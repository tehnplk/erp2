import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { purchasePlanQuerySchema, createPurchasePlanSchema } from '@/lib/validation/schemas';
import { findDepartmentCodeByName } from '@/lib/department-code';

type PurchasePlanPayload = {
  product_code?: string | null;
  category?: string | null;
  product_name?: string | null;
  product_type?: string | null;
  product_subtype?: string | null;
  unit?: string | null;
  price_per_unit?: number | null;
  budget_year?: string | null;
  plan_id?: number | null;
  in_plan?: string | null;
  carried_forward_quantity?: number | null;
  carried_forward_value?: number | null;
  required_quantity_for_year?: number | null;
  total_required_value?: number | null;
  additional_purchase_qty?: number | null;
  additional_purchase_value?: number | null;
  usageplan_dept?: string | null;
  usageplan_dept_code?: string | null;
};

const purchasePlanSelect = `SELECT id, product_code, category, product_name, product_type, product_subtype, unit, price_per_unit::float8 AS price_per_unit, budget_year, plan_id, in_plan, carried_forward_quantity, carried_forward_value::float8 AS carried_forward_value, required_quantity_for_year, total_required_value::float8 AS total_required_value, additional_purchase_qty, additional_purchase_value::float8 AS additional_purchase_value, usageplan_dept, usageplan_dept_code FROM public.purchase_plan`;

async function getInventorySnapshot(productCode: string | null) {
  if (!productCode) {
    return {
      carriedForwardQuantity: 0,
      carriedForwardValue: 0,
    };
  }

  const inventoryResult = await pgQuery(
    `SELECT
       COALESCE(SUM(ib.on_hand_qty), 0)::int AS carried_forward_quantity,
       COALESCE(SUM(ib.on_hand_qty * ib.avg_cost), 0)::float8 AS carried_forward_value
     FROM public.inventory_balance ib
     INNER JOIN public.inventory_item ii ON ii.id = ib.inventory_item_id
     WHERE ii.product_code = $1`,
    [productCode]
  );

  const inventory = inventoryResult.rows[0];

  return {
    carriedForwardQuantity: Number(inventory?.carried_forward_quantity || 0),
    carriedForwardValue: Number(inventory?.carried_forward_value || 0),
  };
}

async function getApprovedQuotaSnapshot(productCode: string | null, budgetYear: number | null, requestingDept: string | null) {
  if (!productCode || budgetYear === null || budgetYear === undefined || !requestingDept) {
    return 0;
  }

  const quotaResult = await pgQuery(
    `SELECT COALESCE(SUM(approved_quota), 0)::int AS approved_quota
     FROM public.usage_plan
     WHERE product_code = $1
       AND budget_year = $2
       AND requesting_dept IS NOT DISTINCT FROM $3`,
    [productCode, budgetYear, requestingDept]
  );

  return Number(quotaResult.rows[0]?.approved_quota || 0);
}

