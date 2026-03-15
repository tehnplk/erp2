'use client';

import { Suspense, useEffect, useMemo, useRef, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { CheckCircle, Pencil, Trash2, XCircle, X, Download, RefreshCw, Plus, FileText } from 'lucide-react';

const getCurrentBudgetYear = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

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
  has_purchase_approval?: boolean;
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
  usage_plan_id: number | null;
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
  inventory_qty: number;
  available_qty: number;
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
  requesting_dept?: string;
  requested_amount?: string;
  approved_quota?: string;
  budget_year?: string;
  sequence_no?: string;
  inventory_qty?: number;
  available_qty?: number;
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

function getSortIcon(column: string, currentSortBy: string, currentSortOrder: 'asc' | 'desc') {
  const pathname = usePathname();
  const searchParams = useSearchParams();

  const initialProductNameFilter = searchParams.get('product_name') || '';
  const initialCategoryFilter = searchParams.get('category') || '';
  const initialTypeFilter = searchParams.get('product_type') || '';
  const initialSubtypeFilter = searchParams.get('product_subtype') || '';
  const initialRequestingDeptFilter = searchParams.get('requesting_dept') || '';
  const initialBudgetYearFilter = searchParams.get('budget_year') || '';
  const initialHasPurchaseApprovalFilter = searchParams.get('has_purchase_approval') || '';
  const initialSortBy = searchParams.get('order_by') || 'id';
  const initialSortOrder = (searchParams.get('sort_order') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
  const initialPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
  const initialPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);

  if (column === currentSortBy) {
    if (currentSortOrder === 'asc') {
      return <XCircle />;
    } else {
      return <CheckCircle />;
    }
  } else {
    return <Pencil />;
  }
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
  const initialHasPurchaseApprovalFilter = searchParams.get('has_purchase_approval') || '';
  const initialSortBy = searchParams.get('order_by') || 'id';
  const initialSortOrder = (searchParams.get('sort_order') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
  const initialPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
  const initialPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);

  const [items, setItems] = useState<PurchasePlanRow[]>([]);
  const [summaryItems, setSummaryItems] = useState<PurchasePlanRow[]>([]);
  const [statusCountItems, setStatusCountItems] = useState<PurchasePlanRow[]>([]);
  const [selectedRows, setSelectedRows] = useState<Set<number>>(new Set());
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [filtersLoading, setFiltersLoading] = useState(true);
  const [savingRowId, setSavingRowId] = useState<number | null>(null);
  const [editingRowId, setEditingRowId] = useState<number | null>(null);
  const [editingPurchaseQty, setEditingPurchaseQty] = useState<string>('');
  const purchaseQtyInputRefs = useRef<Record<number, HTMLInputElement | null>>({});
  const dataRequestIdRef = useRef(0);
  const lastPushedUrlRef = useRef('');
  const prevFilterKeyRef = useRef('');
  const [productNameFilter, setProductNameFilter] = useState(initialProductNameFilter);
  const [categoryFilter, setCategoryFilter] = useState(initialCategoryFilter);
  const [typeFilter, setTypeFilter] = useState(initialTypeFilter);
  const [subtypeFilter, setSubtypeFilter] = useState(initialSubtypeFilter);
  const [requestingDeptFilter, setRequestingDeptFilter] = useState(initialRequestingDeptFilter);
  const [budgetYearFilter, setBudgetYearFilter] = useState(initialBudgetYearFilter);
  const [hasPurchaseApprovalFilter, setHasPurchaseApprovalFilter] = useState(initialHasPurchaseApprovalFilter);

  const [sortBy, setSortBy] = useState(initialSortBy);
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>(initialSortOrder);
  const [page, setPage] = useState(initialPage);
  const [pageSize, setPageSize] = useState(initialPageSize);

  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<CategoryOption[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);
  const [years, setYears] = useState<string[]>([]);
  const [approvedPlanIds, setApprovedPlanIds] = useState<Set<number>>(new Set());

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
    void fetchApprovedPlanIds();
  }, [sortBy, sortOrder, page, pageSize, productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, hasPurchaseApprovalFilter]);

  useEffect(() => {
    void fetchSummaryData();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, hasPurchaseApprovalFilter, sortBy, sortOrder]);

  useEffect(() => {
    const fetchStatusCountItems = async () => {
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
        setStatusCountItems(Array.isArray(data?.data) ? data.data : []);
      } catch (error) {
        console.error('Error fetching purchase plan status counts:', error);
      }
    };

    void fetchStatusCountItems();
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
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, hasPurchaseApprovalFilter, sortBy, sortOrder]);

  useEffect(() => {
    const nextProductName = searchParams.get('product_name') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('product_type') || '';
    const nextSubtype = searchParams.get('product_subtype') || '';
    const nextRequestingDept = searchParams.get('requesting_dept') || '';
    const nextBudgetYear = searchParams.get('budget_year') || '';
    const nextHasPurchaseApproval = searchParams.get('has_purchase_approval') || '';
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
    setHasPurchaseApprovalFilter((prev) => (prev === nextHasPurchaseApproval ? prev : nextHasPurchaseApproval));
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
    if (hasPurchaseApprovalFilter) params.set('has_purchase_approval', hasPurchaseApprovalFilter);
    if (sortBy && sortBy !== 'id') params.set('order_by', sortBy);
    if (sortOrder !== 'desc') params.set('sort_order', sortOrder);
    if (page > 1) params.set('page', page.toString());
    if (pageSize !== 20) params.set('page_size', pageSize.toString());

    const nextUrl = params.toString() ? `${pathname}?${params.toString()}` : pathname;
    const currentUrl = searchParams.toString() ? `${pathname}?${searchParams.toString()}` : pathname;

    if (nextUrl !== currentUrl) {
      router.replace(nextUrl, { scroll: false });
    }
  }, [pathname, router, searchParams, productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, hasPurchaseApprovalFilter, sortBy, sortOrder, page, pageSize]);

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
      if (hasPurchaseApprovalFilter) params.append('has_purchase_approval', hasPurchaseApprovalFilter);
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

  const fetchApprovedPlanIds = async () => {
    try {
      // Don't filter by budget year - get all approved plans
      const response = await fetch('/api/purchase-plans/approved');
      if (!response.ok) {
        throw new Error('Failed to fetch approved purchase plans');
      }

      const data = await response.json();
      if (data.success) {
        setApprovedPlanIds(new Set(data.data));
      }
    } catch (error) {
      console.error('Error fetching approved purchase plans:', error);
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
      if (hasPurchaseApprovalFilter) params.append('has_purchase_approval', hasPurchaseApprovalFilter);
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
  const purchaseApprovalCreatedCount = statusCountItems.filter((item) => item.has_purchase_approval).length;
  const purchaseApprovalPendingCount = statusCountItems.filter((item) => !item.has_purchase_approval).length;

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

  const handleSelectAll = (checked: boolean) => {
    if (checked) {
      const selectableItems = items.filter((item) => !item.has_purchase_approval);
      const selectedItems = items.filter((item) => selectedRows.has(item.id));
      const selectedCategory = selectedItems[0]?.category ?? null;

      if (!selectedCategory) {
        const availableCategories = Array.from(
          new Set(
            selectableItems
              .map((item) => item.category)
              .filter((category): category is string => Boolean(category))
          )
        );

        if (availableCategories.length > 1) {
          void Swal.fire({
            icon: 'warning',
            title: 'เลือกได้เฉพาะหมวดเดียวกัน',
            text: 'การทำเอกสารอนุมัติจัดซื้อสามารถเลือกรายการสินค้าได้เฉพาะหมวดเดียวกัน กรุณากรองหรือเลือกเฉพาะหมวดเดียวก่อน',
          });
          return;
        }
      }

      const selectableIds = new Set(
        selectableItems
          .filter((item) => !selectedCategory || item.category === selectedCategory)
          .map((item) => item.id)
      );
      setSelectedRows(selectableIds);
    } else {
      setSelectedRows(new Set());
    }
  };

  const handleRowSelect = (id: number, checked: boolean) => {
    const currentItem = items.find((item) => item.id === id);
    if (currentItem?.has_purchase_approval) {
      return;
    }

    if (checked && currentItem) {
      const selectedItems = items.filter((item) => selectedRows.has(item.id));
      const selectedCategory = selectedItems[0]?.category ?? null;

      if (selectedCategory && currentItem.category !== selectedCategory) {
        void Swal.fire({
          icon: 'warning',
          title: 'เลือกได้เฉพาะหมวดเดียวกัน',
          text: `รายการที่เลือกอยู่คนละหมวดกับรายการที่เลือกไว้แล้ว (${selectedCategory})`,
        });
        return;
      }
    }

    setSelectedRows(prev => {
      const newSet = new Set(prev);
      if (checked) {
        newSet.add(id);
      } else {
        newSet.delete(id);
      }
      return newSet;
    });
  };

  const selectableRowIds = useMemo(
    () => items.filter((item) => !item.has_purchase_approval).map((item) => item.id),
    [items]
  );
  const isAllSelected = selectableRowIds.length > 0 && selectableRowIds.every((id) => selectedRows.has(id));
  const isIndeterminate = selectedRows.size > 0 && !isAllSelected;

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
      setSelectedRows(prev => {
        const newSet = new Set(prev);
        newSet.delete(id);
        return newSet;
      });
    } catch (error) {
      console.error(error);
      await Swal.fire({ icon: 'error', title: 'ลบไม่สำเร็จ', text: error instanceof Error ? error.message : 'ไม่สามารถลบข้อมูลได้' });
    }
  };

  const handleBulkPurchaseApproval = async () => {
    if (selectedRows.size === 0) {
      await Swal.fire({ icon: 'warning', title: 'ไม่ได้เลือกรายการ', text: 'กรุณาเลือกรายการที่ต้องการทำรายการอนุมัติจัดซื้อ' });
      return;
    }

    const selectedItems = items.filter(item => selectedRows.has(item.id));
    const selectedCategories = Array.from(
      new Set(
        selectedItems
          .map((item) => item.category)
          .filter((category): category is string => Boolean(category))
      )
    );

    if (selectedCategories.length !== 1) {
      await Swal.fire({
        icon: 'warning',
        title: 'เลือกได้เฉพาะหมวดเดียวกัน',
        text: 'การทำเอกสารอนุมัติจัดซื้อสามารถเลือกรายการสินค้าได้เฉพาะหมวดเดียวกันเท่านั้น',
      });
      return;
    }

    const result = await Swal.fire({
      title: 'ยืนยันการทำรายการอนุมัติจัดซื้อ?',
      html: `จะทำรายการอนุมัติจัดซื้อ <strong>${selectedRows.size}</strong> รายการ<br/>รายการเหล่านี้จะถูกส่งไปยังระบบการอนุมัติการจัดซื้อ`,
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'ยืนยัน',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#10b981',
    });

    if (!result.isConfirmed) {
      return;
    }

    try {
      // Create payload for new purchase_approval table structure
      const details = selectedItems.map((item, index) => ({
        purchase_plan_id: item.id, // Link to the purchase plan
        approved_quantity: item.purchase_qty || 0,
        approved_amount: (item.purchase_qty || 0) * (item.price_per_unit || 0),
        line_number: index + 1, // Start from 1
        status: 'PENDING'
      }));

      // Create header with basic info
      const header = {
        budget_year: selectedItems[0]?.budget_year ?? new Date().getFullYear() + 543,
        department: 'กลุ่มงานบริหารทั่วไป', // Default department
        doc_date: new Date(Date.now() - new Date().getTimezoneOffset() * 60000).toISOString().split('T')[0], // Current date
        notes: `สร้างจากแผนจัดซื้อ ${selectedItems.length} รายการ`,
        created_by: 'system'
      };

      const response = await fetch('/api/purchase-approvals/bulk', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ header, details }),
      });

      const payload = await response.json().catch(() => null);
      if (!response.ok || !payload?.success) {
        throw new Error(payload?.error || 'ทำรายการอนุมัติจัดซื้อไม่สำเร็จ');
      }

      await Swal.fire({ 
        icon: 'success', 
        title: 'ทำรายการอนุมัติจัดซื้อสำเร็จ', 
        html: `สร้างรายการอนุมัติจัดซื้อ ${payload.data?.created || 0} รายการเรียบร้อยแล้ว<br/><strong>รหัสเอกสาร: ${payload.data?.approve_code || 'N/A'}</strong><br/><strong>เลขที่หนังสือ: ${payload.data?.doc_no || 'N/A'}</strong>` 
      });

      // Clear selection and refresh data
      setSelectedRows(new Set());
      await Promise.all([fetchData(), fetchSummaryData()]);
    } catch (error) {
      console.error(error);
      await Swal.fire({ 
        icon: 'error', 
        title: 'ทำรายการอนุมัติจัดซื้อไม่สำเร็จ', 
        text: error instanceof Error ? error.message : 'ไม่สามารถทำรายการได้' 
      });
    }
  };

  const handleBulkRemoveFromPlan = async () => {
    if (selectedRows.size === 0) {
      await Swal.fire({ icon: 'warning', title: 'ไม่ได้เลือกรายการ', text: 'กรุณาเลือกรายการที่ต้องการนำออกจากแผนจัดซื้อ' });
      return;
    }

    const result = await Swal.fire({
      title: 'ยืนยันการนำออกจากแผนจัดซื้อ?',
      html: `จะนำออก <strong>${selectedRows.size}</strong> รายการจากแผนจัดซื้อ<br/>รายการเหล่านี้จะถูกลบออกจากระบบถาวร`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'นำออก',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#dc2626',
    });

    if (!result.isConfirmed) {
      return;
    }

    try {
      const response = await fetch('/api/purchase-plans/bulk', {
        method: 'DELETE',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ ids: Array.from(selectedRows) }),
      });

      const payload = await response.json().catch(() => null);
      if (!response.ok || !payload?.success) {
        throw new Error(payload?.error || 'นำออกจากแผนจัดซื้อไม่สำเร็จ');
      }

      await Swal.fire({ 
        icon: 'success', 
        title: 'นำออกจากแผนจัดซื้อสำเร็จ', 
        text: `ลบ ${payload.data?.deleted || selectedRows.size} รายการเรียบร้อยแล้ว` 
      });

      // Clear selection and refresh data
      setSelectedRows(new Set());
      await Promise.all([fetchData(), fetchSummaryData()]);
    } catch (error) {
      console.error(error);
      await Swal.fire({ 
        icon: 'error', 
        title: 'นำออกจากแผนจัดซื้อไม่สำเร็จ', 
        text: error instanceof Error ? error.message : 'ไม่สามารถลบข้อมูลได้' 
      });
    }
  };

  const handleExport = async () => {
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
      params.append('export', 'all'); // Get all records for export

      const response = await fetch(`/api/purchase-plans?${params.toString()}`);
      if (!response.ok) {
        throw new Error('ดึงข้อมูลส่งออกไม่สำเร็จ');
      }

      const data = await response.json();
      const exportData = Array.isArray(data?.data) ? data.data : [];

      if (exportData.length === 0) {
        await Swal.fire({ icon: 'info', title: 'ไม่มีข้อมูลส่งออก', text: 'ไม่พบข้อมูลที่ตรงเงื่อนไขสำหรับส่งออก' });
        return;
      }

      // Create CSV content
      const headers = [
        'ID', 'ปีงบ', 'ครั้งที่', 'รหัสสินค้า', 'ชื่อสินค้า', 'หมวด', 'ประเภท', 'ประเภทย่อย', 'หน่วยงานที่ขอ', 
        'ขอใช้', 'โควต้า', 'คงคลัง', 'มูลค่าคงคลัง', 'ซื้อ', 'มูลค่าซื้อ', 'ราคาต่อหน่วย'
      ];
      
      const csvContent = [
        headers.join(','),
        ...exportData.map((row: any) => [
          row.id,
          row.budget_year || '',
          row.sequence_no || '',
          `"${row.product_code || ''}"`,
          `"${row.product_name || ''}"`,
          `"${row.category || ''}"`,
          `"${row.product_type || ''}"`,
          `"${row.product_subtype || ''}"`,
          `"${row.requesting_dept || ''}"`,
          row.requested_amount || '',
          row.approved_quota || '',
          row.inventory_qty || '',
          row.inventory_value || '',
          row.purchase_qty || '',
          row.purchase_value || '',
          row.price_per_unit || ''
        ].join(','))
      ].join('\n');

      // Create and download file
      const blob = new Blob(['\uFEFF' + csvContent], { type: 'text/csv;charset=utf-8;' });
      const link = document.createElement('a');
      const url = URL.createObjectURL(blob);
      link.setAttribute('href', url);
      link.setAttribute('download', `purchase_plans_${new Date().toISOString().split('T')[0]}.csv`);
      link.style.visibility = 'hidden';
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);

      await Swal.fire({ 
        icon: 'success', 
        title: 'ส่งออกข้อมูลสำเร็จ', 
        text: `ส่งออก ${exportData.length} รายการเรียบร้อยแล้ว` 
      });
    } catch (error) {
      console.error(error);
      await Swal.fire({ 
        icon: 'error', 
        title: 'ส่งออกข้อมูลไม่สำเร็จ', 
        text: error instanceof Error ? error.message : 'ไม่สามารถส่งออกข้อมูลได้' 
      });
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = async () => {
    try {
      setLoading(true);
      await Promise.all([fetchData(), fetchSummaryData()]);
      await Swal.fire({ 
        icon: 'success', 
        title: 'รีเฟรชข้อมูลสำเร็จ', 
        text: 'ข้อมูลได้รับการอัพเดทเรียบร้อยแล้ว',
        timer: 1500,
        showConfirmButton: false
      });
    } catch (error) {
      console.error(error);
      await Swal.fire({ 
        icon: 'error', 
        title: 'รีเฟรชข้อมูลไม่สำเร็จ', 
        text: 'ไม่สามารถอัพเดทข้อมูลได้' 
      });
    } finally {
      setLoading(false);
    }
  };

  const handleCreateNew = () => {
    // Navigate to usage plans page to create new purchase plans
    router.push('/usage-plans');
  };

  return (
    <div className="p-6 bg-gray-50 min-h-screen">
      <div className="mb-6">
        <div className="flex flex-col gap-4 xl:flex-row xl:items-center xl:justify-between">
          <h1 className="text-3xl font-bold text-gray-900">แผนจัดซื้อ</h1>
          <div className="flex flex-wrap items-center gap-3 xl:justify-end">
            <button
              onClick={handleBulkPurchaseApproval}
              className="inline-flex items-center gap-2 rounded-lg bg-green-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition-colors hover:bg-green-700"
            >
              ทำรายการอนุมัติจัดซื้อ {selectedRows.size > 0 ? `${selectedRows.size} รายการ` : ''}
            </button>
            <button
              onClick={handleBulkRemoveFromPlan}
              className="inline-flex items-center gap-2 rounded-lg bg-red-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition-colors hover:bg-red-700"
            >
              นำออกจากแผนจัดซื้อ {selectedRows.size > 0 ? `${selectedRows.size} รายการ` : ''}
            </button>
            <button
              onClick={() => setSelectedRows(new Set())}
              className="inline-flex items-center gap-2 rounded-lg bg-gray-500 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition-colors hover:bg-gray-600"
            >
              ยกเลิก {selectedRows.size > 0 ? `${selectedRows.size} รายการ` : ''}
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 md:grid-cols-7 gap-4 mb-4">
            <select value={budgetYearFilter} onChange={(event) => setBudgetYearFilter(event.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ปีงบ</option>
              {availableBudgetYears.map((year) => <option key={year} value={year}>{year}</option>)}
            </select>
            <select value={requestingDeptFilter} onChange={(event) => setRequestingDeptFilter(event.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หน่วยงาน</option>
              {departments.map((department) => <option key={department} value={department}>{department}</option>)}
            </select>
            <select value={hasPurchaseApprovalFilter} onChange={(event) => setHasPurchaseApprovalFilter(event.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">สถานะเอกสาร</option>
              <option value="true">ทำเอกสารแล้ว ({purchaseApprovalCreatedCount})</option>
              <option value="false">ยังไม่ทำเอกสาร ({purchaseApprovalPendingCount})</option>
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
                <th className="px-2 py-2.5 text-left">
                  <input
                    type="checkbox"
                    checked={isAllSelected}
                    ref={(el) => {
                      if (el) {
                        el.indeterminate = isIndeterminate;
                      }
                    }}
                    onChange={(e) => handleSelectAll(e.target.checked)}
                    className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                  />
                </th>
                <th className="px-2 py-2.5 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-16">สถานะ</th>
                <th onClick={() => handleSort('budget_year')} className={`${getHeaderClass('budget_year')} w-20`}>ปีงบ</th>
                <th onClick={() => handleSort('sequence_no')} className={`${getHeaderClass('sequence_no')} w-16`}>ครั้งที่</th>
                <th onClick={() => handleSort('product_code')} className={`${getHeaderClass('product_code')} w-28`}>รหัสสินค้า</th>
                <th onClick={() => handleSort('product_name')} className={`${getHeaderClass('product_name')} w-[20rem]`}>ชื่อสินค้า</th>
                <th onClick={() => handleSort('requesting_dept')} className={`${getHeaderClass('requesting_dept')} w-36`}>หน่วยงานที่ขอ</th>
                <th className="px-2 py-2.5 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-32">ขอใช้ / โควต้า</th>
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
                const isApprovedRow = Boolean(row.has_purchase_approval);

                return (
                  <tr key={row.id} className={`${isEditingRow ? 'bg-yellow-50' : 'hover:bg-gray-50 transition-colors duration-150'}`}>
                    <td className="px-2 py-2 text-[11px] align-top">
                      <input
                        type="checkbox"
                        checked={selectedRows.has(row.id)}
                        onChange={(e) => handleRowSelect(row.id, e.target.checked)}
                        disabled={Boolean(row.has_purchase_approval)}
                        className={`h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500 ${
                          row.has_purchase_approval
                            ? 'opacity-50 cursor-not-allowed' 
                            : ''
                        }`}
                        title={row.has_purchase_approval ? 'รายการนี้ถูกเพิ่มไปยังรายการอนุมัติแล้ว' : ''}
                      />
                    </td>
                    <td className="px-2 py-2 text-[11px] align-top">
                      {row.has_purchase_approval ? (
                        <span title="ทำเอกสารอนุมัติจัดซื้อแล้ว" className="inline-flex items-center text-blue-600">
                          <FileText className="h-4 w-4" />
                        </span>
                      ) : '-'}
                    </td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.budget_year ?? '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.sequence_no ?? '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top break-all">{row.product_code || '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">
                      <div className="font-medium text-gray-900 whitespace-normal break-words leading-4" title={row.product_name || ''}>{row.product_name || '-'}</div>
                      <div className="mt-1 text-[10px] leading-4 text-gray-600">{row.price_per_unit ? `${Number(row.price_per_unit).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })} บาท/${row.unit || 'หน่วย'}` : '-'}</div>
                      <div className="mt-1 text-[10px] leading-4 text-emerald-600/80">{[row.category || '-', row.product_type || '-', row.product_subtype || '-'].filter((value, index, arr) => !(value === '-' && arr.every((item) => item === '-'))).join(' · ')}</div>
                    </td>
                    <td className="px-2 py-2 text-[11px] align-top break-words">{row.requesting_dept || '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">
                      {row.requested_amount && row.approved_quota ? (
                        <span>
                          <span className="text-gray-500">{row.requested_amount} / </span><strong>{row.approved_quota}</strong>
                        </span>
                      ) : row.requested_amount ?? row.approved_quota ?? '-'}
                    </td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.inventory_qty ?? '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.inventory_value ? Number(row.inventory_value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : row.inventory_value === 0 ? '0.00' : '-'}</td>
                    <td
                      className={`px-2 py-2 text-[11px] align-top ${!isEditingRow && !isApprovedRow ? 'cursor-text hover:bg-yellow-50' : ''} ${isApprovedRow ? 'text-gray-500' : ''}`}
                      onClick={() => {
                        if (!isEditingRow && !isApprovedRow) {
                          startInlineEdit(row);
                        }
                      }}
                      title={isApprovedRow ? 'รายการนี้ถูกสร้างเอกสารอนุมัติจัดซื้อแล้ว จึงไม่สามารถแก้ไขได้' : undefined}
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
                        />
                      ) : (
                        row.purchase_qty ?? '-'
                      )}
                    </td>
                    <td className="px-2 py-2 text-[11px] align-top">{row.purchase_value ? Number(row.purchase_value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : row.purchase_value === 0 ? '0.00' : '-'}</td>
                    <td className="px-2 py-2 text-[11px] align-top font-medium w-20">
                      {isEditingRow ? (
                        <div className="flex items-center gap-3">
                          <button onClick={() => void handleSaveAction(row)} className="text-emerald-600 hover:text-emerald-800 cursor-pointer" title="บันทึก" aria-label="บันทึก">
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
                              if (isApprovedRow) {
                                return;
                              }
                              startInlineEdit(row);
                            }}
                            className={`${isApprovedRow ? 'text-gray-300 cursor-not-allowed' : 'text-indigo-600 hover:text-indigo-900 cursor-pointer'}`}
                            title={isApprovedRow ? 'รายการนี้ถูกสร้างเอกสารอนุมัติจัดซื้อแล้ว จึงไม่สามารถแก้ไขได้' : 'แก้ไข'}
                            aria-label="แก้ไข"
                            disabled={isApprovedRow}
                          >
                            <Pencil className="h-5 w-5" />
                          </button>
                          <button
                            onClick={() => {
                              if (isApprovedRow) {
                                return;
                              }
                              void handleDelete(row.id);
                            }}
                            className={`${isApprovedRow ? 'text-gray-300 cursor-not-allowed' : 'text-red-600 hover:text-red-900 cursor-pointer'}`}
                            title={isApprovedRow ? 'รายการนี้ถูกสร้างเอกสารอนุมัติจัดซื้อแล้ว จึงไม่สามารถลบได้' : 'ลบ'}
                            aria-label="ลบ"
                            disabled={isApprovedRow}
                          >
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
