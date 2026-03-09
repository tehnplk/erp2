import Link from 'next/link';
import { pgQuery } from '@/lib/pg';

export const dynamic = 'force-dynamic';

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

export default async function InventoryStockPage() {
  const result = await pgQuery<BalanceRow>(`
    SELECT
      ib.id,
      ib.inventory_item_id,
      ii.product_code,
      ii.product_name,
      ii.category,
      ii.product_type,
      ii.unit,
      iw.warehouse_name,
      ii.lot_no,
      ib.on_hand_qty,
      ib.reserved_qty,
      ib.available_qty,
      ib.avg_cost::float8 AS avg_cost
    FROM public.inventory_balance ib
    INNER JOIN public.inventory_item ii ON ii.id = ib.inventory_item_id
    INNER JOIN public.inventory_warehouse iw ON iw.id = ii.warehouse_id
    ORDER BY ib.available_qty DESC, ii.product_name ASC
    LIMIT 100
  `);

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
                {result.rows.map((row) => (
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
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
