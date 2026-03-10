BEGIN;

CREATE TABLE IF NOT EXISTS public."InventoryWarehouse" (
  id SERIAL PRIMARY KEY,
  "warehouseCode" TEXT NOT NULL UNIQUE,
  "warehouseName" TEXT NOT NULL,
  "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public."InventoryLocation" (
  id SERIAL PRIMARY KEY,
  "warehouseId" INTEGER NOT NULL REFERENCES public."InventoryWarehouse"(id) ON DELETE RESTRICT,
  "locationCode" TEXT NOT NULL,
  "locationName" TEXT NOT NULL,
  "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "InventoryLocation_warehouseId_locationCode_key" UNIQUE ("warehouseId", "locationCode")
);

CREATE TABLE IF NOT EXISTS public."InventoryItem" (
  id SERIAL PRIMARY KEY,
  "productCode" TEXT NOT NULL,
  "productName" TEXT NOT NULL,
  category TEXT,
  "productType" TEXT,
  "productSubtype" TEXT,
  unit TEXT,
  "warehouseId" INTEGER NOT NULL REFERENCES public."InventoryWarehouse"(id) ON DELETE RESTRICT,
  "locationId" INTEGER REFERENCES public."InventoryLocation"(id) ON DELETE SET NULL,
  "lotNo" TEXT,
  "expiryDate" DATE,
  "standardCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "isActive" BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE UNIQUE INDEX IF NOT EXISTS "InventoryItem_unique_product_wh_location_lot"
ON public."InventoryItem" (
  "productCode",
  "warehouseId",
  COALESCE("locationId", 0),
  COALESCE("lotNo", '')
);

CREATE TABLE IF NOT EXISTS public."InventoryBalance" (
  id SERIAL PRIMARY KEY,
  "inventoryItemId" INTEGER NOT NULL UNIQUE REFERENCES public."InventoryItem"(id) ON DELETE CASCADE,
  "onHandQty" INTEGER NOT NULL DEFAULT 0,
  "reservedQty" INTEGER NOT NULL DEFAULT 0,
  "availableQty" INTEGER NOT NULL DEFAULT 0,
  "avgCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "lastMovementAt" TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "InventoryBalance_non_negative" CHECK ("onHandQty" >= 0 AND "reservedQty" >= 0 AND "availableQty" >= 0)
);

CREATE TABLE IF NOT EXISTS public."InventoryMovement" (
  id SERIAL PRIMARY KEY,
  "inventoryItemId" INTEGER NOT NULL REFERENCES public."InventoryItem"(id) ON DELETE RESTRICT,
  "movementDate" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "movementType" TEXT NOT NULL,
  "qtyIn" INTEGER NOT NULL DEFAULT 0,
  "qtyOut" INTEGER NOT NULL DEFAULT 0,
  "unitCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "totalCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "balanceQtyAfter" INTEGER NOT NULL DEFAULT 0,
  "balanceValueAfter" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "referenceType" TEXT,
  "referenceId" INTEGER,
  "referenceNo" TEXT,
  "sourceDepartment" TEXT,
  "targetDepartment" TEXT,
  note TEXT,
  "createdBy" TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "InventoryMovement_qty_valid" CHECK ("qtyIn" >= 0 AND "qtyOut" >= 0)
);

CREATE INDEX IF NOT EXISTS "InventoryMovement_item_date_idx"
ON public."InventoryMovement" ("inventoryItemId", "movementDate" DESC);

CREATE TABLE IF NOT EXISTS public."InventoryReceipt" (
  id SERIAL PRIMARY KEY,
  "receiptNo" TEXT NOT NULL UNIQUE,
  "receiptDate" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "receiptType" TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'POSTED',
  "vendorName" TEXT,
  "sourceReferenceType" TEXT,
  "sourceReferenceId" INTEGER,
  "sourceReferenceNo" TEXT,
  note TEXT,
  "createdBy" TEXT,
  "approvedBy" TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public."InventoryReceiptItem" (
  id SERIAL PRIMARY KEY,
  "receiptId" INTEGER NOT NULL REFERENCES public."InventoryReceipt"(id) ON DELETE CASCADE,
  "inventoryItemId" INTEGER NOT NULL REFERENCES public."InventoryItem"(id) ON DELETE RESTRICT,
  "purchaseApprovalId" INTEGER REFERENCES public."PurchaseApproval"(id) ON DELETE SET NULL,
  qty INTEGER NOT NULL,
  "unitCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "totalCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "lotNo" TEXT,
  "expiryDate" DATE,
  CONSTRAINT "InventoryReceiptItem_qty_positive" CHECK (qty > 0)
);

CREATE TABLE IF NOT EXISTS public."PurchaseApprovalInventoryLink" (
  id SERIAL PRIMARY KEY,
  "purchaseApprovalId" INTEGER NOT NULL UNIQUE REFERENCES public."PurchaseApproval"(id) ON DELETE CASCADE,
  "inventoryReceiptStatus" TEXT NOT NULL DEFAULT 'PENDING',
  "receivedQty" INTEGER NOT NULL DEFAULT 0,
  "lastReceiptId" INTEGER REFERENCES public."InventoryReceipt"(id) ON DELETE SET NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "PurchaseApprovalInventoryLink_receivedQty_non_negative" CHECK ("receivedQty" >= 0)
);

CREATE TABLE IF NOT EXISTS public."InventoryRequisition" (
  id SERIAL PRIMARY KEY,
  "requisitionNo" TEXT NOT NULL UNIQUE,
  "requestDate" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "requestingDepartment" TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'DRAFT',
  "requestedBy" TEXT,
  "approvedBy" TEXT,
  "approvedAt" TIMESTAMP,
  "issuedBy" TEXT,
  "issuedAt" TIMESTAMP,
  note TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public."InventoryRequisitionItem" (
  id SERIAL PRIMARY KEY,
  "requisitionId" INTEGER NOT NULL REFERENCES public."InventoryRequisition"(id) ON DELETE CASCADE,
  "inventoryItemId" INTEGER NOT NULL REFERENCES public."InventoryItem"(id) ON DELETE RESTRICT,
  "requestedQty" INTEGER NOT NULL,
  "approvedQty" INTEGER NOT NULL DEFAULT 0,
  "issuedQty" INTEGER NOT NULL DEFAULT 0,
  "unitCostAtIssue" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "lineStatus" TEXT NOT NULL DEFAULT 'DRAFT',
  note TEXT,
  CONSTRAINT "InventoryRequisitionItem_qty_valid" CHECK ("requestedQty" > 0 AND "approvedQty" >= 0 AND "issuedQty" >= 0)
);

CREATE TABLE IF NOT EXISTS public."InventoryIssue" (
  id SERIAL PRIMARY KEY,
  "issueNo" TEXT NOT NULL UNIQUE,
  "issueDate" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "requisitionId" INTEGER NOT NULL REFERENCES public."InventoryRequisition"(id) ON DELETE RESTRICT,
  "requestingDepartment" TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'POSTED',
  "issuedBy" TEXT,
  "approvedBy" TEXT,
  note TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public."InventoryIssueItem" (
  id SERIAL PRIMARY KEY,
  "issueId" INTEGER NOT NULL REFERENCES public."InventoryIssue"(id) ON DELETE CASCADE,
  "requisitionItemId" INTEGER NOT NULL REFERENCES public."InventoryRequisitionItem"(id) ON DELETE RESTRICT,
  "inventoryItemId" INTEGER NOT NULL REFERENCES public."InventoryItem"(id) ON DELETE RESTRICT,
  "issuedQty" INTEGER NOT NULL,
  "unitCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "totalCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  CONSTRAINT "InventoryIssueItem_issuedQty_positive" CHECK ("issuedQty" > 0)
);

CREATE TABLE IF NOT EXISTS public."InventoryAdjustment" (
  id SERIAL PRIMARY KEY,
  "adjustmentNo" TEXT NOT NULL UNIQUE,
  "adjustmentDate" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reason TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'DRAFT',
  "createdBy" TEXT,
  "approvedBy" TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS public."InventoryAdjustmentItem" (
  id SERIAL PRIMARY KEY,
  "adjustmentId" INTEGER NOT NULL REFERENCES public."InventoryAdjustment"(id) ON DELETE CASCADE,
  "inventoryItemId" INTEGER NOT NULL REFERENCES public."InventoryItem"(id) ON DELETE RESTRICT,
  "qtyDiff" INTEGER NOT NULL,
  "unitCost" NUMERIC(18,2) NOT NULL DEFAULT 0,
  note TEXT
);

CREATE TABLE IF NOT EXISTS public."InventoryPeriod" (
  id SERIAL PRIMARY KEY,
  "periodYear" INTEGER NOT NULL,
  "periodMonth" INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'OPEN',
  "closedAt" TIMESTAMP,
  "closedBy" TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT "InventoryPeriod_unique_period" UNIQUE ("periodYear", "periodMonth"),
  CONSTRAINT "InventoryPeriod_month_valid" CHECK ("periodMonth" BETWEEN 1 AND 12)
);

CREATE TABLE IF NOT EXISTS public."InventoryPeriodBalance" (
  id SERIAL PRIMARY KEY,
  "periodId" INTEGER NOT NULL REFERENCES public."InventoryPeriod"(id) ON DELETE CASCADE,
  "inventoryItemId" INTEGER NOT NULL REFERENCES public."InventoryItem"(id) ON DELETE RESTRICT,
  "openingQty" INTEGER NOT NULL DEFAULT 0,
  "openingValue" NUMERIC(18,2) NOT NULL DEFAULT 0,
  "closingQty" INTEGER NOT NULL DEFAULT 0,
  "closingValue" NUMERIC(18,2) NOT NULL DEFAULT 0,
  CONSTRAINT "InventoryPeriodBalance_unique_item_per_period" UNIQUE ("periodId", "inventoryItemId")
);

INSERT INTO public."InventoryWarehouse" ("warehouseCode", "warehouseName")
VALUES ('MAIN', 'คลังกลาง')
ON CONFLICT ("warehouseCode") DO NOTHING;

INSERT INTO public."PurchaseApprovalInventoryLink" ("purchaseApprovalId", "inventoryReceiptStatus", "receivedQty")
SELECT pa.id, 'PENDING', 0
FROM public."PurchaseApproval" pa
ON CONFLICT ("purchaseApprovalId") DO NOTHING;

COMMIT;
