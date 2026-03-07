import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [categoriesResult, typesResult, subtypesResult] = await Promise.all([
      pgQuery('SELECT DISTINCT category FROM public."Category" ORDER BY category ASC'),
      pgQuery('SELECT DISTINCT type FROM public."Category" ORDER BY type ASC'),
      pgQuery('SELECT DISTINCT subtype FROM public."Category" ORDER BY subtype ASC'),
    ]);

    return NextResponse.json({
      categories: categoriesResult.rows.map((item: any) => item.category).filter(Boolean),
      types: typesResult.rows.map((item: any) => item.type).filter(Boolean),
      subtypes: subtypesResult.rows.map((item: any) => item.subtype).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching category filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
