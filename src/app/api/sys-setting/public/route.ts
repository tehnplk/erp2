import { pgQuery } from '@/lib/pg';
import { apiError, apiSuccess } from '@/lib/api-response';

type SysSettingRow = {
  id: number;
  sys_name: string;
  sys_value: string;
  sys_value_detail: string;
};

export async function GET() {
  try {
    const result = await pgQuery<SysSettingRow>(
      `SELECT id, sys_name, sys_value, sys_value_detail
       FROM public.sys_setting
       ORDER BY id ASC`
    );

    const items = result.rows.map((row) => ({
      id: row.id,
      sys_name: row.sys_name,
      sys_value: row.sys_value,
      sys_value_detail: row.sys_value_detail,
    }));

    const byName = Object.fromEntries(
      items.map((item) => [
        item.sys_name,
        {
          sys_value: item.sys_value,
          sys_value_detail: item.sys_value_detail,
        },
      ])
    );

    return apiSuccess({
      items,
      by_name: byName,
    });
  } catch (error) {
    console.error('Error fetching public system settings:', error);
    return apiError('Failed to fetch public system settings');
  }
}
