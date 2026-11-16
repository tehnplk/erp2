import { NextRequest } from 'next/server';
import { apiError, apiSuccess } from '@/lib/api-response';
import { getConfiguredBudgetYear } from '@/lib/budget-year';
import {
  InventoryIssueRuleError,
  quotaUsageColumnsSql,
  reduceStockLot,
  restoreStockLot,
  validateIssueQuota,
} from '@/lib/inventory-issue';
import { pgPool, pgQuery } from '@/lib/pg';
import { createInventoryIssueSchema, idParamSchema } from '@/lib/validation/schemas';

export async function GET(_request: NextRequest, context: { params: Promise<{ id: string }> }) {
  try {
    const params = await context.params;
    const idValidation = idParamSchema.safeParse(params);
    if (!idValidation.success) return apiError('Invalid id parameter', 400);

    const { id } = idValidation.data;

    const currentBudgetYear = await getConfiguredBudgetYear(pgQuery);

    const issueResult = await pgQuery<{
      id: number;
      issue_no: string;
      issue_date: string;
      requesting_department_id: number;
      department_name: string;
      department_code: string;
      note: string | null;
      total_items: number;
      total_qty: string | number;
      created_at: string;
    }>(
      `
        SELECT
          ii.id,
          ii.issue_no,
          ii.issue_date::text,
          ii.requesting_department_id,
          d.name AS department_name,
          d.department_code,
          ii.note,
          COUNT(iit.id)::int AS total_items,
          COALESCE(SUM(iit.issued_qty), 0)::float8 AS total_qty,
          ii.created_at::text
        FROM public.inventory_issue ii
        INNER JOIN public.department d ON d.id = ii.requesting_department_id
        LEFT JOIN public.inventory_issue_item iit ON iit.issue_id = ii.id
        WHERE ii.id = $1
        GROUP BY ii.id, d.name, d.department_code
        LIMIT 1
      `,
      [id]
    );

    const issue = issueResult.rows[0];
    if (!issue) return apiError('Issue not found', 404);

    const itemsResult = await pgQuery<{
      id: number;
      stock_lot_id: number;
      issued_qty: string | number;
      unit_price: string | number;
      total_value: string | number;
      product_id: number;
      product_code: string;
      product_name: string;
      category: string | null;
      product_type: string | null;
      product_subtype: string | null;
      unit: string | null;
      lot_no: string;
      qty_on_hand: string | number;
      last_received_at: string | null;
      current_budget_quota: string | number;
      issued_qty_current_budget_year: string | number;
    }>(
      `
        SELECT
          iit.id,
          iit.stock_lot_id,
          iit.issued_qty::float8 AS issued_qty,
          iit.unit_price::float8 AS unit_price,
          iit.total_value::float8 AS total_value,
          p.id AS product_id,
          p.code AS product_code,
          p.name AS product_name,
          p.category,
          p.type AS product_type,
          p.subtype AS product_subtype,
          p.unit,
          isl.lot_no,
          isl.qty_on_hand::float8 AS qty_on_hand,
          ${quotaUsageColumnsSql({ departmentId: '$3', productCode: 'p.code', productId: 'p.id', budgetYear: '$2' })},
          (
            SELECT MAX(r.receipt_date)
            FROM public.inventory_receipt_item ri
            INNER JOIN public.inventory_receipt r ON r.id = ri.receipt_id
            WHERE ri.product_id = isl.product_id
              AND ri.lot_no = isl.lot_no
          ) AS last_received_at
        FROM public.inventory_issue_item iit
        INNER JOIN public.inventory_stock_lot isl ON isl.id = iit.stock_lot_id
        INNER JOIN public.product p ON p.id = isl.product_id
        WHERE iit.issue_id = $1
        ORDER BY iit.id ASC
      `,
      [id, currentBudgetYear, issue.requesting_department_id]
    );

    return apiSuccess({
      issue,
      items: itemsResult.rows,
    });
  } catch (error) {
    console.error('Error loading inventory issue detail:', error);
    return apiError('Failed to load inventory issue detail');
  }
}

