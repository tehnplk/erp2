import { auth } from '@/auth';
import { apiConflict, apiError, apiForbidden, apiNotFound, apiSuccess, apiUnauthorized } from '@/lib/api-response';
import { hashPassword } from '@/lib/password';
import { pgQuery } from '@/lib/pg';
import { DuplicateUserProviderIdError, UserNotFoundError, deleteUserRecord, updateUserRecord } from '@/lib/user-management';
import { updateUserSchema } from '@/lib/validation/schemas';
import { validateRequest } from '@/lib/validation/validate';

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

export async function PATCH(request: Request, context: { params: Promise<{ id: string }> }) {
  const admin = await requireAdmin();
  if ('response' in admin) return admin.response;

  try {
    const { id } = await context.params;
    const body = await request.json();
    const validation = await validateRequest(updateUserSchema, body);
    if (!validation.success) {
      return validation.error;
    }

    const user = await updateUserRecord(id, validation.data, {
      query: pgQuery,
      hashPassword,
    });

    return apiSuccess(user, 'User updated successfully');
  } catch (error) {
    if (error instanceof DuplicateUserProviderIdError) {
      return apiConflict('Username is already used');
    }

    if (error instanceof UserNotFoundError) {
      return apiNotFound('User');
    }

    console.error('Error updating user:', error);
    return apiError('Failed to update user');
  }
}

export async function DELETE(_request: Request, context: { params: Promise<{ id: string }> }) {
  const admin = await requireAdmin();
  if ('response' in admin) return admin.response;

  try {
    const { id } = await context.params;
    const user = await deleteUserRecord(id, pgQuery);

    return apiSuccess(user, 'User deleted successfully');
  } catch (error) {
    if (error instanceof UserNotFoundError) {
      return apiNotFound('User');
    }

    console.error('Error deleting user:', error);
    return apiError('Failed to delete user');
  }
}
