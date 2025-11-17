import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { productQuerySchema, createProductSchema } from '@/lib/validation/schemas';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    
    // Validate query parameters
    const queryValidation = validateQuery(productQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }
    
    const { name, category, type, subtype, orderBy, sortOrder, page = 1, pageSize = 20 } = queryValidation.data as any;
    
    // Build where clause
    const where: any = {};
    if (name) {
      where.name = {
        contains: name,
        mode: 'insensitive'
      };
    }
    if (category) where.category = category;
    if (type) where.type = type;
    if (subtype) where.subtype = subtype;
    
    // Build orderBy clause
    let orderByClause: any = { id: 'desc' };
    if (orderBy === 'code') {
      orderByClause = { code: 'asc' };
    } else if (orderBy) {
      orderByClause = { [orderBy]: sortOrder };
    }
    
    const skip = (page - 1) * pageSize;
    
    // Get total count and products in parallel
    const [totalCount, products] = await Promise.all([
      prisma.product.count({ where }),
      prisma.product.findMany({
        where,
        orderBy: orderByClause,
        skip,
        take: pageSize
      })
    ]);
    
    return apiSuccess(products, undefined, totalCount, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching products:', error);
    return apiError('Failed to fetch products');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createProductSchema, body);
    if (!validation.success) {
      return validation.error;
    }
    
    const { code, category, name } = validation.data;

    // Check if product with this code already exists
    const existingProduct = await prisma.product.findUnique({
      where: { code }
    });

    if (existingProduct) {
      return apiConflict('Product with this code already exists');
    }

    const product = await prisma.product.create({
      data: validation.data as any
    });

    return apiSuccess(product, 'Product created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating product:', error);
    return apiError('Failed to create product');
  }
}
