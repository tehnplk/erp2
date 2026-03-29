import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { createSysSettingSchema, sysSettingQuerySchema } from '@/lib/validation/schemas';
import { isUniqueViolation } from '@/lib/db-errors';

const sysSettingSelect = `
  SELECT id, sys_name, sys_value, sys_value_detail
  FROM public.sys_setting
`;

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const validation = validateQuery(sysSettingQuerySchema, searchParams);
    if (!validation.success) {
      return validation.error;
    }

    const {
      search,
      order_by: orderBy = 'id',
      sort_order: sortOrder = 'asc',
      page = 1,
      page_size: pageSize = 20,
    } = validation.data as any;

    const whereClauses: string[] = [];
    const params: unknown[] = [];

    if (search?.trim()) {
      params.push(`%${search.trim()}%`);
      const paramIndex = params.length;
      whereClauses.push(`(
        id::text ILIKE $${paramIndex}
        OR sys_name ILIKE $${paramIndex}
        OR sys_value ILIKE $${paramIndex}
        OR sys_value_detail ILIKE $${paramIndex}
      )`);
    }

    const allowedOrderFields: Record<string, string> = {
      id: 'id',
      sys_name: 'sys_name',
      sys_value: 'sys_value',
      sys_value_detail: 'sys_value_detail',
    };
    const safeOrderField = allowedOrderFields[orderBy] || 'id';
    const safeSortOrder = sortOrder === 'desc' ? 'DESC' : 'ASC';
    const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(' AND ')}` : '';
    const skip = (page - 1) * pageSize;

    const [countResult, settingsResult] = await Promise.all([
      pgQuery(`SELECT COUNT(*)::int AS count FROM public.sys_setting ${whereSql}`, params),
      pgQuery(
        `${sysSettingSelect} ${whereSql} ORDER BY ${safeOrderField} ${safeSortOrder} LIMIT $${params.length + 1} OFFSET $${params.length + 2}`,
        [...params, pageSize, skip]
      ),
    ]);

    return apiSuccess(
      settingsResult.rows,
      undefined,
      countResult.rows[0]?.count ?? 0,
      200,
      { page, page_size: pageSize }
    );
  } catch (error) {
    console.error('Error fetching system settings:', error);
    return apiError('Failed to fetch system settings');
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validation = await validateRequest(createSysSettingSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const sysName = validation.data.sys_name.trim();
    const sysValue = validation.data.sys_value.trim();
    const sysValueDetail = validation.data.sys_value_detail.trim();

    const existing = await pgQuery('SELECT id FROM public.sys_setting WHERE sys_name = $1 LIMIT 1', [sysName]);
    if (existing.rows.length > 0) {
      return apiConflict('sys_name นี้มีอยู่แล้ว');
    }

    const nextIdResult = await pgQuery('SELECT COALESCE(MAX(id), 0) + 1 AS next_id FROM public.sys_setting');
    const nextId = Number(nextIdResult.rows[0]?.next_id ?? 1);

    try {
      const result = await pgQuery(
        `INSERT INTO public.sys_setting (id, sys_name, sys_value, sys_value_detail)
         VALUES ($1, $2, $3, $4)
         RETURNING id, sys_name, sys_value, sys_value_detail`,
        [nextId, sysName, sysValue, sysValueDetail]
      );

      return apiSuccess(result.rows[0], 'System setting created successfully', undefined, 201);
    } catch (error) {
      if (isUniqueViolation(error)) {
        return apiConflict('sys_name นี้มีอยู่แล้ว');
      }
      throw error;
    }
  } catch (error) {
    console.error('Error creating system setting:', error);
    return apiError('Failed to create system setting');
  }
}
