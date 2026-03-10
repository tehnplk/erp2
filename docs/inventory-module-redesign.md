# Inventory Module Redesign

## Overview

This document proposes a new warehouse and inventory module for the ERP system using PostgreSQL via `pg` only. The redesign replaces the current single-table warehouse approach with a document-driven and ledger-based inventory model.

The main business requirement is that stock in the warehouse must originate from `purchase_approval` records, rather than being entered manually as standalone warehouse rows.

## Current State Summary

### Existing `purchase_approval`

Current table: `public.purchase_approval`

Relevant columns:

- `id`
- `approval_id`
- `department`
- `budget_year`
- `record_number`
- `request_date`
- `product_name`
- `product_code`
- `category`
- `product_type`
- `product_subtype`
- `requested_quantity`
- `unit`
- `price_per_unit`
- `total_value`
- `over_plan_case`
- `requester`
- `approver`
- `created_at`
- `updated_at`

### Existing `warehouse`

Current table: `public.warehouse`

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

- Stock must originate from `purchase_approval` automatically.
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

### 1. `inventory_warehouse`

Master table for warehouses.

Columns:

- `id` serial primary key
- `warehouse_code` text not null unique
- `warehouse_name` text not null
- `is_active` boolean not null default true
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

### 2. `inventory_location`

Optional sub-location inside a warehouse.

Columns:

- `id` serial primary key
- `warehouse_id` integer not null references `inventory_warehouse(id)`
- `location_code` text not null
- `location_name` text not null
- `is_active` boolean not null default true
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Unique index:

- `warehouse_id`, `location_code`

### 3. `inventory_item`

Master item record as stored in inventory.

Columns:

- `id` serial primary key
- `product_code` text not null
- `product_name` text not null
- `category` text null
- `product_type` text null
- `product_subtype` text null
- `unit` text null
- `warehouse_id` integer not null references `inventory_warehouse(id)`
- `location_id` integer null references `inventory_location(id)`
- `lot_no` text null
- `expiry_date` date null
- `standard_cost` numeric(18,2) not null default 0
- `is_active` boolean not null default true
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Recommended uniqueness:

- `product_code`, `warehouse_id`, `coalesce(location_id, 0)`, `coalesce(lot_no, '')`

Implementation note:

Because PostgreSQL does not support `coalesce` in a normal unique constraint cleanly for nullable columns without expression indexes, use a unique expression index if location/lot-level tracking is required. For MVP, a simpler unique constraint on `product_code`, `warehouse_id`, `location_id`, `lot_no` may be acceptable.

### 4. `inventory_balance`

Current stock summary per inventory item.

Columns:

- `id` serial primary key
- `inventory_item_id` integer not null unique references `inventory_item(id)`
- `on_hand_qty` integer not null default 0
- `reserved_qty` integer not null default 0
- `available_qty` integer not null default 0
- `avg_cost` numeric(18,2) not null default 0
- `last_movement_at` timestamp null
- `updated_at` timestamp not null default current_timestamp

Business rule:

- `available_qty = on_hand_qty - reserved_qty`

### 5. `inventory_movement`

Ledger table for every stock movement.

Columns:

- `id` serial primary key
- `inventory_item_id` integer not null references `inventory_item(id)`
- `movement_date` timestamp not null default current_timestamp
- `movement_type` text not null
- `qty_in` integer not null default 0
- `qty_out` integer not null default 0
- `unit_cost` numeric(18,2) not null default 0
- `total_cost` numeric(18,2) not null default 0
- `balance_qty_after` integer not null default 0
- `balance_value_after` numeric(18,2) not null default 0
- `reference_type` text null
- `reference_id` integer null
- `reference_no` text null
- `source_department` text null
- `target_department` text null
- `note` text null
- `created_by` text null
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

### 6. `inventory_receipt`

Header document for warehouse receiving.

Columns:

- `id` serial primary key
- `receipt_no` text not null unique
- `receipt_date` timestamp not null default current_timestamp
- `receipt_type` text not null
- `status` text not null default 'POSTED'
- `vendor_name` text null
- `source_reference_type` text null
- `source_reference_id` integer null
- `source_reference_no` text null
- `note` text null
- `created_by` text null
- `approved_by` text null
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Recommended `receipt_type` values:

- `FROM_PURCHASE_APPROVAL`
- `MANUAL`
- `RETURN`
- `TRANSFER_IN`

### 7. `inventory_receipt_item`

Line items for receipts.

Columns:

- `id` serial primary key
- `receipt_id` integer not null references `inventory_receipt(id)` on delete cascade
- `inventory_item_id` integer not null references `inventory_item(id)`
- `purchase_approval_id` integer null references `purchase_approval(id)`
- `qty` integer not null
- `unit_cost` numeric(18,2) not null default 0
- `total_cost` numeric(18,2) not null default 0
- `lot_no` text null
- `expiry_date` date null

