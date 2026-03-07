# Inventory Module Redesign

## Overview

This document proposes a new warehouse and inventory module for the ERP system using PostgreSQL via `pg` only. The redesign replaces the current single-table warehouse approach with a document-driven and ledger-based inventory model.

The main business requirement is that stock in the warehouse must originate automatically from `PurchaseApproval` records, rather than being entered manually as standalone warehouse rows.

## Current State Summary

### Existing `PurchaseApproval`

Current table: `public."PurchaseApproval"`

Relevant columns:

- `id`
- `approvalId`
- `department`
- `budgetYear`
- `recordNumber`
- `requestDate`
- `productName`
- `productCode`
- `category`
- `productType`
- `productSubtype`
- `requestedQuantity`
- `unit`
- `pricePerUnit`
- `totalValue`
- `overPlanCase`
- `requester`
- `approver`
- `created_at`
- `updated_at`

### Existing `Warehouse`

Current table: `public."Warehouse"`

The current schema mixes:

- opening balance fields
- receipt fields
- issue fields
- remaining stock fields
- department fields
- item master fields

This structure is not suitable for an auditable inventory system because it does not cleanly separate:

- stock master
- stock movement
- receipt documents
- requisition documents
- issue documents
- period closing snapshots

## Design Goals

- Stock must originate from `PurchaseApproval` automatically.
- Inventory must support requisition and issue approval flow.
- Inventory must support stock deduction and stock balance tracking.
- Inventory must support carried forward / carried over balances.
- Inventory must support stock card and audit trail.
- Inventory must support future expansion such as adjustments, returns, transfers, and low stock alerts.
- The redesign must use PostgreSQL and `pg`, not Prisma.

## Core Design Principle

The source of truth for stock movement must be an inventory ledger.

Balances such as on-hand quantity or available quantity may be stored in summary tables for performance, but they must be derived and maintained from the movement flow.

## Proposed Data Model

### 1. `InventoryWarehouse`

Master table for warehouses.

Columns:

- `id` serial primary key
- `warehouseCode` text not null unique
- `warehouseName` text not null
- `isActive` boolean not null default true
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

### 2. `InventoryLocation`

Optional sub-location inside a warehouse.

Columns:

- `id` serial primary key
- `warehouseId` integer not null references `InventoryWarehouse(id)`
- `locationCode` text not null
- `locationName` text not null
- `isActive` boolean not null default true
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Unique index:

- `warehouseId`, `locationCode`

### 3. `InventoryItem`

Master item record as stored in inventory.

Columns:

- `id` serial primary key
- `productCode` text not null
- `productName` text not null
- `category` text null
- `productType` text null
- `productSubtype` text null
- `unit` text null
- `warehouseId` integer not null references `InventoryWarehouse(id)`
- `locationId` integer null references `InventoryLocation(id)`
- `lotNo` text null
- `expiryDate` date null
- `standardCost` numeric(18,2) not null default 0
- `isActive` boolean not null default true
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Recommended uniqueness:

- `productCode`, `warehouseId`, `coalesce(locationId, 0)`, `coalesce(lotNo, '')`

Implementation note:

Because PostgreSQL does not support `coalesce` in a normal unique constraint cleanly for nullable columns without expression indexes, use a unique expression index if location/lot-level tracking is required. For MVP, a simpler unique constraint on `productCode`, `warehouseId`, `locationId`, `lotNo` may be acceptable.

### 4. `InventoryBalance`

Current stock summary per inventory item.

Columns:

- `id` serial primary key
- `inventoryItemId` integer not null unique references `InventoryItem(id)`
- `onHandQty` integer not null default 0
- `reservedQty` integer not null default 0
- `availableQty` integer not null default 0
- `avgCost` numeric(18,2) not null default 0
- `lastMovementAt` timestamp null
- `updated_at` timestamp not null default current_timestamp

Business rule:

- `availableQty = onHandQty - reservedQty`

### 5. `InventoryMovement`

Ledger table for every stock movement.

Columns:

- `id` serial primary key
- `inventoryItemId` integer not null references `InventoryItem(id)`
- `movementDate` timestamp not null default current_timestamp
- `movementType` text not null
- `qtyIn` integer not null default 0
- `qtyOut` integer not null default 0
- `unitCost` numeric(18,2) not null default 0
- `totalCost` numeric(18,2) not null default 0
- `balanceQtyAfter` integer not null default 0
- `balanceValueAfter` numeric(18,2) not null default 0
- `referenceType` text null
- `referenceId` integer null
- `referenceNo` text null
- `sourceDepartment` text null
- `targetDepartment` text null
- `note` text null
- `createdBy` text null
- `created_at` timestamp not null default current_timestamp

