import { auth } from '@/auth';
import { redirect } from 'next/navigation';
import LoginForm from './login-form';
import { sanitizeRedirectPath } from './redirect';

type LoginPageProps = {
  searchParams?: Promise<Record<string, string | string[] | undefined>>;
};

const firstParam = (value: string | string[] | undefined) => (Array.isArray(value) ? value[0] : value);

export default async function LoginPage({ searchParams }: LoginPageProps) {
  const params = searchParams ? await searchParams : {};
  const redirectTo = sanitizeRedirectPath(firstParam(params.callbackUrl));
  const session = await auth();

  if (session?.user) {
    redirect(redirectTo);
  }

  return <LoginForm redirectTo={redirectTo} />;
}