### 8. `purchase_approval_inventory_link`

Explicit link between purchase approval rows and inventory receiving progress.

Columns:

- `id` serial primary key
- `purchase_approval_id` integer not null unique references `purchase_approval(id)` on delete cascade
- `inventory_receipt_status` text not null default 'PENDING'
- `received_qty` integer not null default 0
- `last_receipt_id` integer null references `inventory_receipt(id)`
- `created_at` timestamp not null default current_timestamp
- `updated_at` timestamp not null default current_timestamp

Recommended `inventory_receipt_status` values:

- `PENDING`
- `PARTIAL`
- `RECEIVED`
- `CANCELLED`

### 9. `inventory_requisition`

Header document for requisition requests.

Columns:

- `id` serial primary key
- `requisition_no` text not null unique
- `request_date` timestamp not null default current_timestamp
- `requesting_department` text not null
- `status` text not null default 'DRAFT'
- `requested_by` text null
- `approved_by` text null
- `approved_at` timestamp null
- `issued_by` text null
- `issued_at` timestamp null
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

### 10. `inventory_requisition_item`

Columns:

- `id` serial primary key
- `requisition_id` integer not null references `inventory_requisition(id)` on delete cascade
- `inventory_item_id` integer not null references `inventory_item(id)`
- `requested_qty` integer not null
- `approved_qty` integer not null default 0
- `issued_qty` integer not null default 0
- `unit_cost_at_issue` numeric(18,2) not null default 0
- `line_status` text not null default 'DRAFT'
- `note` text null

### 11. `inventory_issue`

Header document for issue transactions.

Columns:

- `id` serial primary key
- `issue_no` text not null unique
- `issue_date` timestamp not null default current_timestamp
- `requisition_id` integer not null references `inventory_requisition(id)`
- `requesting_department` text not null
- `status` text not null default 'POSTED'
- `issued_by` text null
- `approved_by` text null
- `note` text null
- `created_at` timestamp not null default current_timestamp

### 12. `inventory_issue_item`

Columns:

- `id` serial primary key
- `issue_id` integer not null references `inventory_issue(id)` on delete cascade
- `requisition_item_id` integer not null references `inventory_requisition_item(id)`
- `inventory_item_id` integer not null references `inventory_item(id)`
- `issued_qty` integer not null
- `unit_cost` numeric(18,2) not null default 0
- `total_cost` numeric(18,2) not null default 0

### 13. `inventory_adjustment`

Header document for stock adjustments.

Columns:

- `id` serial primary key
- `adjustment_no` text not null unique
- `adjustment_date` timestamp not null default current_timestamp
- `reason` text not null
- `status` text not null default 'DRAFT'
- `created_by` text null
- `approved_by` text null
- `created_at` timestamp not null default current_timestamp

### 14. `inventory_adjustment_item`

Columns:

- `id` serial primary key
- `adjustment_id` integer not null references `inventory_adjustment(id)` on delete cascade
- `inventory_item_id` integer not null references `inventory_item(id)`
- `qty_diff` integer not null
- `unit_cost` numeric(18,2) not null default 0
- `note` text null

### 15. `inventory_period`

Header table for inventory closing period.

Columns:

- `id` serial primary key
- `period_year` integer not null
- `period_month` integer not null
- `status` text not null default 'OPEN'
- `closed_at` timestamp null
- `closed_by` text null
- `created_at` timestamp not null default current_timestamp

Unique constraint:

- `period_year`, `period_month`

Recommended `status` values:

- `OPEN`
- `CLOSING`
- `CLOSED`

### 16. `inventory_period_balance`

Snapshot of opening and closing balances.

Columns:

- `id` serial primary key
- `period_id` integer not null references `inventory_period(id)` on delete cascade
- `inventory_item_id` integer not null references `inventory_item(id)`
- `opening_qty` integer not null default 0
- `opening_value` numeric(18,2) not null default 0
- `closing_qty` integer not null default 0
- `closing_value` numeric(18,2) not null default 0

Unique constraint:

- `period_id`, `inventory_item_id`

## How Stock Originates from PurchaseApproval

### Recommended business flow

`purchase_approval` is the source document for receivable stock.

Recommended approach:

1. A `purchase_approval` record is created and approved.
2. The system exposes approved rows as pending warehouse receipts.
3. Warehouse staff performs receiving based on `purchase_approval`.
4. Receipt posting creates item master records as needed and writes inventory movements.

This is preferable to instant stock creation upon approval because it supports:

- partial receipt
- lot tracking
- bill number / vendor capture
- operational verification by warehouse staff
- audit trail

### Auto-origin requirement interpretation

