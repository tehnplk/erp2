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
         FROM public."Category"
         ORDER BY category ASC, type ASC, subtype ASC`
      ),
      pgQuery('SELECT DISTINCT "requestingDept" AS "requestingDept" FROM public."UsagePlan" WHERE "requestingDept" IS NOT NULL ORDER BY "requestingDept" ASC'),
      pgQuery('SELECT DISTINCT budget_year AS "budgetYear" FROM public."UsagePlan" WHERE budget_year IS NOT NULL ORDER BY budget_year DESC')
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      categories: Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean))),
      types: Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean))),
      subtypes: Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean))),
      categoryOptions: categoryRows,
      departments: departments.rows.map((d: any) => d.requestingDept).filter(Boolean),
      budgetYears: budgetYears.rows.map((year: any) => year.budgetYear).filter((value: number | null) => value !== null)
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
