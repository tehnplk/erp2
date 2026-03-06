import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET() {
  try {
    const [categoryRows, unitRows, sellerRows] = await Promise.all([
      prisma.category.findMany({
        select: {
          category: true,
          type: true,
          subtype: true,
        },
        orderBy: [
          { category: 'asc' },
          { type: 'asc' },
          { subtype: 'asc' },
        ],
      }),
      prisma.product.findMany({
        select: { unit: true },
        distinct: ['unit'],
        orderBy: { unit: 'asc' },
      }),
      prisma.seller.findMany({
        select: { code: true, name: true },
        orderBy: { code: 'asc' },
      }),
    ]);

    const categories = Array.from(new Set(categoryRows.map((item) => item.category).filter(Boolean)));
    const types = Array.from(new Set(categoryRows.map((item) => item.type).filter(Boolean)));
    const subtypes = Array.from(new Set(categoryRows.map((item) => item.subtype).filter(Boolean)));
    const units = unitRows.map((item) => item.unit).filter(Boolean);
    const sellerCodes = sellerRows.map((seller) => seller.code).filter(Boolean);

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