If the requirement says warehouse stock must come from `purchase_approval` automatically, the system should treat `purchase_approval` as the authoritative source of inbound inventory. Warehouse receiving should not allow unrelated inbound creation unless explicitly created as a manual receipt type.

## Main Business Flows

### 1. Receipt from PurchaseApproval

Flow:

1. User approves purchase approval.
2. System marks the row as pending receipt.
3. Warehouse user opens pending receipt list.
4. Warehouse user confirms actual receiving quantity, lot, expiry, receipt bill number, and vendor.
5. System posts receipt.

System actions:

- upsert `inventory_item`
- create `inventory_receipt`
- create `inventory_receipt_item`
- create `inventory_movement` with `PURCHASE_APPROVAL_RECEIPT`
- update `inventory_balance`
- update `purchase_approval_inventory_link.received_qty`
- update `purchase_approval_inventory_link.inventory_receipt_status`

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
- update reserved quantity in `inventory_balance`
- optionally create reservation movement entry with `REQUISITION_RESERVE`

### 4. Issue and stock deduction

Flow:

1. Warehouse issues items physically.
2. System posts issue document.
3. Stock is deducted.

System actions:

- create `inventory_issue`
- create `inventory_issue_item`
- create `inventory_movement` with `ISSUE_APPROVED`
- decrease `on_hand_qty`
- decrease `reserved_qty`
- recalculate `available_qty`

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

- create `purchase_approval_inventory_link`
- backfill rows for existing `purchase_approval` records

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

- use `SELECT ... FOR UPDATE` when loading `inventory_balance` rows during stock-affecting transactions
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

- `inventory_warehouse`
- `inventory_location`
- `inventory_item`
- `inventory_balance`
- `inventory_movement`
- `inventory_receipt`
- `inventory_receipt_item`
- `purchase_approval_inventory_link`
- `inventory_requisition`
- `inventory_requisition_item`
- `inventory_issue`
- `inventory_issue_item`
- `inventory_adjustment`
- `inventory_adjustment_item`
- `inventory_period`
- `inventory_period_balance`

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

- `purchase_approval` = source of receivable stock
- warehouse user must confirm receipt before on-hand stock increases
- issue flow uses requisition -> approval -> posting
- all stock changes must write to `inventory_movement`
- balances are maintained summary values, not the only source of truth

## เอกสารส่งมอบสำหรับทีมพัฒนา

ส่วนนี้เป็น handoff note ของโมดูลคลังฉบับปฏิบัติจริง เพื่อให้ developer คนอื่นสามารถอ่านแล้วเข้าใจภาพรวมของระบบ, รู้ว่ามีอะไรถูก build แล้ว, อะไรยังเป็น MVP, และควรต่อยอดจากจุดใดโดยไม่ต้องไล่แกะโค้ดทั้งหมดใหม่

## สถานะปัจจุบันของระบบ

โมดูล `inventory` ถูกพัฒนาเป็น MVP ที่ใช้งานได้จริงบน Next.js App Router และ PostgreSQL ผ่าน `pg` แล้ว โดย flow หลักที่ทำงานได้ในปัจจุบันคือ:

- รับสินค้าเข้าคลังจาก `purchase_approval`
- ดูยอดคงคลังปัจจุบันจาก `inventory_balance`
- สร้างคำขอเบิกสินค้า
- อนุมัติคำขอเบิกและทำการ reserve stock
- บันทึกจ่ายสินค้าและตัด stock จริง
- ดู movement / stock ledger จาก `inventory_movement`

ระบบนี้ไม่ได้ใช้ Prisma และยึดหลักให้ `InventoryMovement` เป็นแหล่งอ้างอิงหลักของการเปลี่ยนแปลงสต็อก ส่วน `InventoryBalance` เป็น summary table สำหรับการอ่านเร็วและแสดงผลบน UI

## วัตถุประสงค์ทางธุรกิจของโมดูลคลัง

โมดูลนี้ถูกออกแบบมาเพื่อแก้ข้อจำกัดของโมดูล `Warehouse` เดิมที่เก็บข้อมูลหลายบทบาทไว้ในตารางเดียว ทำให้ audit ยากและขยาย flow เพิ่มได้ลำบาก

หลักคิดของโมดูลใหม่คือ:

- stock ต้นทางต้องมาจาก `purchase_approval`
- การรับเข้าและจ่ายออกต้องเกิดเป็น document ชัดเจน
- ทุกการเปลี่ยนแปลง stock ต้องมี ledger ย้อนกลับได้
- balance ที่ UI เห็นต้องอธิบายได้จาก movement จริง

## ขอบเขตที่ทำเสร็จแล้วในโค้ดปัจจุบัน

### Database / Schema

ใช้ migration ที่ `sql/inventory_module_v1.sql`

ตารางสำคัญที่ถูกสร้างแล้ว:

