import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const numericId = parseInt(id);
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
      requestedQuantity: body.requestedQuantity !== undefined ? (body.requestedQuantity === null || body.requestedQuantity === '' ? null : parseInt(body.requestedQuantity)) : undefined,
      unit: body.unit ?? null,
      pricePerUnit: body.pricePerUnit != null ? parseFloat(body.pricePerUnit) : undefined,
      totalValue: body.totalValue != null ? parseFloat(body.totalValue) : undefined,
      overPlanCase: body.overPlanCase ?? null,
      requester: body.requester ?? null,
      approver: body.approver ?? null,
    };

    const updated = await prisma.purchaseApproval.update({ where: { id: numericId }, data });
    return NextResponse.json(updated);
  } catch (error) {
    console.error('Error updating purchase approval:', error);
    return NextResponse.json({ error: 'Failed to update purchase approval' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const numericId = parseInt(id);
    await prisma.purchaseApproval.delete({ where: { id: numericId } });
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting purchase approval:', error);
    return NextResponse.json({ error: 'Failed to delete purchase approval' }, { status: 500 });
  }
}
