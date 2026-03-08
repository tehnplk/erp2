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

    // Get distinct values for each filter field
    const [categories, productTypes, productSubtypes, departments, budgetYears] = await Promise.all([
      pgQuery(`SELECT DISTINCT category FROM public."PurchasePlan" WHERE category IS NOT NULL AND category <> '' ORDER BY category ASC`),
      pgQuery(`SELECT DISTINCT "productType" FROM public."PurchasePlan" WHERE "productType" IS NOT NULL AND "productType" <> '' ORDER BY "productType" ASC`),
      pgQuery(`SELECT DISTINCT "productSubtype" FROM public."PurchasePlan" WHERE "productSubtype" IS NOT NULL AND "productSubtype" <> '' ORDER BY "productSubtype" ASC`),
      pgQuery(`SELECT DISTINCT "purchasingDepartment" FROM public."PurchasePlan" WHERE "purchasingDepartment" IS NOT NULL AND "purchasingDepartment" <> '' ORDER BY "purchasingDepartment" ASC`),
      pgQuery(`SELECT DISTINCT "budgetYear" FROM public."PurchasePlan" WHERE "budgetYear" IS NOT NULL AND "budgetYear" <> '' ORDER BY "budgetYear" DESC`)
    ]);

    const result = {
      categories: categories.rows.map(item => item.category).filter(Boolean),
      productTypes: productTypes.rows.map(item => item.productType).filter(Boolean),
      productSubtypes: productSubtypes.rows.map(item => item.productSubtype).filter(Boolean),
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
