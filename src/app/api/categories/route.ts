import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
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

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (category) {
      params.push(`%${category}%`);
      whereClauses.push(`category ILIKE $${params.length}`);
    }
    if (type) {
      params.push(`%${type}%`);
      whereClauses.push(`type ILIKE $${params.length}`);
    }
    if (subtype) {
      params.push(`%${subtype}%`);
      whereClauses.push(`subtype ILIKE $${params.length}`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const baseSelect = 'SELECT id, category, type, subtype FROM public."Category"';

    if (!page || !pageSize) {
      const categoriesResult = await pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC`, params);
      return apiSuccess(categoriesResult.rows, undefined, categoriesResult.rows.length);
    }

    const skip = (page - 1) * pageSize;

    const [totalCountResult, categoriesResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."Category" ${whereSql}`, params),
      pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, skip]),
    ]);

    return apiSuccess(categoriesResult.rows, undefined, totalCountResult.rows[0]?.count || 0, 200, { page, pageSize });
  } catch (error) {
    console.error('Error fetching categories:', error);
    return apiError('Failed to fetch categories');
  }
}

// POST /api/categories - Create new category
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const validation = await validateRequest(createCategorySchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const result = await pgQuery(
      `INSERT INTO public."Category" (category, type, subtype)
       VALUES ($1, $2, $3)
       RETURNING id, category, type, subtype`,
      [validation.data.category, validation.data.type, validation.data.subtype]
    );

    return apiSuccess(result.rows[0], 'Category created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating category:', error);
    return apiError('Failed to create category');
  }
}
