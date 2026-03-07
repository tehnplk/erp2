'use client';

import {
  BadgeCheck,
  BarChart4,
  ClipboardList,
  Hospital,
  Stethoscope,
  Warehouse,
} from 'lucide-react';
import {
  Bar,
  BarChart,
  CartesianGrid,
  Cell,
  Legend,
  Line,
  LineChart,
  Pie,
  PieChart,
  ResponsiveContainer,
  Tooltip,
  XAxis,
  YAxis,
} from 'recharts';

type OverviewStat = {
  label: string;
  value: number;
  color: string;
  icon: 'products' | 'surveys' | 'plans' | 'approvals' | 'warehouse' | 'departments';
};

type ValueStat = {
  label: string;
  value: number;
};

type ChartDatum = {
  name: string;
  value: number;
};

type BudgetTrendDatum = {
  year: string;
  surveyValue: number;
  planValue: number;
};

type DepartmentCompareDatum = {
  name: string;
  surveyCount: number;
  planCount: number;
  approvalCount: number;
};

type DepartmentValueDatum = {
  name: string;
  surveyValue: number;
  planValue: number;
  approvalValue: number;
};

type HomeDashboardProps = {
  overview: OverviewStat[];
  valueStats: ValueStat[];
  productsByCategory: ChartDatum[];
  surveysByDepartment: ChartDatum[];
  purchasePlanStatus: ChartDatum[];
  warehouseTransactions: ChartDatum[];
  budgetTrend: BudgetTrendDatum[];
  departmentComparison: DepartmentCompareDatum[];
  departmentValue: DepartmentValueDatum[];
};

const currencyFormatter = new Intl.NumberFormat('th-TH', {
  style: 'currency',
  currency: 'THB',
  maximumFractionDigits: 0,
});

const numberFormatter = new Intl.NumberFormat('th-TH');

const pieColors = ['#2563eb', '#0f766e', '#9333ea', '#ea580c', '#dc2626', '#16a34a', '#0891b2'];

const iconMap = {
  products: Stethoscope,
  surveys: ClipboardList,
  plans: BarChart4,
  approvals: BadgeCheck,
  warehouse: Warehouse,
  departments: Hospital,
};

