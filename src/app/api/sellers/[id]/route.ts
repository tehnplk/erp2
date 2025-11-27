import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError, apiNotFound } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateSellerSchema } from '@/lib/validation/schemas';

// GET /api/sellers/[id] - Get seller by ID
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;

    const seller = await prisma.seller.findUnique({
      where: { id }
    });

    if (!seller) {
      return apiNotFound('Seller');
    }

    return apiSuccess(seller);
  } catch (error) {
    console.error('Error fetching seller:', error);
    return apiError('Failed to fetch seller');
  }
}

// PUT /api/sellers/[id] - Update seller
export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;
    
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(updateSellerSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const updatedSeller = await prisma.seller.update({
      where: { id },
      data: validation.data as any
    });

    return apiSuccess(updatedSeller, 'Seller updated successfully');
  } catch (error: any) {
    console.error('Error updating seller:', error);
    if (error.code === 'P2025') {
      return apiNotFound('Seller');
    }
    return apiError('Failed to update seller');
  }
}

// DELETE /api/sellers/[id] - Delete seller
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const rawParams = await params;
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, rawParams);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;

    await prisma.seller.delete({
      where: { id }
    });

    return apiSuccess(null, 'Seller deleted successfully');
  } catch (error: any) {
    console.error('Error deleting seller:', error);
    if (error.code === 'P2025') {
      return apiNotFound('Seller');
    }
    return apiError('Failed to delete seller');
  }
}
