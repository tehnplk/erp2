'use server';

import { AuthError } from 'next-auth';
import { signIn } from '@/auth';
import { sanitizeRedirectPath } from './redirect';

export type LoginActionState = {
  error: string;
};

export async function signInWithCredentials(
  _previousState: LoginActionState,
  formData: FormData
): Promise<LoginActionState> {
  const providerId = String(formData.get('providerId') ?? '').trim();
  const password = String(formData.get('password') ?? '');
  const redirectTo = sanitizeRedirectPath(formData.get('redirectTo'));

  if (!providerId || !password) {
    return { error: 'กรุณากรอกชื่อผู้ใช้และรหัสผ่าน' };
  }

  try {
    await signIn('credentials', {
      providerId,
      password,
      redirectTo,
    });
  } catch (error) {
    if (error instanceof AuthError) {
      return { error: 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง' };
    }

    throw error;
  }

  return { error: '' };
}