Recommended movement types:

- `OPENING_BALANCE`
- `PURCHASE_APPROVAL_RECEIPT`
- `MANUAL_RECEIPT`
- `REQUISITION_RESERVE`
- `ISSUE_APPROVED`
- `ISSUE_CANCELLED`
- `RETURN_IN`
- `RETURN_OUT`
- `ADJUSTMENT_IN`
- `ADJUSTMENT_OUT`
- `TRANSFER_IN`
- `TRANSFER_OUT`
- `CLOSING_CARRY_FORWARD`

### 6. `InventoryReceipt`

Header document for warehouse receiving.

Columns:

- `id` serial primary key
- `receiptNo` text not null unique
- `receiptDate` timestamp not null default current_timestamp
- `receiptType` text not null
- `status` text not null default 'POSTED'
- `vendorName` text null
- `sourceReferenceType` text null
- `sourceReferenceId` integer null
- `sourceReferenceNo` text null
- `note` text null
- `createdBy` text null
- `approvedBy` text null
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Recommended `receiptType` values:

- `FROM_PURCHASE_APPROVAL`
- `MANUAL`
- `RETURN`
- `TRANSFER_IN`

### 7. `InventoryReceiptItem`

Line items for receipts.

Columns:

- `id` serial primary key
- `receiptId` integer not null references `InventoryReceipt(id)` on delete cascade
- `inventoryItemId` integer not null references `InventoryItem(id)`
- `purchaseApprovalId` integer null references `PurchaseApproval(id)`
- `qty` integer not null
- `unitCost` numeric(18,2) not null default 0
- `totalCost` numeric(18,2) not null default 0
- `lotNo` text null
- `expiryDate` date null

### 8. `PurchaseApprovalInventoryLink`

Explicit link between purchase approval rows and inventory receiving progress.

Columns:

- `id` serial primary key
- `purchaseApprovalId` integer not null unique references `PurchaseApproval(id)` on delete cascade
- `inventoryReceiptStatus` text not null default 'PENDING'
- `receivedQty` integer not null default 0
- `lastReceiptId` integer null references `InventoryReceipt(id)`
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Recommended `inventoryReceiptStatus` values:

- `PENDING`
- `PARTIAL`
- `RECEIVED`
- `CANCELLED`

### 9. `InventoryRequisition`

Header document for requisition requests.

Columns:

- `id` serial primary key
- `requisitionNo` text not null unique
- `requestDate` timestamp not null default current_timestamp
- `requestingDepartment` text not null
- `status` text not null default 'DRAFT'
- `requestedBy` text null
- `approvedBy` text null
- `approvedAt` timestamp null
- `issuedBy` text null
- `issuedAt` timestamp null
- `note` text null
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Recommended `status` values:

- `DRAFT`
- `SUBMITTED`
- `PARTIALLY_APPROVED`
- `APPROVED`
- `REJECTED`
- `PARTIALLY_ISSUED`
- `ISSUED`
- `CANCELLED`

### 10. `InventoryRequisitionItem`

Columns:

- `id` serial primary key
- `requisitionId` integer not null references `InventoryRequisition(id)` on delete cascade
- `inventoryItemId` integer not null references `InventoryItem(id)`
- `requestedQty` integer not null
- `approvedQty` integer not null default 0
- `issuedQty` integer not null default 0
- `unitCostAtIssue` numeric(18,2) not null default 0
- `lineStatus` text not null default 'DRAFT'
- `note` text null

### 11. `InventoryIssue`

Header document for issue transactions.

Columns:

- `id` serial primary key
- `issueNo` text not null unique
- `issueDate` timestamp not null default current_timestamp
- `requisitionId` integer not null references `InventoryRequisition(id)`
- `requestingDepartment` text not null
- `status` text not null default 'POSTED'
- `issuedBy` text null
- `approvedBy` text null
- `note` text null
- `created_at` timestamp not null default current_timestamp

### 12. `InventoryIssueItem`

Columns:

- `id` serial primary key
- `issueId` integer not null references `InventoryIssue(id)` on delete cascade
- `requisitionItemId` integer not null references `InventoryRequisitionItem(id)`
- `inventoryItemId` integer not null references `InventoryItem(id)`
- `issuedQty` integer not null
- `unitCost` numeric(18,2) not null default 0
- `totalCost` numeric(18,2) not null default 0

