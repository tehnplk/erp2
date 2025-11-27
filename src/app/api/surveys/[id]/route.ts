import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseInt(id);
    const body = await request.json();
    
    const {
      productCode,
      category,
      type,
      subtype,
      productName,
      requestedAmount,
      unit,
      pricePerUnit,
      requestingDept,
      approvedQuota
    } = body;
    
    const survey = await prisma.survey.update({
      where: { id: numericId },
      data: {
        productCode: productCode || null,
        category: category || null,
        type: type || null,
        subtype: subtype || null,
        productName: productName || null,
        requestedAmount: requestedAmount ? parseInt(requestedAmount) : null,
        unit: unit || null,
        pricePerUnit: pricePerUnit ? parseFloat(pricePerUnit) : 0,
        requestingDept: requestingDept || null,
        approvedQuota: approvedQuota ? parseInt(approvedQuota) : null
      }
    });
    
    return NextResponse.json(survey);
  } catch (error) {
    console.error('Error updating survey:', error);
    return NextResponse.json(
      { error: 'Failed to update survey' },
      { status: 500 }
    );
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseInt(id);
    
    await prisma.survey.delete({
      where: { id: numericId }
    });
    
    return NextResponse.json({ message: 'Survey deleted successfully' });
  } catch (error) {
    console.error('Error deleting survey:', error);
    return NextResponse.json(
      { error: 'Failed to delete survey' },
      { status: 500 }
    );
  }
}
