'use client';

import { useEffect, useMemo, useState } from 'react';
import Link from 'next/link';

type PendingReceiptRow = {
  id: number;
  approval_id: string | null;
  department: string | null;
  budget_year: number | null;
  record_number: string | null;
  request_date: string | null;
  product_code: string | null;
  product_name: string | null;
  category: string | null;
  product_type: string | null;
  product_subtype: string | null;
  requested_quantity: number | null;
  unit: string | null;
  price_per_unit: number | null;
  total_value: number | null;
  inventory_receipt_status: string;
  received_qty: number;
  remaining_qty: number;
};

type ApiResponse<T> = {
  success: boolean;
  data: T;
  totalCount?: number;
  error?: string;
};

type WarehouseOption = {
  id: number;
  warehouse_code: string;
  warehouse_name: string;
};

function formatNumber(value: number) {
  return new Intl.NumberFormat('th-TH').format(value);
}

function formatCurrency(value: number) {
  return new Intl.NumberFormat('th-TH', {
    style: 'currency',
    currency: 'THB',
    maximumFractionDigits: 0,
  }).format(value);
}

export default function InventoryReceiptsPage() {
  const [items, setItems] = useState<PendingReceiptRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [submitting_id, setSubmittingId] = useState<number | null>(null);
  const [message, setMessage] = useState<string>('');
  const [warehouse_id, setWarehouseId] = useState('1');
  const [warehouses, setWarehouses] = useState<WarehouseOption[]>([]);
  const [warehousesLoading, setWarehousesLoading] = useState(false);
  const [warehousesError, setWarehousesError] = useState('');
  const [product_name_filter, setProductNameFilter] = useState('');

  const filteredItems = useMemo(() => {
    if (!product_name_filter.trim()) {
      return items;
    }

    return items.filter((item) => `${item.product_code || ''} ${item.product_name || ''}`.toLowerCase().includes(product_name_filter.toLowerCase()));
  }, [items, product_name_filter]);

  const fetchItems = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/inventory/receipts/pending-purchase-approvals?page=1&page_size=200');
      const payload: ApiResponse<PendingReceiptRow[]> = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'โหลดรายการรอรับเข้าไม่สำเร็จ');
      }
      setItems(payload.data || []);
    } catch (error) {
      console.error(error);
      setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการโหลดข้อมูล');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchItems();
  }, []);

  const fetchWarehouses = async () => {
    try {
      setWarehousesLoading(true);
      setWarehousesError('');
      const response = await fetch('/api/inventory/warehouses');
      const payload: ApiResponse<WarehouseOption[]> = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'โหลดรายชื่อคลังสินค้าไม่สำเร็จ');
      }
      const data = payload.data || [];
      setWarehouses(data);
      if (data.length > 0) {
        setWarehouseId(String(data[0].id));
      }
    } catch (error) {
      console.error(error);
      setWarehousesError(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการโหลดรายชื่อคลังสินค้า');
    } finally {
      setWarehousesLoading(false);
    }
  };

  useEffect(() => {
    fetchWarehouses();
  }, []);

  const handleReceive = async (item: PendingReceiptRow) => {
    try {
      setSubmittingId(item.id);
      setMessage('');
      const response = await fetch('/api/inventory/receipts/from-purchase-approval', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          purchase_approval_id: item.id,
          warehouse_id: Number(warehouse_id),
          qty: item.remaining_qty,
          unit_cost: item.price_per_unit || 0,
          note: `Auto receipt from PurchaseApproval ${item.record_number || item.id}`,
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'รับเข้าสินค้าไม่สำเร็จ');
      }

      setMessage(`บันทึกรับสินค้า ${item.product_name || item.product_code} เข้าคลังเรียบร้อยแล้ว`);
      await fetchItems();
    } catch (error) {
      console.error(error);
      setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการรับเข้า');
    } finally {
      setSubmittingId(null);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-6 flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
          <div>
            <p className="text-sm font-medium uppercase tracking-[0.2em] text-slate-500">Inventory Receipts</p>
            <h1 className="mt-1 text-3xl font-bold text-slate-900">บันทึกรับสินค้าเข้าคลัง</h1>
            <p className="mt-2 text-sm text-slate-600">ตรวจสอบรายการจัดซื้อที่อนุมัติแล้วและยังรับสินค้าเข้าคลังไม่ครบ เพื่อดำเนินการรับเข้าอย่างถูกต้อง</p>
          </div>
          <div className="flex gap-3">
            <Link href="/inventory" className="rounded-xl border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-100">
              กลับหน้าหลักระบบคลังสินค้า
            </Link>
          </div>
        </div>

        <div className="mb-4 grid grid-cols-1 gap-4 rounded-2xl border border-slate-200 bg-white p-4 shadow-sm md:grid-cols-3">
          <label className="text-sm text-slate-600">
            ค้นหาสินค้า
            <input
              value={product_name_filter}
              onChange={(e) => setProductNameFilter(e.target.value)}
              placeholder="ค้นหาจากรหัสหรือชื่อสินค้า"
              className="mt-2 w-full rounded-xl border border-slate-300 px-3 py-2 text-slate-900 outline-none ring-0 focus:border-blue-500"
            />
          </label>
          <label className="text-sm text-slate-600">
            รหัสคลัง
            <select
              value={warehouse_id}
              onChange={(e) => setWarehouseId(e.target.value)}
              className="mt-2 w-full rounded-xl border border-slate-300 bg-white px-3 py-2 text-slate-900 outline-none ring-0 focus:border-blue-500"
              disabled={warehousesLoading || warehouses.length === 0}
            >
              {warehousesLoading ? (
                <option value="">กำลังโหลด...</option>
              ) : warehouses.length === 0 ? (
                <option value="">ไม่มีคลังสินค้า</option>
              ) : (
                warehouses.map((warehouse) => (
                  <option key={warehouse.id} value={warehouse.id}>
                    {warehouse.warehouse_code} - {warehouse.warehouse_name}
                  </option>
                ))
              )}
            </select>
            {warehousesError ? <p className="mt-2 text-xs text-red-600">{warehousesError}</p> : null}
          </label>
          <div className="rounded-xl bg-slate-50 p-4 text-sm text-slate-600">
            <p className="font-medium text-slate-900">คำแนะนำการใช้งาน</p>
            <p className="mt-2">ใช้ปุ่ม “รับเข้าทั้งค้าง” เพื่อบันทึกรับเข้าสินค้าตามจำนวนคงเหลือรับเข้าของแต่ละรายการโดยอัตโนมัติ</p>
          </div>
        </div>

        {message ? (
          <div className="mb-4 rounded-2xl border border-blue-200 bg-blue-50 px-4 py-3 text-sm text-blue-800">
            {message}
          </div>
        ) : null}

        <div className="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200 text-sm">
              <thead className="bg-slate-100 text-left text-xs uppercase tracking-wider text-slate-500">
                <tr>
                  <th className="px-4 py-3">รหัสสินค้า</th>
                  <th className="px-4 py-3">ชื่อสินค้า</th>
                  <th className="px-4 py-3">หน่วยงาน</th>
                  <th className="px-4 py-3">ปีงบ</th>
                  <th className="px-4 py-3 text-right">ขอซื้อ</th>
                  <th className="px-4 py-3 text-right">รับเข้าแล้ว</th>
                  <th className="px-4 py-3 text-right">คงเหลือรับเข้า</th>
                  <th className="px-4 py-3 text-right">ราคา/หน่วย</th>
                  <th className="px-4 py-3">สถานะ</th>
                  <th className="px-4 py-3 text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 bg-white">
                {loading ? (
                  <tr>
                    <td colSpan={10} className="px-4 py-10 text-center text-slate-500">กำลังโหลดข้อมูล...</td>
                  </tr>
                ) : filteredItems.length === 0 ? (
                  <tr>
                    <td colSpan={10} className="px-4 py-10 text-center text-slate-500">ไม่พบรายการรอรับเข้า</td>
                  </tr>
                ) : (
                  filteredItems.map((item) => (
                    <tr key={item.id} className="hover:bg-slate-50">
                      <td className="px-4 py-3 font-medium text-slate-900">{item.product_code || '-'}</td>
                      <td className="px-4 py-3 text-slate-700">{item.product_name || '-'}</td>
                      <td className="px-4 py-3 text-slate-600">{item.department || '-'}</td>
                      <td className="px-4 py-3 text-slate-600">{item.budget_year || '-'}</td>
                      <td className="px-4 py-3 text-right text-slate-700">{formatNumber(Number(item.requested_quantity || 0))}</td>
                      <td className="px-4 py-3 text-right text-slate-700">{formatNumber(Number(item.received_qty || 0))}</td>
                      <td className="px-4 py-3 text-right font-semibold text-amber-700">{formatNumber(Number(item.remaining_qty || 0))}</td>
                      <td className="px-4 py-3 text-right text-slate-700">{formatCurrency(Number(item.price_per_unit || 0))}</td>
                      <td className="px-4 py-3">
                        <span className="rounded-full bg-amber-100 px-3 py-1 text-xs font-medium text-amber-800">{item.inventory_receipt_status}</span>
                      </td>
                      <td className="px-4 py-3 text-right">
                        <button
                          type="button"
                          onClick={() => handleReceive(item)}
                          disabled={submitting_id === item.id || Number(item.remaining_qty || 0) <= 0}
                          className="rounded-xl bg-emerald-600 px-4 py-2 text-sm font-medium text-white shadow-sm transition hover:bg-emerald-700 disabled:cursor-not-allowed disabled:bg-slate-300"
                        >
                          {submitting_id === item.id ? 'กำลังบันทึก...' : 'รับเข้าทั้งค้าง'}
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
