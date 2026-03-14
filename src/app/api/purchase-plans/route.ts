import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern, cacheGet, cacheSet } from '@/lib/redis';
import { createPurchasePlanSchema, purchasePlanQuerySchema } from '@/lib/validation/schemas';
import { validateQuery, validateRequest } from '@/lib/validation/validate';

type PurchasePlanPayload = {
  usage_plan_id?: number | null;
  inventory_qty?: number | null;
  inventory_value?: number | null;
  purchase_qty?: number | null;
  purchase_value?: number | null;
};

const purchasePlanBaseSelect = `
  FROM public.purchase_plan pp
  INNER JOIN public.usage_plan up ON up.id = pp.usage_plan_id
  LEFT JOIN public.purchase_approval_detail pad ON pad.purchase_plan_id = pp.id
  LEFT JOIN (
    SELECT
      ii.product_code,
      COALESCE(SUM(ib.on_hand_qty), 0)::int AS inventory_qty,
      COALESCE(SUM(ib.on_hand_qty * ib.avg_cost), 0)::float8 AS inventory_value
    FROM public.inventory_item ii
    INNER JOIN public.inventory_balance ib ON ib.inventory_item_id = ii.id
    GROUP BY ii.product_code
  ) inventory_snapshot ON inventory_snapshot.product_code = up.product_code
`;

const purchasePlanSelect = `
  SELECT
    pp.id,
    pp.usage_plan_id,
    up.sequence_no,
    up.product_code,
    up.product_name,
    up.category,
    up.type AS product_type,
    up.subtype AS product_subtype,
    up.unit,
    up.price_per_unit::float8 AS price_per_unit,
    up.requested_amount,
    up.approved_quota,
    up.budget_year,
    up.requesting_dept,
    CASE WHEN pad.id IS NOT NULL THEN true ELSE false END AS has_purchase_approval,
    COALESCE(inventory_snapshot.inventory_qty, pp.inventory_qty, 0)::int AS inventory_qty,
    COALESCE(inventory_snapshot.inventory_value, pp.inventory_value, 0)::float8 AS inventory_value,
    COALESCE(pp.purchase_qty, GREATEST(COALESCE(up.approved_quota, 0) - COALESCE(inventory_snapshot.inventory_qty, 0), 0))::int AS purchase_qty,
    COALESCE(pp.purchase_value, ROUND(COALESCE(pp.purchase_qty, GREATEST(COALESCE(up.approved_quota, 0) - COALESCE(inventory_snapshot.inventory_qty, 0), 0)) * COALESCE(up.price_per_unit, 0), 2))::float8 AS purchase_value
  ${purchasePlanBaseSelect}
`;

function buildWhereClause(filters: {
  product_name?: string;
  category?: string;
  product_type?: string;
  product_subtype?: string;
  budget_year?: string;
  requesting_dept?: string;
  has_purchase_approval?: 'true' | 'false';
}) {
  const whereClauses: string[] = [];
  const params: unknown[] = [];

  if (filters.product_name) {
    params.push(`%${filters.product_name}%`);
    const searchParamIndex = params.length;
    whereClauses.push(`(up.product_name ILIKE $${searchParamIndex} OR up.product_code ILIKE $${searchParamIndex})`);
  }

  if (filters.category) {
    params.push(filters.category);
    whereClauses.push(`up.category = $${params.length}`);
  }

  if (filters.product_type) {
    params.push(filters.product_type);
    whereClauses.push(`up.type = $${params.length}`);
  }

  if (filters.product_subtype) {
    params.push(filters.product_subtype);
    whereClauses.push(`up.subtype = $${params.length}`);
  }

  if (filters.budget_year) {
    params.push(Number(filters.budget_year));
    whereClauses.push(`up.budget_year = $${params.length}`);
  }

  if (filters.requesting_dept) {
    params.push(filters.requesting_dept);
    whereClauses.push(`up.requesting_dept = $${params.length}`);
  }

  if (filters.has_purchase_approval === 'true') {
    whereClauses.push('EXISTS (SELECT 1 FROM public.purchase_approval_detail pad WHERE pad.purchase_plan_id = pp.id)');
  }

  if (filters.has_purchase_approval === 'false') {
    whereClauses.push('NOT EXISTS (SELECT 1 FROM public.purchase_approval_detail pad WHERE pad.purchase_plan_id = pp.id)');
  }

  return {
    params,
    whereSql: whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '',
  };
}

