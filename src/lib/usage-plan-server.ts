import { auth } from '@/auth';
import { canActOnDepartment, type DepartmentScopedUser } from '@/lib/access-control';
import { apiForbidden, apiUnauthorized } from '@/lib/api-response';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';

export async function requireUsagePlanActor() {
  const session = await auth();
  if (!session?.user) {
    return { response: apiUnauthorized('Login required') };
  }

  const { role, departmentId } = session.user;
  let departmentCode: string | null = null;
  if (departmentId) {
    const result = await pgQuery<{ department_code: string | null }>(
      'SELECT department_code FROM public.department WHERE id = $1 LIMIT 1',
      [departmentId]
    );
    departmentCode = result.rows[0]?.department_code ?? null;
  }

  return { actor: { role, departmentCode } satisfies DepartmentScopedUser };
}

export const forbidOtherDepartment = (
  actor: DepartmentScopedUser,
  ...departmentCodes: Array<string | null | undefined>
) =>
  departmentCodes.every((code) => canActOnDepartment(actor, code))
    ? null
    : apiForbidden('ไม่มีสิทธิ์จัดการแผนการใช้ของหน่วยงานอื่น');

export const invalidateUsagePlanCaches = () =>
  Promise.all([
    cacheDelByPattern('erp:purchase:plans:list:*'),
    cacheDelByPattern('erp:purchase:plans:filters*'),
    cacheDelByPattern('erp:purchase:approvals:list:*'),
    cacheDelByPattern('erp:purchase:approvals:filters*'),
    cacheDelByPattern('erp:usage_plans:filters*'),
  ]);
