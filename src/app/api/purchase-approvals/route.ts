import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { purchaseApprovalQuerySchema, createPurchaseApprovalSchema } from '@/lib/validation/schemas';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    
    // Validate query parameters
    const queryValidation = validateQuery(purchaseApprovalQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }
    
    const { orderBy, sortOrder, productName, category, productType, productSubtype, department } = queryValidation.data as any;

    const where: any = {};
    if (productName) where.productName = { contains: productName, mode: 'insensitive' };
    if (category) where.category = category;
    if (productType) where.productType = productType;
    if (productSubtype) where.productSubtype = productSubtype;
    if (department) where.department = department;

    let orderByClause: any = { id: 'desc' };
    if (orderBy) orderByClause = { [orderBy]: sortOrder };

    // Get total count and items in parallel
    const [totalCount, items] = await Promise.all([
      prisma.purchaseApproval.count({ where }),
      prisma.purchaseApproval.findMany({ where, orderBy: orderByClause })
    ]);

    return apiSuccess(items, undefined, totalCount);
  } catch (error) {
    console.error('Error fetching purchase approvals:', error);
    return apiError('Failed to fetch purchase approvals');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createPurchaseApprovalSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const item = await prisma.purchaseApproval.create({ 
      data: validation.data as any
    });
    
    return apiSuccess(item, 'Purchase approval created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating purchase approval:', error);
    return apiError('Failed to create purchase approval');
  }
}
