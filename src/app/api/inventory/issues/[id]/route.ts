import { NextRequest } from 'next/server';
import { PoolClient } from 'pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { pgPool, pgQuery } from '@/lib/pg';
import { createInventoryIssueSchema, idParamSchema } from '@/lib/validation/schemas';

function getCurrentBudgetYear() {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
}

async function restoreStockLot(client: PoolClient, stockLotId: number, qty: number, totalValue: number) {
  const lotResult = await client.query<{
    id: number;
    qty_on_hand: string | number;
    total_value: string | number;
  }>(
    `
      SELECT id, qty_on_hand::float8 AS qty_on_hand, total_value::float8 AS total_value
      FROM public.inventory_stock_lot
      WHERE id = $1
      FOR UPDATE
    `,
    [stockLotId]
  );

  const lot = lotResult.rows[0];
  if (!lot) {
    throw new Error(`Stock lot not found: ${stockLotId}`);
  }

  await client.query(
    `
      UPDATE public.inventory_stock_lot
      SET
        qty_on_hand = qty_on_hand + $2,
        total_value = total_value + $3,
        updated_at = now()
      WHERE id = $1
    `,
    [stockLotId, qty, totalValue]
  );
}

async function reduceStockLot(client: PoolClient, stockLotId: number, qty: number) {
  const lotResult = await client.query<{
    id: number;
    qty_on_hand: string | number;
    total_value: string | number;
    avg_unit_price: string | number;
  }>(
    `
      SELECT
        id,
        qty_on_hand::float8 AS qty_on_hand,
        total_value::float8 AS total_value,
        CASE
          WHEN qty_on_hand <= 0 THEN 0
          ELSE ROUND(total_value / qty_on_hand, 4)
        END::float8 AS avg_unit_price
      FROM public.inventory_stock_lot
      WHERE id = $1
      FOR UPDATE
    `,
    [stockLotId]
  );

  const lot = lotResult.rows[0];
  if (!lot) {
    throw new Error(`Stock lot not found: ${stockLotId}`);
  }

  const availableQty = Number(lot.qty_on_hand);
  if (availableQty < qty) {
    throw new Error(`ไม่สามารถเบิกเกินคงเหลือของล็อต ${stockLotId}`);
  }

  const unitPrice = Number(lot.avg_unit_price || 0);
  const lineValue = Number((qty * unitPrice).toFixed(2));

  const updateResult = await client.query(
    `
      UPDATE public.inventory_stock_lot
      SET
        qty_on_hand = qty_on_hand - $2,
        total_value = GREATEST(total_value - $3, 0),
        updated_at = now()
      WHERE id = $1
        AND qty_on_hand >= $2
      RETURNING id
    `,
    [stockLotId, qty, lineValue]
  );

  if (updateResult.rowCount === 0) {
    throw new Error(`ไม่สามารถอัปเดตล็อต ${stockLotId} ได้`);
  }

  return { unitPrice, lineValue };
}

export async function GET(_request: NextRequest, context: { params: Promise<{ id: string }> }) {
  try {
    const params = await context.params;
    const idValidation = idParamSchema.safeParse(params);
    if (!idValidation.success) return apiError('Invalid id parameter', 400);

    const { id } = idValidation.data;

    const currentBudgetYear = getCurrentBudgetYear();

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
          COALESCE((
            SELECT SUM(COALESCE(up.approved_quota, 0))::int
            FROM public.usage_plan up
            WHERE up.requesting_dept_code = $2
              AND up.product_code = p.code
              AND up.budget_year = $3
          ), 0)::int AS current_budget_quota,
          COALESCE((
            SELECT SUM(iit2.issued_qty)::int
            FROM public.inventory_issue_item iit2
            INNER JOIN public.inventory_issue ii2 ON ii2.id = iit2.issue_id
            INNER JOIN public.inventory_stock_lot isl2 ON isl2.id = iit2.stock_lot_id
            WHERE ii2.requesting_department_id = $4
              AND isl2.product_id = p.id
              AND (
                CASE
                  WHEN EXTRACT(MONTH FROM ii2.issue_date) >= 10
                    THEN EXTRACT(YEAR FROM ii2.issue_date)::int + 544
                  ELSE EXTRACT(YEAR FROM ii2.issue_date)::int + 543
                END
              ) = $3
          ), 0)::int AS issued_qty_current_budget_year,
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
      [id, issue.department_code, currentBudgetYear, issue.requesting_department_id]
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
    const { issue_date, requesting_department_id, note, items } = validation.data;

    await client.query('BEGIN');

    const issueResult = await client.query<{
      id: number;
      issue_no: string;
    }>(
      `
        SELECT id, issue_no
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
      await restoreStockLot(client, Number(item.stock_lot_id), Number(item.issued_qty), Number(item.total_value));
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
      [id, issue_date, requesting_department_id, note?.trim() || null]
    );

    if (updateIssueResult.rowCount === 0) {
      throw new Error('Failed to update issue header');
    }

    const insertedItems: Array<{ stock_lot_id: number; issued_qty: number; unit_price: number; total_value: number }> = [];
    for (const item of items) {
      const qty = Number(item.issued_qty);
      const reduced = await reduceStockLot(client, Number(item.stock_lot_id), qty);
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
    await client.query('ROLLBACK');
    console.error('Error updating inventory issue:', error);
    return apiError(error instanceof Error ? error.message : 'Failed to update inventory issue');
  } finally {
    client.release();
  }
}
