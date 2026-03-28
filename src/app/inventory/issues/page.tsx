'use client';

import { useEffect, useMemo, useRef, useState } from 'react';
import { Eye, Plus, Trash2, X } from 'lucide-react';
import { InventoryBreadcrumbs } from '../_components/inventory-breadcrumbs';
import { formatBaht } from '@/lib/format-baht';

type DepartmentOption = { id: number; name: string; department_code: string; is_active: boolean };
type IssueListRow = { id: number; issue_no: string; issue_date: string; requesting_department_id: number; department_name: string; department_code: string; note: string | null; total_items: number; total_qty: number; total_value: number; created_at: string };
type IssueDetailItem = { id: number; stock_lot_id: number; issued_qty: number; unit_price: number; total_value: number; product_id: number; product_code: string; product_name: string; category: string | null; product_type: string | null; product_subtype: string | null; unit: string | null; lot_no: string; qty_on_hand: number; last_received_at: string | null };
type IssueDetailResponse = { issue: IssueListRow; items: IssueDetailItem[] };
type LotOption = { stock_lot_id: number; product_id: number; product_code: string; product_name: string; category: string | null; product_type: string | null; product_subtype: string | null; unit: string | null; lot_no: string; qty_on_hand: number; total_value: number; avg_unit_price: number; last_received_at: string | null };
type IssueFormItem = LotOption & { issued_qty: string; original_issued_qty: number };
type ApiResponse<T> = { success: boolean; data: T; totalCount?: number; error?: string; message?: string };

function formatDate(value: string | null) {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '-';
  return date.toLocaleDateString('th-TH');
}

function formatNumber(value: number | string | null | undefined, fractionDigits = 0) {
  const parsed = Number(value ?? 0);
  const safeValue = Number.isFinite(parsed) ? parsed : 0;
  return safeValue.toLocaleString('th-TH', { minimumFractionDigits: fractionDigits, maximumFractionDigits: fractionDigits });
}

