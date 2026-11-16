import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateRequest, validateQuery } from '@/lib/validation/validate';
import { createCategorySchema, categoryQuerySchema } from '@/lib/validation/schemas';
import { runListQuery } from '@/lib/list-query';

// GET /api/categories - Get categories with optional filters and pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(categoryQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { category, type, subtype, include_inactive: includeInactive, page, page_size: pageSize } = queryValidation.data as any;

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

    if (!includeInactive) {
      whereClauses.unshift('is_active = true');
    }
    const list = await runListQuery(
      {
        columns: 'id, category_code, category, type, subtype, is_active',
        from: 'public.category',
        where: whereClauses,
        params,
        orderBy: 'category ASC, type ASC, subtype ASC',
        page,
        pageSize,
        cache: { namespace: 'erp:categories:list', ttlSeconds: 3600, get: cacheGet, set: cacheSet },
      },
      pgQuery
    );
    return apiSuccess(list.rows, undefined, list.totalCount, 200, list.meta);
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
      `INSERT INTO public.category (category_code, category, type, subtype, is_active)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id, category_code, category, type, subtype, is_active`,
      [validation.data.category_code, validation.data.category, validation.data.type, validation.data.subtype, validation.data.is_active ?? true]
    );

    await cacheDelByPattern('erp:categories:list:*');
    await cacheDelByPattern('erp:categories:filters');
    await cacheDelByPattern('erp:usage_plans:filters*');

    return apiSuccess(result.rows[0], 'Category created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating category:', error);
    return apiError('Failed to create category');
  }
}
