'use client';

import { Suspense, useState, useEffect, useRef, useMemo } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { Upload, Plus, CheckCircle2, AlertCircle, X as XIcon, ChevronUp, ChevronDown, ArrowUpDown, Pencil, Trash2, Search, X } from 'lucide-react';

const PRODUCT_SUGGESTION_LIMIT = 12;

const getCurrentBudgetYear = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

const formatDateTime = (value?: string | null) => {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '-';
  return date.toLocaleString('th-TH', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
  });
};

interface ProductOption {
  id: number;
  code: string;
  name: string;
  category: string;
  type: string;
  subtype: string | null;
  unit: string;
  costPrice?: number | null;
}

interface BulkSurveyRecord {
  id: number;
  productSearch: string;
  productCode: string;
  category: string;
  type: string;
  subtype: string;
  productName: string;
  requestedAmount: string;
  unit: string;
  pricePerUnit: string;
  requestingDept: string;
  approvedQuota: string;
  budgetYear: string;
  sequenceNo: string;
}

interface Survey {
  id: number;
  productCode: string | null;
  category: string | null;
  type: string | null;
  subtype: string | null;
  productName: string | null;
  requestedAmount: number | null;
  unit: string | null;
  pricePerUnit: number;
  requestingDept: string | null;
  approvedQuota: number | null;
  budgetYear: number | null;
  sequenceNo: number | null;
  createdAt: string;
  updatedAt: string;
}

interface SurveyFormData {
  productCode: string;
  category: string;
  type: string;
  subtype: string;
  productName: string;
  requestedAmount: string;
  unit: string;
  pricePerUnit: string;
  requestingDept: string;
  approvedQuota: string;
  budgetYear: string;
  sequenceNo: string;
}

interface CategoryOption {
  category: string;
  type: string;
  subtype: string | null;
}

