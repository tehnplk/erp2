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
    const purchasingDepartment = searchParams.get('purchasingDepartment');
    const budgetYear = searchParams.get('budgetYear');

    const where: any = {};
    if (productName) where.productName = { contains: productName, mode: 'insensitive' };
    if (category) where.category = category;
    if (productType) where.productType = productType;
    if (productSubtype) where.productSubtype = productSubtype;
    if (purchasingDepartment) where.purchasingDepartment = purchasingDepartment;
    if (budgetYear) where.budgetYear = budgetYear;

    let orderByClause: any = { id: 'desc' };
    if (orderBy) orderByClause = { [orderBy]: sortOrder };

    const totalCount = await prisma.purchasePlan.count();
    const items = await prisma.purchasePlan.findMany({ where, orderBy: orderByClause });

    return NextResponse.json({ items, totalCount });
  } catch (error) {
    console.error('Error fetching purchase plans:', error);
    return NextResponse.json({ error: 'Failed to fetch purchase plans' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const data: any = {
      productCode: body.productCode ?? null,
      category: body.category ?? null,
      productName: body.productName ?? null,
      productType: body.productType ?? null,
      productSubtype: body.productSubtype ?? null,
      unit: body.unit ?? null,
      pricePerUnit: body.pricePerUnit ? parseFloat(body.pricePerUnit) : 0,
      budgetYear: body.budgetYear ?? null,
      planId: body.planId ? parseInt(body.planId) : null,
      inPlan: body.inPlan ?? null,
      carriedForwardQuantity: body.carriedForwardQuantity != null && body.carriedForwardQuantity !== '' ? parseInt(body.carriedForwardQuantity) : null,
      carriedForwardValue: body.carriedForwardValue ? parseFloat(body.carriedForwardValue) : 0,
      requiredQuantityForYear: body.requiredQuantityForYear != null && body.requiredQuantityForYear !== '' ? parseInt(body.requiredQuantityForYear) : null,
      totalRequiredValue: body.totalRequiredValue ? parseFloat(body.totalRequiredValue) : 0,
      additionalPurchaseQty: body.additionalPurchaseQty != null && body.additionalPurchaseQty !== '' ? parseInt(body.additionalPurchaseQty) : null,
      additionalPurchaseValue: body.additionalPurchaseValue ? parseFloat(body.additionalPurchaseValue) : 0,
      purchasingDepartment: body.purchasingDepartment ?? null,
    };

    const item = await prisma.purchasePlan.create({ data });
    return NextResponse.json(item, { status: 201 });
  } catch (error) {
    console.error('Error creating purchase plan:', error);
    return NextResponse.json({ error: 'Failed to create purchase plan' }, { status: 500 });
  }
}
