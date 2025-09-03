import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    const body = await request.json();
    
    const {
      productId,
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
    
    // Validate required fields
    if (!productId || !category || !type || !subtype || !productName || 
        !requestedAmount || !unit || !requestingDept) {
      return NextResponse.json(
        { error: 'Missing required fields' },
        { status: 400 }
      );
    }
    
    const survey = await prisma.survey.update({
      where: { id },
      data: {
        productId,
        category,
        type,
        subtype,
        productName,
        requestedAmount: parseInt(requestedAmount),
        unit,
        pricePerUnit: pricePerUnit ? parseFloat(pricePerUnit) : null,
        requestingDept,
        approvedQuota: approvedQuota ? parseInt(approvedQuota) : 0
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
  { params }: { params: { id: string } }
) {
  try {
    const id = parseInt(params.id);
    
    await prisma.survey.delete({
      where: { id }
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
