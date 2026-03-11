'use client';

import { Suspense, useEffect, useMemo, useRef, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { CheckCircle, Pencil, Trash2, XCircle, X, Plus, Search } from 'lucide-react';

const getCurrentBudgetYear = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

const PRODUCT_SUGGESTION_LIMIT = 12;

type PurchasePlanRow = {
  id: number;
  usage_plan_id: number;
  sequence_no: number | null;
  product_code: string | null;
  product_name: string | null;
  category: string | null;
  product_type: string | null;
  product_subtype: string | null;
  unit: string | null;
  price_per_unit: number | null;
  requested_amount: number | null;
  approved_quota: number | null;
  budget_year: number | null;
  requesting_dept: string | null;
  inventory_qty: number | null;
  inventory_value: number | null;
  purchase_qty: number | null;
  purchase_value: number | null;
};

type CategoryOption = {
  category: string;
  type: string;
  subtype: string | null;
};

type BulkPurchasePlanRecord = {
  id: number;
  productSearch: string;
  product_code: string;
  category: string;
  product_type: string;
  product_subtype: string;
  product_name: string;
  requested_amount: string;
  unit: string;
  price_per_unit: string;
  requesting_dept: string;
  approved_quota: string;
  budget_year: string;
  sequence_no: string;
};

type ProductOption = {
  id: number;
  code: string;
  name: string;
  category: string;
  type: string;
  subtype: string | null;
  unit: string;
  cost_price?: number | null;
};

interface DepartmentComboboxProps {
  id: string;
  name: string;
  aria_label: string;
  value: string;
  departments: string[];
  placeholder?: string;
  required?: boolean;
  on_change: (value: string) => void;
  on_clear_error?: () => void;
  class_name?: string;
  list_class_name?: string;
  on_key_down?: (event: React.KeyboardEvent<HTMLInputElement>) => void;
}

function DepartmentCombobox({
  id,
  name,
  aria_label,
  value,
  departments,
  placeholder,
  required = false,
  on_change,
  on_clear_error,
  class_name = '',
  list_class_name = '',
  on_key_down,
}: DepartmentComboboxProps) {
  const [input_value, setInputValue] = useState(value || '');
  const [is_open, setIsOpen] = useState(false);
  const [highlighted_index, setHighlightedIndex] = useState(-1);
  const list_ref = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    setInputValue(value || '');
  }, [value]);

  const filtered_departments = useMemo(() => {
    const normalized_value = input_value.trim().toLowerCase();
    if (!normalized_value) {
      return departments;
    }
    return departments.filter(dept => 
      dept.toLowerCase().includes(normalized_value)
    );
  }, [input_value, departments]);

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const new_value = e.target.value;
    setInputValue(new_value);
    setIsOpen(true);
    setHighlightedIndex(-1);
    on_clear_error?.();
    
    // If the input exactly matches a department, update the value
    const exact_match = departments.find(dept => 
      dept.toLowerCase() === new_value.trim().toLowerCase()
    );
    if (exact_match) {
      on_change(exact_match);
    } else if (new_value.trim() === '') {
      on_change('');
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setIsOpen(true);
      setHighlightedIndex(prev => 
        prev < filtered_departments.length - 1 ? prev + 1 : prev
      );
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setHighlightedIndex(prev => prev > 0 ? prev - 1 : -1);
    } else if (e.key === 'Enter') {
      e.preventDefault();
      if (highlighted_index >= 0 && filtered_departments[highlighted_index]) {
        const selected = filtered_departments[highlighted_index];
        setInputValue(selected);
        on_change(selected);
        setIsOpen(false);
        setHighlightedIndex(-1);
      }
    } else if (e.key === 'Escape') {
      setIsOpen(false);
      setHighlightedIndex(-1);
    } else if (e.key === 'Tab') {
      setIsOpen(false);
      setHighlightedIndex(-1);
    }
    
    on_key_down?.(e);
  };

  const handleDepartmentSelect = (dept: string) => {
    setInputValue(dept);
    on_change(dept);
    setIsOpen(false);
    setHighlightedIndex(-1);
  };

  useEffect(() => {
    if (is_open && highlighted_index >= 0 && list_ref.current) {
      const highlighted_element = list_ref.current.querySelector(`[data-index="${highlighted_index}"]`);
      highlighted_element?.scrollIntoView({ block: 'nearest' });
    }
  }, [highlighted_index, is_open]);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (list_ref.current && !list_ref.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <div className="relative">
      <input
        id={id}
        name={name}
        type="text"
        value={input_value}
        onChange={handleInputChange}
        onKeyDown={handleKeyDown}
        onFocus={() => setIsOpen(true)}
        placeholder={placeholder}
        required={required}
        aria-label={aria_label}
        className={class_name}
        role="combobox"
        aria-expanded={is_open}
        aria-autocomplete="list"
      />
      {is_open && filtered_departments.length > 0 && (
        <div
          ref={list_ref}
          className={list_class_name}
          role="listbox"
        >
          {filtered_departments.map((dept, index) => (
            <div
              key={dept}
              data-index={index}
              className={`px-3 py-2 cursor-pointer ${
                index === highlighted_index ? 'bg-blue-100' : 'hover:bg-gray-100'
              }`}
              onClick={() => handleDepartmentSelect(dept)}
              role="option"
              aria-selected={index === highlighted_index}
            >
              {dept}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

function PurchasePlansPageContent() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();

  const initialProductNameFilter = searchParams.get('product_name') || '';
  const initialCategoryFilter = searchParams.get('category') || '';
  const initialTypeFilter = searchParams.get('product_type') || '';
  const initialSubtypeFilter = searchParams.get('product_subtype') || '';
  const initialRequestingDeptFilter = searchParams.get('requesting_dept') || '';
  const initialBudgetYearFilter = searchParams.get('budget_year') || '';
  const initialSortBy = searchParams.get('order_by') || 'id';
  const initialSortOrder = (searchParams.get('sort_order') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
  const initialPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
  const initialPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);

  const [items, setItems] = useState<PurchasePlanRow[]>([]);
  const [summaryItems, setSummaryItems] = useState<PurchasePlanRow[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [filtersLoading, setFiltersLoading] = useState(true);
  const [savingRowId, setSavingRowId] = useState<number | null>(null);
  const [editingRowId, setEditingRowId] = useState<number | null>(null);
  const [showBulkForm, setShowBulkForm] = useState(false);
  const [bulkRecords, setBulkRecords] = useState<BulkPurchasePlanRecord[]>([]);
  const [editingPurchaseQty, setEditingPurchaseQty] = useState<string>('');
  const purchaseQtyInputRefs = useRef<Record<number, HTMLInputElement | null>>({});
  const [bulkProductSearch, setBulkProductSearch] = useState('');
  const [bulkProductOptions, setBulkProductOptions] = useState<ProductOption[]>([]);
  const [showBulkProductSuggestions, setShowBulkProductSuggestions] = useState(false);
  const [highlightedBulkProductIndex, setHighlightedBulkProductIndex] = useState(-1);
  const [selectedBulkProductLabel, setSelectedBulkProductLabel] = useState('');
  const [bulkRecordErrors, setBulkRecordErrors] = useState<Record<number, string>>({});
  const [bulkValidationErrors, setBulkValidationErrors] = useState<Record<number, { requestedAmount?: string; requestingDept?: string }>>({});
  const bulkProductSearchInputRef = useRef<HTMLInputElement | null>(null);
  const bulkProductSuggestionsRef = useRef<HTMLDivElement | null>(null);
  const bulkProductSearchAbortRef = useRef<AbortController | null>(null);
  const dataRequestIdRef = useRef(0);
  const lastPushedUrlRef = useRef('');
  const prevFilterKeyRef = useRef('');
  const [productNameFilter, setProductNameFilter] = useState(initialProductNameFilter);
  const [categoryFilter, setCategoryFilter] = useState(initialCategoryFilter);
  const [typeFilter, setTypeFilter] = useState(initialTypeFilter);
  const [subtypeFilter, setSubtypeFilter] = useState(initialSubtypeFilter);
  const [requestingDeptFilter, setRequestingDeptFilter] = useState(initialRequestingDeptFilter);
  const [budgetYearFilter, setBudgetYearFilter] = useState(initialBudgetYearFilter);

  const [sortBy, setSortBy] = useState(initialSortBy);
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>(initialSortOrder);
  const [page, setPage] = useState(initialPage);
  const [pageSize, setPageSize] = useState(initialPageSize);

  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<CategoryOption[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);
  const [years, setYears] = useState<string[]>([]);

  const summaryRequestIdRef = useRef(0);
  const hasMountedSummaryRef = useRef(false);
  const hasSyncedSearchParamsRef = useRef(false);
  const filtersLoadedRef = useRef(false);

  const availableBudgetYears = Array.from(
    new Set([
      ...years,
      ...Array.from({ length: 6 }, (_, index) => String(getCurrentBudgetYear() - index)),
    ]),
  ).sort((a, b) => Number(b) - Number(a));

  useEffect(() => {
    void fetchFilters();
  }, []);

  useEffect(() => {
    void fetchData();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder, page, pageSize]);

  useEffect(() => {
    void fetchSummaryData();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder]);

  const availableTypes = useMemo(() => {
    if (!categoryFilter) {
      return types;
    }

    return Array.from(
      new Set(
        categoryOptions
          .filter((option) => option.category === categoryFilter)
          .map((option) => option.type)
          .filter(Boolean),
      ),
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
          .filter(Boolean),
      ),
    ) as string[];
  }, [categoryFilter, typeFilter, categoryOptions]);

  useEffect(() => {
    if (!filtersLoadedRef.current) {
      return;
    }

    if (typeFilter && !availableTypes.includes(typeFilter)) {
      setTypeFilter('');
      setSubtypeFilter('');
    }
  }, [availableTypes, typeFilter]);

  useEffect(() => {
    if (!filtersLoadedRef.current) {
      return;
    }

    if (subtypeFilter && !availableSubtypes.includes(subtypeFilter)) {
      setSubtypeFilter('');
    }
  }, [availableSubtypes, subtypeFilter]);

  useEffect(() => {
    if (!hasSyncedSearchParamsRef.current) {
      return;
    }

    if (!hasMountedSummaryRef.current) {
      hasMountedSummaryRef.current = true;
      return;
    }

    setPage((prev) => (prev === 1 ? prev : 1));
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder]);

  useEffect(() => {
    const nextProductName = searchParams.get('product_name') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('product_type') || '';
    const nextSubtype = searchParams.get('product_subtype') || '';
    const nextRequestingDept = searchParams.get('requesting_dept') || '';
    const nextBudgetYear = searchParams.get('budget_year') || '';
    const nextSortBy = searchParams.get('order_by') || 'id';
    const nextSortOrder = (searchParams.get('sort_order') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
    const nextPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const nextPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);

    setProductNameFilter((prev) => (prev === nextProductName ? prev : nextProductName));
    setCategoryFilter((prev) => (prev === nextCategory ? prev : nextCategory));
    setTypeFilter((prev) => (prev === nextType ? prev : nextType));
    setSubtypeFilter((prev) => (prev === nextSubtype ? prev : nextSubtype));
    setRequestingDeptFilter((prev) => (prev === nextRequestingDept ? prev : nextRequestingDept));
    setBudgetYearFilter((prev) => (prev === nextBudgetYear ? prev : nextBudgetYear));
    setSortBy((prev) => (prev === nextSortBy ? prev : nextSortBy));
    setSortOrder((prev) => (prev === nextSortOrder ? prev : nextSortOrder));
    setPage((prev) => (prev === nextPage ? prev : nextPage));
    setPageSize((prev) => (prev === nextPageSize ? prev : nextPageSize));
    hasSyncedSearchParamsRef.current = true;
  }, [searchParams]);

  useEffect(() => {
    if (!hasSyncedSearchParamsRef.current) {
      return;
    }

    const params = new URLSearchParams();
    if (productNameFilter) params.set('product_name', productNameFilter);
    if (categoryFilter) params.set('category', categoryFilter);
    if (typeFilter) params.set('product_type', typeFilter);
    if (subtypeFilter) params.set('product_subtype', subtypeFilter);
    if (requestingDeptFilter) params.set('requesting_dept', requestingDeptFilter);
    if (budgetYearFilter) params.set('budget_year', budgetYearFilter);
    if (sortBy && sortBy !== 'id') params.set('order_by', sortBy);
    if (sortOrder !== 'desc') params.set('sort_order', sortOrder);
    if (page > 1) params.set('page', page.toString());
    if (pageSize !== 20) params.set('page_size', pageSize.toString());

    const nextUrl = params.toString() ? `${pathname}?${params.toString()}` : pathname;
    const currentUrl = searchParams.toString() ? `${pathname}?${searchParams.toString()}` : pathname;

    if (nextUrl !== currentUrl) {
      router.replace(nextUrl, { scroll: false });
    }
  }, [pathname, router, searchParams, productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder, page, pageSize]);

  useEffect(() => {
    if (editingRowId === null) {
      return;
    }

    const input = purchaseQtyInputRefs.current[editingRowId];
    if (!input) {
      return;
    }

    input.focus();
    input.select();
  }, [editingRowId]);

  const fetchFilters = async () => {
    try {
      setFiltersLoading(true);
      const response = await fetch('/api/purchase-plans/filters');
      if (!response.ok) {
        throw new Error('fetch filters failed');
      }

      const data = await response.json();
      setCategories(data.categories || []);
      setTypes(data.product_types || []);
      setCategoryOptions(data.category_options || []);
      setDepartments(data.departments || []);
      setYears(data.budget_years || []);
      filtersLoadedRef.current = true;
    } catch (error) {
      console.error(error);
    } finally {
      setFiltersLoading(false);
    }
  };

  const fetchData = async () => {
    const requestId = ++dataRequestIdRef.current;

    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (productNameFilter) params.append('product_name', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('product_type', typeFilter);
      if (subtypeFilter) params.append('product_subtype', subtypeFilter);
      if (requestingDeptFilter) params.append('requesting_dept', requestingDeptFilter);
      if (budgetYearFilter) params.append('budget_year', budgetYearFilter);
      params.append('order_by', sortBy);
      params.append('sort_order', sortOrder);
      params.append('page', page.toString());
      params.append('page_size', pageSize.toString());

      const response = await fetch(`/api/purchase-plans?${params.toString()}`);
      if (!response.ok) {
        throw new Error('fetch failed');
      }

      const data = await response.json();
      if (requestId !== dataRequestIdRef.current) {
        return;
      }

      const nextItems = Array.isArray(data?.data) ? data.data : [];
      const nextTotalCount = typeof data?.totalCount === 'number' ? data.totalCount : nextItems.length;
      setItems(nextItems);
      setTotalCount(nextTotalCount);

      if (data.page && data.page !== page) {
        setPage(data.page);
      }

      if (data.page_size && data.page_size !== pageSize) {
        setPageSize(data.page_size);
      }
    } catch (error) {
      console.error(error);
    } finally {
      if (requestId === dataRequestIdRef.current) {
        setLoading(false);
      }
    }
  };

  const fetchSummaryData = async () => {
    const requestId = ++summaryRequestIdRef.current;

    try {
      const params = new URLSearchParams();
      if (productNameFilter) params.append('product_name', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('product_type', typeFilter);
      if (subtypeFilter) params.append('product_subtype', subtypeFilter);
      if (requestingDeptFilter) params.append('requesting_dept', requestingDeptFilter);
      if (budgetYearFilter) params.append('budget_year', budgetYearFilter);
      params.append('order_by', sortBy);
      params.append('sort_order', sortOrder);

      const response = await fetch(`/api/purchase-plans?${params.toString()}`);
      if (!response.ok) {
        return;
      }

      const data = await response.json();
      if (requestId !== summaryRequestIdRef.current) {
        return;
      }

      setSummaryItems(Array.isArray(data?.data) ? data.data : []);
    } catch (error) {
      console.error(error);
    }
  };

  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount > 0 ? ((page - 1) * pageSize) + 1 : 0;
  const pageEnd = Math.min(page * pageSize, totalCount);

  const totalInventoryValue = summaryItems.reduce((sum, item) => sum + (item.inventory_value ?? 0), 0);
  const totalPurchaseValue = summaryItems.reduce((sum, item) => sum + (item.purchase_value ?? 0), 0);

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) {
      return;
    }

    setPage(newPage);
  };

  const handlePageSizeChange = (event: React.ChangeEvent<HTMLSelectElement>) => {
    const newSize = parseInt(event.target.value, 10);
    setPageSize(newSize);
    setPage(1);
  };

  const handleSort = (column: string) => {
    if (sortBy === column) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
      return;
    }

    setSortBy(column);
    setSortOrder('asc');
  };

  const getHeaderClass = (column: string) => `px-2 py-2.5 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${column === sortBy ? 'bg-gray-100' : ''}`;

  const startInlineEdit = (row: PurchasePlanRow) => {
    setEditingRowId(row.id);
    setEditingPurchaseQty(String(row.purchase_qty ?? 0));
  };

  const stopInlineEdit = () => {
    setEditingRowId(null);
    setEditingPurchaseQty('');
  };

  const savePurchaseQty = async (row: PurchasePlanRow, purchaseQtyText: string) => {
    const nextPurchaseQty = Number(purchaseQtyText);
    if (!Number.isFinite(nextPurchaseQty) || nextPurchaseQty < 0) {
      await Swal.fire({ icon: 'error', title: 'ข้อมูลไม่ถูกต้อง', text: 'purchase_qty ต้องเป็นตัวเลขตั้งแต่ 0 ขึ้นไป' });
      return false;
    }

    try {
      setSavingRowId(row.id);
      const purchaseValue = Number((nextPurchaseQty * Number(row.price_per_unit || 0)).toFixed(2));
      const response = await fetch(`/api/purchase-plans/${row.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          usage_plan_id: row.usage_plan_id,
          inventory_qty: row.inventory_qty ?? 0,
          inventory_value: row.inventory_value ?? 0,
          purchase_qty: nextPurchaseQty,
          purchase_value: purchaseValue,
        }),
      });

      const result = await response.json().catch(() => null);
      if (!response.ok || !result?.success) {
        throw new Error(result?.error || 'บันทึกไม่สำเร็จ');
      }

      setItems((prev) => prev.map((item) => (item.id === row.id ? result.data : item)));
      setSummaryItems((prev) => prev.map((item) => (item.id === row.id ? result.data : item)));
      return true;
    } catch (error) {
      console.error(error);
      await Swal.fire({ icon: 'error', title: 'บันทึกไม่สำเร็จ', text: error instanceof Error ? error.message : 'ไม่สามารถบันทึกข้อมูลได้' });
      return false;
    } finally {
      setSavingRowId(null);
      await Promise.all([fetchData(), fetchSummaryData()]);
    }
  };

  const moveToAdjacentRow = (rowId: number, direction: 'up' | 'down') => {
    const currentIndex = items.findIndex((item) => item.id === rowId);
    if (currentIndex === -1) {
      stopInlineEdit();
      return;
    }

    const nextIndex = direction === 'up' ? currentIndex - 1 : currentIndex + 1;
    if (nextIndex < 0 || nextIndex >= items.length) {
      stopInlineEdit();
      return;
    }

    const nextRow = items[nextIndex];
    setEditingRowId(nextRow.id);
    setEditingPurchaseQty(String(nextRow.purchase_qty ?? 0));
  };

  const handlePurchaseQtyBlur = async (row: PurchasePlanRow) => {
    if (savingRowId === row.id) {
      return;
    }

    const saved = await savePurchaseQty(row, editingPurchaseQty);
    if (saved) {
      stopInlineEdit();
    }
  };

  const handleSaveAction = async (row: PurchasePlanRow) => {
    if (savingRowId === row.id) {
      return;
    }

    const saved = await savePurchaseQty(row, editingPurchaseQty);
    if (saved) {
      stopInlineEdit();
    }
  };

  const handleCancelAction = () => {
    stopInlineEdit();
  };

  const handlePurchaseQtyKeyDown = async (event: React.KeyboardEvent<HTMLInputElement>, row: PurchasePlanRow) => {
    if (event.key === 'ArrowUp' || event.key === 'ArrowDown') {
      event.preventDefault();
      const direction = event.key === 'ArrowUp' ? 'up' : 'down';
      const saved = await savePurchaseQty(row, event.currentTarget.value);
      if (saved) {
        moveToAdjacentRow(row.id, direction);
      }
      return;
    }

    if (event.key === 'Enter') {
      event.preventDefault();
      const saved = await savePurchaseQty(row, event.currentTarget.value);
      if (saved) {
        stopInlineEdit();
      }
      return;
    }

    if (event.key === 'Escape') {
      event.preventDefault();
      stopInlineEdit();
    }
  };

  const handleDelete = async (id: number) => {
    const result = await Swal.fire({
      title: 'ยืนยันการลบ?',
      text: 'รายการแผนจัดซื้อนี้จะถูกลบออก',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'ลบ',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#dc2626',
    });

    if (!result.isConfirmed) {
      return;
    }

    try {
      const response = await fetch(`/api/purchase-plans/${id}`, { method: 'DELETE' });
      const payload = await response.json().catch(() => null);
      if (!response.ok || !payload?.success) {
        throw new Error(payload?.error || 'ลบไม่สำเร็จ');
      }

      await Promise.all([fetchData(), fetchSummaryData()]);
    } catch (error) {
      console.error(error);
      await Swal.fire({ icon: 'error', title: 'ลบไม่สำเร็จ', text: error instanceof Error ? error.message : 'ไม่สามารถลบข้อมูลได้' });
    }
  };

  useEffect(() => {
    const searchValue = bulkProductSearch.trim();
    if (searchValue.length === 0) {
      setBulkProductOptions([]);
      setShowBulkProductSuggestions(false);
      setHighlightedBulkProductIndex(-1);
      bulkProductSearchAbortRef.current?.abort();
      bulkProductSearchAbortRef.current = null;
      return;
    }

    const timeoutId = window.setTimeout(async () => {
      try {
        bulkProductSearchAbortRef.current?.abort();
        const controller = new AbortController();
        bulkProductSearchAbortRef.current = controller;

        const params = new URLSearchParams({
          page: '1',
          page_size: PRODUCT_SUGGESTION_LIMIT.toString(),
          order_by: 'code',
          sort_order: 'asc',
          search: searchValue,
        });

        const response = await fetch(`/api/products?${params.toString()}`, {
          signal: controller.signal,
        });

        if (!response.ok) {
          throw new Error('Failed to search products');
        }

        const data = await response.json();
        setBulkProductOptions((data.data || []) as ProductOption[]);
        setShowBulkProductSuggestions(true);
        setHighlightedBulkProductIndex(-1);
      } catch (error) {
        if ((error as Error).name === 'AbortError') {
          return;
        }
        console.error('Error searching bulk product options:', error);
        setBulkProductOptions([]);
      }
    }, 150);

    return () => {
      window.clearTimeout(timeoutId);
      bulkProductSearchAbortRef.current?.abort();
    };
  }, [bulkProductSearch]);

  useEffect(() => {
    if (!showBulkForm) {
      return;
    }

    const focusFrame = window.requestAnimationFrame(() => {
      bulkProductSearchInputRef.current?.focus();
    });

    return () => window.cancelAnimationFrame(focusFrame);
  }, [showBulkForm]);

  useEffect(() => {
    if (!showBulkProductSuggestions || highlightedBulkProductIndex < 0) {
      return;
    }

    const suggestionContainer = bulkProductSuggestionsRef.current;
    if (!suggestionContainer) {
      return;
    }

    const highlightedElement = suggestionContainer.querySelector<HTMLElement>(`[data-bulk-suggestion-index="${highlightedBulkProductIndex}"]`);
    highlightedElement?.scrollIntoView({ block: 'nearest' });
  }, [highlightedBulkProductIndex, showBulkProductSuggestions]);

  const createEmptyBulkRecord = (id: number): BulkPurchasePlanRecord => ({
    id,
    productSearch: '',
    product_code: '',
    category: '',
    product_type: '',
    product_subtype: '',
    product_name: '',
    requested_amount: '',
    unit: '',
    price_per_unit: '',
    requesting_dept: '',
    approved_quota: '',
    budget_year: getCurrentBudgetYear().toString(),
    sequence_no: '1'
  });

  const updateBulkRecord = (id: number, updater: (record: BulkPurchasePlanRecord) => BulkPurchasePlanRecord) => {
    setBulkRecords((prev) => prev.map((record) => (record.id === id ? updater(record) : record)));
  };

  const clearBulkValidationError = (id: number, field: 'requestedAmount' | 'requestingDept') => {
    setBulkValidationErrors((prev) => {
      const current = prev[id];
      if (!current?.[field]) {
        return prev;
      }

      const nextRecordErrors = { ...current };
      delete nextRecordErrors[field];

      if (Object.keys(nextRecordErrors).length === 0) {
        const nextErrors = { ...prev };
        delete nextErrors[id];
        return nextErrors;
      }

      return {
        ...prev,
        [id]: nextRecordErrors,
      };
    });
  };

  const handleBulkProductSearchKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    // If suggestions are visible, handle suggestion navigation first
    if (showBulkProductSuggestions && filteredBulkProductOptions.length > 0) {
      if (event.key === 'ArrowDown') {
        event.preventDefault();
        setHighlightedBulkProductIndex((prev) => (prev + 1) % filteredBulkProductOptions.length);
        return;
      }

      if (event.key === 'ArrowUp') {
        event.preventDefault();
        setHighlightedBulkProductIndex((prev) => (prev <= 0 ? filteredBulkProductOptions.length - 1 : prev - 1));
        return;
      }

      if (event.key === 'Enter') {
        event.preventDefault();
        const selectedIndex = highlightedBulkProductIndex >= 0 ? highlightedBulkProductIndex : 0;
        const selectedOption = filteredBulkProductOptions[selectedIndex];
        if (selectedOption) {
          handleBulkProductSelect(selectedOption.id, `${selectedOption.code} - ${selectedOption.name}`);
        }
        return;
      }

      if (event.key === 'Escape') {
        setShowBulkProductSuggestions(false);
        setHighlightedBulkProductIndex(-1);
        return;
      }
    }

    // Only handle navigation to table fields when suggestions are NOT visible
    if (event.key === 'ArrowDown' && !showBulkProductSuggestions && bulkRecords.length > 0) {
      event.preventDefault();
      // Focus the first requested amount field in the table
      const firstRecord = bulkRecords[0];
      const firstRequestedAmountField = document.getElementById(`purchase-bulk-requested-amount-${firstRecord.id}`);
      if (firstRequestedAmountField) {
        firstRequestedAmountField.focus();
      }
      return;
    }

    if (event.key === 'Escape') {
      setShowBulkProductSuggestions(false);
      setHighlightedBulkProductIndex(-1);
    }
  };

  const handleBulkFormKeyDown = (event: React.KeyboardEvent<HTMLInputElement>, recordId: number, field: string) => {
    // Only handle arrow keys for navigation
    if (event.key !== 'ArrowUp' && event.key !== 'ArrowDown' && event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') {
      return;
    }

    event.preventDefault();
    
    const recordIndex = bulkRecords.findIndex(r => r.id === recordId);
    if (recordIndex === -1) return;

    // Define field order for each record
    const fieldOrder = ['requested_amount', 'requesting_dept'];
    const currentFieldIndex = fieldOrder.indexOf(field);
    
    let nextElement: HTMLElement | null = null;

    if (event.key === 'ArrowUp') {
      if (recordIndex === 0 && field === 'requested_amount') {
        // From first record's requested amount, go back to product search
        nextElement = document.getElementById('purchase-bulk-product-search');
      } else if (recordIndex === 0 && field === 'requesting_dept') {
        // From first record's department, go back to product search
        nextElement = document.getElementById('purchase-bulk-product-search');
      } else if (recordIndex > 0) {
        // Move to same field in previous record
        const prevRecordId = bulkRecords[recordIndex - 1].id;
        const nextFieldId = field === 'requesting_dept' 
          ? `purchase-bulk-requesting-dept-${prevRecordId}`
          : `purchase-bulk-requested-amount-${prevRecordId}`;
        nextElement = document.getElementById(nextFieldId);
      }
    } else if (event.key === 'ArrowDown' && recordIndex < bulkRecords.length - 1) {
      // Move to same field in next record
      const nextRecordId = bulkRecords[recordIndex + 1].id;
      const nextFieldId = field === 'requesting_dept'
        ? `purchase-bulk-requesting-dept-${nextRecordId}`
        : `purchase-bulk-requested-amount-${nextRecordId}`;
      nextElement = document.getElementById(nextFieldId);
    } else if (event.key === 'ArrowDown' && recordIndex === bulkRecords.length - 1 && field === 'requesting_dept') {
      // From last record's department, move to save button
      nextElement = document.querySelector('button') as HTMLElement;
      // Find the save button by checking its text content
      const buttons = document.querySelectorAll('button');
      for (const button of buttons) {
        if (button.textContent?.includes('บันทึกทั้งหมด')) {
          nextElement = button as HTMLElement;
          break;
        }
      }
    } else if (event.key === 'ArrowRight' && currentFieldIndex < fieldOrder.length - 1) {
      // Move to next field in same record
      const nextField = fieldOrder[currentFieldIndex + 1];
      const nextFieldId = nextField === 'requesting_dept'
        ? `purchase-bulk-requesting-dept-${recordId}`
        : `purchase-bulk-requested-amount-${recordId}`;
      nextElement = document.getElementById(nextFieldId);
    } else if (event.key === 'ArrowLeft' && currentFieldIndex > 0) {
      // Move to previous field in same record
      const prevField = fieldOrder[currentFieldIndex - 1];
      const prevFieldId = prevField === 'requesting_dept'
        ? `purchase-bulk-requesting-dept-${recordId}`
        : `purchase-bulk-requested-amount-${recordId}`;
      nextElement = document.getElementById(prevFieldId);
    }

    // Focus the next element if found
    if (nextElement) {
      nextElement.focus();
    }
  };

  const filteredBulkProductOptions = bulkProductOptions.slice(0, PRODUCT_SUGGESTION_LIMIT);

  const shouldShowBulkProductNoResults = showBulkProductSuggestions
    && bulkProductSearch.trim().length > 0
    && bulkProductSearch.trim() !== selectedBulkProductLabel.trim()
    && filteredBulkProductOptions.length === 0;

  const handleBulkProductSelect = (id: number, value: string) => {
    const normalizedValue = value.trim().toLowerCase();
    const selectedProduct = bulkProductOptions.find((product) => {
      const label = `${product.code} - ${product.name}`.toLowerCase();
      return label === normalizedValue || product.code.toLowerCase() === normalizedValue || product.name.toLowerCase() === normalizedValue;
    });

    if (!selectedProduct) {
      setSelectedBulkProductLabel('');
      setShowBulkProductSuggestions(value.trim().length > 0);
      setHighlightedBulkProductIndex(-1);
      return;
    }

    const selectedLabel = `${selectedProduct.code} - ${selectedProduct.name}`;
    setSelectedBulkProductLabel('');
    setBulkProductSearch('');
    setShowBulkProductSuggestions(false);
    setHighlightedBulkProductIndex(-1);
    setBulkValidationErrors((prev) => {
      const nextErrors = { ...prev };
      delete nextErrors[id];
      return nextErrors;
    });
    setBulkRecordErrors((prev) => {
      const nextErrors = { ...prev };
      delete nextErrors[id];
      return nextErrors;
    });

    setBulkRecords((prev) => {
      const hasExistingRecord = prev.some((record) => record.product_code === selectedProduct.code);
      if (hasExistingRecord) {
        return prev;
      }

      const nextId = prev.length > 0 ? Math.max(...prev.map((record) => record.id)) + 1 : 1;
      return [
        ...prev,
        {
          id: nextId,
          productSearch: selectedLabel,
          product_code: selectedProduct.code || '',
          category: selectedProduct.category || '',
          product_type: selectedProduct.type || '',
          product_subtype: selectedProduct.subtype || '',
          product_name: selectedProduct.name || '',
          requested_amount: '',
          unit: selectedProduct.unit || '',
          price_per_unit: selectedProduct.cost_price?.toString() || '0',
          requesting_dept: '',
          approved_quota: '',
          budget_year: getCurrentBudgetYear().toString(),
          sequence_no: '1',
        },
      ];
    });
  };

  const validateBulkPurchasePlans = () => {
    const nextValidationErrors: Record<number, { requestedAmount?: string; requestingDept?: string }> = {};

    const validRecords = bulkRecords.filter((record) => {
      const hasProduct = record.product_code.trim() !== '' && record.product_name.trim() !== '';

      if (!hasProduct) {
        return false;
      }

      const requestedAmount = record.requested_amount.trim();
      const requestingDept = record.requesting_dept.trim();
      const recordErrors: { requestedAmount?: string; requestingDept?: string } = {};

      if (!requestedAmount || Number.isNaN(Number(requestedAmount)) || Number(requestedAmount) <= 0) {
        recordErrors.requestedAmount = 'กรุณากรอกจำนวนที่ขอมากกว่า 0';
      }

      if (!requestingDept) {
        recordErrors.requestingDept = 'กรุณาเลือกหน่วยงานที่ขอ';
      }

      if (Object.keys(recordErrors).length > 0) {
        nextValidationErrors[record.id] = recordErrors;
        return false;
      }

      return true;
    });

    setBulkValidationErrors(nextValidationErrors);
    return validRecords;
  };

  const saveBulkPurchasePlans = () => {
    const validRecords = validateBulkPurchasePlans();

    if (validRecords.length === 0) {
      return;
    }

    console.log('Saving bulk purchase plans:', validRecords);
  };

  return (
    <div className="p-6 bg-gray-50 min-h-screen">
      <div className="mb-6 flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">แผนจัดซื้อ</h1>
        </div>
        <button
          type="button"
          onClick={() => {
            setShowBulkForm(true);
            setBulkRecords([]);
            setBulkRecordErrors({});
          }}
          className="inline-flex items-center gap-2 rounded-lg bg-blue-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition-colors hover:bg-blue-700"
          title="เพิ่มแผนจัดซื้อใหม่"
        >
          <Plus className="h-5 w-5" />
          <span>เพิ่มแผนจัดซื้อ</span>
        </button>
      </div>

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 md:grid-cols-6 gap-4 mb-4">
            <select value={budgetYearFilter} onChange={(event) => setBudgetYearFilter(event.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ปีงบ</option>
              {availableBudgetYears.map((year) => <option key={year} value={year}>{year}</option>)}
            </select>
            <select value={requestingDeptFilter} onChange={(event) => setRequestingDeptFilter(event.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หน่วยงาน</option>
              {departments.map((department) => <option key={department} value={department}>{department}</option>)}
            </select>
            <div className="relative">
              <input
                placeholder="รหัสสินค้า / ชื่อสินค้า"
                value={productNameFilter}
                onChange={(event) => setProductNameFilter(event.target.value)}
                className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2 pr-10"
              />
              {productNameFilter && (
                <button
                  type="button"
                  onClick={() => setProductNameFilter('')}
                  className="absolute right-2 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                  title="ล้างค่า"
                >
                  <X className="h-4 w-4" />
                </button>
              )}
            </div>
            <select value={categoryFilter} onChange={(event) => { setCategoryFilter(event.target.value); setTypeFilter(''); setSubtypeFilter(''); }} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หมวด</option>
              {categories.map((category) => <option key={category} value={category}>{category}</option>)}
            </select>
            <select value={typeFilter} onChange={(event) => { setTypeFilter(event.target.value); setSubtypeFilter(''); }} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภท</option>
              {availableTypes.map((type) => <option key={type} value={type}>{type}</option>)}
            </select>
            <select value={subtypeFilter} onChange={(event) => setSubtypeFilter(event.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภทย่อย</option>
              {availableSubtypes.map((subtype) => <option key={subtype} value={subtype}>{subtype}</option>)}
            </select>
          </div>
          {filtersLoading && <p className="text-xs text-gray-500">กำลังโหลดตัวเลือกตัวกรอง...</p>}
        </div>
      </div>

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <h3 className="text-lg font-medium text-gray-900">สรุปข้อมูลแผนการจัดซื้อ</h3>
            <div className="flex flex-wrap items-center gap-6 text-sm">
              <div>
                <span className="text-gray-500">มูลค่าสินค้าคงคลัง (inventory_value): </span>
                <span className="font-semibold text-gray-900">฿{totalInventoryValue.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</span>
              </div>
              <div>
                <span className="text-gray-500">มูลค่าจัดซื้อ (purchase_value): </span>
                <span className="font-semibold text-gray-900">฿{totalPurchaseValue.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="mt-4 flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div className="text-sm text-gray-600">แสดง {pageStart}-{pageEnd} จาก {totalCount} รายการ</div>
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
          <div className="flex items-center gap-2">
            <span className="text-sm text-gray-600">แสดงต่อหน้า</span>
            <select value={pageSize} onChange={handlePageSizeChange} className="rounded border border-gray-300 px-2 py-1 text-sm">
              {[10, 20, 50].map((size) => <option key={size} value={size}>{size}</option>)}
            </select>
          </div>
          <div className="flex items-center gap-2">
            <button onClick={() => goToPage(page - 1)} disabled={page === 1} className={`px-3 py-1 rounded border text-sm ${page === 1 ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-100'}`}>
              ก่อนหน้า
            </button>
            <span className="text-sm text-gray-700">หน้า {page} / {totalPages}</span>
            <button onClick={() => goToPage(page + 1)} disabled={page >= totalPages} className={`px-3 py-1 rounded border text-sm ${page >= totalPages ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-100'}`}>
              ถัดไป
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white shadow-md rounded-lg overflow-hidden mt-4">
        <div className="overflow-x-auto">
        {loading ? (
          <div className="flex justify-center items-center py-12">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          </div>
        ) : items.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-500">ไม่พบข้อมูล</p>
          </div>
        ) : (
          <table className="min-w-[1400px] w-full divide-y divide-gray-200 table-fixed">
            <thead className="bg-gray-50">
              <tr>
                <th onClick={() => handleSort('budget_year')} className={`${getHeaderClass('budget_year')} w-20`}>ปีงบ</th>
                <th onClick={() => handleSort('sequence_no')} className={`${getHeaderClass('sequence_no')} w-16`}>ครั้งที่</th>
                <th onClick={() => handleSort('product_code')} className={`${getHeaderClass('product_code')} w-28`}>รหัสสินค้า</th>
                <th onClick={() => handleSort('product_name')} className={`${getHeaderClass('product_name')} w-[20rem]`}>ชื่อสินค้า</th>
                <th onClick={() => handleSort('price_per_unit')} className={`${getHeaderClass('price_per_unit')} w-24`}>ราคา/หน่วย</th>
                <th onClick={() => handleSort('requesting_dept')} className={`${getHeaderClass('requesting_dept')} w-36`}>หน่วยงานที่ขอ</th>
                <th onClick={() => handleSort('requested_amount')} className={`${getHeaderClass('requested_amount')} w-24`}>จำนวนที่ขอ</th>
                <th onClick={() => handleSort('approved_quota')} className={`${getHeaderClass('approved_quota')} w-24`}>โควต้าที่ได้</th>
                <th onClick={() => handleSort('inventory_qty')} className={`${getHeaderClass('inventory_qty')} w-20`}>คงคลัง</th>
                <th onClick={() => handleSort('inventory_value')} className={`${getHeaderClass('inventory_value')} w-28`}>มูลค่าคงคลัง</th>
                <th onClick={() => handleSort('purchase_qty')} className={`${getHeaderClass('purchase_qty')} w-20`}>ซื้อ</th>
                <th onClick={() => handleSort('purchase_value')} className={`${getHeaderClass('purchase_value')} w-28`}>มูลค่าซื้อ</th>
                <th className="px-2 py-2.5 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-20">Action</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {items.map((row) => {
                const isEditingRow = editingRowId === row.id;
                const isSavingRow = savingRowId === row.id;

                return (
                  <tr key={row.id} className={isEditingRow ? 'bg-yellow-50' : ''}>
                    <td className="px-2 py-2 text-[11px] align-top">{row.budget_year ?? '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.sequence_no ?? '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top break-all">{row.product_code || '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">
                      <div className="font-medium text-gray-900 whitespace-normal break-words leading-4" title={row.product_name || ''}>{row.product_name || '-'}</div>
                      <div className="mt-1 text-[10px] leading-4 text-emerald-600/80">{[row.category || '-', row.product_type || '-', row.product_subtype || '-'].filter((value, index, arr) => !(value === '-' && arr.every((item) => item === '-'))).join(' · ')}</div>
                    </td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.price_per_unit ? Number(row.price_per_unit).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top break-words">{row.requesting_dept || '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.requested_amount ?? '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.approved_quota ?? '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.inventory_qty ?? '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.inventory_value ? Number(row.inventory_value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : row.inventory_value === 0 ? '0.00' : '-'}</td>
                    <td
                      className={`px-2 py-2 text-[11px] align-top ${!isEditingRow ? 'cursor-text hover:bg-yellow-50' : ''}`}
                      onClick={() => {
                        if (!isEditingRow) {
                          startInlineEdit(row);
                        }
                      }}
                    >
                      {isEditingRow ? (
                        <input
                          type="number"
                          min="0"
                          value={editingPurchaseQty}
                          onChange={(event) => setEditingPurchaseQty(event.target.value)}
                          onBlur={() => void handlePurchaseQtyBlur(row)}
                          onKeyDown={(event) => void handlePurchaseQtyKeyDown(event, row)}
                          ref={(element) => {
                            purchaseQtyInputRefs.current[row.id] = element;
                          }}
                          className="w-20 rounded border border-amber-300 bg-white px-2 py-1 text-[11px] shadow-sm outline-none ring-2 ring-amber-100"
                          disabled={isSavingRow}
                        />
                      ) : (
                        row.purchase_qty ?? '-'
                      )}
                    </td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.purchase_value ? Number(row.purchase_value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : row.purchase_value === 0 ? '0.00' : '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top font-medium w-20">
                      {isEditingRow ? (
                        <div className="flex items-center gap-3">
                          <button onClick={() => void handleSaveAction(row)} className="text-emerald-600 hover:text-emerald-800 cursor-pointer disabled:opacity-50" title="บันทึก" aria-label="บันทึก" disabled={isSavingRow}>
                            <CheckCircle className="h-5 w-5" />
                          </button>
                          <button onClick={handleCancelAction} className="text-gray-500 hover:text-gray-700 cursor-pointer" title="ยกเลิก" aria-label="ยกเลิก">
                            <XCircle className="h-5 w-5" />
                          </button>
                        </div>
                      ) : (
                        <div className="flex items-center gap-3">
                          <button
                            onClick={(event) => {
                              event.stopPropagation();
                              startInlineEdit(row);
                            }}
                            className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                            title="แก้ไข"
                            aria-label="แก้ไข"
                          >
                            <Pencil className="h-5 w-5" />
                          </button>
                          <button onClick={() => void handleDelete(row.id)} className="text-red-600 hover:text-red-900 cursor-pointer" title="ลบ" aria-label="ลบ">
                            <Trash2 className="h-5 w-5" />
                          </button>
                        </div>
                      )}
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        )}
        </div>
      </div>

      {/* Bulk Add Purchase Plans Modal */}
      {showBulkForm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-100/80 p-2 backdrop-blur-sm md:p-4">
          <div className="flex h-[96vh] w-[98vw] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-[0_24px_80px_rgba(15,23,42,0.18)] ring-1 ring-slate-200">
            <div className="flex items-center justify-between border-b border-slate-200 bg-gradient-to-r from-blue-50 via-white to-slate-50 px-5 py-3">
              <div>
                <h2 className="text-lg font-bold text-slate-900">เพิ่มรายการสินค้าเข้าแผนจัดซื้อ</h2>
              </div>
              <button
                type="button"
                onClick={() => {
                  setShowBulkForm(false);
                  setBulkRecords([]);
                  setBulkProductSearch('');
                  setBulkProductOptions([]);
                  setBulkRecordErrors({});
                }}
                className="rounded-full p-1.5 text-slate-500 transition-colors hover:bg-white hover:text-slate-700"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="flex min-h-0 flex-1 flex-col px-6 py-6">
              <div className="relative z-20 mb-4 rounded-2xl border border-blue-100 bg-blue-50 p-4">
                <label htmlFor="purchase-bulk-product-search" className="mb-2 block text-sm font-medium text-gray-700">
                  ค้นหารหัสหรือชื่อสินค้า
                </label>
                <div className="relative">
                  <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
                  <input
                    ref={bulkProductSearchInputRef}
                    id="purchase-bulk-product-search"
                    name="purchaseBulkProductSearch"
                    type="text"
                    value={bulkProductSearch}
                    onChange={(e) => {
                      setBulkProductSearch(e.target.value);
                      setSelectedBulkProductLabel('');
                      setShowBulkProductSuggestions(true);
                      setHighlightedBulkProductIndex(-1);
                    }}
                    onFocus={() => {
                      if (bulkProductSearch.trim() && bulkProductSearch.trim() !== selectedBulkProductLabel.trim()) {
                        setShowBulkProductSuggestions(true);
                      }
                    }}
                    onKeyDown={handleBulkProductSearchKeyDown}
                    placeholder="พิมพ์รหัสสินค้า หรือชื่อสินค้า"
                    autoComplete="off"
                    aria-label="ค้นหารหัสหรือชื่อสินค้า"
                    className="w-full rounded-md border border-gray-300 bg-white px-3 py-2 pl-9 pr-9 focus:outline-none focus:ring-2 focus:ring-blue-500"
                  />
                  {bulkProductSearch && (
                    <button
                      type="button"
                      onClick={() => {
                        setBulkProductSearch('');
                        setSelectedBulkProductLabel('');
                        setShowBulkProductSuggestions(false);
                        setHighlightedBulkProductIndex(-1);
                      }}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                      aria-label="ล้างคำค้น"
                    >
                      <X className="h-4 w-4" />
                    </button>
                  )}
                  {showBulkProductSuggestions && (
                    <div
                      ref={bulkProductSuggestionsRef}
                      className="absolute z-50 mt-2 max-h-72 w-full overflow-auto rounded-md border border-gray-200 bg-white shadow-2xl"
                    >
                      {shouldShowBulkProductNoResults ? (
                        <div className="px-4 py-3 text-sm text-gray-500">ไม่พบรายการที่ค้นหา</div>
                      ) : (
                        filteredBulkProductOptions.map((product, index) => {
                          const label = `${product.code} - ${product.name}`;
                          return (
                            <button
                              key={product.id}
                              data-bulk-suggestion-index={index}
                              type="button"
                              onMouseDown={(event) => event.preventDefault()}
                              onClick={() => handleBulkProductSelect(product.id, label)}
                              className={`block w-full border-b border-gray-100 px-4 py-3 text-left text-sm ${index === highlightedBulkProductIndex ? 'bg-blue-50' : 'hover:bg-gray-50'}`}
                            >
                              <div className="font-medium text-gray-900">{label}</div>
                              <div className="text-xs text-gray-500">{product.category || '-'} | {product.type || '-'} | {product.unit || '-'}</div>
                            </button>
                          );
                        })
                      )}
                    </div>
                  )}
                </div>
              </div>
              <div className="min-h-0 flex-1 overflow-hidden rounded-xl border border-slate-200 bg-slate-50">
                <div className="h-full overflow-auto">
                  {bulkRecords.length > 0 ? (
                    <table className="w-full">
                      <thead className="bg-slate-100">
                        <tr>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ลำดับ</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">รหัสสินค้า</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ชื่อสินค้า</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จำนวนที่ขอ</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หน่วย</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หน่วยงานที่ขอ</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จัดการ</th>
                        </tr>
                      </thead>
                      <tbody>
                        {bulkRecords.map((record, index) => (
                          <tr key={record.id} className="border-b border-slate-200 bg-white">
                            <td className="w-12 px-2 py-3 text-sm text-gray-900">{index + 1}</td>
                            <td className="w-36 px-2 py-3">
                              <input
                                id={`purchase-bulk-product-code-${record.id}`}
                                name={`bulkProductCode-${record.id}`}
                                aria-label={`รหัสสินค้า แถว ${index + 1}`}
                                type="text"
                                value={record.product_code}
                                readOnly
                                placeholder="รหัสสินค้า"
                                className="w-full px-2 py-1 border border-gray-300 rounded bg-gray-100 text-sm"
                              />
                            </td>
                            <td className="min-w-[24rem] px-2 py-3">
                              <input
                                id={`purchase-bulk-product-name-${record.id}`}
                                name={`bulkProductName-${record.id}`}
                                aria-label={`ชื่อสินค้า แถว ${index + 1}`}
                                type="text"
                                value={record.product_name}
                                readOnly
                                placeholder="ชื่อสินค้า"
                                title={record.product_name || ''}
                                className={`w-full px-2 py-1 border rounded bg-gray-100 text-sm ${
                                  bulkRecordErrors[record.id] ? 'border-red-500' : 'border-gray-300'
                                }`}
                              />
                              {bulkRecordErrors[record.id] && (
                                <div className="mt-1 text-xs text-red-600 font-medium">
                                  {bulkRecordErrors[record.id]}
                                </div>
                              )}
                            </td>
                            <td className="w-32 px-2 py-3">
                              <input
                                id={`purchase-bulk-requested-amount-${record.id}`}
                                name={`bulkRequestedAmount-${record.id}`}
                                aria-label={`จำนวนที่ขอ แถว ${index + 1}`}
                                type="number"
                                required
                                min="1"
                                value={record.requested_amount || ''}
                                onChange={(e) => {
                                  updateBulkRecord(record.id, (current) => {
                                    const shouldSyncApprovedQuota =
                                      current.approved_quota === '' ||
                                      current.approved_quota === current.requested_amount;

                                    return {
                                      ...current,
                                      requested_amount: e.target.value,
                                      approved_quota: shouldSyncApprovedQuota ? e.target.value : current.approved_quota,
                                    };
                                  });
                                  clearBulkValidationError(record.id, 'requestedAmount');
                                }}
                                onKeyDown={(e) => handleBulkFormKeyDown(e, record.id, 'requested_amount')}
                                placeholder="จำนวนที่ขอ"
                                className={`w-full px-2 py-1 border rounded focus:outline-none focus:ring-2 text-sm ${bulkValidationErrors[record.id]?.requestedAmount ? 'border-red-500 focus:ring-red-500' : 'border-gray-300 focus:ring-blue-500'}`}
                              />
                              {bulkValidationErrors[record.id]?.requestedAmount && (
                                <p className="mt-1 text-xs text-red-600">{bulkValidationErrors[record.id]?.requestedAmount}</p>
                              )}
                            </td>
                            <td className="w-24 px-2 py-3">
                              <input
                                id={`purchase-bulk-unit-${record.id}`}
                                name={`bulkUnit-${record.id}`}
                                aria-label={`หน่วย แถว ${index + 1}`}
                                type="text"
                                value={record.unit || ''}
                                readOnly
                                placeholder="หน่วย"
                                className="w-full px-2 py-1 border border-gray-300 rounded bg-gray-100 text-sm"
                              />
                            </td>
                            <td className="min-w-[14rem] px-2 py-3">
                              <input
                                id={`purchase-bulk-approved-quota-${record.id}`}
                                name={`bulkApprovedQuota-${record.id}`}
                                aria-label={`โควต้าที่ได้รับ แถว ${index + 1}`}
                                type="hidden"
                                value={record.approved_quota || ''}
                                readOnly
                              />
                              <DepartmentCombobox
                                id={`purchase-bulk-requesting-dept-${record.id}`}
                                name={`bulkRequestingDept-${record.id}`}
                                aria_label={`หน่วยงานที่ขอ แถว ${index + 1}`}
                                required
                                value={record.requesting_dept || ''}
                                departments={departments}
                                placeholder="เลือกหน่วยงาน"
                                on_change={(value) => {
                                  updateBulkRecord(record.id, (current) => ({ ...current, requesting_dept: value }));
                                  clearBulkValidationError(record.id, 'requestingDept');
                                }}
                                on_clear_error={() => clearBulkValidationError(record.id, 'requestingDept')}
                                on_key_down={(e) => handleBulkFormKeyDown(e, record.id, 'requesting_dept')}
                                class_name={`w-full px-2 py-1 border rounded focus:outline-none focus:ring-2 text-sm ${bulkValidationErrors[record.id]?.requestingDept ? 'border-red-500 focus:ring-red-500' : 'border-gray-300 focus:ring-blue-500'}`}
                                list_class_name="absolute z-40 mt-1 max-h-60 w-full overflow-auto rounded-md border border-gray-200 bg-white shadow-xl"
                              />
                              {bulkValidationErrors[record.id]?.requestingDept && (
                                <p className="mt-1 text-xs text-red-600">{bulkValidationErrors[record.id]?.requestingDept}</p>
                              )}
                            </td>
                            <td className="w-16 px-2 py-3">
                              <div className="flex gap-1">
                                {bulkRecords.length > 0 && (
                                  <button
                                    type="button"
                                    onClick={() => {
                                      setBulkRecords(bulkRecords.filter((r) => r.id !== record.id));
                                      setBulkValidationErrors((prev) => {
                                        const nextErrors = { ...prev };
                                        delete nextErrors[record.id];
                                        return nextErrors;
                                      });
                                    }}
                                    className="text-red-600 hover:text-red-900 p-1"
                                    title="ลบแถวนี้"
                                  >
                                    <X className="h-4 w-4" />
                                  </button>
                                )}
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  ) : (
                    <div className="flex items-center justify-center h-32">
                      <p className="text-gray-500">ยังไม่มีรายการสินค้า</p>
                    </div>
                  )}
                </div>
              </div>

              <div className="flex items-center justify-end gap-3 border-t border-slate-200 bg-slate-50 px-6 py-5">
                <button
                  type="button"
                  onClick={() => {
                    setShowBulkForm(false);
                    setBulkRecords([]);
                    setBulkValidationErrors({});
                    setBulkProductSearch('');
                    setBulkProductOptions([]);
                    setBulkRecordErrors({});
                  }}
                  className="rounded-lg bg-slate-500 px-6 py-2.5 text-white transition-colors hover:bg-slate-600"
                >
                  ยกเลิก
                </button>
                <button
                  type="button"
                  onClick={saveBulkPurchasePlans}
                  className="rounded-lg bg-blue-600 px-6 py-2.5 text-white shadow-sm transition-colors hover:bg-blue-700"
                >
                  บันทึกทั้งหมด ({bulkRecords.length} รายการ)
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

export default function PurchasePlansPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-gray-50" />}>
      <PurchasePlansPageContent />
    </Suspense>
  );
}
