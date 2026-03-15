import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { usage_plan_query_schema, create_usage_plan_schema } from '@/lib/validation/schemas';
import { findDepartmentCodeByName } from '@/lib/department-code';

const buildUsagePlanConstraintError = () =>
  NextResponse.json(
    { error: 'ในปีงบประมาณนี้ แผนกนี้ ขอใช้สินค้านี้ ครบ 2 ครั้งแล้ว' },
    { status: 400 }
  );

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(usage_plan_query_schema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      product_name,
      category,
      type,
      subtype,
      requesting_dept,
      budget_year,
      has_purchase_plan,
      order_by,
      sort_order,
      page: validatedPage,
      page_size: validatedPageSize,
    } = queryValidation.data as any;

    const orderField = order_by || 'id';
    const orderDirection = sort_order || 'desc';
    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      product_code: 'product_code',
      product_name: 'product_name',
      category: 'category',
      type: 'type',
      subtype: 'subtype',
      requesting_dept: 'requesting_dept',
      budget_year: 'budget_year',
      sequence_no: 'sequence_no',
      created_at: 'created_at',
      updated_at: 'updated_at',
    };
    const safeOrderField = allowedOrderFields[orderField] || 'id';

    const matches_exact_filter = (row: Record<string, any>) => {
      if (category && row.category !== category) return false;
      if (type && row.type !== type) return false;
      if (subtype && row.subtype !== subtype) return false;
      if (requesting_dept && row.requesting_dept !== requesting_dept) return false;
      if (budget_year && Number(row.budget_year) !== parseInt(budget_year, 10)) return false;
      if (has_purchase_plan === 'true' && !row.has_purchase_plan) return false;
      if (has_purchase_plan === 'false' && row.has_purchase_plan) return false;
      return true;
    };

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (product_name) {
      params.push(`%${product_name}%`);
      whereClauses.push(`(product_name ILIKE $${params.length} OR product_code ILIKE $${params.length})`);
    }

    if (category) {
      params.push(category);
      whereClauses.push(`category = $${params.length}`);
    }

    if (type) {
      params.push(type);
      whereClauses.push(`type = $${params.length}`);
    }

    if (subtype) {
      params.push(subtype);
      whereClauses.push(`subtype = $${params.length}`);
    }

    if (requesting_dept) {
      params.push(requesting_dept);
      whereClauses.push(`requesting_dept = $${params.length}`);
    }

    if (budget_year) {
      params.push(parseInt(budget_year, 10));
      whereClauses.push(`budget_year = $${params.length}`);
    }

    if (has_purchase_plan === 'true') {
      whereClauses.push('EXISTS (SELECT 1 FROM public.purchase_plan pp WHERE pp.usage_plan_id = up.id)');
    }

    if (has_purchase_plan === 'false') {
      whereClauses.push('NOT EXISTS (SELECT 1 FROM public.purchase_plan pp WHERE pp.usage_plan_id = up.id)');
    }

    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

    const hasPagination = validatedPage !== undefined || validatedPageSize !== undefined;

    if (!hasPagination) {
      const [usagePlansResult, totalCountResult] = await Promise.all([
        pgQuery(
          `SELECT 
            up.id, up.product_code, up.category, up.type, up.subtype, up.product_name, 
            up.requested_amount, up.unit, up.price_per_unit::float8 AS price_per_unit, 
            up.requesting_dept, up.requesting_dept_code, up.approved_quota, 
            up.budget_year, up.sequence_no, up.created_at, up.updated_at,
            CASE WHEN pp.id IS NOT NULL THEN true ELSE false END as has_purchase_plan,
            CASE WHEN EXISTS (SELECT 1 FROM public.purchase_approval_detail pad WHERE pad.purchase_plan_id = pp.id) THEN true ELSE false END as has_purchase_approval
           FROM public.usage_plan up
           LEFT JOIN public.purchase_plan pp ON up.id = pp.usage_plan_id
           ${whereSql} ORDER BY ${safeOrderField} ${orderDirection}`,
          params
        ),
        pgQuery(`SELECT COUNT(*)::int AS count FROM public.usage_plan up ${whereSql}`, params)
      ]);

      const filteredUsagePlans = usagePlansResult.rows.filter(matches_exact_filter);

      const result = {
        usage_plans: filteredUsagePlans,
        totalCount: subtype ? filteredUsagePlans.length : totalCountResult.rows[0]?.count || 0,
      };

      return NextResponse.json(result);
    }

    const page = validatedPage ?? 1;
    const pageSize = validatedPageSize ?? 20;
    const offset = (page - 1) * pageSize;

    const paginatedParams = [...params, pageSize, offset];

    const [usagePlansResult, totalCountResult, summaryResult, filteredSummaryResult] = await Promise.all([
      pgQuery(
        `SELECT 
          up.id, up.product_code, up.category, up.type, up.subtype, up.product_name, 
          up.requested_amount, up.unit, up.price_per_unit::float8 AS price_per_unit, 
          up.requesting_dept, up.requesting_dept_code, up.approved_quota, 
          up.budget_year, up.sequence_no, up.created_at, up.updated_at,
          CASE WHEN pp.id IS NOT NULL THEN true ELSE false END as has_purchase_plan,
          CASE WHEN EXISTS (SELECT 1 FROM public.purchase_approval_detail pad WHERE pad.purchase_plan_id = pp.id) THEN true ELSE false END as has_purchase_approval
         FROM public.usage_plan up
         LEFT JOIN public.purchase_plan pp ON up.id = pp.usage_plan_id
         ${whereSql} ORDER BY ${safeOrderField} ${orderDirection} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`,
        paginatedParams
      ),
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.usage_plan up ${whereSql}`, params),
      pgQuery(
        `SELECT COALESCE(SUM(COALESCE(up.requested_amount,0) * COALESCE(up.price_per_unit,0)),0)::float8 AS total_requested_value, COALESCE(SUM(COALESCE(up.approved_quota,0) * COALESCE(up.price_per_unit,0)),0)::float8 AS total_approved_value FROM public.usage_plan up ${whereSql}`,
        params
      ),
      pgQuery(
        `SELECT COUNT(*)::int AS count, COALESCE(SUM(COALESCE(up.requested_amount,0) * COALESCE(up.price_per_unit,0)),0)::float8 AS total_requested_value, COALESCE(SUM(COALESCE(up.approved_quota,0) * COALESCE(up.price_per_unit,0)),0)::float8 AS total_approved_value FROM public.usage_plan up ${whereSql}`,
        params
      ),
    ]);

    const filteredUsagePlans = usagePlansResult.rows.filter(matches_exact_filter);
    const filteredSummaryRow = filteredSummaryResult.rows[0];

    const paginatedResult = {
      usage_plans: filteredUsagePlans,
      totalCount: filteredSummaryRow?.count || totalCountResult.rows[0]?.count || 0,
      total_requested_value: filteredSummaryRow?.total_requested_value ?? summaryResult.rows[0]?.total_requested_value ?? 0,
      total_approved_value: filteredSummaryRow?.total_approved_value ?? summaryResult.rows[0]?.total_approved_value ?? 0,
      page,
      page_size: pageSize,
    };

    return NextResponse.json(paginatedResult);
  } catch (error) {
    console.error('Error fetching usage plans:', error);
    return NextResponse.json(
      { error: 'Failed to fetch usage plans' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const validation = await validateRequest(create_usage_plan_schema, body);
    if (!validation.success) {
      return validation.error;
    }

    const usagePlanData = validation.data as any;

    if (usagePlanData.budget_year === null || usagePlanData.budget_year === undefined) {
      usagePlanData.budget_year = 2569;
    }

    if (usagePlanData.budget_year !== null && usagePlanData.budget_year !== undefined && usagePlanData.sequence_no !== null && usagePlanData.sequence_no !== undefined) {
      const existing = await pgQuery(
        `SELECT id FROM public.usage_plan WHERE budget_year = $1 AND requesting_dept IS NOT DISTINCT FROM $2 AND product_code IS NOT DISTINCT FROM $3 AND sequence_no = $4 LIMIT 1`,
        [usagePlanData.budget_year, usagePlanData.requesting_dept || null, usagePlanData.product_code || null, usagePlanData.sequence_no]
      );

      if (existing.rows.length > 0) {
        return buildUsagePlanConstraintError();
      }
    }

    if (usagePlanData.budget_year !== null && usagePlanData.budget_year !== undefined) {
      const existingCountResult = await pgQuery(
        `SELECT COUNT(*)::int AS count FROM public.usage_plan WHERE budget_year = $1 AND requesting_dept IS NOT DISTINCT FROM $2 AND product_code IS NOT DISTINCT FROM $3`,
        [usagePlanData.budget_year, usagePlanData.requesting_dept || null, usagePlanData.product_code || null]
      );
      const existingCount = existingCountResult.rows[0]?.count || 0;

      if (existingCount >= 2) {
        return buildUsagePlanConstraintError();
      }

      if (usagePlanData.sequence_no === null || usagePlanData.sequence_no === undefined) {
        usagePlanData.sequence_no = existingCount + 1;
      }
    }

    if (usagePlanData.sequence_no === null || usagePlanData.sequence_no === undefined) {
      usagePlanData.sequence_no = 1;
    }

    const requestingDept = usagePlanData.requesting_dept || null;
    const requestingDeptCode = await findDepartmentCodeByName(requestingDept);

    const usagePlan = await pgQuery(
      `INSERT INTO public.usage_plan (product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit, requesting_dept, requesting_dept_code, approved_quota, budget_year, sequence_no)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
       RETURNING id, product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit::float8 AS price_per_unit, requesting_dept, requesting_dept_code, approved_quota, budget_year, sequence_no, created_at, updated_at`,
      [
        usagePlanData.product_code || null,
        usagePlanData.category || null,
        usagePlanData.type || null,
        usagePlanData.subtype || null,
        usagePlanData.product_name || null,
        usagePlanData.requested_amount ?? null,
        usagePlanData.unit || null,
        usagePlanData.price_per_unit ?? 0,
        requestingDept,
        requestingDeptCode,
        usagePlanData.approved_quota ?? null,
        usagePlanData.budget_year ?? null,
        usagePlanData.sequence_no ?? null,
      ]
    );
    
    await cacheDelByPattern('erp:usage_plans:list:*');
    
    return NextResponse.json(usagePlan.rows[0], { status: 201 });
  } catch (error) {
    console.error('Error creating usage plan:', error);
    return NextResponse.json(
      { error: 'Failed to create usage plan' },
      { status: 500 }
    );
  }
}
