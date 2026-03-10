'use client';

import { Suspense, useEffect, useMemo, useRef, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { Pencil, Trash2, X } from 'lucide-react';

const PURCHASE_PLAN_PRODUCT_SUGGESTION_LIMIT = 12;

const getCurrentBudgetYear = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

interface SurveyOption {
  id: number;
  product_code: string | null;
  category: string | null;
  type: string | null;
  subtype: string | null;
  product_name: string | null;
  requested_amount: number | null;
  unit: string | null;
  price_per_unit: number;
  requesting_dept: string | null;
  approved_quota: number | null;
  budget_year: number | null;
  sequence_no: number | null;
}

interface PurchasePlanFormData {
  product_code?: string;
  category?: string;
  product_name?: string;
  product_type?: string;
  product_subtype?: string;
  unit?: string;
  price_per_unit?: number;
  budget_year?: string;
  plan_id?: number | null;
  in_plan?: string;
  carried_forward_quantity?: number | null;
  carried_forward_value?: number;
  required_quantity_for_year?: number | null;
  total_required_value?: number;
  additional_purchase_qty?: number | null;
  additional_purchase_value?: number;
  purchasing_department?: string;
}

interface BulkPurchasePlanRecord {
  id: number;
  product_code: string;
  category: string;
  product_name: string;
  product_type: string;
  product_subtype: string;
  unit: string;
  price_per_unit: string;
  budget_year: string;
  plan_id: number | null;
  in_plan: string;
  carried_forward_quantity: string;
  carried_forward_value: string;
  required_quantity_for_year: string;
  total_required_value: string;
  additional_purchase_qty: string;
  additional_purchase_value: string;
  purchasing_department: string;
}

interface CategoryOption {
  category: string;
  type: string;
  subtype: string | null;
}

function PurchasePlansPageContent() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const initialProductNameFilter = searchParams.get('product_name') || '';
  const initialCategoryFilter = searchParams.get('category') || '';
  const initialTypeFilter = searchParams.get('type') || '';
  const initialSubtypeFilter = searchParams.get('product_subtype') || '';
  const initialRequestingDeptFilter = searchParams.get('requesting_dept') || '';
  const initialBudgetYearFilter = searchParams.get('budget_year') || '';
  const initialSortBy = searchParams.get('order_by') || 'id';
  const initialSortOrder = (searchParams.get('sort_order') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
  const initialPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
  const initialPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);
  const [items, setItems] = useState<any[]>([]);
  const [summaryItems, setSummaryItems] = useState<any[]>([]);
  const [surveyOptions, setSurveyOptions] = useState<SurveyOption[]>([]);
  const [surveysLoading, setSurveysLoading] = useState(false);
  const [surveySearchTerm, setSurveySearchTerm] = useState('');
  const [showSurveySuggestions, setShowSurveySuggestions] = useState(false);
  const [highlightedSurveyIndex, setHighlightedSurveyIndex] = useState(-1);
  const surveySearchInputRef = useRef<HTMLInputElement>(null);
  const surveySuggestionsRef = useRef<HTMLDivElement>(null);
  const dataRequestIdRef = useRef(0);
  const summaryRequestIdRef = useRef(0);
  const hasMountedSummaryRef = useRef(false);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [filtersLoading, setFiltersLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState<any | null>(null);
  const [formData, setFormData] = useState<PurchasePlanFormData>({});
  const isEditing = Boolean(editing);
  const [bulkRecords, setBulkRecords] = useState<BulkPurchasePlanRecord[]>([]);
  const [bulkValidationErrors, setBulkValidationErrors] = useState<Record<number, { inPlan?: string; carriedForwardQuantity?: string; purchasingDepartment?: string }>>({});
  const [toast, setToast] = useState<{
    message: string;
    type: 'success' | 'error';
    visible: boolean;
  }>({
    message: '',
    type: 'success',
    visible: false,
  });

  // filters
  const [productNameFilter, setProductNameFilter] = useState(initialProductNameFilter);
  const [categoryFilter, setCategoryFilter] = useState(initialCategoryFilter);
  const [typeFilter, setTypeFilter] = useState(initialTypeFilter);
  const [subtypeFilter, setSubtypeFilter] = useState(initialSubtypeFilter);
  const [requestingDeptFilter, setRequestingDeptFilter] = useState(initialRequestingDeptFilter);
  const [budgetYearFilter, setBudgetYearFilter] = useState(initialBudgetYearFilter);

  // sort
  const [sortBy, setSortBy] = useState(initialSortBy);
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>(initialSortOrder);
  const [page, setPage] = useState(initialPage);
  const [pageSize, setPageSize] = useState(initialPageSize);

  // dynamic options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<CategoryOption[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);
  const [years, setYears] = useState<string[]>([]);
  const availableBudgetYears = Array.from(new Set([
    ...years,
    ...Array.from({ length: 6 }, (_, index) => String(getCurrentBudgetYear() - index)),
  ])).sort((a, b) => Number(b) - Number(a));

  useEffect(() => {
    fetchFilters();
    fetchSurveyOptions();
  }, []);

  useEffect(() => {
    if (!showForm || isEditing) {
      setSurveysLoading(false);
      return;
    }

    const searchValue = surveySearchTerm.trim();
    if (searchValue.length === 0) {
      setSurveysLoading(false);
      setShowSurveySuggestions(false);
      setHighlightedSurveyIndex(-1);
      return;
    }

    setSurveysLoading(true);
    const timeoutId = window.setTimeout(() => {
      setShowSurveySuggestions(true);
      setHighlightedSurveyIndex(-1);
      setSurveysLoading(false);
    }, 150);

    return () => {
      window.clearTimeout(timeoutId);
      setSurveysLoading(false);
    };
  }, [surveySearchTerm, showForm, isEditing]);

  useEffect(() => {
    if (!showForm || isEditing) {
      return;
    }

    const focusFrame = window.requestAnimationFrame(() => {
      surveySearchInputRef.current?.focus();
    });

    return () => window.cancelAnimationFrame(focusFrame);
  }, [showForm, isEditing]);

  useEffect(() => {
    if (!showSurveySuggestions || highlightedSurveyIndex < 0) {
      return;
    }

    const suggestionContainer = surveySuggestionsRef.current;
    if (!suggestionContainer) {
      return;
    }

    const highlightedElement = suggestionContainer.querySelector<HTMLElement>(`[data-survey-suggestion-index="${highlightedSurveyIndex}"]`);
    highlightedElement?.scrollIntoView({ block: 'nearest' });
  }, [highlightedSurveyIndex, showSurveySuggestions]);

  useEffect(() => {
    fetchData();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder, page, pageSize]);

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

  useEffect(() => {
    fetchSummaryData();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder]);

  useEffect(() => {
    if (!hasMountedSummaryRef.current) {
      hasMountedSummaryRef.current = true;
      return;
    }

    setPage((prev) => (prev === 1 ? prev : 1));
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder]);

  useEffect(() => {
    const nextProductName = searchParams.get('product_name') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('type') || '';
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
  }, [searchParams]);

  useEffect(() => {
    const params = new URLSearchParams();

    if (productNameFilter) params.set('product_name', productNameFilter);
    if (categoryFilter) params.set('category', categoryFilter);
    if (typeFilter) params.set('type', typeFilter);
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

  const fetchFilters = async () => {
    try {
      setFiltersLoading(true);
      const res = await fetch('/api/purchase-plans/filters');
      if (res.ok) {
        const data = await res.json();
        setCategories(data.categories || []);
        setTypes(data.product_types || []);
        setSubtypes(data.product_subtypes || []);
        setCategoryOptions(data.category_options || []);
        setDepartments(data.departments || []);
        setYears(data.budget_years || []);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setFiltersLoading(false);
    }
  };

  const fetchSurveyOptions = async () => {
    try {
      const params = new URLSearchParams();
      params.append('order_by', 'id');
      params.append('sort_order', 'desc');
      const res = await fetch(`/api/usage-plans?${params.toString()}`);
      if (!res.ok) throw new Error('fetch surveys failed');
      const data = await res.json();
      setSurveyOptions(data.data || data.surveys || []);
    } catch (e) {
      console.error(e);
    }
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
    const requestId = ++dataRequestIdRef.current;
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (productNameFilter) params.append('product_name', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (subtypeFilter) params.append('product_subtype', subtypeFilter);
      if (requestingDeptFilter) params.append('requesting_dept', requestingDeptFilter);
      if (budgetYearFilter) params.append('budget_year', budgetYearFilter);
      params.append('order_by', sortBy);
      params.append('sort_order', sortOrder);
      params.append('page', page.toString());
      params.append('page_size', pageSize.toString());

      const res = await fetch(`/api/purchase-plans?${params.toString()}`);
      if (!res.ok) throw new Error('fetch failed');
      const data = await res.json();
      const nextItems = Array.isArray(data?.data)
        ? data.data
        : Array.isArray(data?.items)
          ? data.items
          : [];
      const nextTotalCount = typeof data?.totalCount === 'number'
        ? data.totalCount
        : typeof data?.count === 'number'
          ? data.count
          : nextItems.length;

      if (requestId !== dataRequestIdRef.current) {
        return;
      }

      setItems(nextItems);
      setTotalCount(nextTotalCount);
      if (data.page && data.page !== page) {
        setPage(data.page);
      }
      if (data.page_size && data.page_size !== pageSize) {
        setPageSize(data.page_size);
      }
    } catch (e) {
      console.error(e);
    } finally {
      if (requestId === dataRequestIdRef.current) {
        setLoading(false);
      }
    }
  };

  // Fetch full filtered dataset for summary (independent of pagination)
  const fetchSummaryData = async () => {
    const requestId = ++summaryRequestIdRef.current;
    try {
      const params = new URLSearchParams();
      if (productNameFilter) params.append('product_name', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (subtypeFilter) params.append('product_subtype', subtypeFilter);
      if (requestingDeptFilter) params.append('requesting_dept', requestingDeptFilter);
      if (budgetYearFilter) params.append('budget_year', budgetYearFilter);
      params.append('order_by', sortBy);
      params.append('sort_order', sortOrder);

      const res = await fetch(`/api/purchase-plans?${params.toString()}`);
      if (!res.ok) return;
      const data = await res.json();
      const nextSummaryItems = Array.isArray(data?.data)
        ? data.data
        : Array.isArray(data?.items)
          ? data.items
          : [];

      if (requestId !== summaryRequestIdRef.current) {
        return;
      }

      setSummaryItems(nextSummaryItems);
    } catch (e) {
      console.error(e);
    }
  };

  const handleSort = (column: string) => {
    if (sortBy === column) setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    else { setSortBy(column); setSortOrder('asc'); }
  };

  const getHeaderClass = (col: string) => `px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${col === sortBy ? 'bg-gray-100' : ''}`;

  const createEmptyBulkRecord = (id: number): BulkPurchasePlanRecord => ({
    id,
    product_code: '',
    category: '',
    product_name: '',
    product_type: '',
    product_subtype: '',
    unit: '',
    price_per_unit: '',
    budget_year: getCurrentBudgetYear().toString(),
    plan_id: null,
    in_plan: '',
    carried_forward_quantity: '',
    carried_forward_value: '',
    required_quantity_for_year: '',
    total_required_value: '',
    additional_purchase_qty: '',
    additional_purchase_value: '',
    purchasing_department: '',
  });

  const updateBulkRecord = (id: number, updater: (record: BulkPurchasePlanRecord) => BulkPurchasePlanRecord) => {
    setBulkRecords((prev) => prev.map((record) => (record.id === id ? updater(record) : record)));
  };

  const clearBulkValidationError = (id: number, field: 'inPlan' | 'carriedForwardQuantity' | 'purchasingDepartment') => {
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

  const hideToastLater = () => {
    window.setTimeout(() => {
      setToast((prev) => ({ ...prev, visible: false }));
    }, 3000);
  };

  const closeBulkForm = () => {
    setEditing(null);
    setFormData({});
    setSurveySearchTerm('');
    setShowSurveySuggestions(false);
    setHighlightedSurveyIndex(-1);
    setBulkRecords([]);
    setBulkValidationErrors({});
    setShowForm(false);
  };

  const openCreateForm = () => {
    setEditing(null);
    setFormData({});
    setBulkValidationErrors({});
    setSurveySearchTerm('');
    setShowSurveySuggestions(false);
    setHighlightedSurveyIndex(-1);
    setShowForm(true);
  };

  const handleEdit = (row: any) => {
    setEditing(row);
    setFormData({
      product_code: row.product_code || '',
      category: row.category || '',
      product_name: row.product_name || '',
      product_type: row.product_type || '',
      product_subtype: row.product_subtype || '',
      unit: row.unit || '',
      price_per_unit: row.price_per_unit ? Number(row.price_per_unit) : undefined,
      budget_year: row.budget_year || '',
      plan_id: row.plan_id ?? null,
      in_plan: row.in_plan || '',
      carried_forward_quantity: row.carried_forward_quantity ?? null,
      carried_forward_value: row.carried_forward_value ? Number(row.carried_forward_value) : undefined,
      required_quantity_for_year: row.required_quantity_for_year ?? null,
      total_required_value: row.total_required_value ? Number(row.total_required_value) : undefined,
      additional_purchase_qty: row.additional_purchase_qty ?? null,
      additional_purchase_value: row.additional_purchase_value ? Number(row.additional_purchase_value) : undefined,
      purchasing_department: row.purchasing_department || '',
    });
    setSurveySearchTerm(
      row.product_code || row.product_name
        ? `${row.product_code || '-'} | ${row.product_name || '-'}`
        : ''
    );
    setShowForm(true);
  };

  const purchasingDepartmentOptions = Array.from(new Set([...(formData.purchasing_department ? [formData.purchasing_department] : []), ...departments].filter(Boolean)));
  const selectedSearchLabel = formData.product_code || formData.product_name
    ? `${formData.product_code || '-'} | ${formData.product_name || '-'}`
    : '';
  const isSurveySearchDirty = surveySearchTerm.trim() !== '' && surveySearchTerm !== selectedSearchLabel;
  const filteredSurveyOptions = useMemo(() => {
    const normalizedSurveySearchTerm = surveySearchTerm.trim().toLowerCase();
    if (!normalizedSurveySearchTerm) {
      return [];
    }

    const seenSurveyKeys = new Set<string>();

    return surveyOptions
      .filter((survey) => `${survey.product_code || ''} ${survey.product_name || ''}`.toLowerCase().includes(normalizedSurveySearchTerm))
      .filter((survey) => {
        const key = `${survey.product_code || ''}::${survey.product_name || ''}`.toLowerCase();
        if (seenSurveyKeys.has(key)) {
          return false;
        }
        seenSurveyKeys.add(key);
        return true;
      })
      .slice(0, PURCHASE_PLAN_PRODUCT_SUGGESTION_LIMIT);
  }, [surveyOptions, surveySearchTerm]);

  const resetForm = () => {
    closeBulkForm();
  };

  const handleSurveySelect = (survey: SurveyOption) => {
    if (isEditing) {
      return;
    }

    const selectedLabel = `${survey.product_code || '-'} | ${survey.product_name || '-'}`;
    setFormData((prev) => ({
      ...prev,
      plan_id: survey.id,
      product_code: survey.product_code || '',
      category: survey.category || '',
      product_name: survey.product_name || '',
      product_type: survey.type || '',
      product_subtype: survey.subtype || '',
      unit: survey.unit || '',
      price_per_unit: survey.price_per_unit ? Number(survey.price_per_unit) : undefined,
      budget_year: survey.budget_year !== null && survey.budget_year !== undefined ? String(survey.budget_year) : getCurrentBudgetYear().toString(),
      required_quantity_for_year: survey.requested_amount ?? null,
      total_required_value: Number(((survey.approved_quota ?? 0) * (survey.price_per_unit ?? 0)).toFixed(2)),
      additional_purchase_qty: survey.requested_amount ?? null,
      additional_purchase_value: Number(((survey.requested_amount ?? 0) * (survey.price_per_unit ?? 0)).toFixed(2)),
    }));
    setSurveySearchTerm(selectedLabel);
    setShowSurveySuggestions(false);
    setHighlightedSurveyIndex(-1);

    setBulkRecords((prev) => {
      const hasExistingRecord = prev.some((record) => record.plan_id === survey.id || record.product_code === (survey.product_code || ''));
      if (hasExistingRecord) {
        return prev;
      }

      const nextId = prev.length > 0 ? Math.max(...prev.map((record) => record.id)) + 1 : 1;
      const approvedQuota = survey.approved_quota ?? 0;
      const requestedAmount = survey.requested_amount ?? 0;
      const pricePerUnit = Number(survey.price_per_unit) || 0;
      const totalRequiredValue = Number((approvedQuota * pricePerUnit).toFixed(2));
      const additionalPurchaseValue = Number((requestedAmount * pricePerUnit).toFixed(2));

      return [
        ...prev,
        {
          id: nextId,
          product_code: survey.product_code || '',
          category: survey.category || '',
          product_name: survey.product_name || '',
          product_type: survey.type || '',
          product_subtype: survey.subtype || '',
          unit: survey.unit || '',
          price_per_unit: pricePerUnit ? pricePerUnit.toString() : '',
          budget_year: survey.budget_year !== null && survey.budget_year !== undefined ? String(survey.budget_year) : getCurrentBudgetYear().toString(),
          plan_id: survey.id,
          in_plan: 'ในแผน',
          carried_forward_quantity: '',
          carried_forward_value: '0',
          required_quantity_for_year: requestedAmount ? requestedAmount.toString() : '0',
          total_required_value: totalRequiredValue ? totalRequiredValue.toString() : '0',
          additional_purchase_qty: requestedAmount ? requestedAmount.toString() : '0',
          additional_purchase_value: additionalPurchaseValue ? additionalPurchaseValue.toString() : '0',
          purchasing_department: survey.requesting_dept || '',
        },
      ];
    });

    setBulkValidationErrors((prev) => {
      const nextErrors = { ...prev };
      const existingRecord = Object.keys(nextErrors).find((key) => Number(key) === survey.id);
      if (existingRecord) {
        delete nextErrors[Number(existingRecord)];
      }
      return nextErrors;
    });
    setSurveySearchTerm('');
  };

  const clearSurveySelection = () => {
    setSurveySearchTerm('');
    setShowSurveySuggestions(false);
    setHighlightedSurveyIndex(-1);
    setFormData((prev) => ({
      ...prev,
      plan_id: null,
      product_code: '',
      category: '',
      product_name: '',
      product_type: '',
      product_subtype: '',
      unit: '',
      price_per_unit: undefined,
      budget_year: '',
      required_quantity_for_year: null,
      total_required_value: undefined,
      additional_purchase_qty: null,
      additional_purchase_value: undefined,
      purchasing_department: '',
    }));
  };

  const handleSurveySearchKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (!filteredSurveyOptions.length) {
      if (e.key === 'Escape') {
        setShowSurveySuggestions(false);
      }
      return;
    }

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setShowSurveySuggestions(true);
      setHighlightedSurveyIndex((prev) => (prev + 1) % filteredSurveyOptions.length);
      return;
    }

    if (e.key === 'ArrowUp') {
      e.preventDefault();
      setShowSurveySuggestions(true);
      setHighlightedSurveyIndex((prev) => (prev <= 0 ? filteredSurveyOptions.length - 1 : prev - 1));
      return;
    }

    if (e.key === 'Enter') {
      if (showSurveySuggestions) {
        e.preventDefault();
        const targetIndex = highlightedSurveyIndex >= 0 ? highlightedSurveyIndex : 0;
        const selectedSurvey = filteredSurveyOptions[targetIndex];
        if (selectedSurvey) {
          handleSurveySelect(selectedSurvey);
        }
      }
      return;
    }

    if (e.key === 'Escape') {
      e.preventDefault();
      setShowSurveySuggestions(false);
      setHighlightedSurveyIndex(-1);
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: ['price_per_unit','carried_forward_value','total_required_value','additional_purchase_value'].includes(name)
        ? (value ? parseFloat(value) : undefined)
        : ['plan_id','carried_forward_quantity','required_quantity_for_year','additional_purchase_qty'].includes(name)
        ? (value ? parseInt(value) : null)
        : value
    }));
  };

  const handleBulkFieldChange = (id: number, field: keyof BulkPurchasePlanRecord, value: string) => {
    updateBulkRecord(id, (current) => {
      const nextRecord = {
        ...current,
        [field]: value,
      } as BulkPurchasePlanRecord;

      const pricePerUnit = Number(nextRecord.price_per_unit) || 0;
      const requiredQuantityForYear = Number(nextRecord.required_quantity_for_year) || 0;
      const carriedForwardQuantity = Number(nextRecord.carried_forward_quantity) || 0;
      const carriedForwardValue = Number((carriedForwardQuantity * pricePerUnit).toFixed(2));
      const additionalPurchaseQty = Math.max(requiredQuantityForYear - carriedForwardQuantity, 0);
      const totalRequiredValue = Number((requiredQuantityForYear * pricePerUnit).toFixed(2));
      const additionalPurchaseValue = Number((additionalPurchaseQty * pricePerUnit).toFixed(2));

      nextRecord.carried_forward_value = carriedForwardValue ? carriedForwardValue.toString() : '0';
      nextRecord.additional_purchase_qty = additionalPurchaseQty ? additionalPurchaseQty.toString() : '0';
      nextRecord.total_required_value = totalRequiredValue ? totalRequiredValue.toString() : '0';
      nextRecord.additional_purchase_value = additionalPurchaseValue ? additionalPurchaseValue.toString() : '0';

      return nextRecord;
    });
  };

  const saveBulkPurchasePlans = async () => {
    try {
      const nextValidationErrors: Record<number, { inPlan?: string; carriedForwardQuantity?: string; purchasingDepartment?: string }> = {};

      const validRecords = bulkRecords.filter((record) => {
        const hasProduct = record.product_code.trim() !== '' && record.product_name.trim() !== '';
        if (!hasProduct) {
          return false;
        }

        const recordErrors: { inPlan?: string; carriedForwardQuantity?: string; purchasingDepartment?: string } = {};

        if (!record.in_plan.trim()) {
          recordErrors.inPlan = 'กรุณาเลือกประเภทในแผน/นอกแผน';
        }

        if (record.carried_forward_quantity.trim() === '' || Number.isNaN(Number(record.carried_forward_quantity)) || Number(record.carried_forward_quantity) < 0) {
          recordErrors.carriedForwardQuantity = 'กรุณากรอกจำนวนยกยอดมาให้ถูกต้อง';
        }

        if (!record.purchasing_department.trim()) {
          recordErrors.purchasingDepartment = 'กรุณาเลือกหน่วยงานจัดซื้อ';
        }

        if (Object.keys(recordErrors).length > 0) {
          nextValidationErrors[record.id] = recordErrors;
          return false;
        }

        return true;
      });

      setBulkValidationErrors(nextValidationErrors);

      if (validRecords.length === 0) {
        setToast({
          message: bulkRecords.length > 0 ? 'กรุณากรอกข้อมูลที่จำเป็นให้ครบถ้วน' : 'กรุณาเลือกสินค้าอย่างน้อย 1 รายการ',
          type: 'error',
          visible: true,
        });
        hideToastLater();
        return;
      }

      const requests = validRecords.map((record) =>
        fetch('/api/purchase-plans', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            product_code: record.product_code.trim(),
            category: record.category || '',
            product_name: record.product_name.trim(),
            product_type: record.product_type || '',
            product_subtype: record.product_subtype || '',
            unit: record.unit || '',
            price_per_unit: record.price_per_unit ? Number(record.price_per_unit) : 0,
            budget_year: record.budget_year || '',
            plan_id: record.plan_id,
            in_plan: record.in_plan,
            carried_forward_quantity: record.carried_forward_quantity ? Number(record.carried_forward_quantity) : 0,
            carried_forward_value: record.carried_forward_value ? Number(record.carried_forward_value) : 0,
            required_quantity_for_year: record.required_quantity_for_year ? Number(record.required_quantity_for_year) : 0,
            total_required_value: record.total_required_value ? Number(record.total_required_value) : 0,
            additional_purchase_qty: record.additional_purchase_qty ? Number(record.additional_purchase_qty) : 0,
            additional_purchase_value: record.additional_purchase_value ? Number(record.additional_purchase_value) : 0,
            purchasing_department: record.purchasing_department,
          }),
        })
      );

      const results = await Promise.allSettled(requests);
      const successful = results.filter((result) => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;

      if (successful > 0) {
        closeBulkForm();
        await Promise.all([fetchData(), fetchSummaryData()]);
        setToast({
          message: `บันทึกสำเร็จ ${successful} รายการ${failed > 0 ? `, ไม่สำเร็จ ${failed} รายการ` : ''}`,
          type: 'success',
          visible: true,
        });
        hideToastLater();
      }

      if (failed > 0 && successful === 0) {
        await Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถบันทึกรายการได้', 'error');
      }
    } catch (error) {
      console.error('Error saving bulk purchase plans:', error);
      await Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถบันทึกรายการได้', 'error');
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const method = editing ? 'PUT' : 'POST';
    const url = editing ? `/api/purchase-plans/${editing.id}` : '/api/purchase-plans';
    const res = await fetch(url, { method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(formData) });
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

  const handleDelete = async (id: number) => {
    const result = await Swal.fire({ title: 'ลบข้อมูล?', text: 'ยืนยันการลบรายการ', icon: 'warning', showCancelButton: true, confirmButtonText: 'ลบ', cancelButtonText: 'ยกเลิก' });
    if (!result.isConfirmed) return;
    const res = await fetch(`/api/purchase-plans/${id}`, { method: 'DELETE' });
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
        <h1 className="text-3xl font-bold text-gray-800">แผนจัดซื้อ</h1>
        <button
          onClick={openCreateForm}
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        >
          เพิ่มรายการ
        </button>
      </div>

      {showForm && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-100/80 p-2 backdrop-blur-sm md:p-4">
          <div className="flex h-[96vh] w-[98vw] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-[0_24px_80px_rgba(15,23,42,0.18)] ring-1 ring-slate-200">
            <div className="flex justify-between items-center mb-4">
              <div className="flex items-center justify-between border-b border-slate-200 bg-gradient-to-r from-blue-50 via-white to-slate-50 px-5 py-3 w-full">
                <h3 className="text-lg font-medium">{editing ? 'แก้ไขรายการ' : 'เพิ่มรายการแผนการจัดซื้อ'}</h3>
                <button onClick={resetForm} className="rounded-full p-1.5 text-slate-500 transition-colors hover:bg-white hover:text-slate-700">✕</button>
              </div>
            </div>
            {editing ? (
              <form onSubmit={handleSubmit} className="space-y-4 overflow-auto px-5 pb-5">
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">อ้างอิงแผนการใช้</span>
                    <input id="purchase-plan-surveySearch" type="text" value={surveySearchTerm} name="surveySearch" className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">รายการในแผน/นอกแผน</span>
                    <select id="purchase-plan-inPlan" name="in_plan" value={formData.in_plan || ''} onChange={handleInputChange} className={modalFieldClassName}>
                      <option value="">เลือกประเภท</option>
                      <option value="ในแผน">ในแผน</option>
                      <option value="นอกแผน">นอกแผน</option>
                    </select>
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">จำนวนยกยอดมา</span>
                    <input id="purchase-plan-carriedForwardQuantity" type="number" name="carried_forward_quantity" value={formData.carried_forward_quantity ?? ''} onChange={handleInputChange} className={modalFieldClassName} min="0" />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">มูลค่ายกยอดมา</span>
                    <input id="purchase-plan-carriedForwardValue" type="number" step="0.01" name="carried_forward_value" value={formData.carried_forward_value ?? ''} className={`${modalFieldClassName} bg-gray-50`} min="0" readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">รหัสสินค้า</span>
                    <input id="purchase-plan-productCode" name="product_code" value={formData.product_code || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ชื่อสินค้า</span>
                    <input id="purchase-plan-productName" name="product_name" value={formData.product_name || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">หน่วย</span>
                    <input id="purchase-plan-unit" name="unit" value={formData.unit || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">หมวดหมู่</span>
                    <input id="purchase-plan-category" name="category" value={formData.category || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ประเภท</span>
                    <input id="purchase-plan-productType" name="product_type" value={formData.product_type || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ประเภทย่อย</span>
                    <input id="purchase-plan-productSubtype" name="product_subtype" value={formData.product_subtype || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ราคา/หน่วย</span>
                    <input id="purchase-plan-pricePerUnit" type="number" step="0.01" name="price_per_unit" value={formData.price_per_unit ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">จำนวนที่ต้องการใช้ในปี</span>
                    <input id="purchase-plan-requiredQuantityForYear" type="number" name="required_quantity_for_year" value={formData.required_quantity_for_year ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">มูลค่ารวมที่ต้องใช้ในปี</span>
                    <input id="purchase-plan-totalRequiredValue" type="number" step="0.01" name="total_required_value" value={formData.total_required_value ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">จำนวนที่ต้องซื้อเพิ่มในปี</span>
                    <input id="purchase-plan-additionalPurchaseQty" type="number" name="additional_purchase_qty" value={formData.additional_purchase_qty ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">มูลค่าที่ต้องซื้อเพิ่มในปี</span>
                    <input id="purchase-plan-additionalPurchaseValue" type="number" step="0.01" name="additional_purchase_value" value={formData.additional_purchase_value ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">ปีงบประมาณ</span>
                    <input id="purchase-plan-budgetYear" name="budget_year" value={formData.budget_year || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  </label>
                  <label className="flex flex-col gap-1 text-sm text-gray-700">
                    <span className="font-medium">หน่วยงานจัดซื้อ</span>
                    <select id="purchase-plan-purchasingDepartment" name="purchasing_department" value={formData.purchasing_department || ''} onChange={handleInputChange} className={modalFieldClassName}>
                      <option value="">เลือกหน่วยงานจัดซื้อ</option>
                      {purchasingDepartmentOptions.map((department) => (
                        <option key={department} value={department}>{department}</option>
                      ))}
                    </select>
                  </label>
                </div>
                <div className="flex justify-end space-x-3 border-t border-slate-200 pt-5">
                  <button type="button" onClick={resetForm} className="px-4 py-2 border rounded">ยกเลิก</button>
                  <button type="submit" className="px-4 py-2 bg-blue-600 text-white rounded">บันทึก</button>
                </div>
              </form>
            ) : (
              <div className="flex min-h-0 flex-1 flex-col px-6 py-6">
                <div className="relative z-20 mb-4 rounded-2xl border border-blue-100 bg-blue-50 p-4">
                  <label htmlFor="purchase-plan-surveySearch" className="mb-2 block text-sm font-medium text-gray-700">
                    ค้นหารหัสหรือชื่อสินค้า
                  </label>
                  <div className="relative">
                    <input
                      ref={surveySearchInputRef}
                      id="purchase-plan-surveySearch"
                      type="text"
                      value={surveySearchTerm}
                      name="surveySearch"
                      onChange={(e) => {
                        setSurveySearchTerm(e.target.value);
                        setShowSurveySuggestions(true);
                        setHighlightedSurveyIndex(-1);
                      }}
                      onFocus={() => {
                        if (surveySearchTerm.trim() && surveySearchTerm.trim() !== selectedSearchLabel.trim()) {
                          setShowSurveySuggestions(true);
                        }
                      }}
                      onKeyDown={handleSurveySearchKeyDown}
                      placeholder="พิมพ์รหัสสินค้า หรือชื่อสินค้า"
                      autoComplete="off"
                      className={`${modalFieldClassName} pr-10`}
                    />
                    {surveySearchTerm && (
                      <button type="button" onClick={clearSurveySelection} className="absolute inset-y-0 right-2 flex items-center text-gray-400 hover:text-gray-600" aria-label="ล้างค่า">
                        <X className="h-4 w-4" />
                      </button>
                    )}
                    {showSurveySuggestions && (
                      <div ref={surveySuggestionsRef} className="absolute z-50 mt-2 max-h-72 w-full overflow-auto rounded-md border border-gray-200 bg-white shadow-2xl">
                        {showSurveySuggestions && !filteredSurveyOptions.length && isSurveySearchDirty ? (
                          <div className="px-4 py-3 text-sm text-gray-500">ไม่พบรายการที่ค้นหา</div>
                        ) : (
                          filteredSurveyOptions.map((survey, index) => (
                            <button
                              key={survey.id}
                              data-survey-suggestion-index={index}
                              type="button"
                              onMouseDown={(e) => e.preventDefault()}
                              onClick={() => handleSurveySelect(survey)}
                              className={`block w-full border-b border-gray-100 px-4 py-3 text-left text-sm ${index === highlightedSurveyIndex ? 'bg-blue-50' : 'hover:bg-gray-50'}`}
                            >
                              <div className="font-medium text-gray-900">{survey.product_code || '-'} | {survey.product_name || '-'}</div>
                              <div className="text-xs text-gray-500">{survey.category || '-'} | {survey.type || '-'} | {survey.unit || '-'} | {survey.requesting_dept || '-'}</div>
                            </button>
                          ))
                        )}
                      </div>
                    )}
                  </div>
                  {surveysLoading && <span className="mt-2 block text-xs text-gray-500">กำลังโหลดรายการสินค้า...</span>}
                </div>

                <div className="min-h-0 flex-1 overflow-hidden rounded-xl border border-slate-200 bg-slate-50">
                  <div className="h-full overflow-auto">
                    <table className="w-full">
                      <thead className="bg-slate-100">
                        <tr>
                          <th className="w-12 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ลำดับ</th>
                          <th className="w-36 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">รหัสสินค้า</th>
                          <th className="min-w-[20rem] px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ชื่อสินค้า</th>
                          <th className="w-28 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ประเภท</th>
                          <th className="w-28 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ยกยอดมา</th>
                          <th className="w-28 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">มูลค่ายกยอด</th>
                          <th className="w-28 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ต้องใช้/ปี</th>
                          <th className="w-28 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ซื้อเพิ่ม</th>
                          <th className="w-32 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">หน่วยงานจัดซื้อ</th>
                          <th className="w-24 px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">จัดการ</th>
                        </tr>
                      </thead>
                      <tbody>
                        {bulkRecords.map((record, index) => (
                          <tr key={record.id} className="border-b border-slate-200 bg-white align-top">
                            <td className="w-12 px-2 py-3 text-xs text-gray-900">{index + 1}</td>
                            <td className="w-36 px-2 py-3">
                              <input value={record.product_code} readOnly className="w-full rounded border border-gray-300 bg-gray-100 px-2 py-1 text-xs" />
                            </td>
                            <td className="min-w-[20rem] px-2 py-3">
                              <input value={record.product_name} readOnly title={record.product_name} className="w-full rounded border border-gray-300 bg-gray-100 px-2 py-1 text-xs" />
                            </td>
                            <td className="w-28 px-2 py-3">
                              <select
                                value={record.in_plan}
                                onChange={(e) => {
                                  handleBulkFieldChange(record.id, 'in_plan', e.target.value);
                                  clearBulkValidationError(record.id, 'inPlan');
                                }}
                                className={`w-full rounded border px-2 py-1 text-xs ${bulkValidationErrors[record.id]?.inPlan ? 'border-red-500' : 'border-gray-300'}`}
                              >
                                <option value="">เลือกประเภท</option>
                                <option value="ในแผน">ในแผน</option>
                                <option value="นอกแผน">นอกแผน</option>
                              </select>
                              {bulkValidationErrors[record.id]?.inPlan && <p className="mt-1 text-[10px] text-red-600">{bulkValidationErrors[record.id]?.inPlan}</p>}
                            </td>
                            <td className="w-28 px-2 py-3">
                              <input
                                type="number"
                                min="0"
                                value={record.carried_forward_quantity}
                                onChange={(e) => {
                                  handleBulkFieldChange(record.id, 'carried_forward_quantity', e.target.value);
                                  clearBulkValidationError(record.id, 'carriedForwardQuantity');
                                }}
                                className={`w-full rounded border px-2 py-1 text-xs ${bulkValidationErrors[record.id]?.carriedForwardQuantity ? 'border-red-500' : 'border-gray-300'}`}
                              />
                              {bulkValidationErrors[record.id]?.carriedForwardQuantity && <p className="mt-1 text-[10px] text-red-600">{bulkValidationErrors[record.id]?.carriedForwardQuantity}</p>}
                            </td>
                            <td className="w-28 px-2 py-3">
                              <input value={record.carried_forward_value} readOnly className="w-full rounded border border-gray-300 bg-gray-100 px-2 py-1 text-xs" />
                            </td>
                            <td className="w-28 px-2 py-3">
                              <input value={record.required_quantity_for_year} readOnly className="w-full rounded border border-gray-300 bg-gray-100 px-2 py-1 text-xs" />
                            </td>
                            <td className="w-28 px-2 py-3">
                              <input value={record.additional_purchase_qty} readOnly className="w-full rounded border border-gray-300 bg-gray-100 px-2 py-1 text-xs" />
                            </td>
                            <td className="w-32 px-2 py-3">
                              <select
                                value={record.purchasing_department}
                                onChange={(e) => {
                                  handleBulkFieldChange(record.id, 'purchasing_department', e.target.value);
                                  clearBulkValidationError(record.id, 'purchasingDepartment');
                                }}
                                className={`w-full rounded border px-2 py-1 text-xs ${bulkValidationErrors[record.id]?.purchasingDepartment ? 'border-red-500' : 'border-gray-300'}`}
                              >
                                <option value="">เลือกหน่วยงาน</option>
                                {departments.map((department) => (
                                  <option key={department} value={department}>{department}</option>
                                ))}
                              </select>
                              {bulkValidationErrors[record.id]?.purchasingDepartment && <p className="mt-1 text-[10px] text-red-600">{bulkValidationErrors[record.id]?.purchasingDepartment}</p>}
                            </td>
                            <td className="w-24 px-2 py-3">
                              <button
                                type="button"
                                onClick={() => {
                                  setBulkRecords((prev) => prev.filter((current) => current.id !== record.id));
                                  setBulkValidationErrors((prev) => {
                                    const nextErrors = { ...prev };
                                    delete nextErrors[record.id];
                                    return nextErrors;
                                  });
                                }}
                                className="rounded p-1 text-red-600 hover:text-red-800"
                                title="ลบแถวนี้"
                              >
                                <X className="h-4 w-4" />
                              </button>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>

                <div className="mt-5 flex items-center justify-end gap-3 border-t border-slate-200 bg-slate-50 px-1 pt-5">
                  <button type="button" onClick={resetForm} className="rounded-lg bg-slate-500 px-6 py-2.5 text-white transition-colors hover:bg-slate-600">ยกเลิก</button>
                  <button type="button" onClick={saveBulkPurchasePlans} className="rounded-lg bg-blue-600 px-6 py-2.5 text-white shadow-sm transition-colors hover:bg-blue-700">บันทึกทั้งหมด ({bulkRecords.length} รายการ)</button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 md:grid-cols-6 gap-4 mb-4">
            <select value={budgetYearFilter} onChange={(e)=>setBudgetYearFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ปีงบ</option>
              {availableBudgetYears.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={requestingDeptFilter} onChange={(e)=>setRequestingDeptFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หน่วยงาน</option>
              {departments.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <input placeholder="ชื่อสินค้า" value={productNameFilter} onChange={(e)=>setProductNameFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2" />
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
          </div>
       </div>
     </div>

      {/* Summary Section (based on filtered dataset, not pagination) */}
      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <h3 className="text-lg font-medium text-gray-900">สรุปข้อมูลแผนการจัดซื้อ</h3>
            <div className="flex flex-wrap items-center gap-6 text-sm">
              <div>
                <span className="text-gray-500">มูลค่ารวมตามแผน (total_required_value): </span>
                <span className="font-semibold text-gray-900">
                  ฿{summaryItems
                    .reduce((sum, row) => sum + (Number(row.total_required_value) || 0), 0)
                    .toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
              <div>
                <span className="text-gray-500">มูลค่ารวมซื้อเพิ่ม (additional_purchase_value): </span>
                <span className="font-semibold text-gray-900">
                  ฿{summaryItems
                    .reduce((sum, row) => sum + (Number(row.additional_purchase_value) || 0), 0)
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
                <th onClick={()=>handleSort('product_code')} className={getHeaderClass('product_code')}>รหัส</th>
                <th onClick={()=>handleSort('product_name')} className={getHeaderClass('product_name')}>ชื่อสินค้า</th>
                <th onClick={()=>handleSort('category')} className={getHeaderClass('category')}>หมวด</th>
                <th onClick={()=>handleSort('product_type')} className={getHeaderClass('product_type')}>ประเภท</th>
                <th onClick={()=>handleSort('unit')} className={getHeaderClass('unit')}>หน่วย</th>
                <th onClick={()=>handleSort('price_per_unit')} className={getHeaderClass('price_per_unit')}>ราคา/หน่วย</th>
                <th onClick={()=>handleSort('required_quantity_for_year')} className={getHeaderClass('required_quantity_for_year')}>ต้องการ/ปี</th>
                <th onClick={()=>handleSort('total_required_value')} className={getHeaderClass('total_required_value')}>มูลค่ารวม</th>
                <th onClick={()=>handleSort('budget_year')} className={getHeaderClass('budget_year')}>ปีงบ</th>
                <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-24">Action</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {items.map((row) => (
                <tr key={row.id}>
                  <td className="px-3 py-2 text-xs">{row.product_code}</td>
                  <td className="px-3 py-2 text-xs">
                    <div className="whitespace-normal break-words" title={row.product_name}>
                      {row.product_name}
                    </div>
                  </td>
                  <td className="px-3 py-2 text-xs">{row.category}</td>
                  <td className="px-3 py-2 text-xs">{row.product_type}</td>
                  <td className="px-3 py-2 text-xs">{row.unit}</td>
                  <td className="px-3 py-2 text-xs">{row.price_per_unit ? Number(row.price_per_unit).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                  <td className="px-3 py-2 text-xs">{row.required_quantity_for_year ?? '-'}</td>
                  <td className="px-3 py-2 text-xs">{row.total_required_value ? Number(row.total_required_value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                  <td className="px-3 py-2 text-xs">{row.budget_year}</td>
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

export default function PurchasePlansPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-gray-50" />}>
      <PurchasePlansPageContent />
    </Suspense>
  );
}