### 13. `InventoryAdjustment`

Header document for stock adjustments.

Columns:

- `id` serial primary key
- `adjustmentNo` text not null unique
- `adjustmentDate` timestamp not null default current_timestamp
- `reason` text not null
- `status` text not null default 'DRAFT'
- `createdBy` text null
- `approvedBy` text null
- `created_at` timestamp not null default current_timestamp

### 14. `InventoryAdjustmentItem`

Columns:

- `id` serial primary key
- `adjustmentId` integer not null references `InventoryAdjustment(id)` on delete cascade
- `inventoryItemId` integer not null references `InventoryItem(id)`
- `qtyDiff` integer not null
- `unitCost` numeric(18,2) not null default 0
- `note` text null

### 15. `InventoryPeriod`

Header table for inventory closing period.

Columns:

- `id` serial primary key
- `periodYear` integer not null
- `periodMonth` integer not null
- `status` text not null default 'OPEN'
- `closedAt` timestamp null
- `closedBy` text null
- `created_at` timestamp not null default current_timestamp

Unique constraint:

- `periodYear`, `periodMonth`

Recommended `status` values:

- `OPEN`
- `CLOSING`
- `CLOSED`

### 16. `InventoryPeriodBalance`

Snapshot of opening and closing balances.

Columns:

- `id` serial primary key
- `periodId` integer not null references `InventoryPeriod(id)` on delete cascade
- `inventoryItemId` integer not null references `InventoryItem(id)`
- `openingQty` integer not null default 0
- `openingValue` numeric(18,2) not null default 0
- `closingQty` integer not null default 0
- `closingValue` numeric(18,2) not null default 0

Unique constraint:

- `periodId`, `inventoryItemId`

## How Stock Originates from PurchaseApproval

### Recommended business flow

`PurchaseApproval` is the source document for receivable stock.

Recommended approach:

1. A `PurchaseApproval` record is created and approved.
2. The system exposes approved rows as pending warehouse receipts.
3. Warehouse staff performs receiving based on `PurchaseApproval`.
4. Receipt posting creates item master records as needed and writes inventory movements.

This is preferable to instant stock creation upon approval because it supports:

- partial receipt
- lot tracking
- bill number / vendor capture
- operational verification by warehouse staff
- audit trail

### Auto-origin requirement interpretation

If the requirement says warehouse stock must come from `PurchaseApproval` automatically, the system should treat `PurchaseApproval` as the authoritative source of inbound inventory. Warehouse receiving should not allow unrelated inbound creation unless explicitly created as a manual receipt type.

## Main Business Flows

### 1. Receipt from PurchaseApproval

Flow:

1. User approves purchase approval.
2. System marks the row as pending receipt.
3. Warehouse user opens pending receipt list.
4. Warehouse user confirms actual receiving quantity, lot, expiry, receipt bill number, and vendor.
5. System posts receipt.

System actions:

- upsert `InventoryItem`
- create `InventoryReceipt`
- create `InventoryReceiptItem`
- create `InventoryMovement` with `PURCHASE_APPROVAL_RECEIPT`
- update `InventoryBalance`
- update `PurchaseApprovalInventoryLink.receivedQty`
- update `PurchaseApprovalInventoryLink.inventoryReceiptStatus`

Rules:

- received quantity cannot exceed approved/requested quantity for the source row
- support partial receipt
- support repeated receipts until fully received

### 2. Requisition request

Flow:

1. Department creates requisition.
2. Requisition includes one or more inventory items.
3. System checks stock availability.
4. Document is submitted for review.

### 3. Approve issue

Flow:

1. Warehouse or approver reviews requisition.
2. Approved quantity is entered.
3. System reserves stock.

System actions:

- update requisition item approved quantity
- update reserved quantity in `InventoryBalance`
- optionally create reservation movement entry with `REQUISITION_RESERVE`

### 4. Issue and stock deduction

Flow:

1. Warehouse issues items physically.
2. System posts issue document.
3. Stock is deducted.

System actions:

- create `InventoryIssue`
- create `InventoryIssueItem`
- create `InventoryMovement` with `ISSUE_APPROVED`
- decrease `onHandQty`
- decrease `reservedQty`
- recalculate `availableQty`

### 5. Return

Flow:

- returned stock from department creates `RETURN_IN`
- returned to vendor or outbound return creates `RETURN_OUT`

