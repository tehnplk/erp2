import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
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

    const { name, page, pageSize } = queryValidation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];
    if (name) {
      params.push(`%${name}%`);
      whereClauses.push(`name ILIKE $${params.length}`);
    }

    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const baseSelect = 'SELECT id, name FROM public."Department"';

    if (!page || !pageSize) {
      const result = await pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC`, params);
      return apiSuccess(result.rows, undefined, result.rows.length);
    }

    const skip = (page - 1) * pageSize;

    const [countResult, result] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public."Department" ${whereSql}`, params),
      pgQuery(`${baseSelect} ${whereSql} ORDER BY id ASC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`, [...params, pageSize, skip]),
    ]);
    
    return apiSuccess(result.rows, undefined, countResult.rows[0]?.count || 0, 200, { page, pageSize });
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

    const result = await pgQuery(
      `INSERT INTO public."Department" (name)
       VALUES ($1)
       RETURNING id, name`,
      [validation.data.name]
    );

    return apiSuccess(result.rows[0], 'Department created successfully', undefined, 201);
  } catch (error) {
    console.error('Error creating department:', error);
    return apiError('Failed to create department');
  }
}
