import { auth } from '@/auth';
import UsersAdminClient from './users-admin-client';

export default async function UsersPage() {
  const session = await auth();

  if (session?.user?.role !== 'Admin') {
    return (
      <main className="min-h-screen bg-slate-50 px-4 py-10 text-slate-900">
        <div className="mx-auto max-w-2xl rounded-md border border-red-200 bg-white p-6">
          <p className="text-sm font-semibold uppercase text-red-600">ไม่มีสิทธิ์เข้าถึง</p>
          <h1 className="mt-2 text-2xl font-semibold text-slate-950">ต้องใช้สิทธิ์ผู้ดูแลระบบ</h1>
        </div>
      </main>
    );
  }

  return <UsersAdminClient />;
}
