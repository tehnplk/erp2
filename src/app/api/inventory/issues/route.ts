import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { apiConflict, apiError, apiNotFound, apiSuccess } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { createInventoryIssueSchema } from '@/lib/validation/schemas';

export async function GET() {
  try {
    const cacheKey = 'erp:inventory:issues:list:all';
    const cached = await cacheGet<any[]>(cacheKey);
    if (cached) return apiSuccess(cached);

    const result = await pgQuery(`
      SELECT
        ii.id,
        ii."issueNo",
        ii."issueDate",
        ii."requisitionId",
        ii."requestingDepartment",
        ii.status,
        ii."issuedBy",
        ii."approvedBy",
        ii.note,
        ii.created_at,
        COALESCE(SUM(iii."issuedQty"), 0)::int AS "issuedQtyTotal"
      FROM public."InventoryIssue" ii
      LEFT JOIN public."InventoryIssueItem" iii ON iii."issueId" = ii.id
      GROUP BY ii.id
      ORDER BY ii.id DESC
    `);

    await cacheSet(cacheKey, result.rows, 300); // 5 minutes

    return apiSuccess(result.rows);
  } catch (error) {
    console.error('Error fetching inventory issues:', error);
    return apiError('Failed to fetch inventory issues');
  }
}

export async function POST(request: NextRequest) {
  const client = await pgPool.connect();

  try {
    const body = await request.json();
    const validation = await validateRequest(createInventoryIssueSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const { requisitionId, issueNo, issueDate, requestingDepartment, issuedBy, approvedBy, note, items } = validation.data;
    const resolvedIssueNo = issueNo || `ISS-${Date.now()}`;
    const resolvedIssueDate = issueDate || new Date().toISOString();

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
    if (!['APPROVED', 'PARTIALLY_APPROVED', 'PARTIALLY_ISSUED'].includes(requisition.status)) {
      await client.query('ROLLBACK');
      return apiConflict('Inventory requisition is not ready for issue posting');
    }

    const issueResult = await client.query(
      `INSERT INTO public."InventoryIssue" ("issueNo", "issueDate", "requisitionId", "requestingDepartment", status, "issuedBy", "approvedBy", note)
       VALUES ($1, $2, $3, $4, 'POSTED', $5, $6, $7)
       RETURNING id, "issueNo", "issueDate"`,
      [resolvedIssueNo, resolvedIssueDate, requisitionId, requestingDepartment, issuedBy || null, approvedBy || null, note || null]
    );

    const issue = issueResult.rows[0];

    for (const item of items) {
      const requisitionItemResult = await client.query(
        `SELECT id, "inventoryItemId", "approvedQty", "issuedQty"
         FROM public."InventoryRequisitionItem"
         WHERE id = $1 AND "requisitionId" = $2
         FOR UPDATE`,
        [item.requisitionItemId, requisitionId]
      );

      if (requisitionItemResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return apiNotFound(`Inventory requisition item ${item.requisitionItemId}`);
      }

      const requisitionItem = requisitionItemResult.rows[0];
      const approvedQty = Number(requisitionItem.approvedQty || 0);
      const alreadyIssuedQty = Number(requisitionItem.issuedQty || 0);
      const remainingIssueQty = approvedQty - alreadyIssuedQty;

      if (item.inventoryItemId !== Number(requisitionItem.inventoryItemId)) {
        await client.query('ROLLBACK');
        return apiConflict(`Inventory item mismatch for requisition item ${item.requisitionItemId}`);
      }

      if (item.issuedQty > remainingIssueQty) {
        await client.query('ROLLBACK');
        return apiConflict(`Issued quantity exceeds remaining approved quantity for requisition item ${item.requisitionItemId}`);
      }

      const balanceResult = await client.query(
        `SELECT "onHandQty", "reservedQty", "availableQty", "avgCost"
         FROM public."InventoryBalance"
         WHERE "inventoryItemId" = $1
         FOR UPDATE`,
        [item.inventoryItemId]
      );

      if (balanceResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return apiNotFound(`Inventory balance for item ${item.inventoryItemId}`);
      }

      const balance = balanceResult.rows[0];
      const onHandQty = Number(balance.onHandQty || 0);
      const reservedQty = Number(balance.reservedQty || 0);
      const availableQty = Number(balance.availableQty || 0);
      const avgCost = Number(balance.avgCost || 0);

      if (item.issuedQty > onHandQty) {
        await client.query('ROLLBACK');
        return apiConflict(`Issued quantity exceeds on hand quantity for inventory item ${item.inventoryItemId}`);
      }

      if (item.issuedQty > reservedQty) {
        await client.query('ROLLBACK');
        return apiConflict(`Issued quantity exceeds reserved quantity for inventory item ${item.inventoryItemId}`);
      }

      await client.query(
        `INSERT INTO public."InventoryIssueItem" ("issueId", "requisitionItemId", "inventoryItemId", "issuedQty", "unitCost", "totalCost")
         VALUES ($1, $2, $3, $4, $5, $6)`,
        [issue.id, item.requisitionItemId, item.inventoryItemId, item.issuedQty, avgCost, item.issuedQty * avgCost]
      );

      const nextOnHandQty = onHandQty - item.issuedQty;
      const nextReservedQty = reservedQty - item.issuedQty;
      const nextAvailableQty = availableQty;

      await client.query(
        `UPDATE public."InventoryBalance"
         SET "onHandQty" = $2,
             "reservedQty" = $3,
             "availableQty" = $4,
             "lastMovementAt" = CURRENT_TIMESTAMP,
             updated_at = CURRENT_TIMESTAMP
         WHERE "inventoryItemId" = $1`,
        [item.inventoryItemId, nextOnHandQty, nextReservedQty, nextAvailableQty]
      );

      await client.query(
        `UPDATE public."InventoryRequisitionItem"
         SET "issuedQty" = "issuedQty" + $2,
             "lineStatus" = CASE
               WHEN "issuedQty" + $2 >= "approvedQty" THEN 'ISSUED'
               WHEN "issuedQty" + $2 > 0 THEN 'PARTIALLY_ISSUED'
               ELSE "lineStatus"
             END
         WHERE id = $1`,
        [item.requisitionItemId, item.issuedQty]
      );

      await client.query(
        `INSERT INTO public."InventoryMovement"
          ("inventoryItemId", "movementDate", "movementType", "qtyIn", "qtyOut", "unitCost", "totalCost", "balanceQtyAfter", "balanceValueAfter", "referenceType", "referenceId", "referenceNo", "targetDepartment", note, "createdBy")
         VALUES ($1, $2, 'ISSUE_APPROVED', 0, $3, $4, $5, $6, $7, 'InventoryIssue', $8, $9, $10, $11, $12)`,
        [
          item.inventoryItemId,
          resolvedIssueDate,
          item.issuedQty,
          avgCost,
          item.issuedQty * avgCost,
          nextOnHandQty,
          Number((nextOnHandQty * avgCost).toFixed(2)),
          issue.id,
          issue.issueNo,
          requestingDepartment,
          note || null,
          issuedBy || null,
        ]
      );
    }

    const requisitionSummaryResult = await client.query(
      `SELECT
         COALESCE(SUM("approvedQty"), 0)::int AS "approvedQtyTotal",
         COALESCE(SUM("issuedQty"), 0)::int AS "issuedQtyTotal"
       FROM public."InventoryRequisitionItem"
       WHERE "requisitionId" = $1`,
      [requisitionId]
    );

    const approvedQtyTotal = Number(requisitionSummaryResult.rows[0]?.approvedQtyTotal || 0);
    const issuedQtyTotal = Number(requisitionSummaryResult.rows[0]?.issuedQtyTotal || 0);
    const nextStatus = issuedQtyTotal >= approvedQtyTotal ? 'ISSUED' : 'PARTIALLY_ISSUED';

    await client.query(
      `UPDATE public."InventoryRequisition"
       SET status = $2,
           "issuedBy" = $3,
           "issuedAt" = CURRENT_TIMESTAMP,
           updated_at = CURRENT_TIMESTAMP
       WHERE id = $1`,
      [requisitionId, nextStatus, issuedBy || null]
    );

    await client.query('COMMIT');

    // Invalidate Redis Cache
    await cacheDelByPattern('erp:inventory:balances:*');
    await cacheDelByPattern('erp:inventory:issues:list:*');
    await cacheDelByPattern('erp:inventory:requisitions:list:*');

    return apiSuccess({
      issueId: issue.id,
      issueNo: issue.issueNo,
      requisitionId,
      status: nextStatus,
    }, 'Inventory issue posted successfully', undefined, 201);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error posting inventory issue:', error);
    return apiError('Failed to post inventory issue');
  } finally {
    client.release();
  }
}