### 6. Adjustment

Flow:

- stock count discrepancy
- expired goods
- damaged goods
- manual reconciliation

System creates `ADJUSTMENT_IN` or `ADJUSTMENT_OUT` movements.

### 7. Carry forward / period close

Flow:

1. At month-end or year-end, close inventory period.
2. Snapshot balances into `InventoryPeriodBalance`.
3. Next period opening comes from previous period closing.

Rules:

- closed period should not allow direct backdated posting
- corrections should be handled through adjustments in open periods

## Required MVP Features

For the first implementation phase, build the following:

- pending receipt from `PurchaseApproval`
- receive into inventory
- inventory stock list
- inventory balance list
- stock card / movement query
- requisition creation
- requisition approval
- issue posting and stock deduction

## Nice-to-have Features After MVP

- lot and expiry alerts
- minimum stock and reorder point
- return flow
- adjustment approval flow
- transfer between locations
- cycle counting
- warehouse dashboard widgets
- valuation reports

## API Proposal

### Receipt and inbound stock

- `GET /api/inventory/receipts/pending-purchase-approvals`
- `POST /api/inventory/receipts/from-purchase-approval`
- `GET /api/inventory/receipts`
- `GET /api/inventory/receipts/:id`

### Inventory master and balances

- `GET /api/inventory/items`
- `GET /api/inventory/balances`
- `GET /api/inventory/movements`
- `GET /api/inventory/items/:id/stock-card`

### Requisition and issue

- `POST /api/inventory/requisitions`
- `GET /api/inventory/requisitions`
- `POST /api/inventory/requisitions/:id/submit`
- `POST /api/inventory/requisitions/:id/approve`
- `POST /api/inventory/issues`
- `GET /api/inventory/issues`

### Adjustment and closing

- `POST /api/inventory/adjustments`
- `POST /api/inventory/periods/:id/close`

## UI Proposal

### New pages

- `/inventory`
  - inventory dashboard and summary
- `/inventory/receipts`
  - receive from purchase approval and manual receipt
- `/inventory/stock`
  - stock balances and filters
- `/inventory/requisitions`
  - requisition list and creation
- `/inventory/issues`
  - issue approval and posting
- `/inventory/movements`
  - stock card and movement history
- `/inventory/periods`
  - closing and carry forward

### Existing `/warehouse`

Recommended action:

- keep existing `/warehouse` as legacy temporarily
- add navigation to new `/inventory` module
- migrate users gradually
- eventually retire legacy warehouse module

## Migration Strategy

### Phase 1

Create all new inventory tables in PostgreSQL without touching current `Warehouse` data.

### Phase 2

Add linkage between `PurchaseApproval` and inventory receipt status.

Recommended approach:

- create `PurchaseApprovalInventoryLink`
- backfill rows for existing `PurchaseApproval` records

### Phase 3

Build receipt posting transaction from purchase approval to inventory ledger.

### Phase 4

Build requisition and issue flow.

### Phase 5

Build reporting, stock card, and period close.

### Phase 6

Retire or freeze legacy `Warehouse` module.

## Transaction Rules

All stock-affecting operations must run inside a PostgreSQL transaction.

Examples:

- receipt posting
- issue posting
- adjustment posting
- closing period posting

For each transaction:

1. validate source document status
2. lock affected balance rows if necessary
3. insert document headers and lines
4. insert movement ledger rows
5. update balances
6. commit

## Concurrency Considerations

To prevent double posting or incorrect stock balance:

- use `SELECT ... FOR UPDATE` when loading `InventoryBalance` rows during stock-affecting transactions
- enforce document status transitions strictly
- prevent receiving the same purchase approval line beyond allowed quantity
- prevent issuing more than approved or available quantity

## Naming and Code Strategy

- keep implementation in `src/app/api/inventory/*`
- keep SQL and DB access through `src/lib/pg.ts`
- extend `src/lib/validation/schemas.ts` with new inventory schemas
- implement small, focused SQL transactions in route handlers or reusable server helpers

## Docker / PostgreSQL Execution Strategy

Current environment findings:

- Postgres container name: `postgres`
- probable project database: `erp2`
- current project uses `pg` and `DATABASE_URL`

Recommended workflow:

1. create SQL file under repo, for example `sql/inventory_module_v1.sql`
2. review SQL file in git
3. run with Docker:
   - `docker exec -i postgres psql -U admin -d erp2 < sql/inventory_module_v1.sql`