async function buildPurchasePlanPayload(input: PurchasePlanPayload, mode: 'create' | 'update') {
  const planId = input.plan_id ?? null;

  if (planId === null) {
    return { error: apiError('กรุณาเลือกแผนการใช้ก่อนบันทึก', 400) };
  }

  const surveyResult = await pgQuery(
    `SELECT id, product_code, category, type, subtype, product_name, requested_amount, unit, price_per_unit::float8 AS price_per_unit, requesting_dept, requesting_dept_code, approved_quota, budget_year, sequence_no
     FROM public.usage_plan
     WHERE id = $1
     LIMIT 1`,
    [planId]
  );

  const survey = surveyResult.rows[0];
  if (!survey) {
    return { error: apiError('ไม่พบข้อมูลแผนการใช้ที่เลือก', 400) };
  }

  const inPlan = input.in_plan?.trim();
  if (!inPlan || !['ในแผน', 'นอกแผน'].includes(inPlan)) {
    return { error: apiError('รายการในแผน/นอกแผน ต้องเป็น "ในแผน" หรือ "นอกแผน"', 400) };
  }

  const pricePerUnit = Number(survey.price_per_unit) || 0;
  const approvedQuota = await getApprovedQuotaSnapshot(
    survey.product_code || null,
    survey.budget_year ?? null,
    survey.requesting_dept || null
  );
  const { carriedForwardQuantity, carriedForwardValue } = await getInventorySnapshot(survey.product_code || null);
  const totalRequiredValue = Number((approvedQuota * pricePerUnit).toFixed(2));
  const additionalPurchaseQtyRaw = approvedQuota - carriedForwardQuantity;
  const additionalPurchaseQty = additionalPurchaseQtyRaw > 0 ? additionalPurchaseQtyRaw : 0;
  const additionalPurchaseValue = Number((additionalPurchaseQty * pricePerUnit).toFixed(2));

  const payload = {
    product_code: survey.product_code || null,
    category: survey.category || null,
    product_name: survey.product_name || null,
    product_type: survey.type || null,
    product_subtype: survey.subtype || null,
    unit: survey.unit || null,
    price_per_unit: pricePerUnit,
    budget_year: survey.budget_year !== null && survey.budget_year !== undefined ? String(survey.budget_year) : null,
    plan_id: survey.id,
    in_plan: inPlan,
    carried_forward_quantity: carriedForwardQuantity,
    carried_forward_value: carriedForwardValue,
    required_quantity_for_year: approvedQuota,
    total_required_value: totalRequiredValue,
    additional_purchase_qty: additionalPurchaseQty,
    additional_purchase_value: additionalPurchaseValue,
    usageplan_dept: survey.requesting_dept || null,
    usageplan_dept_code: survey.requesting_dept_code || await findDepartmentCodeByName(survey.requesting_dept || null),
  };

  if (mode === 'create') {
    const duplicateResult = await pgQuery(
      `SELECT id FROM public.purchase_plan WHERE plan_id = $1 LIMIT 1`,
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
      order_by,
      sort_order,
      product_name,
      category,
      type,
      product_type,
      product_subtype,
      requesting_dept,
      usageplan_dept,
      budget_year,
      page,
      page_size: pageSize
    } = queryValidation.data as any;

    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      product_code: 'product_code',
      product_name: 'product_name',
      category: 'category',
      product_type: 'product_type',
      product_subtype: 'product_subtype',
      unit: 'unit',
      price_per_unit: 'price_per_unit',
      required_quantity_for_year: 'required_quantity_for_year',
      total_required_value: 'total_required_value',
      budget_year: 'budget_year',
      usageplan_dept: 'usageplan_dept'
    };
    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'id';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (product_name) {
      params.push(`%${product_name}%`);
      whereClauses.push(`product_name ILIKE $${params.length}`);
    }
    if (category) {
      params.push(category);
      whereClauses.push(`category = $${params.length}`);
    }
    const resolvedProductType = type || product_type;
    if (resolvedProductType) {
      params.push(resolvedProductType);
      whereClauses.push(`product_type = $${params.length}`);
    }
    if (product_subtype) {
      params.push(product_subtype);
      whereClauses.push(`product_subtype = $${params.length}`);
    }
    const resolvedPurchasingDepartment = requesting_dept || usageplan_dept;
    if (resolvedPurchasingDepartment) {
      params.push(resolvedPurchasingDepartment);
      whereClauses.push(`usageplan_dept = $${params.length}`);
    }
    if (budget_year) {
      params.push(budget_year);
      whereClauses.push(`budget_year = $${params.length}`);
    }

    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const baseSelect = purchasePlanSelect;

    // Determine whether pagination params were explicitly provided
    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('page_size');

    // Non-paginated mode: no page/pageSize in query -> return all matching items (for summaries)
    const cacheKeyAll = `erp:purchase:plans:list:all:${JSON.stringify(params)}`;
    if (!pageParam && !pageSizeParam) {
      const cachedAll = await cacheGet<any>(cacheKeyAll);
      if (cachedAll) return apiSuccess(cachedAll.items, undefined, cachedAll.totalCount, 200);

      const [totalCount, items] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count FROM public.purchase_plan ${whereSql}`, params),
        pgQuery(`${baseSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params)
      ]);

      const resultAll = {
        items: items.rows,
        totalCount: totalCount.rows[0]?.count || 0
      };

      await cacheSet(cacheKeyAll, resultAll, 3600);

      return apiSuccess(resultAll.items, undefined, resultAll.totalCount, 200);
    }

    // Paginated mode (used by main listing)
    const currentPage = page && typeof page === 'number' ? page : 1;
    const currentPageSize = pageSize && typeof pageSize === 'number' ? pageSize : 20;
    
    const cacheKey = `erp:purchase:plans:list:${JSON.stringify({ ...queryValidation.data, page: currentPage, page_size: currentPageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page: currentPage, page_size: currentPageSize });
    }

    const skip = (currentPage - 1) * currentPageSize;
    const paginatedParams = [...params, currentPageSize, skip];

    // Get total count and paginated items in parallel
    const [totalCount, items] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.purchase_plan ${whereSql}`, params),
      pgQuery(`${baseSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, paginatedParams)
    ]);

    const result = {
      items: items.rows,
      totalCount: totalCount.rows[0]?.count || 0
    };

    await cacheSet(cacheKey, result, 1800);

    return apiSuccess(result.items, undefined, result.totalCount, 200, { page: currentPage, page_size: currentPageSize });
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
      `INSERT INTO public.purchase_plan (product_code, category, product_name, product_type, product_subtype, unit, price_per_unit, budget_year, plan_id, in_plan, carried_forward_quantity, carried_forward_value, required_quantity_for_year, total_required_value, additional_purchase_qty, additional_purchase_value, usageplan_dept, usageplan_dept_code)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18)
       RETURNING id, product_code, category, product_name, product_type, product_subtype, unit, price_per_unit::float8 AS price_per_unit, budget_year, plan_id, in_plan, carried_forward_quantity, carried_forward_value::float8 AS carried_forward_value, required_quantity_for_year, total_required_value::float8 AS total_required_value, additional_purchase_qty, additional_purchase_value::float8 AS additional_purchase_value, usageplan_dept, usageplan_dept_code`,
      [
        payload.product_code,
        payload.category,
        payload.product_name,
        payload.product_type,
        payload.product_subtype,
        payload.unit,
        payload.price_per_unit,
        payload.budget_year,
        payload.plan_id,
        payload.in_plan,
        payload.carried_forward_quantity,
        payload.carried_forward_value,
        payload.required_quantity_for_year,
        payload.total_required_value,
        payload.additional_purchase_qty,
        payload.additional_purchase_value,
        payload.usageplan_dept,
        payload.usageplan_dept_code,
      ]
    );
    
    await cacheDelByPattern('erp:purchase:plans:list:*');

    return apiSuccess(item.rows[0], 'Purchase plan created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating purchase plan:', error);
    return apiError('Failed to create purchase plan');
  }
}
