'use client';

import { useEffect, useMemo, useRef, useState } from 'react';
import { Eye, Plus, Trash2, X, XCircle } from 'lucide-react';
import { InventoryBreadcrumbs } from '../_components/inventory-breadcrumbs';
import { SortableHeader } from '../_components/sortable-header';
import { formatBaht } from '@/lib/format-baht';

type DepartmentOption = { id: number; name: string; department_code: string; is_active: boolean };
type IssueListRow = { id: number; issue_no: string; issue_date: string; requesting_department_id: number; department_name: string; department_code: string; note: string | null; total_items: number; total_qty: number; total_value: number; created_at: string };
type IssueDetailItem = { id: number; stock_lot_id: number; issued_qty: number; unit_price: number; total_value: number; product_id: number; product_code: string; product_name: string; category: string | null; product_type: string | null; product_subtype: string | null; unit: string | null; lot_no: string; qty_on_hand: number; last_received_at: string | null; current_budget_quota: number; issued_qty_current_budget_year: number };
type IssueDetailResponse = { issue: IssueListRow; items: IssueDetailItem[] };
type LotOption = { stock_lot_id: number; product_id: number; product_code: string; product_name: string; category: string | null; product_type: string | null; product_subtype: string | null; unit: string | null; lot_no: string; qty_on_hand: number; total_value: number; avg_unit_price: number; last_received_at: string | null; current_budget_quota: number; issued_qty_current_budget_year: number };
type IssueFormItem = LotOption & { issued_qty: string; original_issued_qty: number };
type ApiResponse<T> = { success: boolean; data: T; totalCount?: number; error?: string; message?: string };
type SortOrder = 'asc' | 'desc';
type IssueListSortKey = 'issue_no' | 'issue_date' | 'requesting_department' | 'total_items' | 'total_value' | 'note';
type IssueFormSortKey = 'product_code' | 'product_name' | 'lot_no' | 'last_received_at' | 'qty_on_hand' | 'issued_qty';
type IssueDetailSortKey = 'product_code' | 'product_name' | 'lot_no' | 'issued_qty' | 'qty_on_hand' | 'total_value';

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