4. verify created tables and indexes

## Initial Implementation Recommendation

### Step 1

Create SQL migration for the following first:

- `InventoryWarehouse`
- `InventoryLocation`
- `InventoryItem`
- `InventoryBalance`
- `InventoryMovement`
- `InventoryReceipt`
- `InventoryReceiptItem`
- `PurchaseApprovalInventoryLink`
- `InventoryRequisition`
- `InventoryRequisitionItem`
- `InventoryIssue`
- `InventoryIssueItem`
- `InventoryAdjustment`
- `InventoryAdjustmentItem`
- `InventoryPeriod`
- `InventoryPeriodBalance`

### Step 2

Create API MVP:

- pending approvals for receipt
- post receipt from purchase approval
- inventory balances list
- movement list
- requisition create/list
- requisition approve
- issue post

### Step 3

Create UI MVP pages under `/inventory`.

## Out of Scope for First MVP

- barcode integration
- multi-warehouse transfer automation
- advanced costing methods like FIFO layers
- procurement workflow redesign outside inventory linkage
- full historical migration from legacy `Warehouse`

## Open Questions for Review

1. Should stock be created immediately on purchase approval approval, or only when warehouse staff confirms receipt?
2. Is lot and expiry required in MVP or phase 2?
3. Is there more than one warehouse in real use, or only one central warehouse currently?
4. Should requisition approval be one-step or two-step?
5. Is period closing monthly, yearly, or both?

## Recommended Decision

For correctness and auditability, use this default:

- `PurchaseApproval` = source of receivable stock
- warehouse user must confirm receipt before on-hand stock increases
- issue flow uses requisition -> approval -> posting
- all stock changes must write to `InventoryMovement`
- balances are maintained summary values, not the only source of truth

## เอกสารส่งมอบสำหรับทีมพัฒนา

ส่วนนี้เป็น handoff note ของโมดูลคลังฉบับปฏิบัติจริง เพื่อให้ developer คนอื่นสามารถอ่านแล้วเข้าใจภาพรวมของระบบ, รู้ว่ามีอะไรถูก build แล้ว, อะไรยังเป็น MVP, และควรต่อยอดจากจุดใดโดยไม่ต้องไล่แกะโค้ดทั้งหมดใหม่

## สถานะปัจจุบันของระบบ

โมดูล `inventory` ถูกพัฒนาเป็น MVP ที่ใช้งานได้จริงบน Next.js App Router และ PostgreSQL ผ่าน `pg` แล้ว โดย flow หลักที่ทำงานได้ในปัจจุบันคือ:

- รับสินค้าเข้าคลังจาก `PurchaseApproval`
- ดูยอดคงคลังปัจจุบันจาก `InventoryBalance`
- สร้างคำขอเบิกสินค้า
- อนุมัติคำขอเบิกและทำการ reserve stock
- บันทึกจ่ายสินค้าและตัด stock จริง
- ดู movement / stock ledger จาก `InventoryMovement`

ระบบนี้ไม่ได้ใช้ Prisma และยึดหลักให้ `InventoryMovement` เป็นแหล่งอ้างอิงหลักของการเปลี่ยนแปลงสต็อก ส่วน `InventoryBalance` เป็น summary table สำหรับการอ่านเร็วและแสดงผลบน UI

## วัตถุประสงค์ทางธุรกิจของโมดูลคลัง

โมดูลนี้ถูกออกแบบมาเพื่อแก้ข้อจำกัดของโมดูล `Warehouse` เดิมที่เก็บข้อมูลหลายบทบาทไว้ในตารางเดียว ทำให้ audit ยากและขยาย flow เพิ่มได้ลำบาก

หลักคิดของโมดูลใหม่คือ:

- stock ต้นทางต้องมาจาก `PurchaseApproval`
- การรับเข้าและจ่ายออกต้องเกิดเป็น document ชัดเจน
- ทุกการเปลี่ยนแปลง stock ต้องมี ledger ย้อนกลับได้
- balance ที่ UI เห็นต้องอธิบายได้จาก movement จริง

## ขอบเขตที่ทำเสร็จแล้วในโค้ดปัจจุบัน

### Database / Schema

ใช้ migration ที่ `sql/inventory_module_v1.sql`

ตารางสำคัญที่ถูกสร้างแล้ว:

