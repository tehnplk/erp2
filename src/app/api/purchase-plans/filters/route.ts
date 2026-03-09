import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

export async function GET() {
  try {
    const cacheKey = 'erp:purchase:plans:filters';
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
      pgQuery(`SELECT DISTINCT purchasing_department FROM public.purchase_plan WHERE purchasing_department IS NOT NULL AND purchasing_department <> '' ORDER BY purchasing_department ASC`),
      pgQuery(`SELECT DISTINCT budget_year FROM public.purchase_plan WHERE budget_year IS NOT NULL AND budget_year <> '' ORDER BY budget_year DESC`)
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      categories: Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean))),
      productTypes: Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean))),
      productSubtypes: Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean))),
      categoryOptions: categoryRows,
      departments: departments.rows.map((item: any) => item.purchasing_department).filter(Boolean),
      budgetYears: budgetYears.rows.map((item: any) => item.budget_year).filter(Boolean)
    };

    await cacheSet(cacheKey, result, 3600);

    return NextResponse.json(result);
  } catch (error) {
    console.error('Error fetching purchase plan filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
