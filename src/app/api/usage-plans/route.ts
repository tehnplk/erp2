import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { usage_plan_query_schema, create_usage_plan_schema } from '@/lib/validation/schemas';

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
      product_code,
      requesting_dept_code,
      plan_flag,
      budget_year,
      category,
      type,
      has_purchase_plan,
      order_by,
      sort_order,
      page: validatedPage,
      page_size: validatedPageSize,
    } = queryValidation.data as any;

    const orderField = order_by || 'id';
    const orderDirection = sort_order || 'desc';
    const allowedOrderFields: Record<string, string> = {
      id: 'up.id',
      product_code: 'up.product_code',
      requesting_dept_code: 'up.requesting_dept_code',
      requested_amount: 'up.requested_amount',
      approved_quota: 'up.approved_quota',
      plan_flag: 'up.plan_flag',
      budget_year: 'up.budget_year',
      sequence_no: 'up.sequence_no',
      created_at: 'up.created_at',
      updated_at: 'up.updated_at',
    };
    const safeOrderField = allowedOrderFields[orderField] || 'up.id';

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (product_code) {
      params.push(`%${product_code}%`);
      whereClauses.push(`(p.name ILIKE $${params.length} OR up.product_code ILIKE $${params.length})`);
    }

    if (requesting_dept_code) {
      params.push(requesting_dept_code);
      whereClauses.push(`up.requesting_dept_code = $${params.length}`);
    }

    if (budget_year) {
      params.push(parseInt(budget_year, 10));
      whereClauses.push(`up.budget_year = $${params.length}`);
    }

    if (plan_flag) {
      params.push(plan_flag);
      whereClauses.push(`COALESCE(up.plan_flag, 'ในแผน') = $${params.length}`);
    }

    if (category) {
      params.push(`%${category}%`);
      whereClauses.push(`p.category ILIKE $${params.length}`);
    }

    if (type) {
      params.push(`%${type}%`);
      whereClauses.push(`p.type ILIKE $${params.length}`);
    }

    if (has_purchase_plan === 'true') {
      whereClauses.push('up.purchase_plan_id IS NOT NULL');
    }

    if (has_purchase_plan === 'false') {
      whereClauses.push('up.purchase_plan_id IS NULL');
    }

    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

    const hasPagination = validatedPage !== undefined || validatedPageSize !== undefined;

    const usagePlanFromSql = `
      FROM public.usage_plan up
      LEFT JOIN public.product p ON p.code = up.product_code
      LEFT JOIN public.department d ON d.department_code = up.requesting_dept_code
      ${whereSql}
    `;

    const usagePlanSelect = `
      SELECT
        up.id,
        up.product_code,
        p.name AS product_name,
        p.category,
        p.type,
        p.subtype,
        up.requested_amount,
        p.unit,
        COALESCE(p.cost_price, 0)::float8 AS price_per_unit,
        up.requesting_dept_code,
        COALESCE(d.name, up.requesting_dept_code) AS requesting_dept,
        COALESCE(up.plan_flag, 'ในแผน') AS plan_flag,
        up.approved_quota,
        up.budget_year,
        up.sequence_no,
        up.created_at,
        up.updated_at,
        (up.purchase_plan_id IS NOT NULL) AS has_purchase_plan,
        EXISTS (
          SELECT 1
          FROM public.purchase_approval_detail pad
          WHERE pad.purchase_plan_id = up.purchase_plan_id
        ) AS has_purchase_approval
      ${usagePlanFromSql}
    `;

    const summarySql = `
      SELECT
        COUNT(*)::int AS count,
        COALESCE(SUM(COALESCE(up.requested_amount, 0) * COALESCE(p.cost_price, 0)), 0)::float8 AS total_requested_value,
        COALESCE(SUM(COALESCE(up.approved_quota, 0) * COALESCE(p.cost_price, 0)), 0)::float8 AS total_approved_value
      ${usagePlanFromSql}
    `;

    if (!hasPagination) {
      const [usagePlansResult, totalCountResult] = await Promise.all([
        pgQuery(`${usagePlanSelect} ORDER BY ${safeOrderField} ${orderDirection}`, params),
        pgQuery(`SELECT COUNT(*)::int AS count ${usagePlanFromSql}`, params),
      ]);

      const result = {
        usage_plans: usagePlansResult.rows,
        totalCount: totalCountResult.rows[0]?.count || 0,
      };

      return NextResponse.json(result);
    }

    const page = validatedPage ?? 1;
    const pageSize = validatedPageSize ?? 20;
    const offset = (page - 1) * pageSize;

    const paginatedParams = [...params, pageSize, offset];

    const [usagePlansResult, totalCountResult, summaryResult] = await Promise.all([
      pgQuery(
        `${usagePlanSelect} ORDER BY ${safeOrderField} ${orderDirection} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`,
        paginatedParams
      ),
      pgQuery(`SELECT COUNT(*)::int AS count ${usagePlanFromSql}`, params),
      pgQuery(summarySql, params),
    ]);
    const summaryRow = summaryResult.rows[0];

    const paginatedResult = {
      usage_plans: usagePlansResult.rows,
      totalCount: totalCountResult.rows[0]?.count || 0,
      total_requested_value: summaryRow?.total_requested_value ?? 0,
      total_approved_value: summaryRow?.total_approved_value ?? 0,
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

    const usagePlanData = validation.data as {
      product_code?: string | null;
      requested_amount?: number | null;
      requesting_dept_code?: string | null;
      plan_flag?: 'ในแผน' | 'นอกแผน';
      approved_quota?: number | null;
      budget_year?: number | null;
      sequence_no?: number | null;
    };

    if (usagePlanData.budget_year === null || usagePlanData.budget_year === undefined) {
      usagePlanData.budget_year = 2569;
    }

    if (usagePlanData.budget_year !== null && usagePlanData.budget_year !== undefined && usagePlanData.sequence_no !== null && usagePlanData.sequence_no !== undefined) {
      const existing = await pgQuery(
        `SELECT id FROM public.usage_plan WHERE budget_year = $1 AND requesting_dept_code IS NOT DISTINCT FROM $2 AND product_code IS NOT DISTINCT FROM $3 AND sequence_no = $4 LIMIT 1`,
        [usagePlanData.budget_year, usagePlanData.requesting_dept_code || null, usagePlanData.product_code || null, usagePlanData.sequence_no]
      );

      if (existing.rows.length > 0) {
        return buildUsagePlanConstraintError();
      }
    }

    if (usagePlanData.budget_year !== null && usagePlanData.budget_year !== undefined) {
      const existingCountResult = await pgQuery(
        `SELECT COUNT(*)::int AS count FROM public.usage_plan WHERE budget_year = $1 AND requesting_dept_code IS NOT DISTINCT FROM $2 AND product_code IS NOT DISTINCT FROM $3`,
        [usagePlanData.budget_year, usagePlanData.requesting_dept_code || null, usagePlanData.product_code || null]
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

    const usagePlan = await pgQuery(
      `INSERT INTO public.usage_plan (product_code, requested_amount, requesting_dept_code, plan_flag, approved_quota, budget_year, sequence_no)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING id, product_code, requested_amount, requesting_dept_code, plan_flag, approved_quota, budget_year, sequence_no, created_at, updated_at`,
      [
        usagePlanData.product_code || null,
        usagePlanData.requested_amount ?? null,
        usagePlanData.requesting_dept_code || null,
        usagePlanData.plan_flag || 'ในแผน',
        usagePlanData.approved_quota ?? null,
        usagePlanData.budget_year ?? null,
        usagePlanData.sequence_no ?? null,
      ]
    );

    const createdUsagePlanResult = await pgQuery(
      `SELECT
        up.id,
        up.product_code,
        p.name AS product_name,
        p.category,
        c.type,
        c.subtype,
        up.requested_amount,
        p.unit,
        COALESCE(p.cost_price, 0)::float8 AS price_per_unit,
        up.requesting_dept_code,
        COALESCE(d.name, up.requesting_dept_code) AS requesting_dept,
        COALESCE(up.plan_flag, 'ในแผน') AS plan_flag,
        up.approved_quota,
        up.budget_year,
        up.sequence_no,
        up.created_at,
        up.updated_at,
        false AS has_purchase_plan,
        false AS has_purchase_approval
      FROM public.usage_plan up
      LEFT JOIN public.product p ON p.code = up.product_code
      LEFT JOIN public.department d ON d.department_code = up.requesting_dept_code
      LEFT JOIN LATERAL (
        SELECT c.type, c.subtype
        FROM public.category c
        WHERE c.category = p.category
          AND c.is_active = true
        ORDER BY c.category_code ASC
        LIMIT 1
      ) c ON true
      WHERE up.id = $1
      LIMIT 1`,
      [usagePlan.rows[0].id]
    );
    
    await cacheDelByPattern('erp:usage_plans:list:*');
    
    return NextResponse.json(createdUsagePlanResult.rows[0] || usagePlan.rows[0], { status: 201 });
  } catch (error) {
    console.error('Error creating usage plan:', error);
    return NextResponse.json(
      { error: 'Failed to create usage plan' },
      { status: 500 }
    );
  }
}
