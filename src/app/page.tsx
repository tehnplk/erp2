import { pgQuery } from '@/lib/pg';
import HomeDashboard from './components/HomeDashboard';

export const dynamic = 'force-dynamic';

type CountRow = { count: number };
type SumRow = { total: number | null };
type ChartRow = { name: string | null; value: number };
type BudgetTrendRow = { year: string; surveyValue: number; planValue: number };
type DepartmentComparisonRow = { name: string | null; surveyCount: number; planCount: number; approvalCount: number };
type DepartmentValueRow = { name: string | null; surveyValue: number; planValue: number; approvalValue: number };

const normalizeChartRows = (rows: ChartRow[]) => rows.map((row) => ({
  name: row.name || 'ไม่ระบุ',
  value: Number(row.value) || 0,
}));

 export default async function Home() {
  const [
    productCountResult,
    surveyCountResult,
    purchasePlanCountResult,
    approvalCountResult,
    departmentCountResult,
    surveyValueResult,
    planValueResult,
    approvalValueResult,
    productsByCategoryResult,
    surveysByDepartmentResult,
    purchasePlanStatusResult,
    budgetTrendResult,
    departmentComparisonResult,
    departmentValueResult,
  ] = await Promise.all([
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public.product'),
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public.usage_plan'),
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public.purchase_plan'),
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public.purchase_approval'),
    pgQuery<CountRow>('SELECT COUNT(*)::int AS count FROM public.department'),
    pgQuery<SumRow>('SELECT COALESCE(SUM(COALESCE(requested_amount, 0) * COALESCE(price_per_unit, 0)), 0)::float8 AS total FROM public.usage_plan'),
    pgQuery<SumRow>('SELECT COALESCE(SUM(COALESCE(total_required_value, 0)), 0)::float8 AS total FROM public.purchase_plan'),
    pgQuery<SumRow>('SELECT COALESCE(SUM(COALESCE(total_value, 0)), 0)::float8 AS total FROM public.purchase_approval'),
    pgQuery<ChartRow>(
      'SELECT category AS name, COUNT(*)::int AS value FROM public.product GROUP BY category ORDER BY value DESC, name ASC LIMIT 6'
    ),
    pgQuery<ChartRow>(
      'SELECT requesting_dept AS name, COUNT(*)::int AS value FROM public.usage_plan GROUP BY requesting_dept ORDER BY value DESC, name ASC LIMIT 6'
    ),
    pgQuery<ChartRow>(
      `SELECT COALESCE(in_plan, 'ไม่ระบุ') AS name, COUNT(*)::int AS value
       FROM public.purchase_plan
       GROUP BY COALESCE(in_plan, 'ไม่ระบุ')
       ORDER BY value DESC, name ASC`
    ),
    pgQuery<BudgetTrendRow>(
      `WITH survey_stats AS (
         SELECT budget_year::text AS year,
                COALESCE(SUM(COALESCE(requested_amount, 0) * COALESCE(price_per_unit, 0)), 0)::float8 AS "surveyValue"
         FROM public.usage_plan
         GROUP BY budget_year
       ),
       plan_stats AS (
         SELECT budget_year::text AS year,
                COALESCE(SUM(COALESCE(total_required_value, 0)), 0)::float8 AS "planValue"
         FROM public.purchase_plan
         GROUP BY budget_year
       )
       SELECT COALESCE(survey_stats.year, plan_stats.year) AS year,
              COALESCE(survey_stats."surveyValue", 0)::float8 AS "surveyValue",
              COALESCE(plan_stats."planValue", 0)::float8 AS "planValue"
       FROM survey_stats
       FULL OUTER JOIN plan_stats ON survey_stats.year = plan_stats.year
       ORDER BY COALESCE(survey_stats.year, plan_stats.year) ASC`
    ),
    pgQuery<DepartmentComparisonRow>(
      `WITH survey_counts AS (
         SELECT COALESCE(requesting_dept, 'ไม่ระบุ') AS name, COUNT(*)::int AS "surveyCount"
         FROM public.usage_plan
         GROUP BY COALESCE(requesting_dept, 'ไม่ระบุ')
       ),
       plan_counts AS (
         SELECT COALESCE(purchasing_department, 'ไม่ระบุ') AS name, COUNT(*)::int AS "planCount"
         FROM public.purchase_plan
         GROUP BY COALESCE(purchasing_department, 'ไม่ระบุ')
       ),
       approval_counts AS (
         SELECT COALESCE(department, 'ไม่ระบุ') AS name, COUNT(*)::int AS "approvalCount"
         FROM public.purchase_approval
         GROUP BY COALESCE(department, 'ไม่ระบุ')
       )
       SELECT COALESCE(survey_counts.name, plan_counts.name, approval_counts.name) AS name,
              COALESCE(survey_counts."surveyCount", 0)::int AS "surveyCount",
              COALESCE(plan_counts."planCount", 0)::int AS "planCount",
              COALESCE(approval_counts."approvalCount", 0)::int AS "approvalCount"
       FROM survey_counts
       FULL OUTER JOIN plan_counts ON survey_counts.name = plan_counts.name
       FULL OUTER JOIN approval_counts ON COALESCE(survey_counts.name, plan_counts.name) = approval_counts.name
       ORDER BY (COALESCE(survey_counts."surveyCount", 0) + COALESCE(plan_counts."planCount", 0) + COALESCE(approval_counts."approvalCount", 0)) DESC,
                COALESCE(survey_counts.name, plan_counts.name, approval_counts.name) ASC
       LIMIT 8`
    ),
    pgQuery<DepartmentValueRow>(
      `WITH survey_values AS (
         SELECT COALESCE(requesting_dept, 'ไม่ระบุ') AS name,
                COALESCE(SUM(COALESCE(requested_amount, 0) * COALESCE(price_per_unit, 0)), 0)::float8 AS "surveyValue"
         FROM public.usage_plan
         GROUP BY COALESCE(requesting_dept, 'ไม่ระบุ')
       ),
       plan_values AS (
         SELECT COALESCE(purchasing_department, 'ไม่ระบุ') AS name,
                COALESCE(SUM(COALESCE(total_required_value, 0)), 0)::float8 AS "planValue"
         FROM public.purchase_plan
         GROUP BY COALESCE(purchasing_department, 'ไม่ระบุ')
       ),
       approval_values AS (
         SELECT COALESCE(department, 'ไม่ระบุ') AS name,
                COALESCE(SUM(COALESCE(total_value, 0)), 0)::float8 AS "approvalValue"
         FROM public.purchase_approval
         GROUP BY COALESCE(department, 'ไม่ระบุ')
       )
       SELECT COALESCE(survey_values.name, plan_values.name, approval_values.name) AS name,
              COALESCE(survey_values."surveyValue", 0)::float8 AS "surveyValue",
              COALESCE(plan_values."planValue", 0)::float8 AS "planValue",
              COALESCE(approval_values."approvalValue", 0)::float8 AS "approvalValue"
       FROM survey_values
       FULL OUTER JOIN plan_values ON survey_values.name = plan_values.name
       FULL OUTER JOIN approval_values ON COALESCE(survey_values.name, plan_values.name) = approval_values.name
       ORDER BY (COALESCE(survey_values."surveyValue", 0) + COALESCE(plan_values."planValue", 0) + COALESCE(approval_values."approvalValue", 0)) DESC,
                COALESCE(survey_values.name, plan_values.name, approval_values.name) ASC
       LIMIT 8`
    ),
  ]);

  const overview = [
    { label: 'สินค้า', value: productCountResult.rows[0]?.count || 0, color: 'bg-purple-500', icon: 'products' as const },
    { label: 'แผนการใช้', value: surveyCountResult.rows[0]?.count || 0, color: 'bg-teal-500', icon: 'surveys' as const },
    { label: 'แผนจัดซื้อ', value: purchasePlanCountResult.rows[0]?.count || 0, color: 'bg-indigo-500', icon: 'plans' as const },
    { label: 'อนุมัติจัดซื้อ', value: approvalCountResult.rows[0]?.count || 0, color: 'bg-emerald-500', icon: 'approvals' as const },
    { label: 'แผนก', value: departmentCountResult.rows[0]?.count || 0, color: 'bg-green-500', icon: 'departments' as const },
  ];

  const visibleOverview = overview.filter((item) => item.label !== 'สินค้า');

  const valueStats = [
    { label: 'มูลค่าแผนการใช้', value: Number(surveyValueResult.rows[0]?.total) || 0 },
    { label: 'มูลค่าแผนจัดซื้อ', value: Number(planValueResult.rows[0]?.total) || 0 },
    { label: 'มูลค่าอนุมัติจัดซื้อ', value: Number(approvalValueResult.rows[0]?.total) || 0 },
  ];

  return (
    <div className="min-h-screen">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <HomeDashboard
          overview={visibleOverview}
          valueStats={valueStats}
          productsByCategory={normalizeChartRows(productsByCategoryResult.rows)}
          surveysByDepartment={normalizeChartRows(surveysByDepartmentResult.rows)}
          purchasePlanStatus={normalizeChartRows(purchasePlanStatusResult.rows)}
          budgetTrend={budgetTrendResult.rows.map((row) => ({
            year: row.year || '-',
            surveyValue: Number(row.surveyValue) || 0,
            planValue: Number(row.planValue) || 0,
          }))}
          departmentComparison={departmentComparisonResult.rows.map((row) => ({
            name: row.name || 'ไม่ระบุ',
            surveyCount: Number(row.surveyCount) || 0,
            planCount: Number(row.planCount) || 0,
            approvalCount: Number(row.approvalCount) || 0,
          }))}
          departmentValue={departmentValueResult.rows.map((row) => ({
            name: row.name || 'ไม่ระบุ',
            surveyValue: Number(row.surveyValue) || 0,
            planValue: Number(row.planValue) || 0,
            approvalValue: Number(row.approvalValue) || 0,
          }))}
        />
        {/* Module Grid */}
      </div>
    </div>
  );
}
