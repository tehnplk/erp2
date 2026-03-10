# Inventory Module Updates (2026-03-07)

เอกสารนี้แสดงรายละเอียดการอัปเดตโมดูล Inventory โดยสานต่อจาก Hand-off note ฉบับดั้งเดิม (`inventory-module-redesign.md`) ในส่วนของ **Priority 1**

## ภาพรวมการแก้ไข

การแก้ไขครอบคลุมส่วน Backend API และ Frontend UI เพื่อให้ Flow การจัดการเบิก-จ่ายสมบูรณ์มากยิ่งขึ้น:

1.  **เพิ่มระบบบันทึกลง Ledger (InventoryMovement) เมื่อทำการจองสินค้า (Reserve)**
2.  **รองรับการคืนยอดจองสินค้า (Unreserve/Cancel) เมื่อมีการยกเลิกคำขอเบิกหรือปรับลดยอดที่อนุมัติ**
3.  **หน้าจอจ่ายสินค้า (Issues) สามารถระบุจำนวนที่จะจ่ายแยกสัดส่วน (Partial Issue) ด้วยการกรอกตัวเลขแบบ Manual**

---

## 1. Backend / API Changes

### 1.1 ปรับปรุง API อนุมัติการเบิก (Approve Requisition)

**ไฟล์:** `src/app/api/inventory/requisitions/approve/route.ts`

- **Reserve Movement:** เพิ่มการ Insert เข้าตาราง `InventoryMovement` ชนิด `REQUISITION_RESERVE` เมื่อมีการอนุมัติให้หักจากยอดพร้อมใช้ (`availableQty`) ไปไว้ที่ยอดจอง (`reservedQty`)
- **Unreserve On Edit:** ปรับปรุง API ให้รองรับการแก้ไขยอดอนุมัติ (Edit Approval) โดยอ่านยอดอนุมัติเดิม (`oldApprovedQty`) มาหาส่วนต่าง (`diffQty`)
  - หากเปลี่ยนเป้าหมายลดลง (ยอดส่วนต่างติดลบ) ระบบจะ Insert เป็น `REQUISITION_UNRESERVE` คืนสต็อกที่พร้อมใช้ (Available) ทันที

### 1.2 เพิ่ม API ใหม่สำหรับยกเลิกคำขอเบิก (Cancel Requisition)

**ไฟล์:** `src/app/api/inventory/requisitions/cancel/route.ts`

- **วัตถุประสงค์:** ออกแบบมาเพื่อระงับและยกเลิกคำขอเบิก (เฉพาะคำขอที่ยังจ่ายไม่ครบ หรือยังไม่ถูกยกเลิก/ปฏิเสธ)
- **การทำงาน:**
  1. ดึงข้อมูล Items ที่ถูกจองเอาไว้แต่ยังไม่ได้จ่ายจริง (`approvedQty` - `issuedQty`)
  2. ยกเลิกการจองสินค้า (Unreserve) ให้กลับไปเป็น Available Quantity ใน `InventoryBalance`
  3. เพิ่มประวัติลงยอดคงคลัง (Ledger) ใน `InventoryMovement` ประเภท `REQUISITION_UNRESERVE`
  4. อัปเดตสถานะ Line Items `lineStatus` เป็น `CANCELLED`
  5. อัปเดตสถานะเอกสาร `status` เป็น `CANCELLED`

---

## 2. Frontend / UI Changes

### 2.1 ปรับปรุง UI หน้าจ่ายสินค้า (Issue Items)

**ไฟล์:** `src/app/inventory/issues/page.tsx`

- **แบบเดิม:** เมื่อเลือกคำขอเบิก ระบบจะโยนจำนวนคงเหลือทั้งหมดของทุกรายการไปจ่ายแบบอัตโนมัติ
- **แบบใหม่ (Partial Issue UI):**
  - เพิ่มช่องกรอก Input แบบ `type="number"` ในตาราง สำหรับแต่ละรายการสินค้า (Line item)
  - กำหนด Default เป็นยอดที่ยังค้างจ่าย (Remaining Approved Qty)
  - ผู้ใช้งานสามารถกรอกปรับลดยอดจ่ายได้ (Partial Issue) เช่น อนุมัติ 10 แต่อยากจ่ายให้ก่อน 5 ก็พิมพ์ 5 ลงไปได้
  - ควบคุมไม่ให้ผู้ใช้กรอกตัวเลขยอดจ่ายเกินกว่ายอดที่ได้รับการอนุมัติ

### 2.2 ปรับปรุง UI หน้าคำขอเบิก (Requisitions)

**ไฟล์:** `src/app/inventory/requisitions/page.tsx`

- **ฟังก์ชันปุ่ม Cancel (ระงับ/ยกเลิกคำขอ):** เพิ่มปุ่ม Action "ยกเลิก" ถัดจากปุ่มอนุมัติ สำหรับใบเบิกที่ยังไม่เข้าเคส `ISSUED` ทำครบ 100%, `CANCELLED` หรือ `REJECTED` ไปแล้ว
- **แจ้งเตือนยืนยัน:** ระบบจะถาม Confirm ("ต้องการยกเลิกคำขอเบิก xx ใช่หรือไม่?") ก่อนที่จะยิง API `/cancel` เพื่อป้องกันความผิดพลาด
- เมื่อยกเลิกสำเร็จ ระบบจะดึงยอดต่างๆ กลับมาเป็น 0 (สำหรับส่วนที่ยังค้าง) และคืนสต็อกพร้อมใช้ทันที

---

## สรุปหลักการ

การอัปเดตครั้งนี้ยึดหลัก Invariant Data ตามข้อเสนอแนะในหน้า Docs ดั้งเดิม:

- สิ่งสำคัญที่สุดคือ **InventoryMovement (Ledger)** เป็นตัวรวบรวมเหตุการณ์ที่มาที่ไปของสต็อกทั้งหมด
- สินค้าที่ถูกขยับผ่านสถานะจอง (`reservedQty`) หรือพร้อมใช้ (`availableQty`) ครั้งนี้มีรากฐาน Ledger สนับสนุนเรียบร้อยแล้ว ทำให้เวลากลับมาตรวจสอบหาข้อผิดพลาด สามารถ Audit ย้อนกลับได้ตรงไปตรงมา
