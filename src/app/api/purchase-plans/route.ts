import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { cacheDelByPattern, cacheGet, cacheSet } from '@/lib/redis';
import { allocatePurchasePlanId, normalizePurchasePlanFlag } from '@/lib/purchase-plan';
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
        WHEN BOOL_OR(COALESCE(up.plan_flag, '') = 'เธเธญเธเนเธเธ') THEN 'เธเธญเธเนเธเธ'
        ELSE 'เนเธเนเธเธ'
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
      p_stock.code AS product_code,
      COALESCE(SUM(isl.qty_on_hand), 0)::int AS inventory_qty
    FROM public.inventory_stock_lot isl
    INNER JOIN public.product p_stock ON p_stock.id = isl.product_id
    GROUP BY p_stock.code
  ) inventory_snapshot ON inventory_snapshot.product_code = usage_summary.product_code
  LEFT JOIN (
    SELECT
      COALESCE(pad.product_code, p.code) AS product_code,
      COALESCE(pad.purchase_department_id, p.purchase_department_id) AS purchase_department_id,
      pa.budget_year,
      CASE WHEN COALESCE(pad.usage_plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END AS usage_plan_flag,
      COALESCE(SUM(COALESCE(pad.proposed_quantity, pad.approved_quantity, 0)), 0)::int AS purchased_qty
    FROM public.purchase_approval_detail pad
    INNER JOIN public.purchase_approval pa ON pa.id = pad.purchase_approval_id
    LEFT JOIN public.product p ON p.code = pad.product_code
    GROUP BY COALESCE(pad.product_code, p.code), COALESCE(pad.purchase_department_id, p.purchase_department_id), pa.budget_year, CASE WHEN COALESCE(pad.usage_plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END
  ) purchased_summary ON purchased_summary.product_code = usage_summary.product_code
    AND purchased_summary.purchase_department_id = p.purchase_department_id
    AND purchased_summary.budget_year = usage_summary.budget_year
    AND purchased_summary.usage_plan_flag = usage_summary.usage_plan_flag
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
    COALESCE(inventory_snapshot.inventory_qty, pp.inventory_qty, 0)::int AS inventory_qty,
    COALESCE(purchased_summary.purchased_qty, 0)::int AS purchased_qty,
    GREATEST(
      COALESCE(pp.qouta_qty, usage_summary.approved_quota, 0)
      - COALESCE(inventory_snapshot.inventory_qty, pp.inventory_qty, 0),
      0
    )::int AS purchase_qty,
    ROUND(
      GREATEST(
        COALESCE(pp.qouta_qty, usage_summary.approved_quota, 0)
        - COALESCE(inventory_snapshot.inventory_qty, pp.inventory_qty, 0),
        0
      ) * COALESCE(p.cost_price, 0),
      2
    )::float8 AS purchase_value
  ${purchasePlanBaseSelect}
`;

const PURCHASE_PLAN_CACHE_VERSION = 'v9';

function buildWhereClause(filters: {
  product_name?: string;
  category?: string;
  product_type?: string;
  product_subtype?: string;
  usage_plan_flag?: string;
  purchase_department?: string;
  budget_year?: string;
  requesting_dept?: string;
}) {
  const whereClauses: string[] = [];
  const params: unknown[] = [];

  if (filters.product_name) {
    params.push(`%${filters.product_name}%`);
    const searchParamIndex = params.length;
    whereClauses.push(`(pp.product_name ILIKE $${searchParamIndex} OR pp.product_code ILIKE $${searchParamIndex})`);
  }

  if (filters.category) {
    params.push(filters.category);
    whereClauses.push(`pp.category = $${params.length}`);
  }

  if (filters.product_type) {
    params.push(filters.product_type);
    whereClauses.push(`pp.product_type = $${params.length}`);
  }

  if (filters.product_subtype) {
    params.push(filters.product_subtype);
    whereClauses.push(`pp.product_subtype = $${params.length}`);
  }

  if (filters.usage_plan_flag === 'นอกแผน' || filters.usage_plan_flag === 'ในแผน') {
    params.push(filters.usage_plan_flag);
    whereClauses.push(`pp.usage_plan_flag = $${params.length}`);
  }

  if (filters.purchase_department) {
    params.push(filters.purchase_department);
    whereClauses.push(`COALESCE(pp.purchase_department_name, pp.purchase_department_code, '') = $${params.length}`);
  }

  if (filters.budget_year) {
    params.push(Number(filters.budget_year));
    whereClauses.push(`pp.budget_year = $${params.length}`);
  }

  if (filters.requesting_dept) {
    params.push(filters.requesting_dept);
    whereClauses.push(`pp.requesting_dept ILIKE $${params.length}`);
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
    });

    const allowedOrderFields: Record<string, string> = {
      id: 'pp.id',
      product_code: 'pp.product_code',
      product_name: 'pp.product_name',
      purchase_department: 'COALESCE(pp.purchase_department_name, pp.purchase_department_code)',
      usage_plan_flag: 'pp.usage_plan_flag',
      unit: 'pp.unit',
      approved_quota: 'pp.approved_quota',
      inventory_qty: 'pp.inventory_qty',
      purchased_qty: 'pp.purchased_qty',
      purchase_qty: 'pp.purchase_qty',
      unit_price: 'pp.unit_price',
      purchase_value: 'pp.purchase_value',
      budget_year: 'pp.budget_year',
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
      usage_plan_flag,
      purchase_department,
      budget_year,
      requesting_dept,
      order_by: order_by || 'id',
      sort_order: sort_order || 'desc',
    };
    const baseFrom = 'FROM public.purchase_plan pp';

    if (!pageParam && !pageSizeParam) {
      const cacheKeyAll = `erp:purchase:plans:list:${PURCHASE_PLAN_CACHE_VERSION}:all:${JSON.stringify(cacheBasePayload)}`;
      const cachedAll = await cacheGet<{ items: unknown[]; totalCount: number }>(cacheKeyAll);
      if (cachedAll) {
        return apiSuccess(cachedAll.items, undefined, cachedAll.totalCount, 200);
      }

      const [countResult, itemsResult] = await Promise.all([
        pgQuery(`SELECT COUNT(*)::int AS count ${baseFrom} ${whereSql}`, params),
        pgQuery(`SELECT pp.* ${baseFrom} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder}`, params),
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
    const cacheKey = `erp:purchase:plans:list:${PURCHASE_PLAN_CACHE_VERSION}:${JSON.stringify({ ...cacheBasePayload, page: currentPage, page_size: currentPageSize })}`;
    const cached = await cacheGet<{ items: unknown[]; totalCount: number }>(cacheKey);

    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page: currentPage, page_size: currentPageSize });
    }

    const paginatedParams = [...params, currentPageSize, offset];
    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count ${baseFrom} ${whereSql}`, params),
      pgQuery(`SELECT pp.* ${baseFrom} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, paginatedParams),
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
        budget_year: number | null;
        approved_quota: number | null;
        requested_amount: number | null;
        purchase_plan_id: number | null;
        plan_flag: string | null;
      }>(
        `SELECT id, product_code, budget_year, approved_quota, requested_amount, purchase_plan_id, plan_flag
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

      const budgetYears = Array.from(
        new Set(usagePlansResult.rows.map((row) => Number(row.budget_year)).filter((year) => Number.isFinite(year) && year > 0)),
      );
      if (budgetYears.length !== 1) {
        await client.query('ROLLBACK');
        return apiError('usage_plan ที่เลือกต้องอยู่ปีงบเดียวกันทั้งหมด', 400);
      }

      const selectedPlanFlags = Array.from(
        new Set(usagePlansResult.rows.map((row) => normalizePurchasePlanFlag(row.plan_flag))),
      );
      if (selectedPlanFlags.length !== 1) {
        await client.query('ROLLBACK');
        return apiError('กรุณาเลือก usage_plan ที่มีประเภทแผนเดียวกัน (ในแผน หรือ นอกแผน) ต่อครั้ง', 400);
      }

      const productCode = productCodes[0];
      const targetBudgetYear = budgetYears[0];
      const targetPlanFlag = selectedPlanFlags[0];
      const purchaseDepartmentResult = await client.query<{ purchase_department_id: number | null }>(
        `SELECT COALESCE(p.purchase_department_id, 0)::int AS purchase_department_id
         FROM public.product p
         WHERE p.code = $1
         LIMIT 1`,
        [productCode],
      );
      const targetPurchaseDepartmentId = Number(purchaseDepartmentResult.rows[0]?.purchase_department_id ?? 0);

      const existingPlanResult = await client.query<{ id: number }>(
        `SELECT purchase_plan_id AS id
         FROM public.usage_plan
         INNER JOIN public.product p ON p.code = public.usage_plan.product_code
         WHERE purchase_plan_id IS NOT NULL
           AND public.usage_plan.product_code = $1
           AND budget_year = $2
           AND COALESCE(p.purchase_department_id, 0) = $3
           AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = $4
         GROUP BY purchase_plan_id
         ORDER BY purchase_plan_id`,
        [productCode, targetBudgetYear, targetPurchaseDepartmentId, targetPlanFlag],
      );

      let purchasePlanId = Number(existingPlanResult.rows[0]?.id ?? 0);
      if (!purchasePlanId) {
        purchasePlanId = await allocatePurchasePlanId(client);
      }

      if (!purchasePlanId) {
        await client.query('ROLLBACK');
        return apiError('ไม่สามารถสร้างแผนจัดซื้อได้', 500);
      }

      const duplicatePlanIds = existingPlanResult.rows
        .slice(1)
        .map((row) => Number(row.id))
        .filter((id) => Number.isInteger(id) && id > 0);

      if (duplicatePlanIds.length > 0) {
        await client.query(
        `UPDATE public.usage_plan
         SET purchase_plan_id = $1,
             updated_at = NOW()
         WHERE purchase_plan_id = ANY($2::int[])
           AND product_code = $3
           AND budget_year = $4
           AND EXISTS (
             SELECT 1
             FROM public.product p
             WHERE p.code = public.usage_plan.product_code
               AND COALESCE(p.purchase_department_id, 0) = $5
           )
           AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = $6`,
          [purchasePlanId, duplicatePlanIds, productCode, targetBudgetYear, targetPurchaseDepartmentId, targetPlanFlag],
        );
      }

      const usagePlanUpdateResult = await client.query(
        `UPDATE public.usage_plan
         SET purchase_plan_id = $1,
             plan_flag = $2,
             updated_at = NOW()
         WHERE id = ANY($3::int[])
           AND purchase_plan_id IS NULL`,
        [purchasePlanId, targetPlanFlag, usagePlanIds],
      );

      if (usagePlanUpdateResult.rowCount !== usagePlanIds.length) {
        await client.query('ROLLBACK');
        return apiError('มีบางรายการถูกสร้างแผนจัดซื้อโดยผู้ใช้อื่นแล้ว กรุณารีเฟรชข้อมูลแล้วลองใหม่', 409);
      }

      const quotaResult = await client.query<{ total_quota: number }>(
        `SELECT COALESCE(SUM(GREATEST(COALESCE(approved_quota, requested_amount, 0), 0)), 0)::int AS total_quota
         FROM public.usage_plan
         WHERE purchase_plan_id = $1
           AND product_code = $2
           AND budget_year = $3
           AND EXISTS (
             SELECT 1
             FROM public.product p
             WHERE p.code = public.usage_plan.product_code
               AND COALESCE(p.purchase_department_id, 0) = $4
           )
           AND (CASE WHEN COALESCE(plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END) = $5`,
        [purchasePlanId, productCode, targetBudgetYear, targetPurchaseDepartmentId, targetPlanFlag],
      );

      const inventoryResult = await client.query<{ inventory_qty: number }>(
        `SELECT COALESCE(SUM(isl.qty_on_hand), 0)::int AS inventory_qty
         FROM public.inventory_stock_lot isl
         INNER JOIN public.product p_stock ON p_stock.id = isl.product_id
         WHERE p_stock.code = $1`,
        [productCode],
      );

      const totalQuotaFromUsagePlan = Number(quotaResult.rows[0]?.total_quota ?? 0);
      const qoutaQty = payload.qouta_qty > 0 ? payload.qouta_qty : totalQuotaFromUsagePlan;
      const inventoryQty = Number(inventoryResult.rows[0]?.inventory_qty ?? 0);
      const purchaseQty = Math.max(qoutaQty - inventoryQty, 0);

      await client.query('COMMIT');

      await cacheDelByPattern('erp:purchase:plans:list:*');
      await cacheDelByPattern('erp:purchase:plans:filters*');

      return apiSuccess(
        {
          id: purchasePlanId,
          budget_year: targetBudgetYear,
          inventory_qty: inventoryQty,
          qouta_qty: qoutaQty,
          purchase_qty: purchaseQty,
          usage_plan_ids: usagePlanIds,
          plan_flag: targetPlanFlag,
        },
        'Purchase plan created successfully',
        undefined,
        201,
      );
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




