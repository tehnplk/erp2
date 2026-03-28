import { NextRequest } from 'next/server';
import { PoolClient } from 'pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { pgPool, pgQuery } from '@/lib/pg';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { createInventoryIssueSchema, inventoryIssueQuerySchema } from '@/lib/validation/schemas';

const ISSUE_PREFIX = 'ISS';

function buildIssueNo() {
  return `${ISSUE_PREFIX}-${new Date().toISOString().replace(/[-:.TZ]/g, '').slice(0, 14)}`;
}

async function reduceStockLot(client: PoolClient, stockLotId: number, qty: number) {
  const lotResult = await client.query<{
    id: number;
    qty_on_hand: string | number;
    total_value: string | number;
    avg_unit_price: string | number;
  }>(
    `
      SELECT id, qty_on_hand::float8 AS qty_on_hand, total_value::float8 AS total_value, avg_unit_price::float8 AS avg_unit_price
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
        avg_unit_price = CASE
          WHEN (qty_on_hand - $2) <= 0 THEN 0
          ELSE ROUND(GREATEST(total_value - $3, 0) / (qty_on_hand - $2), 4)
        END,
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

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryIssueQuerySchema, searchParams);
    if (!queryValidation.success) return queryValidation.error;

    const {
      search,
      page = 1,
      page_size = 20,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: Array<string | number> = [];

    if (search?.trim()) {
      params.push(`%${search.trim()}%`);
      const p = `$${params.length}`;
      whereClauses.push(`(
        ii.issue_no ILIKE ${p}
        OR COALESCE(ii.note, '') ILIKE ${p}
        OR EXISTS (
          SELECT 1
          FROM public.inventory_issue_item iit
          INNER JOIN public.inventory_stock_lot isl ON isl.id = iit.stock_lot_id
          INNER JOIN public.product p_item ON p_item.id = isl.product_id
          WHERE iit.issue_id = ii.id
            AND (p_item.code ILIKE ${p} OR p_item.name ILIKE ${p} OR isl.lot_no ILIKE ${p})
        )
      )`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const offset = (page - 1) * page_size;

    const [countResult, rowsResult] = await Promise.all([
      pgQuery<{ count: number }>(
        `
          SELECT COUNT(*)::int AS count
          FROM public.inventory_issue ii
          INNER JOIN public.department d ON d.id = ii.requesting_department_id
          ${whereSql}
        `,
        params
      ),
      pgQuery<{
        id: number;
        issue_no: string;
        issue_date: string;
        requesting_department_id: number;
        department_name: string;
        department_code: string;
        note: string | null;
        total_items: number;
        total_qty: string | number;
        total_value: string | number;
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
            ii.total_items,
            ii.total_qty::float8 AS total_qty,
            COALESCE(SUM(iit.total_value), 0)::float8 AS total_value,
            ii.created_at::text
          FROM public.inventory_issue ii
          INNER JOIN public.department d ON d.id = ii.requesting_department_id
          LEFT JOIN public.inventory_issue_item iit ON iit.issue_id = ii.id
          ${whereSql}
          GROUP BY ii.id, d.name, d.department_code
          ORDER BY ii.issue_date DESC, ii.id DESC
          LIMIT $${params.length + 1} OFFSET $${params.length + 2}
        `,
        [...params, page_size, offset]
      ),
    ]);

    return apiSuccess(rowsResult.rows, undefined, countResult.rows[0]?.count ?? 0, 200, { page, page_size });
  } catch (error) {
    console.error('Error listing inventory issues:', error);
    return apiError('Failed to list inventory issues');
  }
}

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(createInventoryIssueSchema, body);
    if (!validation.success) return validation.error;

    const { issue_date, requesting_department_id, note, items } = validation.data;

    await client.query('BEGIN');

    const issueInsert = await client.query<{ id: number; issue_no: string }>(
      `
        INSERT INTO public.inventory_issue (issue_no, issue_date, requesting_department_id, note)
        VALUES ($1, $2, $3, $4)
        RETURNING id, issue_no
      `,
      [buildIssueNo(), issue_date, requesting_department_id, note?.trim() || null]
    );

    const issue = issueInsert.rows[0];
    for (const item of items) {
      const qty = Number(item.issued_qty);
      const reduced = await reduceStockLot(client, Number(item.stock_lot_id), qty);

      await client.query(
        `
          INSERT INTO public.inventory_issue_item
            (issue_id, stock_lot_id, issued_qty, unit_price, total_value)
          VALUES ($1, $2, $3, $4, $5)
        `,
        [
          issue.id,
          Number(item.stock_lot_id),
          qty,
          reduced.unitPrice,
          reduced.lineValue,
        ]
      );
    }

    await client.query('COMMIT');

    return apiSuccess(
      {
        id: issue.id,
        issue_no: issue.issue_no,
      },
      'Inventory issue created successfully',
      undefined,
      201
    );
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error creating inventory issue:', error);
    return apiError(error instanceof Error ? error.message : 'Failed to create inventory issue');
  } finally {
    client.release();
  }
}
