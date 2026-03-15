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

    const [categoryRowsResult, departments, budgetYears] = await Promise.all([
      pgQuery(
        `SELECT category, type, subtype
         FROM public.category
         WHERE is_active = true
         ORDER BY category ASC, type ASC, subtype ASC`,
      ),
      pgQuery(
        `SELECT DISTINCT requesting_dept
         FROM public.usage_plan
         WHERE requesting_dept IS NOT NULL
           AND requesting_dept <> ''
         ORDER BY requesting_dept ASC`,
      ),
      pgQuery(
        `SELECT DISTINCT budget_year
         FROM public.usage_plan
         WHERE budget_year IS NOT NULL
         ORDER BY budget_year DESC`,
      ),
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      categories: Array.from(new Set(categoryRows.map((item: { category?: string }) => item.category).filter(Boolean))),
      product_types: Array.from(new Set(categoryRows.map((item: { type?: string }) => item.type).filter(Boolean))),
      product_subtypes: Array.from(new Set(categoryRows.map((item: { subtype?: string | null }) => item.subtype).filter(Boolean))),
      category_options: categoryRows,
      departments: departments.rows.map((item: { requesting_dept?: string }) => item.requesting_dept).filter(Boolean),
      budget_years: budgetYears.rows.map((item: { budget_year?: number }) => String(item.budget_year)).filter(Boolean),
    };

    await cacheSet(cacheKey, result, 3600);

    return NextResponse.json(result);
  } catch (error) {
    console.error('Error fetching purchase plan filter options:', error);
    return NextResponse.json({ error: 'Failed to fetch filter options' }, { status: 500 });
  }
}
