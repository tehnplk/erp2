import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { surveyQuerySchema, createSurveySchema } from '@/lib/validation/schemas';
import { findDepartmentCodeByName } from '@/lib/department-code';

const buildSurveyConstraintError = () =>
  NextResponse.json(
    { error: 'ในปีงบประมาณนี้ แผนกนี้ ขอใช้สินค้านี้ ครบ 2 ครั้งแล้ว' },
    { status: 400 }
  );

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(surveyQuerySchema, searchParams);
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

    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

    // --- Redis Caching Logic (Non-paginated) ---
    const cacheKey = `erp:surveys:list:${JSON.stringify({ product_name, category, type, subtype, requesting_dept, budget_year, order_by, sort_order })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return NextResponse.json(cached);
    }

    const hasPagination = validatedPage !== undefined || validatedPageSize !== undefined;

    if (!hasPagination) {
      const [surveysResult, totalCountResult] = await Promise.all([
        pgQuery(
          `SELECT 
            up.id, up.product_code, up.category, up.type, up.subtype, up.product_name, 
            up.requested_amount, up.unit, up.price_per_unit::float8 AS price_per_unit, 
            up.requesting_dept, up.requesting_dept_code, up.approved_quota, 
            up.budget_year, up.sequence_no, up.created_at, up.updated_at,
            CASE WHEN pp.id IS NOT NULL THEN true ELSE false END as has_purchase_plan
           FROM public.usage_plan up
           LEFT JOIN public.purchase_plan pp ON up.id = pp.usage_plan_id
           ${whereSql} ORDER BY ${safeOrderField} ${orderDirection}`,
          params
        ),
        pgQuery(`SELECT COUNT(*)::int AS count FROM public.usage_plan ${whereSql}`, params),
      ]);

      const filteredSurveys = surveysResult.rows.filter(matches_exact_filter);

      const result = {
        surveys: filteredSurveys,
        totalCount: subtype ? filteredSurveys.length : totalCountResult.rows[0]?.count || 0,
      };

      // Save to Cache
      await cacheSet(cacheKey, result, 600);

      return NextResponse.json(result);
    }

    const page = validatedPage ?? 1;
    const pageSize = validatedPageSize ?? 20;
    const offset = (page - 1) * pageSize;

    // --- Redis Caching Logic (Paginated) ---
    const paginatedCacheKey = `erp:surveys:list:${JSON.stringify({ ...queryValidation.data, page, page_size: pageSize })}`;
    const cachedPaginated = await cacheGet<any>(paginatedCacheKey);
    if (cachedPaginated) {
      return NextResponse.json(cachedPaginated);
    }

    const paginatedParams = [...params, pageSize, offset];

    const [surveysResult, totalCountResult, summaryResult, filteredSummaryResult] = await Promise.all([
      pgQuery(
        `SELECT 
          up.id, up.product_code, up.category, up.type, up.subtype, up.product_name, 
          up.requested_amount, up.unit, up.price_per_unit::float8 AS price_per_unit, 
          up.requesting_dept, up.requesting_dept_code, up.approved_quota, 
          up.budget_year, up.sequence_no, up.created_at, up.updated_at,
          CASE WHEN pp.id IS NOT NULL THEN true ELSE false END as has_purchase_plan
         FROM public.usage_plan up
         LEFT JOIN public.purchase_plan pp ON up.id = pp.usage_plan_id
         ${whereSql} ORDER BY ${safeOrderField} ${orderDirection} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`,
        paginatedParams
      ),
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.usage_plan ${whereSql}`, params),
      pgQuery(
        `SELECT COALESCE(SUM(COALESCE(requested_amount,0) * COALESCE(price_per_unit,0)),0)::float8 AS total_requested_value, COALESCE(SUM(COALESCE(approved_quota,0) * COALESCE(price_per_unit,0)),0)::float8 AS total_approved_value FROM public.usage_plan ${whereSql}`,
        params
      ),
      pgQuery(
        `SELECT COUNT(*)::int AS count, COALESCE(SUM(COALESCE(requested_amount,0) * COALESCE(price_per_unit,0)),0)::float8 AS total_requested_value, COALESCE(SUM(COALESCE(approved_quota,0) * COALESCE(price_per_unit,0)),0)::float8 AS total_approved_value FROM public.usage_plan ${whereSql}`,
        params
      ),
    ]);

    const filteredSurveys = surveysResult.rows.filter(matches_exact_filter);
    const filteredSummaryRow = filteredSummaryResult.rows[0];

    const paginatedResult = {
      surveys: filteredSurveys,
      totalCount: filteredSummaryRow?.count || totalCountResult.rows[0]?.count || 0,
      total_requested_value: filteredSummaryRow?.total_requested_value ?? summaryResult.rows[0]?.total_requested_value ?? 0,
      total_approved_value: filteredSummaryRow?.total_approved_value ?? summaryResult.rows[0]?.total_approved_value ?? 0,
      page,
      page_size: pageSize,
    };

    // Save to Cache
    await cacheSet(paginatedCacheKey, paginatedResult, 600);
    
    return NextResponse.json(paginatedResult);
  } catch (error) {
    console.error('Error fetching surveys:', error);
    return NextResponse.json(
      { error: 'Failed to fetch surveys' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const validation = await validateRequest(createSurveySchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const surveyData = validation.data as any;

    if (surveyData.budget_year === null || surveyData.budget_year === undefined) {
      surveyData.budget_year = 2569;
    }

    if (surveyData.budget_year !== null && surveyData.budget_year !== undefined && surveyData.sequence_no !== null && surveyData.sequence_no !== undefined) {
      const existing = await pgQuery(
        `SELECT id FROM public.usage_plan WHERE budget_year = $1 AND requesting_dept IS NOT DISTINCT FROM $2 AND product_code IS NOT DISTINCT FROM $3 AND sequence_no = $4 LIMIT 1`,
        [surveyData.budget_year, surveyData.requesting_dept || null, surveyData.product_code || null, surveyData.sequence_no]
      );

      if (existing.rows.length > 0) {
        return buildSurveyConstraintError();
      }
    }

    if (surveyData.budget_year !== null && surveyData.budget_year !== undefined) {
      const existingCountResult = await pgQuery(
        `SELECT COUNT(*)::int AS count FROM public.usage_plan WHERE budget_year = $1 AND requesting_dept IS NOT DISTINCT FROM $2 AND product_code IS NOT DISTINCT FROM $3`,
        [surveyData.budget_year, surveyData.requesting_dept || null, surveyData.product_code || null]
      );
      const existingCount = existingCountResult.rows[0]?.count || 0;

      if (existingCount >= 2) {
        return buildSurveyConstraintError();
      }

      if (surveyData.sequence_no === null || surveyData.sequence_no === undefined) {
        surveyData.sequence_no = existingCount + 1;
      }
    }

    if (surveyData.sequence_no === null || surveyData.sequence_no === undefined) {
      surveyData.sequence_no = 1;
    }

    const requestingDept = surveyData.requesting_dept || null;
    const requestingDeptCode = await findDepartmentCodeByName(requestingDept);

    const survey = await pgQuery(
      `INSERT INTO public.usage_plan (product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit, requesting_dept, requesting_dept_code, approved_quota, budget_year, sequence_no)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
       RETURNING id, product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit::float8 AS price_per_unit, requesting_dept, requesting_dept_code, approved_quota, budget_year, sequence_no, created_at, updated_at`,
      [
        surveyData.product_code || null,
        surveyData.category || null,
        surveyData.type || null,
        surveyData.subtype || null,
        surveyData.product_name || null,
        surveyData.requested_amount ?? null,
        surveyData.unit || null,
        surveyData.price_per_unit ?? 0,
        requestingDept,
        requestingDeptCode,
        surveyData.approved_quota ?? null,
        surveyData.budget_year ?? null,
        surveyData.sequence_no ?? null,
      ]
    );
    
    await cacheDelByPattern('erp:surveys:list:*');
    
    return NextResponse.json(survey.rows[0], { status: 201 });
  } catch (error) {
    console.error('Error creating survey:', error);
    return NextResponse.json(
      { error: 'Failed to create survey' },
      { status: 500 }
    );
  }
}
