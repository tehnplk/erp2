import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const numericId = parseInt(id);
    const body = await request.json();
    const data: any = {
      stockId: body.stockId ?? null,
      transactionType: body.transactionType ?? null,
      transactionDate: body.transactionDate ?? null,
      category: body.category ?? null,
      productType: body.productType ?? null,
      productSubtype: body.productSubtype ?? null,
      productCode: body.productCode ?? null,
      productName: body.productName ?? null,
      productImage: body.productImage ?? null,
      unit: body.unit ?? null,
      productLot: body.productLot ?? null,
      productPrice: body.productPrice != null ? parseFloat(body.productPrice) : undefined,
      receivedFromCompany: body.receivedFromCompany ?? null,
      receiptBillNumber: body.receiptBillNumber ?? null,
      requestingDepartment: body.requestingDepartment ?? null,
      requisitionNumber: body.requisitionNumber ?? null,
      quotaAmount: body.quotaAmount !== undefined ? (body.quotaAmount === null || body.quotaAmount === '' ? null : parseInt(body.quotaAmount)) : undefined,
      carriedForwardQty: body.carriedForwardQty !== undefined ? (body.carriedForwardQty === null || body.carriedForwardQty === '' ? null : parseInt(body.carriedForwardQty)) : undefined,
      carriedForwardValue: body.carriedForwardValue != null ? parseFloat(body.carriedForwardValue) : undefined,
      transactionPrice: body.transactionPrice != null ? parseFloat(body.transactionPrice) : undefined,
      transactionQuantity: body.transactionQuantity !== undefined ? (body.transactionQuantity === null || body.transactionQuantity === '' ? null : parseInt(body.transactionQuantity)) : undefined,
      transactionValue: body.transactionValue != null ? parseFloat(body.transactionValue) : undefined,
      remainingQuantity: body.remainingQuantity !== undefined ? (body.remainingQuantity === null || body.remainingQuantity === '' ? null : parseInt(body.remainingQuantity)) : undefined,
      remainingValue: body.remainingValue != null ? parseFloat(body.remainingValue) : undefined,
      inventoryStatus: body.inventoryStatus ?? null,
    };

    const updated = await prisma.warehouse.update({ where: { id: numericId }, data });
    return NextResponse.json(updated);
  } catch (error) {
    console.error('Error updating warehouse record:', error);
    return NextResponse.json({ error: 'Failed to update warehouse record' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const numericId = parseInt(id);
    await prisma.warehouse.delete({ where: { id: numericId } });
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting warehouse record:', error);
    return NextResponse.json({ error: 'Failed to delete warehouse record' }, { status: 500 });
  }
}
