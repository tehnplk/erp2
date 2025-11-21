import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [categories, productTypes, productSubtypes, departments, budgetYears] = await Promise.all([
      prisma.purchasePlan.findMany({
        select: { category: true },
        distinct: ['category'],
        orderBy: { category: 'asc' }
      }),
      prisma.purchasePlan.findMany({
        select: { productType: true },
        distinct: ['productType'],
        orderBy: { productType: 'asc' }
      }),
      prisma.purchasePlan.findMany({
        select: { productSubtype: true },
        distinct: ['productSubtype'],
        orderBy: { productSubtype: 'asc' }
      }),
      prisma.purchasePlan.findMany({
        select: { purchasingDepartment: true },
        distinct: ['purchasingDepartment'],
        orderBy: { purchasingDepartment: 'asc' }
      }),
      prisma.purchasePlan.findMany({
        select: { budgetYear: true },
        distinct: ['budgetYear'],
        orderBy: { budgetYear: 'desc' }
      })
    ]);

    return NextResponse.json({
      categories: categories.map(item => item.category).filter(Boolean),
      productTypes: productTypes.map(item => item.productType).filter(Boolean),
      productSubtypes: productSubtypes.map(item => item.productSubtype).filter(Boolean),
      departments: departments.map(item => item.purchasingDepartment).filter(Boolean),
      budgetYears: budgetYears.map(item => item.budgetYear).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching purchase plan filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
