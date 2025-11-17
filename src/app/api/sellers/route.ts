import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { validateRequest, validateQuery } from '@/lib/validation/validate';
import { createSellerSchema, sellerQuerySchema } from '@/lib/validation/schemas';

// GET /api/sellers - Get sellers with optional pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(sellerQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { name, page, pageSize } = queryValidation.data as any;

    const where: any = {};
    if (name) {
      where.name = {
        contains: name,
        mode: 'insensitive'
      };
    }

    // If no pagination params, return all sellers (backwards compatible)
    if (!page || !pageSize) {
      const sellers = await prisma.seller.findMany({
        where,
        orderBy: { id: 'asc' }
      });
      return apiSuccess(sellers, undefined, sellers.length);
    }

    const skip = (page - 1) * pageSize;

    const [totalCount, sellers] = await Promise.all([
      prisma.seller.count({ where }),
      prisma.seller.findMany({
        where,
        orderBy: { id: 'asc' },
        skip,
        take: pageSize
      })
    ]);
    
    return apiSuccess(sellers, undefined, totalCount, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching sellers:', error);
    return apiError('Failed to fetch sellers');
  }
}

// POST /api/sellers - Create new seller
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createSellerSchema, body);
    if (!validation.success) {
      return validation.error;
    }
    
    const { code } = validation.data as any;

    // Check if seller with this code already exists
    const existingSeller = await prisma.seller.findUnique({
      where: { code }
    });

    if (existingSeller) {
      return apiConflict('Seller with this code already exists');
    }

    const newSeller = await prisma.seller.create({
      data: validation.data as any
    });

    return apiSuccess(newSeller, 'Seller created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating seller:', error);
    return apiError('Failed to create seller');
  }
}

