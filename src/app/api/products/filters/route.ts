import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [categories, types, subtypes, sellerCodes] = await Promise.all([
      prisma.product.findMany({
        select: { category: true },
        distinct: ['category'],
        orderBy: { category: 'asc' }
      }),
      prisma.product.findMany({
        select: { type: true },
        distinct: ['type'],
        orderBy: { type: 'asc' }
      }),
      prisma.product.findMany({
        select: { subtype: true },
        distinct: ['subtype'],
        orderBy: { subtype: 'asc' }
      }),
      prisma.product.findMany({
        select: { sellerCode: true },
        distinct: ['sellerCode'],
        where: { sellerCode: { not: null } },
        orderBy: { sellerCode: 'asc' }
      })
    ]);

    return NextResponse.json({
      categories: categories.map(item => item.category).filter(Boolean),
      types: types.map(item => item.type).filter(Boolean),
      subtypes: subtypes.map(item => item.subtype).filter(Boolean),
      sellerCodes: sellerCodes.map(item => item.sellerCode).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching product filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
