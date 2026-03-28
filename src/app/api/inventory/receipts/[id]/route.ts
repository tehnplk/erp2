import { NextRequest } from 'next/server';
import type { PoolClient } from 'pg';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateInventoryReceiptSchema } from '@/lib/validation/schemas';

type ReceiptItemRow = {
  product_id: number;
  lot_no: string;
  received_qty: number;
  total_price: number;
};

type StockDelta = {
  product_id: number;
  lot_no: string;
  qty_delta: number;
  value_delta: number;
  receipt_date: string;
};

async function applyStockDelta(client: PoolClient, delta: StockDelta) {
  const updateResult = await client.query(
    `UPDATE public.inventory_stock_lot
     SET
       qty_on_hand = qty_on_hand + $3,
       total_value = total_value + $4,
       avg_unit_price = CASE
         WHEN (qty_on_hand + $3) = 0 THEN 0
         ELSE ROUND((total_value + $4) / (qty_on_hand + $3), 4)
       END,
       last_received_at = CASE
         WHEN $3 > 0 THEN GREATEST(last_received_at, $5::date)
         ELSE last_received_at
       END,
       updated_at = now()
     WHERE product_id = $1
       AND lot_no = $2`,
    [delta.product_id, delta.lot_no, delta.qty_delta, delta.value_delta, delta.receipt_date]
  );

  if (updateResult.rowCount === 0) {
    if (delta.qty_delta < 0 || delta.value_delta < 0) {
      throw new Error(`Stock lot not found for reverse: product_id=${delta.product_id}, lot_no=${delta.lot_no}`);
    }

    const unitPrice = delta.qty_delta === 0 ? 0 : Number((delta.value_delta / delta.qty_delta).toFixed(4));
    await client.query(
      `INSERT INTO public.inventory_stock_lot
         (product_id, lot_no, qty_on_hand, total_value, avg_unit_price, last_received_at)
       VALUES ($1, $2, $3, $4, $5, $6)`,
      [delta.product_id, delta.lot_no, delta.qty_delta, delta.value_delta, unitPrice, delta.receipt_date]
    );
  }

  await client.query(
    `DELETE FROM public.inventory_stock_lot
     WHERE product_id = $1
       AND lot_no = $2
       AND qty_on_hand = 0
       AND total_value = 0`,
    [delta.product_id, delta.lot_no]
  );
}

export async function GET(_request: NextRequest, context: { params: Promise<{ id: string }> }) {
  try {
    const params = await context.params;
    const idValidation = idParamSchema.safeParse(params);
    if (!idValidation.success) return apiError('Invalid id parameter', 400);
    const { id } = idValidation.data;

    const receiptResult = await pgQuery<{
      id: number;
      receipt_no: string;
      receipt_type: 'OPENING_BALANCE' | 'DELIVERY_NOTE';
      receipt_date: string;
      delivery_note_no: string | null;
      note: string | null;
      created_at: string;
    }>(
      `SELECT
         id,
         receipt_no,
         receipt_type,
         receipt_date::text,
         delivery_note_no,
         note,
         created_at::text
       FROM public.inventory_receipt
       WHERE id = $1
       LIMIT 1`,
      [id]
    );

    const receipt = receiptResult.rows[0];
    if (!receipt) {
      return apiError('Receipt not found', 404);
    }

    const itemsResult = await pgQuery<{
      id: number;
      product_id: number;
      product_code: string;
      product_name: string;
      product_unit: string | null;
      lot_no: string;
      received_qty: number;
      total_price: number;
      unit_price: number;
    }>(
      `SELECT
         ri.id,
         ri.product_id,
         p.code AS product_code,
         p.name AS product_name,
         p.unit AS product_unit,
         ri.lot_no,
         ri.received_qty::float8,
         ri.total_price::float8,
         ri.unit_price::float8
       FROM public.inventory_receipt_item ri
       INNER JOIN public.product p ON p.id = ri.product_id
       WHERE ri.receipt_id = $1
       ORDER BY ri.id ASC`,
      [id]
    );

    return apiSuccess({
      receipt,
      items: itemsResult.rows,
    });
  } catch (error) {
    console.error('Error loading inventory receipt detail:', error);
    return apiError('Failed to load inventory receipt detail');
  }
}

