import { NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET() {
  try {
    // Get distinct values for each filter field
    const [departments, categories, productTypes, productSubtypes, requesters, approvers] = await Promise.all([
      prisma.purchaseApproval.findMany({
        select: { department: true },
        distinct: ['department'],
        orderBy: { department: 'asc' }
      }),
      prisma.purchaseApproval.findMany({
        select: { category: true },
        distinct: ['category'],
        orderBy: { category: 'asc' }
      }),
      prisma.purchaseApproval.findMany({
        select: { productType: true },
        distinct: ['productType'],
        orderBy: { productType: 'asc' }
      }),
      prisma.purchaseApproval.findMany({
        select: { productSubtype: true },
        distinct: ['productSubtype'],
        orderBy: { productSubtype: 'asc' }
      }),
      prisma.purchaseApproval.findMany({
        select: { requester: true },
        distinct: ['requester'],
        where: { requester: { not: null } },
        orderBy: { requester: 'asc' }
      }),
      prisma.purchaseApproval.findMany({
        select: { approver: true },
        distinct: ['approver'],
        where: { approver: { not: null } },
        orderBy: { approver: 'asc' }
      })
    ]);

    return NextResponse.json({
      departments: departments.map(item => item.department).filter(Boolean),
      categories: categories.map(item => item.category).filter(Boolean),
      productTypes: productTypes.map(item => item.productType).filter(Boolean),
      productSubtypes: productSubtypes.map(item => item.productSubtype).filter(Boolean),
      requesters: requesters.map(item => item.requester).filter(Boolean),
      approvers: approvers.map(item => item.approver).filter(Boolean)
    });
  } catch (error) {
    console.error('Error fetching purchase approval filter options:', error);
    return NextResponse.json(
      { error: 'Failed to fetch filter options' },
      { status: 500 }
    );
  }
}
