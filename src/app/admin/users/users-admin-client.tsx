'use client';

import { useEffect, useMemo, useState } from 'react';
import type { FormEvent } from 'react';
import { ArrowDown, ArrowUp, ArrowUpDown, Check, Plus, ShieldCheck, Trash2, Users, X } from 'lucide-react';
import Swal from 'sweetalert2';

type Role = 'Admin' | 'Manager' | 'User';
type SortDirection = 'asc' | 'desc';
type SortKey = 'sequence' | 'name' | 'provider_id' | 'password' | 'role' | 'department' | 'status' | 'last_login';

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
  'h-8 w-full rounded-none border border-slate-400 bg-white px-2 text-xs outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-300';
const selectClass =
  'h-8 w-full rounded-none border border-slate-400 bg-white px-2 text-xs outline-none focus:border-blue-600 focus:ring-1 focus:ring-blue-300';
const headerCellClass = 'border border-slate-300 bg-slate-200 px-2 py-2 text-left text-xs font-semibold text-slate-700';
const bodyCellClass = 'border border-slate-300 px-2 py-1';
const numericCellClass = `${bodyCellClass} text-center text-slate-500`;

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

const roleOptions: Array<{ value: Role; label: string }> = [
  { value: 'Admin', label: roleLabel('Admin') },
  { value: 'Manager', label: roleLabel('Manager') },
  { value: 'User', label: roleLabel('User') },
];
const pageSizeOptions = [20, 50, 100];

const showSuccessToast = (title: string) => {
  void Swal.fire({
    toast: true,
    position: 'top-end',
    icon: 'success',
    title,
    showConfirmButton: false,
    timer: 1800,
    timerProgressBar: true,
  });
};

