import { NextRequest } from 'next/server';
import { pgPool } from '@/lib/pg';
import { apiConflict, apiError, apiNotFound, apiSuccess } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { createInventoryReceiptFromPurchaseApprovalSchema } from '@/lib/validation/schemas';
import { cacheDelByPattern } from '@/lib/redis';

const DEFAULT_RECEIPT_PREFIX = 'IR';

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(createInventoryReceiptFromPurchaseApprovalSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const {
      purchase_approval_id,
      warehouse_id,
      location_id,
      qty,
      unit_cost,
      vendor_name,
      receipt_date,
      receipt_no,
      lot_no,
      expiry_date,
      note,
      created_by,
    } = validation.data;

    await client.query('BEGIN');

    const purchaseApprovalResult = await client.query(
      `SELECT
        pa.id,
        pa.department,
        pa.budget_year,
        pa.record_number,
        pa.request_date,
        pa.product_code,
        pa.product_name,
        pa.category,
        pa.product_type,
        pa.product_subtype,
        pa.requested_quantity,
        pa.unit,
        pa.price_per_unit::float8 AS price_per_unit,
        link.inventory_receipt_status,
        link.received_qty
      FROM public.purchase_approval pa
      INNER JOIN public.purchase_approval_inventory_link link ON link.purchase_approval_id = pa.id
      WHERE pa.id = $1
      FOR UPDATE`,
      [purchase_approval_id]
    );

    if (purchaseApprovalResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return apiNotFound('Purchase approval');
    }

    const purchaseApproval = purchaseApprovalResult.rows[0];
    const requestedQuantity = Number(purchaseApproval.requested_quantity || 0);
    const receivedQty = Number(purchaseApproval.received_qty || 0);
    const remainingQty = Math.max(requestedQuantity - receivedQty, 0);

    if (remainingQty <= 0) {
      await client.query('ROLLBACK');
      return apiConflict('Purchase approval has already been fully received');
    }

    if (qty > remainingQty) {
      await client.query('ROLLBACK');
      return apiConflict(`Receive quantity exceeds remaining quantity (${remainingQty})`);
    }

    const resolvedUnitCost = unit_cost ?? Number(purchaseApproval.price_per_unit || 0);
    const resolvedReceiptNo = receipt_no || `${DEFAULT_RECEIPT_PREFIX}-${Date.now()}`;
    const resolvedReceiptDate = receipt_date || new Date().toISOString();

    const warehouseResult = await client.query(
      `SELECT id FROM public.inventory_warehouse WHERE id = $1 LIMIT 1`,
      [warehouse_id]
    );

    if (warehouseResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return apiNotFound('Inventory warehouse');
    }

    const inventoryItemResult = await client.query(
      `SELECT id, standard_cost
       FROM public.inventory_item
       WHERE product_code = $1
         AND warehouse_id = $2
         AND COALESCE(location_id, 0) = COALESCE($3, 0)
         AND COALESCE(lot_no, '') = COALESCE($4, '')
       LIMIT 1`,
      [purchaseApproval.product_code, warehouse_id, location_id ?? null, lot_no ?? null]
    );

    let inventoryItemId: number;

    if (inventoryItemResult.rows.length > 0) {
      inventoryItemId = inventoryItemResult.rows[0].id;
    } else {
      const insertedInventoryItem = await client.query(
        `INSERT INTO public.inventory_item
          (product_code, product_name, category, product_type, product_subtype, unit, warehouse_id, location_id, lot_no, expiry_date, standard_cost)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
         RETURNING id`,
        [
          purchaseApproval.product_code,
          purchaseApproval.product_name,
          purchaseApproval.category,
          purchaseApproval.product_type,
          purchaseApproval.product_subtype,
          purchaseApproval.unit,
          warehouse_id,
          location_id ?? null,
          lot_no ?? null,
          expiry_date || null,
          resolvedUnitCost,
        ]
      );
      inventoryItemId = insertedInventoryItem.rows[0].id;

      await client.query(
        `INSERT INTO public.inventory_balance (inventory_item_id, on_hand_qty, reserved_qty, available_qty, avg_cost)
         VALUES ($1, 0, 0, 0, $2)
         ON CONFLICT (inventory_item_id) DO NOTHING`,
        [inventoryItemId, resolvedUnitCost]
      );
    }

    const receiptResult = await client.query(
      `INSERT INTO public.inventory_receipt
        (receipt_no, receipt_date, receipt_type, status, vendor_name, source_reference_type, source_reference_id, source_reference_no, note, created_by)
       VALUES ($1, $2, 'FROM_PURCHASE_APPROVAL', 'POSTED', $3, 'PurchaseApproval', $4, $5, $6, $7)
       RETURNING id, receipt_no, receipt_date`,
      [
        resolvedReceiptNo,
        resolvedReceiptDate,
        vendor_name || null,
        purchase_approval_id,
        purchaseApproval.record_number || purchaseApproval.id,
        note || null,
        created_by || null,
      ]
    );

    const receipt = receiptResult.rows[0];

    await client.query(
      `INSERT INTO public.inventory_receipt_item
        (receipt_id, inventory_item_id, purchase_approval_id, qty, unit_cost, total_cost, lot_no, expiry_date)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [receipt.id, inventoryItemId, purchase_approval_id, qty, resolvedUnitCost, qty * resolvedUnitCost, lot_no || null, expiry_date || null]
    );

    const balanceResult = await client.query(
      `SELECT id, on_hand_qty, reserved_qty, available_qty, avg_cost
       FROM public.inventory_balance
       WHERE inventory_item_id = $1
       FOR UPDATE`,
      [inventoryItemId]
    );

    const balanceRow = balanceResult.rows[0];
    const currentOnHandQty = Number(balanceRow?.on_hand_qty || 0);
    const currentReservedQty = Number(balanceRow?.reserved_qty || 0);
    const currentAvailableQty = Number(balanceRow?.available_qty || 0);
    const currentAvgCost = Number(balanceRow?.avg_cost || 0);
    const newOnHandQty = currentOnHandQty + qty;
    const newAvailableQty = currentAvailableQty + qty;
    const newAvgCost = newOnHandQty === 0
      ? resolvedUnitCost
      : Number((((currentOnHandQty * currentAvgCost) + (qty * resolvedUnitCost)) / newOnHandQty).toFixed(2));

    await client.query(
      `UPDATE public.inventory_balance
       SET on_hand_qty = $2,
           reserved_qty = $3,
           available_qty = $4,
           avg_cost = $5,
           last_movement_at = CURRENT_TIMESTAMP,
           updated_at = CURRENT_TIMESTAMP
       WHERE inventory_item_id = $1`,
      [inventoryItemId, newOnHandQty, currentReservedQty, newAvailableQty, newAvgCost]
    );

    await client.query(
      `INSERT INTO public.inventory_movement
        (inventory_item_id, movement_date, movement_type, qty_in, qty_out, unit_cost, total_cost, balance_qty_after, balance_value_after, reference_type, reference_id, reference_no, source_department, note, created_by)
       VALUES ($1, $2, 'PURCHASE_APPROVAL_RECEIPT', $3, 0, $4, $5, $6, $7, 'InventoryReceipt', $8, $9, $10, $11, $12)`,
      [
        inventoryItemId,
        resolvedReceiptDate,
        qty,
        resolvedUnitCost,
        qty * resolvedUnitCost,
        newOnHandQty,
        Number((newOnHandQty * newAvgCost).toFixed(2)),
        receipt.id,
        receipt.receipt_no,
        purchaseApproval.department || null,
        note || null,
        created_by || null,
      ]
    );

    const nextReceivedQty = receivedQty + qty;
    const nextStatus = nextReceivedQty >= requestedQuantity ? 'RECEIVED' : 'PARTIAL';

    await client.query(
      `UPDATE public.purchase_approval_inventory_link
       SET received_qty = $2,
           inventory_receipt_status = $3,
           last_receipt_id = $4,
           updated_at = CURRENT_TIMESTAMP
       WHERE purchase_approval_id = $1`,
      [purchase_approval_id, nextReceivedQty, nextStatus, receipt.id]
    );

    await client.query('COMMIT');
    
    // Invalidate caches
    await Promise.all([
      cacheDelByPattern('erp:inventory:receipts:pending:*'),
      cacheDelByPattern('erp:inventory:balances:*'),
    ]);

    return apiSuccess({
      receipt_id: receipt.id,
      receipt_no: receipt.receipt_no,
      inventory_item_id: inventoryItemId,
      purchase_approval_id,
      received_qty: qty,
      remaining_qty: Math.max(requestedQuantity - nextReceivedQty, 0),
      inventory_receipt_status: nextStatus,
    }, 'Inventory receipt posted successfully', undefined, 201);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error posting inventory receipt from purchase approval:', error);
    return apiError('Failed to post inventory receipt from purchase approval');
  } finally {
    client.release();
  }
}
