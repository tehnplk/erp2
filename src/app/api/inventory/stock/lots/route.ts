import { NextRequest } from 'next/server';
import { apiError, apiSuccess } from '@/lib/api-response';
import { getConfiguredBudgetYear } from '@/lib/budget-year';
import { quotaUsageColumnsSql } from '@/lib/inventory-issue';
import { pgQuery } from '@/lib/pg';
import { validateQuery } from '@/lib/validation/validate';
import { inventoryStockLotQuerySchema } from '@/lib/validation/schemas';

type InventoryStockLotRow = {
  receipt_item_id: number;
  receipt_id: number;
  receipt_no: string;
  receipt_type: 'OPENING_BALANCE' | 'DELIVERY_NOTE';
  receipt_date: string;
  delivery_note_no: string | null;
  receipt_note: string | null;
  stock_lot_id: number;
  product_id: number;
  product_code: string;
  product_name: string;
  category: string | null;
  product_type: string | null;
  product_subtype: string | null;
  unit: string | null;
  lot_no: string;
  total_received_qty: string | number;
  total_received_value: string | number;
  last_delivery_note_no: string | null;
  qty_on_hand: string | number;
  total_value: string | number;
  avg_unit_price: string | number;
  last_received_at: string | null;
  issue_count: string | number;
  current_budget_quota: string | number;
  issued_qty_current_budget_year: string | number;
};

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryStockLotQuerySchema, searchParams);
    if (!queryValidation.success) return queryValidation.error;

    const {
      product_id,
      requesting_department_id,
      search,
      category,
      product_type,
      lot_no,
      available_only,
      usage_plan_only,
      order_by = 'last_received_at',
      sort_order = 'asc',
      page = 1,
      page_size = 20,
    } = queryValidation.data;

    if (usage_plan_only === 'true' && !requesting_department_id) {
      return apiError('กรุณาเลือกหน่วยงานก่อนค้นหาเฉพาะรายการตามแผนการใช้', 400);
    }

    const currentBudgetYear = await getConfiguredBudgetYear(pgQuery);
    const whereClauses: string[] = [];
    const params: Array<string | number | null> = [];

    if (product_id) {
      params.push(product_id);
      whereClauses.push(`v.product_id = $${params.length}`);
    }

    if (search?.trim()) {
      params.push(`%${search.trim()}%`);
      const p = `$${params.length}`;
      whereClauses.push(`(
        v.product_code ILIKE ${p}
        OR v.product_name ILIKE ${p}
        OR v.lot_no ILIKE ${p}
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

    if (lot_no?.trim()) {
      params.push(`%${lot_no.trim()}%`);
      whereClauses.push(`v.lot_no ILIKE $${params.length}`);
    }

    if (available_only === 'true') {
      whereClauses.push('v.qty_on_hand > 0');
    }

    if (usage_plan_only === 'true' && requesting_department_id) {
      params.push(requesting_department_id);
      const departmentParam = `$${params.length}`;
      params.push(currentBudgetYear);
      const budgetYearParam = `$${params.length}`;
      whereClauses.push(`EXISTS (
        SELECT 1
        FROM public.department d
        INNER JOIN public.usage_plan up
          ON up.requesting_dept_code = d.department_code
        WHERE d.id = ${departmentParam}
          AND up.product_code = v.product_code
          AND up.budget_year = ${budgetYearParam}
      )`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const safeSortOrder = sort_order === 'desc' ? 'DESC' : 'ASC';
    const orderMap: Record<string, string> = {
      lot_no: 'v.lot_no',
      last_received_at: 'v.last_received_at',
      last_delivery_note_no: 'v.delivery_note_no',
      total_received_qty: 'v.total_received_qty',
      total_received_value: 'v.total_received_value',
      qty_on_hand: 'v.qty_on_hand',
    };
    const safeOrderBy = orderMap[order_by] || 'v.last_received_at';
    const nullsClause = safeOrderBy === 'v.last_received_at' || safeOrderBy === 'v.last_delivery_note_no' ? ' NULLS LAST' : '';
    const offset = (page - 1) * page_size;

    const countParams = params.slice();
    const listParams = params.slice();
    listParams.push(currentBudgetYear);
    const budgetYearParam = `$${listParams.length}`;
    listParams.push(requesting_department_id ?? null);
    const departmentParam = `$${listParams.length}`;
    listParams.push(page_size, offset);

    const [countResult, rowsResult] = await Promise.all([
      pgQuery<{ count: number }>(
        `
          SELECT COUNT(*)::int AS count
          FROM public.inventory_stock_lot_detail_summary v
          ${whereSql}
        `,
        countParams
      ),
      pgQuery<InventoryStockLotRow>(
        `
          SELECT
            v.receipt_item_id,
            v.receipt_id,
            v.receipt_no,
            v.receipt_type,
            v.receipt_date::text,
            v.delivery_note_no,
            v.receipt_note,
            v.stock_lot_id,
            v.product_id,
            v.product_code,
            v.product_name,
            v.category,
            v.product_type,
            v.product_subtype,
            v.unit,
            v.lot_no,
            v.total_received_qty::float8 AS total_received_qty,
            v.total_received_value::float8 AS total_received_value,
            v.delivery_note_no AS last_delivery_note_no,
            v.qty_on_hand::float8 AS qty_on_hand,
            v.total_value::float8 AS total_value,
            v.avg_unit_price::float8 AS avg_unit_price,
            v.last_received_at,
            ${quotaUsageColumnsSql({
              departmentId: departmentParam,
              productCode: 'v.product_code',
              productId: 'v.product_id',
              budgetYear: budgetYearParam,
            })},
            COALESCE((
              SELECT COUNT(*)::int
              FROM public.inventory_issue_item iit
              WHERE iit.stock_lot_id = v.stock_lot_id
            ), 0)::int AS issue_count
          FROM public.inventory_stock_lot_detail_summary v
          ${whereSql}
          ORDER BY ${safeOrderBy} ${safeSortOrder}${nullsClause}, v.lot_no ASC
          LIMIT $${listParams.length - 1} OFFSET $${listParams.length}
        `,
        listParams
      ),
    ]);

    const rows = rowsResult.rows.map((row) => ({
      ...row,
      current_budget_quota: Number(row.current_budget_quota || 0),
      issued_qty_current_budget_year: Number(row.issued_qty_current_budget_year || 0),
      issue_count: Number(row.issue_count || 0),
      has_issue_history: Number(row.issue_count || 0) > 0,
      last_delivery_note_no:
        row.receipt_type === 'OPENING_BALANCE'
          ? `ยอดยกมา-${(row.receipt_note || '').trim()}`
          : row.delivery_note_no,
    }));

    return apiSuccess(rows, undefined, countResult.rows[0]?.count ?? 0, 200, { page, page_size });
  } catch (error) {
    console.error('Error listing inventory stock lots:', error);
    return apiError('Failed to list inventory stock lots');
  }
}
