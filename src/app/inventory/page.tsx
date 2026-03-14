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
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public.inventory_balance'),
    pgQuery<CountRow>(`
      SELECT COUNT(*)::int AS count
      FROM public.purchase_approval_inventory_link link
      INNER JOIN public.purchase_approval_detail pad ON pad.id = link.purchase_approval_detail_id
      INNER JOIN public.purchase_approval pa ON pa.id = pad.purchase_approval_id
      WHERE pa.status = 'APPROVED'
        AND link.inventory_receipt_status IN ('PENDING', 'PARTIAL')
    `),
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public.inventory_requisition'),
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public.inventory_issue'),
    pgQuery<SummaryRow>(`SELECT COALESCE(SUM(on_hand_qty), 0)::int AS totalqty, COALESCE(SUM(on_hand_qty * avg_cost), 0)::float8 AS totalvalue FROM public.inventory_balance`),
  ]);

  const stats = [
    {
      label: 'รายการที่อนุมัติจัดซื้อ-รอเข้าคลัง',
      value: formatNumber(pendingReceiptCountResult.rows[0]?.count || 0),
      icon: ClipboardCheck,
      borderClass: 'border-emerald-200',
      shadowClass: 'shadow-[0_20px_35px_-28px_rgba(16,185,129,0.9)]',
      iconBorderClass: 'border-emerald-100',
      iconBgClass: 'bg-emerald-50',
      iconColorClass: 'text-emerald-600',
      valueClass: 'text-emerald-700',
    },
    {
      label: 'รายการคงคลัง',
      value: formatNumber(balanceCountResult.rows[0]?.count || 0),
      icon: Boxes,
      borderClass: 'border-sky-200',
      shadowClass: 'shadow-[0_20px_35px_-28px_rgba(14,165,233,0.9)]',
      iconBorderClass: 'border-sky-100',
      iconBgClass: 'bg-sky-50',
      iconColorClass: 'text-sky-600',
      valueClass: 'text-sky-700',
    },
    {
      label: 'เอกสารขอเบิก',
      value: formatNumber(requisitionCountResult.rows[0]?.count || 0),
      icon: FileClock,
      borderClass: 'border-violet-200',
      shadowClass: 'shadow-[0_20px_35px_-28px_rgba(139,92,246,0.9)]',
      iconBorderClass: 'border-violet-100',
      iconBgClass: 'bg-violet-50',
      iconColorClass: 'text-violet-600',
      valueClass: 'text-violet-700',
    },
    {
      label: 'เอกสารจ่าย',
      value: formatNumber(issueCountResult.rows[0]?.count || 0),
      icon: ArrowRightLeft,
      borderClass: 'border-amber-200',
      shadowClass: 'shadow-[0_20px_35px_-28px_rgba(245,158,11,0.85)]',
      iconBorderClass: 'border-amber-100',
      iconBgClass: 'bg-amber-50',
      iconColorClass: 'text-amber-600',
      valueClass: 'text-amber-700',
    },
  ];

  return (
    <div className="min-h-screen bg-white">
      <div className="mx-auto flex max-w-6xl flex-col gap-8 px-4 py-8 sm:px-6 lg:px-8">
        <section className="border-b border-slate-200 pb-6">
          <div className="flex flex-col gap-6 lg:flex-row lg:items-end lg:justify-between">
            <div className="max-w-3xl">
              <p className="text-xs font-medium uppercase tracking-[0.2em] text-slate-500">Inventory Management</p>
              <h1 className="mt-2 text-3xl font-semibold text-slate-900 sm:text-4xl">ระบบคลังสินค้า</h1>
            </div>
            <div className="rounded-2xl border border-slate-200 bg-slate-50 px-5 py-4">
              <p className="text-xs text-slate-500">มูลค่าสินค้าคงเหลือรวม</p>
              <p className="mt-2 text-2xl font-semibold text-slate-900">{formatCurrency(Number(inventorySummaryResult.rows[0]?.totalvalue || 0))}</p>
              <p className="mt-1 text-sm text-slate-600">จำนวนคงเหลือรวม {formatNumber(Number(inventorySummaryResult.rows[0]?.totalqty || 0))} หน่วย</p>
            </div>
          </div>
        </section>

        <section className="grid grid-cols-1 gap-3 sm:grid-cols-2 xl:grid-cols-4">
          {stats.map((stat) => (
            <div
              key={stat.label}
              className={`rounded-2xl border bg-white p-5 shadow-[0_0_0_1px_rgba(148,163,184,0.08),0_10px_24px_-18px_rgba(15,23,42,0.45)] ${stat.borderClass} ${stat.shadowClass}`}
            >
              <div className="flex items-start justify-between gap-4">
                <div>
                  <p className="text-sm text-slate-500">{stat.label}</p>
                  <p className={`mt-2 text-2xl font-semibold ${stat.valueClass}`}>{stat.value}</p>
                </div>
                <div className={`rounded-xl border p-3 ${stat.iconBorderClass} ${stat.iconBgClass}`}>
                  <stat.icon className={`h-5 w-5 ${stat.iconColorClass}`} />
                </div>
              </div>
            </div>
          ))}
        </section>

        <section className="grid grid-cols-1 gap-4 xl:grid-cols-2">
          {shortcuts.map((item) => {
            const Icon = item.icon;
            return (
              <Link key={item.href} href={item.href} className="group rounded-2xl border border-slate-300 bg-white p-5 shadow-[0_0_0_1px_rgba(148,163,184,0.08),0_12px_28px_-20px_rgba(15,23,42,0.5)] transition hover:border-slate-400 hover:shadow-[0_0_0_1px_rgba(100,116,139,0.12),0_16px_32px_-22px_rgba(15,23,42,0.55)] hover:bg-slate-50">
                <div className="flex items-start gap-4">
                  <div className="rounded-xl border border-slate-300 bg-slate-50 p-3 text-slate-700 shadow-sm">
                    <Icon className="h-5 w-5" />
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center justify-between gap-3">
                      <h2 className="text-lg font-semibold text-slate-900">{item.title}</h2>
                      <PackageSearch className="h-5 w-5 text-slate-300 transition group-hover:text-slate-600" />
                    </div>
                    <div className="mt-4 inline-flex items-center gap-2 text-sm font-medium text-slate-700">
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
