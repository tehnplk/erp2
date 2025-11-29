import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [categories, types, subtypes] = await Promise.all([
      prisma.category.findMany({
        select: { category: true },
        distinct: ['category'],
        orderBy: { category: 'asc' }
      }),
      prisma.category.findMany({
        select: { type: true },
        distinct: ['type'],
        orderBy: { type: 'asc' }
      }),
      prisma.category.findMany({
        select: { subtype: true },
        distinct: ['subtype'],
        orderBy: { subtype: 'asc' }
      })
    ]);

    return NextResponse.json({
      categories: categories.map(item => item.category).filter(Boolean),
      types: types.map(item => item.type).filter(Boolean),
      subtypes: subtypes.map(item => item.subtype).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching category filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
