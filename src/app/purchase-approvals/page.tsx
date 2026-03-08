'use client';

import { useEffect, useMemo, useRef, useState } from 'react';
import Swal from 'sweetalert2';
import { Pencil, Search, Trash2, X } from 'lucide-react';

const getCurrentBudgetYear = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

const getTodayDateInputValue = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const formatNumberWithComma = (value?: number | null, fractionDigits = 0) => {
  if (value === null || value === undefined || Number.isNaN(Number(value))) {
    return '';
  }
  return Number(value).toLocaleString('en-US', {
    minimumFractionDigits: fractionDigits,
    maximumFractionDigits: fractionDigits,
  });
};

interface PurchaseApprovalFormData {
  approvalId?: string;
  department?: string;
  budgetYear?: string;
  recordNumber?: string;
  requestDate?: string;
  productName?: string;
  productCode?: string;
  category?: string;
  productType?: string;
  productSubtype?: string;
  requestedQuantity?: number | null;
  unit?: string;
  pricePerUnit?: number;
  totalValue?: number;
  overPlanCase?: string;
  requester?: string;
  approver?: string;
}

interface PurchaseApprovalItem extends PurchaseApprovalFormData {
  id: number;
  created_at?: string;
  updated_at?: string;
}

interface PurchasePlanOption {
  id: number;
  productCode?: string | null;
  productName?: string | null;
  category?: string | null;
  productType?: string | null;
  productSubtype?: string | null;
  unit?: string | null;
  pricePerUnit?: number | null;
  budgetYear?: string | number | null;
  requiredQuantityForYear?: number | null;
  purchasingDepartment?: string | null;
}

interface CategoryOption {
  category: string;
  type: string;
  subtype: string | null;
}

