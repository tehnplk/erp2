import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET(request: NextRequest) {
  try {
    // Get unique categories
    const categories = await prisma.survey.findMany({
      select: { category: true },
      distinct: ['category'],
      where: { category: { not: null } }
    });

    // Get unique types
    const types = await prisma.survey.findMany({
      select: { type: true },
      distinct: ['type'],
      where: { type: { not: null } }
    });

    // Get unique subtypes
    const subtypes = await prisma.survey.findMany({
      select: { subtype: true },
      distinct: ['subtype'],
      where: { subtype: { not: null } }
    });

    // Get unique requesting departments
    const departments = await prisma.survey.findMany({
      select: { requestingDept: true },
      distinct: ['requestingDept'],
      where: { requestingDept: { not: null } }
    });

    return NextResponse.json({
      categories: categories.map(c => c.category).filter(Boolean),
      types: types.map(t => t.type).filter(Boolean),
      subtypes: subtypes.map(s => s.subtype).filter(Boolean),
      departments: departments.map(d => d.requestingDept).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