export async function PUT(request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const client = await pgPool.connect();

  try {
    const params = await context.params;
    const idValidation = idParamSchema.safeParse(params);
    if (!idValidation.success) return apiError('Invalid id parameter', 400);
    const { id } = idValidation.data;

    const body = await request.json();
    const validation = await validateRequest(updateInventoryReceiptSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const { receipt_type, receipt_date, delivery_note_no, note, items } = validation.data;

    await client.query('BEGIN');

    const receiptResult = await client.query<{ id: number }>(
      `SELECT id
       FROM public.inventory_receipt
       WHERE id = $1
       FOR UPDATE`,
      [id]
    );
    if (receiptResult.rowCount === 0) {
      throw new Error('Receipt not found');
    }

    const oldItemsResult = await client.query<ReceiptItemRow>(
      `SELECT product_id, lot_no, received_qty::float8, total_price::float8
       FROM public.inventory_receipt_item
       WHERE receipt_id = $1`,
      [id]
    );

    for (const oldItem of oldItemsResult.rows) {
      await applyStockDelta(client, {
        product_id: oldItem.product_id,
        lot_no: oldItem.lot_no,
        qty_delta: -Number(oldItem.received_qty),
        value_delta: -Number(oldItem.total_price),
        receipt_date,
      });
    }

    await client.query(`DELETE FROM public.inventory_receipt_item WHERE receipt_id = $1`, [id]);

    await client.query(
      `UPDATE public.inventory_receipt
       SET
         receipt_type = $2,
         receipt_date = $3,
         delivery_note_no = $4,
         note = $5,
         updated_at = now()
       WHERE id = $1`,
      [
        id,
        receipt_type,
        receipt_date,
        receipt_type === 'DELIVERY_NOTE' ? delivery_note_no?.trim() ?? null : null,
        note?.trim() || null,
      ]
    );

    for (const item of items) {
      const productResult = await client.query<{ id: number }>(
        `SELECT id
         FROM public.product
         WHERE code = $1
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
        [id, product.id, item.lot_no.trim(), qty, totalPrice, unitPrice]
      );

      await applyStockDelta(client, {
        product_id: product.id,
        lot_no: item.lot_no.trim(),
        qty_delta: qty,
        value_delta: totalPrice,
        receipt_date,
      });
    }

    await client.query('COMMIT');
    return apiSuccess({ id }, 'Inventory receipt updated successfully');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error updating inventory receipt:', error);
    return apiError(error instanceof Error ? error.message : 'Failed to update inventory receipt');
  } finally {
    client.release();
  }
}

export async function DELETE(_request: NextRequest, context: { params: Promise<{ id: string }> }) {
  const client = await pgPool.connect();

  try {
    const params = await context.params;
    const idValidation = idParamSchema.safeParse(params);
    if (!idValidation.success) return apiError('Invalid id parameter', 400);
    const { id } = idValidation.data;

    await client.query('BEGIN');

    const receiptResult = await client.query<{ id: number; receipt_date: string }>(
      `SELECT id, receipt_date::text
       FROM public.inventory_receipt
       WHERE id = $1
       FOR UPDATE`,
      [id]
    );
    const receipt = receiptResult.rows[0];
    if (!receipt) {
      throw new Error('Receipt not found');
    }

    const oldItemsResult = await client.query<ReceiptItemRow>(
      `SELECT product_id, lot_no, received_qty::float8, total_price::float8
       FROM public.inventory_receipt_item
       WHERE receipt_id = $1`,
      [id]
    );

    for (const oldItem of oldItemsResult.rows) {
      await applyStockDelta(client, {
        product_id: oldItem.product_id,
        lot_no: oldItem.lot_no,
        qty_delta: -Number(oldItem.received_qty),
        value_delta: -Number(oldItem.total_price),
        receipt_date: receipt.receipt_date,
      });
    }

    await client.query(`DELETE FROM public.inventory_receipt_item WHERE receipt_id = $1`, [id]);
    await client.query(`DELETE FROM public.inventory_receipt WHERE id = $1`, [id]);

    await client.query('COMMIT');
    return apiSuccess({ id }, 'Inventory receipt deleted successfully');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error deleting inventory receipt:', error);
    return apiError(error instanceof Error ? error.message : 'Failed to delete inventory receipt');
  } finally {
    client.release();
  }
}
