import { pgQuery } from '@/lib/pg';
import type { UserRole } from '@/lib/access-control';

export type AuthUserRecord = {
  id: string;
  provider_id: string;
  name: string | null;
  password_hash: string;
  role: UserRole;
  department_id: number | null;
  is_department_owner: boolean;
};

export const getActiveUserByProviderId = async (providerId: string) => {
  const result = await pgQuery<AuthUserRecord>(
    `SELECT
       u.id::text AS id,
       u.provider_id,
       u.name,
       u.password_hash,
       ur.role AS role,
       u.department_id,
       u.is_department_owner
     FROM public.users u
     JOIN public.user_role ur ON ur.id = u.user_role_id
     WHERE u.provider_id = $1
       AND u.is_active = true
     LIMIT 1`,
    [providerId.trim()]
  );

  return result.rows[0] ?? null;
};

export const touchUserLastLogin = async (userId: string) => {
  await pgQuery('UPDATE public.users SET last_login_at = now() WHERE id = $1', [userId]);
};
