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

    const [categories, types, subtypes, departments, budgetYears] = await Promise.all([
      pgQuery('SELECT DISTINCT category FROM public."UsagePlan" WHERE category IS NOT NULL ORDER BY category ASC'),
      pgQuery('SELECT DISTINCT type FROM public."UsagePlan" WHERE type IS NOT NULL ORDER BY type ASC'),
      pgQuery('SELECT DISTINCT subtype FROM public."UsagePlan" WHERE subtype IS NOT NULL ORDER BY subtype ASC'),
      pgQuery('SELECT DISTINCT "requestingDept" AS "requestingDept" FROM public."UsagePlan" WHERE "requestingDept" IS NOT NULL ORDER BY "requestingDept" ASC'),
      pgQuery('SELECT DISTINCT budget_year AS "budgetYear" FROM public."UsagePlan" WHERE budget_year IS NOT NULL ORDER BY budget_year DESC')
    ]);

    const result = {
      categories: categories.rows.map((c: any) => c.category).filter(Boolean),
      types: types.rows.map((t: any) => t.type).filter(Boolean),
      subtypes: subtypes.rows.map((s: any) => s.subtype).filter(Boolean),
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
