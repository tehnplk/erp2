'use client';

import { useActionState } from 'react';
import { LockKeyhole, User } from 'lucide-react';
import { signInWithCredentials, type LoginActionState } from './actions';

const initialState: LoginActionState = {
  error: '',
};

type LoginFormProps = {
  redirectTo: string;
};

export default function LoginForm({ redirectTo }: LoginFormProps) {
  const [state, formAction, isPending] = useActionState(signInWithCredentials, initialState);

  return (
    <main className="flex min-h-[calc(100vh-52px)] items-center justify-center bg-slate-100 px-4 py-10">
      <section className="w-full max-w-sm rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
        <div className="mb-6">
          <h1 className="text-xl font-semibold text-slate-950">เข้าสู่ระบบ</h1>
          <p className="mt-1 text-sm text-slate-500">Hospital ERP</p>
        </div>

        <form action={formAction} className="space-y-4">
          <input type="hidden" name="redirectTo" value={redirectTo} />

          <label className="block">
            <span className="mb-1 block text-sm font-medium text-slate-700">ชื่อผู้ใช้</span>
            <span className="flex items-center rounded-md border border-slate-300 bg-white px-3 focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-100">
              <User className="mr-2 h-4 w-4 text-slate-400" />
              <input
                name="providerId"
                type="text"
                autoComplete="username"
                required
                disabled={isPending}
                className="h-10 min-w-0 flex-1 border-0 bg-transparent text-sm text-slate-950 outline-none disabled:text-slate-500"
              />
            </span>
          </label>

          <label className="block">
            <span className="mb-1 block text-sm font-medium text-slate-700">รหัสผ่าน</span>
            <span className="flex items-center rounded-md border border-slate-300 bg-white px-3 focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-100">
              <LockKeyhole className="mr-2 h-4 w-4 text-slate-400" />
              <input
                name="password"
                type="password"
                autoComplete="current-password"
                required
                disabled={isPending}
                className="h-10 min-w-0 flex-1 border-0 bg-transparent text-sm text-slate-950 outline-none disabled:text-slate-500"
              />
            </span>
          </label>

          {state.error ? <p className="text-sm text-red-600">{state.error}</p> : null}

          <button
            type="submit"
            disabled={isPending}
            className="flex h-10 w-full items-center justify-center rounded-md bg-blue-600 px-4 text-sm font-medium text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
          >
            {isPending ? 'กำลังเข้าสู่ระบบ...' : 'เข้าสู่ระบบ'}
          </button>
        </form>
      </section>
    </main>
  );
}