export default function InventoryIssuesPage() {
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');
  const [issues, setIssues] = useState<IssueListRow[]>([]);
  const [departments, setDepartments] = useState<DepartmentOption[]>([]);
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const [totalCount, setTotalCount] = useState(0);
  const [createOpen, setCreateOpen] = useState(false);
  const [createSaving, setCreateSaving] = useState(false);
  const [createMessage, setCreateMessage] = useState('');
  const [formMode, setFormMode] = useState<'create' | 'edit'>('create');
  const [formIssueId, setFormIssueId] = useState<number | null>(null);
  const [issueDate, setIssueDate] = useState(() => new Date().toISOString().slice(0, 10));
  const [requestingDepartmentId, setRequestingDepartmentId] = useState('');
  const [issueNote, setIssueNote] = useState('');
  const [searchText, setSearchText] = useState('');
  const [showOutOfStock, setShowOutOfStock] = useState(false);
  const [lotOptions, setLotOptions] = useState<LotOption[]>([]);
  const [searchingLots, setSearchingLots] = useState(false);
  const [activeOptionIndex, setActiveOptionIndex] = useState(-1);
  const [selectedItems, setSelectedItems] = useState<IssueFormItem[]>([]);
  const [selectedIssueId, setSelectedIssueId] = useState<number | null>(null);
  const [selectedIssue, setSelectedIssue] = useState<IssueDetailResponse | null>(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [detailMessage, setDetailMessage] = useState('');
  const searchOptionRefs = useRef<Array<HTMLButtonElement | null>>([]);

  const totalPages = useMemo(() => Math.max(1, Math.ceil(totalCount / pageSize)), [totalCount, pageSize]);
  const selectedIssueTotalQty = useMemo(() => selectedItems.reduce((sum, item) => sum + Number(item.issued_qty || 0), 0), [selectedItems]);
  const selectedIssueTotalValue = useMemo(() => selectedItems.reduce((sum, item) => sum + Number(item.issued_qty || 0) * Number(item.avg_unit_price || 0), 0), [selectedItems]);
  const activeDepartments = useMemo(() => departments.filter((department) => department.is_active).slice().sort((a, b) => `${a.department_code} ${a.name}`.localeCompare(`${b.department_code} ${b.name}`)), [departments]);

  const fetchIssues = async () => {
    const params = new URLSearchParams({ page: String(page), page_size: String(pageSize), sort_order: 'desc' });
    if (search.trim()) params.set('search', search.trim());
    const response = await fetch(`/api/inventory/issues?${params.toString()}`);
    const payload: ApiResponse<IssueListRow[]> = await response.json();
    if (!response.ok || !payload.success) throw new Error(payload.error || 'โหลดรายการใบเบิกจ่ายไม่สำเร็จ');
    setIssues(payload.data || []);
    setTotalCount(payload.totalCount || 0);
  };

  useEffect(() => {
    const loadDepartments = async () => {
      try {
        const response = await fetch('/api/departments?page_size=200');
        const payload: ApiResponse<DepartmentOption[]> = await response.json();
        if (!response.ok || !payload.success) throw new Error(payload.error || 'โหลดหน่วยงานไม่สำเร็จ');
        setDepartments(payload.data || []);
      } catch (error) {
        console.error(error);
        setDepartments([]);
        setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการโหลดหน่วยงาน');
      }
    };
    loadDepartments();
  }, []);

  useEffect(() => {
    const timeout = window.setTimeout(async () => {
      try {
        setLoading(true);
        await fetchIssues();
      } catch (error) {
        console.error(error);
        setIssues([]);
        setTotalCount(0);
        setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด');
      } finally {
        setLoading(false);
      }
    }, 200);
    return () => window.clearTimeout(timeout);
  }, [page, pageSize, search]);

  useEffect(() => {
    if (selectedIssueId === null) return;
    const controller = new AbortController();
    const loadDetail = async () => {
      try {
        setDetailLoading(true);
        setDetailMessage('');
        const response = await fetch(`/api/inventory/issues/${selectedIssueId}`, { signal: controller.signal });
        const payload: ApiResponse<IssueDetailResponse> = await response.json();
        if (!response.ok || !payload.success) throw new Error(payload.error || 'โหลดรายละเอียดใบเบิกจ่ายไม่สำเร็จ');
        setSelectedIssue(payload.data);
      } catch (error) {
        if (controller.signal.aborted) return;
        console.error(error);
        setSelectedIssue(null);
        setDetailMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด');
      } finally {
        if (!controller.signal.aborted) setDetailLoading(false);
      }
    };
    loadDetail();
    return () => controller.abort();
  }, [selectedIssueId]);

  useEffect(() => {
    const q = searchText.trim();
    if (q.length < 2) {
      setLotOptions([]);
      setActiveOptionIndex(-1);
      return;
    }
    const timeout = window.setTimeout(async () => {
      try {
        setSearchingLots(true);
        const params = new URLSearchParams({ search: q, page_size: '20', sort_order: 'asc', available_only: showOutOfStock ? 'false' : 'true' });
        const response = await fetch(`/api/inventory/stock/lots?${params.toString()}`);
        const payload: ApiResponse<LotOption[]> = await response.json();
        if (!response.ok || !payload.success) throw new Error(payload.error || 'ค้นหาสินค้าในคลังไม่สำเร็จ');
        setLotOptions(payload.data || []);
      } catch (error) {
        console.error(error);
        setLotOptions([]);
      } finally {
        setSearchingLots(false);
      }
    }, 250);
    return () => window.clearTimeout(timeout);
  }, [searchText, showOutOfStock]);

  useEffect(() => {
    if (lotOptions.length === 0) {
      setActiveOptionIndex(-1);
      return;
    }
    if (activeOptionIndex >= lotOptions.length) {
      setActiveOptionIndex(0);
      return;
    }
    if (activeOptionIndex >= 0) {
      searchOptionRefs.current[activeOptionIndex]?.scrollIntoView({ block: 'nearest' });
    }
  }, [activeOptionIndex, lotOptions]);

  const openCreateModal = () => {
    setFormMode('create');
    setFormIssueId(null);
    setCreateMessage('');
    setIssueDate(new Date().toISOString().slice(0, 10));
    setRequestingDepartmentId('');
    setIssueNote('');
    setSearchText('');
    setShowOutOfStock(false);
    setLotOptions([]);
    setActiveOptionIndex(-1);
    setSelectedItems([]);
    setCreateOpen(true);
  };

  const resetCreateForm = () => {
    setFormMode('create');
    setFormIssueId(null);
    setIssueDate(new Date().toISOString().slice(0, 10));
    setRequestingDepartmentId('');
    setIssueNote('');
    setSearchText('');
    setShowOutOfStock(false);
    setLotOptions([]);
    setActiveOptionIndex(-1);
    setSelectedItems([]);
    setCreateMessage('');
  };

  const addLotToIssue = (lot: LotOption) => {
    if (Number(lot.qty_on_hand) <= 0) return;
    setSelectedItems((prev) => {
      if (prev.some((item) => item.stock_lot_id === lot.stock_lot_id)) return prev;
      return [...prev, { ...lot, issued_qty: '1', original_issued_qty: 0 }];
    });
  };

  const updateSelectedItemQty = (index: number, value: string) => {
    setSelectedItems((prev) =>
      prev.map((item, currentIndex) => {
        if (currentIndex !== index) return item;
        const raw = value.trim();
        if (raw === '') return { ...item, issued_qty: '' };
        const nextValue = Math.max(0, Number(raw));
        const maxQty = effectiveAvailableQty(item);
        return { ...item, issued_qty: String(Math.min(nextValue, maxQty)) };
      })
    );
  };

  const removeSelectedItem = (index: number) => {
    setSelectedItems((prev) => prev.filter((_, currentIndex) => currentIndex !== index));
  };

  const effectiveAvailableQty = (item: IssueFormItem) => Number(item.qty_on_hand) + Number(item.original_issued_qty || 0);

  const openEditModal = (issue: IssueDetailResponse) => {
    setFormMode('edit');
    setFormIssueId(issue.issue.id);
    setCreateMessage('');
    setIssueDate(issue.issue.issue_date.slice(0, 10));
    setRequestingDepartmentId(String(issue.issue.requesting_department_id));
    setIssueNote(issue.issue.note || '');
    setSearchText('');
    setShowOutOfStock(false);
    setLotOptions([]);
    setActiveOptionIndex(-1);
    setSelectedItems(
      issue.items.map((item) => ({
        stock_lot_id: item.stock_lot_id,
        product_id: item.product_id,
        product_code: item.product_code,
        product_name: item.product_name,
        category: item.category,
        product_type: item.product_type,
        product_subtype: item.product_subtype,
        unit: item.unit,
        lot_no: item.lot_no,
        qty_on_hand: Number(item.qty_on_hand),
        total_value: Number(item.total_value),
        avg_unit_price: Number(item.unit_price),
        last_received_at: item.last_received_at,
        issued_qty: String(item.issued_qty),
        original_issued_qty: Number(item.issued_qty),
      }))
    );
    setCreateOpen(true);
  };

  const submitIssue = async () => {
    if (!requestingDepartmentId) {
      setCreateMessage('กรุณาเลือกหน่วยงานที่ขอเบิก');
      return;
    }
    if (selectedItems.length === 0) {
      setCreateMessage('กรุณาเลือกรายการสินค้าอย่างน้อย 1 รายการ');
      return;
    }
    if (selectedItems.some((item) => Number(item.issued_qty) <= 0)) {
      setCreateMessage('จำนวนเบิกต้องมากกว่า 0');
      return;
    }
    if (selectedItems.some((item) => Number(item.issued_qty) > effectiveAvailableQty(item))) {
      setCreateMessage('จำนวนเบิกห้ามเกินคงเหลือ');
      return;
    }

    try {
      setCreateSaving(true);
      setCreateMessage('');
      const isEdit = formMode === 'edit' && formIssueId !== null;
      const response = await fetch(isEdit ? `/api/inventory/issues/${formIssueId}` : '/api/inventory/issues', {
        method: isEdit ? 'PUT' : 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          issue_date: issueDate,
          requesting_department_id: Number(requestingDepartmentId),
          note: issueNote.trim() || undefined,
          items: selectedItems.map((item) => ({ stock_lot_id: item.stock_lot_id, issued_qty: Number(item.issued_qty) })),
        }),
      });
      const payload: ApiResponse<{ id: number; issue_no: string }> = await response.json();
      if (!response.ok || !payload.success) throw new Error(payload.error || 'บันทึกใบเบิกจ่ายไม่สำเร็จ');
      setMessage(payload.message || `บันทึกใบเบิกจ่ายสำเร็จ เลขที่เอกสาร ${payload.data.issue_no}`);
      setCreateOpen(false);
      resetCreateForm();
      await fetchIssues();
    } catch (error) {
      console.error(error);
      setCreateMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการบันทึก');
    } finally {
      setCreateSaving(false);
    }
  };

  const openDetail = (issueId: number) => {
    setSelectedIssueId(issueId);
    setSelectedIssue(null);
    setDetailMessage('');
  };

  const closeDetail = () => {
    setSelectedIssueId(null);
    setSelectedIssue(null);
    setDetailMessage('');
  };

  const openIssueEditFromDetail = () => {
    if (!selectedIssue) return;
    const issue = selectedIssue;
    closeDetail();
    openEditModal(issue);
  };

  const issueListStart = issues.length > 0 ? (page - 1) * pageSize + 1 : 0;
  const issueListEnd = Math.min(page * pageSize, totalCount);

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="mx-auto flex w-full max-w-none flex-col gap-6">
        <InventoryBreadcrumbs />

        <section className="rounded-2xl border border-gray-200 bg-white p-6 shadow-sm">
          <div className="flex flex-wrap items-start justify-between gap-4">
            <div>
              <h1 className="text-xl font-bold text-gray-900">เบิกจ่าย</h1>
            </div>
            <button
              type="button"
              onClick={openCreateModal}
              className="inline-flex items-center gap-2 rounded-xl bg-blue-600 px-4 py-2 text-sm font-medium text-white shadow-sm transition hover:bg-blue-700"
            >
              <Plus className="h-4 w-4" />
              ทำใบเบิกจ่าย
            </button>
          </div>

          {message ? (
            <div className="mt-4 rounded-lg border border-blue-200 bg-blue-50 px-3 py-2 text-sm text-blue-800">
              {message}
            </div>
          ) : null}

          <div className="mt-4 flex flex-wrap items-end gap-3 rounded-xl border border-gray-200 bg-gray-50 px-3 py-3">
            <label className="w-full max-w-md text-sm text-gray-700">
              ค้นหา
              <input
                type="text"
                value={search}
                onChange={(event) => {
                  setSearch(event.target.value);
                  setPage(1);
                }}
                placeholder="เลขที่เอกสาร / หน่วยงาน / หมายเหตุ / สินค้า / LOT"
                className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2"
              />
            </label>

            <label className="text-sm text-gray-700">
              แถวต่อหน้า
              <select
                value={pageSize}
                onChange={(event) => {
                  setPageSize(Number(event.target.value));
                  setPage(1);
                }}
                className="mt-1 rounded-lg border border-gray-300 px-3 py-2"
              >
                {[10, 20, 50].map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
            </label>
          </div>

          <div className="mt-4 flex flex-wrap items-center justify-between gap-3 rounded-xl border border-gray-200 bg-gray-50 px-3 py-2 text-sm text-gray-700">
            <span>
              แสดง {issueListStart}-{issueListEnd} จาก {formatNumber(totalCount)} รายการ
            </span>
            <div className="flex items-center gap-2">
              <button
                type="button"
                onClick={() => setPage((current) => Math.max(1, current - 1))}
                disabled={page <= 1}
                className="rounded-lg border border-gray-300 bg-white px-3 py-1 text-sm text-gray-700 hover:bg-gray-100 disabled:cursor-not-allowed disabled:opacity-50"
              >
                ก่อนหน้า
              </button>
              <span className="whitespace-nowrap text-sm text-gray-600">
                หน้า {page} / {totalPages}
              </span>
              <button
                type="button"
                onClick={() => setPage((current) => Math.min(totalPages, current + 1))}
                disabled={page >= totalPages}
                className="rounded-lg border border-gray-300 bg-white px-3 py-1 text-sm text-gray-700 hover:bg-gray-100 disabled:cursor-not-allowed disabled:opacity-50"
              >
                ถัดไป
              </button>
            </div>
          </div>

          <div className="mt-4 overflow-x-auto rounded-xl border border-gray-200">
            <table className="min-w-full text-xs">
              <thead className="bg-gray-50 text-left text-gray-500">
                <tr>
                  <th className="px-3 py-2">เลขที่ใบเบิกจ่าย</th>
                  <th className="px-3 py-2">วันที่เบิก</th>
                  <th className="px-3 py-2">หน่วยงาน</th>
                  <th className="px-3 py-2 text-right">จำนวนรายการ</th>
                  <th className="px-3 py-2 text-right">มูลค่ารวม (บาท)</th>
                  <th className="px-3 py-2">หมายเหตุ</th>
                  <th className="px-3 py-2 text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100 bg-white">
                {loading ? (
                  <tr>
                    <td colSpan={7} className="px-3 py-6 text-center text-sm text-gray-500">
                      กำลังโหลดข้อมูล...
                    </td>
                  </tr>
                ) : issues.length === 0 ? (
                  <tr>
                    <td colSpan={7} className="px-3 py-6 text-center text-sm text-gray-500">
                      ไม่พบรายการใบเบิกจ่าย
                    </td>
                  </tr>
                ) : (
                  issues.map((issue) => (
                    <tr key={issue.id} className="hover:bg-gray-50">
                      <td className="px-3 py-2 align-top font-medium text-gray-900">{issue.issue_no}</td>
                      <td className="px-3 py-2 align-top text-gray-700">{formatDate(issue.issue_date)}</td>
                      <td className="px-3 py-2 align-top text-gray-700">
                        <div className="font-medium text-gray-900">{issue.department_name}</div>
                        <div className="text-[10px] text-gray-500">{issue.department_code}</div>
                      </td>
                      <td className="px-3 py-2 align-top text-right text-gray-700">{formatNumber(issue.total_items)}</td>
                      <td className="px-3 py-2 align-top text-right text-gray-700">{formatNumber(issue.total_value, 2)}</td>
                      <td className="px-3 py-2 align-top text-gray-700">{issue.note || '-'}</td>
                      <td className="px-3 py-2 align-top text-right">
                        <button
                          type="button"
                          onClick={() => openDetail(issue.id)}
                          aria-label="ดูรายละเอียด"
                          title="ดูรายละเอียด"
                          className="inline-flex h-8 w-8 items-center justify-center rounded-md border border-gray-300 text-gray-700 hover:bg-gray-100"
                        >
                          <Eye className="h-4 w-4" />
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
      {createOpen ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="max-h-[92vh] w-full max-w-6xl overflow-y-auto rounded-2xl border border-gray-200 bg-white p-5 shadow-xl">
            <div className="flex items-center justify-between gap-3">
              <h2 className="text-xl font-semibold text-gray-900">
                {formMode === 'edit' ? 'แก้ไขใบเบิกจ่าย' : 'ทำใบเบิกจ่าย'}
              </h2>
              <button
                type="button"
                onClick={() => setCreateOpen(false)}
                className="inline-flex h-9 w-9 items-center justify-center rounded-full border border-gray-300 text-gray-600 hover:bg-gray-100"
                aria-label="ปิด"
                title="ปิด"
              >
                <X className="h-4 w-4" />
              </button>
            </div>

            {createMessage ? (
              <div className="mt-4 rounded-lg border border-rose-200 bg-rose-50 px-3 py-2 text-sm text-rose-700">
                {createMessage}
              </div>
            ) : null}

            <div className="mt-5 grid grid-cols-1 gap-4 lg:grid-cols-4">
              <label className="text-sm text-gray-700">
                หน่วยงานที่ขอเบิก
                <select
                  value={requestingDepartmentId}
                  onChange={(event) => setRequestingDepartmentId(event.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2"
                >
                  <option value="">-- เลือกหน่วยงาน --</option>
                  {activeDepartments.map((department) => (
                    <option key={department.id} value={department.id}>
                      {department.department_code} - {department.name}
                    </option>
                  ))}
                </select>
              </label>

              <label className="text-sm text-gray-700">
                วันที่เบิก
                <input
                  type="date"
                  value={issueDate}
                  onChange={(event) => setIssueDate(event.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2"
                />
              </label>

              <label className="text-sm text-gray-700 lg:col-span-2">
                หมายเหตุ
                <input
                  type="text"
                  value={issueNote}
                  onChange={(event) => setIssueNote(event.target.value)}
                  placeholder="(ไม่บังคับ)"
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2"
                />
              </label>
            </div>

            <div className="relative mt-5">
              <label className="text-sm text-gray-700">ค้นหารายการสินค้าในคลัง</label>
              <input
                type="text"
                value={searchText}
                onChange={(event) => setSearchText(event.target.value)}
                onBlur={() => {
                  window.setTimeout(() => {
                    setLotOptions([]);
                    setActiveOptionIndex(-1);
                  }, 120);
                }}
                onKeyDown={(event) => {
                  if (lotOptions.length === 0) return;
                  if (event.key === 'ArrowDown') {
                    event.preventDefault();
                    setActiveOptionIndex((prev) => (prev + 1) % lotOptions.length);
                    return;
                  }
                  if (event.key === 'ArrowUp') {
                    event.preventDefault();
                    setActiveOptionIndex((prev) => (prev <= 0 ? lotOptions.length - 1 : prev - 1));
                    return;
                  }
                  if (event.key === 'Enter') {
                    event.preventDefault();
                    const selected = activeOptionIndex >= 0 ? lotOptions[activeOptionIndex] : lotOptions[0];
                    if (selected) addLotToIssue(selected);
                    return;
                  }
                  if (event.key === 'Escape') {
                    setLotOptions([]);
                    setActiveOptionIndex(-1);
                  }
                }}
                placeholder="พิมพ์รหัสสินค้า / ชื่อสินค้า / เลข lot"
                className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2"
              />

              <label className="mt-2 inline-flex items-center gap-2 text-sm text-gray-700">
                <input
                  type="checkbox"
                  checked={showOutOfStock}
                  onChange={(event) => setShowOutOfStock(event.target.checked)}
                  className="h-4 w-4 rounded border-gray-300"
                />
                แสดงสินค้าหมด
              </label>

              {searchingLots ? <p className="mt-1 text-xs text-gray-500">กำลังค้นหา...</p> : null}

              {lotOptions.length > 0 ? (
                <div className="absolute z-20 mt-1 max-h-64 w-full overflow-y-auto rounded-lg border border-gray-200 bg-white shadow-lg">
                  {lotOptions.map((lot, index) => {
                    const isOutOfStock = Number(lot.qty_on_hand) <= 0;
                    const isSelected = selectedItems.some((item) => item.stock_lot_id === lot.stock_lot_id);
                    const isDisabled = isOutOfStock || isSelected;

                    return (
                      <button
                        key={lot.stock_lot_id}
                        ref={(el) => {
                          searchOptionRefs.current[index] = el;
                        }}
                        type="button"
                        onClick={() => addLotToIssue(lot)}
                        disabled={isDisabled}
                        className={`block w-full border-b border-gray-100 px-3 py-2 text-left text-sm ${index === activeOptionIndex ? 'bg-blue-50' : ''} ${isDisabled ? 'cursor-not-allowed opacity-60' : 'hover:bg-gray-50'}`}
                      >
                        <div className="flex items-center justify-between gap-3">
                          <div>
                            <div className="font-medium text-gray-900">{lot.product_code} - {lot.product_name}</div>
                            <div className="mt-0.5 text-[10px] text-gray-500">
                              LOT {lot.lot_no} · รับเข้า {formatDate(lot.last_received_at)} · คงเหลือ {formatNumber(lot.qty_on_hand, 0)} {lot.unit || ''}
                            </div>
                          </div>
                          <span className={`rounded-full px-2 py-0.5 text-[10px] font-medium ${isOutOfStock ? 'bg-rose-100 text-rose-700' : isSelected ? 'bg-blue-100 text-blue-700' : 'bg-emerald-100 text-emerald-700'}`}>
                            {isOutOfStock ? 'หมด' : isSelected ? 'เพิ่มแล้ว' : 'เพิ่ม'}
                          </span>
                        </div>
                      </button>
                    );
                  })}
                </div>
              ) : null}
            </div>

            <div className="mt-5 overflow-x-auto rounded-xl border border-gray-200">
              <table className="min-w-full text-xs">
                <thead className="bg-gray-50 text-left text-gray-500">
                  <tr>
                    <th className="px-3 py-2">รหัสสินค้า</th>
                    <th className="px-3 py-2">สินค้า</th>
                    <th className="px-3 py-2">LOT</th>
                    <th className="px-3 py-2">วันรับเข้า</th>
                    <th className="px-3 py-2 text-right">คงเหลือ</th>
                    <th className="px-3 py-2 text-right">จำนวนเบิก</th>
                    <th className="px-3 py-2 text-right">จัดการ</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100 bg-white">
                  {selectedItems.length === 0 ? (
                    <tr>
                      <td colSpan={7} className="px-3 py-6 text-center text-gray-500">ยังไม่มีรายการที่เลือก</td>
                    </tr>
                  ) : (
                    selectedItems.map((item, index) => {
                      const isZeroStock = Number(item.qty_on_hand) <= 0;
                      return (
                        <tr key={item.stock_lot_id} className={isZeroStock ? 'bg-rose-50/50' : 'hover:bg-gray-50'}>
                          <td className="px-3 py-2 align-top font-medium text-gray-900">{item.product_code}</td>
                          <td className="px-3 py-2 align-top text-gray-700">
                            <div className="font-medium text-gray-900">{item.product_name}</div>
                            <div className="mt-0.5 text-[10px] text-gray-500">{[item.category, item.product_type, item.product_subtype].filter(Boolean).join(' - ') || '-'}</div>
                          </td>
                          <td className="px-3 py-2 align-top text-gray-700">{item.lot_no}</td>
                          <td className="px-3 py-2 align-top text-gray-700">{formatDate(item.last_received_at)}</td>
                          <td className={`px-3 py-2 align-top text-right ${isZeroStock ? 'font-semibold text-rose-700' : 'text-gray-700'}`}>{formatNumber(item.qty_on_hand, 0)}</td>
                          <td className="px-3 py-2 align-top text-right">
                            <div className="flex items-center justify-end gap-2">
                              <input
                                type="number"
                                min="0"
                                step="1"
                                max={item.qty_on_hand}
                                value={item.issued_qty}
                                disabled={isZeroStock}
                                onChange={(event) => updateSelectedItemQty(index, event.target.value)}
                                className="w-28 rounded-lg border border-gray-300 px-2 py-1 text-right disabled:bg-gray-100"
                              />
                              <span className="whitespace-nowrap text-[10px] text-gray-500">{item.unit || ''}</span>
                            </div>
                          </td>
                          <td className="px-3 py-2 text-right align-top">
                            <button
                              type="button"
                              onClick={() => removeSelectedItem(index)}
                              aria-label="ลบรายการ"
                              title="ลบรายการ"
                              className="inline-flex h-8 w-8 items-center justify-center rounded-md border border-red-300 text-red-700 hover:bg-red-50"
                            >
                              <Trash2 className="h-4 w-4" />
                            </button>
                          </td>
                        </tr>
                      );
                    })
                  )}
                </tbody>
              </table>
            </div>

            <div className="mt-4 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
              <p className="text-sm text-gray-700">รวม {formatNumber(selectedIssueTotalQty, 0)} | มูลค่าประมาณ {formatBaht(selectedIssueTotalValue)}</p>
              <div className="flex gap-2">
                <button type="button" onClick={resetCreateForm} className="rounded-lg border border-gray-300 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                  ล้างฟอร์ม
                </button>
                <button type="button" onClick={submitIssue} disabled={createSaving} className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700 disabled:cursor-not-allowed disabled:bg-gray-300">
                  {createSaving ? 'กำลังบันทึก...' : 'บันทึกใบเบิกจ่าย'}
                </button>
              </div>
            </div>
          </div>
        </div>
      ) : null}
      {selectedIssueId !== null ? (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
          <div className="max-h-[92vh] w-full max-w-6xl overflow-y-auto rounded-2xl border border-gray-200 bg-white p-5 shadow-xl">
            <div className="flex items-center justify-between gap-3">
              <div>
                <h2 className="text-xl font-semibold text-gray-900">รายละเอียดใบเบิกจ่าย</h2>
                <p className="mt-1 text-sm text-gray-500">{selectedIssue?.issue.issue_no || '-'}</p>
              </div>
              <div className="flex items-center gap-2">
                <button
                  type="button"
                  onClick={openIssueEditFromDetail}
                  className="rounded-full border border-gray-300 px-3 py-1 text-sm text-gray-700 hover:bg-gray-100"
                >
                  แก้ไข
                </button>
                <button
                  type="button"
                  onClick={closeDetail}
                  className="inline-flex h-9 w-9 items-center justify-center rounded-full border border-gray-300 text-gray-600 hover:bg-gray-100"
                  aria-label="ปิด"
                  title="ปิด"
                >
                  <X className="h-4 w-4" />
                </button>
              </div>
            </div>

            {detailMessage ? (
              <div className="mt-4 rounded-lg border border-rose-200 bg-rose-50 px-3 py-2 text-sm text-rose-700">{detailMessage}</div>
            ) : null}

            {detailLoading ? (
              <div className="mt-4 rounded-lg border border-gray-200 bg-gray-50 px-3 py-6 text-center text-sm text-gray-500">
                กำลังโหลดรายละเอียดใบเบิกจ่าย...
              </div>
            ) : selectedIssue ? (
              <>
                <div className="mt-5 grid grid-cols-1 gap-3 md:grid-cols-2 lg:grid-cols-4">
                  <div className="rounded-xl border border-gray-200 bg-gray-50 px-3 py-2">
                    <div className="text-[10px] uppercase tracking-wide text-gray-500">เลขที่เอกสาร</div>
                    <div className="mt-1 text-sm font-medium text-gray-900">{selectedIssue.issue.issue_no}</div>
                  </div>
                  <div className="rounded-xl border border-gray-200 bg-gray-50 px-3 py-2">
                    <div className="text-[10px] uppercase tracking-wide text-gray-500">วันที่เบิก</div>
                    <div className="mt-1 text-sm font-medium text-gray-900">{formatDate(selectedIssue.issue.issue_date)}</div>
                  </div>
                  <div className="rounded-xl border border-gray-200 bg-gray-50 px-3 py-2">
                    <div className="text-[10px] uppercase tracking-wide text-gray-500">หน่วยงาน</div>
                    <div className="mt-1 text-sm font-medium text-gray-900">{selectedIssue.issue.department_name}</div>
                    <div className="text-[10px] text-gray-500">{selectedIssue.issue.department_code}</div>
                  </div>
                  <div className="rounded-xl border border-gray-200 bg-gray-50 px-3 py-2">
                    <div className="text-[10px] uppercase tracking-wide text-gray-500">สรุป</div>
                    <div className="mt-1 text-sm font-medium text-gray-900">
                      {formatNumber(selectedIssue.issue.total_items, 0)} รายการ {formatNumber(selectedIssue.issue.total_qty, 0)} ชิ้น
                    </div>
                  </div>
                </div>

                {selectedIssue.issue.note ? (
                  <div className="mt-4 rounded-xl border border-gray-200 px-3 py-2 text-sm text-gray-700">{selectedIssue.issue.note}</div>
                ) : null}

                <div className="mt-5 overflow-x-auto rounded-xl border border-gray-200">
                  <table className="min-w-full text-xs">
                    <thead className="bg-gray-50 text-left text-gray-500">
                      <tr>
                        <th className="px-3 py-2">รหัสสินค้า</th>
                        <th className="px-3 py-2">สินค้า</th>
                        <th className="px-3 py-2">LOT</th>
                        <th className="px-3 py-2 text-right">จำนวนเบิก</th>
                        <th className="px-3 py-2 text-right">คงเหลือ</th>
                        <th className="px-3 py-2 text-right">มูลค่า</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100 bg-white">
                      {selectedIssue.items.length === 0 ? (
                        <tr>
                          <td colSpan={6} className="px-3 py-6 text-center text-gray-500">ไม่พบรายการสินค้า</td>
                        </tr>
                      ) : (
                        selectedIssue.items.map((item) => (
                          <tr key={item.id} className="hover:bg-gray-50">
                            <td className="px-3 py-2 align-top font-medium text-gray-900">{item.product_code}</td>
                            <td className="px-3 py-2 align-top text-gray-700">
                              <div className="font-medium text-gray-900">{item.product_name}</div>
                              <div className="mt-0.5 text-[10px] text-gray-500">{[item.category, item.product_type, item.product_subtype].filter(Boolean).join(' - ') || '-'}</div>
                            </td>
                            <td className="px-3 py-2 align-top text-gray-700">{item.lot_no}</td>
                            <td className="px-3 py-2 align-top text-right text-gray-700">{formatNumber(item.issued_qty, 0)}</td>
                            <td className="px-3 py-2 align-top text-right text-gray-700">{formatNumber(item.qty_on_hand, 0)}</td>
                            <td className="px-3 py-2 align-top text-right text-gray-700">{formatBaht(item.total_value)}</td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </>
            ) : null}
          </div>
        </div>
      ) : null}
    </div>
  );
}
