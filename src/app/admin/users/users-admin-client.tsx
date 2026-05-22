'use client';

import { useEffect, useMemo, useState } from 'react';
import type { FormEvent } from 'react';
import { Check, Plus, ShieldCheck, Trash2, Users, X } from 'lucide-react';
import Swal from 'sweetalert2';

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

const formId = 'admin-user-inline-form';
const inputClass =
  'h-9 w-full rounded-md border border-slate-300 bg-white px-2.5 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100';
const selectClass =
  'h-9 w-full rounded-md border border-slate-300 bg-white px-2.5 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100';

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
  const [isEditorOpen, setIsEditorOpen] = useState(false);
  const [nameFilter, setNameFilter] = useState('');
  const [departmentFilter, setDepartmentFilter] = useState('');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [deletingUserId, setDeletingUserId] = useState<string | null>(null);
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  const activeCount = useMemo(() => users.filter((user) => user?.is_active).length, [users]);
  const adminCount = useMemo(() => users.filter((user) => user?.role === 'Admin').length, [users]);
  const filteredUsers = useMemo(() => {
    const normalizedName = nameFilter.trim().toLowerCase();

    return users.filter((user) => {
      const matchesName = !normalizedName || (user.name || '').toLowerCase().includes(normalizedName);
      const matchesDepartment = !departmentFilter || String(user.department_id ?? '') === departmentFilter;

      return matchesName && matchesDepartment;
    });
  }, [departmentFilter, nameFilter, users]);
  const isCreating = isEditorOpen && !editingUser;

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

  const openCreateEditor = () => {
    setEditingUser(null);
    setForm(initialForm);
    setMessage(null);
    setIsEditorOpen(true);
  };

  const openEditEditor = (user: ManagedUser) => {
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
    setIsEditorOpen(true);
  };

  const closeEditor = () => {
    if (saving) return;
    setIsEditorOpen(false);
    setEditingUser(null);
    setForm(initialForm);
  };

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
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

      closeEditor();
      setMessage({ type: 'success', text: editingUser ? 'บันทึกการแก้ไขผู้ใช้แล้ว' : 'สร้างผู้ใช้แล้ว' });
    } catch (error: any) {
      setMessage({ type: 'error', text: error?.message || 'บันทึกผู้ใช้งานไม่สำเร็จ' });
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (user: ManagedUser) => {
    if (saving || deletingUserId) return;

    const confirmation = await Swal.fire({
      title: 'ยืนยันการลบ',
      text: `ลบผู้ใช้ ${user.name || user.provider_id}?`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#dc2626',
      cancelButtonColor: '#64748b',
      confirmButtonText: 'ลบ',
      cancelButtonText: 'ยกเลิก',
    });
    if (!confirmation.isConfirmed) return;

    setDeletingUserId(user.id);
    setMessage(null);

    try {
      const response = await fetch(`/api/users/${user.id}`, { method: 'DELETE' });
      const payload = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'ลบผู้ใช้งานไม่สำเร็จ');
      }

      setUsers((current) => current.filter((item) => item.id !== user.id));
      if (editingUser?.id === user.id) {
        closeEditor();
      }
      setMessage({ type: 'success', text: 'ลบผู้ใช้แล้ว' });
    } catch (error: any) {
      setMessage({ type: 'error', text: error?.message || 'ลบผู้ใช้งานไม่สำเร็จ' });
    } finally {
      setDeletingUserId(null);
    }
  };

  const renderStatusSwitch = (
    checked: boolean,
    options: {
      disabled?: boolean;
      form?: string;
      onChange?: (checked: boolean) => void;
    } = {}
  ) => (
    <label className={`flex h-9 items-center gap-2 text-sm ${options.disabled ? 'text-slate-500' : 'text-slate-700'}`}>
      <input
        form={options.form}
        type="checkbox"
        checked={checked}
        disabled={options.disabled}
        readOnly={options.disabled}
        onChange={options.onChange ? (event) => options.onChange?.(event.target.checked) : undefined}
        className="peer sr-only"
        role="switch"
        aria-label="สถานะ"
      />
      <span className="relative inline-flex h-6 w-11 shrink-0 rounded-full bg-slate-300 transition-colors after:absolute after:left-0.5 after:top-0.5 after:h-5 after:w-5 after:rounded-full after:bg-white after:shadow-sm after:transition-transform peer-checked:bg-blue-600 peer-checked:after:translate-x-5 peer-focus-visible:outline peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2 peer-focus-visible:outline-blue-600 peer-disabled:opacity-80" />
      <span className="w-8 text-xs font-semibold">{checked ? 'ON' : 'OFF'}</span>
    </label>
  );

  const renderInlineEditorRow = (rowKey: string, sequenceLabel = '-') => (
    <tr key={rowKey} className="bg-blue-50/50 align-top">
      <td className="px-3 py-3 text-center text-slate-500">{sequenceLabel}</td>
      <td className="px-3 py-3">
        <input
          form={formId}
          type="text"
          value={form.name}
          onChange={(event) => updateForm('name', event.target.value)}
          className={inputClass}
          aria-label="ชื่อ-นามสกุล"
        />
      </td>
      <td className="px-3 py-3">
        <input
          form={formId}
          type="text"
          required
          autoComplete="username"
          value={form.provider_id}
          onChange={(event) => updateForm('provider_id', event.target.value)}
          className={inputClass}
          aria-label="ชื่อผู้ใช้"
        />
      </td>
      <td className="px-3 py-3">
        <input
          form={formId}
          type="password"
          required={!editingUser}
          minLength={form.password ? 6 : undefined}
          value={form.password}
          onChange={(event) => updateForm('password', event.target.value)}
          className={inputClass}
          aria-label="รหัสผ่าน"
        />
      </td>
      <td className="px-3 py-3">
        <select
          form={formId}
          value={form.role}
          onChange={(event) => updateForm('role', event.target.value as Role)}
          className={selectClass}
          aria-label="บทบาท"
        >
          <option value="User">ผู้ใช้งาน</option>
          <option value="Manager">ผู้จัดการ</option>
          <option value="Admin">ผู้ดูแลระบบ</option>
        </select>
      </td>
      <td className="px-3 py-3">
        <select
          form={formId}
          value={form.department_id}
          onChange={(event) => updateForm('department_id', event.target.value)}
          className={selectClass}
          aria-label="แผนก"
        >
          <option value="">ไม่ระบุแผนก</option>
          {departments.map((department) => (
            <option key={department.id} value={department.id}>
              {department.department_code ? `${department.department_code} - ` : ''}
              {department.name}
            </option>
          ))}
        </select>
      </td>
      <td className="px-3 py-3">
        {renderStatusSwitch(form.is_active, {
          form: formId,
          onChange: (checked) => updateForm('is_active', checked),
        })}
      </td>
      <td className="px-3 py-3 text-slate-500">-</td>
      <td className="px-3 py-3 text-right">
        <div className="inline-flex items-center gap-2">
          <button
            form={formId}
            type="submit"
            disabled={saving}
            className="inline-flex h-9 w-9 items-center justify-center rounded-md bg-blue-600 text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
            aria-label={editingUser ? 'บันทึกการแก้ไขผู้ใช้' : 'สร้างผู้ใช้'}
            title={editingUser ? 'บันทึกการแก้ไขผู้ใช้' : 'สร้างผู้ใช้'}
          >
            <Check className="h-4 w-4" />
          </button>
          <button
            type="button"
            onClick={closeEditor}
            disabled={saving}
            className="inline-flex h-9 w-9 items-center justify-center rounded-md border border-slate-300 text-slate-600 transition-colors hover:bg-white disabled:opacity-60"
            aria-label="ยกเลิก"
            title="ยกเลิก"
          >
            <X className="h-4 w-4" />
          </button>
          {editingUser && (
            <button
              type="button"
              onClick={() => handleDelete(editingUser)}
              disabled={deletingUserId === editingUser.id || saving}
              className="inline-flex h-9 w-9 items-center justify-center rounded-md border border-red-200 text-red-600 transition-colors hover:bg-red-50 disabled:opacity-60"
              aria-label="ลบผู้ใช้"
              title="ลบผู้ใช้"
            >
              <Trash2 className="h-4 w-4" />
            </button>
          )}
        </div>
      </td>
    </tr>
  );

  return (
    <main className="min-h-screen bg-slate-50 text-slate-900">
      <form id={formId} onSubmit={handleSubmit} />

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
          </div>
        </div>

        <section className="mb-4 rounded-md border border-slate-200 bg-white px-5 py-4">
          <div className="grid gap-4 md:grid-cols-[minmax(0,1fr)_minmax(220px,320px)]">
            <label className="block">
              <span className="mb-1 block text-sm font-medium text-slate-700">ค้นหาชื่อ-นามสกุล</span>
              <input
                type="search"
                value={nameFilter}
                onChange={(event) => setNameFilter(event.target.value)}
                placeholder="ค้นหาชื่อ-นามสกุล"
                className={inputClass}
              />
            </label>

            <label className="block">
              <span className="mb-1 block text-sm font-medium text-slate-700">แผนก</span>
              <select
                value={departmentFilter}
                onChange={(event) => setDepartmentFilter(event.target.value)}
                className={selectClass}
              >
                <option value="">ทุกแผนก</option>
                {departments.map((department) => (
                  <option key={department.id} value={department.id}>
                    {department.department_code ? `${department.department_code} - ` : ''}
                    {department.name}
                  </option>
                ))}
              </select>
            </label>
          </div>
        </section>

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
              onClick={openCreateEditor}
              disabled={loading || saving}
              className="inline-flex h-9 w-9 items-center justify-center rounded-md border border-slate-300 text-slate-700 transition-colors hover:bg-slate-50 disabled:opacity-60"
              aria-label="เพิ่ม"
              title="+"
            >
              <Plus className="h-4 w-4" />
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200 text-sm">
              <thead className="bg-slate-50 text-left text-xs font-semibold uppercase text-slate-500">
                <tr>
                  <th className="w-16 px-3 py-3 text-center">ลำดับ</th>
                  <th className="px-3 py-3">ชื่อ-นามสกุล</th>
                  <th className="px-3 py-3">ชื่อผู้ใช้</th>
                  <th className="px-3 py-3">รหัสผ่าน</th>
                  <th className="px-3 py-3">บทบาท</th>
                  <th className="px-3 py-3">แผนก</th>
                  <th className="px-3 py-3">สถานะ</th>
                  <th className="px-3 py-3">เข้าระบบล่าสุด</th>
                  <th className="px-3 py-3 text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {loading ? (
                  <tr>
                    <td colSpan={9} className="px-5 py-8 text-center text-slate-500">
                      กำลังโหลด...
                    </td>
                  </tr>
                ) : (
                  <>
                    {isCreating && renderInlineEditorRow('create-user')}

                    {filteredUsers.length === 0 && !isCreating ? (
                      <tr>
                        <td colSpan={9} className="px-5 py-8 text-center text-slate-500">
                          ไม่พบผู้ใช้งาน
                        </td>
                      </tr>
                    ) : (
                      filteredUsers.map((user, index) =>
                        editingUser?.id === user.id ? (
                          renderInlineEditorRow(user.id, String(index + 1))
                        ) : (
                          <tr
                            key={user.id}
                            onClick={() => {
                              if (deletingUserId !== user.id) {
                                openEditEditor(user);
                              }
                            }}
                            className="cursor-pointer hover:bg-slate-50"
                          >
                            <td className="px-3 py-3 text-center text-slate-500">{index + 1}</td>
                            <td className="px-3 py-3 font-medium text-slate-950">{user.name || '-'}</td>
                            <td className="px-3 py-3 text-slate-700">{user.provider_id}</td>
                            <td className="px-3 py-3 text-slate-400">-</td>
                            <td className="px-3 py-3">
                              <span className="rounded-full bg-blue-50 px-2.5 py-1 text-xs font-semibold text-blue-700">
                                {roleLabel(user.role)}
                              </span>
                            </td>
                            <td className="px-3 py-3 text-slate-700">{user.department_name || '-'}</td>
                            <td className="px-3 py-3">
                              {renderStatusSwitch(user.is_active, { disabled: true })}
                            </td>
                            <td className="px-3 py-3 text-slate-600">{formatDate(user.last_login_at)}</td>
                            <td className="px-3 py-3 text-right" onClick={(event) => event.stopPropagation()}>
                              <div className="inline-flex items-center gap-2">
                                <button
                                  type="button"
                                  onClick={() => handleDelete(user)}
                                  disabled={deletingUserId === user.id || saving}
                                  className="inline-flex h-9 w-9 items-center justify-center rounded-md border border-red-200 text-red-600 transition-colors hover:bg-red-50 disabled:opacity-60"
                                  aria-label="ลบผู้ใช้"
                                  title="ลบผู้ใช้"
                                >
                                  <Trash2 className="h-4 w-4" />
                                </button>
                              </div>
                            </td>
                          </tr>
                        )
                      )
                    )}
                  </>
                )}
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </main>
  );
}
