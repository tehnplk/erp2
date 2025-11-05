import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiSuccess, apiError } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { createCategorySchema } from '@/lib/validation/schemas';

// GET /api/categories - Get all categories
export async function GET() {
  try {
    const categories = await prisma.category.findMany({
      orderBy: { id: 'asc' }
    });
    
    return apiSuccess(categories, undefined, categories.length);
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
