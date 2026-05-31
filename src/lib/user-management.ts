export type ManagedUserRole = 'Admin' | 'Manager' | 'User';

export type UserListRecord = {
  id: string;
  provider_id: string;
  name: string | null;
  role: ManagedUserRole;
  department_id: number | null;
  department_name: string | null;
  department_code: string | null;
  is_department_owner: boolean;
  is_active: boolean;
  last_login_at: string | null;
  created_at: string;
  updated_at: string;
};

export type CreateUserInput = {
  provider_id: string;
  name?: string | null;
  password: string;
  role: ManagedUserRole;
  department_id?: number | null;
  is_department_owner?: boolean;
  is_active?: boolean;
};

export type UpdateUserInput = {
  provider_id: string;
  name?: string | null;
  password?: string | null;
  role: ManagedUserRole;
  department_id?: number | null;
  is_department_owner: boolean;
  is_active: boolean;
};

export type UserQuery = (
  text: string,
  params?: unknown[]
) => Promise<{ rows: any[] }>;

export type CreateUserDependencies = {
  query: UserQuery;
  hashPassword: (password: string) => Promise<string>;
};

export class DuplicateUserProviderIdError extends Error {
  constructor() {
    super('Provider id is already used');
    this.name = 'DuplicateUserProviderIdError';
  }
}

export class UserNotFoundError extends Error {
  constructor() {
    super('User not found');
    this.name = 'UserNotFoundError';
  }
}

const userListSelect = `
  SELECT
    u.id::text AS id,
    u.provider_id,
    u.name,
    ur.role AS role,
    u.department_id,
    d.name AS department_name,
    d.department_code,
    u.is_department_owner,
    u.is_active,
    u.last_login_at::text AS last_login_at,
    u.created_at::text AS created_at,
    u.updated_at::text AS updated_at
  FROM public.users u
  JOIN public.user_role ur ON ur.id = u.user_role_id
  LEFT JOIN public.department d ON d.id = u.department_id
`;

export const listUserRecords = async (query: UserQuery) => {
  const result = await query(
    `${userListSelect}
     ORDER BY u.created_at DESC, u.id DESC`
  );

  return result.rows as UserListRecord[];
};

export const createUserRecord = async (
  input: CreateUserInput,
  dependencies: CreateUserDependencies
) => {
  const providerId = input.provider_id.trim();
  const name = input.name?.trim() || null;
  const hashedPassword = await dependencies.hashPassword(input.password);

  try {
    const result = await dependencies.query(
      `WITH inserted AS (
         INSERT INTO public.users (
           provider_id,
           name,
           password_hash,
           user_role_id,
           department_id,
           is_department_owner,
           is_active
         )
         VALUES (
           $1,
           $2,
           $3,
           (SELECT id FROM public.user_role WHERE role = $4 AND is_active = true LIMIT 1),
           $5,
           $6,
           $7
         )
         RETURNING
           id::text AS id,
           provider_id,
           name,
           user_role_id,
           department_id,
           is_department_owner,
           is_active,
           last_login_at::text AS last_login_at,
           created_at::text AS created_at,
           updated_at::text AS updated_at
       )
       SELECT
         i.id,
         i.provider_id,
         i.name,
         ur.role AS role,
         i.department_id,
         d.name AS department_name,
         d.department_code,
         i.is_department_owner,
         i.is_active,
         i.last_login_at,
         i.created_at,
         i.updated_at
       FROM inserted i
       JOIN public.user_role ur ON ur.id = i.user_role_id
       LEFT JOIN public.department d ON d.id = i.department_id`,
      [
        providerId,
        name,
        hashedPassword,
        input.role,
        input.department_id ?? null,
        input.is_department_owner ?? false,
        input.is_active ?? true,
      ]
    );

    return result.rows[0] as UserListRecord;
  } catch (error: any) {
    if (error?.code === '23505') {
      throw new DuplicateUserProviderIdError();
    }
    throw error;
  }
};

export const updateUserRecord = async (
  userId: string,
  input: UpdateUserInput,
  dependencies: CreateUserDependencies
) => {
  const providerId = input.provider_id.trim();
  const name = input.name?.trim() || null;
  const params: unknown[] = [
    providerId,
    name,
    input.role,
    input.department_id ?? null,
    input.is_department_owner,
    input.is_active,
  ];
  const assignments = [
    'provider_id = $1',
    'name = $2',
    'user_role_id = (SELECT id FROM public.user_role WHERE role = $3 AND is_active = true LIMIT 1)',
    'department_id = $4',
    'is_department_owner = $5',
    'is_active = $6',
  ];

  const nextPassword = input.password?.trim();
  if (nextPassword) {
    params.push(await dependencies.hashPassword(nextPassword));
    assignments.push(`password_hash = $${params.length}`);
  }

  params.push(userId);
  const idParam = params.length;

  try {
    const result = await dependencies.query(
      `WITH updated AS (
         UPDATE public.users
         SET ${assignments.join(', ')}
         WHERE id = $${idParam}
         RETURNING
           id::text AS id,
           provider_id,
           name,
           user_role_id,
           department_id,
           is_department_owner,
           is_active,
           last_login_at::text AS last_login_at,
           created_at::text AS created_at,
           updated_at::text AS updated_at
       )
       SELECT
         u.id,
         u.provider_id,
         u.name,
         ur.role AS role,
         u.department_id,
         d.name AS department_name,
         d.department_code,
         u.is_department_owner,
         u.is_active,
         u.last_login_at,
         u.created_at,
         u.updated_at
       FROM updated u
       JOIN public.user_role ur ON ur.id = u.user_role_id
       LEFT JOIN public.department d ON d.id = u.department_id`,
      params
    );

    if (!result.rows[0]) {
      throw new UserNotFoundError();
    }

    return result.rows[0] as UserListRecord;
  } catch (error: any) {
    if (error?.code === '23505') {
      throw new DuplicateUserProviderIdError();
    }
    throw error;
  }
};

export const deleteUserRecord = async (userId: string, query: UserQuery) => {
  const result = await query(
    `DELETE FROM public.users
     WHERE id = $1
     RETURNING id::text AS id`,
    [userId]
  );

  if (!result.rows[0]) {
    throw new UserNotFoundError();
  }

  return result.rows[0] as { id: string };
};
