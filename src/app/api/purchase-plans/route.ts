import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern, cacheGet, cacheSet } from '@/lib/redis';
import { createPurchasePlanSchema, purchasePlanQuerySchema } from '@/lib/validation/schemas';
import { validateQuery, validateRequest } from '@/lib/validation/validate';

type PurchasePlanPayload = {
  usage_plan_ids?: number[];
  inventory_qty?: number | null;
  qouta_qty?: number | null;
  purchase_qty?: number | null;
};

const purchasePlanBaseSelect = `
  FROM public.purchase_plan pp
  LEFT JOIN (
    SELECT
      up.purchase_plan_id,
      MIN(up.budget_year)::int AS budget_year,
      MIN(up.product_code) AS product_code,
      SUM(COALESCE(up.requested_amount, 0))::int AS requested_amount,
      SUM(COALESCE(up.approved_quota, 0))::int AS approved_quota,
      STRING_AGG(DISTINCT COALESCE(d.name, up.requesting_dept_code), ', ') AS requesting_depts,
      CASE
        WHEN BOOL_OR(COALESCE(up.plan_flag, '') = 'นอกแผน') THEN 'นอกแผน'
        ELSE 'ในแผน'
      END AS usage_plan_flag
    FROM public.usage_plan up
    LEFT JOIN public.department d ON d.department_code = up.requesting_dept_code
    WHERE up.purchase_plan_id IS NOT NULL
    GROUP BY up.purchase_plan_id
  ) usage_summary ON usage_summary.purchase_plan_id = pp.id
  LEFT JOIN public.product p ON p.code = usage_summary.product_code
  LEFT JOIN public.department pd ON pd.id = p.purchase_department_id
  LEFT JOIN (
    SELECT
      ii.product_code,
      COALESCE(SUM(ib.on_hand_qty), 0)::int AS inventory_qty
    FROM public.inventory_item ii
    INNER JOIN public.inventory_balance ib ON ib.inventory_item_id = ii.id
    GROUP BY ii.product_code
  ) inventory_snapshot ON inventory_snapshot.product_code = usage_summary.product_code
  LEFT JOIN (
    SELECT
      pad.purchase_plan_id,
      COALESCE(SUM(COALESCE(pad.proposed_quantity, pad.approved_quantity, 0)), 0)::int AS purchased_qty
    FROM public.purchase_approval_detail pad
    GROUP BY pad.purchase_plan_id
  ) purchased_summary ON purchased_summary.purchase_plan_id = pp.id
`;

const purchasePlanSelect = `
  SELECT
    pp.id,
    usage_summary.budget_year,
    usage_summary.product_code,
    p.name AS product_name,
    p.category,
    p.type AS product_type,
    p.subtype AS product_subtype,
    p.unit,
    COALESCE(p.cost_price, 0)::float8 AS unit_price,
    usage_summary.requested_amount,
    COALESCE(pp.qouta_qty, usage_summary.approved_quota, 0)::int AS approved_quota,
    usage_summary.requesting_depts AS requesting_dept,
    usage_summary.usage_plan_flag,
    p.purchase_department_id,
    pd.department_code AS purchase_department_code,
    pd.name AS purchase_department_name,
    EXISTS (SELECT 1 FROM public.purchase_approval_detail has_pad WHERE has_pad.purchase_plan_id = pp.id) AS has_purchase_approval,
    COALESCE(inventory_snapshot.inventory_qty, pp.inventory_qty, 0)::int AS inventory_qty,
    COALESCE(purchased_summary.purchased_qty, 0)::int AS purchased_qty,
    COALESCE(pp.purchase_qty, 0)::int AS purchase_qty,
    ROUND(COALESCE(pp.purchase_qty, 0) * COALESCE(p.cost_price, 0), 2)::float8 AS purchase_value
  ${purchasePlanBaseSelect}
`;

const PURCHASE_PLAN_CACHE_VERSION = 'v2';

