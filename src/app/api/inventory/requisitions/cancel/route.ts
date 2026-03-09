import { NextRequest } from "next/server";
import { pgPool } from "@/lib/pg";
import { cacheDelByPattern } from "@/lib/redis";
import {
  apiConflict,
  apiError,
  apiNotFound,
  apiSuccess,
} from "@/lib/api-response";

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const requisitionId = Number(
      new URL(request.url).searchParams.get("requisition_id"),
    );

    if (!requisitionId || Number.isNaN(requisitionId)) {
      return apiError("requisition_id is required", 400);
    }

    const { cancelled_by, note } = body;

    await client.query("BEGIN");

    const requisitionResult = await client.query(
      `SELECT id, requisition_no, requesting_department, status FROM public.inventory_requisition WHERE id = $1 FOR UPDATE`,
      [requisitionId],
    );

    if (requisitionResult.rows.length === 0) {
      await client.query("ROLLBACK");
      return apiNotFound("Inventory requisition");
    }

    const requisition = requisitionResult.rows[0];
    
    // Can only cancel if it's not fully issued yet or already cancelled.
    if (["ISSUED", "CANCELLED", "REJECTED"].includes(requisition.status)) {
      await client.query("ROLLBACK");
      return apiConflict("Inventory requisition cannot be cancelled from its current status");
    }

    // Need to unreserve quantities based on approved_qty - issued_qty
    const requisitionItemsResult = await client.query(
      `SELECT iri.id, iri.inventory_item_id, iri.approved_qty, iri.issued_qty, ib.on_hand_qty, ib.avg_cost
       FROM public.inventory_requisition_item iri
       INNER JOIN public.inventory_balance ib ON ib.inventory_item_id = iri.inventory_item_id
       WHERE iri.requisition_id = $1
       FOR UPDATE`,
      [requisitionId],
    );

    for (const item of requisitionItemsResult.rows) {
      const approvedQty = Number(item.approved_qty || 0);
      const issuedQty = Number(item.issued_qty || 0);
      const pendingReserveQty = approvedQty - issuedQty;

      if (pendingReserveQty > 0) {
        // Unreserve stock
        await client.query(
          `UPDATE public.inventory_balance
           SET reserved_qty = reserved_qty - $2,
               available_qty = available_qty + $2,
               updated_at = CURRENT_TIMESTAMP
           WHERE inventory_item_id = $1`,
          [item.inventory_item_id, pendingReserveQty]
        );

        const onHandQty = Number(item.on_hand_qty || 0);
        const avgCost = Number(item.avg_cost || 0);

        // Add tracking movement
        await client.query(
          `INSERT INTO public.inventory_movement
            (inventory_item_id, movement_date, movement_type, qty_in, qty_out, unit_cost, total_cost, balance_qty_after, balance_value_after, reference_type, reference_id, reference_no, target_department, note, created_by)
           VALUES ($1, CURRENT_TIMESTAMP, 'REQUISITION_UNRESERVE', 0, 0, $2, 0, $3, $4, 'InventoryRequisition', $5, $6, $7, $8, $9)`,
          [
            item.inventory_item_id,
            avgCost,
            onHandQty,
            Number((onHandQty * avgCost).toFixed(2)),
            requisition.id,
            requisition.requisition_no,
            requisition.requesting_department,
            `Unreserved ${pendingReserveQty} items due to cancellation`,
            cancelled_by || null,
          ],
        );
      }

      // Update item status
      await client.query(
        `UPDATE public.inventory_requisition_item
         SET line_status = 'CANCELLED'
         WHERE id = $1`,
        [item.id]
      );
    }

    const updatedResult = await client.query(
      `UPDATE public.inventory_requisition
       SET status = 'CANCELLED',
           note = COALESCE($2, note),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $1
       RETURNING id, requisition_no, status`,
      [requisitionId, note ? `Cancelled by ${cancelled_by || 'System'}: ${note}` : `Cancelled by ${cancelled_by || 'System'}`]
    );

    await client.query("COMMIT");
    
    // Invalidate Redis Caches
    await Promise.all([
      cacheDelByPattern('erp:inventory:requisitions:*'),
      cacheDelByPattern('erp:inventory:balances:*'),
    ]);

    return apiSuccess(
      updatedResult.rows[0],
      "Inventory requisition cancelled successfully",
    );
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error cancelling inventory requisition:", error);
    return apiError("Failed to cancel inventory requisition");
  } finally {
    client.release();
  }
}
