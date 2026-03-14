# Database Tables Summary

| ลำดับ | ชื่อตาราง | เก็บอะไร | รายการชื่อฟิลด์ |
| --- | --- | --- | --- |
| 1 | category | รายการหมวด / ประเภท / ประเภทย่อย | `id`, `category`, `type`, `subtype`, `category_code` |
| 2 | department | รายชื่อหน่วยงาน | `id`, `name`, `department_code` |
| 3 | seller | ข้อมูลผู้ขาย/ผู้จัดจำหน่าย | `id`, `code`, `prefix`, `name`, `business`, `address`, `phone`, `fax`, `mobile` |
| 4 | product | สินค้าในระบบ (catalog) | `id`, `code`, `category`, `name`, `type`, `subtype`, `unit`, `cost_price`, `sell_price`, `stock_balance`, `stock_value`, `seller_code`, `image`, `flag_activate`, `admin_note` |
| 5 | usage_plan | แผนการใช้สินค้า/งบประมาณ | `id`, `product_code`, `category`, `type`, `subtype`, `product_name`, `requested_amount`, `unit`, `price_per_unit`, `requesting_dept`, `requesting_dept_code`, `approved_quota`, `budget_year`, `sequence_no`, `created_at`, `updated_at` |
| 6 | purchase_plan | แผนจัดซื้อที่สรุปจาก usage plan | `id`, `usage_plan_id`, `inventory_qty`, `inventory_value`, `purchase_qty`, `purchase_value` |
| 7 | purchase_approval | เอกสารขออนุมัติจัดซื้อ | `id`, `approve_code`, `doc_no`, `doc_date`, `status`, `total_amount`, `total_items`, `prepared_by`, `approved_by`, `approved_at`, `notes`, `created_by`, `created_at`, `updated_by`, `updated_at`, `version` |
| 8 | purchase_approval_inventory_link | สถานะรับของจากแต่ละ approval | `id`, `purchase_approval_id`, `purchase_approval_detail_id`, `inventory_receipt_status`, `received_qty`, `last_receipt_id`, `created_at`, `updated_at` |
| 9 | inventory_item | รายการสินค้าคงคลัง (ผูก product กับคลัง/ที่จัดเก็บ) | `id`, `product_code`, `product_name`, `category`, `product_type`, `product_subtype`, `unit`, `warehouse_id`, `location_id`, `lot_no`, `expiry_date`, `standard_cost`, `is_active`, `created_at`, `updated_at` |
|10 | inventory_warehouse | คลังสินค้า | `id`, `warehouse_code`, `warehouse_name`, `is_active`, `created_at`, `updated_at` |
|11 | inventory_location | ตำแหน่งจัดเก็บภายในคลัง | `id`, `warehouse_id`, `location_code`, `location_name`, `is_active`, `created_at`, `updated_at` |
|12 | inventory_balance | ยอดสต็อกปัจจุบันต่อ item | *ดูเพิ่มเติมใน schema* |
|13 | inventory_period | งวดบัญชีสต็อก | *ดูเพิ่มเติมใน schema* |
|14 | inventory_period_balance | ยอดเปิด/ปิดตามงวด | *ดูเพิ่มเติมใน schema* |
|15 | inventory_adjustment | เอกสารปรับยอดสต็อก | *ดูเพิ่มเติมใน schema* |
|16 | inventory_adjustment_item | รายการในเอกสารปรับยอด | *ดูเพิ่มเติมใน schema* |
|17 | inventory_movement | เล่มประวัติความเคลื่อนไหวสต็อก | *ดูเพิ่มเติมใน schema* |
|18 | inventory_receipt | ใบรับเข้าสินค้าคงคลัง | *ดูเพิ่มเติมใน schema* |
|19 | inventory_receipt_item | รายการในใบรับสินค้า | *ดูเพิ่มเติมใน schema* |
|20 | inventory_issue | ใบเบิก/จ่ายสินค้าคงคลัง | *ดูเพิ่มเติมใน schema* |
|21 | inventory_issue_item | รายการในใบเบิก | *ดูเพิ่มเติมใน schema* |
|22 | inventory_requisition | ใบขอเบิกก่อนเบิกจริง | *ดูเพิ่มเติมใน schema* |
|23 | inventory_requisition_item | รายการในใบขอเบิก | *ดูเพิ่มเติมใน schema* |
|24 | warehouse | บันทึกทรานแซกชันรวม/ประวัติสรุป (legacy) | *ดูเพิ่มเติมใน schema* |

## ตารางเพิ่มเติมที่พบในระบบ

| ชื่อตาราง | คำอธิบาย |
| --- | --- |
| purchase_approval_backup | ตารางสำรองของ purchase_approval |
| purchase_approval_detail | รายละเอียดเอกสารอนุมัติจัดซื้อ |
| purchase_approval_inventory_link_backup | ตารางสำรองของ purchase_approval_inventory_link |
| test_data | ตารางข้อมูลทดสอบ |

> หมายเหตุ:
>
> - ตาราง `_prisma_migrations` ถูกลบตามคำขอของผู้ใช้ จึงไม่ถูกรวมอยู่ในเอกสารนี้
> - ข้อมูลจาก schema จริงใน Docker Supabase (PostgreSQL) เมื่อ 14 มี.ค. 2569
> - บางตารางมีฟิลด์เพิ่มเติมที่ไม่ได้แสดงในตารางหลัก สามารถตรวจสอบได้จาก database schema โดยตรง