- `InventoryWarehouse`
- `InventoryLocation`
- `InventoryItem`
- `InventoryBalance`
- `InventoryMovement`
- `InventoryReceipt`
- `InventoryReceiptItem`
- `PurchaseApprovalInventoryLink`
- `InventoryRequisition`
- `InventoryRequisitionItem`
- `InventoryIssue`
- `InventoryIssueItem`
- `InventoryAdjustment`
- `InventoryAdjustmentItem`
- `InventoryPeriod`
- `InventoryPeriodBalance`

ข้อมูลตั้งต้นที่มีอยู่แล้ว:

- warehouse หลัก `MAIN / คลังกลาง`
- backfill ข้อมูล `PurchaseApprovalInventoryLink` จาก `PurchaseApproval`

### API ที่มีแล้ว

ภายใต้ `src/app/api/inventory/`

- `balances/route.ts`
- `movements/route.ts`
- `issues/route.ts`
- `requisitions/route.ts`
- `requisitions/approve/route.ts`
- `receipts/from-purchase-approval/route.ts`
- `receipts/pending-purchase-approvals/route.ts`

### UI ที่มีแล้ว

ภายใต้ `src/app/inventory/`

- `page.tsx` dashboard ระบบคลัง
- `receipts/page.tsx` หน้ารับสินค้าเข้าคลัง
- `stock/page.tsx` หน้ายอดคงคลัง
- `requisitions/page.tsx` หน้าคำขอเบิก
- `issues/page.tsx` หน้าจ่ายสินค้า
- `movements/page.tsx` หน้าประวัติการเคลื่อนไหว

## File Map สำหรับ dev คนถัดไป

### โครงสร้าง DB และ migration

- `sql/inventory_module_v1.sql`

### เอกสารออกแบบ

- `docs/inventory-module-redesign.md`

### API routes

- `src/app/api/inventory/balances/route.ts`
- `src/app/api/inventory/movements/route.ts`
- `src/app/api/inventory/issues/route.ts`
- `src/app/api/inventory/requisitions/route.ts`
- `src/app/api/inventory/requisitions/approve/route.ts`
- `src/app/api/inventory/receipts/from-purchase-approval/route.ts`
- `src/app/api/inventory/receipts/pending-purchase-approvals/route.ts`

### UI pages

- `src/app/inventory/page.tsx`
- `src/app/inventory/receipts/page.tsx`
- `src/app/inventory/stock/page.tsx`
- `src/app/inventory/requisitions/page.tsx`
- `src/app/inventory/issues/page.tsx`
- `src/app/inventory/movements/page.tsx`

### Shared infra

- `src/lib/pg.ts`
- `src/lib/api-response.ts`
- `src/lib/validation/schemas.ts`
- `src/lib/validation/validate.ts`

### Navigation

- `src/app/components/Navbar.tsx`

## สถาปัตยกรรมการไหลของข้อมูล

### 1. Inbound stock

ต้นทาง stock ไม่ได้เริ่มที่ `InventoryItem` หรือ `InventoryBalance` แต่เริ่มที่ `PurchaseApproval`

flow ปัจจุบัน:

1. `PurchaseApproval` ถูกใช้เป็น source ของรายการที่รอรับเข้า
2. `PurchaseApprovalInventoryLink` เก็บสถานะว่าแต่ละรายการรับเข้าไปแล้วเท่าไร
3. เมื่อ user ทำ receipt:
   - หา/สร้าง `InventoryItem`
   - หา/สร้าง `InventoryBalance`
   - สร้าง `InventoryReceipt` และ `InventoryReceiptItem`
   - เขียน `InventoryMovement` แบบ `PURCHASE_APPROVAL_RECEIPT`
   - update `InventoryBalance`
   - update `PurchaseApprovalInventoryLink`

### 2. Requisition and reservation

เมื่อ user สร้าง requisition:

1. สร้าง `InventoryRequisition`
2. สร้าง `InventoryRequisitionItem`

เมื่อ approver อนุมัติ:

1. lock `InventoryRequisition`
2. lock `InventoryRequisitionItem`
3. lock `InventoryBalance`
4. เพิ่ม `reservedQty`
5. ลด `availableQty`
6. เปลี่ยนสถานะ `InventoryRequisition` และ line items

หมายเหตุ: flow ปัจจุบันยังไม่ insert movement แยกสำหรับ reserve แม้ใน design จะรองรับแนวคิด `REQUISITION_RESERVE`

### 3. Issue posting

เมื่อ user ทำ issue จาก requisition ที่อนุมัติแล้ว:

