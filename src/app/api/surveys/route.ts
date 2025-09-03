import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const orderBy = searchParams.get('orderBy');
    const sortOrder = searchParams.get('sortOrder') || 'asc';
    
    // Get filter parameters
    const productName = searchParams.get('productName');
    const category = searchParams.get('category');
    const type = searchParams.get('type');
    const requestingDept = searchParams.get('requestingDept');
    
    // Build where clause
    const where: any = {};
    
    if (productName) {
      where.productName = {
        contains: productName,
        mode: 'insensitive'
      };
    }
    
    if (category) {
      where.category = category;
    }
    
    if (type) {
      where.type = type;
    }
    
    if (requestingDept) {
      where.requestingDept = requestingDept;
    }
    
    // Build orderBy clause
    const orderByClause: any = {};
    if (orderBy) {
      orderByClause[orderBy] = sortOrder;
    } else {
      orderByClause.id = 'desc';
    }
    
    const surveys = await prisma.survey.findMany({
      where,
      orderBy: orderByClause,
    });
    
    const totalCount = await prisma.survey.count({ where });
    
    return NextResponse.json({
      surveys,
      totalCount
    });
  } catch (error) {
    console.error('Error fetching surveys:', error);
    return NextResponse.json(
      { error: 'Failed to fetch surveys' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
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
    
    const survey = await prisma.survey.create({
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
    
    return NextResponse.json(survey, { status: 201 });
  } catch (error) {
    console.error('Error creating survey:', error);
    return NextResponse.json(
      { error: 'Failed to create survey' },
      { status: 500 }
    );
  }
}