function normalizePurchasePlanPayload(payload: PurchasePlanPayload) {
  const purchase_qty = Number(payload.purchase_qty ?? 0);
  const purchase_value = Number(payload.purchase_value ?? 0);
  const inventory_qty = Number(payload.inventory_qty ?? 0);
  const inventory_value = Number(payload.inventory_value ?? 0);

  return {
    usage_plan_id: payload.usage_plan_id ?? null,
    inventory_qty: Number.isFinite(inventory_qty) ? inventory_qty : 0,
    inventory_value: Number.isFinite(inventory_value) ? inventory_value : 0,
    purchase_qty: Number.isFinite(purchase_qty) ? purchase_qty : 0,
    purchase_value: Number.isFinite(purchase_value) ? purchase_value : 0,
  };
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(purchasePlanQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      product_name,
      category,
      product_type,
      product_subtype,
      budget_year,
      requesting_dept,
      has_purchase_approval,
      order_by,
      sort_order,
      page,
      page_size: pageSize,
    } = queryValidation.data;

    const { params, whereSql } = buildWhereClause({
      product_name,
      category,
      product_type,
      product_subtype,
      budget_year,
      requesting_dept,
      has_purchase_approval,
    });

    const isFreeTextSearch = Boolean(product_name);

    const allowedOrderFields: Record<string, string> = {
      id: 'pp.id',
      sequence_no: 'up.sequence_no',
      product_code: 'up.product_code',
      product_name: 'up.product_name',
      category: 'up.category',
      product_type: 'up.type',
      product_subtype: 'up.subtype',
      unit: 'up.unit',
      price_per_unit: 'up.price_per_unit',
      requested_amount: 'up.requested_amount',
      approved_quota: 'up.approved_quota',
      inventory_qty: 'COALESCE(inventory_snapshot.inventory_qty, pp.inventory_qty, 0)',
      inventory_value: 'COALESCE(inventory_snapshot.inventory_value, pp.inventory_value, 0)',
      purchase_qty: 'COALESCE(pp.purchase_qty, GREATEST(COALESCE(up.approved_quota, 0) - COALESCE(inventory_snapshot.inventory_qty, 0), 0))',
      purchase_value: 'COALESCE(pp.purchase_value, ROUND(COALESCE(pp.purchase_qty, GREATEST(COALESCE(up.approved_quota, 0) - COALESCE(inventory_snapshot.inventory_qty, 0), 0)) * COALESCE(up.price_per_unit, 0), 2))',
      budget_year: 'up.budget_year',
      requesting_dept: 'up.requesting_dept',
    };

    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'pp.id';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('page_size');

    const cacheBasePayload = {
      product_name,
      category,
      product_type,
      product_subtype,
      budget_year,
      requesting_dept,
      has_purchase_approval,
      order_by: order_by || 'id',
      sort_order: sort_order || 'desc',
    };

    if (isFreeTextSearch && !pageParam && !pageSizeParam) {
      const [countResult, itemsResult] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count ${purchasePlanBaseSelect} ${whereSql}`, params),
        pgQuery(`${purchasePlanSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params),
      ]);

      return apiSuccess(itemsResult.rows, undefined, countResult.rows[0]?.count || 0, 200);
    }

    if (!pageParam && !pageSizeParam) {
      const cacheKeyAll = `erp:purchase:plans:list:all:${JSON.stringify(cacheBasePayload)}`;
      const cachedAll = await cacheGet<{ items: unknown[]; totalCount: number }>(cacheKeyAll);
      if (cachedAll) {
        return apiSuccess(cachedAll.items, undefined, cachedAll.totalCount, 200);
      }

      const [countResult, itemsResult] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count ${purchasePlanBaseSelect} ${whereSql}`, params),
        pgQuery(`${purchasePlanSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params),
      ]);

      const result = {
        items: itemsResult.rows,
        totalCount: countResult.rows[0]?.count || 0,
      };

      await cacheSet(cacheKeyAll, result, 1800);
      return apiSuccess(result.items, undefined, result.totalCount, 200);
    }

    const currentPage = page ?? 1;
    const currentPageSize = pageSize ?? 20;
    const offset = (currentPage - 1) * currentPageSize;

    if (isFreeTextSearch) {
      const paginatedParams = [...params, currentPageSize, offset];
      const [countResult, itemsResult] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count ${purchasePlanBaseSelect} ${whereSql}`, params),
        pgQuery(`${purchasePlanSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, paginatedParams),
      ]);

      return apiSuccess(itemsResult.rows, undefined, countResult.rows[0]?.count || 0, 200, { page: currentPage, page_size: currentPageSize });
    }

    const cacheKey = `erp:purchase:plans:list:${JSON.stringify({ ...cacheBasePayload, page: currentPage, page_size: currentPageSize })}`;
    const cached = await cacheGet<{ items: unknown[]; totalCount: number }>(cacheKey);

    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page: currentPage, page_size: currentPageSize });
    }

    const paginatedParams = [...params, currentPageSize, offset];
    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count ${purchasePlanBaseSelect} ${whereSql}`, params),
      pgQuery(`${purchasePlanSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, paginatedParams),
    ]);

    const result = {
      items: itemsResult.rows,
      totalCount: countResult.rows[0]?.count || 0,
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
    const validation = await validateRequest(createPurchasePlanSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const payload = normalizePurchasePlanPayload(validation.data as PurchasePlanPayload);

    if (payload.usage_plan_id === null) {
      return apiError('กรุณาเลือก usage_plan_id', 400);
    }

    const usagePlanResult = await pgQuery('SELECT id, price_per_unit::float8 AS price_per_unit FROM public.usage_plan WHERE id = $1 LIMIT 1', [payload.usage_plan_id]);
    const usagePlan = usagePlanResult.rows[0];

    if (!usagePlan) {
      return apiError('ไม่พบข้อมูลแผนการใช้ที่เลือก', 400);
    }

    const duplicateResult = await pgQuery('SELECT id FROM public.purchase_plan WHERE usage_plan_id = $1 LIMIT 1', [payload.usage_plan_id]);
    if (duplicateResult.rows.length > 0) {
      return apiError('แผนการใช้นี้ถูกสร้างแผนจัดซื้อแล้ว', 400);
    }

    const pricePerUnit = Number(usagePlan.price_per_unit || 0);
    const purchase_value = Number((payload.purchase_qty * pricePerUnit).toFixed(2));

    const insertResult = await pgQuery(
      `INSERT INTO public.purchase_plan (usage_plan_id, inventory_qty, inventory_value, purchase_qty, purchase_value)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, usage_plan_id, inventory_qty, inventory_value::float8 AS inventory_value, purchase_qty, purchase_value::float8 AS purchase_value`,
      [payload.usage_plan_id, payload.inventory_qty, payload.inventory_value, payload.purchase_qty, purchase_value],
    );

    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');

    return apiSuccess(insertResult.rows[0], 'Purchase plan created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating purchase plan:', error);
    return apiError('Failed to create purchase plan');
  }
}
