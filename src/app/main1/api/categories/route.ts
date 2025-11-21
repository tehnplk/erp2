import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError } from '@/lib/api-response';
import { validateRequest, validateQuery } from '@/lib/validation/validate';
import { createCategorySchema, categoryQuerySchema } from '@/lib/validation/schemas';

// GET /api/categories - Get categories with optional filters and pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(categoryQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { category, type, subtype, page, pageSize } = queryValidation.data as any;

    const where: any = {};
    if (category) where.category = { contains: category, mode: 'insensitive' };
    if (type) where.type = { contains: type, mode: 'insensitive' };
    if (subtype) where.subtype = { contains: subtype, mode: 'insensitive' };

    // If no pagination params, return all categories (backwards compatible)
    if (!page || !pageSize) {
      const categories = await prisma.category.findMany({
        where,
        orderBy: { id: 'asc' }
      });
      return apiSuccess(categories, undefined, categories.length);
    }

    const skip = (page - 1) * pageSize;

    const [totalCount, categories] = await Promise.all([
      prisma.category.count({ where }),
      prisma.category.findMany({
        where,
        orderBy: { id: 'asc' },
        skip,
        take: pageSize
      })
    ]);
    
    return apiSuccess(categories, undefined, totalCount, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching categories:', error);
    return apiError('Failed to fetch categories');
  }
}

// POST /api/categories - Create new category
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createCategorySchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const newCategory = await prisma.category.create({
      data: validation.data as any
    });

    return apiSuccess(newCategory, 'Category created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating category:', error);
    return apiError('Failed to create category');
  }
}