function buildWhereClause(filters: {
  product_name?: string;
  category?: string;
  product_type?: string;
  product_subtype?: string;
  usage_plan_flag?: 'ในแผน' | 'นอกแผน';
  purchase_department?: string;
  budget_year?: string;
  requesting_dept?: string;
  has_purchase_approval?: 'true' | 'false';
}) {
  const whereClauses: string[] = [];
  const params: unknown[] = [];

  if (filters.product_name) {
    params.push(`%${filters.product_name}%`);
    const searchParamIndex = params.length;
    whereClauses.push(`(p.name ILIKE $${searchParamIndex} OR usage_summary.product_code ILIKE $${searchParamIndex})`);
  }

  if (filters.category) {
    params.push(filters.category);
    whereClauses.push(`p.category = $${params.length}`);
  }

  if (filters.product_type) {
    params.push(filters.product_type);
    whereClauses.push(`p.type = $${params.length}`);
  }

  if (filters.product_subtype) {
    params.push(filters.product_subtype);
    whereClauses.push(`p.subtype = $${params.length}`);
  }

  if (filters.usage_plan_flag) {
    params.push(filters.usage_plan_flag);
    whereClauses.push(`usage_summary.usage_plan_flag = $${params.length}`);
  }

  if (filters.purchase_department) {
    params.push(filters.purchase_department);
    whereClauses.push(`COALESCE(pd.name, '') = $${params.length}`);
  }

  if (filters.budget_year) {
    params.push(Number(filters.budget_year));
    whereClauses.push(`usage_summary.budget_year = $${params.length}`);
  }

  if (filters.requesting_dept) {
    params.push(filters.requesting_dept);
    whereClauses.push(`usage_summary.requesting_depts ILIKE $${params.length}`);
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
  const usage_plan_ids = Array.isArray(payload.usage_plan_ids)
    ? payload.usage_plan_ids.map((id) => Number(id)).filter((id) => Number.isInteger(id) && id > 0)
    : [];
  const inventory_qty = Number(payload.inventory_qty ?? 0);
  const qouta_qty = Number(payload.qouta_qty ?? 0);
  const purchase_qty = Number(payload.purchase_qty ?? 0);

  return {
    usage_plan_ids,
    inventory_qty: Number.isFinite(inventory_qty) ? inventory_qty : 0,
    qouta_qty: Number.isFinite(qouta_qty) ? qouta_qty : 0,
    purchase_qty: Number.isFinite(purchase_qty) ? purchase_qty : 0,
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
      usage_plan_flag,
      purchase_department,
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
      usage_plan_flag,
      purchase_department,
      budget_year,
      requesting_dept,
      has_purchase_approval,
    });

    const isFreeTextSearch = Boolean(product_name);

    const allowedOrderFields: Record<string, string> = {
      id: 'pp.id',
      product_code: 'usage_summary.product_code',
      product_name: 'p.name',
      purchase_department: 'p.purchase_department_id',
      approved_quota: 'COALESCE(pp.qouta_qty, usage_summary.approved_quota, 0)',
      inventory_qty: 'COALESCE(inventory_snapshot.inventory_qty, pp.inventory_qty, 0)',
      purchased_qty: 'COALESCE(purchased_summary.purchased_qty, 0)',
      purchase_qty: 'COALESCE(pp.purchase_qty, 0)',
      unit_price: 'COALESCE(p.cost_price, 0)',
      purchase_value: 'ROUND(COALESCE(pp.purchase_qty, 0) * COALESCE(p.cost_price, 0), 2)',
      budget_year: 'usage_summary.budget_year',
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
      purchase_department,
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
      const cacheKeyAll = `erp:purchase:plans:list:${PURCHASE_PLAN_CACHE_VERSION}:all:${JSON.stringify(cacheBasePayload)}`;
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

    const cacheKey = `erp:purchase:plans:list:${PURCHASE_PLAN_CACHE_VERSION}:${JSON.stringify({ ...cacheBasePayload, page: currentPage, page_size: currentPageSize })}`;
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

    const usagePlanIds = payload.usage_plan_ids ?? [];
    if (usagePlanIds.length === 0) {
      return apiError('กรุณาระบุ usage_plan_ids อย่างน้อย 1 รายการ', 400);
    }

    const client = await pgPool.connect();
    try {
      await client.query('BEGIN');

      const usagePlansResult = await client.query<{
        id: number;
        product_code: string | null;
        approved_quota: number | null;
        purchase_plan_id: number | null;
      }>(
        `SELECT id, product_code, approved_quota, purchase_plan_id
         FROM public.usage_plan
         WHERE id = ANY($1::int[])`,
        [usagePlanIds],
      );

      if (usagePlansResult.rows.length !== usagePlanIds.length) {
        await client.query('ROLLBACK');
        return apiError('พบ usage_plan_ids บางรายการไม่มีอยู่จริง', 400);
      }

      if (usagePlansResult.rows.some((row) => row.purchase_plan_id !== null)) {
        await client.query('ROLLBACK');
        return apiError('มีบางรายการถูกผูกกับแผนจัดซื้อแล้ว', 400);
      }

      const productCodes = Array.from(
        new Set(usagePlansResult.rows.map((row) => row.product_code).filter((code): code is string => Boolean(code))),
      );
      if (productCodes.length !== 1) {
        await client.query('ROLLBACK');
        return apiError('usage_plan ที่เลือกต้องมีรหัสสินค้าเดียวกันทั้งหมด', 400);
      }

      const totalQuota = usagePlansResult.rows.reduce((sum, row) => sum + Number(row.approved_quota ?? 0), 0);
      const qoutaQty = payload.qouta_qty > 0 ? payload.qouta_qty : totalQuota;
      const purchaseQty = payload.purchase_qty > 0 ? payload.purchase_qty : qoutaQty;

      const insertResult = await client.query<{ id: number; inventory_qty: number; qouta_qty: number; purchase_qty: number }>(
        `INSERT INTO public.purchase_plan (inventory_qty, qouta_qty, purchase_qty)
         VALUES ($1, $2, $3)
         RETURNING id, inventory_qty, qouta_qty, purchase_qty`,
        [payload.inventory_qty, qoutaQty, purchaseQty],
      );

      const purchasePlanId = insertResult.rows[0].id;
      await client.query(
        `UPDATE public.usage_plan
         SET purchase_plan_id = $1,
             plan_flag = 'ในแผน',
             updated_at = NOW()
         WHERE id = ANY($2::int[])`,
        [purchasePlanId, usagePlanIds],
      );

      await client.query('COMMIT');

      await cacheDelByPattern('erp:purchase:plans:list:*');
      await cacheDelByPattern('erp:purchase:plans:filters*');

      return apiSuccess(insertResult.rows[0], 'Purchase plan created successfully', undefined, 201);
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error creating purchase plans:', error);
    return apiError('Failed to create purchase plans');
  }
}
