import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

export async function GET(request: NextRequest) {
  try {
    const usage_plan_filters_cache_key = 'erp:usage_plans:filters:v1';
    const cached_usage_plan_filters = await cacheGet<any>(usage_plan_filters_cache_key);
    if (cached_usage_plan_filters) {
      return NextResponse.json(cached_usage_plan_filters);
    }

    const [categoryRowsResult, departmentRowsResult, budgetYearRowsResult] = await Promise.all([
      pgQuery(
        `SELECT category, type, subtype
         FROM public.category
         ORDER BY category ASC, type ASC, subtype ASC`
      ),
      pgQuery('SELECT name FROM public.department WHERE name IS NOT NULL ORDER BY name ASC'),
      pgQuery('SELECT DISTINCT budget_year FROM public.usage_plan WHERE budget_year IS NOT NULL ORDER BY budget_year DESC')
    ]);

    const category_rows = categoryRowsResult.rows;

    const categories = Array.from(new Set(category_rows.map((item: any) => item.category).filter(Boolean))).sort((a, b) => a.localeCompare(b));
    const types = Array.from(new Set(category_rows.map((item: any) => item.type).filter(Boolean))).sort((a, b) => a.localeCompare(b));
    const subtypes = Array.from(new Set(category_rows.map((item: any) => item.subtype).filter(Boolean))).sort((a, b) => a.localeCompare(b));

    const usage_plan_filters = {
      categories,
      types,
      subtypes,
      category_options: category_rows,
      departments: departmentRowsResult.rows.map((department: any) => department.name).filter(Boolean).sort((a: string, b: string) => a.localeCompare(b)),
      budget_years: budgetYearRowsResult.rows.map((budget_year: any) => budget_year.budget_year).filter((value: number | null) => value !== null)
    };

    await cacheSet(usage_plan_filters_cache_key, usage_plan_filters, 3600);

    return NextResponse.json(usage_plan_filters);
  } catch (error) {
    console.error('Error fetching usage_plan filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
