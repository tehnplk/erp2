'use client';

import Link from 'next/link';
import { useState, useEffect, useCallback } from 'react';

type BalanceRow = {
  id: number;
  inventory_item_id: number;
  product_code: string;
  product_name: string;
  category: string | null;
  product_type: string | null;
  unit: string | null;
  warehouse_name: string;
  lot_no: string | null;
  on_hand_qty: number;
  reserved_qty: number;
  available_qty: number;
  avg_cost: number;
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

export default function InventoryStockPage() {
  const [rows, setRows] = useState<BalanceRow[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [page, setPage] = useState(1);
  const [pageSize] = useState(20);
  const [filterProductName, setFilterProductName] = useState('');
  const [filterInput, setFilterInput] = useState('');

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      params.set('page', page.toString());
      params.set('page_size', pageSize.toString());
      if (filterProductName) params.set('product_name', filterProductName);
      params.set('order_by', 'available_qty');
      params.set('sort_order', 'desc');

      const res = await fetch(`/api/inventory/balances?${params.toString()}`);
      const data = await res.json();
      if (data.success) {
        setRows(data.data || []);
        setTotalCount(data.totalCount || 0);
      }
    } catch (err) {
      console.error('Error fetching inventory balances:', err);
    } finally {
      setLoading(false);
    }
  }, [page, pageSize, filterProductName]);

  useEffect(() => {
    fetchData();
  }, [fetchData]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    setPage(1);
    setFilterProductName(filterInput);
  };

  const handleClear = () => {
    setFilterInput('');
    setFilterProductName('');
    setPage(1);
  };

  const totalPages = Math.ceil(totalCount / pageSize);

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-6 flex items-center justify-between gap-4">
          <div>
            <p className="text-sm font-medium uppercase tracking-[0.2em] text-slate-500">Inventory Stock</p>
            <h1 className="mt-1 text-3xl font-bold text-slate-900">ยอดคงคลังปัจจุบัน</h1>
            <p className="mt-2 text-sm text-slate-600">แสดงยอดคงเหลือ จองใช้ พร้อมใช้ และมูลค่าสินค้าคงคลังล่าสุดของแต่ละรายการ</p>
          </div>
          <Link href="/inventory" className="rounded-xl border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-100">
            กลับหน้าหลักระบบคลังสินค้า
          </Link>
        </div>

        {/* Filter */}
        <form onSubmit={handleSearch} className="mb-4 flex gap-2">
          <input
            type="text"
            value={filterInput}
            onChange={(e) => setFilterInput(e.target.value)}
            placeholder="ค้นหาชื่อสินค้า"
            className="w-72 rounded-xl border border-slate-300 px-4 py-2 text-sm shadow-sm focus:border-blue-500 focus:outline-none"
          />
          <button type="submit" className="rounded-xl bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700">
            ค้นหา
          </button>
          {filterProductName && (
            <button type="button" onClick={handleClear} className="rounded-xl border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100">
              ล้าง
            </button>
          )}
        </form>

        <div className="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200 text-sm">
              <thead className="bg-slate-100 text-left text-xs uppercase tracking-wider text-slate-500">
                <tr>
                  <th className="px-4 py-3">รหัสสินค้า</th>
                  <th className="px-4 py-3">ชื่อสินค้า</th>
                  <th className="px-4 py-3">หมวด</th>
                  <th className="px-4 py-3">ประเภท</th>
                  <th className="px-4 py-3">คลัง</th>
                  <th className="px-4 py-3">Lot</th>
                  <th className="px-4 py-3 text-right">คงเหลือ</th>
                  <th className="px-4 py-3 text-right">จองใช้</th>
                  <th className="px-4 py-3 text-right">พร้อมใช้</th>
                  <th className="px-4 py-3 text-right">ต้นทุนเฉลี่ย</th>
                  <th className="px-4 py-3 text-right">มูลค่าคงเหลือ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 bg-white">
                {loading ? (
                  <tr><td colSpan={11} className="px-4 py-8 text-center text-slate-500">กำลังโหลด...</td></tr>
                ) : rows.length === 0 ? (
                  <tr><td colSpan={11} className="px-4 py-8 text-center text-slate-500">ไม่พบข้อมูล</td></tr>
                ) : (
                  rows.map((row) => (
                    <tr key={row.id} className="hover:bg-slate-50">
                      <td className="px-4 py-3 font-medium text-slate-900">{row.product_code}</td>
                      <td className="px-4 py-3 text-slate-700">{row.product_name}</td>
                      <td className="px-4 py-3 text-slate-600">{row.category || '-'}</td>
                      <td className="px-4 py-3 text-slate-600">{row.product_type || '-'}</td>
                      <td className="px-4 py-3 text-slate-600">{row.warehouse_name}</td>
                      <td className="px-4 py-3 text-slate-600">{row.lot_no || '-'}</td>
                      <td className="px-4 py-3 text-right text-slate-700">{formatNumber(Number(row.on_hand_qty || 0))}</td>
                      <td className="px-4 py-3 text-right text-amber-700">{formatNumber(Number(row.reserved_qty || 0))}</td>
                      <td className="px-4 py-3 text-right font-semibold text-emerald-700">{formatNumber(Number(row.available_qty || 0))}</td>
                      <td className="px-4 py-3 text-right text-slate-700">{formatCurrency(Number(row.avg_cost || 0))}</td>
                      <td className="px-4 py-3 text-right font-semibold text-slate-900">{formatCurrency(Number(row.available_qty || 0) * Number(row.avg_cost || 0))}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Pagination */}
        <div className="mt-4 flex items-center justify-between text-sm text-slate-600">
          <span>
            แสดง {rows.length > 0 ? (page - 1) * pageSize + 1 : 0}–{Math.min(page * pageSize, totalCount)} จาก {totalCount} รายการ
          </span>
          <div className="flex gap-2">
            <button
              onClick={() => setPage((p) => Math.max(1, p - 1))}
              disabled={page <= 1}
              className="rounded-lg border border-slate-300 bg-white px-3 py-1 disabled:opacity-40 hover:bg-slate-50"
            >
              ก่อนหน้า
            </button>
            <span className="px-2 py-1">หน้า {page} / {totalPages || 1}</span>
            <button
              onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
              disabled={page >= totalPages}
              className="rounded-lg border border-slate-300 bg-white px-3 py-1 disabled:opacity-40 hover:bg-slate-50"
            >
              ถัดไป
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