export default function HomeDashboard({
  overview,
  valueStats,
  productsByCategory,
  surveysByDepartment,
  purchasePlanStatus,
  warehouseTransactions,
  budgetTrend,
  departmentComparison,
  departmentValue,
}: HomeDashboardProps) {
  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-8 rounded-3xl bg-gradient-to-r from-blue-600 via-cyan-600 to-emerald-500 px-6 py-8 text-white shadow-xl">
          <div className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
            <div>
              <p className="mb-2 text-sm font-medium uppercase tracking-[0.2em] text-blue-100">Dashboard</p>
              <h1 className="text-3xl font-bold sm:text-4xl">ภาพรวมสถิติระบบจัดการทรัพยากรโรงพยาบาล</h1>
              <p className="mt-3 max-w-3xl text-sm text-blue-50 sm:text-base">
                ติดตามข้อมูลสินค้า แผนการใช้ แผนจัดซื้อ การอนุมัติ และคลังสินค้าในภาพเดียว
              </p>
            </div>
            <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
              {valueStats.map((stat) => (
                <div key={stat.label} className="rounded-2xl bg-white/15 px-4 py-3 backdrop-blur-sm">
                  <p className="text-xs text-blue-100">{stat.label}</p>
                  <p className="mt-1 text-lg font-semibold">{currencyFormatter.format(stat.value)}</p>
                </div>
              ))}
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 xl:grid-cols-3">
          {overview.map((item) => {
            const Icon = iconMap[item.icon];
            return (
              <div
                key={item.label}
                className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm"
              >
                <div className="flex items-center justify-between">
                  <div>
                    <p className="text-sm text-slate-500">{item.label}</p>
                    <p className="mt-2 text-3xl font-bold text-slate-900">{numberFormatter.format(item.value)}</p>
                  </div>
                  <div className={`rounded-2xl p-3 text-white ${item.color}`}>
                    <Icon className="h-6 w-6" />
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        <section className="mt-8 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4">
            <h2 className="text-lg font-semibold text-slate-900">กราฟแท่งเปรียบเทียบมูลค่ารายแผนก</h2>
            <p className="text-sm text-slate-500">เปรียบเทียบมูลค่าแผนการใช้ แผนจัดซื้อ และอนุมัติจัดซื้อของแต่ละแผนก</p>
          </div>
          <div className="h-[420px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={departmentValue} margin={{ top: 12, right: 12, left: 8, bottom: 60 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} />
                <XAxis dataKey="name" angle={-15} textAnchor="end" height={70} tick={{ fontSize: 12 }} />
                <YAxis tickFormatter={(value) => `${Math.round(Number(value) / 1000)}k`} />
                <Tooltip formatter={(value) => [currencyFormatter.format(Number(value)), 'มูลค่า']} />
                <Legend />
                <Bar dataKey="surveyValue" name="มูลค่าแผนการใช้" fill="#0f766e" radius={[8, 8, 0, 0]} />
                <Bar dataKey="planValue" name="มูลค่าแผนจัดซื้อ" fill="#2563eb" radius={[8, 8, 0, 0]} />
                <Bar dataKey="approvalValue" name="มูลค่าอนุมัติจัดซื้อ" fill="#7c3aed" radius={[8, 8, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </section>

        <section className="mt-8 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4">
            <h2 className="text-lg font-semibold text-slate-900">กราฟแท่งเปรียบเทียบจำนวนรายการรายแผนก</h2>
            <p className="text-sm text-slate-500">เปรียบเทียบจำนวนรายการแผนการใช้ แผนจัดซื้อ และอนุมัติจัดซื้อของแต่ละแผนก</p>
          </div>
          <div className="h-[380px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={departmentComparison} margin={{ top: 12, right: 12, left: 8, bottom: 60 }}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} />
                <XAxis dataKey="name" angle={-15} textAnchor="end" height={70} tick={{ fontSize: 12 }} />
                <YAxis tickFormatter={(value) => numberFormatter.format(Number(value))} />
                <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'รายการ']} />
                <Legend />
                <Bar dataKey="surveyCount" name="แผนการใช้" fill="#0f766e" radius={[8, 8, 0, 0]} />
                <Bar dataKey="planCount" name="แผนจัดซื้อ" fill="#2563eb" radius={[8, 8, 0, 0]} />
                <Bar dataKey="approvalCount" name="อนุมัติจัดซื้อ" fill="#7c3aed" radius={[8, 8, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </section>

        <div className="mt-8 grid grid-cols-1 gap-6 xl:grid-cols-3">
          <section className="xl:col-span-2 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4 flex items-center justify-between">
              <div>
                <h2 className="text-lg font-semibold text-slate-900">มูลค่าความต้องการเทียบแผนจัดซื้อ</h2>
                <p className="text-sm text-slate-500">แนวโน้มมูลค่ารายปีงบของแผนการใช้และแผนจัดซื้อ</p>
              </div>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={budgetTrend} margin={{ top: 12, right: 12, left: 12, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="year" />
                  <YAxis tickFormatter={(value) => `${Math.round(Number(value) / 1000)}k`} />
                  <Tooltip formatter={(value) => currencyFormatter.format(Number(value))} />
                  <Legend />
                  <Line type="monotone" dataKey="surveyValue" name="มูลค่าความต้องการ" stroke="#2563eb" strokeWidth={3} dot={{ r: 4 }} />
                  <Line type="monotone" dataKey="planValue" name="มูลค่าแผนจัดซื้อ" stroke="#16a34a" strokeWidth={3} dot={{ r: 4 }} />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </section>

          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">จำนวนรายการตามโมดูล</h2>
              <p className="text-sm text-slate-500">เปรียบเทียบปริมาณข้อมูลหลักของระบบ</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={overview} margin={{ top: 12, right: 12, left: 0, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="label" tick={{ fontSize: 10 }} angle={-45} textAnchor="end" height={60} />
                  <YAxis tickFormatter={(value) => numberFormatter.format(Number(value))} />
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'จำนวน']} />
                  <Bar dataKey="value" radius={[10, 10, 0, 0]}>
                    {overview.map((entry) => (
                      <Cell key={entry.label} fill={entry.color.includes('bg-') ? '#2563eb' : entry.color} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>
          </section>

          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">สัดส่วนสินค้าแยกตามหมวด</h2>
              <p className="text-sm text-slate-500">Top หมวดสินค้าที่มีรายการมากที่สุด</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={productsByCategory} dataKey="value" nameKey="name" innerRadius={70} outerRadius={110} paddingAngle={3}>
                    {productsByCategory.map((entry, index) => (
                      <Cell key={entry.name} fill={pieColors[index % pieColors.length]} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'สินค้า']} />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </section>



          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">หน่วยงานที่ส่งความต้องการสูงสุด</h2>
              <p className="text-sm text-slate-500">Top หน่วยงานตามจำนวนรายการในแผนการใช้</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={surveysByDepartment} layout="vertical" margin={{ top: 12, right: 12, left: 24, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" horizontal={false} />
                  <XAxis type="number" tickFormatter={(value) => numberFormatter.format(Number(value))} />
                  <YAxis type="category" dataKey="name" width={160} tick={{ fontSize: 12 }} />
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'รายการ']} />
                  <Bar dataKey="value" name="รายการ" fill="#0f766e" radius={[0, 10, 10, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </section>

          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">สถานะแผนจัดซื้อ</h2>
              <p className="text-sm text-slate-500">สัดส่วนในแผนและนอกแผนจากรายการแผนจัดซื้อ</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={purchasePlanStatus} dataKey="value" nameKey="name" innerRadius={65} outerRadius={110}>
                    {purchasePlanStatus.map((entry, index) => (
                      <Cell key={entry.name} fill={pieColors[index % pieColors.length]} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'รายการ']} />
                  <Legend />
                </PieChart>
              </ResponsiveContainer>
            </div>
          </section>

          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">ประเภทการเคลื่อนไหวคลัง</h2>
              <p className="text-sm text-slate-500">จำนวนรายการตามประเภท transaction ในคลังสินค้า</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={warehouseTransactions} margin={{ top: 12, right: 12, left: 0, bottom: 20 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="name" angle={-12} textAnchor="end" height={60} tick={{ fontSize: 12 }} />
                  <YAxis tickFormatter={(value) => numberFormatter.format(Number(value))} />
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'รายการ']} />
                  <Bar dataKey="value" name="รายการ" fill="#7c3aed" radius={[10, 10, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </section>
        </div>

      </div>
    </div>
  );
}
