import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function PUT(request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const id = parseInt(params.id);
    const body = await request.json();
    const data: any = {
      productCode: body.productCode ?? null,
      category: body.category ?? null,
      productName: body.productName ?? null,
      productType: body.productType ?? null,
      productSubtype: body.productSubtype ?? null,
      unit: body.unit ?? null,
      pricePerUnit: body.pricePerUnit != null ? parseFloat(body.pricePerUnit) : undefined,
      budgetYear: body.budgetYear ?? null,
      planId: body.planId != null ? parseInt(body.planId) : undefined,
      inPlan: body.inPlan ?? null,
      carriedForwardQuantity: body.carriedForwardQuantity !== undefined ? (body.carriedForwardQuantity === null || body.carriedForwardQuantity === '' ? null : parseInt(body.carriedForwardQuantity)) : undefined,
      carriedForwardValue: body.carriedForwardValue != null ? parseFloat(body.carriedForwardValue) : undefined,
      requiredQuantityForYear: body.requiredQuantityForYear !== undefined ? (body.requiredQuantityForYear === null || body.requiredQuantityForYear === '' ? null : parseInt(body.requiredQuantityForYear)) : undefined,
      totalRequiredValue: body.totalRequiredValue != null ? parseFloat(body.totalRequiredValue) : undefined,
      additionalPurchaseQty: body.additionalPurchaseQty !== undefined ? (body.additionalPurchaseQty === null || body.additionalPurchaseQty === '' ? null : parseInt(body.additionalPurchaseQty)) : undefined,
      additionalPurchaseValue: body.additionalPurchaseValue != null ? parseFloat(body.additionalPurchaseValue) : undefined,
      purchasingDepartment: body.purchasingDepartment ?? null,
    };

    const updated = await prisma.purchasePlan.update({ where: { id }, data });
    return NextResponse.json(updated);
  } catch (error) {
    console.error('Error updating purchase plan:', error);
    return NextResponse.json({ error: 'Failed to update purchase plan' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: { id: string } }) {
  try {
    const id = parseInt(params.id);
    await prisma.purchasePlan.delete({ where: { id } });
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting purchase plan:', error);
    return NextResponse.json({ error: 'Failed to delete purchase plan' }, { status: 500 });
  }
}
