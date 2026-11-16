import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheGet, cacheSet, cacheDelByPattern } from '@/lib/redis';
import { validateRequest, validateQuery } from '@/lib/validation/validate';
import { createDepartmentSchema, departmentQuerySchema } from '@/lib/validation/schemas';
import { runListQuery } from '@/lib/list-query';
import { isUniqueViolation } from '@/lib/db-errors';

// GET /api/departments - Get departments with optional filters and pagination
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);

    const queryValidation = validateQuery(departmentQuerySchema, searchParams);
    if (!queryValidation.success) {
      return queryValidation.error;
    }

    const { name, department_code: departmentCode, include_inactive: includeInactive, page, page_size: pageSize } = queryValidation.data as any;

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

    if (!includeInactive) {
      whereClauses.unshift('is_active = true');
    }
    const list = await runListQuery(
      {
        columns: 'id, name, department_code, is_active',
        from: 'public.department',
        where: whereClauses,
        params,
        orderBy: 'id ASC',
        page,
        pageSize,
        cache: { namespace: 'erp:departments:list', ttlSeconds: 3600, get: cacheGet, set: cacheSet },
      },
      pgQuery
    );
    return apiSuccess(list.rows, undefined, list.totalCount, 200, list.meta);
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
        `INSERT INTO public.department (name, department_code, is_active)
         VALUES ($1, $2, $3)
         RETURNING id, name, department_code, is_active`,
        [validation.data.name.trim(), validation.data.department_code.trim(), validation.data.is_active ?? true]
      );

      await cacheDelByPattern('erp:departments:list:*');

      return apiSuccess(result.rows[0], 'Department created successfully', undefined, 201);
    } catch (error) {
      if (isUniqueViolation(error)) {
        return apiError('รหัสแผนกนี้ถูกใช้งานแล้ว', 409);
      }
      throw error;
    }
  } catch (error) {
    console.error('Error creating department:', error);
    return apiError('Failed to create department');
  }
}
