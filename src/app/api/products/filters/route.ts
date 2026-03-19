import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

export async function GET() {
  try {
    const cacheKey = 'erp:products:filters';
    const cached = await cacheGet<any>(cacheKey);
    if (cached) return NextResponse.json(cached);

    const [categoryRowsResult, unitRowsResult, sellerRowsResult, departmentRowsResult] = await Promise.all([
      pgQuery(
        `SELECT category, type, subtype
         FROM public.category
         WHERE is_active = true
         ORDER BY category ASC, type ASC, subtype ASC`
      ),
      pgQuery(
        `SELECT DISTINCT unit
         FROM public.product
         WHERE is_active = true
           AND unit IS NOT NULL
         ORDER BY unit ASC`
      ),
      pgQuery(
        `SELECT code, name
         FROM public.seller
         WHERE is_active = true
         ORDER BY code ASC`
      ),
      pgQuery(
        `SELECT id, name, department_code
         FROM public.department
         WHERE is_active = true
         ORDER BY id ASC`
      ),
    ]);

    const categoryRows = categoryRowsResult.rows;
    const unitRows = unitRowsResult.rows;
    const sellerRows = sellerRowsResult.rows;
    const departmentRows = departmentRowsResult.rows;

    const categories = Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean)));
    const types = Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean)));
    const subtypes = Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean)));
    const units = unitRows.map((item: any) => item.unit).filter(Boolean);
    const sellerCodes = sellerRows.map((seller: any) => seller.code).filter(Boolean);

    const result = {
      categories,
      types,
      subtypes,
      units,
      seller_codes: sellerCodes,
      category_options: categoryRows,
      seller_options: sellerRows,
      department_options: departmentRows,
    };

    await cacheSet(cacheKey, result, 3600);
    return NextResponse.json(result);
  } catch (error) {
    console.error('Error fetching product filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
