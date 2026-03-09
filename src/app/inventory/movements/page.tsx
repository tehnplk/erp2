'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';

type MovementRow = {
  id: number;
  inventory_item_id: number;
  product_code: string;
  product_name: string;
  movement_date: string;
  movement_type: string;
  qty_in: number;
  qty_out: number;
  unit_cost: number;
  total_cost: number;
  balance_qty_after: number;
  balance_value_after: number;
  reference_type: string | null;
  reference_no: string | null;
  target_department: string | null;
  source_department: string | null;
};

type ApiResponse<T> = {
  success: boolean;
  data: T;
  error?: string;
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

export default function InventoryMovementsPage() {
  const [items, setItems] = useState<MovementRow[]>([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');

  useEffect(() => {
    const fetchMovements = async () => {
      try {
        setLoading(true);
        const response = await fetch('/api/inventory/movements?page=1&page_size=200');
        const payload: ApiResponse<MovementRow[]> = await response.json();
        if (!response.ok || !payload.success) {
          throw new Error(payload.error || 'โหลด movement ไม่สำเร็จ');
        }
        setItems(payload.data || []);
      } catch (error) {
        console.error(error);
        setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด');
      } finally {
        setLoading(false);
      }
    };

    fetchMovements();
  }, []);

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-6 flex items-center justify-between gap-4">
          <div>
            <p className="text-sm font-medium uppercase tracking-[0.2em] text-slate-500">Inventory Movements</p>
            <h1 className="mt-1 text-3xl font-bold text-slate-900">ประวัติการเคลื่อนไหวสินค้า</h1>
            <p className="mt-2 text-sm text-slate-600">ตรวจสอบประวัติการรับเข้า จ่ายออก และยอดคงเหลือหลังรายการจากทะเบียนเคลื่อนไหวสินค้า</p>
          </div>
          <Link href="/inventory" className="rounded-xl border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-100">
            กลับหน้าหลักระบบคลังสินค้า
          </Link>
        </div>

        {message ? <div className="mb-4 rounded-2xl border border-blue-200 bg-blue-50 px-4 py-3 text-sm text-blue-800">{message}</div> : null}

        <div className="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200 text-sm">
              <thead className="bg-slate-100 text-left text-xs uppercase tracking-wider text-slate-500">
                <tr>
                  <th className="px-4 py-3">วันที่</th>
                  <th className="px-4 py-3">สินค้า</th>
                  <th className="px-4 py-3">ประเภท</th>
                  <th className="px-4 py-3 text-right">เข้า</th>
                  <th className="px-4 py-3 text-right">ออก</th>
                  <th className="px-4 py-3 text-right">ต้นทุน</th>
                  <th className="px-4 py-3 text-right">คงเหลือหลังรายการ</th>
                  <th className="px-4 py-3">อ้างอิง</th>
                  <th className="px-4 py-3">ปลายทาง/ต้นทาง</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 bg-white">
                {loading ? (
                  <tr><td colSpan={9} className="px-4 py-10 text-center text-slate-500">กำลังโหลดข้อมูล...</td></tr>
                ) : items.length === 0 ? (
                  <tr><td colSpan={9} className="px-4 py-10 text-center text-slate-500">ยังไม่มีประวัติการเคลื่อนไหวสินค้า</td></tr>
                ) : items.map((item) => (
                  <tr key={item.id} className="hover:bg-slate-50">
                    <td className="px-4 py-3 text-slate-600">{item.movement_date ? new Date(item.movement_date).toLocaleString('th-TH') : '-'}</td>
                    <td className="px-4 py-3 text-slate-700"><div className="font-medium text-slate-900">{item.product_code}</div><div>{item.product_name}</div></td>
                    <td className="px-4 py-3"><span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-medium text-slate-700">{item.movement_type}</span></td>
                    <td className="px-4 py-3 text-right text-emerald-700">{formatNumber(Number(item.qty_in || 0))}</td>
                    <td className="px-4 py-3 text-right text-rose-700">{formatNumber(Number(item.qty_out || 0))}</td>
                    <td className="px-4 py-3 text-right text-slate-700">{formatCurrency(Number(item.total_cost || 0))}</td>
                    <td className="px-4 py-3 text-right font-semibold text-slate-900">{formatNumber(Number(item.balance_qty_after || 0))}</td>
                    <td className="px-4 py-3 text-slate-600">{item.reference_type || '-'} {item.reference_no || ''}</td>
                    <td className="px-4 py-3 text-slate-600">{item.target_department || item.source_department || '-'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
