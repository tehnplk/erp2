import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

export async function GET() {
  try {
    const cacheKey = 'erp:purchase:plans:filters';
    const cached = await cacheGet<unknown>(cacheKey);
    if (cached) {
      return NextResponse.json(cached);
    }

    const [categoryRowsResult, departments, budgetYears, purchaseDepartments] = await Promise.all([
      pgQuery(
        `SELECT category, type, subtype
         FROM public.category
         WHERE is_active = true
         ORDER BY category ASC, type ASC, subtype ASC`,
      ),
      pgQuery(
        `SELECT DISTINCT COALESCE(d.name, up.requesting_dept_code) AS requesting_dept
         FROM public.usage_plan up
         LEFT JOIN public.department d ON d.department_code = up.requesting_dept_code
         WHERE up.requesting_dept_code IS NOT NULL
           AND up.requesting_dept_code <> ''
         ORDER BY requesting_dept ASC`,
      ),
      pgQuery(
        `SELECT DISTINCT budget_year
         FROM public.usage_plan
         WHERE budget_year IS NOT NULL
         ORDER BY budget_year DESC`,
      ),
      pgQuery(
        `SELECT DISTINCT pd.name AS purchase_department
         FROM public.usage_plan up
         INNER JOIN public.product p ON p.code = up.product_code
         LEFT JOIN public.department pd ON pd.id = p.purchase_department_id
         WHERE up.purchase_plan_id IS NOT NULL
           AND pd.name IS NOT NULL
           AND pd.name <> ''
         ORDER BY pd.name ASC`,
      ),
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      categories: Array.from(new Set(categoryRows.map((item: { category?: string }) => item.category).filter(Boolean))),
      product_types: Array.from(new Set(categoryRows.map((item: { type?: string }) => item.type).filter(Boolean))),
      product_subtypes: Array.from(new Set(categoryRows.map((item: { subtype?: string | null }) => item.subtype).filter(Boolean))),
      category_options: categoryRows,
      departments: departments.rows.map((item: { requesting_dept?: string }) => item.requesting_dept).filter(Boolean),
      purchase_departments: purchaseDepartments.rows.map((item: { purchase_department?: string }) => item.purchase_department).filter(Boolean),
      budget_years: budgetYears.rows.map((item: { budget_year?: number }) => String(item.budget_year)).filter(Boolean),
    };

    await cacheSet(cacheKey, result, 3600);

    return NextResponse.json(result);
  } catch (error) {
    console.error('Error fetching purchase plan filter options:', error);
    return NextResponse.json({ error: 'Failed to fetch filter options' }, { status: 500 });
  }
}
