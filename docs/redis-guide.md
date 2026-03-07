# คู่มือการใช้งาน Redis Caching (ฉบับสมบูรณ์)

**ปรับปรุงล่าสุด:** 7 มีนาคม 2026
**สถานะ:** Implementation ครบทุก Module หลัก

เอกสารฉบับนี้สรุปการนำ Redis มาใช้เพื่อเพิ่มประสิทธิภาพ (Performance) ให้กับระบบ ERP โดยครอบคลุมทั้งการดึงข้อมูล (Read) และการล้างข้อมูล (Invalidation) เมื่อมีการเปลี่ยนแปลง

---

## 1. โครงสร้างพื้นฐาน (Infrastructure)

ใช้ **Redis 7 (Alpine)** ทำงานบน Docker:

- **Connection Logic:** จัดการผ่าน `src/lib/redis.ts` (ใช้ IORedis)
- **Utility Functions:** แนะนำให้ใช้ Helper Functions แทนการเรียก IORedis โดยตรงเพื่อความปลอดภัย:
  - `cacheGet<T>(key: string): Promise<T | null>`
  - `cacheSet(key: string, value: any, ttl?: number): Promise<void>`
  - `cacheDelByPattern(pattern: string): Promise<void>`

---

## 2. กลยุทธ์การทำ Caching (Caching Strategy)

ใช้รูปแบบ **Cache-Aside Pattern** และ **Pattern-based Invalidation**:

- **Naming Convention:** `erp:{module}:{type}:{params_or_id}`
  - ตัวอย่าง: `erp:products:list:{"page":1,"pageSize":20}`
- **TTL (Time To Live):**
  - **Volatile (ข้อมูลเปลี่ยนบ่อย):** 5-10 นาที (Inventory, Requisitions, Issues)
  - **Semi-Volatile:** 30 นาที (Purchase Plans, Surveys, Products)
  - **Stable (ข้อมูลตั้งค่า):** 60 นาที (Categories, Sellers, Departments, Warehouse)

---

## 3. รายการ Module ที่รองรับ Caching

ระบบได้ทำการ Implement Redis Caching แล้วในส่วนต่อไปนี้:

1.  **Inventory Module:**
    - Balances (`/api/inventory/balances`)
    - Pending Receipts (`/api/inventory/receipts/pending-purchase-approvals`)
    - Requisitions (`/api/inventory/requisitions`)
    - Issues (`/api/inventory/issues`)
2.  **Purchase Module:**
    - Purchase Plans (`/api/purchase-plans`)
    - Purchase Approvals (`/api/purchase-approvals`)
3.  **Master Data:**
    - Products & Categories
    - Sellers
    - Departments
    - Warehouse & Locations
4.  **Filters:**
    - ระบบ Dropdown Filter ทั้งหมด (Categories, Products, Purchase, Warehouse)

---

## 4. มาตรฐานโค้ดตัวอย่าง (Code Standard)

### การดึงข้อมูล (GET)

```typescript
const cacheKey = `erp:module:list:${JSON.stringify(params)}`;
const cached = await cacheGet<any>(cacheKey);
if (cached) return apiSuccess(cached.items, undefined, cached.totalCount);

// หากไม่มีใน Cache ให้ Query DB...
const result = await pgQuery(...);
await cacheSet(cacheKey, result, 3600); // เก็บไว้ 1 ชม.
```

### การล้างข้อมูล (POST/PUT/DELETE)

ต้องทำการล้าง Cache ด้วย **Pattern** เสมอเพื่อให้ข้อมูลในหน้า Listing เป็นปัจจุบัน:

```typescript
await client.query("COMMIT");
await cacheDelByPattern("erp:module:list:*"); // ลบ Cache ทุกหน้าที่เกี่ยวข้องกับ List ของ Module นี้
```

---

## 5. การจัดการข้อผิดพลาด (Graceful Fallback)

Helper Functions ใน `src/lib/redis.ts` ถูกออกแบบมาให้:

- หาก Redis Down ระบบจะไม่ Error แต่จะ **Log Warning** และข้ามไป Query Database ทันที
- เมื่อ Redis กลับมาทำงาน ระบบจะ Caching ต่อโดยอัตโนมัติ

---

## 6. การตรวจสอบ (Monitoring)

สามารถตรวจสอบการทำงานของ Redis ได้ผ่าน Docker:

```bash
docker exec -it redis-container redis-cli monitor
```

หรือใช้คำสั่งเช็ค Keys:

```bash
docker exec -it redis-container redis-cli keys "erp:*"
```