- `inventory_warehouse`
- `inventory_location`
- `inventory_item`
- `inventory_balance`
- `inventory_movement`
- `inventory_receipt`
- `inventory_receipt_item`
- `purchase_approval_inventory_link`
- `inventory_requisition`
- `inventory_requisition_item`
- `inventory_issue`
- `inventory_issue_item`
- `inventory_adjustment`
- `inventory_adjustment_item`
- `inventory_period`
- `inventory_period_balance`

ข้อมูลตั้งต้นที่มีอยู่แล้ว:

- warehouse หลัก `MAIN / คลังกลาง`
- backfill ข้อมูล `purchase_approval_inventory_link` จาก `purchase_approval`

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

ต้นทาง stock ไม่ได้เริ่มที่ `inventory_item` หรือ `inventory_balance` แต่เริ่มที่ `purchase_approval`

flow ปัจจุบัน:

1. `purchase_approval` ถูกใช้เป็น source ของรายการที่รอรับเข้า
2. `purchase_approval_inventory_link` เก็บสถานะว่าแต่ละรายการรับเข้าไปแล้วเท่าไร
3. เมื่อ user ทำ receipt:
   - หา/สร้าง `inventory_item`
   - หา/สร้าง `inventory_balance`
   - สร้าง `inventory_receipt` และ `inventory_receipt_item`
   - เขียน `inventory_movement` แบบ `PURCHASE_APPROVAL_RECEIPT`
   - update `inventory_balance`
   - update `purchase_approval_inventory_link`

### 2. Requisition and reservation

เมื่อ user สร้าง requisition:

1. สร้าง `inventory_requisition`
2. สร้าง `inventory_requisition_item`

เมื่อ approver อนุมัติ:

1. lock `inventory_requisition`
2. lock `inventory_requisition_item`
3. lock `inventory_balance`
4. เพิ่ม `reserved_qty`
5. ลด `available_qty`
6. เปลี่ยนสถานะ `inventory_requisition` และ line items

หมายเหตุ: flow ปัจจุบันยังไม่ insert movement แยกสำหรับ reserve แม้ใน design จะรองรับแนวคิด `REQUISITION_RESERVE`

### 3. Issue posting

เมื่อ user ทำ issue จาก requisition ที่อนุมัติแล้ว:

1. สร้าง `inventory_issue`
2. สร้าง `inventory_issue_item`
3. ลด `on_hand_qty`
4. ลด `reserved_qty`
5. คง `available_qty` ไว้ตามค่าที่ถูกลดไปตั้งแต่ขั้นอนุมัติ
6. เขียน `inventory_movement` แบบ `ISSUE_APPROVED`
7. อัปเดตสถานะ `inventory_requisition` เป็น `PARTIALLY_ISSUED` หรือ `ISSUED`

## Business Rules ที่สำคัญใน implementation ปัจจุบัน

### Receipt

- รับเข้าเกินจำนวนคงเหลือของ `purchase_approval` ไม่ได้
- support partial receipt
- ถ้ารับเข้าครบจะเปลี่ยน `purchase_approval_inventory_link.inventory_receipt_status` เป็น `RECEIVED`
- ถ้ายังไม่ครบจะเป็น `PARTIAL`

### Approve requisition

- อนุมัติเกิน `requested_qty` ไม่ได้
- อนุมัติเกิน `available_qty` ไม่ได้
- การอนุมัติจะไป reserve stock ทันทีด้วยการเพิ่ม `reserved_qty` และลด `available_qty`

### Issue posting

- จ่ายเกิน `approved_qty - issued_qty` ไม่ได้
- จ่ายเกิน `on_hand_qty` ไม่ได้
- จ่ายเกิน `reserved_qty` ไม่ได้
- การ issue จะลด `on_hand_qty` และ `reserved_qty`

## Source of Truth ที่ควรใช้เวลา debug

เวลา debug ปัญหา stock ให้ตรวจตามลำดับนี้:

1. `inventory_movement`
2. `inventory_balance`
3. `inventory_receipt` / `inventory_receipt_item`
4. `inventory_requisition` / `inventory_requisition_item`
5. `inventory_issue` / `inventory_issue_item`
6. `purchase_approval_inventory_link`
7. `inventory_warehouse` / `inventory_item`

หลักการคือห้ามแก้ปัญหาข้อมูลด้วย fallback ฝั่ง UI ถ้ายังไม่รู้ว่าต้นทางใน DB ถูกหรือไม่

## สิ่งที่พบจริงระหว่างพัฒนาและทดสอบ

### 1. ปัญหาข้อมูลชื่อคลังใน DB

เคยพบกรณี `inventory_warehouse.warehouse_name` ถูกเก็บเป็น `????????...` ทำให้หน้า stock แสดงชื่อคลังพัง

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
