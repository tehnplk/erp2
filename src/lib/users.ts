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
       id::text AS id,
       provider_id,
       name,
       password_hash,
       role,
       department_id,
       is_department_owner
     FROM public.users
     WHERE provider_id = $1
       AND is_active = true
     LIMIT 1`,
    [providerId.trim()]
  );

  return result.rows[0] ?? null;
};

export const touchUserLastLogin = async (userId: string) => {
  await pgQuery('UPDATE public.users SET last_login_at = now() WHERE id = $1', [userId]);
};
