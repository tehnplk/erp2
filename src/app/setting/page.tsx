'use client';

import { useEffect, useMemo, useState, type ChangeEvent } from 'react';
import Swal from 'sweetalert2';
import { Pencil, Plus, Search, Trash2, X } from 'lucide-react';
import { SortableHeader } from '../inventory/_components/sortable-header';
import { clearSysSettingCache } from '@/lib/sys-setting';

type SortOrder = 'asc' | 'desc';
type SettingSortKey = 'id' | 'sys_name' | 'sys_value' | 'sys_value_detail';

type SysSetting = {
  id: number;
  sys_name: string;
  sys_value: string;
  sys_value_detail: string;
};

type SettingFormData = {
  sys_name: string;
  sys_value: string;
  sys_value_detail: string;
};

const PAGE_SIZE_OPTIONS = [10, 20, 50];

const emptyFormData: SettingFormData = {
  sys_name: '',
  sys_value: '',
  sys_value_detail: '',
};

function formatErrorMessage(error: unknown) {
  if (typeof error === 'string') return error;
  if (error && typeof error === 'object' && 'message' in error) {
    return String((error as { message?: unknown }).message || 'Unknown error');
  }
  return 'เกิดข้อผิดพลาด';
}

export default function SettingPage() {
  const [settings, setSettings] = useState<SysSetting[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [sortBy, setSortBy] = useState<SettingSortKey>('id');
  const [sortOrder, setSortOrder] = useState<SortOrder>('asc');
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const [modalOpen, setModalOpen] = useState(false);
  const [saving, setSaving] = useState(false);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [formData, setFormData] = useState<SettingFormData>(emptyFormData);
  const [feedback, setFeedback] = useState<{ type: 'success' | 'error'; message: string } | null>(null);

  const totalPages = useMemo(() => Math.max(1, Math.ceil(totalCount / pageSize)), [totalCount, pageSize]);
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + pageSize - 1);

  useEffect(() => {
    void loadSettings();
  }, [search, sortBy, sortOrder, page, pageSize]);

  useEffect(() => {
    if (feedback) {
      const timer = window.setTimeout(() => setFeedback(null), 3000);
      return () => window.clearTimeout(timer);
    }
    return undefined;
  }, [feedback]);

  async function loadSettings() {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (search.trim()) params.set('search', search.trim());
      if (sortBy !== 'id') params.set('order_by', sortBy);
      if (sortOrder !== 'asc') params.set('sort_order', sortOrder);
      if (page > 1) params.set('page', String(page));
      if (pageSize !== 20) params.set('page_size', String(pageSize));

      const response = await fetch(`/api/sys-setting${params.toString() ? `?${params.toString()}` : ''}`);
      const json = await response.json();

      if (!response.ok || !json?.success) {
        throw new Error(json?.error || 'Failed to fetch system settings');
      }

      setSettings(Array.isArray(json.data) ? json.data : []);
      setTotalCount(Number(json.totalCount ?? 0));
    } catch (error) {
      console.error('Error fetching system settings:', error);
      setSettings([]);
      setTotalCount(0);
      setFeedback({ type: 'error', message: formatErrorMessage(error) });
    } finally {
      setLoading(false);
    }
  }

  function openCreateModal() {
    setEditingId(null);
    setFormData(emptyFormData);
    setModalOpen(true);
  }

  function openEditModal(setting: SysSetting) {
    setEditingId(setting.id);
    setFormData({
      sys_name: setting.sys_name ?? '',
      sys_value: setting.sys_value ?? '',
      sys_value_detail: setting.sys_value_detail ?? '',
    });
    setModalOpen(true);
  }

  function closeModal() {
    if (saving) return;
    setModalOpen(false);
    setEditingId(null);
    setFormData(emptyFormData);
  }

  function handleSort(nextKey: string) {
    const typedKey = nextKey as SettingSortKey;
    if (sortBy === typedKey) {
      setSortOrder((current) => (current === 'asc' ? 'desc' : 'asc'));
    } else {
      setSortBy(typedKey);
      setSortOrder('asc');
    }
    setPage(1);
  }

  function clearSearch() {
    setSearch('');
    setPage(1);
  }

  function handlePageSizeChange(event: ChangeEvent<HTMLSelectElement>) {
    setPageSize(Number(event.target.value));
    setPage(1);
  }

  async function handleSave() {
    const sysName = formData.sys_name.trim();
    const sysValue = formData.sys_value.trim();
    const sysValueDetail = formData.sys_value_detail.trim();

    if (!sysName || !sysValue || !sysValueDetail) {
      setFeedback({ type: 'error', message: 'กรุณากรอกข้อมูลให้ครบทุกช่อง' });
      return;
    }

    try {
      setSaving(true);
      const response = await fetch(
        editingId ? `/api/sys-setting/${editingId}` : '/api/sys-setting',
        {
          method: editingId ? 'PUT' : 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            sys_name: sysName,
            sys_value: sysValue,
            sys_value_detail: sysValueDetail,
          }),
        }
      );

      const json = await response.json();
      if (!response.ok || !json?.success) {
        throw new Error(json?.error || 'Failed to save system setting');
      }

      setFeedback({
        type: 'success',
        message: editingId ? 'แก้ไขตั้งค่าระบบสำเร็จ' : 'เพิ่มตั้งค่าระบบสำเร็จ',
      });
      clearSysSettingCache();
      window.dispatchEvent(new Event('sys-setting-updated'));
      setModalOpen(false);
      setEditingId(null);
      setFormData(emptyFormData);
      await loadSettings();
    } catch (error) {
      console.error('Error saving system setting:', error);
      setFeedback({ type: 'error', message: formatErrorMessage(error) });
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete(setting: SysSetting) {
    const result = await Swal.fire({
      title: 'ลบการตั้งค่านี้?',
      text: `ยืนยันการลบ ${setting.sys_name} หรือไม่`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'ลบ',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#d33',
      cancelButtonColor: '#64748b',
    });

    if (!result.isConfirmed) return;

    try {
      const response = await fetch(`/api/sys-setting/${setting.id}`, { method: 'DELETE' });
      const json = await response.json();

      if (!response.ok || !json?.success) {
        throw new Error(json?.error || 'Failed to delete system setting');
      }

      setFeedback({ type: 'success', message: 'ลบตั้งค่าระบบสำเร็จ' });
      clearSysSettingCache();
      window.dispatchEvent(new Event('sys-setting-updated'));
      await loadSettings();
    } catch (error) {
      console.error('Error deleting system setting:', error);
      setFeedback({ type: 'error', message: formatErrorMessage(error) });
    }
  }

  const paginationText = `${pageStart}-${pageEnd}`;

  return (
    <div className="min-h-screen bg-slate-50 p-6">
      <div className="mx-auto w-full max-w-none space-y-5">
        <div className="flex flex-wrap items-center justify-between gap-3">
          <div>
            <h1 className="text-2xl font-bold text-slate-900">ตั้งค่าระบบ</h1>
            <p className="mt-1 text-sm text-slate-500">จัดการค่าระบบที่ใช้งานร่วมกันทั้งระบบ</p>
          </div>
          <button
            type="button"
            onClick={openCreateModal}
            className="inline-flex items-center rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-medium text-white shadow-sm transition hover:bg-blue-700"
          >
            <Plus className="mr-2 h-4 w-4" />
            เพิ่มค่าระบบ
          </button>
        </div>

        {feedback && (
          <div
            className={[
              'rounded-2xl border px-4 py-3 text-sm shadow-sm',
              feedback.type === 'success'
                ? 'border-emerald-200 bg-emerald-50 text-emerald-700'
                : 'border-rose-200 bg-rose-50 text-rose-700',
            ].join(' ')}
          >
            {feedback.message}
          </div>
        )}

        <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm">
          <div className="flex flex-wrap items-center gap-3">
            <div className="relative min-w-[280px] flex-1">
              <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-slate-400" />
              <input
                value={search}
                onChange={(event) => {
                  setSearch(event.target.value);
                  setPage(1);
                }}
                placeholder="ค้นหา name / value / detail"
                className="w-full rounded-xl border border-slate-300 py-2.5 pl-10 pr-10 text-sm outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
              />
              {search && (
                <button
                  type="button"
                  onClick={clearSearch}
                  className="absolute right-2 top-1/2 -translate-y-1/2 rounded-lg p-1 text-slate-400 transition hover:bg-slate-100 hover:text-slate-700"
                  aria-label="clear search"
                >
                  <X className="h-4 w-4" />
                </button>
              )}
            </div>

            <select
              value={pageSize}
              onChange={handlePageSizeChange}
              className="rounded-xl border border-slate-300 px-3 py-2.5 text-sm outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
            >
              {PAGE_SIZE_OPTIONS.map((option) => (
                <option key={option} value={option}>
                  {option}
                </option>
              ))}
            </select>
          </div>
        </div>

        <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
          <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 px-4 py-3 text-sm text-slate-600">
            <div className="font-medium text-slate-700">รวม {totalCount.toLocaleString('th-TH')} รายการ</div>
            <div className="flex flex-wrap items-center gap-2">
              <span className="rounded-full bg-slate-100 px-3 py-1 text-slate-700">แสดง {paginationText}</span>
              <span className="rounded-full bg-slate-100 px-3 py-1 text-slate-700">หน้า {page} / {totalPages}</span>
              <button
                type="button"
                onClick={() => setPage((current) => Math.max(1, current - 1))}
                disabled={page <= 1}
                className="rounded-full border border-slate-300 px-3 py-1 text-slate-700 transition hover:bg-slate-100 disabled:cursor-not-allowed disabled:opacity-50"
              >
                ก่อนหน้า
              </button>
              <button
                type="button"
                onClick={() => setPage((current) => Math.min(totalPages, current + 1))}
                disabled={page >= totalPages}
                className="rounded-full border border-slate-300 px-3 py-1 text-slate-700 transition hover:bg-slate-100 disabled:cursor-not-allowed disabled:opacity-50"
              >
                ถัดไป
              </button>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200 text-sm">
              <thead className="bg-slate-50 text-slate-700">
                <tr>
                  <th className="px-4 py-3 text-left font-semibold">
                    <SortableHeader
                      label="ID"
                      sortKey="id"
                      activeKey={sortBy}
                      activeOrder={sortOrder}
                      onSort={handleSort}
                    />
                  </th>
                  <th className="px-4 py-3 text-left font-semibold">
                    <SortableHeader
                      label="sys_name"
                      sortKey="sys_name"
                      activeKey={sortBy}
                      activeOrder={sortOrder}
                      onSort={handleSort}
                    />
                  </th>
                  <th className="px-4 py-3 text-left font-semibold">
                    <SortableHeader
                      label="sys_value"
                      sortKey="sys_value"
                      activeKey={sortBy}
                      activeOrder={sortOrder}
                      onSort={handleSort}
                    />
                  </th>
                  <th className="px-4 py-3 text-left font-semibold">
                    <SortableHeader
                      label="sys_value_detail"
                      sortKey="sys_value_detail"
                      activeKey={sortBy}
                      activeOrder={sortOrder}
                      onSort={handleSort}
                    />
                  </th>
                  <th className="px-4 py-3 text-center font-semibold">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 bg-white">
                {loading ? (
                  <tr>
                    <td colSpan={5} className="px-4 py-10 text-center text-slate-500">
                      กำลังโหลดข้อมูล...
                    </td>
                  </tr>
                ) : settings.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="px-4 py-10 text-center text-slate-500">
                      ไม่พบข้อมูล
                    </td>
                  </tr>
                ) : (
                  settings.map((setting) => (
                    <tr key={setting.id} className="hover:bg-slate-50/70">
                      <td className="px-4 py-3 font-medium text-slate-600">{setting.id}</td>
                      <td className="px-4 py-3 font-mono text-slate-900">{setting.sys_name}</td>
                      <td className="px-4 py-3 text-slate-700">{setting.sys_value}</td>
                      <td className="px-4 py-3 text-slate-700">{setting.sys_value_detail}</td>
                      <td className="px-4 py-3">
                        <div className="flex justify-center gap-2">
                          <button
                            type="button"
                            onClick={() => openEditModal(setting)}
                            className="inline-flex items-center rounded-lg border border-slate-300 p-2 text-slate-700 transition hover:bg-slate-100"
                            aria-label={`edit ${setting.sys_name}`}
                          >
                            <Pencil className="h-4 w-4" />
                          </button>
                          <button
                            type="button"
                            onClick={() => void handleDelete(setting)}
                            className="inline-flex items-center rounded-lg border border-rose-300 p-2 text-rose-600 transition hover:bg-rose-50"
                            aria-label={`delete ${setting.sys_name}`}
                          >
                            <Trash2 className="h-4 w-4" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {modalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/40 px-4 py-8">
          <div className="w-full max-w-2xl rounded-3xl bg-white shadow-2xl">
            <div className="flex items-center justify-between border-b border-slate-200 px-6 py-4">
              <div>
                <h2 className="text-xl font-bold text-slate-900">
                  {editingId ? 'แก้ไขตั้งค่าระบบ' : 'เพิ่มตั้งค่าระบบ'}
                </h2>
                <p className="mt-1 text-sm text-slate-500">
                  ใช้ข้อมูลนี้กำหนดค่ากลางของระบบ
                </p>
              </div>
              <button
                type="button"
                onClick={closeModal}
                disabled={saving}
                className="rounded-xl p-2 text-slate-500 transition hover:bg-slate-100 hover:text-slate-800 disabled:cursor-not-allowed disabled:opacity-60"
                aria-label="close modal"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="space-y-4 px-6 py-5">
              {editingId && (
                <div>
                  <label className="mb-1 block text-sm font-medium text-slate-700">ID</label>
                  <input
                    value={editingId}
                    disabled
                    className="w-full rounded-xl border border-slate-300 bg-slate-100 px-3 py-2.5 text-sm text-slate-600 outline-none"
                  />
                </div>
              )}

              <div className="grid gap-4 md:grid-cols-2">
                <div>
                  <label className="mb-1 block text-sm font-medium text-slate-700">sys_name</label>
                  <input
                    value={formData.sys_name}
                    onChange={(event) => setFormData((current) => ({ ...current, sys_name: event.target.value }))}
                    placeholder="เช่น budget_year"
                    className="w-full rounded-xl border border-slate-300 px-3 py-2.5 text-sm outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                  />
                </div>

                <div>
                  <label className="mb-1 block text-sm font-medium text-slate-700">sys_value</label>
                  <input
                    value={formData.sys_value}
                    onChange={(event) => setFormData((current) => ({ ...current, sys_value: event.target.value }))}
                    placeholder="เช่น 2569"
                    className="w-full rounded-xl border border-slate-300 px-3 py-2.5 text-sm outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                  />
                </div>
              </div>

              <div>
                <label className="mb-1 block text-sm font-medium text-slate-700">sys_value_detail</label>
                <textarea
                  value={formData.sys_value_detail}
                  onChange={(event) => setFormData((current) => ({ ...current, sys_value_detail: event.target.value }))}
                  placeholder="เช่น 1ตค2568-30กย2569"
                  rows={4}
                  className="w-full rounded-xl border border-slate-300 px-3 py-2.5 text-sm outline-none transition focus:border-blue-500 focus:ring-2 focus:ring-blue-100"
                />
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 border-t border-slate-200 px-6 py-4">
              <button
                type="button"
                onClick={closeModal}
                disabled={saving}
                className="rounded-xl border border-slate-300 px-4 py-2.5 text-sm font-medium text-slate-700 transition hover:bg-slate-100 disabled:cursor-not-allowed disabled:opacity-60"
              >
                ยกเลิก
              </button>
              <button
                type="button"
                onClick={() => void handleSave()}
                disabled={saving}
                className="rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-medium text-white shadow-sm transition hover:bg-blue-700 disabled:cursor-not-allowed disabled:opacity-60"
              >
                {saving ? 'กำลังบันทึก...' : 'บันทึก'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
