import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { purchasePlanQuerySchema, createPurchasePlanSchema } from '@/lib/validation/schemas';

type PurchasePlanPayload = {
  productCode?: string | null;
  category?: string | null;
  productName?: string | null;
  productType?: string | null;
  productSubtype?: string | null;
  unit?: string | null;
  pricePerUnit?: number | null;
  budgetYear?: string | null;
  planId?: number | null;
  inPlan?: string | null;
  carriedForwardQuantity?: number | null;
  carriedForwardValue?: number | null;
  requiredQuantityForYear?: number | null;
  totalRequiredValue?: number | null;
  additionalPurchaseQty?: number | null;
  additionalPurchaseValue?: number | null;
  purchasingDepartment?: string | null;
};

const purchasePlanSelect = `SELECT id, "productCode", category, "productName", "productType", "productSubtype", unit, "pricePerUnit"::float8 AS "pricePerUnit", "budgetYear", "planId", "inPlan", "carriedForwardQuantity", "carriedForwardValue"::float8 AS "carriedForwardValue", "requiredQuantityForYear", "totalRequiredValue"::float8 AS "totalRequiredValue", "additionalPurchaseQty", "additionalPurchaseValue"::float8 AS "additionalPurchaseValue", "purchasingDepartment" FROM public."PurchasePlan"`;

