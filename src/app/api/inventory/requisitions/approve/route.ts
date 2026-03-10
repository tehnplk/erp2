import { NextRequest } from "next/server";
import { pgPool } from "@/lib/pg";
import { cacheDelByPattern } from "@/lib/redis";
import {
  apiConflict,
  apiError,
  apiNotFound,
  apiSuccess,
} from "@/lib/api-response";
import { validateRequest } from "@/lib/validation/validate";
import { approveInventoryRequisitionSchema } from "@/lib/validation/schemas";

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(
      approveInventoryRequisitionSchema,
      body,
    );
    if (!validation.success) {
      return validation.error;
    }

    const requisitionId = Number(
      new URL(request.url).searchParams.get("requisition_id"),
    );
    if (!requisitionId || Number.isNaN(requisitionId)) {
      return apiError("requisition_id is required", 400);
    }

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
    if (
      !["DRAFT", "SUBMITTED", "PARTIALLY_APPROVED"].includes(requisition.status)
    ) {
      await client.query("ROLLBACK");
      return apiConflict(
        "Inventory requisition is not in an approvable status",
      );
    }

    for (const item of validation.data.items) {
      const requisitionItemResult = await client.query(
        `SELECT iri.id, iri.inventory_item_id, iri.requested_qty, iri.approved_qty, iri.issued_qty, ib.available_qty, ib.on_hand_qty, ib.avg_cost
         FROM public.inventory_requisition_item iri
         INNER JOIN public.inventory_balance ib ON ib.inventory_item_id = iri.inventory_item_id
         WHERE iri.id = $1 AND iri.requisition_id = $2
         FOR UPDATE`,
        [item.requisition_item_id, requisitionId],
      );

      if (requisitionItemResult.rows.length === 0) {
        await client.query("ROLLBACK");
        return apiNotFound(
          `Inventory requisition item ${item.requisition_item_id}`,
        );
      }

      const requisitionItem = requisitionItemResult.rows[0];
      const requestedQty = Number(requisitionItem.requested_qty || 0);
      const oldApprovedQty = Number(requisitionItem.approved_qty || 0);
      const approvedQty = Number(item.approved_qty || 0);
      const availableQty = Number(requisitionItem.available_qty || 0);
      const onHandQty = Number(requisitionItem.on_hand_qty || 0);
      const avgCost = Number(requisitionItem.avg_cost || 0);
      
      const diffQty = approvedQty - oldApprovedQty;

      if (approvedQty > requestedQty) {
        await client.query("ROLLBACK");
        return apiConflict(
          `Approved quantity cannot exceed requested quantity for item ${item.requisition_item_id}`,
        );
      }

      if (diffQty > availableQty) {
        await client.query("ROLLBACK");
        return apiConflict(
          `Approved quantity exceeds available quantity for item ${item.requisition_item_id}`,
        );
      }

      await client.query(
        `UPDATE public.inventory_requisition_item
         SET approved_qty = $2,
             line_status = CASE WHEN $2 = 0 THEN 'REJECTED' WHEN $2 < requested_qty THEN 'PARTIALLY_APPROVED' ELSE 'APPROVED' END
         WHERE id = $1`,
        [item.requisition_item_id, approvedQty],
      );

      if (diffQty !== 0) {
        await client.query(
          `UPDATE public.inventory_balance
           SET reserved_qty = reserved_qty + $2,
               available_qty = available_qty - $2,
               updated_at = CURRENT_TIMESTAMP
           WHERE inventory_item_id = $1`,
          [requisitionItem.inventory_item_id, diffQty],
        );

        const movementType = diffQty > 0 ? 'REQUISITION_RESERVE' : 'REQUISITION_UNRESERVE';
        const absoluteDiff = Math.abs(diffQty);
        
        await client.query(
          `INSERT INTO public.inventory_movement
            (inventory_item_id, movement_date, movement_type, qty_in, qty_out, unit_cost, total_cost, balance_qty_after, balance_value_after, reference_type, reference_id, reference_no, target_department, note, created_by)
           VALUES ($1, CURRENT_TIMESTAMP, $2, 0, 0, $3, 0, $4, $5, 'InventoryRequisition', $6, $7, $8, $9, $10)`,
          [
            requisitionItem.inventory_item_id,
            movementType,
            avgCost,
            onHandQty,
            Number((onHandQty * avgCost).toFixed(2)),
            requisition.id,
            requisition.requisition_no,
            requisition.requesting_department,
            `${diffQty > 0 ? 'Reserved' : 'Unreserved'} ${absoluteDiff} items`,
            validation.data.approved_by || null,
          ],
        );
      }
    }

    const summaryResult = await client.query(
      `SELECT
         COALESCE(SUM(requested_qty), 0)::int AS requested_qty_total,
         COALESCE(SUM(approved_qty), 0)::int AS approved_qty_total
       FROM public.inventory_requisition_item
       WHERE requisition_id = $1`,
      [requisitionId],
    );

    const requestedQtyTotal = Number(
      summaryResult.rows[0]?.requested_qty_total || 0,
    );
    const approvedQtyTotal = Number(
      summaryResult.rows[0]?.approved_qty_total || 0,
    );
    const nextStatus =
      approvedQtyTotal === 0
        ? "REJECTED"
        : approvedQtyTotal < requestedQtyTotal
          ? "PARTIALLY_APPROVED"
          : "APPROVED";

    const updatedResult = await client.query(
      `UPDATE public.inventory_requisition
       SET status = $2,
           approved_by = $3,
           approved_at = CURRENT_TIMESTAMP,
           note = COALESCE($4, note),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $1
       RETURNING id, requisition_no, status, approved_by, approved_at`,
      [
        requisitionId,
        nextStatus,
        validation.data.approved_by || null,
        validation.data.note || null,
      ],
    );

    await client.query("COMMIT");
    
    // Invalidate Redis Caches
    await Promise.all([
      cacheDelByPattern('erp:inventory:requisitions:*'),
      cacheDelByPattern('erp:inventory:balances:*'),
    ]);

    return apiSuccess(
      updatedResult.rows[0],
      "Inventory requisition approved successfully",
    );
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Error approving inventory requisition:", error);
    return apiError("Failed to approve inventory requisition");
  } finally {
    client.release();
  }
}
