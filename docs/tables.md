# Database Tables Summary

| ลำดับ | ชื่อตาราง | เก็บอะไร | รายการชื่อฟิลด์ |
| --- | --- | --- | --- |
| 1 | category | รายการหมวด / ประเภท / ประเภทย่อย | `category`, `type`, `subtype` |
| 2 | department | รายชื่อหน่วยงาน | `name` |
| 3 | seller | ข้อมูลผู้ขาย/ผู้จัดจำหน่าย | `code`, `name`, `business`, `address`, `phone`, `fax`, `mobile` |
| 4 | user | บัญชีผู้ใช้งานระบบ | `email`, `name`, `password`, `created_at`, `updated_at` |
| 5 | product | สินค้าในระบบ (catalog) | `code`, `name`, `category`, `type`, `subtype`, `unit`, `cost_price`, `sell_price`, `stock_balance`, `seller_code`, `image`, `flag_activate`, `admin_note` |
| 6 | usage_plan | แผนการใช้สินค้า/งบประมาณ | `product_code`, `category`, `type`, `subtype`, `product_name`, `requested_amount`, `unit`, `price_per_unit`, `requesting_dept`, `approved_quota`, `budget_year`, `sequence_no`, `created_at`, `updated_at` |
| 7 | purchase_plan | แผนจัดซื้อที่สรุปจาก usage plan | `product_code`, `category`, `product_name`, `product_type`, `product_subtype`, `unit`, `price_per_unit`, `budget_year`, `plan_id`, `in_plan`, `carried_forward_quantity`, `carried_forward_value`, `required_quantity_for_year`, `total_required_value`, `additional_purchase_qty`, `additional_purchase_value`, `purchasing_department` |
| 8 | purchase_approval | เอกสารขออนุมัติจัดซื้อ | `approval_id`, `department`, `record_number`, `request_date`, `product_name`, `product_code`, `category`, `product_type`, `product_subtype`, `requested_quantity`, `unit`, `price_per_unit`, `total_value`, `over_plan_case`, `requester`, `approver`, `budget_year`, `created_at`, `updated_at` |
| 9 | purchase_approval_inventory_link | สถานะรับของจากแต่ละ approval | `purchase_approval_id`, `inventory_receipt_status`, `received_qty`, `last_receipt_id`, `created_at`, `updated_at` |
|10 | inventory_item | รายการสินค้าคงคลัง (ผูก product กับคลัง/ที่จัดเก็บ) | `product_code`, `product_name`, `category`, `product_type`, `product_subtype`, `unit`, `warehouse_id`, `location_id`, `lot_no`, `expiry_date`, `standard_cost`, `is_active`, `created_at`, `updated_at` |
|11 | inventory_warehouse | คลังสินค้า | `warehouse_code`, `warehouse_name`, `is_active`, `created_at`, `updated_at` |
|12 | inventory_location | ตำแหน่งจัดเก็บภายในคลัง | `warehouse_id`, `location_code`, `location_name`, `is_active`, `created_at`, `updated_at` |
|13 | inventory_balance | ยอดสต็อกปัจจุบันต่อ item | `inventory_item_id`, `on_hand_qty`, `reserved_qty`, `available_qty`, `avg_cost`, `last_movement_at`, `updated_at` |
|14 | inventory_period | งวดบัญชีสต็อก | `period_year`, `period_month`, `status`, `closed_at`, `closed_by`, `created_at` |
|15 | inventory_period_balance | ยอดเปิด/ปิดตามงวด | `period_id`, `inventory_item_id`, `opening_qty`, `opening_value`, `closing_qty`, `closing_value` |
|16 | inventory_adjustment | เอกสารปรับยอดสต็อก | `adjustment_no`, `adjustment_date`, `reason`, `status`, `created_by`, `approved_by`, `created_at` |
|17 | inventory_adjustment_item | รายการในเอกสารปรับยอด | `adjustment_id`, `inventory_item_id`, `qty_diff`, `unit_cost`, `note` |
|18 | inventory_movement | เล่มประวัติความเคลื่อนไหวสต็อก | `inventory_item_id`, `movement_date`, `movement_type`, `qty_in`, `qty_out`, `unit_cost`, `total_cost`, `reference_type`, `reference_id`, `reference_no`, `source_department`, `target_department`, `note`, `created_by`, `created_at` |
|19 | inventory_receipt | ใบรับเข้าสินค้าคงคลัง | `receipt_no`, `receipt_date`, `receipt_type`, `status`, `vendor_name`, `source_reference_type`, `source_reference_id`, `source_reference_no`, `note`, `created_by`, `approved_by`, `created_at`, `updated_at` |
|20 | inventory_receipt_item | รายการในใบรับสินค้า | `receipt_id`, `inventory_item_id`, `purchase_approval_id`, `qty`, `unit_cost`, `total_cost`, `lot_no`, `expiry_date` |
|21 | inventory_issue | ใบเบิก/จ่ายสินค้าคงคลัง | `issue_no`, `issue_date`, `requisition_id`, `requesting_department`, `status`, `issued_by`, `approved_by`, `note`, `created_at` |
|22 | inventory_issue_item | รายการในใบเบิก | `issue_id`, `requisition_item_id`, `inventory_item_id`, `issued_qty`, `unit_cost`, `total_cost` |
|23 | inventory_requisition | ใบขอเบิกก่อนเบิกจริง | `requisition_no`, `request_date`, `requesting_department`, `status`, `requested_by`, `approved_by`, `approved_at`, `issued_by`, `issued_at`, `note`, `created_at`, `updated_at` |
|24 | inventory_requisition_item | รายการในใบขอเบิก | `requisition_id`, `inventory_item_id`, `requested_qty`, `approved_qty`, `issued_qty`, `unit_cost_at_issue`, `line_status`, `note` |
|25 | warehouse | บันทึกทรานแซกชันรวม/ประวัติสรุป (legacy) | `stock_id`, `transaction_type`, `transaction_date`, `category`, `product_type`, `product_subtype`, `product_code`, `product_name`, `product_image`, `unit`, `product_lot`, `product_price`, `received_from_company`, `receipt_bill_number`, `requesting_department`, `requisition_number`, `quota_amount`, `carried_forward_qty`, `carried_forward_value`, `transaction_price`, `transaction_quantity`, `transaction_value`, `remaining_quantity`, `remaining_value`, `inventory_status` |

> หมายเหตุ: ตาราง `_prisma_migrations` ถูกลบตามคำขอของผู้ใช้ จึงไม่ถูกรวมอยู่ในเอกสารนี้
