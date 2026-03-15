import { pgQuery } from '@/lib/pg';

export async function findDepartmentCodeByName(name?: string | null) {
  const normalizedName = name?.trim();
  if (!normalizedName) {
    return null;
  }

  const result = await pgQuery<{ department_code: string | null }>(
    'SELECT department_code FROM public.department WHERE name = $1 AND is_active = true LIMIT 1',
    [normalizedName]
  );

  return result.rows[0]?.department_code ?? null;
}