export default function PurchaseApprovalsPage() {
  const [items, setItems] = useState<PurchaseApprovalItem[]>([]);
  const [summaryItems, setSummaryItems] = useState<PurchaseApprovalItem[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [filtersLoading, setFiltersLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState<PurchaseApprovalItem | null>(null);
  const [formData, setFormData] = useState<PurchaseApprovalFormData>({});
  const [purchasePlanOptions, setPurchasePlanOptions] = useState<PurchasePlanOption[]>([]);
  const [plansLoading, setPlansLoading] = useState(false);
  const [planSearchTerm, setPlanSearchTerm] = useState('');
  const [selectedPlanLabel, setSelectedPlanLabel] = useState('');
  const [showPlanSuggestions, setShowPlanSuggestions] = useState(false);
  const [highlightedPlanIndex, setHighlightedPlanIndex] = useState(-1);
  const [showMemo, setShowMemo] = useState(false);
  const [memoPreview, setMemoPreview] = useState(false);
  const [toast, setToast] = useState<{
    message: string;
    type: 'success' | 'error';
    visible: boolean;
  }>({
    message: '',
    type: 'success',
    visible: false,
  });
  const planSuggestionsRef = useRef<HTMLDivElement>(null);
  const approvalIdInputRef = useRef<HTMLInputElement>(null);
  const [memoText, setMemoText] = useState(
    `บันทึกข้อความ\n` +
    `ส่วนราชการ  โรงพยาบาลวังทอง   อำเภอวังทอง จังหวัดพิษณุโลก   โทร..............................\n` +
    `ที่  วถ..............................\n` +
    `วันที่  ......................................................\n` +
    `เรื่อง  ขอความเห็นชอบจัดซื้อ.........................................................\n\n` +
    `เรียน  ผู้อำนวยการโรงพยาบาลวังทอง\n\n` +
    `         ด้วย  .................................................................................\n` +
    `.................................................................................................\n` +
    `.................................................................................................\n\n` +
    `         จึงเรียนมาเพื่อโปรดพิจารณา........................................................\n` +
    `.................................................................................................\n\n` +
    `ลงชื่อ...............................................................   ผู้เสนอเรื่อง\n` +
    `(............................................................)\n` +
    `ตำแหน่ง.....................................................\n\n` +
    `ความเห็นผู้บังคับบัญชา/หัวหน้าหน่วยงาน\n` +
    `.................................................................................................\n` +
    `.................................................................................................\n` +
    `ลงชื่อ...............................................................\n` +
    `(............................................................)\n` +
    `ตำแหน่ง.....................................................\n\n` +
    `ความเห็นผู้อำนวยการโรงพยาบาลวังทอง\n` +
    `.................................................................................................\n` +
    `.................................................................................................\n` +
    `ลงชื่อ...............................................................\n` +
    `(............................................................)\n` +
    `ผู้อำนวยการโรงพยาบาลวังทอง`
  );

  // filters
  const [nameFilter, setNameFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('');
  const [subtypeFilter, setSubtypeFilter] = useState('');
  const [departmentFilter, setDepartmentFilter] = useState('');
  const [budgetYearFilter, setBudgetYearFilter] = useState('');

  // sort
  const [sortBy, setSortBy] = useState('id');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);

  // dynamic options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<CategoryOption[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);
  const [requesters, setRequesters] = useState<string[]>([]);
  const [approvers, setApprovers] = useState<string[]>([]);
  const [years, setYears] = useState<string[]>([]);
  const availableBudgetYears = Array.from(new Set([
    ...years,
    ...Array.from({ length: 6 }, (_, index) => String(getCurrentBudgetYear() - index)),
  ])).sort((a, b) => Number(b) - Number(a));

  const availableTypes = useMemo(() => {
    if (!categoryFilter) {
      return types;
    }

    return Array.from(
      new Set(
        categoryOptions
          .filter((option) => option.category === categoryFilter)
          .map((option) => option.type)
          .filter(Boolean)
      )
    );
  }, [categoryFilter, categoryOptions, types]);

  const availableSubtypes = useMemo(() => {
    return Array.from(
      new Set(
        categoryOptions
          .filter((option) => {
            const categoryMatched = categoryFilter ? option.category === categoryFilter : true;
            const typeMatched = typeFilter ? option.type === typeFilter : true;
            return categoryMatched && typeMatched;
          })
          .map((option) => option.subtype)
          .filter(Boolean)
      )
    ) as string[];
  }, [categoryFilter, typeFilter, categoryOptions]);

  useEffect(() => {
    if (typeFilter && !availableTypes.includes(typeFilter)) {
      setTypeFilter('');
      setSubtypeFilter('');
    }
  }, [availableTypes, typeFilter]);

  useEffect(() => {
    if (subtypeFilter && !availableSubtypes.includes(subtypeFilter)) {
      setSubtypeFilter('');
    }
  }, [availableSubtypes, subtypeFilter]);

  useEffect(() => { fetchData(); }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, budgetYearFilter, sortBy, sortOrder, page, pageSize]);

  // When filters or sorting change, reset to first page and refresh summary data
  useEffect(() => {
    setPage(1);
    fetchSummaryData();
  }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, budgetYearFilter, sortBy, sortOrder]);

  useEffect(() => { fetchFilters(); fetchSummaryData(); fetchPurchasePlanOptions(); }, []);

  useEffect(() => {
    setFormData((prev) => {
      const quantity = prev.requestedQuantity ?? 0;
      const price = prev.pricePerUnit ?? 0;
      const nextTotal = Number((quantity * price).toFixed(2));

      if ((prev.totalValue ?? 0) === nextTotal) {
        return prev;
      }

      return {
        ...prev,
        totalValue: nextTotal,
      };
    });
  }, [formData.requestedQuantity, formData.pricePerUnit]);

  useEffect(() => {
    if (!showPlanSuggestions || highlightedPlanIndex < 0) {
      return;
    }

    const suggestionContainer = planSuggestionsRef.current;
    if (!suggestionContainer) {
      return;
    }

    const highlightedElement = suggestionContainer.querySelector<HTMLElement>(`[data-plan-suggestion-index="${highlightedPlanIndex}"]`);
    highlightedElement?.scrollIntoView({ block: 'nearest' });
  }, [highlightedPlanIndex, showPlanSuggestions]);

  const hideToastLater = () => {
    window.setTimeout(() => {
      setToast((prev) => ({ ...prev, visible: false }));
    }, 3000);
  };

  const fetchPurchasePlanOptions = async () => {
    try {
      setPlansLoading(true);
      const res = await fetch('/api/purchase-plans?orderBy=id&sortOrder=desc');
      if (!res.ok) {
        throw new Error('fetch purchase plans failed');
      }

      const data = await res.json();
      setPurchasePlanOptions(data.data || []);
    } catch (e) {
      console.error(e);
    } finally {
      setPlansLoading(false);
    }
  };

  const fetchFilters = async () => {
    try {
      setFiltersLoading(true);
      const res = await fetch('/api/purchase-approvals/filters');
      if (res.ok) {
        const data = await res.json();
        setCategories(data.categories || []);
        setTypes(data.productTypes || []);
        setSubtypes(data.productSubtypes || []);
        setCategoryOptions(data.categoryOptions || []);
        setDepartments(data.departments || []);
        setRequesters(data.requesters || []);
        setApprovers(data.approvers || []);
        setYears(data.budgetYears || []);
      }
    } catch (e) { console.error(e); }
    finally { setFiltersLoading(false); }
  };

  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + (items.length || 0) - 1);

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) return;
    setPage(newPage);
  };

  const handlePageSizeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const newSize = parseInt(e.target.value, 10);
    setPageSize(newSize);
    setPage(1);
  };

  const fetchData = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (nameFilter) params.append('productName', nameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('productType', typeFilter);
      if (subtypeFilter) params.append('productSubtype', subtypeFilter);
      if (departmentFilter) params.append('department', departmentFilter);
      if (budgetYearFilter) params.append('budgetYear', budgetYearFilter);
      params.append('orderBy', sortBy);
      params.append('sortOrder', sortOrder);
      params.append('page', page.toString());
      params.append('pageSize', pageSize.toString());

      const res = await fetch(`/api/purchase-approvals?${params.toString()}`);
      if (!res.ok) throw new Error('fetch failed');
      const data = await res.json();
      setItems(data.data || []);
      setTotalCount(data.totalCount || 0);
      if (data.page && data.page !== page) {
        setPage(data.page);
      }
      if (data.pageSize && data.pageSize !== pageSize) {
        setPageSize(data.pageSize);
      }
    } catch (e) { console.error(e); } finally { setLoading(false); }
  };

  // Fetch full filtered dataset for summary (independent of pagination)
  const fetchSummaryData = async () => {
    try {
      const params = new URLSearchParams();
      if (nameFilter) params.append('productName', nameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('productType', typeFilter);
      if (subtypeFilter) params.append('productSubtype', subtypeFilter);
      if (departmentFilter) params.append('department', departmentFilter);
      if (budgetYearFilter) params.append('budgetYear', budgetYearFilter);
      params.append('orderBy', sortBy);
      params.append('sortOrder', sortOrder);

      const res = await fetch(`/api/purchase-approvals?${params.toString()}`);
      if (!res.ok) return;
      const data = await res.json();
      setSummaryItems(data.data || []);
    } catch (e) {
      console.error(e);
    }
  };

  const handleSort = (column: string) => {
    if (sortBy === column) setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    else { setSortBy(column); setSortOrder('asc'); }
  };

  const getHeaderClass = (col: string) => `px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${col === sortBy ? 'bg-gray-100' : ''}`;

  const handleEdit = (row: any) => {
    setEditing(row);
    const selectedLabel = [row.productCode, row.productName].filter(Boolean).join(' - ');
    setPlanSearchTerm(selectedLabel);
    setSelectedPlanLabel(selectedLabel);
    setShowPlanSuggestions(false);
    setHighlightedPlanIndex(-1);
    setFormData({
      approvalId: row.approvalId || '',
      department: row.department || '',
      budgetYear: row.budgetYear ? String(row.budgetYear) : '',
      recordNumber: row.recordNumber || '',
      requestDate: row.requestDate || '',
      productName: row.productName || '',
      productCode: row.productCode || '',
      category: row.category || '',
      productType: row.productType || '',
      productSubtype: row.productSubtype || '',
      requestedQuantity: row.requestedQuantity ?? null,
      unit: row.unit || '',
      pricePerUnit: row.pricePerUnit ? Number(row.pricePerUnit) : undefined,
      totalValue: row.totalValue ? Number(row.totalValue) : undefined,
      overPlanCase: row.overPlanCase || '',
      requester: row.requester || '',
      approver: row.approver || '',
    });
    setShowForm(true);
  };

  const resetForm = () => {
    setEditing(null);
    setFormData({ budgetYear: String(getCurrentBudgetYear()), requestDate: getTodayDateInputValue() });
    setPlanSearchTerm('');
    setSelectedPlanLabel('');
    setShowPlanSuggestions(false);
    setHighlightedPlanIndex(-1);
    setShowForm(false);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: ['pricePerUnit','totalValue'].includes(name)
        ? (value ? parseFloat(value) : undefined)
        : ['requestedQuantity'].includes(name)
        ? (value ? parseInt(value) : null)
        : value
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const method = editing ? 'PUT' : 'POST';
    const url = editing ? `/api/purchase-approvals/${editing.id}` : '/api/purchase-approvals';
    const payload = {
      ...formData,
      requestedQuantity:
        formData.requestedQuantity === null || formData.requestedQuantity === undefined
          ? undefined
          : String(formData.requestedQuantity),
      pricePerUnit:
        formData.pricePerUnit === null || formData.pricePerUnit === undefined
          ? undefined
          : String(formData.pricePerUnit),
      totalValue:
        formData.totalValue === null || formData.totalValue === undefined
          ? undefined
          : String(formData.totalValue),
    };
    const res = await fetch(url, { method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) });
    if (res.ok) {
      resetForm();
      fetchData();
      setToast({
        message: editing ? 'แก้ไขข้อมูลเรียบร้อยแล้ว' : 'เพิ่มข้อมูลเรียบร้อยแล้ว',
        type: 'success',
        visible: true,
      });
      hideToastLater();
    }
    else { const err = await res.json().catch(()=>({})); await Swal.fire('เกิดข้อผิดพลาด', err.error || 'บันทึกล้มเหลว', 'error'); }
  };

  const modalFieldClassName = 'w-full border rounded px-3 py-2';

  const filteredPlanOptions = planSearchTerm.trim().length === 0
    ? purchasePlanOptions.slice(0, 12)
    : purchasePlanOptions.filter((option) => {
        const searchValue = planSearchTerm.trim().toLowerCase();
        return [option.productCode, option.productName]
          .filter(Boolean)
          .some((value) => String(value).toLowerCase().includes(searchValue));
      }).slice(0, 12);

  const applyPurchasePlanSelection = (plan: PurchasePlanOption) => {
    const selectedLabel = [plan.productCode, plan.productName].filter(Boolean).join(' - ');
    setPlanSearchTerm(selectedLabel);
    setSelectedPlanLabel(selectedLabel);
    setShowPlanSuggestions(false);
    setHighlightedPlanIndex(-1);
    setFormData((prev) => ({
      ...prev,
      productCode: plan.productCode || '',
      productName: plan.productName || '',
      category: plan.category || '',
      productType: plan.productType || '',
      productSubtype: plan.productSubtype || '',
      unit: plan.unit || '',
      pricePerUnit: plan.pricePerUnit != null ? Number(plan.pricePerUnit) : undefined,
      budgetYear: plan.budgetYear != null ? String(plan.budgetYear) : prev.budgetYear || String(getCurrentBudgetYear()),
      requestedQuantity: plan.requiredQuantityForYear != null ? Number(plan.requiredQuantityForYear) : prev.requestedQuantity ?? null,
      department: plan.purchasingDepartment || prev.department || '',
    }));

    window.requestAnimationFrame(() => {
      approvalIdInputRef.current?.focus();
    });
  };

  const handlePlanSearchChange = (value: string) => {
    setPlanSearchTerm(value);
    const isExistingSelection = value.trim().length > 0 && value.trim() === selectedPlanLabel.trim();
    if (!isExistingSelection) {
      setSelectedPlanLabel('');
    }
    setShowPlanSuggestions(!isExistingSelection);
    setHighlightedPlanIndex(-1);

    if (!value.trim()) {
      setFormData((prev) => ({
        ...prev,
        productCode: '',
        productName: '',
        category: '',
        productType: '',
        productSubtype: '',
        unit: '',
        pricePerUnit: undefined,
        requestedQuantity: null,
        totalValue: 0,
      }));
    }
  };

  const handlePlanSearchKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (!showPlanSuggestions || filteredPlanOptions.length === 0) {
      return;
    }

    if (event.key === 'ArrowDown') {
      event.preventDefault();
      setHighlightedPlanIndex((prev) => (prev + 1) % filteredPlanOptions.length);
      return;
    }

    if (event.key === 'ArrowUp') {
      event.preventDefault();
      setHighlightedPlanIndex((prev) => (prev <= 0 ? filteredPlanOptions.length - 1 : prev - 1));
      return;
    }

    if (event.key === 'Enter' && highlightedPlanIndex >= 0) {
      event.preventDefault();
      applyPurchasePlanSelection(filteredPlanOptions[highlightedPlanIndex]);
      return;
    }

    if (event.key === 'Escape') {
      setShowPlanSuggestions(false);
      setHighlightedPlanIndex(-1);
    }
  };

  const openCreateForm = () => {
    setEditing(null);
    setFormData({ budgetYear: String(getCurrentBudgetYear()), requestDate: getTodayDateInputValue() });
    setPlanSearchTerm('');
    setSelectedPlanLabel('');
    setShowPlanSuggestions(false);
    setHighlightedPlanIndex(-1);
    setShowForm(true);
  };

  const shouldShowNoResults = showPlanSuggestions
    && !plansLoading
    && planSearchTerm.trim().length > 0
    && planSearchTerm.trim() !== selectedPlanLabel.trim()
    && filteredPlanOptions.length === 0;

  const formatDateTime = (value?: string) => {
    if (!value) return '-';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return value;
    return date.toLocaleString('th-TH');
  };

  const handleDelete = async (id: number) => {
    const result = await Swal.fire({ title: 'ลบข้อมูล?', text: 'ยืนยันการลบรายการ', icon: 'warning', showCancelButton: true, confirmButtonText: 'ลบ', cancelButtonText: 'ยกเลิก' });
    if (!result.isConfirmed) return;
    const res = await fetch(`/api/purchase-approvals/${id}`, { method: 'DELETE' });
    if (res.ok) { await Swal.fire('ลบแล้ว', '', 'success'); fetchData(); }
    else { await Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถลบได้', 'error'); }
  };

  return (
    <div className="container mx-auto px-4 py-8">
      {toast.visible && (
        <div className={`fixed right-4 top-4 z-50 rounded-lg px-4 py-3 text-white shadow-lg transition-all duration-300 ${toast.type === 'success' ? 'bg-green-500' : 'bg-red-500'}`}>
          <div className="flex items-center gap-2">
            <span>{toast.message}</span>
            <button
              type="button"
              onClick={() => setToast((prev) => ({ ...prev, visible: false }))}
              className="hover:opacity-75"
              aria-label="ปิดการแจ้งเตือน"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
        </div>
      )}

      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">ขออนุมัติจัดซื้อ</h1>
        <div className="flex gap-2">
          <button
            onClick={openCreateForm}
            className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            เพิ่มรายการ
          </button>
          <button
            onClick={() => setShowMemo(true)}
            className="bg-emerald-500 hover:bg-emerald-700 text-white font-bold py-2 px-4 rounded"
          >
            ขอความเห็นชอบจัดซื้อ
          </button>
        </div>
      </div>

      {showMemo && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-3/4 shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">บันทึกข้อความ</h3>
              <button onClick={() => setShowMemo(false)} className="text-gray-400 hover:text-gray-600">✕</button>
            </div>
            <div className="space-y-4">
              <div className="flex justify-end space-x-2 text-sm">
                <button
                  type="button"
                  onClick={() => setMemoPreview(false)}
                  className={`px-3 py-1 rounded border ${!memoPreview ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-700 border-gray-300'}`}
                >
                  โหมดแก้ไข
                </button>
                <button
                  type="button"
                  onClick={() => setMemoPreview(true)}
                  className={`px-3 py-1 rounded border ${memoPreview ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-700 border-gray-300'}`}
                >
                  ตัวอย่างก่อนพิมพ์
                </button>
              </div>

              {!memoPreview ? (
                <textarea
                  className="w-full border rounded px-3 py-2 h-80 resize-none text-sm"
                  value={memoText}
                  onChange={(e) => setMemoText(e.target.value)}
                  placeholder="พิมพ์บันทึกข้อความที่นี่..."
                  style={{ whiteSpace: 'pre-wrap', fontFamily: 'Tahoma, system-ui, sans-serif' }}
                />
              ) : (
                <div className="flex justify-center">
                  <div
                    className="bg-white border shadow-sm rounded px-10 py-10 max-h-[32rem] overflow-auto text-sm w-full md:w-[800px]"
                    style={{ whiteSpace: 'pre-wrap', fontFamily: 'Tahoma, system-ui, sans-serif', lineHeight: 1.8 }}
                  >
                    {memoText}
                  </div>
                </div>
              )}
              <div className="flex justify-end space-x-3">
                <button
                  type="button"
                  onClick={() => setShowMemo(false)}
                  className="px-4 py-2 border rounded"
                >
                  ปิด
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-2/3 shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">{editing ? 'แก้ไขรายการ' : 'เพิ่มรายการใหม่'}</h3>
              <button onClick={resetForm} className="text-gray-400 hover:text-gray-600">✕</button>
            </div>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                {!editing && (
                <div className="md:col-span-3 rounded-lg border border-blue-100 bg-blue-50 p-4">
                  <label className="flex flex-col gap-2 text-sm text-gray-700">
                    <div className="relative">
                      <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
                      <input
                        id="purchase-approval-plan-search"
                        name="purchasePlanSearch"
                        value={planSearchTerm}
                        onChange={(e) => handlePlanSearchChange(e.target.value)}
                        onFocus={() => {
                          if (!editing && planSearchTerm.trim() && planSearchTerm.trim() !== selectedPlanLabel.trim()) {
                            setShowPlanSuggestions(true);
                          }
                        }}
                        onKeyDown={handlePlanSearchKeyDown}
                        placeholder="พิมพ์รหัสสินค้า หรือชื่อสินค้า"
                        autoComplete="off"
                        aria-label="ค้นหารหัสหรือชื่อสินค้าจากแผนจัดซื้อ"
                        className={`${modalFieldClassName} pl-9 pr-9`}
                      />
                      {planSearchTerm && (
                        <button
                          type="button"
                          onClick={() => handlePlanSearchChange('')}
                          className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                          aria-label="ล้างคำค้น"
                        >
                          <X className="h-4 w-4" />
                        </button>
                      )}
                      {showPlanSuggestions && (
                        <div ref={planSuggestionsRef} className="absolute z-10 mt-2 max-h-72 w-full overflow-auto rounded-md border border-gray-200 bg-white shadow-lg">
                          {plansLoading ? (
                            <div className="px-4 py-3 text-sm text-gray-500">กำลังโหลดข้อมูลแผนจัดซื้อ...</div>
                          ) : shouldShowNoResults ? (
                            <div className="px-4 py-3 text-sm text-gray-500">ไม่พบรายการที่ค้นหา</div>
                          ) : (
                            filteredPlanOptions.map((plan, index) => (
                              <button
                                key={`${plan.id}-${plan.productCode || plan.productName || index}`}
                                data-plan-suggestion-index={index}
                                type="button"
                                onMouseDown={(event) => event.preventDefault()}
                                onClick={() => applyPurchasePlanSelection(plan)}
                                onMouseEnter={() => setHighlightedPlanIndex(index)}
                                className={`block w-full px-4 py-3 text-left text-sm ${highlightedPlanIndex === index ? 'bg-blue-50' : 'hover:bg-gray-50'}`}
                              >
                                <div className="font-medium text-gray-900">{plan.productCode || '-'} - {plan.productName || 'ไม่ระบุชื่อสินค้า'}</div>
                                <div className="mt-1 text-xs text-gray-500">
                                  หน่วยงาน: {plan.purchasingDepartment || '-'} | ปีงบ: {plan.budgetYear || '-'} | ราคา/หน่วย: {(Number(plan.pricePerUnit) || 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                                </div>
                              </button>
                            ))
                          )}
                        </div>
                      )}
                    </div>
                  </label>
                </div>
                )}
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">รหัสอนุมัติ</span>
                  <input ref={approvalIdInputRef} id="purchase-approval-approvalId" name="approvalId" value={formData.approvalId || ''} onChange={handleInputChange} className={modalFieldClassName} />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">หน่วยงาน</span>
                  <select id="purchase-approval-department" name="department" value={formData.department || ''} onChange={handleInputChange} className={modalFieldClassName}>
                    <option value="">เลือกหน่วยงาน</option>
                    {departments.map((department) => (
                      <option key={department} value={department}>{department}</option>
                    ))}
                  </select>
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">ปีงบประมาณ</span>
                  <select id="purchase-approval-budgetYear" name="budgetYear" value={formData.budgetYear || ''} onChange={handleInputChange} className={modalFieldClassName}>
                    <option value="">เลือกปีงบประมาณ</option>
                    {availableBudgetYears.map((year) => (
                      <option key={year} value={year}>{year}</option>
                    ))}
                  </select>
                </label>
                <div className="md:col-span-3 grid grid-cols-1 gap-4 md:grid-cols-6">
                  <label className="flex flex-col gap-1 text-sm text-gray-700 md:col-span-4">
                    <span className="font-medium">เลขที่บันทึก</span>
                    <input id="purchase-approval-recordNumber" name="recordNumber" value={formData.recordNumber || ''} onChange={handleInputChange} className={modalFieldClassName} />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700 md:col-span-2">
                    <span className="font-medium">วันที่ขอ</span>
                    <input id="purchase-approval-requestDate" type="date" name="requestDate" value={formData.requestDate || ''} onChange={handleInputChange} className={modalFieldClassName} />
                  </label>
                </div>
                <div className="md:col-span-3 grid grid-cols-1 gap-4 md:grid-cols-3">
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">รหัสสินค้า</span>
                    <input id="purchase-approval-productCode" name="productCode" value={formData.productCode || ''} onChange={handleInputChange} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700 md:col-span-2">
                    <span className="font-medium">ชื่อสินค้า</span>
                    <input id="purchase-approval-productName" name="productName" value={formData.productName || ''} onChange={handleInputChange} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                </div>
                <div className="md:col-span-3 grid grid-cols-1 gap-4 md:grid-cols-3">
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">หมวดหมู่</span>
                    <input id="purchase-approval-category" list="purchase-approval-categories" name="category" value={formData.category || ''} onChange={handleInputChange} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                    <datalist id="purchase-approval-categories">
                      {categories.map((category) => (
                        <option key={category} value={category} />
                      ))}
                    </datalist>
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ประเภท</span>
                    <input id="purchase-approval-type" list="purchase-approval-types" name="productType" value={formData.productType || ''} onChange={handleInputChange} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                    <datalist id="purchase-approval-types">
                      {types.map((type) => (
                        <option key={type} value={type} />
                      ))}
                    </datalist>
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ประเภทย่อย</span>
                    <input id="purchase-approval-subtype" list="purchase-approval-subtypes" name="productSubtype" value={formData.productSubtype || ''} onChange={handleInputChange} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                    <datalist id="purchase-approval-subtypes">
                      {subtypes.map((subtype) => (
                        <option key={subtype} value={subtype} />
                      ))}
                    </datalist>
                  </label>
                </div>
                <div className="md:col-span-3 grid grid-cols-1 gap-4 md:grid-cols-4">
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ปริมาณที่ขอ</span>
                    <input id="purchase-approval-requestedQuantity" type="text" inputMode="numeric" name="requestedQuantity" value={formatNumberWithComma(formData.requestedQuantity, 0)} onChange={handleInputChange} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">หน่วย</span>
                    <input id="purchase-approval-unit" name="unit" value={formData.unit || ''} onChange={handleInputChange} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ราคา/หน่วย</span>
                    <input id="purchase-approval-pricePerUnit" type="text" inputMode="decimal" name="pricePerUnit" value={formatNumberWithComma(formData.pricePerUnit, 2)} onChange={handleInputChange} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">มูลค่ารวม</span>
                    <input id="purchase-approval-totalValue" type="text" inputMode="decimal" name="totalValue" value={formatNumberWithComma(formData.totalValue, 2)} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                </div>
                <label className="flex flex-col gap-1 text-sm text-gray-700 md:col-span-3">
                  <span className="font-medium">กรณีเกินแผน</span>
                  <input id="purchase-approval-overPlanCase" name="overPlanCase" value={formData.overPlanCase || ''} onChange={handleInputChange} className={modalFieldClassName} />
                </label>
                <div className="md:col-span-3 grid grid-cols-1 gap-4 md:grid-cols-2">
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ผู้ขอ</span>
                    <input id="purchase-approval-requester" list="purchase-approval-requesters" name="requester" value={formData.requester || ''} onChange={handleInputChange} className={modalFieldClassName} />
                    <datalist id="purchase-approval-requesters">
                      {requesters.map((requester) => (
                        <option key={requester} value={requester} />
                      ))}
                    </datalist>
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ผู้อนุมัติ</span>
                    <input id="purchase-approval-approver" list="purchase-approval-approvers" name="approver" value={formData.approver || ''} onChange={handleInputChange} className={modalFieldClassName} />
                    <datalist id="purchase-approval-approvers">
                      {approvers.map((approver) => (
                        <option key={approver} value={approver} />
                      ))}
                    </datalist>
                  </label>
                </div>
              </div>
              {editing && (
                <div className="grid grid-cols-1 gap-3 rounded-lg bg-gray-50 p-4 text-sm text-gray-600 md:grid-cols-2">
                  <div>
                    <span className="font-medium text-gray-700">สร้างเมื่อ:</span> {formatDateTime(editing.created_at)}
                  </div>
                  <div>
                    <span className="font-medium text-gray-700">อัปเดตล่าสุด:</span> {formatDateTime(editing.updated_at)}
                  </div>
                </div>
              )}
              <div className="flex justify-end space-x-3">
                <button type="button" onClick={resetForm} className="px-4 py-2 border rounded">ยกเลิก</button>
                <button type="submit" className="px-4 py-2 bg-blue-600 text-white rounded">บันทึก</button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 md:grid-cols-6 gap-4 mb-4">
            <input placeholder="ชื่อสินค้า" value={nameFilter} onChange={(e)=>setNameFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2" />
            <select value={categoryFilter} onChange={(e)=>{ setCategoryFilter(e.target.value); setTypeFilter(''); setSubtypeFilter(''); }} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หมวด</option>
              {categories.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={typeFilter} onChange={(e)=>{ setTypeFilter(e.target.value); setSubtypeFilter(''); }} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภท</option>
              {availableTypes.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={subtypeFilter} onChange={(e)=>setSubtypeFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภทย่อย</option>
              {availableSubtypes.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={departmentFilter} onChange={(e)=>setDepartmentFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หน่วยงาน</option>
              {departments.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={budgetYearFilter} onChange={(e)=>setBudgetYearFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ปีงบประมาณ</option>
              {availableBudgetYears.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
          </div>
          {filtersLoading && <div className="text-sm text-gray-500">กำลังโหลดตัวกรอง...</div>}
        </div>
      </div>

      {/* Summary Section (based on filtered dataset, not pagination) */}
      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <h3 className="text-lg font-medium text-gray-900">สรุปมูลค่าการขออนุมัติจัดซื้อ</h3>
            <div className="flex flex-wrap items-center gap-6 text-sm">
              <div>
                <span className="text-gray-500">มูลค่ารวม (totalValue): </span>
                <span className="font-semibold text-gray-900">
                  ฿{summaryItems
                    .reduce((sum, row) => sum + (Number(row.totalValue) || 0), 0)
                    .toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="mt-4 flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="text-sm text-gray-600">
          แสดง {pageStart}-{pageEnd} จาก {totalCount} รายการ
        </div>
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="flex items-center gap-2">
            <span className="text-sm text-gray-600">แสดงต่อหน้า</span>
            <select
              value={pageSize}
              onChange={handlePageSizeChange}
              className="rounded border border-gray-300 px-2 py-1 text-sm"
            >
              {[10, 20, 50].map((size) => (
                <option key={size} value={size}>{size}</option>
              ))}
            </select>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => goToPage(page - 1)}
              disabled={page === 1}
              className={`px-3 py-1 rounded border text-sm ${page === 1 ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-100'}`}
            >
              ก่อนหน้า
            </button>
            <span className="text-sm text-gray-700">
              หน้า {page} / {totalPages}
            </span>
            <button
              onClick={() => goToPage(page + 1)}
              disabled={page >= totalPages}
              className={`px-3 py-1 rounded border text-sm ${page >= totalPages ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-100'}`}
            >
              ถัดไป
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white shadow-md rounded-lg overflow-hidden">
        {loading ? (
          <div className="flex justify-center items-center py-12">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          </div>
        ) : items.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-500">ไม่พบข้อมูล</p>
          </div>
        ) : (
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th onClick={()=>handleSort('approvalId')} className={getHeaderClass('approvalId')}>เลขอนุมัติ</th>
                <th onClick={()=>handleSort('department')} className={getHeaderClass('department')}>หน่วยงาน</th>
                <th onClick={()=>handleSort('budgetYear')} className={getHeaderClass('budgetYear')}>ปีงบ</th>
                <th onClick={()=>handleSort('productName')} className={getHeaderClass('productName')}>ชื่อสินค้า</th>
                <th onClick={()=>handleSort('requestedQuantity')} className={getHeaderClass('requestedQuantity')}>จำนวน</th>
                <th onClick={()=>handleSort('pricePerUnit')} className={getHeaderClass('pricePerUnit')}>ราคา/หน่วย</th>
                <th onClick={()=>handleSort('totalValue')} className={getHeaderClass('totalValue')}>มูลค่ารวม</th>
                <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-24">Action</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {items.map((row) => (
                <tr key={row.id}>
                  <td className="px-3 py-2 text-xs">{row.approvalId}</td>
                  <td className="px-3 py-2 text-xs">{row.department}</td>
                  <td className="px-3 py-2 text-xs">{row.budgetYear || '-'}</td>
                  <td className="px-3 py-2 text-xs">
                    <div className="whitespace-normal break-words" title={row.productName}>
                      {row.productName}
                    </div>
                  </td>
                  <td className="px-3 py-2 text-xs">{row.requestedQuantity ?? '-'}</td>
                  <td className="px-3 py-2 text-xs">{row.pricePerUnit ? Number(row.pricePerUnit).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                  <td className="px-3 py-2 text-xs">{row.totalValue ? Number(row.totalValue).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                  <td className="px-3 py-2 text-xs font-medium w-24">
                    <button
                      onClick={() => handleEdit(row)}
                      className="text-indigo-600 hover:text-indigo-900 mr-2 cursor-pointer"
                      title="แก้ไข"
                    >
                      <Pencil className="h-5 w-5" />
                    </button>
                    <button
                      onClick={() => handleDelete(row.id)}
                      className="text-red-600 hover:text-red-900 cursor-pointer"
                      title="ลบ"
                    >
                      <Trash2 className="h-5 w-5" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}
