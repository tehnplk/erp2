import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateRequest, validateQuery } from '@/lib/validation/validate';
import { createDepartmentSchema, departmentQuerySchema } from '@/lib/validation/schemas';

// GET /api/departments - Get departments with optional filters and pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(departmentQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { name, department_code: departmentCode, page, page_size: pageSize } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];
    if (name) {
      params.push(`%${name}%`);
      whereClauses.push(`name ILIKE $${params.length}`);
    }

    if (departmentCode) {
      params.push(`%${departmentCode}%`);
      whereClauses.push(`department_code ILIKE $${params.length}`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const baseSelect = 'SELECT id, name, department_code FROM public.department';

    const cacheKeyAll = `erp:departments:list:all:${JSON.stringify(params)}`;
    if (!page || !pageSize) {
      const cachedAll = await cacheGet<any>(cacheKeyAll);
      if (cachedAll) return apiSuccess(cachedAll.rows, undefined, cachedAll.rows.length);

      const result = await pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC`, params);
      await cacheSet(cacheKeyAll, { rows: result.rows }, 3600);
      return apiSuccess(result.rows, undefined, result.rows.length);
    }

    const skip = (page - 1) * pageSize;

    // --- Redis Caching Logic (Paginated) ---
    const cacheKey = `erp:departments:list:${JSON.stringify({ ...queryValidation.data, page, page_size: pageSize })}`;
    const cached = await cacheGet<any>(cacheKey);
    if (cached) {
      return apiSuccess(cached.items, undefined, cached.totalCount, 200, { page, page_size: pageSize });
    }

    const [countResult, result] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.department ${whereSql}`, params),
      pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, skip]),
    ]);
    
    const finalResult = {
      items: result.rows,
      totalCount: countResult.rows[0]?.count || 0
    };

    await cacheSet(cacheKey, finalResult, 3600);

    return apiSuccess(finalResult.items, undefined, finalResult.totalCount, 200, { page, page_size: pageSize });
  } catch (error) {
    console.error('Error fetching departments:', error);
    return apiError('Failed to fetch departments');
  }
}

// POST /api/departments - Create a new department
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    // Validate request body
    const validation = await validateRequest(createDepartmentSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    try {
      const result = await pgQuery(
        `INSERT INTO public.department (name, department_code)
         VALUES ($1, $2)
         RETURNING id, name, department_code`,
        [validation.data.name.trim(), validation.data.department_code.trim()]
      );

      await cacheDelByPattern('erp:departments:list:*');

      return apiSuccess(result.rows[0], 'Department created successfully', undefined, 201);
    } catch (error: any) {
      if (error?.code === '23505') {
        return apiError('รหัสแผนกนี้ถูกใช้งานแล้ว', 409);
      }
      throw error;
    }
  } catch (error) {
    console.error('Error creating department:', error);
    return apiError('Failed to create department');
  }
}
