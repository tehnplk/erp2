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
      new URL(request.url).searchParams.get("requisitionId"),
    );

    if (!requisitionId || Number.isNaN(requisitionId)) {
      return apiError("requisitionId is required", 400);
    }

    const { cancelledBy, note } = body;

    await client.query("BEGIN");

    const requisitionResult = await client.query(
      `SELECT id, "requisitionNo", "requestingDepartment", status FROM public."InventoryRequisition" WHERE id = $1 FOR UPDATE`,
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

    // Need to unreserve quantities based on approvedQty - issuedQty
    const requisitionItemsResult = await client.query(
      `SELECT iri.id, iri."inventoryItemId", iri."approvedQty", iri."issuedQty", ib."onHandQty", ib."avgCost"
       FROM public."InventoryRequisitionItem" iri
       INNER JOIN public."InventoryBalance" ib ON ib."inventoryItemId" = iri."inventoryItemId"
       WHERE iri."requisitionId" = $1
       FOR UPDATE`,
      [requisitionId],
    );

    for (const item of requisitionItemsResult.rows) {
      const approvedQty = Number(item.approvedQty || 0);
      const issuedQty = Number(item.issuedQty || 0);
      const pendingReserveQty = approvedQty - issuedQty;

      if (pendingReserveQty > 0) {
        // Unreserve stock
        await client.query(
          `UPDATE public."InventoryBalance"
           SET "reservedQty" = "reservedQty" - $2,
               "availableQty" = "availableQty" + $2,
               updated_at = CURRENT_TIMESTAMP
           WHERE "inventoryItemId" = $1`,
          [item.inventoryItemId, pendingReserveQty]
        );

        const onHandQty = Number(item.onHandQty || 0);
        const avgCost = Number(item.avgCost || 0);

        // Add tracking movement
        await client.query(
          `INSERT INTO public."InventoryMovement"
            ("inventoryItemId", "movementDate", "movementType", "qtyIn", "qtyOut", "unitCost", "totalCost", "balanceQtyAfter", "balanceValueAfter", "referenceType", "referenceId", "referenceNo", "targetDepartment", note, "createdBy")
           VALUES ($1, CURRENT_TIMESTAMP, 'REQUISITION_UNRESERVE', 0, 0, $2, 0, $3, $4, 'InventoryRequisition', $5, $6, $7, $8, $9)`,
          [
            item.inventoryItemId,
            avgCost,
            onHandQty,
            Number((onHandQty * avgCost).toFixed(2)),
            requisition.id,
            requisition.requisitionNo,
            requisition.requestingDepartment,
            `Unreserved ${pendingReserveQty} items due to cancellation`,
            cancelledBy || null,
          ],
        );
      }

      // Update item status
      await client.query(
        `UPDATE public."InventoryRequisitionItem"
         SET "lineStatus" = 'CANCELLED'
         WHERE id = $1`,
        [item.id]
      );
    }

    const updatedResult = await client.query(
      `UPDATE public."InventoryRequisition"
       SET status = 'CANCELLED',
           note = COALESCE($2, note),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $1
       RETURNING id, "requisitionNo", status`,
      [requisitionId, note ? `Cancelled by ${cancelledBy || 'System'}: ${note}` : `Cancelled by ${cancelledBy || 'System'}`]
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
