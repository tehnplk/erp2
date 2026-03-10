import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryPendingPurchaseApprovalQuerySchema } from '@/lib/validation/schemas';
import { cacheGet, cacheSet } from '@/lib/redis';

const pendingPurchaseApprovalSelect = `
  SELECT
    pa.id,
    pa.approval_id,
    pa.department,
    pa.department_code,
    pa.budget_year,
    pa.record_number,
    pa.request_date,
    pa.product_code,
    pa.product_name,
    pa.category,
    pa.product_type,
    pa.product_subtype,
    pa.requested_quantity,
    pa.unit,
    pa.price_per_unit::float8 AS price_per_unit,
    pa.total_value::float8 AS total_value,
    link.inventory_receipt_status,
    link.received_qty,
    GREATEST(COALESCE(pa.requested_quantity, 0) - COALESCE(link.received_qty, 0), 0) AS remaining_qty
  FROM public.purchase_approval pa
  INNER JOIN public.purchase_approval_inventory_link link ON link.purchase_approval_id = pa.id
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
      whereClauses.push(`pa.product_name ILIKE $${params.length}`);
    }

    if (department) {
      params.push(department);
      whereClauses.push(`pa.department = $${params.length}`);
    }

    if (budget_year) {
      params.push(Number(budget_year));
      whereClauses.push(`pa.budget_year = $${params.length}`);
    }

    if (status) {
      params.push(status);
      whereClauses.push(`link.inventory_receipt_status = $${params.length}`);
    } else {
      whereClauses.push(`link.inventory_receipt_status IN ('PENDING', 'PARTIAL')`);
    }

    whereClauses.push(`GREATEST(COALESCE(pa.requested_quantity, 0) - COALESCE(link.received_qty, 0), 0) > 0`);

    const allowedOrderFields: Record<string, string> = {
      id: 'pa.id',
      product_code: 'pa.product_code',
      product_name: 'pa.product_name',
      department: 'pa.department',
      budget_year: 'pa.budget_year',
      requested_quantity: 'pa.requested_quantity',
      received_qty: 'link.received_qty',
    };

    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'pa.id';
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
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.purchase_approval pa INNER JOIN public.purchase_approval_inventory_link link ON link.purchase_approval_id = pa.id ${whereSql}`, params),
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
