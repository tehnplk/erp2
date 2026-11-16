import { NextRequest } from 'next/server';
import { pgPool, pgQuery } from '@/lib/pg';
import { apiSuccess, apiError, apiConflict } from '@/lib/api-response';
import { validateQuery, validateRequest } from '@/lib/validation/validate';
import { createSysSettingSchema, sysSettingQuerySchema } from '@/lib/validation/schemas';
import { isUniqueViolation } from '@/lib/db-errors';
import { runListQuery } from '@/lib/list-query';

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
        OR COALESCE(note, '') ILIKE $${paramIndex}
      )`);
    }

    const list = await runListQuery(
      {
        columns: 'id, sys_name, sys_value, sys_value_detail, note',
        from: 'public.sys_setting',
        where: whereClauses,
        params,
        orderBy: {
          key: orderBy,
          allowed: ['id', 'sys_name', 'sys_value', 'sys_value_detail', 'note'],
          fallback: 'id',
          direction: sortOrder === 'desc' ? 'DESC' : 'ASC',
        },
        page,
        pageSize,
      },
      pgQuery
    );
    return apiSuccess(list.rows, undefined, list.totalCount, 200, list.meta);
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
    const note = validation.data.note?.trim() || null;

    const existing = await pgQuery('SELECT id FROM public.sys_setting WHERE sys_name = $1 LIMIT 1', [sysName]);
    if (existing.rows.length > 0) {
      return apiConflict('sys_name นี้มีอยู่แล้ว');
    }

    const client = await pgPool.connect();
    try {
      await client.query('BEGIN');
      // sys_setting.id has no default; the lock serialises MAX(id)+1 across concurrent inserts.
      await client.query(`SELECT pg_advisory_xact_lock(hashtext('public.sys_setting.id'))`);
      const result = await client.query(
        `INSERT INTO public.sys_setting (id, sys_name, sys_value, sys_value_detail, note)
         SELECT COALESCE(MAX(id), 0) + 1, $1, $2, $3, $4 FROM public.sys_setting
         RETURNING id, sys_name, sys_value, sys_value_detail, note`,
        [sysName, sysValue, sysValueDetail, note]
      );
      await client.query('COMMIT');

      return apiSuccess(result.rows[0], 'System setting created successfully', undefined, 201);
    } catch (error) {
      await client.query('ROLLBACK');
      if (isUniqueViolation(error) && (error as { constraint?: string }).constraint === 'sys_setting_sys_name_key') {
        return apiConflict('sys_name นี้มีอยู่แล้ว');
      }
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Error creating system setting:', error);
    return apiError('Failed to create system setting');
  }
}
