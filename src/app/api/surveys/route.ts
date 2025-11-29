import { NextRequest, NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { surveyQuerySchema, createSurveySchema } from '@/lib/validation/schemas';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(surveyQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const {
      productName,
      category,
      type,
      requestingDept,
      orderBy,
      sortOrder,
      page: validatedPage,
      pageSize: validatedPageSize,
    } = queryValidation.data as any;

    // Build where clause
    const where: any = {};
    
    if (productName) {
      where.productName = {
        contains: productName,
        mode: 'insensitive',
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
    const orderField = orderBy || 'id';
    const orderDirection = sortOrder || 'desc';
    orderByClause[orderField] = orderDirection;

    const hasPagination = validatedPage !== undefined || validatedPageSize !== undefined;

    // If no pagination params provided, return all matching surveys (for summaries, exports, etc.)
    if (!hasPagination) {
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
    const page = validatedPage ?? 1;
    const pageSize = validatedPageSize ?? 20;

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

    const validation = await validateRequest(createSurveySchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const survey = await prisma.survey.create({
      data: validation.data as any,
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
