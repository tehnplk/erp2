import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
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
    const cacheKeyAll = `erp:categories:list:all:${JSON.stringify(params)}`;
    if (!page || !pageSize) {
      const cachedAll = await cacheGet<any>(cacheKeyAll);
      if (cachedAll) return apiSuccess(cachedAll.rows, undefined, cachedAll.rows.length);

      const categoriesResult = await pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC`, params);
      await cacheSet(cacheKeyAll, { rows: categoriesResult.rows }, 3600);
      return apiSuccess(categoriesResult.rows, undefined, categoriesResult.rows.length);
    }

    const skip = (page - 1) * pageSize;

    // --- Redis Caching Logic ---
    const cacheKey = `erp:categories:list:${JSON.stringify({ ...queryValidation.data, page, pageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, pageSize });
    }

    const [totalCountResult, categoriesResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."Category" ${whereSql}`, params),
      pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, skip]),
    ]);

    const result = {
      items: categoriesResult.rows,
      totalCount: totalCountResult.rows[0]?.count || 0
    };

    await cacheSet(cacheKey, result, 3600); // 1 hour

    return apiSuccess(result.items, undefined, result.totalCount, 200, { page, pageSize });
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

    await cacheDelByPattern('erp:categories:list:*');

    return apiSuccess(result.rows[0], 'Category created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating category:', error);
    return apiError('Failed to create category');
  }
}
