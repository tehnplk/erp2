# Database Tables Summary

| ลำดับ | ชื่อตาราง | เก็บอะไร | รายการชื่อฟิลด์ |
| --- | --- | --- | --- |
| 1 | Category | รายการหมวด / ประเภท / ประเภทย่อย | `category`, `type`, `subtype` |
| 2 | Department | รายชื่อหน่วยงาน | `name` |
| 3 | Seller | ข้อมูลผู้ขาย/ผู้จัดจำหน่าย | `code`, `name`, `business`, `address`, `phone`, `fax`, `mobile` |
| 4 | User | บัญชีผู้ใช้งานระบบ | `email`, `name`, `password`, `createdAt`, `updatedAt` |
| 5 | Product | สินค้าในระบบ (catalog) | `code`, `name`, `category`, `type`, `subtype`, `unit`, `costPrice`, `sellPrice`, `stockBalance`, `sellerCode`, `image`, `flagActivate`, `adminNote` |
| 6 | UsagePlan | แผนการใช้สินค้า/งบประมาณ | `productCode`, `category`, `type`, `subtype`, `productName`, `requestedAmount`, `unit`, `pricePerUnit`, `requestingDept`, `approvedQuota`, `budget_year`, `sequence_no`, `created_at`, `updated_at` |
| 7 | PurchasePlan | แผนจัดซื้อที่สรุปจาก usage plan | `productCode`, `category`, `productName`, `productType`, `productSubtype`, `unit`, `pricePerUnit`, `budgetYear`, `planId`, `inPlan`, `carriedForwardQuantity`, `carriedForwardValue`, `requiredQuantityForYear`, `totalRequiredValue`, `additionalPurchaseQty`, `additionalPurchaseValue`, `purchasingDepartment` |
| 8 | PurchaseApproval | เอกสารขออนุมัติจัดซื้อ | `approvalId`, `department`, `recordNumber`, `requestDate`, `productName`, `productCode`, `category`, `productType`, `productSubtype`, `requestedQuantity`, `unit`, `pricePerUnit`, `totalValue`, `overPlanCase`, `requester`, `approver`, `budgetYear`, `created_at`, `updated_at` |
| 9 | PurchaseApprovalInventoryLink | สถานะรับของจากแต่ละ approval | `purchaseApprovalId`, `inventoryReceiptStatus`, `receivedQty`, `lastReceiptId`, `created_at`, `updated_at` |
|10 | InventoryItem | รายการสินค้าคงคลัง (ผูก product กับคลัง/ที่จัดเก็บ) | `productCode`, `productName`, `category`, `productType`, `productSubtype`, `unit`, `warehouseId`, `locationId`, `lotNo`, `expiryDate`, `standardCost`, `isActive`, `created_at`, `updated_at` |
|11 | InventoryWarehouse | คลังสินค้า | `warehouseCode`, `warehouseName`, `isActive`, `created_at`, `updated_at` |
|12 | InventoryLocation | ตำแหน่งจัดเก็บภายในคลัง | `warehouseId`, `locationCode`, `locationName`, `isActive`, `created_at`, `updated_at` |
|13 | InventoryBalance | ยอดสต็อกปัจจุบันต่อ item | `inventoryItemId`, `onHandQty`, `reservedQty`, `availableQty`, `avgCost`, `lastMovementAt`, `updated_at` |
|14 | InventoryPeriod | งวดบัญชีสต็อก | `periodYear`, `periodMonth`, `status`, `closedAt`, `closedBy`, `created_at` |
|15 | InventoryPeriodBalance | ยอดเปิด/ปิดตามงวด | `periodId`, `inventoryItemId`, `openingQty`, `openingValue`, `closingQty`, `closingValue` |
|16 | InventoryAdjustment | เอกสารปรับยอดสต็อก | `adjustmentNo`, `adjustmentDate`, `reason`, `status`, `createdBy`, `approvedBy`, `created_at` |
|17 | InventoryAdjustmentItem | รายการในเอกสารปรับยอด | `adjustmentId`, `inventoryItemId`, `qtyDiff`, `unitCost`, `note` |
|18 | InventoryMovement | เล่มประวัติความเคลื่อนไหวสต็อก | `inventoryItemId`, `movementDate`, `movementType`, `qtyIn`, `qtyOut`, `unitCost`, `totalCost`, `referenceType`, `referenceId`, `referenceNo`, `sourceDepartment`, `targetDepartment`, `note`, `createdBy`, `created_at` |
|19 | InventoryReceipt | ใบรับเข้าสินค้าคงคลัง | `receiptNo`, `receiptDate`, `receiptType`, `status`, `vendorName`, `sourceReferenceType`, `sourceReferenceId`, `sourceReferenceNo`, `note`, `createdBy`, `approvedBy`, `created_at`, `updated_at` |
|20 | InventoryReceiptItem | รายการในใบรับสินค้า | `receiptId`, `inventoryItemId`, `purchaseApprovalId`, `qty`, `unitCost`, `totalCost`, `lotNo`, `expiryDate` |
|21 | InventoryIssue | ใบเบิก/จ่ายสินค้าคงคลัง | `issueNo`, `issueDate`, `requisitionId`, `requestingDepartment`, `status`, `issuedBy`, `approvedBy`, `note`, `created_at` |
|22 | InventoryIssueItem | รายการในใบเบิก | `issueId`, `requisitionItemId`, `inventoryItemId`, `issuedQty`, `unitCost`, `totalCost` |
|23 | InventoryRequisition | ใบขอเบิกก่อนเบิกจริง | `requisitionNo`, `requestDate`, `requestingDepartment`, `status`, `requestedBy`, `approvedBy`, `approvedAt`, `issuedBy`, `issuedAt`, `note`, `created_at`, `updated_at` |
|24 | InventoryRequisitionItem | รายการในใบขอเบิก | `requisitionId`, `inventoryItemId`, `requestedQty`, `approvedQty`, `issuedQty`, `unitCostAtIssue`, `lineStatus`, `note` |
|25 | Warehouse | บันทึกทรานแซกชันรวม/ประวัติสรุป | `stockId`, `transactionType`, `transactionDate`, `category`, `productType`, `productSubtype`, `productCode`, `productName`, `productImage`, `unit`, `productLot`, `productPrice`, `receivedFromCompany`, `receiptBillNumber`, `requestingDepartment`, `requisitionNumber`, `quotaAmount`, `carriedForwardQty`, `carriedForwardValue`, `transactionPrice`, `transactionQuantity`, `transactionValue`, `remainingQuantity`, `remainingValue`, `inventoryStatus` |

> หมายเหตุ: ตาราง `_prisma_migrations` ถูกลบตามคำขอของผู้ใช้ จึงไม่ถูกรวมอยู่ในเอกสารนี้
