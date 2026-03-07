import Link from 'next/link';
import { ClipboardCheck, Boxes, ArrowRightLeft, PackageSearch, FileClock } from 'lucide-react';
import { pgQuery } from '@/lib/pg';

export const dynamic = 'force-dynamic';

type CountRow = { count: number };
type SummaryRow = { totalqty: number | null; totalvalue: number | null };

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

const shortcuts = [
  {
    title: 'รับเข้าจากอนุมัติจัดซื้อ',
    href: '/inventory/receipts',
    icon: ClipboardCheck,
    description: 'ตรวจสอบรายการที่อนุมัติแล้วและบันทึกรับสินค้าเข้าคลังจากเอกสารจัดซื้อ',
    tone: 'from-emerald-500 to-teal-600',
  },
  {
    title: 'คงคลังปัจจุบัน',
    href: '/inventory/stock',
    icon: Boxes,
    description: 'ติดตามยอดคงเหลือ พร้อมใช้ จองใช้ และต้นทุนเฉลี่ยของสินค้าแต่ละรายการ',
    tone: 'from-blue-500 to-indigo-600',
  },
  {
    title: 'รายการขอเบิก',
    href: '/inventory/requisitions',
    icon: FileClock,
    description: 'จัดทำคำขอเบิกและติดตามสถานะอนุมัติเพื่อเตรียมการจ่ายสินค้า',
    tone: 'from-violet-500 to-purple-600',
  },
  {
    title: 'รายการจ่าย',
    href: '/inventory/issues',
    icon: ArrowRightLeft,
    description: 'บันทึกและตรวจสอบเอกสารจ่ายสินค้าจากคำขอเบิกที่ได้รับอนุมัติแล้ว',
    tone: 'from-amber-500 to-orange-600',
  },
  {
    title: 'ประวัติการเคลื่อนไหวสินค้า',
    href: '/inventory/movements',
    icon: PackageSearch,
    description: 'ตรวจสอบประวัติการรับเข้า จ่ายออก และยอดคงเหลือหลังรายการในแต่ละเอกสาร',
    tone: 'from-slate-700 to-slate-900',
  },
];

export default async function InventoryPage() {
  const [balanceCountResult, pendingReceiptCountResult, requisitionCountResult, issueCountResult, inventorySummaryResult] = await Promise.all([
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public."InventoryBalance"'),
    pgQuery<CountRow>(`SELECT COUNT(*)::int AS count FROM public."PurchaseApprovalInventoryLink" WHERE "inventoryReceiptStatus" IN ('PENDING', 'PARTIAL')`),
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public."InventoryRequisition"'),
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public."InventoryIssue"'),
    pgQuery<SummaryRow>(`SELECT COALESCE(SUM("onHandQty"), 0)::int AS totalQty, COALESCE(SUM("onHandQty" * "avgCost"), 0)::float8 AS totalValue FROM public."InventoryBalance"`),
  ]);

  const stats = [
    {
      label: 'รายการคงคลัง',
      value: formatNumber(balanceCountResult.rows[0]?.count || 0),
      helper: 'จำนวนสินค้าและ lot ที่มีการเคลื่อนไหวในระบบคลังสินค้า',
    },
    {
      label: 'รอรับเข้าจาก PurchaseApproval',
      value: formatNumber(pendingReceiptCountResult.rows[0]?.count || 0),
      helper: 'รายการที่ยังรับเข้าไม่ครบ',
    },
    {
      label: 'เอกสารขอเบิก',
      value: formatNumber(requisitionCountResult.rows[0]?.count || 0),
      helper: 'จำนวนคำขอเบิกที่บันทึกในระบบคลังสินค้า',
    },
    {
      label: 'เอกสารจ่าย',
      value: formatNumber(issueCountResult.rows[0]?.count || 0),
      helper: 'จำนวนเอกสารจ่ายสินค้าที่บันทึกเรียบร้อยแล้ว',
    },
  ];

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto flex max-w-7xl flex-col gap-8 px-4 py-8 sm:px-6 lg:px-8">
        <section className="rounded-3xl bg-gradient-to-r from-slate-900 via-blue-900 to-cyan-700 px-6 py-8 text-white shadow-xl">
          <div className="flex flex-col gap-6 lg:flex-row lg:items-end lg:justify-between">
            <div className="max-w-3xl">
              <p className="text-sm font-medium uppercase tracking-[0.25em] text-cyan-100">Warehouse Management</p>
              <h1 className="mt-2 text-3xl font-bold sm:text-4xl">ระบบคลังสินค้า</h1>
              <p className="mt-3 text-sm text-slate-100 sm:text-base">
                ศูนย์กลางการบริหารรับเข้า เบิกจ่าย และติดตามความเคลื่อนไหวสินค้าแบบครบถ้วนบนฐานข้อมูลกลาง
              </p>
            </div>
            <div className="rounded-2xl bg-white/10 px-5 py-4 backdrop-blur-sm">
              <p className="text-xs text-cyan-100">มูลค่าสินค้าคงเหลือรวม</p>
              <p className="mt-2 text-2xl font-semibold">{formatCurrency(Number(inventorySummaryResult.rows[0]?.totalvalue || 0))}</p>
              <p className="mt-1 text-sm text-slate-100">จำนวนคงเหลือรวม {formatNumber(Number(inventorySummaryResult.rows[0]?.totalqty || 0))} หน่วย</p>
            </div>
          </div>
        </section>

        <section className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-4">
          {stats.map((stat) => (
            <div key={stat.label} className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
              <p className="text-sm text-slate-500">{stat.label}</p>
              <p className="mt-3 text-3xl font-bold text-slate-900">{stat.value}</p>
              <p className="mt-2 text-sm text-slate-500">{stat.helper}</p>
            </div>
          ))}
        </section>

        <section className="grid grid-cols-1 gap-5 xl:grid-cols-2">
          {shortcuts.map((item) => {
            const Icon = item.icon;
            return (
              <Link key={item.href} href={item.href} className="group rounded-3xl border border-slate-200 bg-white p-6 shadow-sm transition hover:-translate-y-0.5 hover:shadow-lg">
                <div className="flex items-start gap-4">
                  <div className={`rounded-2xl bg-gradient-to-br ${item.tone} p-4 text-white shadow-lg`}>
                    <Icon className="h-6 w-6" />
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center justify-between gap-3">
                      <h2 className="text-xl font-semibold text-slate-900">{item.title}</h2>
                      <PackageSearch className="h-5 w-5 text-slate-400 transition group-hover:text-slate-700" />
                    </div>
                    <p className="mt-2 text-sm leading-6 text-slate-600">{item.description}</p>
                    <div className="mt-4 inline-flex items-center gap-2 text-sm font-medium text-blue-700">
                      เข้าสู่หน้าจัดการ
                      <ArrowRightLeft className="h-4 w-4" />
                    </div>
                  </div>
                </div>
              </Link>
            );
          })}
        </section>
      </div>
    </div>
  );
}
