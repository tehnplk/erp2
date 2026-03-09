import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryMovementQuerySchema } from '@/lib/validation/schemas';
import { cacheGet, cacheSet } from '@/lib/redis';

const inventoryMovementSelect = `
  SELECT
    im.id,
    im.inventory_item_id,
    ii.product_code,
    ii.product_name,
    im.movement_date,
    im.movement_type,
    im.qty_in,
    im.qty_out,
    im.unit_cost::float8 AS unit_cost,
    im.total_cost::float8 AS total_cost,
    im.balance_qty_after,
    im.balance_value_after::float8 AS balance_value_after,
    im.reference_type,
    im.reference_id,
    im.reference_no,
    im.source_department,
    im.target_department,
    im.note,
    im.created_by,
    im.created_at
  FROM public.inventory_movement im
  INNER JOIN public.inventory_item ii ON ii.id = im.inventory_item_id
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryMovementQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const page = queryValidation.data.page ?? 1;
    const pageSize = Math.max(1, Math.min(200, Number(searchParams.get('page_size') || queryValidation.data.pageSize || 20)));

    const {
      inventory_item_id,
      product_code,
      movement_type,
      reference_type,
      date_from,
      date_to,
      order_by,
      sort_order,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (inventory_item_id) {
      params.push(inventory_item_id);
      whereClauses.push(`im.inventory_item_id = $${params.length}`);
    }

    if (product_code) {
      params.push(`%${product_code}%`);
      whereClauses.push(`ii.product_code ILIKE $${params.length}`);
    }

    if (movement_type) {
      params.push(movement_type);
      whereClauses.push(`im.movement_type = $${params.length}`);
    }

    if (reference_type) {
      params.push(reference_type);
      whereClauses.push(`im.reference_type = $${params.length}`);
    }

    if (date_from) {
      params.push(date_from);
      whereClauses.push(`im.movement_date >= $${params.length}`);
    }

    if (date_to) {
      params.push(date_to);
      whereClauses.push(`im.movement_date <= $${params.length}`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'im.id',
      movement_date: 'im.movement_date',
      movement_type: 'im.movement_type',
      product_code: 'ii.product_code',
      product_name: 'ii.product_name',
      qty_in: 'im.qty_in',
      qty_out: 'im.qty_out',
    };

    const safeOrderField = allowedOrderFields[order_by || 'movement_date'] || 'im.movement_date';
    const safeSortOrder = sort_order === 'asc' ? 'ASC' : 'DESC';
    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const offset = (page - 1) * pageSize;

    const cacheKey = `erp:inventory:movements:${JSON.stringify({ ...queryValidation.data, page, page_size: pageSize })}`;
    const cached = await cacheGet<{ items: any[]; totalCount: number }>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, pageSize });
    }

    const [countResult, itemsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.inventory_movement im INNER JOIN public.inventory_item ii ON ii.id = im.inventory_item_id ${whereSql}`, params),
      pgQuery(`${inventoryMovementSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, offset]),
    ]);

    const result = {
      items: itemsResult.rows,
      totalCount: countResult.rows[0]?.count || 0,
    };

    await cacheSet(cacheKey, result, 300);

    return apiSuccess(result.items, undefined, result.totalCount, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching inventory movements:', error);
    return apiError('Failed to fetch inventory movements');
  }
}
