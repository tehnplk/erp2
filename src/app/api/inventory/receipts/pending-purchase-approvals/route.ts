import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryPendingPurchaseApprovalQuerySchema } from '@/lib/validation/schemas';
import { cacheGet, cacheSet } from '@/lib/redis';

const pendingPurchaseApprovalSelect = `
  SELECT
    pad.id AS purchase_approval_detail_id,
    pa.id AS purchase_approval_id,
    pa.approve_code,
    pa.doc_no,
    pa.status,
    up.requesting_dept AS department,
    d.department_code AS department_code,
    up.budget_year,
    pa.doc_date AS request_date,
    up.product_code,
    p.name AS product_name,
    p.category,
    c.type AS product_type,
    c.subtype AS product_subtype,
    up.requested_amount AS requested_quantity,
    p.unit,
    COALESCE(p.cost_price, 0)::float8 AS price_per_unit,
    (up.requested_amount * COALESCE(p.cost_price, 0))::float8 AS total_value,
    pp.purchase_qty,
    pp.purchase_value,
    pad.approved_quantity,
    pad.approved_amount,
    link.inventory_receipt_status,
    link.received_qty,
    GREATEST(COALESCE(pad.approved_quantity, up.requested_amount, 0) - COALESCE(link.received_qty, 0), 0) AS remaining_qty
  FROM public.purchase_approval_detail pad
  INNER JOIN public.purchase_approval pa ON pa.id = pad.purchase_approval_id
  INNER JOIN public.purchase_plan pp ON pp.id = pad.purchase_plan_id
  INNER JOIN public.usage_plan up ON up.id = pp.usage_plan_id
  LEFT JOIN public.product p ON p.code = up.product_code
  LEFT JOIN public.category c ON c.category = p.category
  LEFT JOIN public.department d ON d.name = up.requesting_dept
  INNER JOIN public.purchase_approval_inventory_link link ON link.purchase_approval_detail_id = pad.id
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryPendingPurchaseApprovalQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const page = queryValidation.data.page ?? 1;
    const pageSize = Math.max(1, Math.min(200, Number(searchParams.get('page_size') || queryValidation.data.page_size || 20)));

    const {
      product_name,
      department,
      budget_year,
      status,
      order_by,
      sort_order,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (product_name) {
      params.push(`%${product_name}%`);
      whereClauses.push(`p.name ILIKE $${params.length}`);
    }

    if (department) {
      params.push(department);
      whereClauses.push(`up.requesting_dept = $${params.length}`);
    }

    if (budget_year) {
      params.push(Number(budget_year));
      whereClauses.push(`up.budget_year = $${params.length}`);
    }

    if (status) {
      params.push(status);
      whereClauses.push(`link.inventory_receipt_status = $${params.length}`);
    } else {
      whereClauses.push(`link.inventory_receipt_status IN ('PENDING', 'PARTIAL')`);
    }

    whereClauses.push(`pa.status = 'APPROVED'`);
    whereClauses.push(`GREATEST(COALESCE(pad.approved_quantity, up.requested_amount, 0) - COALESCE(link.received_qty, 0), 0) > 0`);

    const allowedOrderFields: Record<string, string> = {
      id: 'pad.id',
      product_code: 'up.product_code',
      product_name: 'p.name',
      department: 'up.requesting_dept',
      budget_year: 'up.budget_year',
      requested_quantity: 'up.requested_amount',
      received_qty: 'link.received_qty',
    };

    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'pad.id';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const offset = (page - 1) * pageSize;

    // --- Redis Caching Logic ---
    const cacheKey = `erp:inventory:receipts:pending:${JSON.stringify({ ...queryValidation.data, page, page_size: pageSize })}`;
    const cached = await cacheGet<{ items: any[]; totalCount: number }>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, page_size: pageSize });
    }

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`
        SELECT COUNT(*)::int AS count
        FROM public.purchase_approval_detail pad
        INNER JOIN public.purchase_approval pa ON pa.id = pad.purchase_approval_id
        INNER JOIN public.purchase_plan pp ON pp.id = pad.purchase_plan_id
        INNER JOIN public.usage_plan up ON up.id = pp.usage_plan_id
        LEFT JOIN public.product p ON p.code = up.product_code
        INNER JOIN public.purchase_approval_inventory_link link ON link.purchase_approval_detail_id = pad.id
        ${whereSql}
      `, params),
      pgQuery(`${pendingPurchaseApprovalSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset]),
    ]);

    const items = itemsResult.rows;
    const totalCount = countResult.rows[0]?.count || 0;

    // Save to Cache
    await cacheSet(cacheKey, { items, totalCount }, 600);

    return apiSuccess(items, undefined, totalCount, 200, { page, page_size: pageSize });
  } catch (error) {
    console.error('Error fetching pending purchase approvals for inventory receipt:', error);
    return apiError('Failed to fetch pending purchase approvals');
  }
}
