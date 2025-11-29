import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [transactionTypes, categories, productTypes, productSubtypes, companies, departments] = await Promise.all([
      prisma.warehouse.findMany({
        select: { transactionType: true },
        distinct: ['transactionType'],
        orderBy: { transactionType: 'asc' }
      }),
      prisma.warehouse.findMany({
        select: { category: true },
        distinct: ['category'],
        orderBy: { category: 'asc' }
      }),
      prisma.warehouse.findMany({
        select: { productType: true },
        distinct: ['productType'],
        orderBy: { productType: 'asc' }
      }),
      prisma.warehouse.findMany({
        select: { productSubtype: true },
        distinct: ['productSubtype'],
        orderBy: { productSubtype: 'asc' }
      }),
      prisma.warehouse.findMany({
        select: { receivedFromCompany: true },
        distinct: ['receivedFromCompany'],
        where: { receivedFromCompany: { not: null } },
        orderBy: { receivedFromCompany: 'asc' }
      }),
      prisma.warehouse.findMany({
        select: { requestingDepartment: true },
        distinct: ['requestingDepartment'],
        where: { requestingDepartment: { not: null } },
        orderBy: { requestingDepartment: 'asc' }
      })
    ]);

    return NextResponse.json({
      transactionTypes: transactionTypes.map(item => item.transactionType).filter(Boolean),
      categories: categories.map(item => item.category).filter(Boolean),
      productTypes: productTypes.map(item => item.productType).filter(Boolean),
      productSubtypes: productSubtypes.map(item => item.productSubtype).filter(Boolean),
      companies: companies.map(item => item.receivedFromCompany).filter(Boolean),
      departments: departments.map(item => item.requestingDepartment).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching warehouse filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
