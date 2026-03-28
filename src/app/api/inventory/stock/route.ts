import { NextRequest } from 'next/server';
import { apiError, apiSuccess } from '@/lib/api-response';
import { pgQuery } from '@/lib/pg';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryStockQuerySchema } from '@/lib/validation/schemas';

type InventoryStockRow = {
  product_id: number;
  product_code: string;
  product_name: string;
  category: string | null;
  product_type: string | null;
  product_subtype: string | null;
  unit: string | null;
  lot_count: number;
  lot_numbers: string | null;
  total_qty: string | number;
  total_value: string | number;
  avg_unit_price: string | number;
  last_received_at: string | null;
  last_delivery_note_no: string | null;
};

type InventoryStockFilterRow = {
  category: string | null;
  product_type: string | null;
};

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryStockQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      search,
      category,
      product_type,
      product_subtype,
      lot,
      unit,
      order_by = 'product_code',
      sort_order = 'asc',
      page = 1,
      page_size = 20,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: Array<string | number> = [];

    if (search?.trim()) {
      params.push(`%${search.trim()}%`);
      const searchParam = `$${params.length}`;
      whereClauses.push(`(
        v.product_code ILIKE ${searchParam}
        OR v.product_name ILIKE ${searchParam}
      )`);
    }

    if (category?.trim()) {
      params.push(category.trim());
      whereClauses.push(`v.category = $${params.length}`);
    }

    if (product_type?.trim()) {
      params.push(product_type.trim());
      whereClauses.push(`v.product_type = $${params.length}`);
    }

    if (product_subtype?.trim()) {
      params.push(product_subtype.trim());
      whereClauses.push(`v.product_subtype = $${params.length}`);
    }

    if (lot?.trim()) {
      params.push(`%${lot.trim()}%`);
      whereClauses.push(`v.lot_numbers ILIKE $${params.length}`);
    }

    if (unit?.trim()) {
      params.push(unit.trim());
      whereClauses.push(`v.unit = $${params.length}`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';

    const orderMap: Record<string, string> = {
      product_code: 'v.product_code',
      product_name: 'v.product_name',
      category: 'v.category',
      product_type: 'v.product_type',
      unit: 'v.unit',
      lot_count: 'v.lot_count',
      total_qty: 'v.total_qty',
      total_value: 'v.total_value',
      avg_unit_price: 'v.avg_unit_price',
      last_received_at: 'v.last_received_at',
      last_delivery_note_no: 'v.last_delivery_note_no',
    };

    const safeOrderBy = orderMap[order_by] || 'v.product_code';
    const safeSortOrder = sort_order === 'desc' ? 'DESC' : 'ASC';
    const offset = (page - 1) * page_size;

    params.push(page_size);
    const limitParam = `$${params.length}`;
    params.push(offset);
    const offsetParam = `$${params.length}`;

    const [countResult, rowsResult] = await Promise.all([
      pgQuery<{ count: number }>(`SELECT COUNT(*)::int AS count FROM public.inventory_stock_summary v ${whereSql}`, params.slice(0, params.length - 2)),
      pgQuery<InventoryStockRow>(
        `
          SELECT
            v.product_id,
            v.product_code,
            v.product_name,
            v.category,
            v.product_type,
            v.product_subtype,
            v.unit,
            v.lot_count,
            v.lot_numbers,
            v.total_qty::float8 AS total_qty,
            v.total_value::float8 AS total_value,
            v.avg_unit_price::float8 AS avg_unit_price,
            v.last_received_at,
            v.last_delivery_note_no
          FROM public.inventory_stock_summary v
          ${whereSql}
          ORDER BY ${safeOrderBy} ${safeSortOrder}, v.product_code ASC
          LIMIT ${limitParam} OFFSET ${offsetParam}
        `,
        params
      ),
    ]);

    const totals = await pgQuery<{
      total_products: number;
      total_qty: string | number;
      total_value: string | number;
    }>(
      `
        SELECT
          COUNT(*)::int AS total_products,
          COALESCE(SUM(v.total_qty), 0)::float8 AS total_qty,
          COALESCE(SUM(v.total_value), 0)::float8 AS total_value
        FROM public.inventory_stock_summary v
        ${whereSql}
      `,
      params.slice(0, params.length - 2)
    );

    const filterRows = await pgQuery<InventoryStockFilterRow>(
      `
        SELECT DISTINCT
          v.category,
          v.product_type
        FROM public.inventory_stock_summary v
        WHERE v.category IS NOT NULL OR v.product_type IS NOT NULL
        ORDER BY v.category NULLS LAST, v.product_type NULLS LAST
      `
    );

    const categoryTypeMap = new Map<string, Set<string>>();
    for (const row of filterRows.rows) {
      const categoryName = row.category?.trim();
      const typeName = row.product_type?.trim();
      if (!categoryName) continue;
      if (!categoryTypeMap.has(categoryName)) {
        categoryTypeMap.set(categoryName, new Set());
      }
      if (typeName) {
        categoryTypeMap.get(categoryName)?.add(typeName);
      }
    }

    return apiSuccess(
      {
        rows: rowsResult.rows,
        summary: {
          total_products: totals.rows[0]?.total_products ?? 0,
          total_qty: Number(totals.rows[0]?.total_qty ?? 0),
          total_value: Number(totals.rows[0]?.total_value ?? 0),
        },
        filters: {
          categories: Array.from(categoryTypeMap.keys()).sort((a, b) => a.localeCompare(b)),
          category_type_map: Object.fromEntries(Array.from(categoryTypeMap.entries()).map(([categoryName, typeSet]) => [categoryName, Array.from(typeSet).sort((a, b) => a.localeCompare(b))])),
        },
      },
      undefined,
      countResult.rows[0]?.count ?? 0,
      200,
      { page, page_size }
    );
  } catch (error) {
    console.error('Error listing inventory stock:', error);
    return apiError('Failed to list inventory stock');
  }
}
