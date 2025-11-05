import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { createSellerSchema } from '@/lib/validation/schemas';

// GET /api/sellers - Get all sellers
export async function GET() {
  try {
    const sellers = await prisma.seller.findMany({
      orderBy: {
        id: 'asc'
      }
    });
    
    return apiSuccess(sellers, undefined, sellers.length);
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

