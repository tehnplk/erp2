'use client';

import { useEffect, useMemo, useState } from 'react';
import { Pencil, RefreshCw, ShieldCheck, UserPlus, Users, X } from 'lucide-react';

type Role = 'Admin' | 'Manager' | 'User';

type ManagedUser = {
  id: string;
  provider_id: string;
  name: string | null;
  role: Role;
  department_id: number | null;
  department_name: string | null;
  department_code: string | null;
  is_department_owner: boolean;
  is_active: boolean;
  last_login_at: string | null;
  created_at: string;
};

type Department = {
  id: number;
  name: string;
  department_code?: string | null;
};

type UserForm = {
  provider_id: string;
  name: string;
  password: string;
  role: Role;
  department_id: string;
  is_active: boolean;
};

const initialForm: UserForm = {
  provider_id: '',
  name: '',
  password: '',
  role: 'User',
  department_id: '',
  is_active: true,
};

const formatDate = (value: string | null) => {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '-';
  return new Intl.DateTimeFormat('th-TH', {
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(date);
};

const roleLabel = (role: Role) => {
  if (role === 'Admin') return 'ผู้ดูแลระบบ';
  if (role === 'Manager') return 'ผู้จัดการ';
  return 'ผู้ใช้งาน';
};

export default function UsersAdminClient() {
  const [users, setUsers] = useState<ManagedUser[]>([]);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [form, setForm] = useState<UserForm>(initialForm);
  const [editingUser, setEditingUser] = useState<ManagedUser | null>(null);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  const activeCount = useMemo(() => users.filter((user) => user?.is_active).length, [users]);
  const adminCount = useMemo(() => users.filter((user) => user?.role === 'Admin').length, [users]);

  const loadData = async () => {
    setLoading(true);
    setMessage(null);

    try {
      const [usersResponse, departmentsResponse] = await Promise.all([
        fetch('/api/users', { cache: 'no-store' }),
        fetch('/api/departments', { cache: 'no-store' }),
      ]);

      const usersPayload = await usersResponse.json();
      const departmentsPayload = await departmentsResponse.json();

      if (!usersResponse.ok || !usersPayload.success) {
        throw new Error(usersPayload.error || 'Failed to load users');
      }

      setUsers((usersPayload.data || []).filter(Boolean));
      setDepartments(departmentsPayload.data || []);
    } catch (error: any) {
      setMessage({ type: 'error', text: error?.message || 'โหลดข้อมูลผู้ใช้งานไม่สำเร็จ' });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const updateForm = (field: keyof UserForm, value: string | boolean) => {
    setForm((current) => ({ ...current, [field]: value }));
  };

  const openCreateModal = () => {
    setEditingUser(null);
    setForm(initialForm);
    setMessage(null);
    setIsModalOpen(true);
  };

  const openEditModal = (user: ManagedUser) => {
    setEditingUser(user);
    setForm({
      provider_id: user.provider_id,
      name: user.name || '',
      password: '',
      role: user.role,
      department_id: user.department_id ? String(user.department_id) : '',
      is_active: user.is_active,
    });
    setMessage(null);
    setIsModalOpen(true);
  };

  const closeModal = () => {
    if (saving) return;
    setIsModalOpen(false);
    setEditingUser(null);
    setForm(initialForm);
  };

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setSaving(true);
    setMessage(null);

    const body = {
      provider_id: form.provider_id,
      name: form.name || null,
      ...(editingUser && !form.password ? {} : { password: form.password }),
      role: form.role,
      department_id: form.department_id ? Number(form.department_id) : null,
      is_department_owner: false,
      is_active: form.is_active,
    };

    try {
      const response = await fetch(editingUser ? `/api/users/${editingUser.id}` : '/api/users', {
        method: editingUser ? 'PATCH' : 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });
      const payload = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'บันทึกผู้ใช้งานไม่สำเร็จ');
      }

      if (!payload.data) {
        await loadData();
      } else if (editingUser) {
        setUsers((current) => current.map((user) => (user.id === payload.data.id ? payload.data : user)));
      } else {
        setUsers((current) => [payload.data, ...current.filter(Boolean)]);
      }

      closeModal();
      setMessage({ type: 'success', text: editingUser ? 'บันทึกการแก้ไขผู้ใช้แล้ว' : 'สร้างผู้ใช้แล้ว' });
    } catch (error: any) {
      setMessage({ type: 'error', text: error?.message || 'บันทึกผู้ใช้งานไม่สำเร็จ' });
    } finally {
      setSaving(false);
    }
  };

  return (
    <main className="min-h-screen bg-slate-50 text-slate-900">
      <div className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
        <div className="mb-6 flex flex-col gap-4 border-b border-slate-200 pb-5 lg:flex-row lg:items-end lg:justify-between">
          <div>
            <div className="mb-2 inline-flex items-center gap-2 rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold text-blue-700">
              <ShieldCheck className="h-3.5 w-3.5" />
              ผู้ดูแลระบบ
            </div>
            <h1 className="text-2xl font-semibold tracking-normal text-slate-950">จัดการผู้ใช้งาน</h1>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            <div className="rounded-md border border-slate-200 bg-white px-4 py-3">
              <div className="text-xs font-medium uppercase text-slate-500">ใช้งาน</div>
              <div className="text-xl font-semibold text-slate-950">{activeCount}</div>
            </div>
            <div className="rounded-md border border-slate-200 bg-white px-4 py-3">
              <div className="text-xs font-medium uppercase text-slate-500">ผู้ดูแล</div>
              <div className="text-xl font-semibold text-slate-950">{adminCount}</div>
            </div>
            <button
              type="button"
              onClick={openCreateModal}
              className="inline-flex items-center gap-2 rounded-md bg-blue-600 px-4 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-blue-700"
            >
              <UserPlus className="h-4 w-4" />
              เพิ่มผู้ใช้
            </button>
          </div>
        </div>

        {message && (
          <div
            className={`mb-4 rounded-md border px-4 py-3 text-sm ${
              message.type === 'success'
                ? 'border-emerald-200 bg-emerald-50 text-emerald-800'
                : 'border-red-200 bg-red-50 text-red-800'
            }`}
          >
            {message.text}
          </div>
        )}

        <section className="rounded-md border border-slate-200 bg-white">
          <div className="flex items-center justify-between gap-3 border-b border-slate-200 px-5 py-4">
            <div className="flex items-center gap-2">
              <Users className="h-5 w-5 text-blue-600" />
              <h2 className="text-base font-semibold text-slate-950">ผู้ใช้งาน</h2>
            </div>
            <button
              type="button"
              onClick={loadData}
              disabled={loading}
              className="inline-flex items-center gap-2 rounded-md border border-slate-300 px-3 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50 disabled:opacity-60"
            >
              <RefreshCw className={`h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
              รีเฟรช
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200 text-sm">
              <thead className="bg-slate-50 text-left text-xs font-semibold uppercase text-slate-500">
                <tr>
                  <th className="px-5 py-3">ชื่อผู้ใช้</th>
                  <th className="px-5 py-3">บทบาท</th>
                  <th className="px-5 py-3">แผนก</th>
                  <th className="px-5 py-3">สถานะ</th>
                  <th className="px-5 py-3">เข้าระบบล่าสุด</th>
                  <th className="px-5 py-3 text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {loading ? (
                  <tr>
                    <td colSpan={6} className="px-5 py-8 text-center text-slate-500">
                      กำลังโหลด...
                    </td>
                  </tr>
                ) : users.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="px-5 py-8 text-center text-slate-500">
                      ไม่มีผู้ใช้งาน
                    </td>
                  </tr>
                ) : (
                  users.map((user) => (
                    <tr key={user.id} className="hover:bg-slate-50">
                      <td className="px-5 py-3">
                        <div className="font-medium text-slate-950">{user.name || user.provider_id}</div>
                        <div className="text-xs text-slate-500">{user.provider_id}</div>
                      </td>
                      <td className="px-5 py-3">
                        <span className="rounded-full bg-blue-50 px-2.5 py-1 text-xs font-semibold text-blue-700">
                          {roleLabel(user.role)}
                        </span>
                      </td>
                      <td className="px-5 py-3 text-slate-700">
                        {user.department_name || '-'}
                        {false && (
                          <span className="ml-2 rounded-full bg-amber-50 px-2 py-0.5 text-xs font-medium text-amber-700">
                            เจ้าของ
                          </span>
                        )}
                      </td>
                      <td className="px-5 py-3">
                        <span
                          className={`rounded-full px-2.5 py-1 text-xs font-semibold ${
                            user.is_active
                              ? 'bg-emerald-50 text-emerald-700'
                              : 'bg-slate-100 text-slate-500'
                          }`}
                        >
                            {user.is_active ? 'ใช้งาน' : 'ปิดใช้งาน'}
                        </span>
                      </td>
                      <td className="px-5 py-3 text-slate-600">{formatDate(user.last_login_at)}</td>
                      <td className="px-5 py-3 text-right">
                        <button
                          type="button"
                          onClick={() => openEditModal(user)}
                          className="inline-flex items-center gap-2 rounded-md border border-slate-300 px-3 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50"
                        >
                          <Pencil className="h-4 w-4" />
                          แก้ไข
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </section>
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 z-[70] flex items-center justify-center bg-slate-950/45 px-4 py-6">
          <div className="w-full max-w-lg rounded-md bg-white shadow-xl">
            <div className="flex items-center justify-between border-b border-slate-200 px-5 py-4">
              <div>
                <h2 className="text-base font-semibold text-slate-950">{editingUser ? 'แก้ไขผู้ใช้' : 'เพิ่มผู้ใช้'}</h2>
                {editingUser && <p className="text-xs text-slate-500">{editingUser.provider_id}</p>}
              </div>
              <button
                type="button"
                onClick={closeModal}
                className="rounded-md p-2 text-slate-500 transition-colors hover:bg-slate-100 hover:text-slate-700"
                aria-label="ปิดฟอร์มผู้ใช้"
              >
                <X className="h-4 w-4" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4 p-5">
              <label className="block">
                  <span className="mb-1 block text-sm font-medium text-slate-700">ชื่อ</span>
                <input
                  type="text"
                  value={form.name}
                  onChange={(event) => updateForm('name', event.target.value)}
                  className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                />
              </label>

              <label className="block">
                  <span className="mb-1 block text-sm font-medium text-slate-700">ชื่อผู้ใช้</span>
                <input
                  type="text"
                  required
                  autoComplete="username"
                  value={form.provider_id}
                  onChange={(event) => updateForm('provider_id', event.target.value)}
                  className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                />
              </label>

              <label className="block">
                  <span className="mb-1 block text-sm font-medium text-slate-700">รหัสผ่าน</span>
                <input
                  type="password"
                  required={!editingUser}
                  minLength={form.password ? 6 : undefined}
                  value={form.password}
                  onChange={(event) => updateForm('password', event.target.value)}
                  className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                />
              </label>

              <div className="grid gap-4 sm:grid-cols-2">
                <label className="block">
                    <span className="mb-1 block text-sm font-medium text-slate-700">บทบาท</span>
                  <select
                    value={form.role}
                    onChange={(event) => updateForm('role', event.target.value as Role)}
                    className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                  >
                    <option value="User">ผู้ใช้งาน</option>
                    <option value="Manager">ผู้จัดการ</option>
                    <option value="Admin">ผู้ดูแลระบบ</option>
                  </select>
                </label>

                <label className="block">
                    <span className="mb-1 block text-sm font-medium text-slate-700">แผนก</span>
                  <select
                    value={form.department_id}
                    onChange={(event) => updateForm('department_id', event.target.value)}
                    className="w-full rounded-md border border-slate-300 px-3 py-2 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                  >
                    <option value="">ไม่ระบุแผนก</option>
                    {departments.map((department) => (
                      <option key={department.id} value={department.id}>
                        {department.department_code ? `${department.department_code} - ` : ''}
                        {department.name}
                      </option>
                    ))}
                  </select>
                </label>
              </div>

              <div className="space-y-3 rounded-md border border-slate-200 bg-slate-50 p-3">
                {/*
                <label className="hidden">
                  <input
                    type="checkbox"
                    checked={false}
                    onChange={() => {}}
                    className="h-4 w-4 rounded border-slate-300 text-blue-600"
                  />
                  เจ้าของแผนก
                </label>
                */}
                <label className="flex items-center gap-3 text-sm text-slate-700">
                  <input
                    type="checkbox"
                    checked={form.is_active}
                    onChange={(event) => updateForm('is_active', event.target.checked)}
                    className="h-4 w-4 rounded border-slate-300 text-blue-600"
                  />
                  เปิดใช้งาน
                </label>
              </div>

              <div className="flex justify-end gap-3 border-t border-slate-200 pt-4">
                <button
                  type="button"
                  onClick={closeModal}
                  className="rounded-md border border-slate-300 px-4 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50"
                >
                  ยกเลิก
                </button>
                <button
                  type="submit"
                  disabled={saving}
                  className="inline-flex items-center justify-center gap-2 rounded-md bg-blue-600 px-4 py-2 text-sm font-semibold text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
                >
                  <UserPlus className="h-4 w-4" />
                  {saving ? 'กำลังบันทึก...' : editingUser ? 'บันทึกการแก้ไข' : 'สร้างผู้ใช้'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </main>
  );
}
