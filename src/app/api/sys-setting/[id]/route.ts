import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiError, apiNotFound, apiSuccess, apiConflict } from '@/lib/api-response';
import { validateRequest } from '@/lib/validation/validate';
import { idParamSchema, updateSysSettingSchema } from '@/lib/validation/schemas';
import { isUniqueViolation } from '@/lib/db-errors';

function parseSettingId(rawId: string) {
  const validation = idParamSchema.safeParse({ id: rawId });
  return validation.success ? validation.data.id : null;
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseSettingId(id);
    if (!numericId) {
      return apiError('Invalid setting ID', 400);
    }

    const result = await pgQuery(
      'SELECT id, sys_name, sys_value, sys_value_detail FROM public.sys_setting WHERE id = $1 LIMIT 1',
      [numericId]
    );
    const setting = result.rows[0];
    if (!setting) {
      return apiNotFound('Setting');
    }

    return apiSuccess(setting);
  } catch (error) {
    console.error('Error fetching system setting:', error);
    return apiError('Failed to fetch system setting');
  }
}

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseSettingId(id);
    if (!numericId) {
      return apiError('Invalid setting ID', 400);
    }

    const body = await request.json();
    const validation = await validateRequest(updateSysSettingSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const sysName = validation.data.sys_name.trim();
    const sysValue = validation.data.sys_value.trim();
    const sysValueDetail = validation.data.sys_value_detail.trim();

    const existing = await pgQuery('SELECT id FROM public.sys_setting WHERE id = $1 LIMIT 1', [numericId]);
    if (existing.rows.length === 0) {
      return apiNotFound('Setting');
    }

    const duplicate = await pgQuery(
      'SELECT id FROM public.sys_setting WHERE sys_name = $1 AND id <> $2 LIMIT 1',
      [sysName, numericId]
    );
    if (duplicate.rows.length > 0) {
      return apiConflict('sys_name นี้มีอยู่แล้ว');
    }

    try {
      const result = await pgQuery(
        `UPDATE public.sys_setting
         SET sys_name = $1,
             sys_value = $2,
             sys_value_detail = $3
         WHERE id = $4
         RETURNING id, sys_name, sys_value, sys_value_detail`,
        [sysName, sysValue, sysValueDetail, numericId]
      );

      return apiSuccess(result.rows[0], 'System setting updated successfully');
    } catch (error) {
      if (isUniqueViolation(error)) {
        return apiConflict('sys_name นี้มีอยู่แล้ว');
      }
      throw error;
    }
  } catch (error) {
    console.error('Error updating system setting:', error);
    return apiError('Failed to update system setting');
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const numericId = parseSettingId(id);
    if (!numericId) {
      return apiError('Invalid setting ID', 400);
    }

    const existing = await pgQuery('SELECT id FROM public.sys_setting WHERE id = $1 LIMIT 1', [numericId]);
    if (existing.rows.length === 0) {
      return apiNotFound('Setting');
    }

    await pgQuery('DELETE FROM public.sys_setting WHERE id = $1', [numericId]);
    return apiSuccess({ id: numericId }, 'System setting deleted successfully');
  } catch (error) {
    console.error('Error deleting system setting:', error);
    return apiError('Failed to delete system setting');
  }
}
