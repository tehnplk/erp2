'use client';

import { useMemo, useState } from 'react';
import { formatBaht } from '@/lib/format-baht';
import {
  BadgeCheck,
  BarChart4,
  ClipboardList,
  Hospital,
  Stethoscope,
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
  icon: 'products' | 'surveys' | 'plans' | 'approvals' | 'departments';
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

type PurchasePlanDepartmentSpendDatum = {
  name: string;
  total_value: number;
  item_count: number;
  avg_value: number;
};

type HomeDashboardProps = {
  overview: OverviewStat[];
  valueStats: ValueStat[];
  productsByCategory: ChartDatum[];
  surveysByDepartment: ChartDatum[];
  purchasePlanStatus: ChartDatum[];
  budgetTrend: BudgetTrendDatum[];
  departmentComparison: DepartmentCompareDatum[];
  departmentValue: DepartmentValueDatum[];
  purchasePlanDepartmentSpend: PurchasePlanDepartmentSpendDatum[];
};

type LegendItem = {
  key: string;
  label: string;
  color: string;
};

const numberFormatter = new Intl.NumberFormat('th-TH');

const pieColors = ['#2563eb', '#0f766e', '#9333ea', '#ea580c', '#dc2626', '#16a34a', '#0891b2'];

const iconMap = {
  products: Stethoscope,
  surveys: ClipboardList,
  plans: BarChart4,
  approvals: BadgeCheck,
  departments: Hospital,
};

const overviewUnitMap: Record<string, string> = {
  สินค้า: 'รายการ',
  แผนการใช้: 'รายการ',
  แผนจัดซื้อ: 'รายการ',
  อนุมัติจัดซื้อ: 'รายการ',
  แผนก: 'หน่วยงาน',
};

const valueStatUnitMap: Record<string, string> = {};

const departmentValueLegendItems: LegendItem[] = [
  { key: 'surveyValue', label: 'มูลค่าแผนการใช้', color: '#0f766e' },
  { key: 'planValue', label: 'มูลค่าแผนจัดซื้อ', color: '#2563eb' },
  { key: 'approvalValue', label: 'มูลค่าอนุมัติจัดซื้อ', color: '#7c3aed' },
];

const departmentComparisonLegendItems: LegendItem[] = [
  { key: 'surveyCount', label: 'แผนการใช้', color: '#0f766e' },
  { key: 'planCount', label: 'แผนจัดซื้อ', color: '#2563eb' },
  { key: 'approvalCount', label: 'อนุมัติจัดซื้อ', color: '#7c3aed' },
];

const budgetTrendLegendItems: LegendItem[] = [
  { key: 'surveyValue', label: 'มูลค่าความต้องการ', color: '#2563eb' },
  { key: 'planValue', label: 'มูลค่าแผนจัดซื้อ', color: '#16a34a' },
];

const overviewLegendItems: LegendItem[] = [
  { key: 'value', label: 'จำนวนรายการ', color: '#2563eb' },
];

const surveysLegendItems: LegendItem[] = [
  { key: 'value', label: 'รายการ', color: '#0f766e' },
];

const purchasePlanLegendItems: LegendItem[] = [
  { key: 'value', label: 'รายการ', color: '#2563eb' },
];

const productsLegendItems: LegendItem[] = [
  { key: 'value', label: 'สินค้า', color: '#2563eb' },
];

const purchasePlanDepartmentSpendLegendItems: LegendItem[] = [
  { key: 'total_value', label: 'ยอดใช้เงินแผนจัดซื้อ', color: '#2563eb' },
];

function createInitialVisibility(items: LegendItem[]) {
  return Object.fromEntries(items.map((item) => [item.key, true]));
}

function CustomLegend({
  items,
  visibility,
  onToggle,
}: {
  items: LegendItem[];
  visibility: Record<string, boolean>;
  onToggle: (key: string) => void;
}) {
  return (
    <div className="mt-4 flex flex-wrap gap-2">
      {items.map((item) => {
        const active = visibility[item.key];

        return (
          <button
            key={item.key}
            type="button"
            onClick={() => onToggle(item.key)}
            className={`inline-flex items-center gap-2 rounded-full border px-3 py-1 text-sm transition ${
              active
                ? 'border-slate-300 bg-white text-slate-700'
                : 'border-slate-200 bg-slate-100 text-slate-400'
            }`}
          >
            <span
              className="h-2.5 w-2.5 rounded-full"
              style={{
                backgroundColor: item.color,
                opacity: active ? 1 : 0.35,
              }}
            />
            <span>{item.label}</span>
          </button>
        );
      })}
    </div>
  );
}

export default function HomeDashboard({
  overview,
  valueStats,
  productsByCategory,
  surveysByDepartment,
  purchasePlanStatus,
  budgetTrend,
  departmentComparison,
  departmentValue,
  purchasePlanDepartmentSpend,
}: HomeDashboardProps) {
  const [departmentValueVisibility, setDepartmentValueVisibility] = useState(() =>
    createInitialVisibility(departmentValueLegendItems)
  );
  const [departmentComparisonVisibility, setDepartmentComparisonVisibility] = useState(() =>
    createInitialVisibility(departmentComparisonLegendItems)
  );
  const [budgetTrendVisibility, setBudgetTrendVisibility] = useState(() =>
    createInitialVisibility(budgetTrendLegendItems)
  );
  const [overviewVisibility, setOverviewVisibility] = useState(() => createInitialVisibility(overviewLegendItems));
  const [productsVisibility, setProductsVisibility] = useState(() => createInitialVisibility(productsLegendItems));
  const [surveysVisibility, setSurveysVisibility] = useState(() => createInitialVisibility(surveysLegendItems));
  const [purchasePlanVisibility, setPurchasePlanVisibility] = useState(() =>
    createInitialVisibility(purchasePlanLegendItems)
  );
  const [purchasePlanDepartmentSpendVisibility, setPurchasePlanDepartmentSpendVisibility] = useState(() =>
    createInitialVisibility(purchasePlanDepartmentSpendLegendItems)
  );

  const toggleVisibility = (
    key: string,
    setter: React.Dispatch<React.SetStateAction<Record<string, boolean>>>
  ) => {
    setter((current) => ({
      ...current,
      [key]: !current[key],
    }));
  };

  const visibleOverview = useMemo(
    () => (overviewVisibility.value ? overview : []),
    [overview, overviewVisibility]
  );
  const visibleProductsByCategory = useMemo(
    () => (productsVisibility.value ? productsByCategory : []),
    [productsByCategory, productsVisibility]
  );
  const visibleSurveysByDepartment = useMemo(
    () => (surveysVisibility.value ? surveysByDepartment : []),
    [surveysByDepartment, surveysVisibility]
  );
  const visiblePurchasePlanStatus = useMemo(
    () => (purchasePlanVisibility.value ? purchasePlanStatus : []),
    [purchasePlanStatus, purchasePlanVisibility]
  );
  const visiblePurchasePlanDepartmentSpend = useMemo(
    () => (purchasePlanDepartmentSpendVisibility.total_value ? purchasePlanDepartmentSpend : []),
    [purchasePlanDepartmentSpend, purchasePlanDepartmentSpendVisibility]
  );

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-6 flex flex-col gap-2 text-slate-900">
          <p className="text-sm font-medium uppercase tracking-[0.2em] text-slate-400">Dashboard</p>
        </div>

        <div className="mb-10 grid gap-4 sm:grid-cols-3">
          {valueStats.map((stat) => (
            <div
              key={stat.label}
              className="rounded-2xl border border-slate-200 bg-white px-5 py-4 shadow-sm"
            >
              <p className="text-xs font-semibold uppercase tracking-widest text-slate-500">{stat.label}</p>
              <p className="mt-3 text-2xl font-bold text-slate-900">
                {formatBaht(stat.value)}
                {valueStatUnitMap[stat.label] && (
                  <span className="ml-2 align-middle text-base font-medium text-slate-500">
                    {valueStatUnitMap[stat.label]}
                  </span>
                )}
              </p>
            </div>
          ))}
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
                    <p className="mt-2 text-3xl font-bold text-slate-900">
                      {numberFormatter.format(item.value)}
                      {overviewUnitMap[item.label] && (
                        <span className="ml-2 align-middle text-base font-medium text-slate-500">
                          {overviewUnitMap[item.label]}
                        </span>
                      )}
                    </p>
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
          <div className="mb-4 flex flex-col gap-1">
            <h2 className="text-lg font-semibold text-slate-900">เปรียบเทียบยอดใช้เงินจากแผนจัดซื้อรายหน่วยงาน</h2>
            <p className="text-sm text-slate-500">สรุปยอดใช้เงินจาก `purchase_plan` แยกรายหน่วยงาน พร้อมจำนวนรายการและค่าเฉลี่ยต่อรายการ</p>
          </div>
          <div className="grid grid-cols-1 gap-6 xl:grid-cols-[minmax(0,2fr)_minmax(320px,1fr)]">
            <div className="h-[420px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart
                  data={visiblePurchasePlanDepartmentSpend}
                  layout="vertical"
                  margin={{ top: 12, right: 16, left: 80, bottom: 0 }}
                >
                  <CartesianGrid strokeDasharray="3 3" horizontal={false} />
                  <XAxis type="number" tickFormatter={(value) => `${Math.round(Number(value) / 1000)}k`} />
                  <YAxis type="category" dataKey="name" width={180} tick={{ fontSize: 12 }} />
                  <Tooltip formatter={(value) => [formatBaht(Number(value)), 'ยอดใช้เงิน']} />
                  <Legend content={() => null} />
                  {purchasePlanDepartmentSpendVisibility.total_value && (
                    <Bar dataKey="total_value" name="ยอดใช้เงินแผนจัดซื้อ" fill="#2563eb" radius={[0, 10, 10, 0]} />
                  )}
                </BarChart>
              </ResponsiveContainer>
            </div>
            <div className="overflow-hidden rounded-2xl border border-slate-200">
              <div className="grid grid-cols-[minmax(0,1.5fr)_110px_130px] gap-3 border-b border-slate-200 bg-slate-50 px-4 py-3 text-xs font-semibold uppercase tracking-wide text-slate-500">
                <span>หน่วยงาน</span>
                <span className="text-right">รายการ</span>
                <span className="text-right">ยอดใช้เงิน</span>
              </div>
              <div className="max-h-[420px] overflow-y-auto">
                {purchasePlanDepartmentSpend.map((row) => (
                  <div
                    key={row.name}
                    className="grid grid-cols-[minmax(0,1.5fr)_110px_130px] gap-3 border-b border-slate-100 px-4 py-3 text-sm text-slate-700 last:border-b-0"
                  >
                    <div className="min-w-0">
                      <p className="truncate font-medium text-slate-900">{row.name}</p>
                      <p className="mt-1 text-xs text-slate-500">
                        เฉลี่ย {formatBaht(row.avg_value)} / รายการ
                      </p>
                    </div>
                    <div className="text-right font-medium text-slate-600">
                      {numberFormatter.format(row.item_count)}
                    </div>
                    <div className="text-right font-semibold text-slate-900">
                      {formatBaht(row.total_value)}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
          <CustomLegend
            items={purchasePlanDepartmentSpendLegendItems}
            visibility={purchasePlanDepartmentSpendVisibility}
            onToggle={(key) => toggleVisibility(key, setPurchasePlanDepartmentSpendVisibility)}
          />
        </section>

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
                <Tooltip formatter={(value) => [formatBaht(Number(value)), 'มูลค่า']} />
                <Legend content={() => null} />
                {departmentValueVisibility.surveyValue && (
                  <Bar dataKey="surveyValue" name="มูลค่าแผนการใช้" fill="#0f766e" radius={[8, 8, 0, 0]} />
                )}
                {departmentValueVisibility.planValue && (
                  <Bar dataKey="planValue" name="มูลค่าแผนจัดซื้อ" fill="#2563eb" radius={[8, 8, 0, 0]} />
                )}
                {departmentValueVisibility.approvalValue && (
                  <Bar dataKey="approvalValue" name="มูลค่าอนุมัติจัดซื้อ" fill="#7c3aed" radius={[8, 8, 0, 0]} />
                )}
              </BarChart>
            </ResponsiveContainer>
          </div>
          <CustomLegend
            items={departmentValueLegendItems}
            visibility={departmentValueVisibility}
            onToggle={(key) => toggleVisibility(key, setDepartmentValueVisibility)}
          />
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
                <Legend content={() => null} />
                {departmentComparisonVisibility.surveyCount && (
                  <Bar dataKey="surveyCount" name="แผนการใช้" fill="#0f766e" radius={[8, 8, 0, 0]} />
                )}
                {departmentComparisonVisibility.planCount && (
                  <Bar dataKey="planCount" name="แผนจัดซื้อ" fill="#2563eb" radius={[8, 8, 0, 0]} />
                )}
                {departmentComparisonVisibility.approvalCount && (
                  <Bar dataKey="approvalCount" name="อนุมัติจัดซื้อ" fill="#7c3aed" radius={[8, 8, 0, 0]} />
                )}
              </BarChart>
            </ResponsiveContainer>
          </div>
          <CustomLegend
            items={departmentComparisonLegendItems}
            visibility={departmentComparisonVisibility}
            onToggle={(key) => toggleVisibility(key, setDepartmentComparisonVisibility)}
          />
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
                  <Tooltip formatter={(value) => formatBaht(Number(value))} />
                  <Legend content={() => null} />
                  {budgetTrendVisibility.surveyValue && (
                    <Line type="monotone" dataKey="surveyValue" name="มูลค่าความต้องการ" stroke="#2563eb" strokeWidth={3} dot={{ r: 4 }} />
                  )}
                  {budgetTrendVisibility.planValue && (
                    <Line type="monotone" dataKey="planValue" name="มูลค่าแผนจัดซื้อ" stroke="#16a34a" strokeWidth={3} dot={{ r: 4 }} />
                  )}
                </LineChart>
              </ResponsiveContainer>
            </div>
            <CustomLegend
              items={budgetTrendLegendItems}
              visibility={budgetTrendVisibility}
              onToggle={(key) => toggleVisibility(key, setBudgetTrendVisibility)}
            />
          </section>

          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">จำนวนรายการตามโมดูล</h2>
              <p className="text-sm text-slate-500">เปรียบเทียบปริมาณข้อมูลหลักของระบบ</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={visibleOverview} margin={{ top: 12, right: 12, left: 0, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" vertical={false} />
                  <XAxis dataKey="label" tick={{ fontSize: 10 }} angle={-45} textAnchor="end" height={60} />
                  <YAxis tickFormatter={(value) => numberFormatter.format(Number(value))} />
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'จำนวน']} />
                  <Legend content={() => null} />
                  {overviewVisibility.value && (
                    <Bar dataKey="value" radius={[10, 10, 0, 0]}>
                    {overview.map((entry) => (
                      <Cell key={entry.label} fill={entry.color.includes('bg-') ? '#2563eb' : entry.color} />
                    ))}
                    </Bar>
                  )}
                </BarChart>
              </ResponsiveContainer>
            </div>
            <CustomLegend
              items={overviewLegendItems}
              visibility={overviewVisibility}
              onToggle={(key) => toggleVisibility(key, setOverviewVisibility)}
            />
          </section>

          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">สัดส่วนสินค้าแยกตามหมวด</h2>
              <p className="text-sm text-slate-500">Top หมวดสินค้าที่มีรายการมากที่สุด</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={visibleProductsByCategory} dataKey="value" nameKey="name" innerRadius={70} outerRadius={110} paddingAngle={3}>
                    {visibleProductsByCategory.map((entry, index) => (
                      <Cell key={entry.name} fill={pieColors[index % pieColors.length]} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'สินค้า']} />
                  <Legend content={() => null} />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <CustomLegend
              items={productsLegendItems}
              visibility={productsVisibility}
              onToggle={(key) => toggleVisibility(key, setProductsVisibility)}
            />
          </section>

          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">หน่วยงานที่ส่งความต้องการสูงสุด</h2>
              <p className="text-sm text-slate-500">Top หน่วยงานตามจำนวนรายการในแผนการใช้</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={visibleSurveysByDepartment} layout="vertical" margin={{ top: 12, right: 12, left: 24, bottom: 0 }}>
                  <CartesianGrid strokeDasharray="3 3" horizontal={false} />
                  <XAxis type="number" tickFormatter={(value) => numberFormatter.format(Number(value))} />
                  <YAxis type="category" dataKey="name" width={160} tick={{ fontSize: 12 }} />
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'รายการ']} />
                  <Legend content={() => null} />
                  {surveysVisibility.value && (
                    <Bar dataKey="value" name="รายการ" fill="#0f766e" radius={[0, 10, 10, 0]} />
                  )}
                </BarChart>
              </ResponsiveContainer>
            </div>
            <CustomLegend
              items={surveysLegendItems}
              visibility={surveysVisibility}
              onToggle={(key) => toggleVisibility(key, setSurveysVisibility)}
            />
          </section>

          <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="mb-4">
              <h2 className="text-lg font-semibold text-slate-900">สถานะแผนจัดซื้อ</h2>
              <p className="text-sm text-slate-500">สัดส่วนในแผนและนอกแผนจากรายการแผนจัดซื้อ</p>
            </div>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie data={visiblePurchasePlanStatus} dataKey="value" nameKey="name" innerRadius={65} outerRadius={110}>
                    {visiblePurchasePlanStatus.map((entry, index) => (
                      <Cell key={entry.name} fill={pieColors[index % pieColors.length]} />
                    ))}
                  </Pie>
                  <Tooltip formatter={(value) => [numberFormatter.format(Number(value)), 'รายการ']} />
                  <Legend content={() => null} />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <CustomLegend
              items={purchasePlanLegendItems}
              visibility={purchasePlanVisibility}
              onToggle={(key) => toggleVisibility(key, setPurchasePlanVisibility)}
            />
          </section>
        </div>

      </div>
    </div>
  );
}