1. สร้าง `InventoryIssue`
2. สร้าง `InventoryIssueItem`
3. ลด `onHandQty`
4. ลด `reservedQty`
5. คง `availableQty` ไว้ตามค่าที่ถูกลดไปตั้งแต่ขั้นอนุมัติ
6. เขียน `InventoryMovement` แบบ `ISSUE_APPROVED`
7. อัปเดตสถานะ `InventoryRequisition` เป็น `PARTIALLY_ISSUED` หรือ `ISSUED`

## Business Rules ที่สำคัญใน implementation ปัจจุบัน

### Receipt

- รับเข้าเกินจำนวนคงเหลือของ `PurchaseApproval` ไม่ได้
- support partial receipt
- ถ้ารับเข้าครบจะเปลี่ยน `PurchaseApprovalInventoryLink.inventoryReceiptStatus` เป็น `RECEIVED`
- ถ้ายังไม่ครบจะเป็น `PARTIAL`

### Approve requisition

- อนุมัติเกิน `requestedQty` ไม่ได้
- อนุมัติเกิน `availableQty` ไม่ได้
- การอนุมัติจะไป reserve stock ทันทีด้วยการเพิ่ม `reservedQty` และลด `availableQty`

### Issue posting

- จ่ายเกิน `approvedQty - issuedQty` ไม่ได้
- จ่ายเกิน `onHandQty` ไม่ได้
- จ่ายเกิน `reservedQty` ไม่ได้
- การ issue จะลด `onHandQty` และ `reservedQty`

## Source of Truth ที่ควรใช้เวลา debug

เวลา debug ปัญหา stock ให้ตรวจตามลำดับนี้:

1. `InventoryMovement`
2. `InventoryBalance`
3. `InventoryReceipt` / `InventoryReceiptItem`
4. `InventoryRequisition` / `InventoryRequisitionItem`
5. `InventoryIssue` / `InventoryIssueItem`
6. `PurchaseApprovalInventoryLink`
7. `InventoryWarehouse` / `InventoryItem`

หลักการคือห้ามแก้ปัญหาข้อมูลด้วย fallback ฝั่ง UI ถ้ายังไม่รู้ว่าต้นทางใน DB ถูกหรือไม่

## สิ่งที่พบจริงระหว่างพัฒนาและทดสอบ

### 1. ปัญหาข้อมูลชื่อคลังใน DB

เคยพบกรณี `InventoryWarehouse.warehouseName` ถูกเก็บเป็น `????????...` ทำให้หน้า stock แสดงชื่อคลังพัง

บทเรียนสำคัญ:

- ต้องแก้ที่ต้นทางข้อมูลใน DB
- ไม่ควรทำ UI fallback เพื่อกลบข้อมูลเสีย

สถานะปัจจุบัน:

- ค่า warehouse หลักถูกแก้เป็น `คลังกลาง` แล้ว

### 2. ปัญหา Next.js dev runtime corruption

ระหว่างพัฒนาเคยพบอาการ `.next`/webpack runtime ไม่เสถียร เช่น `Cannot find module './xxxx.js'`

แนวทางแก้ที่ใช้ได้จริง:

- kill `node.exe`
- start `npm run dev` ใหม่
- ทดสอบ browser automation ซ้ำหลัง server clean restart

### 3. ปัญหา browser automation transport

Chrome MCP และ Playwright MCP เคยมีอาการ `transport closed` เป็นครั้งคราว ซึ่งเป็นปัญหาของ session tooling มากกว่าตัวแอป

แนวทางทำงาน:

- เช็กก่อนว่า server ฟังบน `3000` จริง
- ถ้า MCP session ล่ม ให้เปิด session ใหม่หรือ restart dev server ก่อนสรุปว่าระบบพัง

## ผลการทดสอบที่ยืนยันแล้ว

มีการทดสอบด้วย browser automation บน flow จริงดังนี้:

- receipt จาก `PurchaseApproval`
- stock เพิ่มหลัง receipt
- create requisition
- approve requisition
- issue posting
- movement แสดง `PURCHASE_APPROVAL_RECEIPT` และ `ISSUE_APPROVED`
- stock ลดลงหลัง issue จริง

ตัวอย่าง flow ที่ยืนยันแล้ว:

- รับเข้า `P230-000440` จำนวน 200
- approve requisition จำนวน 1
- issue จำนวน 1
- stock ลดจาก 200 เป็น 199

## ข้อจำกัดของ implementation ปัจจุบัน