async function buildPurchasePlanPayload(input: PurchasePlanPayload, mode: 'create' | 'update') {
  const planId = input.planId ?? null;

  if (planId === null) {
    return { error: apiError('กรุณาเลือกแผนการใช้ก่อนบันทึก', 400) };
  }

  const surveyResult = await pgQuery(
    `SELECT id, "productCode", category, type, subtype, "productName", "requestedAmount", unit, "pricePerUnit"::float8 AS "pricePerUnit", "requestingDept", "approvedQuota", budget_year AS "budgetYear", sequence_no AS "sequenceNo"
     FROM public."Survey"
     WHERE id = $1
     LIMIT 1`,
    [planId]
  );

  const survey = surveyResult.rows[0];
  if (!survey) {
    return { error: apiError('ไม่พบข้อมูลแผนการใช้ที่เลือก', 400) };
  }

  const inPlan = input.inPlan?.trim();
  if (!inPlan || !['ในแผน', 'นอกแผน'].includes(inPlan)) {
    return { error: apiError('รายการในแผน/นอกแผน ต้องเป็น "ในแผน" หรือ "นอกแผน"', 400) };
  }

  const carriedForwardQuantity = input.carriedForwardQuantity ?? 0;
  if (carriedForwardQuantity < 0) {
    return { error: apiError('จำนวนยกยอดมาต้องไม่น้อยกว่า 0', 400) };
  }

  const pricePerUnit = Number(survey.pricePerUnit) || 0;
  const approvedQuota = survey.approvedQuota ?? 0;
  const requestedAmount = survey.requestedAmount ?? 0;
  const productResult = survey.productCode
    ? await pgQuery(
        `SELECT "costPrice"::float8 AS "costPrice"
         FROM public."Product"
         WHERE code = $1
         LIMIT 1`,
        [survey.productCode]
      )
    : { rows: [] };
  const product = productResult.rows[0];
  const productCostPrice = Number(product?.costPrice) || 0;
  const carriedForwardValue = Number((carriedForwardQuantity * productCostPrice).toFixed(2));
  const totalRequiredValue = Number((approvedQuota * pricePerUnit).toFixed(2));
  const additionalPurchaseQtyRaw = requestedAmount - carriedForwardQuantity;
  const additionalPurchaseQty = additionalPurchaseQtyRaw > 0 ? additionalPurchaseQtyRaw : 0;
  const additionalPurchaseValue = Number((additionalPurchaseQty * pricePerUnit).toFixed(2));

  const payload = {
    productCode: survey.productCode || null,
    category: survey.category || null,
    productName: survey.productName || null,
    productType: survey.type || null,
    productSubtype: survey.subtype || null,
    unit: survey.unit || null,
    pricePerUnit,
    budgetYear: survey.budgetYear !== null && survey.budgetYear !== undefined ? String(survey.budgetYear) : null,
    planId: survey.id,
    inPlan,
    carriedForwardQuantity,
    carriedForwardValue,
    requiredQuantityForYear: requestedAmount,
    totalRequiredValue,
    additionalPurchaseQty,
    additionalPurchaseValue,
    purchasingDepartment: survey.requestingDept || null,
  };

  if (mode === 'create') {
    const duplicateResult = await pgQuery(
      `SELECT id FROM public."PurchasePlan" WHERE "planId" = $1 LIMIT 1`,
      [survey.id]
    );

    if (duplicateResult.rows.length > 0) {
      return { error: apiError('แผนการใช้นี้ถูกนำมาสร้างแผนจัดซื้อแล้ว', 400) };
    }
  }

  return { payload };
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    
    // Validate query parameters
    const queryValidation = validateQuery(purchasePlanQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }
    
    const {
      orderBy,
      sortOrder,
      productName,
      category,
      type,
      productType,
      productSubtype,
      requestingDept,
      purchasingDepartment,
      budgetYear,
      page,
      pageSize
    } = queryValidation.data as any;

    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      productCode: '"productCode"',
      productName: '"productName"',
      category: 'category',
      productType: '"productType"',
      productSubtype: '"productSubtype"',
      unit: 'unit',
      pricePerUnit: '"pricePerUnit"',
      requiredQuantityForYear: '"requiredQuantityForYear"',
      totalRequiredValue: '"totalRequiredValue"',
      budgetYear: '"budgetYear"',
      purchasingDepartment: '"purchasingDepartment"'
    };
    const safeOrderField = allowedOrderFields[orderBy || 'id'] || 'id';
    const safeSortOrder = sortOrder === 'asc' ? 'ASC' : 'DESC';

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
    const resolvedProductType = type || productType;
    if (resolvedProductType) {
      params.push(resolvedProductType);
      whereClauses.push(`"productType" = $${params.length}`);
    }
    if (productSubtype) {
      params.push(productSubtype);
      whereClauses.push(`"productSubtype" = $${params.length}`);
    }
    const resolvedPurchasingDepartment = requestingDept || purchasingDepartment;
    if (resolvedPurchasingDepartment) {
      params.push(resolvedPurchasingDepartment);
      whereClauses.push(`"purchasingDepartment" = $${params.length}`);
    }
    if (budgetYear) {
      params.push(budgetYear);
      whereClauses.push(`"budgetYear" = $${params.length}`);
    }

    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const baseSelect = `SELECT id, "productCode", category, "productName", "productType", "productSubtype", unit, "pricePerUnit"::float8 AS "pricePerUnit", "budgetYear", "planId", "inPlan", "carriedForwardQuantity", "carriedForwardValue"::float8 AS "carriedForwardValue", "requiredQuantityForYear", "totalRequiredValue"::float8 AS "totalRequiredValue", "additionalPurchaseQty", "additionalPurchaseValue"::float8 AS "additionalPurchaseValue", "purchasingDepartment" FROM public."PurchasePlan"`;

    // Determine whether pagination params were explicitly provided
    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('pageSize');

    // Non-paginated mode: no page/pageSize in query -> return all matching items (for summaries)
    if (!pageParam && !pageSizeParam) {
      const [totalCount, items] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count FROM public."PurchasePlan" ${whereSql}`, params),
        pgQuery(`${baseSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params)
      ]);

      return apiSuccess(items.rows, undefined, totalCount.rows[0]?.count || 0, 200);
    }

    // Paginated mode (used by main listing)
    const currentPage = page && typeof page === 'number' ? page : 1;
    const currentPageSize = pageSize && typeof pageSize === 'number' ? pageSize : 20;
    const skip = (currentPage - 1) * currentPageSize;
    const paginatedParams = [...params, currentPageSize, skip];

    // Get total count and paginated items in parallel
    const [totalCount, items] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."PurchasePlan" ${whereSql}`, params),
      pgQuery(`${baseSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, paginatedParams)
    ]);

    return apiSuccess(items.rows, undefined, totalCount.rows[0]?.count || 0, 200, { page: currentPage, pageSize: currentPageSize });
  } catch (error) {
    console.error('Error fetching purchase plans:', error);
    return apiError('Failed to fetch purchase plans');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createPurchasePlanSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const purchasePlanData = validation.data as PurchasePlanPayload;
    const resolved = await buildPurchasePlanPayload(purchasePlanData, 'create');
    if ('error' in resolved) {
      return resolved.error;
    }

    const payload = resolved.payload;
    const item = await pgQuery(
      `INSERT INTO public."PurchasePlan" ("productCode", category, "productName", "productType", "productSubtype", unit, "pricePerUnit", "budgetYear", "planId", "inPlan", "carriedForwardQuantity", "carriedForwardValue", "requiredQuantityForYear", "totalRequiredValue", "additionalPurchaseQty", "additionalPurchaseValue", "purchasingDepartment")
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
       RETURNING id, "productCode", category, "productName", "productType", "productSubtype", unit, "pricePerUnit"::float8 AS "pricePerUnit", "budgetYear", "planId", "inPlan", "carriedForwardQuantity", "carriedForwardValue"::float8 AS "carriedForwardValue", "requiredQuantityForYear", "totalRequiredValue"::float8 AS "totalRequiredValue", "additionalPurchaseQty", "additionalPurchaseValue"::float8 AS "additionalPurchaseValue", "purchasingDepartment"`,
      [
        payload.productCode,
        payload.category,
        payload.productName,
        payload.productType,
        payload.productSubtype,
        payload.unit,
        payload.pricePerUnit,
        payload.budgetYear,
        payload.planId,
        payload.inPlan,
        payload.carriedForwardQuantity,
        payload.carriedForwardValue,
        payload.requiredQuantityForYear,
        payload.totalRequiredValue,
        payload.additionalPurchaseQty,
        payload.additionalPurchaseValue,
        payload.purchasingDepartment,
      ]
    );
    
    return apiSuccess(item.rows[0], 'Purchase plan created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating purchase plan:', error);
    return apiError('Failed to create purchase plan');
  }
}
