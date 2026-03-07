import { NextRequest } from 'next/server';
import { pgPool } from '@/lib/pg';
import { apiConflict, apiError, apiNotFound, apiSuccess } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { createInventoryReceiptFromPurchaseApprovalSchema } from '@/lib/validation/schemas';

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
      purchaseApprovalId,
      warehouseId,
      locationId,
      qty,
      unitCost,
      vendorName,
      receiptDate,
      receiptNo,
      lotNo,
      expiryDate,
      note,
      createdBy,
    } = validation.data;

    await client.query('BEGIN');

    const purchaseApprovalResult = await client.query(
      `SELECT
        pa.id,
        pa.department,
        pa."budgetYear",
        pa."recordNumber",
        pa."requestDate",
        pa."productCode",
        pa."productName",
        pa.category,
        pa."productType",
        pa."productSubtype",
        pa."requestedQuantity",
        pa.unit,
        pa."pricePerUnit"::float8 AS "pricePerUnit",
        link."inventoryReceiptStatus",
        link."receivedQty"
      FROM public."PurchaseApproval" pa
      INNER JOIN public."PurchaseApprovalInventoryLink" link ON link."purchaseApprovalId" = pa.id
      WHERE pa.id = $1
      FOR UPDATE`,
      [purchaseApprovalId]
    );

    if (purchaseApprovalResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return apiNotFound('Purchase approval');
    }

    const purchaseApproval = purchaseApprovalResult.rows[0];
    const requestedQuantity = Number(purchaseApproval.requestedQuantity || 0);
    const receivedQty = Number(purchaseApproval.receivedQty || 0);
    const remainingQty = Math.max(requestedQuantity - receivedQty, 0);

    if (remainingQty <= 0) {
      await client.query('ROLLBACK');
      return apiConflict('Purchase approval has already been fully received');
    }

    if (qty > remainingQty) {
      await client.query('ROLLBACK');
      return apiConflict(`Receive quantity exceeds remaining quantity (${remainingQty})`);
    }

    const resolvedUnitCost = unitCost ?? Number(purchaseApproval.pricePerUnit || 0);
    const resolvedReceiptNo = receiptNo || `${DEFAULT_RECEIPT_PREFIX}-${Date.now()}`;
    const resolvedReceiptDate = receiptDate || new Date().toISOString();

    const warehouseResult = await client.query(
      `SELECT id FROM public."InventoryWarehouse" WHERE id = $1 LIMIT 1`,
      [warehouseId]
    );

    if (warehouseResult.rows.length === 0) {
      await client.query('ROLLBACK');
      return apiNotFound('Inventory warehouse');
    }

    const inventoryItemResult = await client.query(
      `SELECT id, "standardCost"
       FROM public."InventoryItem"
       WHERE "productCode" = $1
         AND "warehouseId" = $2
         AND COALESCE("locationId", 0) = COALESCE($3, 0)
         AND COALESCE("lotNo", '') = COALESCE($4, '')
       LIMIT 1`,
      [purchaseApproval.productCode, warehouseId, locationId ?? null, lotNo ?? null]
    );

    let inventoryItemId: number;

    if (inventoryItemResult.rows.length > 0) {
      inventoryItemId = inventoryItemResult.rows[0].id;
    } else {
      const insertedInventoryItem = await client.query(
        `INSERT INTO public."InventoryItem"
          ("productCode", "productName", category, "productType", "productSubtype", unit, "warehouseId", "locationId", "lotNo", "expiryDate", "standardCost")
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
         RETURNING id`,
        [
          purchaseApproval.productCode,
          purchaseApproval.productName,
          purchaseApproval.category,
          purchaseApproval.productType,
          purchaseApproval.productSubtype,
          purchaseApproval.unit,
          warehouseId,
          locationId ?? null,
          lotNo ?? null,
          expiryDate || null,
          resolvedUnitCost,
        ]
      );
      inventoryItemId = insertedInventoryItem.rows[0].id;

      await client.query(
        `INSERT INTO public."InventoryBalance" ("inventoryItemId", "onHandQty", "reservedQty", "availableQty", "avgCost")
         VALUES ($1, 0, 0, 0, $2)
         ON CONFLICT ("inventoryItemId") DO NOTHING`,
        [inventoryItemId, resolvedUnitCost]
      );
    }

    const receiptResult = await client.query(
      `INSERT INTO public."InventoryReceipt"
        ("receiptNo", "receiptDate", "receiptType", status, "vendorName", "sourceReferenceType", "sourceReferenceId", "sourceReferenceNo", note, "createdBy")
       VALUES ($1, $2, 'FROM_PURCHASE_APPROVAL', 'POSTED', $3, 'PurchaseApproval', $4, $5, $6, $7)
       RETURNING id, "receiptNo", "receiptDate"`,
      [
        resolvedReceiptNo,
        resolvedReceiptDate,
        vendorName || null,
        purchaseApprovalId,
        purchaseApproval.recordNumber || purchaseApproval.id,
        note || null,
        createdBy || null,
      ]
    );

    const receipt = receiptResult.rows[0];

    await client.query(
      `INSERT INTO public."InventoryReceiptItem"
        ("receiptId", "inventoryItemId", "purchaseApprovalId", qty, "unitCost", "totalCost", "lotNo", "expiryDate")
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [receipt.id, inventoryItemId, purchaseApprovalId, qty, resolvedUnitCost, qty * resolvedUnitCost, lotNo || null, expiryDate || null]
    );

    const balanceResult = await client.query(
      `SELECT id, "onHandQty", "reservedQty", "availableQty", "avgCost"
       FROM public."InventoryBalance"
       WHERE "inventoryItemId" = $1
       FOR UPDATE`,
      [inventoryItemId]
    );

    const balanceRow = balanceResult.rows[0];
    const currentOnHandQty = Number(balanceRow?.onHandQty || 0);
    const currentReservedQty = Number(balanceRow?.reservedQty || 0);
    const currentAvailableQty = Number(balanceRow?.availableQty || 0);
    const currentAvgCost = Number(balanceRow?.avgCost || 0);
    const newOnHandQty = currentOnHandQty + qty;
    const newAvailableQty = currentAvailableQty + qty;
    const newAvgCost = newOnHandQty === 0
      ? resolvedUnitCost
      : Number((((currentOnHandQty * currentAvgCost) + (qty * resolvedUnitCost)) / newOnHandQty).toFixed(2));

    await client.query(
      `UPDATE public."InventoryBalance"
       SET "onHandQty" = $2,
           "reservedQty" = $3,
           "availableQty" = $4,
           "avgCost" = $5,
           "lastMovementAt" = CURRENT_TIMESTAMP,
           updated_at = CURRENT_TIMESTAMP
       WHERE "inventoryItemId" = $1`,
      [inventoryItemId, newOnHandQty, currentReservedQty, newAvailableQty, newAvgCost]
    );

    await client.query(
      `INSERT INTO public."InventoryMovement"
        ("inventoryItemId", "movementDate", "movementType", "qtyIn", "qtyOut", "unitCost", "totalCost", "balanceQtyAfter", "balanceValueAfter", "referenceType", "referenceId", "referenceNo", "sourceDepartment", note, "createdBy")
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
        receipt.receiptNo,
        purchaseApproval.department || null,
        note || null,
        createdBy || null,
      ]
    );

    const nextReceivedQty = receivedQty + qty;
    const nextStatus = nextReceivedQty >= requestedQuantity ? 'RECEIVED' : 'PARTIAL';

    await client.query(
      `UPDATE public."PurchaseApprovalInventoryLink"
       SET "receivedQty" = $2,
           "inventoryReceiptStatus" = $3,
           "lastReceiptId" = $4,
           updated_at = CURRENT_TIMESTAMP
       WHERE "purchaseApprovalId" = $1`,
      [purchaseApprovalId, nextReceivedQty, nextStatus, receipt.id]
    );

    await client.query('COMMIT');

    return apiSuccess({
      receiptId: receipt.id,
      receiptNo: receipt.receiptNo,
      inventoryItemId,
      purchaseApprovalId,
      receivedQty: qty,
      remainingQty: Math.max(requestedQuantity - nextReceivedQty, 0),
      inventoryReceiptStatus: nextStatus,
    }, 'Inventory receipt posted successfully', undefined, 201);
  } catch (error) {
    await client.query('ROLLBACK');
    console.error('Error posting inventory receipt from purchase approval:', error);
    return apiError('Failed to post inventory receipt from purchase approval');
  } finally {
    client.release();
  }
}
