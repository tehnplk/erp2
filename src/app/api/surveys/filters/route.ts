import { NextRequest, NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';

export async function GET(request: NextRequest) {
  try {
    const [categories, types, subtypes, departments, budgetYears] = await Promise.all([
      pgQuery('SELECT DISTINCT category FROM public."Survey" WHERE category IS NOT NULL ORDER BY category ASC'),
      pgQuery('SELECT DISTINCT type FROM public."Survey" WHERE type IS NOT NULL ORDER BY type ASC'),
      pgQuery('SELECT DISTINCT subtype FROM public."Survey" WHERE subtype IS NOT NULL ORDER BY subtype ASC'),
      pgQuery('SELECT DISTINCT "requestingDept" AS "requestingDept" FROM public."Survey" WHERE "requestingDept" IS NOT NULL ORDER BY "requestingDept" ASC'),
      pgQuery('SELECT DISTINCT budget_year AS "budgetYear" FROM public."Survey" WHERE budget_year IS NOT NULL ORDER BY budget_year DESC')
    ]);

    return NextResponse.json({
      categories: categories.rows.map((c: any) => c.category).filter(Boolean),
      types: types.rows.map((t: any) => t.type).filter(Boolean),
      subtypes: subtypes.rows.map((s: any) => s.subtype).filter(Boolean),
      departments: departments.rows.map((d: any) => d.requestingDept).filter(Boolean),
      budgetYears: budgetYears.rows.map((year: any) => year.budgetYear).filter((value: number | null) => value !== null)
    });
  } catch (error) {
    console.error('Error fetching filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
