import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const orderBy = searchParams.get('orderBy');
    const sortOrder = (searchParams.get('sortOrder') as 'asc' | 'desc') || 'desc';

    const productName = searchParams.get('productName');
    const category = searchParams.get('category');
    const productType = searchParams.get('productType');
    const productSubtype = searchParams.get('productSubtype');
    const department = searchParams.get('department');

    const where: any = {};
    if (productName) where.productName = { contains: productName, mode: 'insensitive' };
    if (category) where.category = category;
    if (productType) where.productType = productType;
    if (productSubtype) where.productSubtype = productSubtype;
    if (department) where.department = department;

    let orderByClause: any = { id: 'desc' };
    if (orderBy) orderByClause = { [orderBy]: sortOrder };

    const totalCount = await prisma.purchaseApproval.count();
    const items = await prisma.purchaseApproval.findMany({ where, orderBy: orderByClause });

    return NextResponse.json({ items, totalCount });
  } catch (error) {
    console.error('Error fetching purchase approvals:', error);
    return NextResponse.json({ error: 'Failed to fetch purchase approvals' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const data: any = {
      approvalId: body.approvalId ?? null,
      department: body.department ?? null,
      recordNumber: body.recordNumber ?? null,
      requestDate: body.requestDate ?? null,
      productName: body.productName ?? null,
      productCode: body.productCode ?? null,
      category: body.category ?? null,
      productType: body.productType ?? null,
      productSubtype: body.productSubtype ?? null,
      requestedQuantity: body.requestedQuantity != null && body.requestedQuantity !== '' ? parseInt(body.requestedQuantity) : null,
      unit: body.unit ?? null,
      pricePerUnit: body.pricePerUnit ? parseFloat(body.pricePerUnit) : 0,
      totalValue: body.totalValue ? parseFloat(body.totalValue) : 0,
      overPlanCase: body.overPlanCase ?? null,
      requester: body.requester ?? null,
      approver: body.approver ?? null,
    };

    const item = await prisma.purchaseApproval.create({ data });
    return NextResponse.json(item, { status: 201 });
  } catch (error) {
    console.error('Error creating purchase approval:', error);
    return NextResponse.json({ error: 'Failed to create purchase approval' }, { status: 500 });
  }
}
