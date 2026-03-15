import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

export async function GET() {
  try {
    const cacheKey = 'erp:categories:filters';
    const cached = await cacheGet<any>(cacheKey);
    if (cached) return NextResponse.json(cached);

    // Get distinct values for each filter field
    const [categoriesResult, typesResult, subtypesResult] = await Promise.all([
      pgQuery('SELECT DISTINCT category FROM public.category WHERE is_active = true ORDER BY category ASC'),
      pgQuery('SELECT DISTINCT type FROM public.category WHERE is_active = true ORDER BY type ASC'),
      pgQuery('SELECT DISTINCT subtype FROM public.category WHERE is_active = true ORDER BY subtype ASC'),
    ]);

    const result = {
      categories: categoriesResult.rows.map((item: any) => item.category).filter(Boolean),
      types: typesResult.rows.map((item: any) => item.type).filter(Boolean),
      subtypes: subtypesResult.rows.map((item: any) => item.subtype).filter(Boolean)
    };

    await cacheSet(cacheKey, result, 3600);
    return NextResponse.json(result);
  } catch (error) {
    console.error('Error fetching category filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