export default function UsersAdminClient() {
  const [users, setUsers] = useState<ManagedUser[]>([]);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [form, setForm] = useState<UserForm>(initialForm);
  const [editingUser, setEditingUser] = useState<ManagedUser | null>(null);
  const [isEditorOpen, setIsEditorOpen] = useState(false);
  const [nameFilter, setNameFilter] = useState('');
  const [departmentFilter, setDepartmentFilter] = useState('');
  const [sort, setSort] = useState<{ key: SortKey; direction: SortDirection }>({
    key: 'sequence',
    direction: 'desc',
  });
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [deletingUserId, setDeletingUserId] = useState<string | null>(null);
  const [message, setMessage] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  const filteredUsers = useMemo(() => {
    const normalizedName = nameFilter.trim().toLowerCase();

    return users.filter((user) => {
      const matchesName = !normalizedName || (user.name || '').toLowerCase().includes(normalizedName);
      const matchesDepartment = !departmentFilter || String(user.department_id ?? '') === departmentFilter;

      return matchesName && matchesDepartment;
    });
  }, [departmentFilter, nameFilter, users]);
  const roleCounts = useMemo(
    () =>
      roleOptions.reduce<Record<Role, number>>(
        (counts, role) => ({
          ...counts,
          [role.value]: filteredUsers.filter((user) => user?.role === role.value).length,
        }),
        { Admin: 0, Manager: 0, User: 0 }
      ),
    [filteredUsers]
  );
  const sortedUsers = useMemo(() => {
    const indexedUsers = filteredUsers.map((user, index) => ({ user, index }));

    indexedUsers.sort((left, right) => {
      const sortValue = (item: { user: ManagedUser; index: number }) => {
        switch (sort.key) {
          case 'sequence':
            return Number(item.user.id) || 0;
          case 'name':
            return item.user.name || '';
          case 'provider_id':
            return item.user.provider_id || '';
          case 'password':
            return '';
          case 'role':
            return roleLabel(item.user.role);
          case 'department':
            return item.user.department_name || '';
          case 'status':
            return item.user.is_active ? 1 : 0;
          case 'last_login':
            return item.user.last_login_at ? new Date(item.user.last_login_at).getTime() : 0;
          default:
            return '';
        }
      };

      const leftValue = sortValue(left);
      const rightValue = sortValue(right);
      let comparison = 0;

      if (typeof leftValue === 'number' && typeof rightValue === 'number') {
        comparison = leftValue - rightValue;
      } else {
        comparison = String(leftValue).localeCompare(String(rightValue), 'th', {
          numeric: true,
          sensitivity: 'base',
        });
      }

      if (comparison === 0) {
        comparison = left.index - right.index;
      }

      return sort.direction === 'asc' ? comparison : -comparison;
    });

    return indexedUsers.map((item) => item.user);
  }, [filteredUsers, sort]);
  const totalCount = sortedUsers.length;
  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const paginatedUsers = useMemo(() => {
    const startIndex = (page - 1) * pageSize;
    return sortedUsers.slice(startIndex, startIndex + pageSize);
  }, [page, pageSize, sortedUsers]);
  const isCreating = isEditorOpen && !editingUser;

  useEffect(() => {
    if (page > totalPages) {
      setPage(totalPages);
    }
  }, [page, totalPages]);

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
    setPage(1);
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

      const successText = editingUser ? 'บันทึกการแก้ไขผู้ใช้แล้ว' : 'สร้างผู้ใช้แล้ว';
      closeEditor();
      showSuccessToast(successText);
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
      showSuccessToast('ลบผู้ใช้แล้ว');
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
    <label className={`flex h-8 items-center gap-2 text-xs ${options.disabled ? 'text-slate-500' : 'text-slate-700'}`}>
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
      <span className="relative inline-flex h-5 w-9 shrink-0 rounded-full bg-slate-300 transition-colors after:absolute after:left-0.5 after:top-0.5 after:h-4 after:w-4 after:rounded-full after:bg-white after:shadow-sm after:transition-transform peer-checked:bg-blue-600 peer-checked:after:translate-x-4 peer-focus-visible:outline peer-focus-visible:outline-2 peer-focus-visible:outline-offset-2 peer-focus-visible:outline-blue-600 peer-disabled:opacity-80" />
      <span className="w-7 text-xs font-semibold">{checked ? 'ON' : 'OFF'}</span>
    </label>
  );

  const handleSort = (key: SortKey) => {
    setPage(1);
    setSort((current) =>
      current.key === key
        ? { key, direction: current.direction === 'asc' ? 'desc' : 'asc' }
        : { key, direction: key === 'sequence' ? 'desc' : 'asc' }
    );
  };

  const renderSortHeader = (key: SortKey, label: string, className = '') => {
    const active = sort.key === key;
    const Icon = active ? (sort.direction === 'asc' ? ArrowUp : ArrowDown) : ArrowUpDown;

    return (
      <th
        className={`${headerCellClass} ${className}`}
        aria-sort={active ? (sort.direction === 'asc' ? 'ascending' : 'descending') : 'none'}
      >
        <button
          type="button"
          onClick={() => handleSort(key)}
          className={`flex w-full items-center gap-1 text-left ${className.includes('text-center') ? 'justify-center' : ''}`}
        >
          <span>{label}</span>
          <Icon className={`h-3.5 w-3.5 shrink-0 ${active ? 'text-blue-700' : 'text-slate-400'}`} />
        </button>
      </th>
    );
  };

  const renderInlineEditorRow = (rowKey: string, sequenceLabel = '-') => (
    <tr key={rowKey} className="bg-blue-50/70 align-top">
      <td className={numericCellClass}>{sequenceLabel}</td>
      <td className={bodyCellClass}>
        <input
          form={formId}
          type="text"
          value={form.name}
          onChange={(event) => updateForm('name', event.target.value)}
          className={inputClass}
          aria-label="ชื่อ-นามสกุล"
        />
      </td>
      <td className={bodyCellClass}>
        <input
          form={formId}
          type="text"
          required
          name={editingUser ? 'provider_id' : 'new_user_provider_id'}
          autoComplete={editingUser ? 'username' : 'off'}
          value={form.provider_id}
          onChange={(event) => updateForm('provider_id', event.target.value)}
          className={inputClass}
          aria-label="ชื่อผู้ใช้"
        />
      </td>
      <td className={bodyCellClass}>
        <input
          form={formId}
          type="password"
          required={!editingUser}
          minLength={form.password ? 6 : undefined}
          name={editingUser ? 'password' : 'new_user_password'}
          autoComplete="new-password"
          value={form.password}
          onChange={(event) => updateForm('password', event.target.value)}
          placeholder={editingUser ? 'ว่างไว้หากไม่เปลี่ยน' : undefined}
          className={inputClass}
          aria-label="รหัสผ่าน"
        />
      </td>
      <td className={bodyCellClass}>
        <select
          form={formId}
          value={form.role}
          onChange={(event) => updateForm('role', event.target.value as Role)}
          className={selectClass}
          aria-label="บทบาท"
        >
          {roleOptions.map((role) => (
            <option key={role.value} value={role.value}>
              {role.label}
            </option>
          ))}
        </select>
      </td>
      <td className={bodyCellClass}>
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
      <td className={bodyCellClass}>
        {renderStatusSwitch(form.is_active, {
          form: formId,
          onChange: (checked) => updateForm('is_active', checked),
        })}
      </td>
      <td className={`${bodyCellClass} text-slate-500`}>-</td>
      <td className={`${bodyCellClass} text-right`}>
        <div className="inline-flex items-center gap-1">
          <button
            form={formId}
            type="submit"
            disabled={saving}
            className="inline-flex h-7 w-7 items-center justify-center rounded-sm bg-blue-600 text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
            aria-label={editingUser ? 'บันทึกการแก้ไขผู้ใช้' : 'สร้างผู้ใช้'}
            title={editingUser ? 'บันทึกการแก้ไขผู้ใช้' : 'สร้างผู้ใช้'}
          >
            <Check className="h-4 w-4" />
          </button>
          <button
            type="button"
            onClick={closeEditor}
            disabled={saving}
            className="inline-flex h-7 w-7 items-center justify-center rounded-sm border border-slate-400 bg-white text-slate-600 transition-colors hover:bg-slate-100 disabled:opacity-60"
            aria-label="ยกเลิก"
            title="ยกเลิก"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
      </td>
    </tr>
  );

  return (
    <main className="min-h-screen bg-slate-50 p-6 text-slate-900">
      <form id={formId} onSubmit={handleSubmit} autoComplete="off" />

      <div className="w-full">
        <div className="mb-4 border-b border-slate-200 pb-5">
          <div>
            <div className="mb-2 inline-flex items-center gap-2 rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold text-blue-700">
              <ShieldCheck className="h-3.5 w-3.5" />
              ผู้ดูแลระบบ
            </div>
            <h1 className="text-2xl font-semibold tracking-normal text-slate-950">จัดการผู้ใช้งาน</h1>
          </div>
        </div>

        <section className="mb-3 overflow-hidden rounded-md border border-slate-300 bg-white">
          <div className="grid lg:grid-cols-[minmax(0,1fr)_360px]">
            <div className="grid gap-3 border-b border-slate-300 p-3 md:grid-cols-[minmax(0,1fr)_minmax(220px,320px)] lg:border-b-0 lg:border-r">
              <label className="block">
                <span className="mb-1 block text-xs font-semibold text-slate-700">ค้นหาชื่อ-นามสกุล</span>
                <input
                  type="search"
                  value={nameFilter}
                  onChange={(event) => {
                    setNameFilter(event.target.value);
                    setPage(1);
                  }}
                  placeholder="ค้นหาชื่อ-นามสกุล"
                  className={inputClass}
                />
              </label>

              <label className="block">
                <span className="mb-1 block text-xs font-semibold text-slate-700">แผนก</span>
                <select
                  value={departmentFilter}
                  onChange={(event) => {
                    setDepartmentFilter(event.target.value);
                    setPage(1);
                  }}
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

            <div className="grid grid-cols-3 divide-x divide-slate-300 text-xs">
              {roleOptions.map((role) => (
                <div key={role.value} className="px-3 py-2">
                  <div className="font-semibold text-slate-500">{role.label}</div>
                  <div className="mt-1 text-lg font-semibold text-slate-950">{roleCounts[role.value]}</div>
                </div>
              ))}
            </div>
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

        <section className="overflow-hidden rounded-md border border-slate-300 bg-white shadow-sm">
          <div className="flex items-center gap-3 border-b border-slate-300 bg-slate-100 px-3 py-2">
            <div className="flex items-center gap-2">
              <Users className="h-5 w-5 text-blue-600" />
              <h2 className="text-sm font-semibold text-slate-950">ผู้ใช้งาน</h2>
            </div>
          </div>

          <div className="mx-3 my-3 flex flex-col gap-2 rounded-lg border border-gray-100 bg-gray-50 px-3 py-2 text-sm text-gray-600 md:flex-row md:items-center md:justify-between">
            <div className="font-medium text-gray-700">
              หน้า {page} / {totalPages}
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <div className="rounded border border-gray-200 bg-white px-2 py-1 text-xs text-gray-600">
                รวมผู้ใช้ {totalCount.toLocaleString('th-TH')} รายการ
              </div>
              <select
                aria-label="เลือกจำนวนรายการต่อหน้า"
                value={String(pageSize)}
                onChange={(event) => {
                  const nextSize = Number(event.target.value);
                  if (!pageSizeOptions.includes(nextSize)) return;
                  setPageSize(nextSize);
                  setPage(1);
                }}
                className="rounded border border-gray-300 bg-white px-2 py-1 text-sm"
              >
                {pageSizeOptions.map((size) => (
                  <option key={size} value={size}>
                    {size}
                  </option>
                ))}
              </select>
              <button
                type="button"
                disabled={page <= 1}
                onClick={() => setPage((current) => Math.max(1, current - 1))}
                className="rounded border border-gray-300 bg-white px-2 py-1 disabled:opacity-50"
              >
                ก่อนหน้า
              </button>
              <button
                type="button"
                disabled={page >= totalPages}
                onClick={() => setPage((current) => Math.min(totalPages, current + 1))}
                className="rounded border border-gray-300 bg-white px-2 py-1 disabled:opacity-50"
              >
                ถัดไป
              </button>
              <button
                type="button"
                onClick={openCreateEditor}
                disabled={loading || saving}
                className="inline-flex h-8 w-8 items-center justify-center rounded-sm border border-emerald-700 bg-emerald-600 text-white transition-colors hover:bg-emerald-700 disabled:opacity-60"
                aria-label="เพิ่ม"
                title="+"
              >
                <Plus className="h-4 w-4" />
              </button>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="min-w-full border-collapse text-xs">
              <thead className="sticky top-0 z-10 text-left">
                <tr>
                  {renderSortHeader('sequence', 'ลำดับ', 'w-16 text-center')}
                  {renderSortHeader('name', 'ชื่อ-นามสกุล')}
                  {renderSortHeader('provider_id', 'ชื่อผู้ใช้')}
                  {renderSortHeader('password', 'รหัสผ่าน')}
                  {renderSortHeader('role', 'บทบาท')}
                  {renderSortHeader('department', 'แผนก')}
                  {renderSortHeader('status', 'สถานะ')}
                  {renderSortHeader('last_login', 'เข้าระบบล่าสุด')}
                  <th className={`${headerCellClass} text-right`}>จัดการ</th>
                </tr>
              </thead>
              <tbody>
                {loading ? (
                  <tr>
                    <td colSpan={9} className="border border-slate-300 px-5 py-8 text-center text-slate-500">
                      กำลังโหลด...
                    </td>
                  </tr>
                ) : (
                  <>
                    {isCreating && renderInlineEditorRow('create-user')}

                    {filteredUsers.length === 0 && !isCreating ? (
                      <tr>
                        <td colSpan={9} className="border border-slate-300 px-5 py-8 text-center text-slate-500">
                          ไม่พบผู้ใช้งาน
                        </td>
                      </tr>
                    ) : (
                      paginatedUsers.map((user, index) =>
                        editingUser?.id === user.id ? (
                          renderInlineEditorRow(user.id, user.id)
                        ) : (
                          <tr
                            key={user.id}
                            onClick={() => {
                              if (deletingUserId !== user.id) {
                                openEditEditor(user);
                              }
                            }}
                            className="cursor-cell hover:bg-blue-50"
                          >
                            <td className={numericCellClass}>{user.id}</td>
                            <td className={`${bodyCellClass} font-medium text-slate-950`}>{user.name || '-'}</td>
                            <td className={`${bodyCellClass} text-slate-700`}>{user.provider_id}</td>
                            <td className={`${bodyCellClass} text-slate-400`}>-</td>
                            <td className={bodyCellClass}>
                              <span className="inline-flex h-6 items-center border border-blue-200 bg-blue-50 px-2 text-xs font-semibold text-blue-700">
                                {roleLabel(user.role)}
                              </span>
                            </td>
                            <td className={`${bodyCellClass} text-slate-700`}>{user.department_name || '-'}</td>
                            <td className={bodyCellClass}>
                              {renderStatusSwitch(user.is_active, { disabled: true })}
                            </td>
                            <td className={`${bodyCellClass} text-slate-600`}>{formatDate(user.last_login_at)}</td>
                            <td className={`${bodyCellClass} text-right`} onClick={(event) => event.stopPropagation()}>
                              <div className="inline-flex items-center gap-1">
                                <button
                                  type="button"
                                  onClick={() => handleDelete(user)}
                                  disabled={deletingUserId === user.id || saving}
                                  className="inline-flex h-7 w-7 items-center justify-center rounded-sm border border-red-300 bg-white text-red-600 transition-colors hover:bg-red-50 disabled:opacity-60"
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
