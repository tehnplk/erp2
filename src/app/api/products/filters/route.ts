import { NextResponse } from 'next/server';
import { pgQuery } from '@/lib/pg';

export async function GET() {
  try {
    const [categoryRowsResult, unitRowsResult, sellerRowsResult] = await Promise.all([
      pgQuery(
        `SELECT category, type, subtype
         FROM public."Category"
         ORDER BY category ASC, type ASC, subtype ASC`
      ),
      pgQuery(
        `SELECT DISTINCT unit
         FROM public."Product"
         WHERE unit IS NOT NULL
         ORDER BY unit ASC`
      ),
      pgQuery(
        `SELECT code, name
         FROM public."Seller"
         ORDER BY code ASC`
      ),
    ]);

    const categoryRows = categoryRowsResult.rows;
    const unitRows = unitRowsResult.rows;
    const sellerRows = sellerRowsResult.rows;

    const categories = Array.from(new Set(categoryRows.map((item: any) => item.category).filter(Boolean)));
    const types = Array.from(new Set(categoryRows.map((item: any) => item.type).filter(Boolean)));
    const subtypes = Array.from(new Set(categoryRows.map((item: any) => item.subtype).filter(Boolean)));
    const units = unitRows.map((item: any) => item.unit).filter(Boolean);
    const sellerCodes = sellerRows.map((seller: any) => seller.code).filter(Boolean);

    return NextResponse.json({
      categories,
      types,
      subtypes,
      units,
      sellerCodes,
      categoryOptions: categoryRows,
      sellerOptions: sellerRows,
    });
  } catch (error) {
    console.error('Error fetching product filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
