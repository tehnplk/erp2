import { NextRequest } from 'next/server';
import type { PoolClient } from 'pg';
import { pgPool } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateInventoryReceiptItemSchema } from '@/lib/validation/schemas';

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

export async function PUT(request: NextRequest, context: { params: Promise<{ itemId: string }> }) {
  const client = await pgPool.connect();

  try {
    const params = await context.params;
    const idValidation = idParamSchema.safeParse({ id: params.itemId });
    if (!idValidation.success) return apiError('Invalid item id parameter', 400);
    const { id } = idValidation.data;

    const body = await request.json();
    const validation = await validateRequest(updateInventoryReceiptItemSchema, body);
    if (!validation.success) return validation.error;

    const { receipt_type, receipt_date, delivery_note_no, note, product_code, lot_no, received_qty, total_price } = validation.data;

    await client.query('BEGIN');

    const currentItemResult = await client.query<{
      receipt_item_id: number;
      receipt_id: number;
      old_product_id: number;
      old_lot_no: string;
      old_received_qty: number;
      old_total_price: number;
    }>(
      `SELECT
         ri.id AS receipt_item_id,
         ri.receipt_id,
         ri.product_id AS old_product_id,
         ri.lot_no AS old_lot_no,
         ri.received_qty::float8 AS old_received_qty,
         ri.total_price::float8 AS old_total_price
       FROM public.inventory_receipt_item ri
       WHERE ri.id = $1
       FOR UPDATE`,
      [id]
    );

    const currentItem = currentItemResult.rows[0];
    if (!currentItem) {
      throw new Error('Receipt item not found');
    }

    const productResult = await client.query<{ id: number }>(
      `SELECT id
       FROM public.product
       WHERE code = $1
         AND is_active = true
       LIMIT 1`,
      [product_code.trim()]
    );

    const product = productResult.rows[0];
    if (!product) {
      throw new Error(`Product code not found: ${product_code}`);
    }

    await applyStockDelta(client, {
      product_id: currentItem.old_product_id,
      lot_no: currentItem.old_lot_no,
      qty_delta: -Number(currentItem.old_received_qty),
      value_delta: -Number(currentItem.old_total_price),
      receipt_date,
    });

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
        currentItem.receipt_id,
        receipt_type,
        receipt_date,
        receipt_type === 'DELIVERY_NOTE' ? delivery_note_no?.trim() ?? null : null,
        note?.trim() || null,
      ]
    );

    const unitPrice = Number(received_qty) === 0 ? 0 : Number((Number(total_price) / Number(received_qty)).toFixed(4));

    await client.query(
      `UPDATE public.inventory_receipt_item
       SET
         product_id = $2,
         lot_no = $3,
         received_qty = $4,
         total_price = $5,
         unit_price = $6
       WHERE id = $1`,
      [id, product.id, lot_no.trim(), Number(received_qty), Number(total_price), unitPrice]
    );

    await applyStockDelta(client, {
      product_id: product.id,
      lot_no: lot_no.trim(),
      qty_delta: Number(received_qty),
      value_delta: Number(total_price),
      receipt_date,
    });

    await client.query('COMMIT');

    return apiSuccess({ id, receipt_id: currentItem.receipt_id }, 'Inventory receipt item updated successfully');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error updating inventory receipt item:', error);
    return apiError(error instanceof Error ? error.message : 'Failed to update inventory receipt item');
  } finally {
    client.release();
  }
}

export async function DELETE(_request: NextRequest, context: { params: Promise<{ itemId: string }> }) {
  const client = await pgPool.connect();

  try {
    const params = await context.params;
    const idValidation = idParamSchema.safeParse({ id: params.itemId });
    if (!idValidation.success) return apiError('Invalid item id parameter', 400);
    const { id } = idValidation.data;

    await client.query('BEGIN');

    const itemResult = await client.query<{
      receipt_item_id: number;
      receipt_id: number;
      receipt_date: string;
      product_id: number;
      product_code: string;
      product_name: string;
      lot_no: string;
      received_qty: number;
      total_price: number;
      remaining_item_count: number;
    }>(
      `SELECT
         ri.id AS receipt_item_id,
         ri.receipt_id,
         r.receipt_date::text,
         ri.product_id,
         p.code AS product_code,
         p.name AS product_name,
         ri.lot_no,
         ri.received_qty::float8 AS received_qty,
         ri.total_price::float8 AS total_price,
         (
           SELECT COUNT(*)::int
           FROM public.inventory_receipt_item sibling
           WHERE sibling.receipt_id = ri.receipt_id
         ) AS remaining_item_count
       FROM public.inventory_receipt_item ri
       INNER JOIN public.inventory_receipt r ON r.id = ri.receipt_id
       INNER JOIN public.product p ON p.id = ri.product_id
       WHERE ri.id = $1
       FOR UPDATE`,
      [id]
    );

    const item = itemResult.rows[0];
    if (!item) {
      throw new Error('Receipt item not found');
    }

    await applyStockDelta(client, {
      product_id: item.product_id,
      lot_no: item.lot_no,
      qty_delta: -Number(item.received_qty),
      value_delta: -Number(item.total_price),
      receipt_date: item.receipt_date,
    });

    await client.query(`DELETE FROM public.inventory_receipt_item WHERE id = $1`, [id]);

    if (Number(item.remaining_item_count) <= 1) {
      await client.query(`DELETE FROM public.inventory_receipt WHERE id = $1`, [item.receipt_id]);
    }

    await client.query('COMMIT');

    return apiSuccess(
      {
        id,
        receipt_id: item.receipt_id,
        product_code: item.product_code,
        product_name: item.product_name,
        lot_no: item.lot_no,
        received_qty: Number(item.received_qty),
      },
      'Inventory receipt item deleted successfully'
    );
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error deleting inventory receipt item:', error);
    return apiError(error instanceof Error ? error.message : 'Failed to delete inventory receipt item');
  } finally {
    client.release();
  }
}
