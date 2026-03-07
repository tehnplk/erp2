import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { surveyQuerySchema, createSurveySchema } from '@/lib/validation/schemas';

const buildSurveyConstraintError = () =>
  NextResponse.json(
    { error: 'สินค้าเดิม หน่วยงานเดิม และปีงบเดิม สามารถมีได้ไม่เกิน 2 ครั้ง' },
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
      productName,
      category,
      type,
      requestingDept,
      budgetYear,
      orderBy,
      sortOrder,
      page: validatedPage,
      pageSize: validatedPageSize,
    } = queryValidation.data as any;

    const orderField = orderBy || 'id';
    const orderDirection = sortOrder || 'desc';
    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      productCode: '"productCode"',
      productName: '"productName"',
      category: 'category',
      type: 'type',
      subtype: 'subtype',
      requestingDept: '"requestingDept"',
      budgetYear: 'budget_year',
      sequenceNo: 'sequence_no',
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    };
    const safeOrderField = allowedOrderFields[orderField] || 'id';

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (productName) {
      params.push(`%${productName}%`);
      whereClauses.push(`"productName" ILIKE $${params.length}`);
    }

    if (category) {
      params.push(category);
      whereClauses.push(`category = $${params.length}`);
    }

    if (type) {
      params.push(type);
      whereClauses.push(`type = $${params.length}`);
    }

    if (requestingDept) {
      params.push(requestingDept);
      whereClauses.push(`"requestingDept" = $${params.length}`);
    }

    if (budgetYear) {
      params.push(parseInt(budgetYear, 10));
      whereClauses.push(`budget_year = $${params.length}`);
    }

    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

    // --- Redis Caching Logic (Non-paginated) ---
    const cacheKey = `erp:surveys:list:${JSON.stringify({ productName, category, type, requestingDept, budgetYear, orderBy, sortOrder })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return NextResponse.json(cached);
    }

    const hasPagination = validatedPage !== undefined || validatedPageSize !== undefined;

    if (!hasPagination) {
      const [surveysResult, totalCountResult] = await Promise.all([
        pgQuery(
          `SELECT id, "productCode", category, type, subtype, "productName", "requestedAmount", unit, "pricePerUnit"::float8 AS "pricePerUnit", "requestingDept", "approvedQuota", budget_year AS "budgetYear", sequence_no AS "sequenceNo", created_at AS "createdAt", updated_at AS "updatedAt" FROM public."UsagePlan" ${whereSql} ORDER BY ${safeOrderField} ${orderDirection}`,
          params
        ),
        pgQuery(`SELECT COUNT(*)::int AS count FROM public."UsagePlan" ${whereSql}`, params),
      ]);

      const result = {
        surveys: surveysResult.rows,
        totalCount: totalCountResult.rows[0]?.count || 0,
      };

      // Save to Cache
      await cacheSet(cacheKey, result, 600);

      return NextResponse.json(result);
    }

    const page = validatedPage ?? 1;
    const pageSize = validatedPageSize ?? 20;
    const offset = (page - 1) * pageSize;

    // --- Redis Caching Logic (Paginated) ---
    const paginatedCacheKey = `erp:surveys:list:${JSON.stringify({ ...queryValidation.data, page, pageSize })}`;
    const cachedPaginated = await cacheGet<any>(paginatedCacheKey);
    if (cachedPaginated) {
      return NextResponse.json(cachedPaginated);
    }

    const paginatedParams = [...params, pageSize, offset];

    const [surveysResult, totalCountResult] = await Promise.all([
      pgQuery(
        `SELECT id, "productCode", category, type, subtype, "productName", "requestedAmount", unit, "pricePerUnit"::float8 AS "pricePerUnit", "requestingDept", "approvedQuota", budget_year AS "budgetYear", sequence_no AS "sequenceNo", created_at AS "createdAt", updated_at AS "updatedAt" FROM public."UsagePlan" ${whereSql} ORDER BY ${safeOrderField} ${orderDirection} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`,
        paginatedParams
      ),
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."UsagePlan" ${whereSql}`, params),
    ]);

    const paginatedResult = {
      surveys: surveysResult.rows,
      totalCount: totalCountResult.rows[0]?.count || 0,
      page,
      pageSize,
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

    if (surveyData.budgetYear === null || surveyData.budgetYear === undefined) {
      surveyData.budgetYear = 2569;
    }

    if (surveyData.budgetYear !== null && surveyData.budgetYear !== undefined && surveyData.sequenceNo !== null && surveyData.sequenceNo !== undefined) {
      const existing = await pgQuery(
        `SELECT id FROM public."UsagePlan" WHERE budget_year = $1 AND "requestingDept" IS NOT DISTINCT FROM $2 AND "productCode" IS NOT DISTINCT FROM $3 AND sequence_no = $4 LIMIT 1`,
        [surveyData.budgetYear, surveyData.requestingDept || null, surveyData.productCode || null, surveyData.sequenceNo]
      );

      if (existing.rows.length > 0) {
        return buildSurveyConstraintError();
      }
    }

    if (surveyData.budgetYear !== null && surveyData.budgetYear !== undefined) {
      const existingCountResult = await pgQuery(
        `SELECT COUNT(*)::int AS count FROM public."UsagePlan" WHERE budget_year = $1 AND "requestingDept" IS NOT DISTINCT FROM $2 AND "productCode" IS NOT DISTINCT FROM $3`,
        [surveyData.budgetYear, surveyData.requestingDept || null, surveyData.productCode || null]
      );
      const existingCount = existingCountResult.rows[0]?.count || 0;

      if (existingCount >= 2) {
        return buildSurveyConstraintError();
      }

      if (surveyData.sequenceNo === null || surveyData.sequenceNo === undefined) {
        surveyData.sequenceNo = existingCount + 1;
      }
    }

    if (surveyData.sequenceNo === null || surveyData.sequenceNo === undefined) {
      surveyData.sequenceNo = 1;
    }

    const survey = await pgQuery(
      `INSERT INTO public."UsagePlan" ("productCode", category, type, subtype, "productName", "requestedAmount", unit, "pricePerUnit", "requestingDept", "approvedQuota", budget_year, sequence_no)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
       RETURNING id, "productCode", category, type, subtype, "productName", "requestedAmount", unit, "pricePerUnit"::float8 AS "pricePerUnit", "requestingDept", "approvedQuota", budget_year AS "budgetYear", sequence_no AS "sequenceNo", created_at AS "createdAt", updated_at AS "updatedAt"`,
      [
        surveyData.productCode || null,
        surveyData.category || null,
        surveyData.type || null,
        surveyData.subtype || null,
        surveyData.productName || null,
        surveyData.requestedAmount ?? null,
        surveyData.unit || null,
        surveyData.pricePerUnit ?? 0,
        surveyData.requestingDept || null,
        surveyData.approvedQuota ?? null,
        surveyData.budgetYear ?? null,
        surveyData.sequenceNo ?? null,
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
