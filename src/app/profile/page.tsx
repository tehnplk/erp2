import { auth } from '@/auth';

export default async function ProfilePage() {
  const session = await auth();
  const user = session?.user;

  return (
    <main className="min-h-screen bg-slate-50 px-4 py-10 text-slate-900">
      <div className="mx-auto max-w-3xl">
        <div className="mb-6 border-b border-slate-200 pb-5">
          <h1 className="text-2xl font-semibold text-slate-950">โปรไฟล์</h1>
        </div>

        <section className="rounded-md border border-slate-200 bg-white">
          <dl className="divide-y divide-slate-100">
            <div className="grid gap-1 px-5 py-4 sm:grid-cols-3">
              <dt className="text-sm font-medium text-slate-500">ชื่อ</dt>
              <dd className="text-sm text-slate-950 sm:col-span-2">{user?.name || '-'}</dd>
            </div>
            <div className="grid gap-1 px-5 py-4 sm:grid-cols-3">
              <dt className="text-sm font-medium text-slate-500">ชื่อผู้ใช้</dt>
              <dd className="text-sm text-slate-950 sm:col-span-2">{user?.email || '-'}</dd>
            </div>
            <div className="grid gap-1 px-5 py-4 sm:grid-cols-3">
              <dt className="text-sm font-medium text-slate-500">บทบาท</dt>
              <dd className="text-sm text-slate-950 sm:col-span-2">{user?.role || '-'}</dd>
            </div>
            <div className="grid gap-1 px-5 py-4 sm:grid-cols-3">
              <dt className="text-sm font-medium text-slate-500">รหัสแผนก</dt>
              <dd className="text-sm text-slate-950 sm:col-span-2">{user?.departmentId ?? '-'}</dd>
            </div>
          </dl>
        </section>
      </div>
    </main>
  );
}