function SurveysPageContent() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const initialProductNameFilter = searchParams.get('productName') || '';
  const initialCategoryFilter = searchParams.get('category') || '';
  const initialTypeFilter = searchParams.get('type') || '';
  const initialSubtypeFilter = searchParams.get('subtype') || '';
  const initialRequestingDeptFilter = searchParams.get('requestingDept') || '';
  const initialBudgetYearFilter = searchParams.get('budgetYear') || getCurrentBudgetYear().toString();
  const initialSortField = searchParams.get('orderBy') || 'id';
  const initialSortOrder = (searchParams.get('sortOrder') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
  const initialPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
  const initialPageSize = Math.max(1, parseInt(searchParams.get('pageSize') || '20', 10) || 20);
  const [surveys, setSurveys] = useState<Survey[]>([]);
  const [summarySurveys, setSummarySurveys] = useState<Survey[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingSurvey, setEditingSurvey] = useState<Survey | null>(null);
  const [importing, setImporting] = useState(false);
  const [formData, setFormData] = useState<SurveyFormData>({
    productCode: '',
    category: '',
    type: '',
    subtype: '',
    productName: '',
    requestedAmount: '',
    unit: '',
    pricePerUnit: '',
    requestingDept: '',
    approvedQuota: '',
    budgetYear: getCurrentBudgetYear().toString(),
    sequenceNo: '1'
  });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingField, setEditingField] = useState<'requestedAmount' | 'requestingDept' | 'approvedQuota' | null>(null);
  const [isInlineSaving, setIsInlineSaving] = useState(false);
  const [editData, setEditData] = useState({
    productCode: '',
    category: '',
    type: '',
    subtype: '',
    productName: '',
    requestedAmount: '',
    unit: '',
    pricePerUnit: '',
    requestingDept: '',
    approvedQuota: '',
    budgetYear: getCurrentBudgetYear().toString(),
    sequenceNo: '1'
  });
  const [showBulkForm, setShowBulkForm] = useState(false);
  const [bulkRecords, setBulkRecords] = useState<BulkSurveyRecord[]>([]);
  const [toast, setToast] = useState<{
    message: string;
    type: 'success' | 'error';
    visible: boolean;
  }>({
    message: '',
    type: 'success',
    visible: false
  });
  const fileInputRef = useRef<HTMLInputElement>(null);
  const bulkProductSearchInputRef = useRef<HTMLInputElement>(null);
  const bulkProductSuggestionsRef = useRef<HTMLDivElement>(null);
  const inlineEditContainerRef = useRef<HTMLTableCellElement | null>(null);
  const hasSyncedSearchParamsRef = useRef(false);
  
  // Validation state
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [productNameFilter, setProductNameFilter] = useState(initialProductNameFilter);
  const [categoryFilter, setCategoryFilter] = useState(initialCategoryFilter);
  const [typeFilter, setTypeFilter] = useState(initialTypeFilter);
  const [subtypeFilter, setSubtypeFilter] = useState(initialSubtypeFilter);
  const [requestingDeptFilter, setRequestingDeptFilter] = useState(initialRequestingDeptFilter);
  const [budgetYearFilter, setBudgetYearFilter] = useState(initialBudgetYearFilter);
  
  // Sort states
  const [sortField, setSortField] = useState(initialSortField);
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>(initialSortOrder);
  const [page, setPage] = useState(initialPage);
  const [pageSize, setPageSize] = useState(initialPageSize);
  
  // Filter options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<CategoryOption[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);
  const [budgetYears, setBudgetYears] = useState<number[]>([]);
  const [productOptions, setProductOptions] = useState<ProductOption[]>([]);
  const [productSearch, setProductSearch] = useState('');
  const [showProductSuggestions, setShowProductSuggestions] = useState(false);
  const [highlightedProductIndex, setHighlightedProductIndex] = useState(-1);
  const [selectedProductLabel, setSelectedProductLabel] = useState('');
  const [bulkProductSearch, setBulkProductSearch] = useState('');
  const [showBulkProductSuggestions, setShowBulkProductSuggestions] = useState(false);
  const [highlightedBulkProductIndex, setHighlightedBulkProductIndex] = useState(-1);
  const [selectedBulkProductLabel, setSelectedBulkProductLabel] = useState('');
  const [bulkValidationErrors, setBulkValidationErrors] = useState<Record<number, { requestedAmount?: string; requestingDept?: string }>>({});
  const bulkProductSearchAbortRef = useRef<AbortController | null>(null);
  const dataRequestIdRef = useRef(0);
  const summaryRequestIdRef = useRef(0);
  const hasMountedSummaryRef = useRef(false);

  const fallbackBudgetYears = Array.from({ length: 6 }, (_, index) => getCurrentBudgetYear() - index);
  const availableBudgetYears = useMemo(() => {
    return Array.from(new Set([
      ...budgetYears,
      getCurrentBudgetYear()
    ])).sort((a, b) => b - a);
  }, [budgetYears]);

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
    if (!hasSyncedSearchParamsRef.current) {
      hasSyncedSearchParamsRef.current = true;
      return;
    }

    const nextProductName = searchParams.get('productName') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('type') || '';
    const nextSubtype = searchParams.get('subtype') || '';
    const nextRequestingDept = searchParams.get('requestingDept') || '';
    const nextBudgetYear = searchParams.get('budgetYear') || getCurrentBudgetYear().toString();
    const nextSortField = searchParams.get('orderBy') || 'id';
    const nextSortOrder = (searchParams.get('sortOrder') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
    const nextPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const nextPageSize = Math.max(1, parseInt(searchParams.get('pageSize') || '20', 10) || 20);

    setProductNameFilter((prev) => prev === nextProductName ? prev : nextProductName);
    setCategoryFilter((prev) => prev === nextCategory ? prev : nextCategory);
    setTypeFilter((prev) => prev === nextType ? prev : nextType);
    setSubtypeFilter((prev) => prev === nextSubtype ? prev : nextSubtype);
    setRequestingDeptFilter((prev) => prev === nextRequestingDept ? prev : nextRequestingDept);
    setBudgetYearFilter((prev) => prev === nextBudgetYear ? prev : nextBudgetYear);
    setSortField((prev) => prev === nextSortField ? prev : nextSortField);
    setSortOrder((prev) => prev === nextSortOrder ? prev : nextSortOrder);
    setPage((prev) => prev === nextPage ? prev : nextPage);
    setPageSize((prev) => prev === nextPageSize ? prev : nextPageSize);
  }, [searchParams]);

  useEffect(() => {
    const params = new URLSearchParams();

    if (productNameFilter) params.set('productName', productNameFilter);
    if (categoryFilter) params.set('category', categoryFilter);
    if (typeFilter) params.set('type', typeFilter);
    if (subtypeFilter) params.set('subtype', subtypeFilter);
    if (requestingDeptFilter) params.set('requestingDept', requestingDeptFilter);
    if (budgetYearFilter) params.set('budgetYear', budgetYearFilter);
    if (sortField && sortField !== 'id') params.set('orderBy', sortField);
    if (sortOrder !== 'desc') params.set('sortOrder', sortOrder);
    if (page > 1) params.set('page', page.toString());
    if (pageSize !== 20) params.set('pageSize', pageSize.toString());

    const nextUrl = params.toString() ? `${pathname}?${params.toString()}` : pathname;
    router.replace(nextUrl, { scroll: false });
  }, [pathname, router, productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortField, sortOrder, page, pageSize]);

  useEffect(() => {
    fetchFilterOptions();
  }, []);

  useEffect(() => {
    if (!showBulkForm) {
      return;
    }

    const searchValue = bulkProductSearch.trim();
    if (searchValue.length === 0) {
      setProductOptions([]);
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
          pageSize: PRODUCT_SUGGESTION_LIMIT.toString(),
          orderBy: 'code',
          sortOrder: 'asc',
          search: searchValue,
        });

        const response = await fetch(`/api/products?${params.toString()}`, {
          signal: controller.signal,
        });

        if (!response.ok) {
          throw new Error('Failed to search products');
        }

        const data = await response.json();
        setProductOptions((data.data || []) as ProductOption[]);
        setShowBulkProductSuggestions(true);
        setHighlightedBulkProductIndex(-1);
      } catch (error) {
        if ((error as Error).name === 'AbortError') {
          return;
        }
        console.error('Error searching bulk product options:', error);
        setProductOptions([]);
      }
    }, 250);

    return () => {
      window.clearTimeout(timeoutId);
      bulkProductSearchAbortRef.current?.abort();
    };
  }, [bulkProductSearch, showBulkForm]);

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

  // Fetch surveys when filters, sorting or pagination change (current page only)
  useEffect(() => {
    fetchSurveys();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortField, sortOrder, page, pageSize]);

  // Fetch summary data when filters change (independent of pagination)
  useEffect(() => {
    fetchSummarySurveys();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortField, sortOrder]);

  useEffect(() => {
    if (!hasMountedSummaryRef.current) {
      hasMountedSummaryRef.current = true;
      return;
    }

    setPage((prev) => (prev === 1 ? prev : 1));
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortField, sortOrder]);

  const fetchFilterOptions = async () => {
    try {
      const response = await fetch('/api/usage-plans/filters');
      if (response.ok) {
        const data = await response.json();
        setCategories(data.categories);
        setTypes(data.types);
        setSubtypes(data.subtypes);
        setCategoryOptions(data.categoryOptions || []);
        setDepartments(data.departments);
        setBudgetYears((data.budgetYears || []).sort((a: number, b: number) => b - a));
      }
    } catch (error) {
      console.error('Error fetching filter options:', error);
    }
  };

  const handleBulkProductSearchKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (!showBulkProductSuggestions || filteredBulkProductOptions.length === 0) {
      return;
    }

    if (event.key === 'ArrowDown') {
      event.preventDefault();
      setHighlightedBulkProductIndex((prev) => (prev + 1) % filteredBulkProductOptions.length);
    }

    if (event.key === 'ArrowUp') {
      event.preventDefault();
      setHighlightedBulkProductIndex((prev) => (prev <= 0 ? filteredBulkProductOptions.length - 1 : prev - 1));
    }

    if (event.key === 'Enter' && highlightedBulkProductIndex >= 0) {
      event.preventDefault();
      const selectedOption = filteredBulkProductOptions[highlightedBulkProductIndex];
      if (selectedOption) {
        handleBulkProductSelect(selectedOption.id, `${selectedOption.code} - ${selectedOption.name}`);
      }
    }

    if (event.key === 'Escape') {
      setShowBulkProductSuggestions(false);
      setHighlightedBulkProductIndex(-1);
    }
  };

  const filteredProductOptions = productSearch.trim().length === 0
    ? productOptions.slice(0, 12)
    : productOptions.filter((product) => {
        const searchValue = productSearch.trim().toLowerCase();
        return [product.code, product.name]
          .filter(Boolean)
          .some((value) => String(value).toLowerCase().includes(searchValue));
      }).slice(0, 12);

  const shouldShowProductNoResults = showProductSuggestions
    && productSearch.trim().length > 0
    && productSearch.trim() !== selectedProductLabel.trim()
    && filteredProductOptions.length === 0;

  const filteredBulkProductOptions = productOptions.slice(0, PRODUCT_SUGGESTION_LIMIT);

  const shouldShowBulkProductNoResults = showBulkProductSuggestions
    && bulkProductSearch.trim().length > 0
    && bulkProductSearch.trim() !== selectedBulkProductLabel.trim()
    && filteredBulkProductOptions.length === 0;

  const handleProductSearchKeyDown = (event: React.KeyboardEvent<HTMLInputElement>) => {
    if (!showProductSuggestions || filteredProductOptions.length === 0) {
      return;
    }

    if (event.key === 'ArrowDown') {
      event.preventDefault();
      setHighlightedProductIndex((prev) => (prev + 1) % filteredProductOptions.length);
    }

    if (event.key === 'ArrowUp') {
      event.preventDefault();
      setHighlightedProductIndex((prev) => (prev <= 0 ? filteredProductOptions.length - 1 : prev - 1));
    }

    if (event.key === 'Enter' && highlightedProductIndex >= 0) {
      event.preventDefault();
      const selectedOption = filteredProductOptions[highlightedProductIndex];
      if (selectedOption) {
        handleProductSelect(`${selectedOption.code} - ${selectedOption.name}`);
      }
    }

    if (event.key === 'Escape') {
      setShowProductSuggestions(false);
      setHighlightedProductIndex(-1);
    }
  };

  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + (surveys.length || 0) - 1);

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) return;
    setPage(newPage);
  };

  const resetToNewestFirst = () => {
    setSortField('id');
    setSortOrder('desc');
    setPage(1);
  };

  const hideToastLater = () => {
    setTimeout(() => {
      setToast((prev) => ({ ...prev, visible: false }));
    }, 3000);
  };

  const handlePageSizeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const newSize = parseInt(e.target.value, 10);
    setPageSize(newSize);
    setPage(1);
  };

  const fetchSurveys = async () => {
    const requestId = ++dataRequestIdRef.current;
    try {
      setLoading(true);
      const params = new URLSearchParams();
      
      if (productNameFilter) params.append('productName', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (subtypeFilter) params.append('subtype', subtypeFilter);
      if (requestingDeptFilter) params.append('requestingDept', requestingDeptFilter);
      if (budgetYearFilter) params.append('budgetYear', budgetYearFilter);
      if (sortField) params.append('orderBy', sortField);
      if (sortOrder) params.append('sortOrder', sortOrder);
      params.append('page', page.toString());
      params.append('pageSize', pageSize.toString());
      
      const response = await fetch(`/api/usage-plans?${params.toString()}`);
      if (response.ok) {
        const data = await response.json();
        if (requestId !== dataRequestIdRef.current) {
          return;
        }
        setSurveys(data.surveys);
        setTotalCount(data.totalCount || 0);
        if (data.page && data.page !== page) {
          setPage(data.page);
        }
        if (data.pageSize && data.pageSize !== pageSize) {
          setPageSize(data.pageSize);
        }
      }
    } catch (error) {
      console.error('Error fetching surveys:', error);
    } finally {
      if (requestId === dataRequestIdRef.current) {
        setLoading(false);
      }
    }
  };

  // Fetch full filtered dataset for summary (not paginated)
  const fetchSummarySurveys = async () => {
    const requestId = ++summaryRequestIdRef.current;
    try {
      const params = new URLSearchParams();

      if (productNameFilter) params.append('productName', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (subtypeFilter) params.append('subtype', subtypeFilter);
      if (requestingDeptFilter) params.append('requestingDept', requestingDeptFilter);
      if (sortField) params.append('orderBy', sortField);
      if (sortOrder) params.append('sortOrder', sortOrder);

      const response = await fetch(`/api/usage-plans?${params.toString()}`);
      if (response.ok) {
        const data = await response.json();
        if (requestId !== summaryRequestIdRef.current) {
          return;
        }
        setSummarySurveys(data.surveys || []);
      }
    } catch (error) {
      console.error('Error fetching summary surveys:', error);
    }
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: '' }));
    }
  };

  const handleProductSelect = (value: string) => {
    setProductSearch(value);

    const normalizedValue = value.trim().toLowerCase();
    const selectedProduct = productOptions.find((product) => {
      const label = `${product.code} - ${product.name}`.toLowerCase();
      return label === normalizedValue || product.code.toLowerCase() === normalizedValue || product.name.toLowerCase() === normalizedValue;
    });

    if (!selectedProduct) {
      setSelectedProductLabel('');
      setShowProductSuggestions(value.trim().length > 0);
      setHighlightedProductIndex(-1);
      setFormData((prev) => ({
        ...prev,
        productCode: value,
        productName: '',
        category: '',
        type: '',
        subtype: '',
        unit: '',
        pricePerUnit: '',
      }));
      return;
    }

    const selectedLabel = `${selectedProduct.code} - ${selectedProduct.name}`;
    setProductSearch(selectedLabel);
    setSelectedProductLabel(selectedLabel);
    setShowProductSuggestions(false);
    setHighlightedProductIndex(-1);
    setFormData((prev) => ({
      ...prev,
      productCode: selectedProduct.code || '',
      productName: selectedProduct.name || '',
      category: selectedProduct.category || '',
      type: selectedProduct.type || '',
      subtype: selectedProduct.subtype || '',
      unit: selectedProduct.unit || '',
      pricePerUnit: selectedProduct.costPrice?.toString() || prev.pricePerUnit,
    }));

    setErrors((prev) => ({
      ...prev,
      productCode: '',
      productName: '',
    }));
  };

  const updateInlineField = (field: 'requestedAmount' | 'approvedQuota', value: string) => {
    setEditData((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const validateForm = () => {
    const newErrors: Record<string, string> = {};
    
    if (!formData.productCode.trim()) {
      newErrors.productCode = 'กรุณาระบุรหัสสินค้า';
    }
    
    if (!formData.productName.trim()) {
      newErrors.productName = 'กรุณาระบุชื่อสินค้า';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) {
      return;
    }
    
    try {
      const url = editingSurvey ? `/api/usage-plans/${editingSurvey.id}` : '/api/usage-plans';
      const method = editingSurvey ? 'PUT' : 'POST';
      
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ...formData,
          budgetYear: formData.budgetYear ? parseInt(formData.budgetYear, 10) : null,
          sequenceNo: formData.sequenceNo ? parseInt(formData.sequenceNo, 10) : null,
        }),
      });
      
      if (response.ok) {
        const savedSurvey = await response.json();
        
        closeForm();
        resetToNewestFirst();
        await fetchSurveys();
        await fetchSummarySurveys();
        if (savedSurvey?.id) {
          setEditingSurvey(null);
        }
      } else {
        const errorData = await response.json().catch(() => null);
        throw new Error(errorData?.error || 'Failed to save survey');
      }
    } catch (error) {
      console.error('Error saving survey:', error);
      await Swal.fire({
        title: 'เกิดข้อผิดพลาด!',
        text: error instanceof Error ? error.message : 'ไม่สามารถบันทึกข้อมูลได้',
        icon: 'error',
        confirmButtonText: 'ตกลง'
      });
    }
  };

  const handleEdit = (survey: Survey) => {
    setEditingSurvey(survey);
    const label = survey.productCode && survey.productName ? `${survey.productCode} - ${survey.productName}` : survey.productCode || survey.productName || '';
    setProductSearch(label);
    setSelectedProductLabel(label);
    setShowProductSuggestions(false);
    setHighlightedProductIndex(-1);
    setFormData({
      productCode: survey.productCode || '',
      category: survey.category || '',
      type: survey.type || '',
      subtype: survey.subtype || '',
      productName: survey.productName || '',
      requestedAmount: survey.requestedAmount?.toString() || '',
      unit: survey.unit || '',
      pricePerUnit: survey.pricePerUnit?.toString() || '',
      requestingDept: survey.requestingDept || '',
      approvedQuota: survey.approvedQuota?.toString() || '',
      budgetYear: survey.budgetYear?.toString() || getCurrentBudgetYear().toString(),
      sequenceNo: survey.sequenceNo?.toString() || '1'
    });
    setShowForm(true);
  };

  const handleDelete = async (survey: Survey) => {
    const result = await Swal.fire({
      title: 'คุณแน่ใจหรือไม่?',
      text: `คุณต้องการลบข้อมูล "${survey.productName}" หรือไม่?`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'ลบ',
      cancelButtonText: 'ยกเลิก'
    });

    if (result.isConfirmed) {
      try {
        const response = await fetch(`/api/usage-plans/${survey.id}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          await Swal.fire({
            title: 'ลบเรียบร้อย!',
            text: 'ข้อมูลถูกลบเรียบร้อยแล้ว',
            icon: 'success',
            confirmButtonText: 'ตกลง'
          });
          resetToNewestFirst();
          fetchSurveys();
        } else {
          throw new Error('Failed to delete survey');
        }
      } catch (error) {
        console.error('Error deleting survey:', error);
        await Swal.fire({
          title: 'เกิดข้อผิดพลาด!',
          text: 'ไม่สามารถลบข้อมูลได้',
          icon: 'error',
          confirmButtonText: 'ตกลง'
        });
      }
    }
  };

  const closeForm = () => {
    setShowForm(false);
    setEditingSurvey(null);
    setProductSearch('');
    setSelectedProductLabel('');
    setShowProductSuggestions(false);
    setHighlightedProductIndex(-1);
    setFormData({
      productCode: '',
      category: '',
      type: '',
      subtype: '',
      productName: '',
      requestedAmount: '',
      unit: '',
      pricePerUnit: '',
      requestingDept: '',
      approvedQuota: '',
      budgetYear: getCurrentBudgetYear().toString(),
      sequenceNo: '1'
    });
    setErrors({});
  };

  const handleSort = (field: string) => {
    if (sortField === field) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      setSortField(field);
      setSortOrder('asc');
    }
  };

  const handleImportClick = () => {
    fileInputRef.current?.click();
  };

  const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // reset input to allow re-selecting the same file later
    e.currentTarget.value = '';

    const validExt = [
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.ms-excel',
    ];
    if (!validExt.includes(file.type) && !file.name.match(/\.(xlsx|xls)$/i)) {
      await Swal.fire({
        title: 'ไฟล์ไม่ถูกต้อง',
        text: 'กรุณาเลือกไฟล์ Excel (.xlsx หรือ .xls)',
        icon: 'warning',
        confirmButtonText: 'ตกลง'
      });
      return;
    }

    try {
      setImporting(true);
      const formData = new FormData();
      formData.append('file', file);

      const res = await fetch('/api/usage-plans/import', {
        method: 'POST',
        body: formData,
      });

      if (!res.ok) {
        const text = await res.text();
        throw new Error(text || 'Import failed');
      }

      const data = await res.json().catch(() => ({}));

      await Swal.fire({
        title: 'นำเข้าเรียบร้อย',
        text: data?.importedCount != null ? `นำเข้าข้อมูล ${data.importedCount} รายการ` : 'นำเข้าข้อมูลสำเร็จ',
        icon: 'success',
        confirmButtonText: 'ตกลง'
      });
      resetToNewestFirst();
      fetchSurveys();
    } catch (err) {
      console.error('Error importing excel:', err);
      await Swal.fire({
        title: 'เกิดข้อผิดพลาด',
        text: 'ไม่สามารถนำเข้าไฟล์ได้',
        icon: 'error',
        confirmButtonText: 'ตกลง'
      });
    } finally {
      setImporting(false);
    }
  };

  // Start inline editing
  const startInlineEdit = (survey: Survey, field: 'requestedAmount' | 'requestingDept' | 'approvedQuota') => {
    setEditingId(survey.id);
    setEditingField(field);
    setEditData({
      productCode: survey.productCode || '',
      category: survey.category || '',
      type: survey.type || '',
      subtype: survey.subtype || '',
      productName: survey.productName || '',
      requestedAmount: survey.requestedAmount?.toString() || '',
      unit: survey.unit || '',
      pricePerUnit: survey.pricePerUnit?.toString() || '',
      requestingDept: survey.requestingDept || '',
      approvedQuota: survey.approvedQuota?.toString() || '',
      budgetYear: survey.budgetYear?.toString() || getCurrentBudgetYear().toString(),
      sequenceNo: survey.sequenceNo?.toString() || '1'
    });
  };

  // Save inline edit
  const resetInlineEdit = () => {
    setEditingId(null);
    setEditingField(null);
    setIsInlineSaving(false);
    setEditData({
      productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: '', budgetYear: getCurrentBudgetYear().toString(), sequenceNo: '1'
    });
  };

  const saveInlineEdit = async (id: number) => {
    if (isInlineSaving) {
      return;
    }

    try {
      setIsInlineSaving(true);
      const response = await fetch(`/api/usage-plans/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          requestedAmount: editData.requestedAmount,
          approvedQuota: editData.approvedQuota,
          requestingDept: editData.requestingDept,
        })
      });

      if (response.ok) {
        resetInlineEdit();
        resetToNewestFirst();
        await fetchSurveys();
        await fetchSummarySurveys();
      } else {
        const errorData = await response.json().catch(() => null);
        setToast({
          message: errorData?.error || 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
          type: 'error',
          visible: true
        });

        hideToastLater();
        setIsInlineSaving(false);
      }
    } catch (error) {
      console.error('Error updating survey:', error);

      setToast({
        message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
        type: 'error',
        visible: true
      });

      hideToastLater();
      setIsInlineSaving(false);
    }
  };

  // Cancel inline edit
  const cancelInlineEdit = () => {
    resetInlineEdit();
  };

  const handleInlineEditorBlur = (event: React.FocusEvent<HTMLElement>, surveyId: number) => {
    const nextFocusedElement = event.relatedTarget as Node | null;
    if (nextFocusedElement && inlineEditContainerRef.current?.contains(nextFocusedElement)) {
      return;
    }

    void saveInlineEdit(surveyId);
  };

  const inlineEditableCellClassName = useMemo(
    () => 'rounded transition-colors hover:bg-blue-50 focus-within:bg-blue-50',
    []
  );

  const createEmptyBulkRecord = (id: number): BulkSurveyRecord => ({
    id,
    productSearch: '',
    productCode: '',
    category: '',
    type: '',
    subtype: '',
    productName: '',
    requestedAmount: '',
    unit: '',
    pricePerUnit: '',
    requestingDept: '',
    approvedQuota: '',
    budgetYear: getCurrentBudgetYear().toString(),
    sequenceNo: '1'
  });

  const updateBulkRecord = (id: number, updater: (record: BulkSurveyRecord) => BulkSurveyRecord) => {
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

  const handleBulkProductSelect = (id: number, value: string) => {
    const normalizedValue = value.trim().toLowerCase();
    const selectedProduct = productOptions.find((product) => {
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

    setBulkRecords((prev) => {
      const hasExistingRecord = prev.some((record) => record.productCode === selectedProduct.code);
      if (hasExistingRecord) {
        return prev;
      }

      const nextId = prev.length > 0 ? Math.max(...prev.map((record) => record.id)) + 1 : 1;
      return [
        ...prev,
        {
          id: nextId,
          productSearch: selectedLabel,
          productCode: selectedProduct.code || '',
          category: selectedProduct.category || '',
          type: selectedProduct.type || '',
          subtype: selectedProduct.subtype || '',
          productName: selectedProduct.name || '',
          requestedAmount: '',
          unit: selectedProduct.unit || '',
          pricePerUnit: selectedProduct.costPrice?.toString() || '0',
          requestingDept: '',
          approvedQuota: '',
          budgetYear: getCurrentBudgetYear().toString(),
          sequenceNo: '1',
        },
      ];
    });
  };

  // Save bulk surveys
  const saveBulkSurveys = async () => {
    try {
      const nextValidationErrors: Record<number, { requestedAmount?: string; requestingDept?: string }> = {};

      const validRecords = bulkRecords.filter((record) => {
        const hasProduct = record.productCode.trim() !== '' && record.productName.trim() !== '';

        if (!hasProduct) {
          return false;
        }

        const requestedAmount = record.requestedAmount.trim();
        const requestingDept = record.requestingDept.trim();
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

      if (validRecords.length === 0) {
        setToast({
          message: bulkRecords.some((record) => record.productCode.trim() !== '' && record.productName.trim() !== '')
            ? 'กรุณากรอกจำนวนที่ขอและหน่วยงานที่ขอให้ครบถ้วน'
            : 'กรุณากรอกข้อมูลให้ครบถ้วนอย่างน้อย 1 รายการ',
          type: 'error',
          visible: true
        });
        hideToastLater();
        return;
      }

      const promises = validRecords.map(record =>
        fetch('/api/usage-plans', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            productCode: record.productCode.trim(),
            category: record.category || '',
            type: record.type || '',
            subtype: record.subtype || '',
            productName: record.productName.trim(),
            requestedAmount: record.requestedAmount ? parseFloat(record.requestedAmount) : 0,
            unit: record.unit || '',
            pricePerUnit: record.pricePerUnit ? parseFloat(record.pricePerUnit) : 0,
            requestingDept: record.requestingDept || '',
            approvedQuota: record.approvedQuota ? parseFloat(record.approvedQuota) : 0,
            budgetYear: record.budgetYear ? parseInt(record.budgetYear, 10) : null,
          })
        })
      );

      const results = await Promise.allSettled(promises);
      const successful = results.filter(result => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;
      const firstFailedResponse = results.find(
        (result): result is PromiseFulfilledResult<Response> => result.status === 'fulfilled' && !result.value.ok
      )?.value;
      let failedMessage = 'เกิดข้อผิดพลาดในการบันทึกข้อมูลทั้งหมด';

      if (firstFailedResponse) {
        try {
          const errorData = await firstFailedResponse.json();
          failedMessage = errorData?.error || failedMessage;
        } catch {
          failedMessage = 'เกิดข้อผิดพลาดในการบันทึกข้อมูลทั้งหมด';
        }
      }

      if (successful > 0) {
        setShowBulkForm(false);
        setBulkRecords([]);
        setBulkValidationErrors({});
        resetToNewestFirst();
        await fetchSurveys();
        await fetchSummarySurveys();

        setToast({
          message: `บันทึกสำเร็จ ${successful} รายการ${failed > 0 ? `, ไม่สำเร็จ ${failed} รายการ` : ''}`,
          type: 'success',
          visible: true
        });

        hideToastLater();
      }

      if (failed > 0 && successful === 0) {
        setToast({
          message: failedMessage,
          type: 'error',
          visible: true
        });

        hideToastLater();
      }
    } catch (error) {
      console.error('Error saving bulk surveys:', error);

      setToast({
        message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
        type: 'error',
        visible: true
      });

      hideToastLater();
    }
  };
  const getSortIcon = (field: string) => {
    if (sortField !== field) {
      return <ArrowUpDown className="inline-block ml-1 h-4 w-4 text-gray-400" />;
    }
    return sortOrder === 'asc' ? (
      <ChevronUp className="inline-block ml-1 h-4 w-4" />
    ) : (
      <ChevronDown className="inline-block ml-1 h-4 w-4" />
    );
  };

  const getHeaderClass = (field: string) => {
    return `px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${
      sortField === field ? 'bg-gray-100' : ''
    }`;
  };

  const clearFilters = () => {
    setProductNameFilter('');
    setCategoryFilter('');
    setTypeFilter('');
    setSubtypeFilter('');
    setRequestingDeptFilter('');
    setBudgetYearFilter(getCurrentBudgetYear().toString());
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="container mx-auto px-4 py-8">
        {/* Toast Notification */}
        {toast.visible && (
          <div className={`fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transition-all duration-300 ${
            toast.type === 'success'
              ? 'bg-green-500 text-white'
              : 'bg-red-500 text-white'
          }`}>
            <div className="flex items-center gap-2">
              {toast.type === 'success' ? (
                <CheckCircle2 className="h-5 w-5" />
              ) : (
                <AlertCircle className="h-5 w-5" />
              )}
              <span>{toast.message}</span>
              <button
                onClick={() => setToast({ ...toast, visible: false })}
                className="ml-2 hover:opacity-75"
              >
                <XIcon className="h-4 w-4" />
              </button>
            </div>
          </div>
        )}

        {/* Header */}
        <div className="flex items-center justify-between gap-4 mb-4">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">ข้อมูลความต้องการ</h1>

          </div>
          <div className="flex items-center gap-3">
            <input
              id="surveys-import-file"
              name="surveysImportFile"
              ref={fileInputRef}
              type="file"
              accept=".xlsx,.xls,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel"
              onChange={handleFileChange}
              className="hidden"
            />
            <button
              type="button"
              onClick={handleImportClick}
              disabled={importing}
              className={`flex items-center gap-2 rounded-lg bg-green-600 px-5 py-2.5 text-sm font-medium text-white shadow-sm transition-colors hover:bg-green-700 ${importing ? 'opacity-70 cursor-not-allowed' : ''}`}
            >
              <Upload className="h-5 w-5" />
              <span>{importing ? 'กำลังนำเข้า...' : 'นำเข้า Excel'}</span>
            </button>
            <button
              type="button"
              onClick={() => {
                setShowBulkForm(true);
                setBulkRecords([]);
              }}
              className="inline-flex items-center gap-2 rounded-lg bg-blue-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm transition-colors hover:bg-blue-700"
              title="เพิ่มความต้องการใหม่"
            >
              <Plus className="h-5 w-5" />
              <span>เพิ่มรายการ</span>
            </button>
          </div>
        </div>
        {/* Filter Section */}
        <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
          <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
            <div className="grid grid-cols-1 md:grid-cols-6 gap-4 mb-4">
            <div>
              <select
                id="surveys-filter-budget-year"
                name="budgetYearFilter"
                value={budgetYearFilter}
                onChange={(e) => setBudgetYearFilter(e.target.value)}
                className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2"
              >
                <option value="">ปีงบ</option>
                {availableBudgetYears.map((year) => (
                  <option key={year} value={year.toString()}>{year}</option>
                ))}
              </select>
            </div>

            <div>
              <select
                id="surveys-filter-requesting-dept"
                name="requestingDeptFilter"
                value={requestingDeptFilter}
                onChange={(e) => setRequestingDeptFilter(e.target.value)}
                className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2"
              >
                <option value="">หน่วยงานที่ขอ</option>
                {departments.map((dept) => (
                  <option key={dept} value={dept}>{dept}</option>
                ))}
              </select>
            </div>

            <div>
              <input
                id="surveys-filter-product-name"
                name="productNameFilter"
                type="text"
                value={productNameFilter}
                onChange={(e) => setProductNameFilter(e.target.value)}
                className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2"
                placeholder="ชื่อสินค้า"
              />
            </div>
            
            <div>
              <select
                id="surveys-filter-category"
                name="categoryFilter"
                value={categoryFilter}
                onChange={(e) => {
                  setCategoryFilter(e.target.value);
                  setTypeFilter('');
                  setSubtypeFilter('');
                }}
                className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2"
              >
                <option value="">หมวด</option>
                {categories.map((cat) => (
                  <option key={cat} value={cat}>{cat}</option>
                ))}
              </select>
            </div>
            
            <div>
              <select
                id="surveys-filter-type"
                name="typeFilter"
                value={typeFilter}
                onChange={(e) => {
                  setTypeFilter(e.target.value);
                  setSubtypeFilter('');
                }}
                className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2"
              >
                <option value="">ประเภท</option>
                {availableTypes.map((type) => (
                  <option key={type} value={type}>{type}</option>
                ))}
              </select>
            </div>
            
            <div>
              <select
                id="surveys-filter-subtype"
                name="subtypeFilter"
                value={subtypeFilter}
                onChange={(e) => setSubtypeFilter(e.target.value)}
                className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2"
              >
                <option value="">ประเภทย่อย</option>
                {availableSubtypes.map((subtype) => (
                  <option key={subtype} value={subtype}>{subtype}</option>
                ))}
              </select>
            </div>
            </div>
          </div>
        </div>

        {/* Summary Section (based on filtered dataset, not pagination) */}
        <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
          <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
            <div className="flex justify-between items-center">
              <h3 className="text-lg font-medium text-gray-900">สรุปข้อมูล</h3>
              <div className="flex flex-wrap items-center gap-6">
                <div className="text-sm">
                  <span className="text-gray-500">มูลค่ารวมที่ขอ: </span>
                  <span className="font-semibold text-gray-900">
                    ฿{summarySurveys.reduce((sum, s) => sum + ((s.requestedAmount || 0) * (s.pricePerUnit || 0)), 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </span>
                </div>
                <div className="text-sm">
                  <span className="text-gray-500">มูลค่ารวมที่อนุมัติ: </span>
                  <span className="font-semibold text-gray-900">
                    ฿{summarySurveys.reduce((sum, s) => sum + ((s.approvedQuota || 0) * (s.pricePerUnit || 0)), 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
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
              <label htmlFor="surveys-page-size" className="text-sm text-gray-600">แสดงต่อหน้า</label>
              <select
                id="surveys-page-size"
                name="pageSize"
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
                type="button"
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
                type="button"
                onClick={() => goToPage(page + 1)}
                disabled={page >= totalPages}
                className={`px-3 py-1 rounded border text-sm ${page >= totalPages ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-100'}`}
              >
                ถัดไป
              </button>
            </div>
          </div>
        </div>

        {/* Table */}
        <div className="bg-white rounded-lg shadow-md overflow-hidden">
          {loading ? (
            <div className="flex justify-center items-center py-12">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
            </div>
          ) : surveys.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-gray-500">ไม่พบข้อมูล</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th onClick={() => handleSort('budgetYear')} className={getHeaderClass('budgetYear')}>
                      ปีงบ {getSortIcon('budgetYear')}
                    </th>
                    <th onClick={() => handleSort('sequenceNo')} className={getHeaderClass('sequenceNo')}>
                      ครั้งที่ {getSortIcon('sequenceNo')}
                    </th>
                    <th onClick={() => handleSort('productCode')} className={getHeaderClass('productCode') + ' w-24'}>
                      รหัสสินค้า {getSortIcon('productCode')}
                    </th>
                    <th onClick={() => handleSort('productName')} className={getHeaderClass('productName')}>
                      ชื่อสินค้า {getSortIcon('productName')}
                    </th>
                    <th onClick={() => handleSort('category')} className={getHeaderClass('category')}>
                      หมวดสินค้า {getSortIcon('category')}
                    </th>
                    <th onClick={() => handleSort('type')} className={getHeaderClass('type')}>
                      ประเภท {getSortIcon('type')}
                    </th>
                    <th onClick={() => handleSort('requestedAmount')} className={getHeaderClass('requestedAmount')}>
                      จำนวนที่ขอ {getSortIcon('requestedAmount')}
                    </th>
                    <th onClick={() => handleSort('pricePerUnit')} className={getHeaderClass('pricePerUnit')}>
                      ราคาต่อหน่วย {getSortIcon('pricePerUnit')}
                    </th>
                    <th onClick={() => handleSort('requestingDept')} className={getHeaderClass('requestingDept')}>
                      หน่วยงานที่ขอ {getSortIcon('requestingDept')}
                    </th>
                    <th onClick={() => handleSort('approvedQuota')} className={getHeaderClass('approvedQuota')}>
                      จำนวนที่อนุมัติ {getSortIcon('approvedQuota')}
                    </th>
                    <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-24">
                      Action
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {surveys.map((survey) => (
                    <tr key={survey.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                        {survey.budgetYear || '-'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                        {survey.sequenceNo || '-'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                        {survey.productCode}
                      </td>
                      <td className="px-6 py-4 text-xs text-gray-900 break-words max-w-xs">
                        {survey.productName}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                        {survey.category}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                        {survey.type}
                      </td>
                      <td className={`px-6 py-4 whitespace-nowrap text-xs text-gray-900 ${editingId !== survey.id || editingField === 'requestedAmount' ? inlineEditableCellClassName : ''}`}>
                        {editingId === survey.id && editingField === 'requestedAmount' ? (
                          <div className="flex items-center gap-2">
                            <input
                              id={`survey-inline-requested-amount-${survey.id}`}
                              name={`inlineRequestedAmount-${survey.id}`}
                              aria-label={`จำนวนที่ขอ รายการ ${survey.id}`}
                              type="number"
                              min="0"
                              value={editData.requestedAmount}
                              onChange={(e) => updateInlineField('requestedAmount', e.target.value)}
                              onBlur={(e) => handleInlineEditorBlur(e, survey.id)}
                              autoFocus
                              className="w-24 rounded border border-gray-300 px-2 py-1 text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                            />
                            <span className="text-[10px] text-gray-500">{survey.unit || ''}</span>
                          </div>
                        ) : (
                          <button
                            type="button"
                            onClick={() => startInlineEdit(survey, 'requestedAmount')}
                            className="w-full text-left cursor-text"
                          >
                            {survey.requestedAmount?.toLocaleString() || ''} {survey.unit}
                          </button>
                        )}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                        <>฿{survey.pricePerUnit?.toLocaleString() || '0'}</>
                      </td>
                      <td
                        ref={editingId === survey.id && editingField === 'requestingDept' ? inlineEditContainerRef : null}
                        className={`px-6 py-4 whitespace-nowrap text-xs text-gray-900 ${editingId !== survey.id || editingField === 'requestingDept' ? inlineEditableCellClassName : ''}`}
                      >
                        {editingId === survey.id && editingField === 'requestingDept' ? (
                          <select
                            id={`survey-inline-requesting-dept-${survey.id}`}
                            name={`inlineRequestingDept-${survey.id}`}
                            aria-label={`หน่วยงานที่ขอ รายการ ${survey.id}`}
                            value={editData.requestingDept}
                            onChange={(e) => setEditData((prev) => ({ ...prev, requestingDept: e.target.value }))}
                            onBlur={(e) => handleInlineEditorBlur(e, survey.id)}
                            autoFocus
                            className="w-40 rounded border border-gray-300 px-2 py-1 text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                          >
                            <option value="">เลือกหน่วยงาน</option>
                            {departments.map((dept) => (
                              <option key={dept} value={dept}>{dept}</option>
                            ))}
                          </select>
                        ) : (
                          <button
                            type="button"
                            onClick={() => startInlineEdit(survey, 'requestingDept')}
                            className="w-full text-left cursor-text"
                          >
                            {survey.requestingDept || '-'}
                          </button>
                        )}
                      </td>
                      <td className={`px-6 py-4 whitespace-nowrap text-xs text-gray-900 ${editingId !== survey.id || editingField === 'approvedQuota' ? inlineEditableCellClassName : ''}`}>
                        {editingId === survey.id && editingField === 'approvedQuota' ? (
                          <input
                            id={`survey-inline-approved-quota-${survey.id}`}
                            name={`inlineApprovedQuota-${survey.id}`}
                            aria-label={`จำนวนที่อนุมัติ รายการ ${survey.id}`}
                            type="number"
                            min="0"
                            value={editData.approvedQuota}
                            onChange={(e) => updateInlineField('approvedQuota', e.target.value)}
                            onBlur={(e) => handleInlineEditorBlur(e, survey.id)}
                            autoFocus
                            className="w-24 rounded border border-gray-300 px-2 py-1 text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        ) : (
                          <button
                            type="button"
                            onClick={() => startInlineEdit(survey, 'approvedQuota')}
                            className="w-full text-left cursor-text"
                          >
                            {survey.approvedQuota?.toLocaleString() || '-'}
                          </button>
                        )}
                      </td>
                      <td className="px-3 py-4 whitespace-nowrap text-xs font-medium w-24">
                        <div className="flex items-center gap-2">
                          {editingId === survey.id ? (
                            <>
                              <button
                                type="button"
                                onClick={() => void saveInlineEdit(survey.id)}
                                className="text-green-600 hover:text-green-800 cursor-pointer"
                                title="บันทึก"
                              >
                                <CheckCircle2 className="h-5 w-5" />
                              </button>
                              <button
                                type="button"
                                onClick={cancelInlineEdit}
                                className="text-gray-500 hover:text-gray-700 cursor-pointer"
                                title="ยกเลิก"
                              >
                                <XIcon className="h-5 w-5" />
                              </button>
                            </>
                          ) : (
                            <>
                              <button
                                type="button"
                                onClick={() => startInlineEdit(survey, 'requestedAmount')}
                                className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                                title="แก้ไข"
                              >
                                <Pencil className="h-5 w-5" />
                              </button>
                              <button
                                type="button"
                                onClick={() => handleDelete(survey)}
                                className="text-red-600 hover:text-red-900 cursor-pointer"
                                title="ลบ"
                              >
                                <Trash2 className="h-5 w-5" />
                              </button>
                            </>
                          )}
                        </div>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>

        {/* Form Modal */}
        {showForm && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-100/80 p-4 backdrop-blur-sm">
            <div className="w-full max-w-4xl max-h-[90vh] overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-[0_24px_80px_rgba(15,23,42,0.18)] ring-1 ring-slate-200">
              <div className="border-b border-slate-200 bg-gradient-to-r from-blue-50 via-white to-slate-50 px-6 py-5">
                <h2 className="text-xl font-semibold text-gray-800">
                  {editingSurvey ? 'แก้ไขข้อมูลความต้องการ' : 'เพิ่มข้อมูลความต้องการ'}
                </h2>
                <p className="mt-1 text-sm text-slate-500">เลือกสินค้าและกรอกรายละเอียดที่จำเป็นให้ครบถ้วนก่อนบันทึก</p>
              </div>
              
              <form onSubmit={handleSubmit} className="overflow-y-auto px-6 py-6 space-y-6">
                <div className="rounded-2xl border border-blue-100 bg-blue-50 p-4">
                  <label htmlFor="survey-product-search" className="mb-2 block text-sm font-medium text-gray-700">
                    ค้นหารหัสหรือชื่อสินค้า
                  </label>
                  <div className="relative">
                    <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
                    <input
                      id="survey-product-search"
                      name="productSearch"
                      type="text"
                      value={productSearch}
                      onChange={(e) => handleProductSelect(e.target.value)}
                      onFocus={() => {
                        if (!editingSurvey && productSearch.trim() && productSearch.trim() !== selectedProductLabel.trim()) {
                          setShowProductSuggestions(true);
                        }
                      }}
                      onKeyDown={handleProductSearchKeyDown}
                      readOnly={Boolean(editingSurvey)}
                      autoComplete="off"
                      aria-label="ค้นหารหัสหรือชื่อสินค้า"
                      placeholder="พิมพ์รหัสสินค้า หรือชื่อสินค้า"
                      className={`w-full rounded-md border px-3 py-2 pl-9 pr-9 focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.productCode ? 'border-red-500' : 'border-gray-300'} ${editingSurvey ? 'bg-gray-50' : 'bg-white'}`}
                    />
                    {productSearch && !editingSurvey && (
                      <button
                        type="button"
                        onClick={() => handleProductSelect('')}
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                        aria-label="ล้างคำค้น"
                      >
                        <X className="h-4 w-4" />
                      </button>
                    )}
                    {showProductSuggestions && !editingSurvey && (
                      <div className="absolute z-10 mt-2 max-h-72 w-full overflow-auto rounded-md border border-gray-200 bg-white shadow-lg">
                        {shouldShowProductNoResults ? (
                          <div className="px-4 py-3 text-sm text-gray-500">ไม่พบรายการที่ค้นหา</div>
                        ) : (
                          filteredProductOptions.map((product, index) => {
                            const label = `${product.code} - ${product.name}`;
                            return (
                              <button
                                key={product.id}
                                type="button"
                                onMouseDown={(event) => event.preventDefault()}
                                onClick={() => handleProductSelect(label)}
                                className={`block w-full border-b border-gray-100 px-4 py-3 text-left text-sm ${index === highlightedProductIndex ? 'bg-blue-50' : 'hover:bg-gray-50'}`}
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
                  {errors.productCode && <p className="mt-2 text-sm text-red-600">{errors.productCode}</p>}
                </div>

                {(editingSurvey || formData.productName) && (
                  <div className="rounded-2xl border border-slate-200 bg-white shadow-sm">
                    <div className="border-b border-slate-200 px-4 py-3">
                      <h3 className="text-sm font-semibold text-slate-700">รายการที่เลือก</h3>
                      <p className="mt-1 text-xs text-slate-500">เลือกสินค้าแล้วค่อยกรอกจำนวน หน่วยงาน และข้อมูลประกอบในแถวรายการนี้</p>
                    </div>
                    <div className="overflow-x-auto">
                      <table className="min-w-full">
                        <thead className="bg-slate-50">
                          <tr className="text-left text-xs font-medium uppercase tracking-wide text-slate-500">
                            <th scope="col" className="px-4 py-3">รหัสสินค้า</th>
                            <th scope="col" className="px-4 py-3">ชื่อสินค้า</th>
                            <th scope="col" className="px-4 py-3">จำนวนที่ขอ</th>
                            <th scope="col" className="px-4 py-3">หน่วย</th>
                            <th scope="col" className="px-4 py-3">ราคาต่อหน่วย</th>
                            <th scope="col" className="px-4 py-3">หน่วยงานที่ขอ</th>
                            <th scope="col" className="px-4 py-3">จำนวนอนุมัติ</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr className="border-t border-slate-200 align-top">
                            <td className="px-4 py-3">
                              <input id="survey-product-code" type="text" name="productCode" aria-label="รหัสสินค้า" value={formData.productCode} readOnly className="w-full rounded-md border border-gray-300 bg-gray-50 px-3 py-2 text-sm focus:outline-none" />
                            </td>
                            <td className="px-4 py-3 min-w-[240px]">
                              <input id="survey-product-name" type="text" name="productName" aria-label="ชื่อสินค้า" value={formData.productName} readOnly className={`w-full rounded-md border px-3 py-2 text-sm focus:outline-none ${errors.productName ? 'border-red-500' : 'border-gray-300 bg-gray-50'}`} />
                              {errors.productName && <p className="mt-1 text-sm text-red-600">{errors.productName}</p>}
                            </td>
                            <td className="px-4 py-3 min-w-[140px]">
                              <input id="survey-requested-amount" type="number" name="requestedAmount" aria-label="จำนวนที่ขอ" value={formData.requestedAmount} onChange={handleInputChange} min="0" className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="จำนวน" />
                            </td>
                            <td className="px-4 py-3 min-w-[120px]">
                              <input id="survey-unit" type="text" name="unit" aria-label="หน่วย" value={formData.unit} readOnly className="w-full rounded-md border border-gray-300 bg-gray-50 px-3 py-2 text-sm focus:outline-none" />
                            </td>
                            <td className="px-4 py-3 min-w-[150px]">
                              <input id="survey-price-per-unit" type="number" name="pricePerUnit" aria-label="ราคาต่อหน่วย" value={formData.pricePerUnit} onChange={handleInputChange} min="0" step="0.01" className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="ราคาต่อหน่วย" />
                            </td>
                            <td className="px-4 py-3 min-w-[220px]">
                              <select id="survey-requesting-dept" name="requestingDept" aria-label="หน่วยงานที่ขอ" value={formData.requestingDept} onChange={handleInputChange} className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                                <option value="">เลือกหน่วยงานที่ขอ</option>
                                {departments.map((dept) => (
                                  <option key={dept} value={dept}>{dept}</option>
                                ))}
                              </select>
                            </td>
                            <td className="px-4 py-3 min-w-[140px]">
                              <input id="survey-approved-quota" type="number" name="approvedQuota" aria-label="จำนวนที่อนุมัติ" value={formData.approvedQuota} onChange={handleInputChange} min="0" className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" placeholder="จำนวนอนุมัติ" />
                            </td>
                          </tr>
                        </tbody>
                      </table>
                    </div>

                    <div className="grid grid-cols-1 gap-4 border-t border-slate-200 px-4 py-4 md:grid-cols-3">
                      <div>
                        <label htmlFor="survey-category" className="mb-2 block text-sm font-medium text-gray-700">หมวดสินค้า</label>
                        <input id="survey-category" type="text" name="category" value={formData.category} readOnly className="w-full rounded-md border border-gray-300 bg-gray-50 px-3 py-2 text-sm focus:outline-none" />
                      </div>
                      <div>
                        <label htmlFor="survey-type" className="mb-2 block text-sm font-medium text-gray-700">ประเภท</label>
                        <input id="survey-type" type="text" name="type" value={formData.type} readOnly className="w-full rounded-md border border-gray-300 bg-gray-50 px-3 py-2 text-sm focus:outline-none" />
                      </div>
                      <div>
                        <label htmlFor="survey-subtype" className="mb-2 block text-sm font-medium text-gray-700">ประเภทย่อย</label>
                        <input id="survey-subtype" type="text" name="subtype" value={formData.subtype} readOnly className="w-full rounded-md border border-gray-300 bg-gray-50 px-3 py-2 text-sm focus:outline-none" />
                      </div>
                      <div>
                        <label htmlFor="survey-budget-year" className="mb-2 block text-sm font-medium text-gray-700">ปีงบ</label>
                        <select id="survey-budget-year" name="budgetYear" value={formData.budgetYear} onChange={handleInputChange} className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                          {availableBudgetYears.map((year) => (
                            <option key={year} value={year.toString()}>{year}</option>
                          ))}
                        </select>
                      </div>
                      <div>
                        <label htmlFor="survey-sequence-no" className="mb-2 block text-sm font-medium text-gray-700">ครั้งที่</label>
                        <select id="survey-sequence-no" name="sequenceNo" value={formData.sequenceNo} onChange={handleInputChange} className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
                          <option value="1">ครั้งที่ 1</option>
                          <option value="2">ครั้งที่ 2</option>
                        </select>
                      </div>
                    </div>
                  </div>
                )}
                
                <div className="mt-8 flex justify-end gap-3 border-t border-slate-200 pt-5">
                  <button
                    type="button"
                    onClick={closeForm}
                    className="rounded-lg border border-slate-300 px-4 py-2 text-slate-700 transition-colors hover:bg-slate-50"
                  >
                    ยกเลิก
                  </button>
                  <button
                    type="submit"
                    className="rounded-lg bg-blue-600 px-4 py-2 text-white shadow-sm transition-colors hover:bg-blue-700"
                  >
                    {editingSurvey ? 'บันทึกการแก้ไข' : 'บันทึกข้อมูล'}
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* Bulk Add Surveys Modal */}
        {showBulkForm && (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-100/80 p-2 backdrop-blur-sm md:p-4">
            <div className="flex h-[96vh] w-[98vw] flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-[0_24px_80px_rgba(15,23,42,0.18)] ring-1 ring-slate-200">
              <div className="flex items-center justify-between border-b border-slate-200 bg-gradient-to-r from-blue-50 via-white to-slate-50 px-5 py-3">
                <div>
                  <h2 className="text-lg font-bold text-slate-900">เพิ่มรายการสินค้าเข้าแผนการใช้</h2>
                </div>
                <button
                  type="button"
                  onClick={() => {
                    setShowBulkForm(false);
                    setBulkRecords([]);
                  }}
                  className="rounded-full p-1.5 text-slate-500 transition-colors hover:bg-white hover:text-slate-700"
                >
                  <XIcon className="h-5 w-5" />
                </button>
              </div>

              <div className="flex min-h-0 flex-1 flex-col px-6 py-6">
                <div className="relative z-20 mb-4 rounded-2xl border border-blue-100 bg-blue-50 p-4">
                  <label htmlFor="survey-bulk-product-search" className="mb-2 block text-sm font-medium text-gray-700">
                    ค้นหารหัสหรือชื่อสินค้า
                  </label>
                  <div className="relative">
                    <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-gray-400" />
                    <input
                      ref={bulkProductSearchInputRef}
                      id="survey-bulk-product-search"
                      name="surveyBulkProductSearch"
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
                    <table className="w-full">
                      <thead className="bg-slate-100">
                        <tr>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ลำดับ</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">รหัสสินค้า</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ชื่อสินค้า</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จำนวนที่ขอ</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หน่วย</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หน่วยงานที่ขอ</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จำนวนที่อนุมัติ</th>
                          <th scope="col" className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จัดการ</th>
                        </tr>
                      </thead>
                      <tbody>
                        {bulkRecords.map((record, index) => (
                          <tr key={record.id} className="border-b border-slate-200 bg-white">
                            <td className="w-12 px-2 py-3 text-sm text-gray-900">{index + 1}</td>
                            <td className="w-36 px-2 py-3">
                              <input
                                id={`survey-bulk-product-code-${record.id}`}
                                name={`bulkProductCode-${record.id}`}
                                aria-label={`รหัสสินค้า แถว ${index + 1}`}
                                type="text"
                                value={record.productCode}
                                readOnly
                                placeholder="รหัสสินค้า"
                                className="w-full px-2 py-1 border border-gray-300 rounded bg-gray-100 text-sm"
                              />
                            </td>
                            <td className="min-w-[24rem] px-2 py-3">
                              <input
                                id={`survey-bulk-product-name-${record.id}`}
                                name={`bulkProductName-${record.id}`}
                                aria-label={`ชื่อสินค้า แถว ${index + 1}`}
                                type="text"
                                value={record.productName}
                                readOnly
                                placeholder="ชื่อสินค้า"
                                title={record.productName || ''}
                                className="w-full px-2 py-1 border border-gray-300 rounded bg-gray-100 text-sm"
                              />
                            </td>
                            <td className="w-32 px-2 py-3">
                              <input
                                id={`survey-bulk-requested-amount-${record.id}`}
                                name={`bulkRequestedAmount-${record.id}`}
                                aria-label={`จำนวนที่ขอ แถว ${index + 1}`}
                                type="number"
                                required
                                min="1"
                                value={record.requestedAmount || ''}
                                onChange={(e) => {
                                  updateBulkRecord(record.id, (current) => ({ ...current, requestedAmount: e.target.value }));
                                  clearBulkValidationError(record.id, 'requestedAmount');
                                }}
                                placeholder="จำนวนที่ขอ"
                                className={`w-full px-2 py-1 border rounded focus:outline-none focus:ring-2 text-sm ${bulkValidationErrors[record.id]?.requestedAmount ? 'border-red-500 focus:ring-red-500' : 'border-gray-300 focus:ring-blue-500'}`}
                              />
                              {bulkValidationErrors[record.id]?.requestedAmount && (
                                <p className="mt-1 text-xs text-red-600">{bulkValidationErrors[record.id]?.requestedAmount}</p>
                              )}
                            </td>
                            <td className="w-24 px-2 py-3">
                              <input
                                id={`survey-bulk-unit-${record.id}`}
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
                              <select
                                id={`survey-bulk-requesting-dept-${record.id}`}
                                name={`bulkRequestingDept-${record.id}`}
                                aria-label={`หน่วยงานที่ขอ แถว ${index + 1}`}
                                required
                                value={record.requestingDept || ''}
                                onChange={(e) => {
                                  updateBulkRecord(record.id, (current) => ({ ...current, requestingDept: e.target.value }));
                                  clearBulkValidationError(record.id, 'requestingDept');
                                }}
                                className={`w-full px-2 py-1 border rounded focus:outline-none focus:ring-2 text-sm ${bulkValidationErrors[record.id]?.requestingDept ? 'border-red-500 focus:ring-red-500' : 'border-gray-300 focus:ring-blue-500'}`}
                              >
                                <option value="">เลือกหน่วยงาน</option>
                                {departments.map((dept) => (
                                  <option key={dept} value={dept}>{dept}</option>
                                ))}
                              </select>
                              {bulkValidationErrors[record.id]?.requestingDept && (
                                <p className="mt-1 text-xs text-red-600">{bulkValidationErrors[record.id]?.requestingDept}</p>
                              )}
                            </td>
                            <td className="w-32 px-2 py-3">
                              <input
                                id={`survey-bulk-approved-quota-${record.id}`}
                                name={`bulkApprovedQuota-${record.id}`}
                                aria-label={`จำนวนที่อนุมัติ แถว ${index + 1}`}
                                type="number"
                                value={record.approvedQuota || ''}
                                onChange={(e) => {
                                  updateBulkRecord(record.id, (current) => ({ ...current, approvedQuota: e.target.value }));
                                }}
                                placeholder="จำนวนอนุมัติ"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
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
                                    <XIcon className="h-4 w-4" />
                                  </button>
                                )}
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>

              <div className="flex items-center justify-end gap-3 border-t border-slate-200 bg-slate-50 px-6 py-5">
                <button
                  type="button"
                  onClick={() => {
                    setShowBulkForm(false);
                    setBulkRecords([]);
                    setBulkValidationErrors({});
                  }}
                  className="rounded-lg bg-slate-500 px-6 py-2.5 text-white transition-colors hover:bg-slate-600"
                >
                  ยกเลิก
                </button>
                <button
                  type="button"
                  onClick={saveBulkSurveys}
                  className="rounded-lg bg-blue-600 px-6 py-2.5 text-white shadow-sm transition-colors hover:bg-blue-700"
                >
                  บันทึกทั้งหมด ({bulkRecords.length} รายการ)
                </button>
              </div>
            </div>
          </div>
        )}

      </div>
    </div>
  );
}

export default function SurveysPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-gray-50" />}>
      <SurveysPageContent />
    </Suspense>
  );
}
