import { NextRequest } from 'next/server';
import { pgPool } from '@/lib/pg';
import { apiConflict, apiError, apiNotFound, apiSuccess } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { approveInventoryRequisitionSchema } from '@/lib/validation/schemas';

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(approveInventoryRequisitionSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const requisitionId = Number(new URL(request.url).searchParams.get('requisitionId'));
    if (!requisitionId || Number.isNaN(requisitionId)) {
      return apiError('requisitionId is required', 400);
    }

    await client.query('BEGIN');

    const requisitionResult = await client.query(
      `SELECT id, status FROM public."InventoryRequisition" WHERE id = $1 FOR UPDATE`,
      [requisitionId]
    );

    if (requisitionResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return apiNotFound('Inventory requisition');
    }

    const requisition = requisitionResult.rows[0];
    if (!['DRAFT', 'SUBMITTED', 'PARTIALLY_APPROVED'].includes(requisition.status)) {
      await client.query('ROLLBACK');
      return apiConflict('Inventory requisition is not in an approvable status');
    }

    for (const item of validation.data.items) {
      const requisitionItemResult = await client.query(
        `SELECT iri.id, iri."inventoryItemId", iri."requestedQty", iri."approvedQty", iri."issuedQty", ib."availableQty"
         FROM public."InventoryRequisitionItem" iri
         INNER JOIN public."InventoryBalance" ib ON ib."inventoryItemId" = iri."inventoryItemId"
         WHERE iri.id = $1 AND iri."requisitionId" = $2
         FOR UPDATE`,
        [item.requisitionItemId, requisitionId]
      );

      if (requisitionItemResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return apiNotFound(`Inventory requisition item ${item.requisitionItemId}`);
      }

      const requisitionItem = requisitionItemResult.rows[0];
      const requestedQty = Number(requisitionItem.requestedQty || 0);
      const approvedQty = Number(item.approvedQty || 0);
      const availableQty = Number(requisitionItem.availableQty || 0);

      if (approvedQty > requestedQty) {
        await client.query('ROLLBACK');
        return apiConflict(`Approved quantity cannot exceed requested quantity for item ${item.requisitionItemId}`);
      }

      if (approvedQty > availableQty) {
        await client.query('ROLLBACK');
        return apiConflict(`Approved quantity exceeds available quantity for item ${item.requisitionItemId}`);
      }

      await client.query(
        `UPDATE public."InventoryRequisitionItem"
         SET "approvedQty" = $2,
             "lineStatus" = CASE WHEN $2 = 0 THEN 'REJECTED' WHEN $2 < "requestedQty" THEN 'PARTIALLY_APPROVED' ELSE 'APPROVED' END
         WHERE id = $1`,
        [item.requisitionItemId, approvedQty]
      );

      await client.query(
        `UPDATE public."InventoryBalance"
         SET "reservedQty" = "reservedQty" + $2,
             "availableQty" = "availableQty" - $2,
             updated_at = CURRENT_TIMESTAMP
         WHERE "inventoryItemId" = $1`,
        [requisitionItem.inventoryItemId, approvedQty]
      );
    }

    const summaryResult = await client.query(
      `SELECT
         COALESCE(SUM("requestedQty"), 0)::int AS "requestedQtyTotal",
         COALESCE(SUM("approvedQty"), 0)::int AS "approvedQtyTotal"
       FROM public."InventoryRequisitionItem"
       WHERE "requisitionId" = $1`,
      [requisitionId]
    );

    const requestedQtyTotal = Number(summaryResult.rows[0]?.requestedQtyTotal || 0);
    const approvedQtyTotal = Number(summaryResult.rows[0]?.approvedQtyTotal || 0);
    const nextStatus = approvedQtyTotal === 0
      ? 'REJECTED'
      : approvedQtyTotal < requestedQtyTotal
        ? 'PARTIALLY_APPROVED'
        : 'APPROVED';

    const updatedResult = await client.query(
      `UPDATE public."InventoryRequisition"
       SET status = $2,
           "approvedBy" = $3,
           "approvedAt" = CURRENT_TIMESTAMP,
           note = COALESCE($4, note),
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $1
       RETURNING id, "requisitionNo", status, "approvedBy", "approvedAt"`,
      [requisitionId, nextStatus, validation.data.approvedBy || null, validation.data.note || null]
    );

    await client.query('COMMIT');

    return apiSuccess(updatedResult.rows[0], 'Inventory requisition approved successfully');
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error approving inventory requisition:', error);
    return apiError('Failed to approve inventory requisition');
  } finally {
    client.release();
  }
}
