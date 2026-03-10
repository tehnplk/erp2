import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

export async function GET(request: NextRequest) {
  try {
    const cacheKey = 'erp:surveys:filters';
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return NextResponse.json(cached);
    }

    const [categoryRowsResult, departments, budgetYears] = await Promise.all([
      pgQuery(
        `SELECT category, type, subtype
         FROM public.category
         ORDER BY category ASC, type ASC, subtype ASC`
      ),
      pgQuery('SELECT DISTINCT requesting_dept FROM public.usage_plan WHERE requesting_dept IS NOT NULL ORDER BY requesting_dept ASC'),
      pgQuery('SELECT DISTINCT budget_year FROM public.usage_plan WHERE budget_year IS NOT NULL ORDER BY budget_year DESC')
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      categories: Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean))),
      types: Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean))),
      subtypes: Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean))),
      category_options: categoryRows,
      departments: departments.rows.map((d: any) => d.requesting_dept).filter(Boolean),
      budget_years: budgetYears.rows.map((year: any) => year.budget_year).filter((value: number | null) => value !== null)
    };

    await cacheSet(cacheKey, result, 3600);

    return NextResponse.json(result);
  } catch (error) {
    console.error('Error fetching filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