แม้ MVP ใช้งานได้แล้ว แต่ยังมี gap ที่ dev คนต่อไปควรรู้:

### 1. Requisition ยังเป็น single-item oriented บน UI

แม้ schema รองรับหลาย line items แต่ UI ปัจจุบันเน้นสร้างคำขอเบิกทีละรายการ

### 2. Reserve movement ยังไม่ถูกบันทึกเป็น ledger แยก

ปัจจุบัน approve requisition update `InventoryBalance` โดยตรง แต่ยังไม่ได้ insert `InventoryMovement` ประเภท `REQUISITION_RESERVE`

### 3. ยังไม่มี cancel / unreserve flow

ถ้ามีการยกเลิก requisition หรือ revert approval ยังต้องออกแบบการคืน `reservedQty` และการเขียน movement ย้อนกลับ

### 4. Adjustment / Period close ยังมี schema แต่ยังไม่มี UI/flow ใช้งานจริง

### 5. Manual receipt, return, transfer ยังเป็น future scope

### 6. Legacy `/warehouse` route ยังอยู่ใน codebase

แม้ navigation หลักถูกถอดออกแล้ว แต่ route เดิมยังไม่ถูกลบจากระบบทั้งหมด

## คำแนะนำในการพัฒนาต่อ

### Priority 1

- เพิ่ม reserve ledger (`REQUISITION_RESERVE`)
- เพิ่ม unreserve flow เมื่อ reject / cancel / edit requisition
- ปรับ issue UI ให้รองรับ partial issue แบบหลาย line item ชัดเจนขึ้น

### Priority 2

- เพิ่ม filters และ pagination ที่สมบูรณ์ใน UI
- เพิ่ม detail views สำหรับ receipt / requisition / issue document
- เพิ่ม search และ stock card drill-down ระดับสินค้า

### Priority 3

- เพิ่ม return flow
- เพิ่ม adjustment flow
- เพิ่ม period close flow
- เพิ่ม dashboard metrics และ alerts

## แนวทางแก้ bug ที่ควรยึดเป็นมาตรฐาน

- แก้ที่ source data ก่อน UI เสมอ
- ทุก operation ที่กระทบ stock ต้องอยู่ใน transaction
- ใช้ `SELECT ... FOR UPDATE` กับ balance/documents ที่ต้อง lock
- หลีกเลี่ยงการทำ business rule ซ้ำทั้ง UI และ API ถ้ายังไม่มี source of truth เดียว
- อย่าพึ่ง logic จากข้อความบนหน้าจออย่างเดียว ให้ตรวจ network และ DB เสมอเมื่อ flow ผิด

## วิธีรันและตรวจระบบแบบเร็ว

### Run app

- `npm run dev`

### Build check

- `npm run build`

### DB reference

ดูข้อมูลเชื่อมต่อได้ที่:

- `doc/docker-db.md`

ค่าที่ใช้งานจริงใน environment นี้:

- container: `postgres`
- db: `erp2`
- user: `admin`

### Migration

- `sql/inventory_module_v1.sql`

## Suggested smoke test สำหรับ dev คนถัดไป

1. เปิด `/inventory/receipts`
2. รับเข้า 1 รายการจาก pending approvals
3. เปิด `/inventory/stock` และตรวจว่ามี item ใหม่หรือ quantity เพิ่มขึ้น
4. เปิด `/inventory/requisitions` และสร้างคำขอเบิก 1 รายการ
5. กดอนุมัติ
6. เปิด `/inventory/issues` และ post issue
7. เปิด `/inventory/movements` และตรวจ ledger
8. กลับ `/inventory/stock` และตรวจยอดหลังจ่าย

## สรุปสำหรับคนรับงานต่อ

ถ้าจะเข้าใจโมดูลนี้ให้เร็วที่สุด ให้จำ 5 ประโยคนี้:

- inbound stock มาจาก `PurchaseApproval`
- stock จริงเพิ่มเมื่อ `receipt` ถูก post
- approval จะ reserve stock ผ่าน `InventoryBalance`
- issue จะลด stock จริงและเขียน `InventoryMovement`
- เวลา debug ให้เชื่อ ledger และ DB ก่อน UI

ถ้าจะต่อยอดระบบนี้โดยไม่ทำให้ข้อมูลพัง ควรเริ่มจากการรักษา invariant ของ `InventoryBalance` และเพิ่ม ledger coverage ให้ครบทุก movement ที่ยังขาด
