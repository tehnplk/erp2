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
      pgQuery(`SELECT DISTINCT usageplan_dept FROM public.purchase_plan WHERE usageplan_dept IS NOT NULL AND usageplan_dept <> '' ORDER BY usageplan_dept ASC`),
      pgQuery(`SELECT DISTINCT budget_year FROM public.purchase_plan WHERE budget_year IS NOT NULL AND budget_year <> '' ORDER BY budget_year DESC`)
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      categories: Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean))),
      product_types: Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean))),
      product_subtypes: Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean))),
      category_options: categoryRows,
      departments: departments.rows.map((item: any) => item.usageplan_dept).filter(Boolean),
      budget_years: budgetYears.rows.map((item: any) => item.budget_year).filter(Boolean)
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