export async function PUT(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const client = await pgPool.connect();
  const query = (text: string, params?: unknown[]) => client.query(text, params);
  let inTransaction = false;

  try {
    const params = await context.params;
    const idValidation = idParamSchema.safeParse(params);
    if (!idValidation.success) return apiError('Invalid id parameter', 400);

    const body = await request.json();
    const validation = await createInventoryIssueSchema.safeParseAsync(body);
    if (!validation.success) {
      const errorMessage = validation.error.issues.map((issue) => `${issue.path.join('.')}: ${issue.message}`).join(', ');
      return apiError(errorMessage, 400);
    }

    const { id } = idValidation.data;
    const { issue_date, note, items } = validation.data;

    await client.query('BEGIN');
    inTransaction = true;

    const issueResult = await client.query<{
      id: number;
      issue_no: string;
      requesting_department_id: number;
    }>(
      `
        SELECT id, issue_no, requesting_department_id
        FROM public.inventory_issue
        WHERE id = $1
        FOR UPDATE
      `,
      [id]
    );

    const issue = issueResult.rows[0];
    if (!issue) {
      await client.query('ROLLBACK');
      return apiError('Issue not found', 404);
    }

    const lockedRequestingDepartmentId = issue.requesting_department_id;
    await validateIssueQuota(query, {
      requestingDepartmentId: lockedRequestingDepartmentId,
      issueDate: issue_date,
      items: items.map((item) => ({ stock_lot_id: Number(item.stock_lot_id), issued_qty: Number(item.issued_qty) })),
      excludeIssueId: id,
    });

    const currentItemsResult = await client.query<{
      id: number;
      stock_lot_id: number;
      issued_qty: string | number;
      total_value: string | number;
      product_code: string;
      product_name: string;
    }>(
      `
        SELECT
          iit.id,
          iit.stock_lot_id,
          iit.issued_qty::float8 AS issued_qty,
          iit.total_value::float8 AS total_value,
          p.code AS product_code,
          p.name AS product_name
        FROM public.inventory_issue_item iit
        INNER JOIN public.inventory_stock_lot isl ON isl.id = iit.stock_lot_id
        INNER JOIN public.product p ON p.id = isl.product_id
        WHERE iit.issue_id = $1
        ORDER BY iit.id ASC
        FOR UPDATE OF iit, isl
      `,
      [id]
    );

    const currentItems = currentItemsResult.rows;
    for (const item of currentItems) {
      await restoreStockLot(query, Number(item.stock_lot_id), Number(item.issued_qty), Number(item.total_value));
    }

    await client.query(`DELETE FROM public.inventory_issue_item WHERE issue_id = $1`, [id]);

    const updateIssueResult = await client.query(
      `
        UPDATE public.inventory_issue
        SET issue_date = $2,
            requesting_department_id = $3,
            note = $4,
            updated_at = now()
        WHERE id = $1
      `,
      [id, issue_date, lockedRequestingDepartmentId, note?.trim() || null]
    );

    if (updateIssueResult.rowCount === 0) {
      throw new Error('Failed to update issue header');
    }

    const insertedItems: Array<{ stock_lot_id: number; issued_qty: number; unit_price: number; total_value: number }> = [];
    for (const item of items) {
      const qty = Number(item.issued_qty);
      const reduced = await reduceStockLot(query, Number(item.stock_lot_id), qty);
      insertedItems.push({
        stock_lot_id: Number(item.stock_lot_id),
        issued_qty: qty,
        unit_price: reduced.unitPrice,
        total_value: reduced.lineValue,
      });

      await client.query(
        `
          INSERT INTO public.inventory_issue_item
            (issue_id, stock_lot_id, issued_qty, unit_price, total_value)
          VALUES ($1, $2, $3, $4, $5)
        `,
        [id, Number(item.stock_lot_id), qty, reduced.unitPrice, reduced.lineValue]
      );
    }

    await client.query('COMMIT');

    const currentByLot = new Map<number, { qty: number; product_code: string; product_name: string }>();
    for (const item of currentItems) {
      const existing = currentByLot.get(Number(item.stock_lot_id));
      currentByLot.set(Number(item.stock_lot_id), {
        qty: (existing?.qty ?? 0) + Number(item.issued_qty),
        product_code: item.product_code,
        product_name: item.product_name,
      });
    }

    const nextByLot = new Map<number, { qty: number }>();
    for (const item of insertedItems) {
      const existing = nextByLot.get(item.stock_lot_id);
      nextByLot.set(item.stock_lot_id, { qty: (existing?.qty ?? 0) + item.issued_qty });
    }

    const restoredMessages: string[] = [];
    for (const [stockLotId, current] of currentByLot.entries()) {
      const nextQty = nextByLot.get(stockLotId)?.qty ?? 0;
      const returnedQty = Math.max(current.qty - nextQty, 0);
      if (returnedQty > 0) {
        restoredMessages.push(`นำรายการสินค้า ${current.product_name} (${current.product_code}) กลับเข้าคลัง ${returnedQty} หน่วย`);
      }
    }

    return apiSuccess(
      {
        id,
        issue_no: issue.issue_no,
        restored_items: restoredMessages,
      },
      restoredMessages.length > 0
        ? restoredMessages.join(', ')
        : 'บันทึกการแก้ไขใบเบิกจ่ายสำเร็จ',
    );
  } catch (error) {
    if (inTransaction) await client.query('ROLLBACK');
    console.error('Error updating inventory issue:', error);
    return apiError(
      error instanceof Error ? error.message : 'Failed to update inventory issue',
      error instanceof InventoryIssueRuleError ? 400 : 500
    );
  } finally {
    client.release();
  }
}
