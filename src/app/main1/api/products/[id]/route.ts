import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError, apiNotFound, apiConflict } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateProductSchema } from '@/lib/validation/schemas';

export async function GET(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, params);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;
    
    const product = await prisma.product.findUnique({
      where: { id }
    });

    if (!product) {
      return apiNotFound('Product');
    }

    return apiSuccess(product);
  } catch (error) {
    console.error('Error fetching product:', error);
    return apiError('Failed to fetch product');
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, params);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;
    
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(updateProductSchema, body);
    if (!validation.success) {
      return validation.error;
    }
    
    const { code } = validation.data as any;

    const existingProduct = await prisma.product.findUnique({
      where: { id }
    });

    if (!existingProduct) {
      return apiNotFound('Product');
    }

    if (code && code !== existingProduct.code) {
      const duplicateCode = await prisma.product.findUnique({
        where: { code }
      });
      if (duplicateCode) {
        return apiConflict('Product with this code already exists');
      }
    }

    const product = await prisma.product.update({
      where: { id },
      data: validation.data as any
    });

    return apiSuccess(product, 'Product updated successfully');
  } catch (error) {
    console.error('Error updating product:', error);
    return apiError('Failed to update product');
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  try {
    // Validate ID parameter
    const idValidation = await validateRequest(idParamSchema, params);
    if (!idValidation.success) {
      return idValidation.error;
    }
    
    const { id } = idValidation.data;
    
    const product = await prisma.product.findUnique({
      where: { id }
    });

    if (!product) {
      return apiNotFound('Product');
    }

    await prisma.product.delete({
      where: { id }
    });

    return apiSuccess(null, 'Product deleted successfully');
  } catch (error) {
    console.error('Error deleting product:', error);
    return apiError('Failed to delete product');
  }
}
