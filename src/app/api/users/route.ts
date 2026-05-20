import { auth } from '@/auth';
import { apiConflict, apiError, apiForbidden, apiSuccess, apiUnauthorized } from '@/lib/api-response';
import { pgQuery } from '@/lib/pg';
import { DuplicateUserEmailError, createUserRecord, listUserRecords } from '@/lib/user-management';
import { hashPassword } from '@/lib/password';
import { validateRequest } from '@/lib/validation/validate';
import { createUserSchema } from '@/lib/validation/schemas';

export const runtime = 'nodejs';

const requireAdmin = async () => {
  const session = await auth();

  if (!session?.user) {
    return { response: apiUnauthorized('Login required') };
  }

  if (session.user.role !== 'Admin') {
    return { response: apiForbidden('Admin role required') };
  }

  return { session };
};

export async function GET() {
  const admin = await requireAdmin();
  if ('response' in admin) return admin.response;

  try {
    const users = await listUserRecords(pgQuery);
    return apiSuccess(users, undefined, users.length);
  } catch (error) {
    console.error('Error fetching users:', error);
    return apiError('Failed to fetch users');
  }
}

export async function POST(request: Request) {
  const admin = await requireAdmin();
  if ('response' in admin) return admin.response;

  try {
    const body = await request.json();
    const validation = await validateRequest(createUserSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const user = await createUserRecord(validation.data, {
      query: pgQuery,
      hashPassword,
    });

    return apiSuccess(user, 'User created successfully', undefined, 201);
  } catch (error) {
    if (error instanceof DuplicateUserEmailError) {
      return apiConflict('Email is already used');
    }

    console.error('Error creating user:', error);
    return apiError('Failed to create user');
  }
}
