import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryBalanceQuerySchema } from '@/lib/validation/schemas';
import { cacheGet, cacheSet } from '@/lib/redis';

const inventoryBalanceSelect = `
  SELECT
    ib.id,
    ib.inventory_item_id,
    ii.product_code,
    ii.product_name,
    ii.category,
    ii.product_type,
    ii.product_subtype,
    ii.unit,
    ii.warehouse_id,
    iw.warehouse_code,
    iw.warehouse_name,
    ii.location_id,
    ii.lot_no,
    ii.expiry_date,
    ib.on_hand_qty,
    ib.reserved_qty,
    ib.available_qty,
    ib.avg_cost::float8 AS avg_cost,
    ib.last_movement_at,
    ib.updated_at
  FROM public.inventory_balance ib
  INNER JOIN public.inventory_item ii ON ii.id = ib.inventory_item_id
  INNER JOIN public.inventory_warehouse iw ON iw.id = ii.warehouse_id
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryBalanceQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const page = queryValidation.data.page ?? 1;
    const pageSize = Math.max(1, Math.min(200, Number(searchParams.get('page_size') || queryValidation.data.pageSize || 20)));

    const {
      product_name,
      product_code,
      category,
      product_type,
      warehouse_id,
      low_stock_only,
      order_by,
      sort_order,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (product_name) {
      params.push(`%${product_name}%`);
      whereClauses.push(`ii.product_name ILIKE $${params.length}`);
    }

    if (product_code) {
      params.push(`%${product_code}%`);
      whereClauses.push(`ii.product_code ILIKE $${params.length}`);
    }

    if (category) {
      params.push(category);
      whereClauses.push(`ii.category = $${params.length}`);
    }

    if (product_type) {
      params.push(product_type);
      whereClauses.push(`ii.product_type = $${params.length}`);
    }

    if (warehouse_id) {
      params.push(warehouse_id);
      whereClauses.push(`ii.warehouse_id = $${params.length}`);
    }

    if (low_stock_only === 'true') {
      whereClauses.push(`ib.available_qty <= 0`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'ib.id',
      product_code: 'ii.product_code',
      product_name: 'ii.product_name',
      category: 'ii.category',
      product_type: 'ii.product_type',
      on_hand_qty: 'ib.on_hand_qty',
      available_qty: 'ib.available_qty',
      avg_cost: 'ib.avg_cost',
    };

    const safeOrderField = allowedOrderFields[order_by || 'id'] || 'ib.id';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const offset = (page - 1) * pageSize;

    // --- Redis Caching Logic ---
    const cacheKey = `erp:inventory:balances:${JSON.stringify({ ...queryValidation.data, page, page_size: pageSize })}`;
    const cached = await cacheGet<{ items: any[]; totalCount: number }>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, pageSize });
    }

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.inventory_balance ib INNER JOIN public.inventory_item ii ON ii.id = ib.inventory_item_id INNER JOIN public.inventory_warehouse iw ON iw.id = ii.warehouse_id ${whereSql}`, params),
      pgQuery(`${inventoryBalanceSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset]),
    ]);

    const items = itemsResult.rows;
    const totalCount = countResult.rows[0]?.count || 0;

    // Save to Cache
    await cacheSet(cacheKey, { items, totalCount }, 300);

    return apiSuccess(items, undefined, totalCount, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching inventory balances:', error);
    return apiError('Failed to fetch inventory balances');
  }
}
