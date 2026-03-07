import Link from 'next/link';
import { pgQuery } from '@/lib/pg';

export const dynamic = 'force-dynamic';

type BalanceRow = {
  id: number;
  inventoryItemId: number;
  productCode: string;
  productName: string;
  category: string | null;
  productType: string | null;
  unit: string | null;
  warehouseName: string;
  lotNo: string | null;
  onHandQty: number;
  reservedQty: number;
  availableQty: number;
  avgCost: number;
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
      ib."inventoryItemId",
      ii."productCode",
      ii."productName",
      ii.category,
      ii."productType",
      ii.unit,
      iw."warehouseName",
      ii."lotNo",
      ib."onHandQty",
      ib."reservedQty",
      ib."availableQty",
      ib."avgCost"::float8 AS "avgCost"
    FROM public."InventoryBalance" ib
    INNER JOIN public."InventoryItem" ii ON ii.id = ib."inventoryItemId"
    INNER JOIN public."InventoryWarehouse" iw ON iw.id = ii."warehouseId"
    ORDER BY ib."availableQty" DESC, ii."productName" ASC
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
                    <td className="px-4 py-3 font-medium text-slate-900">{row.productCode}</td>
                    <td className="px-4 py-3 text-slate-700">{row.productName}</td>
                    <td className="px-4 py-3 text-slate-600">{row.category || '-'}</td>
                    <td className="px-4 py-3 text-slate-600">{row.productType || '-'}</td>
                    <td className="px-4 py-3 text-slate-600">{row.warehouseName}</td>
                    <td className="px-4 py-3 text-slate-600">{row.lotNo || '-'}</td>
                    <td className="px-4 py-3 text-right text-slate-700">{formatNumber(Number(row.onHandQty || 0))}</td>
                    <td className="px-4 py-3 text-right text-amber-700">{formatNumber(Number(row.reservedQty || 0))}</td>
                    <td className="px-4 py-3 text-right font-semibold text-emerald-700">{formatNumber(Number(row.availableQty || 0))}</td>
                    <td className="px-4 py-3 text-right text-slate-700">{formatCurrency(Number(row.avgCost || 0))}</td>
                    <td className="px-4 py-3 text-right font-semibold text-slate-900">{formatCurrency(Number(row.availableQty || 0) * Number(row.avgCost || 0))}</td>
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
