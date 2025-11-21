import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const productName = searchParams.get('productName');
    const category = searchParams.get('category');
    const type = searchParams.get('type');
    const requestingDept = searchParams.get('requestingDept');
    const orderBy = searchParams.get('orderBy') || 'id';
    const sortOrder = searchParams.get('sortOrder') || 'desc';

    const pageParam = searchParams.get('page');
    const pageSizeParam = searchParams.get('pageSize');

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

    // If no pagination params provided, return all matching surveys (for summaries, exports, etc.)
    if (!pageParam && !pageSizeParam) {
      const [surveys, totalCount] = await Promise.all([
        prisma.survey.findMany({
          where,
          orderBy: orderByClause,
        }),
        prisma.survey.count({ where }),
      ]);

      return NextResponse.json({
        surveys,
        totalCount,
      });
    }

    // Paginated mode (used by main listing)
    let page = pageParam ? parseInt(pageParam, 10) : 1;
    let pageSize = pageSizeParam ? parseInt(pageSizeParam, 10) : 20;

    if (Number.isNaN(page) || page < 1) page = 1;
    if (Number.isNaN(pageSize) || pageSize < 1) pageSize = 20;
    if (pageSize > 200) pageSize = 200;

    const skip = (page - 1) * pageSize;

    const [surveys, totalCount] = await Promise.all([
      prisma.survey.findMany({
        where,
        orderBy: orderByClause,
        skip,
        take: pageSize,
      }),
      prisma.survey.count({ where }),
    ]);
    
    return NextResponse.json({
      surveys,
      totalCount,
      page,
      pageSize,
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
    
    const survey = await prisma.survey.create({
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
    
    return NextResponse.json(survey, { status: 201 });
  } catch (error) {
    console.error('Error creating survey:', error);
    return NextResponse.json(
      { error: 'Failed to create survey' },
      { status: 500 }
    );
  }
}
