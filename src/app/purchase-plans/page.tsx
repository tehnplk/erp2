'use client';

import { Suspense, useEffect, useMemo, useRef, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';

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
  purchase_department_id?: number | null;
  purchase_department_code?: string | null;
  purchase_department_name?: string | null;
  has_purchase_approval?: boolean;
  inventory_qty: number | null;
  inventory_value: number | null;
  purchased_qty: number | null;
  purchase_qty: number | null;
  unit_price: number | null;
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

type DepartmentOption = {
  department_code: string;
  name: string;
};

type OutOfPlanProduct = {
  id: number;
  code: string;
  name: string;
  category: string | null;
  type: string | null;
  subtype: string | null;
  unit: string | null;
  cost_price: number | null;
  purchase_department_code: string | null;
  purchase_department_name: string | null;
};

type ApprovalDraftInput = {
  quantity: number;
  totalAmount: number;
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
  const [editingUnitPrice, setEditingUnitPrice] = useState<string>('');
  const purchaseQtyInputRefs = useRef<Record<number, HTMLInputElement | null>>({});
  const unitPriceInputRefs = useRef<Record<number, HTMLInputElement | null>>({});
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
  const [purchaseDepartmentFilter, setPurchaseDepartmentFilter] = useState('');
  const [autoCreating, setAutoCreating] = useState(false);
  const [approvedPlanIds, setApprovedPlanIds] = useState<Set<number>>(new Set());
  const [showOutOfPlanModal, setShowOutOfPlanModal] = useState(false);
  const [outOfPlanDepartments, setOutOfPlanDepartments] = useState<DepartmentOption[]>([]);
  const [outOfPlanCategories, setOutOfPlanCategories] = useState<string[]>([]);
  const [outOfPlanProducts, setOutOfPlanProducts] = useState<OutOfPlanProduct[]>([]);
  const [outOfPlanDeptCode, setOutOfPlanDeptCode] = useState('');
  const [outOfPlanCategory, setOutOfPlanCategory] = useState('');
  const [outOfPlanSearch, setOutOfPlanSearch] = useState('');
  const [outOfPlanBudgetYear, setOutOfPlanBudgetYear] = useState(String(getCurrentBudgetYear()));
  const [outOfPlanPurchaseQty, setOutOfPlanPurchaseQty] = useState('1');
  const [selectedOutOfPlanProductCode, setSelectedOutOfPlanProductCode] = useState('');
  const [loadingOutOfPlanProducts, setLoadingOutOfPlanProducts] = useState(false);
  const [savingOutOfPlan, setSavingOutOfPlan] = useState(false);
  const [approvalDraftByPlanId, setApprovalDraftByPlanId] = useState<Record<number, ApprovalDraftInput>>({});
  const [showApprovalInputModal, setShowApprovalInputModal] = useState(false);
  const [approvalInputRow, setApprovalInputRow] = useState<PurchasePlanRow | null>(null);
  const [approvalInputQty, setApprovalInputQty] = useState('');
  const [approvalInputTotal, setApprovalInputTotal] = useState('');

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
    lastPushedUrlRef.current = searchParams.toString() ? `${pathname}?${searchParams.toString()}` : pathname;
    hasSyncedSearchParamsRef.current = true;
  }, [pathname, searchParams]);

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

    if (lastPushedUrlRef.current !== nextUrl && nextUrl !== currentUrl) {
      lastPushedUrlRef.current = nextUrl;
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

  const handleRowFocus = async (row: PurchasePlanRow, focus: 'qty' | 'price') => {
    if (row.has_purchase_approval) {
      return;
    }

    if (editingRowId !== null && editingRowId !== row.id) {
      const previousRow = items.find((item) => item.id === editingRowId);
      if (previousRow) {
        const saved = await savePurchasePlan(previousRow, editingPurchaseQty, editingUnitPrice);
        if (!saved) {
          return;
        }
      }
    }

    startInlineEdit(row);
    if (focus === 'price') {
      setTimeout(() => {
        unitPriceInputRefs.current[row.id]?.focus();
        unitPriceInputRefs.current[row.id]?.select();
      }, 0);
    }
  };

  const startInlineEdit = (row: PurchasePlanRow) => {
    setEditingRowId(row.id);
    setEditingPurchaseQty(String(row.purchase_qty ?? 0));
    setEditingUnitPrice(String(row.unit_price ?? row.price_per_unit ?? 0));
  };

  const stopInlineEdit = () => {
    setEditingRowId(null);
    setEditingPurchaseQty('');
    setEditingUnitPrice('');
  };

  const savePurchasePlan = async (row: PurchasePlanRow, purchaseQtyText: string, unitPriceText: string) => {
    const nextPurchaseQty = Number(purchaseQtyText);
    const nextUnitPrice = Number(unitPriceText);

    if (purchaseQtyText.trim() === '') {
      await Swal.fire({ icon: 'error', title: 'ข้อมูลไม่ถูกต้อง', text: 'กรุณากรอกจำนวนซื้อครั้งนี้' });
      return false;
    }

    if (unitPriceText.trim() === '') {
      await Swal.fire({ icon: 'error', title: 'ข้อมูลไม่ถูกต้อง', text: 'กรุณากรอกราคาต่อหน่วย' });
      return false;
    }

    if (!Number.isFinite(nextPurchaseQty) || nextPurchaseQty < 0) {
      await Swal.fire({ icon: 'error', title: 'ข้อมูลไม่ถูกต้อง', text: 'purchase_qty ต้องเป็นตัวเลขตั้งแต่ 0 ขึ้นไป' });
      return false;
    }

    if (!Number.isFinite(nextUnitPrice) || nextUnitPrice < 0) {
      await Swal.fire({ icon: 'error', title: 'ข้อมูลไม่ถูกต้อง', text: 'unit_price ต้องเป็นตัวเลขตั้งแต่ 0 ขึ้นไป' });
      return false;
    }

    const approvedQuota = Number(row.approved_quota ?? 0);
    const inventoryQty = Number(row.inventory_qty ?? 0);
    const purchasedQty = Number(row.purchased_qty ?? 0);
    if (inventoryQty + purchasedQty + nextPurchaseQty > approvedQuota) {
      return false;
    }

    try {
      setSavingRowId(row.id);
      const purchaseValue = Number((nextPurchaseQty * nextUnitPrice).toFixed(2));
      const response = await fetch(`/api/purchase-plans/${row.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          usage_plan_id: row.usage_plan_id,
          inventory_qty: row.inventory_qty ?? 0,
          inventory_value: row.inventory_value ?? 0,
          purchase_qty: nextPurchaseQty,
          unit_price: nextUnitPrice,
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
    setEditingUnitPrice(String(nextRow.unit_price ?? nextRow.price_per_unit ?? 0));
  };

  const selectedPlanItems = useMemo(
    () => items.filter((item) => selectedRows.has(item.id)),
    [items, selectedRows],
  );

  const openApprovalInputModal = (row: PurchasePlanRow) => {
    const existing = approvalDraftByPlanId[row.id];
    const defaultQty = existing?.quantity ?? row.purchase_qty ?? 0;
    const defaultTotal = existing?.totalAmount ?? row.purchase_value ?? 0;
    setApprovalInputRow(row);
    setApprovalInputQty(String(defaultQty));
    setApprovalInputTotal(String(defaultTotal));
    setShowApprovalInputModal(true);
  };

  const closeApprovalInputModal = () => {
    setShowApprovalInputModal(false);
    setApprovalInputRow(null);
    setApprovalInputQty('');
    setApprovalInputTotal('');
  };

  const handleConfirmApprovalInput = () => {
    if (!approvalInputRow) {
      closeApprovalInputModal();
      return;
    }

    const quantity = Number(approvalInputQty);
    const totalAmount = Number(approvalInputTotal);

    if (!Number.isFinite(quantity) || quantity <= 0 || !Number.isInteger(quantity)) {
      void Swal.fire({
        icon: 'warning',
        title: 'จำนวนซื้อไม่ถูกต้อง',
        text: 'กรุณากรอกจำนวนซื้อเป็นจำนวนเต็มมากกว่า 0',
      });
      return;
    }

    if (!Number.isFinite(totalAmount) || totalAmount < 0) {
      void Swal.fire({
        icon: 'warning',
        title: 'ราคารวมไม่ถูกต้อง',
        text: 'กรุณากรอกราคารวมเป็นตัวเลขที่ไม่ติดลบ',
      });
      return;
    }

    setApprovalDraftByPlanId((prev) => ({
      ...prev,
      [approvalInputRow.id]: {
        quantity,
        totalAmount,
      },
    }));
    setSelectedRows((prev) => {
      const next = new Set(prev);
      next.add(approvalInputRow.id);
      return next;
    });
    closeApprovalInputModal();
  };
  const selectionAnchor = useMemo(() => {
    const firstItem = selectedPlanItems[0];
    if (!firstItem) {
      return null;
    }

    const purchaseDepartmentName = (firstItem.purchase_department_name ?? '').trim();
    const category = (firstItem.category ?? '').trim();
    if (!purchaseDepartmentName || !category) {
      return null;
    }

    return { purchaseDepartmentName, category };
  }, [selectedPlanItems]);

  const isRowSelectableByRule = (item: PurchasePlanRow) => {
    if (item.has_purchase_approval) {
      return false;
    }

    if (!selectionAnchor) {
      return true;
    }

    const purchaseDepartmentName = (item.purchase_department_name ?? '').trim();
    const category = (item.category ?? '').trim();
    return (
      purchaseDepartmentName === selectionAnchor.purchaseDepartmentName
      && category === selectionAnchor.category
    );
  };

  const handleSelectAll = (checked: boolean) => {
    if (checked) {
      void Swal.fire({
        icon: 'info',
        title: 'เลือกรายการทีละรายการ',
        text: 'ต้องกรอกจำนวนซื้อและราคารวมของแต่ละรายการในหน้าต่างยืนยันก่อน',
      });
    } else {
      setSelectedRows(new Set());
      setApprovalDraftByPlanId({});
    }
  };

  const handleRowSelect = (id: number, checked: boolean) => {
    const currentItem = items.find((item) => item.id === id);
    if (currentItem?.has_purchase_approval) {
      return;
    }

    if (checked && currentItem) {
      const purchaseDepartmentName = (currentItem.purchase_department_name ?? '').trim();
      const category = (currentItem.category ?? '').trim();
      if (!purchaseDepartmentName || !category) {
        void Swal.fire({
          icon: 'warning',
          title: 'ข้อมูลรายการไม่ครบ',
          text: 'รายการที่เลือกต้องมีข้อมูลหน่วยงานจัดซื้อและหมวดสินค้า',
        });
        return;
      }

      if (!isRowSelectableByRule(currentItem)) {
        void Swal.fire({
          icon: 'warning',
          title: 'เลือกรายการข้ามกลุ่มไม่ได้',
          text: 'เลือกรายการได้เฉพาะหน่วยงานจัดซื้อและหมวดสินค้าเดียวกันเท่านั้น',
        });
        return;
      }

      openApprovalInputModal(currentItem);
      return;
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

    if (!checked) {
      setApprovalDraftByPlanId((prev) => {
        if (!(id in prev)) {
          return prev;
        }
        const next = { ...prev };
        delete next[id];
        return next;
      });
    }
  };

  const selectableRowIds = useMemo(
    () => items
      .filter((item) => !purchaseDepartmentFilter || item.purchase_department_name === purchaseDepartmentFilter)
      .filter((item) => isRowSelectableByRule(item))
      .map((item) => item.id),
    [items, purchaseDepartmentFilter, selectionAnchor]
  );
  const isAllSelected = selectableRowIds.length > 0 && selectableRowIds.every((id) => selectedRows.has(id));
  const isIndeterminate = selectableRowIds.some((id) => selectedRows.has(id)) && !isAllSelected;

  const handlePurchaseQtyKeyDown = async (event: React.KeyboardEvent<HTMLInputElement>, row: PurchasePlanRow) => {
    if (event.key === 'ArrowUp' || event.key === 'ArrowDown') {
      event.preventDefault();
      const direction = event.key === 'ArrowUp' ? 'up' : 'down';
      const saved = await savePurchasePlan(row, event.currentTarget.value, editingUnitPrice);
      if (saved) {
        moveToAdjacentRow(row.id, direction);
      }
      return;
    }

    if (event.key === 'Enter') {
      event.preventDefault();
      const saved = await savePurchasePlan(row, event.currentTarget.value, editingUnitPrice);
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

  const handleUnitPriceKeyDown = async (event: React.KeyboardEvent<HTMLInputElement>, row: PurchasePlanRow) => {
    if (event.key === 'Enter') {
      event.preventDefault();
      const saved = await savePurchasePlan(row, editingPurchaseQty, event.currentTarget.value);
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

  const handleBulkPurchaseApproval = async () => {
    if (selectedRows.size === 0) {
      await Swal.fire({ icon: 'warning', title: 'ไม่ได้เลือกรายการ', text: 'กรุณาเลือกรายการที่ต้องการทำรายการอนุมัติจัดซื้อ' });
      return;
    }

    const selectedItems = selectedPlanItems;
    const missingDraftItems = selectedItems.filter((item) => !approvalDraftByPlanId[item.id]);
    if (missingDraftItems.length > 0) {
      await Swal.fire({
        icon: 'warning',
        title: 'ข้อมูลยังไม่ครบ',
        text: 'กรุณาเลือกรายการใหม่และกรอกจำนวนซื้อ/ราคารวมให้ครบทุกรายการ',
      });
      return;
    }

    const selectedDepartments = Array.from(
      new Set(
        selectedItems
          .map((item) => item.purchase_department_name)
          .filter((department): department is string => Boolean(department))
      )
    );

    const selectedCategories = Array.from(
      new Set(
        selectedItems
          .map((item) => item.category)
          .filter((category): category is string => Boolean(category))
      )
    );

    if (selectedDepartments.length !== 1) {
      await Swal.fire({
        icon: 'warning',
        title: 'หน่วยงานจัดซื้อไม่สอดคล้อง',
        text: 'การทำรายการอนุมัติจัดซื้อรวม ต้องเลือกรายการที่มีหน่วยงานจัดซื้อเดียวกัน',
      });
      return;
    }

    if (selectedCategories.length !== 1) {
      await Swal.fire({
        icon: 'warning',
        title: 'หมวดสินค้าไม่สอดคล้อง',
        text: 'การทำรายการอนุมัติจัดซื้อรวม ต้องเลือกรายการที่มีหมวดสินค้าเดียวกัน',
      });
      return;
    }

    const escapeHtml = (value: string) =>
      value
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');

    const summaryRowsHtml = selectedItems
      .map((item, index) => {
        const draft = approvalDraftByPlanId[item.id];
        const quantityText = draft.quantity.toLocaleString('en-US');
        const amountText = draft.totalAmount.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        return `
          <tr>
            <td style="padding:6px;border:1px solid #e5e7eb;text-align:center;">${index + 1}</td>
            <td style="padding:6px;border:1px solid #e5e7eb;text-align:left;">${escapeHtml(item.product_code ?? '-')}</td>
            <td style="padding:6px;border:1px solid #e5e7eb;text-align:left;">${escapeHtml(item.product_name ?? '-')}</td>
            <td style="padding:6px;border:1px solid #e5e7eb;text-align:right;">${quantityText}</td>
            <td style="padding:6px;border:1px solid #e5e7eb;text-align:right;">${amountText}</td>
          </tr>
        `;
      })
      .join('');

    const grandTotal = selectedItems.reduce((sum, item) => sum + approvalDraftByPlanId[item.id].totalAmount, 0);

    const result = await Swal.fire({
      title: 'ยืนยันการทำรายการอนุมัติจัดซื้อ?',
      html: `
        <div style="text-align:left;">
          <div style="margin-bottom:8px;">จะทำรายการอนุมัติจัดซื้อ <strong>${selectedRows.size}</strong> รายการ</div>
          <div style="max-height:260px;overflow:auto;border:1px solid #e5e7eb;border-radius:8px;">
            <table style="width:100%;border-collapse:collapse;font-size:12px;">
              <thead style="background:#f9fafb;position:sticky;top:0;">
                <tr>
                  <th style="padding:6px;border:1px solid #e5e7eb;">ลำดับ</th>
                  <th style="padding:6px;border:1px solid #e5e7eb;">รหัสสินค้า</th>
                  <th style="padding:6px;border:1px solid #e5e7eb;">ชื่อสินค้า</th>
                  <th style="padding:6px;border:1px solid #e5e7eb;">จำนวนซื้อ</th>
                  <th style="padding:6px;border:1px solid #e5e7eb;">มูลค่า</th>
                </tr>
              </thead>
              <tbody>${summaryRowsHtml}</tbody>
            </table>
          </div>
          <div style="margin-top:10px;text-align:right;">
            มูลค่ารวมทั้งหมด: <strong>${grandTotal.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</strong>
          </div>
        </div>
      `,
      icon: 'question',
      showCancelButton: true,
      confirmButtonText: 'ยืนยัน',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#10b981',
      width: 980,
    });

    if (!result.isConfirmed) {
      return;
    }

    try {
      // Create payload for new purchase_approval table structure
      const details = selectedItems.map((item, index) => ({
        proposed_quantity: approvalDraftByPlanId[item.id].quantity,
        proposed_amount: approvalDraftByPlanId[item.id].totalAmount,
        purchase_plan_id: item.id, // Link to the purchase plan
        approved_quantity: approvalDraftByPlanId[item.id].quantity,
        approved_amount: approvalDraftByPlanId[item.id].totalAmount,
        line_number: index + 1, // Start from 1
        status: 'PENDING'
      }));

      // Create header with basic info
      const header = {
        budget_year: selectedItems[0]?.budget_year ?? new Date().getFullYear() + 543,
        department: selectedDepartments[0],
        doc_date: new Date(Date.now() - new Date().getTimezoneOffset() * 60000).toISOString().split('T')[0], // Current date
        notes: `สร้างจากแผนจัดซื้อ ${selectedItems.length} รายการ (หน่วยงานจัดซื้อ ${selectedDepartments[0]}, หมวดสินค้า ${selectedCategories[0]})`,
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
      setApprovalDraftByPlanId({});
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
        'ปีงบ',
        'รหัสสินค้า',
        'ชื่อสินค้า',
        'หน่วยงานจัดซื้อ',
        'โควต้า',
        'คงคลัง',
        'ซื้อแล้ว',
        'ซื้อครั้งนี้',
        'ราคาต่อหน่วย',
        'รวมมูลค่าซื้อ'
      ];
      
      const csvContent = [
        headers.join(','),
        ...exportData.map((row: any) => [
          row.budget_year || '',
          `"${row.product_code || ''}"`,
          `"${row.product_name || ''}"`,
          `"${[row.purchase_department_code || '', row.purchase_department_name || ''].filter(Boolean).join(' - ') || '-'}"`,
          row.approved_quota || '',
          row.inventory_qty || '',
          row.purchased_qty || '',
          row.purchase_qty || '',
          row.unit_price || '',
          row.purchase_value || '',
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

  const purchaseDepartmentOptions = useMemo(
    () => Array.from(new Set(items.map((item) => item.purchase_department_name).filter(Boolean) as string[])).sort(),
    [items],
  );

  const visibleItems = useMemo(() => {
    if (!purchaseDepartmentFilter) {
      return items;
    }

    return items.filter((item) => item.purchase_department_name === purchaseDepartmentFilter);
  }, [items, purchaseDepartmentFilter]);

  useEffect(() => {
    const validIds = new Set(items.map((item) => item.id));

    setSelectedRows((prev) => {
      const next = new Set(Array.from(prev).filter((id) => validIds.has(id)));
      return next.size === prev.size ? prev : next;
    });

    setApprovalDraftByPlanId((prev) => {
      const entries = Object.entries(prev).filter(([id]) => validIds.has(Number(id)));
      if (entries.length === Object.keys(prev).length) {
        return prev;
      }
      return Object.fromEntries(entries) as Record<number, ApprovalDraftInput>;
    });
  }, [items]);

  const handleAutoCreate = async () => {
    try {
      setAutoCreating(true);
      const response = await fetch('/api/purchase-plans/auto', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
      });

      const payload = await response.json().catch(() => null);
      if (!response.ok || !payload?.success) {
        throw new Error(payload?.error || 'ไม่สามารถทำแผนจัดซื้ออัตโนมัติได้');
      }

      await Swal.fire({
        icon: 'success',
        title: 'ทำแผนจัดซื้ออัตโนมัติสำเร็จ',
        text: payload?.message || 'สร้างแผนจัดซื้ออัตโนมัติเรียบร้อยแล้ว',
      });

      await Promise.all([fetchData(), fetchSummaryData()]);
    } catch (error) {
      console.error(error);
      await Swal.fire({
        icon: 'error',
        title: 'ทำแผนจัดซื้ออัตโนมัติไม่สำเร็จ',
        text: error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการสร้างแผนจัดซื้ออัตโนมัติ',
      });
    } finally {
      setAutoCreating(false);
    }
  };

  const fetchOutOfPlanOptions = async (args?: { departmentCode?: string; category?: string; searchText?: string }) => {
    try {
      setLoadingOutOfPlanProducts(true);
      const departmentCode = args?.departmentCode ?? outOfPlanDeptCode;
      const category = args?.category ?? outOfPlanCategory;
      const searchText = args?.searchText ?? '';
      const params = new URLSearchParams();
      if (departmentCode) params.set('department_code', departmentCode);
      if (category) params.set('category', category);
      if (searchText.trim()) params.set('search', searchText.trim());

      const response = await fetch(`/api/purchase-plans/out-of-plan?${params.toString()}`);
      if (!response.ok) {
        throw new Error('โหลดข้อมูลสินค้าไม่สำเร็จ');
      }

      const data = await response.json();
      setOutOfPlanDepartments(Array.isArray(data?.departments) ? data.departments : []);
      setOutOfPlanCategories(Array.isArray(data?.categories) ? data.categories : []);
      setOutOfPlanProducts(Array.isArray(data?.products) ? data.products : []);
    } catch (error) {
      console.error(error);
      setOutOfPlanProducts([]);
    } finally {
      setLoadingOutOfPlanProducts(false);
    }
  };

  const openOutOfPlanModal = async () => {
    setShowOutOfPlanModal(true);
    setOutOfPlanDeptCode('');
    setOutOfPlanCategory('');
    setOutOfPlanSearch('');
    setOutOfPlanBudgetYear(String(getCurrentBudgetYear()));
    setOutOfPlanPurchaseQty('1');
    setSelectedOutOfPlanProductCode('');
    setOutOfPlanProducts([]);
    await fetchOutOfPlanOptions({ departmentCode: '', category: '', searchText: '' });
  };

  const handleSearchOutOfPlanProducts = async () => {
    if (!outOfPlanDeptCode || !outOfPlanCategory || !outOfPlanSearch.trim()) {
      await Swal.fire({
        icon: 'warning',
        title: 'ข้อมูลไม่ครบ',
        text: 'กรุณาเลือกหน่วยงาน เลือกหมวดสินค้า และกรอกรหัส/ชื่อสินค้า',
      });
      return;
    }
    await fetchOutOfPlanOptions({
      departmentCode: outOfPlanDeptCode,
      category: outOfPlanCategory,
      searchText: outOfPlanSearch,
    });
  };

  const handleCreateOutOfPlanPurchase = async () => {
    if (!selectedOutOfPlanProductCode) {
      await Swal.fire({ icon: 'warning', title: 'ยังไม่ได้เลือกสินค้า', text: 'กรุณาเลือกสินค้า 1 รหัสก่อนบันทึก' });
      return;
    }

    const qty = Number(outOfPlanPurchaseQty);
    if (!Number.isFinite(qty) || qty <= 0) {
      await Swal.fire({ icon: 'warning', title: 'จำนวนไม่ถูกต้อง', text: 'จำนวนต้องมากกว่า 0' });
      return;
    }

    try {
      setSavingOutOfPlan(true);
      const response = await fetch('/api/purchase-plans/out-of-plan', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          product_code: selectedOutOfPlanProductCode,
          requesting_dept_code: outOfPlanDeptCode,
          category: outOfPlanCategory,
          budget_year: Number(outOfPlanBudgetYear),
          purchase_qty: qty,
        }),
      });

      const payload = await response.json().catch(() => null);
      if (!response.ok || !payload?.success) {
        throw new Error(payload?.error || 'เพิ่มแผนจัดซื้อนอกแผนไม่สำเร็จ');
      }

      await Swal.fire({
        icon: 'success',
        title: 'เพิ่มแผนจัดซื้อนอกแผนสำเร็จ',
        text: payload?.message || 'บันทึกลง usage_plan และ purchase_plan เรียบร้อยแล้ว',
      });

      setShowOutOfPlanModal(false);
      await Promise.all([fetchData(), fetchSummaryData(), fetchFilters()]);
    } catch (error) {
      console.error(error);
      await Swal.fire({
        icon: 'error',
        title: 'เพิ่มแผนจัดซื้อนอกแผนไม่สำเร็จ',
        text: error instanceof Error ? error.message : 'เกิดข้อผิดพลาด',
      });
    } finally {
      setSavingOutOfPlan(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="mx-auto max-w-[1600px] space-y-4">
        <div className="rounded-xl border border-emerald-200 bg-emerald-50 p-4">
          <div className="flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
            <div>
              <h1 className="text-2xl font-semibold text-emerald-900">แผนจัดซื้อ</h1>
              <p className="text-sm text-emerald-800">เลือกรายการเพื่อจัดทำเอกสารอนุมัติจัดซื้อได้ เมื่อเป็นหน่วยงานจัดซื้อเดียวกันและหมวดสินค้าเดียวกัน</p>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <button
                type="button"
                onClick={() => void openOutOfPlanModal()}
                className="rounded-lg border border-emerald-600 bg-white px-4 py-2 text-sm font-semibold text-emerald-700 hover:bg-emerald-100"
              >
                เพิ่มแผนจัดซื้อนอกแผนการใช้
              </button>
              <button
                type="button"
                onClick={() => void handleBulkPurchaseApproval()}
                disabled={selectedPlanItems.length === 0}
                className="rounded-lg border border-blue-600 bg-blue-50 px-4 py-2 text-sm font-semibold text-blue-700 hover:bg-blue-100 disabled:cursor-not-allowed disabled:opacity-60"
              >
                จัดทำเอกสารอนุมัติจัดซื้อ ({selectedPlanItems.length})
              </button>
              <button
                type="button"
                onClick={() => void handleAutoCreate()}
                disabled={autoCreating}
                className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:cursor-not-allowed disabled:opacity-60"
              >
                {autoCreating ? 'กำลังทำแผนจัดซื้ออัตโนมัติ...' : 'ทำแผนจัดซื้ออัตโนมัติ'}
              </button>
            </div>
          </div>
        </div>

        <div className="rounded-xl border border-gray-200 bg-white p-4">
          <div className="mb-4 grid grid-cols-1 gap-3 md:grid-cols-4">
            <select
              value={purchaseDepartmentFilter}
              onChange={(event) => setPurchaseDepartmentFilter(event.target.value)}
              className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
            >
              <option value="">ทุกหน่วยงานจัดซื้อ</option>
              {purchaseDepartmentOptions.map((department) => (
                <option key={department} value={department}>{department}</option>
              ))}
            </select>
            <select
              value={categoryFilter}
              onChange={(event) => {
                setCategoryFilter(event.target.value);
                setTypeFilter('');
              }}
              className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
            >
              <option value="">ทุกหมวด</option>
              {categories.map((category) => (
                <option key={category} value={category}>{category}</option>
              ))}
            </select>
            <select
              value={typeFilter}
              onChange={(event) => setTypeFilter(event.target.value)}
              className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
            >
              <option value="">ทุกประเภท</option>
              {availableTypes.map((type) => (
                <option key={type} value={type}>{type}</option>
              ))}
            </select>
            <input
              type="text"
              value={productNameFilter}
              onChange={(event) => setProductNameFilter(event.target.value)}
              placeholder="ค้นหารหัส/ชื่อสินค้า"
              className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
            />
          </div>

          <div className="overflow-x-auto">
            <table className="w-full min-w-[980px] divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-3 py-2 text-center text-xs font-semibold uppercase text-gray-500">
                    <input
                      type="checkbox"
                      aria-label="เลือกทั้งหมด"
                      checked={isAllSelected}
                      ref={(element) => {
                        if (element) {
                          element.indeterminate = isIndeterminate;
                        }
                      }}
                      onChange={(event) => handleSelectAll(event.target.checked)}
                      className="h-4 w-4 rounded border-gray-300 text-emerald-600 focus:ring-emerald-500"
                    />
                  </th>
                  <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">ID</th>
                  <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">ปีงบ</th>
                  <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">รหัสสินค้า</th>
                  <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">ชื่อสินค้า</th>
                  <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">หน่วยงานจัดซื้อ</th>
                  <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">หน่วยนับ</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">โควต้า</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">คงคลัง</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">จำนวนซื้อ</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">ราคาต่อหน่วย</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">มูลค่าซื้อ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100 bg-white">
                {loading ? (
                  <tr>
                    <td colSpan={12} className="px-3 py-8 text-center text-sm text-gray-500">กำลังโหลดข้อมูล...</td>
                  </tr>
                ) : visibleItems.length === 0 ? (
                  <tr>
                    <td colSpan={12} className="px-3 py-8 text-center text-sm text-gray-500">ไม่พบข้อมูลแผนจัดซื้อ</td>
                  </tr>
                ) : (
                  visibleItems.map((row) => (
                    <tr key={row.id} className="hover:bg-gray-50">
                      <td className="px-3 py-2 text-center text-xs text-gray-700">
                        <input
                          type="checkbox"
                          aria-label={`เลือกรายการ ${row.product_code ?? row.id}`}
                          checked={selectedRows.has(row.id)}
                          onChange={(event) => handleRowSelect(row.id, event.target.checked)}
                          disabled={!isRowSelectableByRule(row)}
                          className="h-4 w-4 rounded border-gray-300 text-emerald-600 focus:ring-emerald-500 disabled:cursor-not-allowed disabled:opacity-50"
                        />
                      </td>
                      <td className="px-3 py-2 text-xs text-gray-700">{row.id}</td>
                      <td className="px-3 py-2 text-xs text-gray-700">{row.budget_year ?? '-'}</td>
                      <td className="px-3 py-2 text-xs text-gray-700">{row.product_code ?? '-'}</td>
                      <td className="px-3 py-2 text-xs text-gray-700">
                        <div className="font-medium text-gray-900">{row.product_name ?? '-'}</div>
                        <div className="text-[10px] text-amber-600">{[row.category, row.product_type, row.product_subtype].filter(Boolean).join(' - ') || '-'}</div>
                      </td>
                      <td className="px-3 py-2 text-xs text-gray-700">{row.purchase_department_name ?? '-'}</td>
                      <td className="px-3 py-2 text-xs text-gray-700">{row.unit ?? '-'}</td>
                      <td className="px-3 py-2 text-right text-xs text-gray-700">{row.approved_quota ?? 0}</td>
                      <td className="px-3 py-2 text-right text-xs text-gray-700">{row.inventory_qty ?? 0}</td>
                      <td className="px-3 py-2 text-right text-xs text-gray-700">{row.purchase_qty ?? 0}</td>
                      <td className="px-3 py-2 text-right text-xs text-gray-700">
                        {(row.unit_price ?? row.price_per_unit ?? 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                      </td>
                      <td className="px-3 py-2 text-right text-xs text-gray-700">{(row.purchase_value ?? 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

        {showOutOfPlanModal && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="flex max-h-[90vh] w-full max-w-4xl flex-col rounded-xl bg-white p-4 shadow-xl">
              <div className="mb-3 flex items-center justify-between">
                <h2 className="text-lg font-semibold text-gray-900">เพิ่มแผนจัดซื้อนอกแผนการใช้</h2>
                <button
                  type="button"
                  onClick={() => setShowOutOfPlanModal(false)}
                  className="rounded-md border border-gray-300 px-3 py-1 text-sm text-gray-700 hover:bg-gray-100"
                >
                  ปิด
                </button>
              </div>

              <div className="overflow-y-auto pr-1">
                <div className="grid grid-cols-1 gap-3 md:grid-cols-5">
                <select
                  value={outOfPlanDeptCode}
                  onChange={(event) => setOutOfPlanDeptCode(event.target.value)}
                  className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
                >
                  <option value="">เลือกหน่วยงาน</option>
                  {outOfPlanDepartments.map((department) => (
                    <option key={department.department_code} value={department.department_code}>
                      {department.department_code} - {department.name}
                    </option>
                  ))}
                </select>
                <select
                  value={outOfPlanCategory}
                  onChange={(event) => setOutOfPlanCategory(event.target.value)}
                  className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
                >
                  <option value="">เลือกหมวดสินค้า</option>
                  {outOfPlanCategories.map((category) => (
                    <option key={category} value={category}>
                      {category}
                    </option>
                  ))}
                </select>
                <input
                  type="text"
                  value={outOfPlanSearch}
                  onChange={(event) => setOutOfPlanSearch(event.target.value)}
                  placeholder="ค้นหารหัส/ชื่อสินค้า"
                  className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
                />
                <input
                  type="number"
                  min={1}
                  value={outOfPlanPurchaseQty}
                  onChange={(event) => setOutOfPlanPurchaseQty(event.target.value)}
                  placeholder="จำนวน"
                  className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
                />
                <select
                  value={outOfPlanBudgetYear}
                  onChange={(event) => setOutOfPlanBudgetYear(event.target.value)}
                  className="rounded-lg border border-gray-300 px-3 py-2 text-sm"
                >
                  {availableBudgetYears.map((year) => (
                    <option key={year} value={year}>
                      {year}
                    </option>
                  ))}
                </select>
                </div>

                <div className="mt-3 flex items-center gap-2">
                  <button
                    type="button"
                    onClick={() => void handleSearchOutOfPlanProducts()}
                    disabled={loadingOutOfPlanProducts}
                    className="rounded-lg bg-blue-600 px-3 py-2 text-sm font-semibold text-white hover:bg-blue-700 disabled:opacity-60"
                  >
                    {loadingOutOfPlanProducts ? 'กำลังค้นหา...' : 'ค้นหาสินค้า'}
                  </button>
                  <p className="text-xs text-gray-500">เพิ่มได้ครั้งละ 1 รหัสสินค้า</p>
                </div>

                <div className="mt-3 max-h-72 overflow-y-auto rounded-lg border border-gray-200">
                  <table className="w-full divide-y divide-gray-200">
                    <thead className="bg-gray-50">
                      <tr>
                        <th className="px-3 py-2 text-left text-xs font-semibold text-gray-500">เลือก</th>
                        <th className="px-3 py-2 text-left text-xs font-semibold text-gray-500">รหัสสินค้า</th>
                        <th className="px-3 py-2 text-left text-xs font-semibold text-gray-500">ชื่อสินค้า</th>
                        <th className="px-3 py-2 text-left text-xs font-semibold text-gray-500">หน่วย</th>
                        <th className="px-3 py-2 text-right text-xs font-semibold text-gray-500">ราคา</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100 bg-white">
                      {outOfPlanProducts.length === 0 ? (
                        <tr>
                          <td colSpan={5} className="px-3 py-4 text-center text-sm text-gray-500">
                            ยังไม่พบสินค้า
                          </td>
                        </tr>
                      ) : (
                        outOfPlanProducts.map((product) => (
                          <tr key={product.code} className="hover:bg-gray-50">
                            <td className="px-3 py-2 text-xs">
                              <input
                                type="radio"
                                name="selected_out_of_plan_product"
                                value={product.code}
                                checked={selectedOutOfPlanProductCode === product.code}
                                onChange={() => setSelectedOutOfPlanProductCode(product.code)}
                              />
                            </td>
                            <td className="px-3 py-2 text-xs text-gray-700">{product.code}</td>
                            <td className="px-3 py-2 text-xs text-gray-700">{product.name}</td>
                            <td className="px-3 py-2 text-xs text-gray-700">{product.unit || '-'}</td>
                            <td className="px-3 py-2 text-right text-xs text-gray-700">
                              {(product.cost_price ?? 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                            </td>
                          </tr>
                        ))
                      )}
                    </tbody>
                  </table>
                </div>
              </div>

              <div className="mt-4 flex items-center justify-end gap-2">
                <button
                  type="button"
                  onClick={() => setShowOutOfPlanModal(false)}
                  className="rounded-lg border border-gray-300 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                >
                  ยกเลิก
                </button>
                <button
                  type="button"
                  onClick={() => void handleCreateOutOfPlanPurchase()}
                  disabled={savingOutOfPlan}
                  className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700 disabled:opacity-60"
                >
                  {savingOutOfPlan ? 'กำลังบันทึก...' : 'บันทึกนอกแผน'}
                </button>
              </div>
            </div>
          </div>
        )}

        {showApprovalInputModal && approvalInputRow && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="w-full max-w-md rounded-xl bg-white p-4 shadow-xl">
              <h2 className="text-lg font-semibold text-gray-900">กรอกข้อมูลเพื่อจัดทำเอกสารอนุมัติจัดซื้อ</h2>
              <p className="mt-1 text-sm text-gray-600">
                {approvalInputRow.product_code || '-'} - {approvalInputRow.product_name || '-'}
              </p>
              <div className="mt-3 space-y-3">
                <div>
                  <label className="mb-1 block text-sm font-medium text-gray-700">จำนวนซื้อ</label>
                  <input
                    type="number"
                    min={1}
                    step={1}
                    value={approvalInputQty}
                    onChange={(event) => setApprovalInputQty(event.target.value)}
                    className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"
                  />
                </div>
                <div>
                  <label className="mb-1 block text-sm font-medium text-gray-700">ราคารวม</label>
                  <input
                    type="number"
                    min={0}
                    step="0.01"
                    value={approvalInputTotal}
                    onChange={(event) => setApprovalInputTotal(event.target.value)}
                    className="w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"
                  />
                </div>
              </div>
              <div className="mt-4 flex justify-end gap-2">
                <button
                  type="button"
                  onClick={closeApprovalInputModal}
                  className="rounded-lg border border-gray-300 px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                >
                  ยกเลิก
                </button>
                <button
                  type="button"
                  onClick={handleConfirmApprovalInput}
                  className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white hover:bg-emerald-700"
                >
                  ยืนยัน
                </button>
              </div>
            </div>
          </div>
        )}
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


