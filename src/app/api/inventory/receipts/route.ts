import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { createInventoryReceiptSchema, inventoryReceiptQuerySchema } from '@/lib/validation/schemas';

const RECEIPT_PREFIX = 'RCV';

function buildReceiptNo() {
  return `${RECEIPT_PREFIX}-${new Date().toISOString().replace(/[-:.TZ]/g, '').slice(0, 14)}`;
}

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const queryValidation = validateQuery(inventoryReceiptQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      receipt_type,
      start_date,
      end_date,
      search,
      page = 1,
      page_size = 20,
    } = queryValidation.data;

    const whereClauses: string[] = [];
    const params: Array<string | number> = [];

    if (receipt_type) {
      params.push(receipt_type);
      whereClauses.push(`r.receipt_type = $${params.length}`);
    }

    if (start_date) {
      params.push(start_date);
      whereClauses.push(`r.receipt_date >= $${params.length}`);
    }

    if (end_date) {
      params.push(end_date);
      whereClauses.push(`r.receipt_date <= $${params.length}`);
    }

    if (search?.trim()) {
      params.push(`%${search.trim()}%`);
      const p = `$${params.length}`;
      whereClauses.push(`(
        r.receipt_no ILIKE ${p}
        OR COALESCE(r.delivery_note_no, '') ILIKE ${p}
        OR EXISTS (
          SELECT 1
          FROM public.inventory_receipt_item ri
          INNER JOIN public.product p_item ON p_item.id = ri.product_id
          WHERE ri.receipt_id = r.id
            AND (p_item.code ILIKE ${p} OR p_item.name ILIKE ${p})
        )
      )`);
    }

    const whereSql = whereClauses.length > 0 ? `WHERE ${whereClauses.join(' AND ')}` : '';

    params.push(page_size);
    const limitParam = `$${params.length}`;
    params.push((page - 1) * page_size);
    const offsetParam = `$${params.length}`;

    const rowsResult = await pgQuery(
      `SELECT
         r.id,
         r.receipt_no,
         r.receipt_type,
         r.receipt_date,
         r.delivery_note_no,
         r.note,
         COUNT(ri.id)::int AS item_count,
         COALESCE(SUM(ri.received_qty), 0)::float8 AS total_qty,
         COALESCE(SUM(ri.total_price), 0)::float8 AS total_price,
         r.created_at
       FROM public.inventory_receipt r
       LEFT JOIN public.inventory_receipt_item ri ON ri.receipt_id = r.id
       ${whereSql}
       GROUP BY r.id
       ORDER BY r.receipt_date DESC, r.id DESC
       LIMIT ${limitParam} OFFSET ${offsetParam}`,
      params
    );

    const countResult = await pgQuery<{ count: number }>(
      `SELECT COUNT(*)::int AS count
       FROM public.inventory_receipt r
       ${whereSql}`,
      params.slice(0, params.length - 2)
    );

    return apiSuccess(rowsResult.rows, undefined, countResult.rows[0]?.count ?? 0, 200, { page, page_size });
  } catch (error) {
    console.error('Error listing inventory receipts:', error);
    return apiError('Failed to list inventory receipts');
  }
}

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(createInventoryReceiptSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const { receipt_type, receipt_date, delivery_note_no, note, items } = validation.data;

    await client.query('BEGIN');

    const receiptNo = buildReceiptNo();
    const receiptInsert = await client.query<{
      id: number;
      receipt_no: string;
      receipt_type: string;
      receipt_date: string;
      delivery_note_no: string | null;
    }>(
      `INSERT INTO public.inventory_receipt
         (receipt_no, receipt_type, receipt_date, delivery_note_no, note)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, receipt_no, receipt_type, receipt_date::text, delivery_note_no`,
      [
        receiptNo,
        receipt_type,
        receipt_date,
        receipt_type === 'DELIVERY_NOTE' ? delivery_note_no?.trim() ?? null : null,
        note?.trim() || null,
      ]
    );

    const receipt = receiptInsert.rows[0];

    for (const item of items) {
      const productResult = await client.query<{
        id: number;
        code: string;
        name: string;
      }>(
        `SELECT id, code, name
         FROM public.product
         WHERE code = $1
           AND is_active = true
         LIMIT 1`,
        [item.product_code.trim()]
      );

      const product = productResult.rows[0];
      if (!product) {
        throw new Error(`Product code not found: ${item.product_code}`);
      }

      const qty = Number(item.received_qty);
      const totalPrice = Number(item.total_price);
      const unitPrice = qty === 0 ? 0 : Number((totalPrice / qty).toFixed(4));

      await client.query(
        `INSERT INTO public.inventory_receipt_item
           (receipt_id, product_id, lot_no, received_qty, total_price, unit_price)
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [
          receipt.id,
          product.id,
          item.lot_no.trim(),
          qty,
          totalPrice,
          unitPrice,
        ]
      );

      await client.query(
        `INSERT INTO public.inventory_stock_lot
           (product_id, lot_no, qty_on_hand, total_value)
         VALUES ($1, $2, $3, $4)
         ON CONFLICT (product_id, lot_no)
         DO UPDATE SET
           qty_on_hand = public.inventory_stock_lot.qty_on_hand + EXCLUDED.qty_on_hand,
           total_value = public.inventory_stock_lot.total_value + EXCLUDED.total_value,
           updated_at = now()`,
        [
          product.id,
          item.lot_no.trim(),
          qty,
          totalPrice,
        ]
      );
    }

    await client.query('COMMIT');

    return apiSuccess({
      id: receipt.id,
      receipt_no: receipt.receipt_no,
      receipt_type: receipt.receipt_type,
      receipt_date: receipt.receipt_date,
      delivery_note_no: receipt.delivery_note_no,
    }, 'Inventory receipt created successfully', undefined, 201);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error creating inventory receipt:', error);
    return apiError(error instanceof Error ? error.message : 'Failed to create inventory receipt');
  } finally {
    client.release();
  }
}