function escapeHtml(value: string) {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

function compareMixedValues(left: string | number | null | undefined, right: string | number | null | undefined) {
  if (typeof left === 'number' || typeof right === 'number') {
    return Number(left ?? 0) - Number(right ?? 0);
  }

  const leftValue = String(left ?? '').trim();
  const rightValue = String(right ?? '').trim();
  return leftValue.localeCompare(rightValue, 'th');
}

function toggleSort(currentKey: string, currentOrder: SortOrder, nextKey: string): SortOrder {
  if (currentKey !== nextKey) return 'asc';
  return currentOrder === 'asc' ? 'desc' : 'asc';
}

export default function InventoryIssuesPage() {
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');
  const [issues, setIssues] = useState<IssueListRow[]>([]);
  const [departments, setDepartments] = useState<DepartmentOption[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<string[]>([]);
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
  const [categoryFilter, setCategoryFilter] = useState('');
  const [issueNote, setIssueNote] = useState('');
  const [searchText, setSearchText] = useState('');
  const [usagePlanOnly, setUsagePlanOnly] = useState(false);
  const [lotOptions, setLotOptions] = useState<LotOption[]>([]);
  const [searchingLots, setSearchingLots] = useState(false);
  const [activeOptionIndex, setActiveOptionIndex] = useState(-1);
  const [selectedItems, setSelectedItems] = useState<IssueFormItem[]>([]);
  const [selectedIssueId, setSelectedIssueId] = useState<number | null>(null);
  const [selectedIssue, setSelectedIssue] = useState<IssueDetailResponse | null>(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [detailMessage, setDetailMessage] = useState('');
  const [issueSortBy, setIssueSortBy] = useState<IssueListSortKey>('issue_date');
  const [issueSortOrder, setIssueSortOrder] = useState<SortOrder>('desc');
  const [selectedItemSortBy, setSelectedItemSortBy] = useState<IssueFormSortKey>('product_code');
  const [selectedItemSortOrder, setSelectedItemSortOrder] = useState<SortOrder>('asc');
  const [detailSortBy, setDetailSortBy] = useState<IssueDetailSortKey>('product_code');
  const [detailSortOrder, setDetailSortOrder] = useState<SortOrder>('asc');
  const searchOptionRefs = useRef<Array<HTMLButtonElement | null>>([]);

  const totalPages = useMemo(() => Math.max(1, Math.ceil(totalCount / pageSize)), [totalCount, pageSize]);
  const selectedIssueTotalQty = useMemo(() => selectedItems.reduce((sum, item) => sum + Number(item.issued_qty || 0), 0), [selectedItems]);
  const selectedIssueTotalValue = useMemo(() => selectedItems.reduce((sum, item) => sum + Number(item.issued_qty || 0) * Number(item.avg_unit_price || 0), 0), [selectedItems]);
  const activeDepartments = useMemo(() => departments.filter((department) => department.is_active).slice().sort((a, b) => `${a.department_code} ${a.name}`.localeCompare(`${b.department_code} ${b.name}`)), [departments]);
  const selectedDepartment = useMemo(
    () => activeDepartments.find((department) => String(department.id) === requestingDepartmentId) ?? null,
    [activeDepartments, requestingDepartmentId]
  );
  const sortedSelectedItems = useMemo(() => {
    const items = [...selectedItems];
    items.sort((left, right) => {
      const direction = selectedItemSortOrder === 'asc' ? 1 : -1;
      const result = (() => {
        switch (selectedItemSortBy) {
          case 'product_code':
            return compareMixedValues(left.product_code, right.product_code);
          case 'product_name':
            return compareMixedValues(left.product_name, right.product_name);
          case 'lot_no':
            return compareMixedValues(left.lot_no, right.lot_no);
          case 'last_received_at':
            return compareMixedValues(left.last_received_at, right.last_received_at);
          case 'qty_on_hand':
            return compareMixedValues(Number(left.qty_on_hand), Number(right.qty_on_hand));
          case 'issued_qty':
            return compareMixedValues(Number(left.issued_qty || 0), Number(right.issued_qty || 0));
          default:
            return 0;
        }
      })();
      if (result !== 0) return result * direction;
      return compareMixedValues(left.product_code, right.product_code);
    });
    return items;
  }, [selectedItems, selectedItemSortBy, selectedItemSortOrder]);
  const sortedDetailItems = useMemo(() => {
    if (!selectedIssue) return [];
    const items = [...selectedIssue.items];
    items.sort((left, right) => {
      const direction = detailSortOrder === 'asc' ? 1 : -1;
      const result = (() => {
        switch (detailSortBy) {
          case 'product_code':
            return compareMixedValues(left.product_code, right.product_code);
          case 'product_name':
            return compareMixedValues(left.product_name, right.product_name);
          case 'lot_no':
            return compareMixedValues(left.lot_no, right.lot_no);
          case 'issued_qty':
            return compareMixedValues(Number(left.issued_qty), Number(right.issued_qty));
          case 'qty_on_hand':
            return compareMixedValues(Number(left.qty_on_hand), Number(right.qty_on_hand));
          case 'total_value':
            return compareMixedValues(Number(left.total_value), Number(right.total_value));
          default:
            return 0;
        }
      })();
      if (result !== 0) return result * direction;
      return compareMixedValues(left.product_code, right.product_code);
    });
    return items;
  }, [detailSortBy, detailSortOrder, selectedIssue]);

  const fetchIssues = async () => {
    const params = new URLSearchParams({
      page: String(page),
      page_size: String(pageSize),
      order_by: issueSortBy,
      sort_order: issueSortOrder,
    });
    if (search.trim()) params.set('search', search.trim());
    const response = await fetch(`/api/inventory/issues?${params.toString()}`);
    const payload: ApiResponse<IssueListRow[]> = await response.json();
    if (!response.ok || !payload.success) throw new Error(payload.error || 'โหลดรายการใบเบิกจ่ายไม่สำเร็จ');
    setIssues(payload.data || []);
    setTotalCount(payload.totalCount || 0);
  };

  useEffect(() => {
    const loadFormOptions = async () => {
      try {
        const [departmentResponse, stockResponse] = await Promise.all([
          fetch('/api/departments?page_size=200'),
          fetch('/api/inventory/stock?page_size=1'),
        ]);

        const departmentPayload: ApiResponse<DepartmentOption[]> = await departmentResponse.json();
        if (!departmentResponse.ok || !departmentPayload.success) {
          throw new Error(departmentPayload.error || 'โหลดหน่วยงานไม่สำเร็จ');
        }

        const stockPayload: ApiResponse<{ filters?: { categories?: string[] } }> = await stockResponse.json();
        if (!stockResponse.ok || !stockPayload.success) {
          throw new Error(stockPayload.error || 'โหลดหมวดสินค้าไม่สำเร็จ');
        }

        setDepartments(departmentPayload.data || []);
        setCategoryOptions(Array.isArray(stockPayload.data?.filters?.categories) ? stockPayload.data.filters.categories : []);
      } catch (error) {
        console.error(error);
        setDepartments([]);
        setCategoryOptions([]);
        setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการโหลดหน่วยงาน');
      }
    };
    loadFormOptions();
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
  }, [issueSortBy, issueSortOrder, page, pageSize, search]);

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
    if (usagePlanOnly && !selectedDepartment) {
      setLotOptions([]);
      setActiveOptionIndex(-1);
      return;
    }
    const timeout = window.setTimeout(async () => {
      try {
        setSearchingLots(true);
        const params = new URLSearchParams({ search: q, page_size: '20', sort_order: 'asc' });
        if (selectedDepartment) {
          params.set('requesting_department_id', String(selectedDepartment.id));
        }
        if (categoryFilter.trim()) {
          params.set('category', categoryFilter.trim());
        }
        if (usagePlanOnly && selectedDepartment) {
          params.set('usage_plan_only', 'true');
        }
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
  }, [categoryFilter, searchText, selectedDepartment, usagePlanOnly]);

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
    setCategoryFilter('');
    setIssueNote('');
    setSearchText('');
    setUsagePlanOnly(false);
    setLotOptions([]);
    setActiveOptionIndex(-1);
    setSelectedItems([]);
    setSelectedItemSortBy('product_code');
    setSelectedItemSortOrder('asc');
    setCreateOpen(true);
  };

  const resetCreateForm = () => {
    setFormMode('create');
    setFormIssueId(null);
    setIssueDate(new Date().toISOString().slice(0, 10));
    setRequestingDepartmentId('');
    setCategoryFilter('');
    setIssueNote('');
    setSearchText('');
    setUsagePlanOnly(false);
    setLotOptions([]);
    setActiveOptionIndex(-1);
    setSelectedItems([]);
    setSelectedItemSortBy('product_code');
    setSelectedItemSortOrder('asc');
    setCreateMessage('');
  };

  const addLotToIssue = (lot: LotOption) => {
    if (Number(lot.qty_on_hand) <= 0) return;
    setSelectedItems((prev) => {
      if (prev.some((item) => item.stock_lot_id === lot.stock_lot_id)) return prev;
      return [...prev, { ...lot, issued_qty: '1', original_issued_qty: 0 }];
    });
  };

  const updateSelectedItemQty = (stockLotId: number, value: string) => {
    setSelectedItems((prev) =>
      prev.map((item) => {
        if (item.stock_lot_id !== stockLotId) return item;
        const raw = value.trim();
        if (raw === '') return { ...item, issued_qty: '' };
        const nextValue = Math.max(0, Number(raw));
        const maxQty = effectiveAvailableQty(item);
        return { ...item, issued_qty: String(Math.min(nextValue, maxQty)) };
      })
    );
  };

  const removeSelectedItem = (stockLotId: number) => {
    setSelectedItems((prev) => prev.filter((item) => item.stock_lot_id !== stockLotId));
  };

  const effectiveAvailableQty = (item: IssueFormItem) => Number(item.qty_on_hand) + Number(item.original_issued_qty || 0);

  const clearLotSearch = () => {
    setSearchText('');
    setLotOptions([]);
    setActiveOptionIndex(-1);
  };

  const openEditModal = (issue: IssueDetailResponse) => {
    setFormMode('edit');
    setFormIssueId(issue.issue.id);
    setCreateMessage('');
    setIssueDate(issue.issue.issue_date.slice(0, 10));
    setRequestingDepartmentId(String(issue.issue.requesting_department_id));
    setCategoryFilter('');
    setIssueNote(issue.issue.note || '');
    setSearchText('');
    setUsagePlanOnly(false);
    setLotOptions([]);
    setActiveOptionIndex(-1);
    setSelectedItemSortBy('product_code');
    setSelectedItemSortOrder('asc');
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
        current_budget_quota: Number(item.current_budget_quota || 0),
        issued_qty_current_budget_year: Number(item.issued_qty_current_budget_year || 0),
      }))
    );
    setCreateOpen(true);
  };

  const handleIssueSort = (sortKey: IssueListSortKey) => {
    setIssueSortOrder((currentOrder) => toggleSort(issueSortBy, currentOrder, sortKey));
    setIssueSortBy(sortKey);
    setPage(1);
  };

  const handleSelectedItemSort = (sortKey: IssueFormSortKey) => {
    setSelectedItemSortOrder((currentOrder) => toggleSort(selectedItemSortBy, currentOrder, sortKey));
    setSelectedItemSortBy(sortKey);
  };

  const handleDetailSort = (sortKey: IssueDetailSortKey) => {
    setDetailSortOrder((currentOrder) => toggleSort(detailSortBy, currentOrder, sortKey));
    setDetailSortBy(sortKey);
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

  const previewIssueDocument = () => {
    if (!selectedIssue) return;

    const totalQty = selectedIssue.items.reduce((sum, item) => sum + Number(item.issued_qty || 0), 0);
    const totalValue = selectedIssue.items.reduce((sum, item) => sum + Number(item.total_value || 0), 0);
    const rowsHtml = sortedDetailItems
      .map((item, index) => {
        const lineTotal = Number(item.total_value || 0);
        return `
          <tr>
            <td class="cell cell-center">${index + 1}</td>
            <td class="cell">${escapeHtml(item.product_code)}</td>
            <td class="cell">${escapeHtml(item.product_name)}</td>
            <td class="cell">${escapeHtml(item.lot_no)}</td>
            <td class="cell cell-right">${formatNumber(item.issued_qty, 0)}</td>
            <td class="cell cell-right">${formatNumber(lineTotal, 2)}</td>
          </tr>
        `;
      })
      .join('');

    const issueNo = escapeHtml(selectedIssue.issue.issue_no || '-');
    const issueDate = escapeHtml(formatDate(selectedIssue.issue.issue_date));
    const department = escapeHtml(`${selectedIssue.issue.department_name} (${selectedIssue.issue.department_code})`);
    const note = selectedIssue.issue.note ? escapeHtml(selectedIssue.issue.note) : '-';
    const popup = window.open('', '_blank');

    if (!popup) {
      setDetailMessage('ไม่สามารถเปิดหน้าพรีวิวได้ กรุณาอนุญาต pop-up ของเบราว์เซอร์');
      return;
    }

    const html = `<!doctype html>
<html lang="th">
  <head>
    <meta charset="utf-8" />
    <title>พรีวิวใบเบิกจ่าย ${issueNo}</title>
    <style>
      @page { size: A4 portrait; margin: 12mm; }
      * { box-sizing: border-box; }
      body { margin: 0; color: #111827; font-family: "Sarabun", Tahoma, Arial, sans-serif; background: #f3f4f6; }
      .toolbar { display: flex; justify-content: flex-end; padding: 10px 12px; background: #e5e7eb; border-bottom: 1px solid #d1d5db; }
      .toolbar button { border: 1px solid #1d4ed8; background: #2563eb; color: #fff; border-radius: 6px; padding: 6px 12px; font-size: 12px; cursor: pointer; }
      .page { width: 210mm; min-height: 297mm; margin: 12px auto; background: #fff; padding: 14mm; border: 1px solid #d1d5db; }
      .title { margin: 0 0 12px 0; text-align: center; font-size: 22px; font-weight: 700; }
      .head-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px 16px; margin-bottom: 12px; }
      .head-item { font-size: 13px; }
      .label { color: #4b5563; margin-right: 4px; }
      .value { font-weight: 600; }
      .note { margin: 10px 0 14px; font-size: 13px; }
      .section-title { margin: 0 0 8px 0; font-size: 14px; font-weight: 700; }
      table { width: 100%; border-collapse: collapse; font-size: 12px; }
      th, td { border: 1px solid #9ca3af; padding: 6px 7px; vertical-align: top; }
      th { background: #f3f4f6; font-weight: 700; text-align: left; }
      .cell-right { text-align: right; white-space: nowrap; }
      .cell-center { text-align: center; white-space: nowrap; }
      .summary { margin-top: 12px; display: flex; justify-content: flex-end; }
      .summary-box { min-width: 300px; border: 1px solid #9ca3af; }
      .summary-row { display: flex; justify-content: space-between; padding: 6px 10px; font-size: 12px; border-bottom: 1px solid #d1d5db; }
      .summary-row:last-child { border-bottom: 0; font-weight: 700; background: #f9fafb; }
      @media print {
        body { background: #fff; }
        .toolbar { display: none; }
        .page { margin: 0; border: 0; width: auto; min-height: auto; padding: 0; }
      }
    </style>
  </head>
  <body>
    <div class="toolbar">
      <button onclick="window.print()">พิมพ์เอกสาร</button>
    </div>
    <main class="page">
      <h1 class="title">ใบเบิกจ่ายสินค้า</h1>
      <section class="head-grid">
        <div class="head-item"><span class="label">เลขที่เอกสาร:</span><span class="value">${issueNo}</span></div>
        <div class="head-item"><span class="label">วันที่เบิก:</span><span class="value">${issueDate}</span></div>
        <div class="head-item"><span class="label">หน่วยงานที่เบิก:</span><span class="value">${department}</span></div>
        <div class="head-item"><span class="label">จำนวนรายการ:</span><span class="value">${formatNumber(selectedIssue.items.length, 0)} รายการ</span></div>
      </section>
      <section class="note"><span class="label">หมายเหตุ:</span><span class="value">${note}</span></section>
      <section>
        <h2 class="section-title">รายการที่เบิก</h2>
        <table>
          <thead>
            <tr>
              <th class="cell-center">ลำดับ</th>
              <th>รหัสสินค้า</th>
              <th>รายการ</th>
              <th>LOT</th>
              <th class="cell-right">จำนวนเบิก</th>
              <th class="cell-right">มูลค่า (บาท)</th>
            </tr>
          </thead>
          <tbody>
            ${rowsHtml || '<tr><td colspan="6" class="cell-center">ไม่พบรายการ</td></tr>'}
          </tbody>
        </table>
      </section>
      <section class="summary">
        <div class="summary-box">
          <div class="summary-row"><span>ผลรวมจำนวนเบิก</span><span>${formatNumber(totalQty, 0)} ชิ้น</span></div>
          <div class="summary-row"><span>ผลรวมมูลค่า</span><span>${formatNumber(totalValue, 2)} บาท</span></div>
        </div>
      </section>
    </main>
  </body>
</html>`;

    popup.document.open();
    popup.document.write(html);
    popup.document.close();
    popup.focus();
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
                  <th className="px-3 py-2">
                    <SortableHeader label="เลขที่ใบเบิกจ่าย" sortKey="issue_no" activeKey={issueSortBy} activeOrder={issueSortOrder} onSort={(key) => handleIssueSort(key as IssueListSortKey)} />
                  </th>
                  <th className="px-3 py-2">
                    <SortableHeader label="วันที่เบิก" sortKey="issue_date" activeKey={issueSortBy} activeOrder={issueSortOrder} onSort={(key) => handleIssueSort(key as IssueListSortKey)} />
                  </th>
                  <th className="px-3 py-2">
                    <SortableHeader label="หน่วยงาน" sortKey="requesting_department" activeKey={issueSortBy} activeOrder={issueSortOrder} onSort={(key) => handleIssueSort(key as IssueListSortKey)} />
                  </th>
                  <th className="px-3 py-2 text-right">
                    <SortableHeader label="จำนวนรายการ" sortKey="total_items" activeKey={issueSortBy} activeOrder={issueSortOrder} onSort={(key) => handleIssueSort(key as IssueListSortKey)} align="right" />
                  </th>
                  <th className="px-3 py-2 text-right">
                    <SortableHeader label="มูลค่ารวม (บาท)" sortKey="total_value" activeKey={issueSortBy} activeOrder={issueSortOrder} onSort={(key) => handleIssueSort(key as IssueListSortKey)} align="right" />
                  </th>
                  <th className="px-3 py-2">
                    <SortableHeader label="หมายเหตุ" sortKey="note" activeKey={issueSortBy} activeOrder={issueSortOrder} onSort={(key) => handleIssueSort(key as IssueListSortKey)} />
                  </th>
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
                  onChange={(event) => {
                    setRequestingDepartmentId(event.target.value);
                    setCreateMessage('');
                    setSearchText('');
                    setLotOptions([]);
                    setActiveOptionIndex(-1);
                  }}
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
                หมวดสินค้า
                <select
                  value={categoryFilter}
                  onChange={(event) => {
                    setCategoryFilter(event.target.value);
                    setSearchText('');
                    setLotOptions([]);
                    setActiveOptionIndex(-1);
                  }}
                  className="mt-1 w-full rounded-lg border border-gray-300 px-3 py-2"
                >
                  <option value="">-- ทุกหมวดสินค้า --</option>
                  {categoryOptions.map((category) => (
                    <option key={category} value={category}>
                      {category}
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

              <label className="text-sm text-gray-700">
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
              <div className="relative mt-1">
                <input
                  type="text"
                  value={searchText}
                  onChange={(event) => setSearchText(event.target.value)}
                  disabled={!selectedDepartment}
                  onBlur={() => {
                    window.setTimeout(() => {
                      setLotOptions([]);
                      setActiveOptionIndex(-1);
                    }, 120);
                  }}
                  onFocus={() => {
                    if (!selectedDepartment) {
                      setCreateMessage('กรุณาเลือกหน่วยงานที่ขอเบิกก่อนค้นหารายการสินค้า');
                    }
                  }}
                  onKeyDown={(event) => {
                    if (!selectedDepartment) {
                      event.preventDefault();
                      setCreateMessage('กรุณาเลือกหน่วยงานที่ขอเบิกก่อนค้นหารายการสินค้า');
                      return;
                    }
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
                  placeholder={selectedDepartment ? 'พิมพ์รหัสสินค้า / ชื่อสินค้า / เลข lot' : 'เลือกหน่วยงานก่อนค้นหารายการสินค้า'}
                  className="w-full rounded-lg border border-gray-300 px-3 py-2 pr-10 disabled:cursor-not-allowed disabled:bg-gray-100 disabled:text-gray-500"
                />
                {searchText ? (
                  <button
                    type="button"
                    onClick={clearLotSearch}
                    aria-label="ล้างการค้นหา"
                    title="ล้างการค้นหา"
                    className="absolute right-2 top-1/2 inline-flex h-6 w-6 -translate-y-1/2 items-center justify-center rounded-full text-gray-400 transition hover:bg-gray-100 hover:text-gray-700"
                  >
                    <XCircle className="h-4 w-4" />
                  </button>
                ) : null}
              </div>

              {!selectedDepartment ? (
                <p className="mt-1 text-xs text-amber-600">กรุณาเลือกหน่วยงานที่ขอเบิกก่อน ถึงจะค้นหารายการสินค้าได้</p>
              ) : null}

              <div className="mt-2 flex flex-wrap items-center gap-x-5 gap-y-2">
                <label className="inline-flex items-center gap-2 text-sm text-gray-700">
                  <input
                    type="checkbox"
                    checked={usagePlanOnly}
                    onChange={(event) => setUsagePlanOnly(event.target.checked)}
                    className="h-4 w-4 rounded border-gray-300"
                  />
                  <span>ค้นหาเฉพาะรายการสินค้าที่หน่วยงานทำแผนการใช้</span>
                </label>
              </div>

              {usagePlanOnly && !selectedDepartment ? (
                <p className="mt-1 text-xs text-amber-600">กรุณาเลือกหน่วยงานที่ขอเบิกก่อนใช้ตัวกรองตามแผนการใช้</p>
              ) : null}

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
                    <th className="px-3 py-2">
                      <SortableHeader label="รหัสสินค้า" sortKey="product_code" activeKey={selectedItemSortBy} activeOrder={selectedItemSortOrder} onSort={(key) => handleSelectedItemSort(key as IssueFormSortKey)} />
                    </th>
                    <th className="px-3 py-2">
                      <SortableHeader label="สินค้า" sortKey="product_name" activeKey={selectedItemSortBy} activeOrder={selectedItemSortOrder} onSort={(key) => handleSelectedItemSort(key as IssueFormSortKey)} />
                    </th>
                    <th className="px-3 py-2">
                      <SortableHeader label="LOT" sortKey="lot_no" activeKey={selectedItemSortBy} activeOrder={selectedItemSortOrder} onSort={(key) => handleSelectedItemSort(key as IssueFormSortKey)} />
                    </th>
                    <th className="px-3 py-2">
                      <SortableHeader label="วันรับเข้า" sortKey="last_received_at" activeKey={selectedItemSortBy} activeOrder={selectedItemSortOrder} onSort={(key) => handleSelectedItemSort(key as IssueFormSortKey)} />
                    </th>
                    <th className="px-3 py-2 text-right">
                      <SortableHeader label="คงเหลือในคลัง" sortKey="qty_on_hand" activeKey={selectedItemSortBy} activeOrder={selectedItemSortOrder} onSort={(key) => handleSelectedItemSort(key as IssueFormSortKey)} align="right" />
                    </th>
                    <th className="px-3 py-2 text-right">โควต้าปีงบปัจจุบัน</th>
                    <th className="px-3 py-2 text-right">เบิกไปแล้ว</th>
                    <th className="px-3 py-2 text-right">
                      <SortableHeader label="ขอเบิกครั้งนี้" sortKey="issued_qty" activeKey={selectedItemSortBy} activeOrder={selectedItemSortOrder} onSort={(key) => handleSelectedItemSort(key as IssueFormSortKey)} align="right" />
                    </th>
                    <th className="px-3 py-2 text-right">จัดการ</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100 bg-white">
                  {selectedItems.length === 0 ? (
                    <tr>
                      <td colSpan={9} className="px-3 py-6 text-center text-gray-500">ยังไม่มีรายการที่เลือก</td>
                    </tr>
                  ) : (
                    sortedSelectedItems.map((item) => {
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
                          <td className="px-3 py-2 align-top text-right text-gray-700">{formatNumber(item.current_budget_quota, 0)}</td>
                          <td className="px-3 py-2 align-top text-right text-gray-700">{formatNumber(item.issued_qty_current_budget_year, 0)}</td>
                          <td className="px-3 py-2 align-top text-right">
                            <div className="flex items-center justify-end gap-2">
                              <input
                                type="number"
                                min="0"
                                step="1"
                                max={item.qty_on_hand}
                                value={item.issued_qty}
                                disabled={isZeroStock}
                                onChange={(event) => updateSelectedItemQty(item.stock_lot_id, event.target.value)}
                                className="w-28 rounded-lg border border-gray-300 px-2 py-1 text-right disabled:bg-gray-100"
                              />
                              <span className="whitespace-nowrap text-[10px] text-gray-500">{item.unit || ''}</span>
                            </div>
                          </td>
                          <td className="px-3 py-2 text-right align-top">
                            <button
                              type="button"
                              onClick={() => removeSelectedItem(item.stock_lot_id)}
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
                  onClick={previewIssueDocument}
                  className="rounded-full border border-indigo-300 px-3 py-1 text-sm text-indigo-700 hover:bg-indigo-50"
                >
                  พิมพ์เอกสาร
                </button>
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
                        <th className="px-3 py-2">
                          <SortableHeader label="รหัสสินค้า" sortKey="product_code" activeKey={detailSortBy} activeOrder={detailSortOrder} onSort={(key) => handleDetailSort(key as IssueDetailSortKey)} />
                        </th>
                        <th className="px-3 py-2">
                          <SortableHeader label="สินค้า" sortKey="product_name" activeKey={detailSortBy} activeOrder={detailSortOrder} onSort={(key) => handleDetailSort(key as IssueDetailSortKey)} />
                        </th>
                        <th className="px-3 py-2">
                          <SortableHeader label="LOT" sortKey="lot_no" activeKey={detailSortBy} activeOrder={detailSortOrder} onSort={(key) => handleDetailSort(key as IssueDetailSortKey)} />
                        </th>
                        <th className="px-3 py-2 text-right">
                          <SortableHeader label="จำนวนเบิก" sortKey="issued_qty" activeKey={detailSortBy} activeOrder={detailSortOrder} onSort={(key) => handleDetailSort(key as IssueDetailSortKey)} align="right" />
                        </th>
                        <th className="px-3 py-2 text-right">
                          <SortableHeader label="คงเหลือ" sortKey="qty_on_hand" activeKey={detailSortBy} activeOrder={detailSortOrder} onSort={(key) => handleDetailSort(key as IssueDetailSortKey)} align="right" />
                        </th>
                        <th className="px-3 py-2 text-right">
                          <SortableHeader label="มูลค่า" sortKey="total_value" activeKey={detailSortBy} activeOrder={detailSortOrder} onSort={(key) => handleDetailSort(key as IssueDetailSortKey)} align="right" />
                        </th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100 bg-white">
                      {selectedIssue.items.length === 0 ? (
                        <tr>
                          <td colSpan={6} className="px-3 py-6 text-center text-gray-500">ไม่พบรายการสินค้า</td>
                        </tr>
                      ) : (
                        sortedDetailItems.map((item) => (
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
