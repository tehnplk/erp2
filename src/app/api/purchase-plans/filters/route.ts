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
         FROM public."Category"
         ORDER BY category ASC, type ASC, subtype ASC`
      ),
      pgQuery(`SELECT DISTINCT "purchasingDepartment" FROM public."PurchasePlan" WHERE "purchasingDepartment" IS NOT NULL AND "purchasingDepartment" <> '' ORDER BY "purchasingDepartment" ASC`),
      pgQuery(`SELECT DISTINCT "budgetYear" FROM public."PurchasePlan" WHERE "budgetYear" IS NOT NULL AND "budgetYear" <> '' ORDER BY "budgetYear" DESC`)
    ]);

    const categoryRows = categoryRowsResult.rows;

    const result = {
      categories: Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean))),
      productTypes: Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean))),
      productSubtypes: Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean))),
      categoryOptions: categoryRows,
      departments: departments.rows.map(item => item.purchasingDepartment).filter(Boolean),
      budgetYears: budgetYears.rows.map(item => item.budgetYear).filter(Boolean)
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
