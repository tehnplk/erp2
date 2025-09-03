import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [categories, types, subtypes, departments] = await Promise.all([
      prisma.survey.findMany({
        select: { category: true },
        distinct: ['category'],
        orderBy: { category: 'asc' }
      }),
      prisma.survey.findMany({
        select: { type: true },
        distinct: ['type'],
        orderBy: { type: 'asc' }
      }),
      prisma.survey.findMany({
        select: { subtype: true },
        distinct: ['subtype'],
        orderBy: { subtype: 'asc' }
      }),
      prisma.survey.findMany({
        select: { requestingDept: true },
        distinct: ['requestingDept'],
        orderBy: { requestingDept: 'asc' }
      })
    ]);

    return NextResponse.json({
      categories: categories.map(item => item.category).filter(Boolean),
      types: types.map(item => item.type).filter(Boolean),
      subtypes: subtypes.map(item => item.subtype).filter(Boolean),
      departments: departments.map(item => item.requestingDept).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
