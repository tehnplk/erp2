'use client';

import { Suspense, useEffect, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { Pencil, Trash2, X } from 'lucide-react';

const getCurrentBudgetYear = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

interface SurveyOption {
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
}

interface ProductOption {
  code: string;
  costPrice?: number | null;
}

interface PurchasePlanFormData {
  productCode?: string;
  category?: string;
  productName?: string;
  productType?: string;
  productSubtype?: string;
  unit?: string;
  pricePerUnit?: number;
  budgetYear?: string;
  planId?: number | null;
  inPlan?: string;
  carriedForwardQuantity?: number | null;
  carriedForwardValue?: number;
  requiredQuantityForYear?: number | null;
  totalRequiredValue?: number;
  additionalPurchaseQty?: number | null;
  additionalPurchaseValue?: number;
  purchasingDepartment?: string;
}

function PurchasePlansPageContent() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [items, setItems] = useState<any[]>([]);
  const [summaryItems, setSummaryItems] = useState<any[]>([]);
  const [surveyOptions, setSurveyOptions] = useState<SurveyOption[]>([]);
  const [productCostMap, setProductCostMap] = useState<Record<string, number>>({});
  const [surveysLoading, setSurveysLoading] = useState(false);
  const [surveySearchTerm, setSurveySearchTerm] = useState('');
  const [showSurveySuggestions, setShowSurveySuggestions] = useState(false);
  const [highlightedSurveyIndex, setHighlightedSurveyIndex] = useState(-1);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [filtersLoading, setFiltersLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState<any | null>(null);
  const [formData, setFormData] = useState<PurchasePlanFormData>({});

  // filters
  const [productNameFilter, setProductNameFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('');
  const [subtypeFilter, setSubtypeFilter] = useState('');
  const [requestingDeptFilter, setRequestingDeptFilter] = useState('');
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
  const [departments, setDepartments] = useState<string[]>([]);
  const [years, setYears] = useState<string[]>([]);
  const availableBudgetYears = Array.from(new Set([
    ...years,
    ...Array.from({ length: 6 }, (_, index) => String(getCurrentBudgetYear() - index)),
  ])).sort((a, b) => Number(b) - Number(a));

  useEffect(() => {
    fetchFilters();
    fetchData();
    fetchSummaryData();
    fetchSurveyOptions();
    fetchProductCosts();
  }, []);

  useEffect(() => {
    fetchData();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder, page, pageSize]);

  // When filters or sorting change, reset to first page and refresh summary data
  useEffect(() => {
    setPage(1);
    fetchSummaryData();
  }, [productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder]);

  useEffect(() => {
    const nextProductName = searchParams.get('productName') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('type') || '';
    const nextSubtype = searchParams.get('productSubtype') || '';
    const nextRequestingDept = searchParams.get('requestingDept') || '';
    const nextBudgetYear = searchParams.get('budgetYear') || '';
    const nextSortBy = searchParams.get('orderBy') || 'id';
    const nextSortOrder = (searchParams.get('sortOrder') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
    const nextPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const nextPageSize = Math.max(1, parseInt(searchParams.get('pageSize') || '20', 10) || 20);

    setProductNameFilter((prev) => prev === nextProductName ? prev : nextProductName);
    setCategoryFilter((prev) => prev === nextCategory ? prev : nextCategory);
    setTypeFilter((prev) => prev === nextType ? prev : nextType);
    setSubtypeFilter((prev) => prev === nextSubtype ? prev : nextSubtype);
    setRequestingDeptFilter((prev) => prev === nextRequestingDept ? prev : nextRequestingDept);
    setBudgetYearFilter((prev) => prev === nextBudgetYear ? prev : nextBudgetYear);
    setSortBy((prev) => prev === nextSortBy ? prev : nextSortBy);
    setSortOrder((prev) => prev === nextSortOrder ? prev : nextSortOrder);
    setPage((prev) => prev === nextPage ? prev : nextPage);
    setPageSize((prev) => prev === nextPageSize ? prev : nextPageSize);
  }, [searchParams]);

  useEffect(() => {
    const params = new URLSearchParams();

    if (productNameFilter) params.set('productName', productNameFilter);
    if (categoryFilter) params.set('category', categoryFilter);
    if (typeFilter) params.set('type', typeFilter);
    if (subtypeFilter) params.set('productSubtype', subtypeFilter);
    if (requestingDeptFilter) params.set('requestingDept', requestingDeptFilter);
    if (budgetYearFilter) params.set('budgetYear', budgetYearFilter);
    if (sortBy && sortBy !== 'id') params.set('orderBy', sortBy);
    if (sortOrder !== 'desc') params.set('sortOrder', sortOrder);
    if (page > 1) params.set('page', page.toString());
    if (pageSize !== 20) params.set('pageSize', pageSize.toString());

    const nextUrl = params.toString() ? `${pathname}?${params.toString()}` : pathname;
    router.replace(nextUrl, { scroll: false });
  }, [pathname, router, productNameFilter, categoryFilter, typeFilter, subtypeFilter, requestingDeptFilter, budgetYearFilter, sortBy, sortOrder, page, pageSize]);

  const fetchFilters = async () => {
    try {
      setFiltersLoading(true);
      const res = await fetch('/api/purchase-plans/filters');
      if (res.ok) {
        const data = await res.json();
        setCategories(data.categories || []);
        setTypes(data.productTypes || []);
        setSubtypes(data.productSubtypes || []);
        setDepartments(data.departments || []);
        setYears(data.budgetYears || []);
      }
    } catch (e) {
      console.error(e);
    } finally {
      setFiltersLoading(false);
    }
  };

  const fetchProductCosts = async () => {
    try {
      const nextMap: Record<string, number> = {};
      let currentPage = 1;
      let hasMore = true;

      while (hasMore) {
        const params = new URLSearchParams();
        params.append('orderBy', 'code');
        params.append('sortOrder', 'asc');
        params.append('page', String(currentPage));
        params.append('pageSize', '200');
        const res = await fetch(`/api/products?${params.toString()}`);
        if (!res.ok) throw new Error('fetch products failed');
        const data = await res.json();
        const products = (data.data || []) as ProductOption[];

        products.forEach((product) => {
          if (product.code) {
            nextMap[product.code] = Number(product.costPrice) || 0;
          }
        });

        hasMore = products.length === 200;
        currentPage += 1;
      }

      setProductCostMap(nextMap);
    } catch (e) {
      console.error(e);
    }
  };

  const fetchSurveyOptions = async () => {
    try {
      setSurveysLoading(true);
      const params = new URLSearchParams();
      params.append('orderBy', 'id');
      params.append('sortOrder', 'desc');
      const res = await fetch(`/api/surveys?${params.toString()}`);
      if (!res.ok) throw new Error('fetch surveys failed');
      const data = await res.json();
      setSurveyOptions(data.surveys || []);
    } catch (e) {
      console.error(e);
    } finally {
      setSurveysLoading(false);
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
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (productNameFilter) params.append('productName', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (subtypeFilter) params.append('productSubtype', subtypeFilter);
      if (requestingDeptFilter) params.append('requestingDept', requestingDeptFilter);
      if (budgetYearFilter) params.append('budgetYear', budgetYearFilter);
      params.append('orderBy', sortBy);
      params.append('sortOrder', sortOrder);
      params.append('page', page.toString());
      params.append('pageSize', pageSize.toString());

      const res = await fetch(`/api/purchase-plans?${params.toString()}`);
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
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  // Fetch full filtered dataset for summary (independent of pagination)
  const fetchSummaryData = async () => {
    try {
      const params = new URLSearchParams();
      if (productNameFilter) params.append('productName', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (subtypeFilter) params.append('productSubtype', subtypeFilter);
      if (requestingDeptFilter) params.append('requestingDept', requestingDeptFilter);
      if (budgetYearFilter) params.append('budgetYear', budgetYearFilter);
      params.append('orderBy', sortBy);
      params.append('sortOrder', sortOrder);

      const res = await fetch(`/api/purchase-plans?${params.toString()}`);
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

  const getHeaderClass = (col: string) => `px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${col === sortBy ? 'bg-gray-100' : ''}`;

  const handleEdit = (row: any) => {
    setEditing(row);
    const matchedSurvey = surveyOptions.find((survey) => survey.id === row.planId);
    setFormData({
      productCode: row.productCode || '',
      category: row.category || '',
      productName: row.productName || '',
      productType: row.productType || '',
      productSubtype: row.productSubtype || '',
      unit: row.unit || '',
      pricePerUnit: row.pricePerUnit ? Number(row.pricePerUnit) : undefined,
      budgetYear: row.budgetYear || '',
      planId: row.planId ?? null,
      inPlan: row.inPlan || '',
      carriedForwardQuantity: row.carriedForwardQuantity ?? null,
      carriedForwardValue: row.carriedForwardValue ? Number(row.carriedForwardValue) : undefined,
      requiredQuantityForYear: row.requiredQuantityForYear ?? null,
      totalRequiredValue: row.totalRequiredValue ? Number(row.totalRequiredValue) : undefined,
      additionalPurchaseQty: row.additionalPurchaseQty ?? null,
      additionalPurchaseValue: row.additionalPurchaseValue ? Number(row.additionalPurchaseValue) : undefined,
      purchasingDepartment: row.purchasingDepartment || '',
    });
    setSurveySearchTerm(
      matchedSurvey
        ? `${matchedSurvey.productCode || '-'} | ${matchedSurvey.productName || '-'}`
        : ''
    );
    setShowForm(true);
  };

  const selectedSurvey = surveyOptions.find((survey) => survey.id === formData.planId);
  const isEditing = Boolean(editing);
  const purchasingDepartmentOptions = Array.from(new Set([...(formData.purchasingDepartment ? [formData.purchasingDepartment] : []), ...departments].filter(Boolean)));
  const isSurveySearchDirty = surveySearchTerm.trim() !== '' && (!selectedSurvey || surveySearchTerm !== `${selectedSurvey.productCode || '-'} | ${selectedSurvey.productName || '-'}`);
  const filteredSurveyOptions = surveyOptions.filter((survey) => {
    const search = isSurveySearchDirty ? surveySearchTerm.trim().toLowerCase() : '';
    if (!search) return true;

    const productCode = (survey.productCode || '').toLowerCase();
    const productName = (survey.productName || '').toLowerCase();

    return productCode.includes(search) || productName.includes(search);
  }).slice(0, 20);

  const derivedPricePerUnit = selectedSurvey ? Number(selectedSurvey.pricePerUnit) || 0 : 0;
  const derivedProductCostPrice = selectedSurvey?.productCode ? (productCostMap[selectedSurvey.productCode] ?? 0) : 0;
  const derivedApprovedQuota = selectedSurvey?.approvedQuota ?? 0;
  const derivedRequestedAmount = selectedSurvey?.requestedAmount ?? 0;
  const derivedCarriedForwardValue = Number((((formData.carriedForwardQuantity ?? 0) * derivedProductCostPrice)).toFixed(2));
  const derivedTotalRequiredValue = Number((derivedApprovedQuota * derivedPricePerUnit).toFixed(2));
  const derivedAdditionalPurchaseQtyRaw = derivedRequestedAmount - (formData.carriedForwardQuantity ?? 0);
  const derivedAdditionalPurchaseQty = derivedAdditionalPurchaseQtyRaw > 0 ? derivedAdditionalPurchaseQtyRaw : 0;
  const derivedAdditionalPurchaseValue = Number((derivedAdditionalPurchaseQty * derivedPricePerUnit).toFixed(2));

  useEffect(() => {
    if (!selectedSurvey) {
      return;
    }

    setFormData((prev) => ({
      ...prev,
      productCode: selectedSurvey.productCode || '',
      category: selectedSurvey.category || '',
      productName: selectedSurvey.productName || '',
      productType: selectedSurvey.type || '',
      productSubtype: selectedSurvey.subtype || '',
      unit: selectedSurvey.unit || '',
      pricePerUnit: derivedPricePerUnit,
      budgetYear: selectedSurvey.budgetYear !== null && selectedSurvey.budgetYear !== undefined ? String(selectedSurvey.budgetYear) : '',
      carriedForwardValue: derivedCarriedForwardValue,
      requiredQuantityForYear: derivedRequestedAmount,
      totalRequiredValue: derivedTotalRequiredValue,
      additionalPurchaseQty: derivedAdditionalPurchaseQty,
      additionalPurchaseValue: derivedAdditionalPurchaseValue,
      purchasingDepartment: prev.purchasingDepartment || selectedSurvey.requestingDept || '',
    }));
  }, [selectedSurvey, derivedPricePerUnit, derivedCarriedForwardValue, derivedRequestedAmount, derivedTotalRequiredValue, derivedAdditionalPurchaseQty, derivedAdditionalPurchaseValue]);

  const resetForm = () => {
    setEditing(null);
    setFormData({});
    setSurveySearchTerm('');
    setShowSurveySuggestions(false);
    setHighlightedSurveyIndex(-1);
    setShowForm(false);
  };

  const handleSurveySelect = (survey: SurveyOption) => {
    setFormData((prev) => ({
      ...prev,
      planId: survey.id,
    }));
    setSurveySearchTerm(`${survey.productCode || '-'} | ${survey.productName || '-'}`);
    setShowSurveySuggestions(false);
    setHighlightedSurveyIndex(-1);
  };

  const clearSurveySelection = () => {
    setSurveySearchTerm('');
    setShowSurveySuggestions(false);
    setHighlightedSurveyIndex(-1);
    setFormData((prev) => ({
      ...prev,
      planId: null,
      productCode: '',
      category: '',
      productName: '',
      productType: '',
      productSubtype: '',
      unit: '',
      pricePerUnit: undefined,
      budgetYear: '',
      requiredQuantityForYear: null,
      totalRequiredValue: undefined,
      additionalPurchaseQty: null,
      additionalPurchaseValue: undefined,
      purchasingDepartment: '',
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
        const survey = filteredSurveyOptions[targetIndex];
        if (survey) {
          handleSurveySelect(survey);
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
      [name]: ['pricePerUnit','carriedForwardValue','totalRequiredValue','additionalPurchaseValue'].includes(name)
        ? (value ? parseFloat(value) : undefined)
        : ['planId','carriedForwardQuantity','requiredQuantityForYear','additionalPurchaseQty'].includes(name)
        ? (value ? parseInt(value) : null)
        : value
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const method = editing ? 'PUT' : 'POST';
    const url = editing ? `/api/purchase-plans/${editing.id}` : '/api/purchase-plans';
    const res = await fetch(url, { method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(formData) });
    if (res.ok) { resetForm(); fetchData(); }
    else { const err = await res.json().catch(()=>({})); alert(err.error || 'บันทึกล้มเหลว'); }
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
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">แผนการจัดซื้อ</h1>
        <button onClick={() => setShowForm(true)} className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">เพิ่มรายการ</button>
      </div>

      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-2/3 shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">{editing ? 'แก้ไขรายการ' : 'เพิ่มรายการใหม่'}</h3>
              <button onClick={resetForm} className="text-gray-400 hover:text-gray-600">✕</button>
            </div>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">อ้างอิงแผนการใช้</span>
                  <div className="relative">
                    <input
                      type="text"
                      value={surveySearchTerm}
                      name="surveySearch"
                      onChange={(e) => {
                        setSurveySearchTerm(e.target.value);
                        setShowSurveySuggestions(true);
                        setHighlightedSurveyIndex(-1);
                        setFormData((prev) => ({
                          ...prev,
                          planId: null,
                        }));
                      }}
                      onFocus={() => setShowSurveySuggestions(true)}
                      onBlur={() => {
                        setTimeout(() => {
                          setShowSurveySuggestions(false);
                          setHighlightedSurveyIndex(-1);
                        }, 0);
                      }}
                      onKeyDown={handleSurveySearchKeyDown}
                      placeholder="ค้นหาด้วยรหัสหรือชื่อสินค้า"
                      className={`${modalFieldClassName} pr-10 ${isEditing ? 'bg-gray-50' : ''}`}
                      readOnly={isEditing}
                    />
                    {surveySearchTerm && !isEditing && (
                      <button
                        type="button"
                        onClick={clearSurveySelection}
                        className="absolute inset-y-0 right-2 flex items-center text-gray-400 hover:text-gray-600"
                        aria-label="ล้างค่า"
                      >
                        <X className="h-4 w-4" />
                      </button>
                    )}
                    {showSurveySuggestions && filteredSurveyOptions.length > 0 && !isEditing && (
                      <div className="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded border border-gray-200 bg-white shadow-lg">
                        {filteredSurveyOptions.map((survey, index) => (
                          <button
                            key={survey.id}
                            type="button"
                            onMouseDown={(e) => e.preventDefault()}
                            onClick={() => handleSurveySelect(survey)}
                            className={`block w-full border-b border-gray-100 px-3 py-2 text-left text-sm ${index === highlightedSurveyIndex ? 'bg-blue-50' : 'hover:bg-gray-50'}`}
                          >
                            <div className="font-medium text-gray-900">
                              {survey.productCode || '-'} | {survey.productName || '-'}
                            </div>
                            <div className="text-xs text-gray-500">
                              {survey.requestingDept || '-'} | ปี {survey.budgetYear || '-'}
                            </div>
                          </button>
                        ))}
                      </div>
                    )}
                    {showSurveySuggestions && !filteredSurveyOptions.length && isSurveySearchDirty && !isEditing && (
                      <div className="absolute z-10 mt-1 w-full rounded border border-gray-200 bg-white px-3 py-2 text-sm text-gray-500 shadow-lg">
                        ไม่พบรายการที่ค้นหา
                      </div>
                    )}
                  </div>
                  {surveysLoading && <span className="text-xs text-gray-500">กำลังโหลดรายการแผนการใช้...</span>}
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">รายการในแผน/นอกแผน</span>
                  <select name="inPlan" value={formData.inPlan || ''} onChange={handleInputChange} className={modalFieldClassName}>
                    <option value="">เลือกประเภท</option>
                    <option value="ในแผน">ในแผน</option>
                    <option value="นอกแผน">นอกแผน</option>
                  </select>
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">จำนวนยกยอดมา</span>
                  <input type="number" name="carriedForwardQuantity" value={formData.carriedForwardQuantity ?? ''} onChange={handleInputChange} className={modalFieldClassName} min="0" />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">มูลค่ายกยอดมา</span>
                  <input type="number" step="0.01" name="carriedForwardValue" value={formData.carriedForwardValue ?? ''} className={`${modalFieldClassName} bg-gray-50`} min="0" readOnly />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">รหัสสินค้า</span>
                  <input name="productCode" value={formData.productCode || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">ชื่อสินค้า</span>
                  <input name="productName" value={formData.productName || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">หน่วย</span>
                  <input list="purchase-plan-units" name="unit" value={formData.unit || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  <datalist id="purchase-plan-units">
                    {Array.from(new Set(items.map((item) => item.unit).filter(Boolean))).map((unit) => (
                      <option key={unit} value={unit} />
                    ))}
                  </datalist>
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">หมวดหมู่</span>
                  <input list="purchase-plan-categories" name="category" value={formData.category || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  <datalist id="purchase-plan-categories">
                    {categories.map((category) => (
                      <option key={category} value={category} />
                    ))}
                  </datalist>
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">ประเภท</span>
                  <input list="purchase-plan-types" name="productType" value={formData.productType || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  <datalist id="purchase-plan-types">
                    {types.map((type) => (
                      <option key={type} value={type} />
                    ))}
                  </datalist>
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">ประเภทย่อย</span>
                  <input list="purchase-plan-subtypes" name="productSubtype" value={formData.productSubtype || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  <datalist id="purchase-plan-subtypes">
                    {subtypes.map((subtype) => (
                      <option key={subtype} value={subtype} />
                    ))}
                  </datalist>
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">ราคา/หน่วย</span>
                  <input type="number" step="0.01" name="pricePerUnit" value={formData.pricePerUnit ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">จำนวนที่ต้องการใช้ในปี</span>
                  <input type="number" name="requiredQuantityForYear" value={formData.requiredQuantityForYear ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">มูลค่ารวมที่ต้องใช้ในปี</span>
                  <input type="number" step="0.01" name="totalRequiredValue" value={formData.totalRequiredValue ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">จำนวนที่ต้องซื้อเพิ่มในปี</span>
                  <input type="number" name="additionalPurchaseQty" value={formData.additionalPurchaseQty ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">มูลค่าที่ต้องซื้อเพิ่มในปี</span>
                  <input type="number" step="0.01" name="additionalPurchaseValue" value={formData.additionalPurchaseValue ?? ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">ปีงบประมาณ</span>
                  <input list="purchase-plan-years" name="budgetYear" value={formData.budgetYear || ''} className={`${modalFieldClassName} bg-gray-50`} readOnly />
                  <datalist id="purchase-plan-years">
                    {years.map((year) => (
                      <option key={year} value={year} />
                    ))}
                  </datalist>
                </label>
                <label className="flex flex-col gap-1 text-sm text-gray-700">
                  <span className="font-medium">หน่วยงานจัดซื้อ</span>
                  <select name="purchasingDepartment" value={formData.purchasingDepartment || ''} onChange={handleInputChange} className={modalFieldClassName}>
                    <option value="">เลือกหน่วยงานจัดซื้อ</option>
                    {purchasingDepartmentOptions.map((department) => (
                      <option key={department} value={department}>{department}</option>
                    ))}
                  </select>
                </label>
              </div>
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
          {filtersLoading ? (
            <div className="flex justify-center items-center py-8">
              <div className="animate-spin rounded-full h-6 w-6 border-b-2 border-blue-600"></div>
            </div>
          ) : (
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
              <select value={categoryFilter} onChange={(e)=>setCategoryFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
                <option value="">หมวด</option>
                {categories.map(x => <option key={x} value={x}>{x}</option>)}
              </select>
              <select value={typeFilter} onChange={(e)=>setTypeFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
                <option value="">ประเภท</option>
                {types.map(x => <option key={x} value={x}>{x}</option>)}
              </select>
              <select value={subtypeFilter} onChange={(e)=>setSubtypeFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
                <option value="">ประเภทย่อย</option>
                {subtypes.map(x => <option key={x} value={x}>{x}</option>)}
              </select>
            </div>
          )}
        </div>
      </div>

      {/* Summary Section (based on filtered dataset, not pagination) */}
      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <h3 className="text-lg font-medium text-gray-900">สรุปข้อมูลแผนการจัดซื้อ</h3>
            <div className="flex flex-wrap items-center gap-6 text-sm">
              <div>
                <span className="text-gray-500">มูลค่ารวมตามแผน (totalRequiredValue): </span>
                <span className="font-semibold text-gray-900">
                  ฿{summaryItems
                    .reduce((sum, row) => sum + (Number(row.totalRequiredValue) || 0), 0)
                    .toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
              <div>
                <span className="text-gray-500">มูลค่ารวมซื้อเพิ่ม (additionalPurchaseValue): </span>
                <span className="font-semibold text-gray-900">
                  ฿{summaryItems
                    .reduce((sum, row) => sum + (Number(row.additionalPurchaseValue) || 0), 0)
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
                <th onClick={()=>handleSort('productCode')} className={getHeaderClass('productCode')}>รหัส</th>
                <th onClick={()=>handleSort('productName')} className={getHeaderClass('productName')}>ชื่อสินค้า</th>
                <th onClick={()=>handleSort('category')} className={getHeaderClass('category')}>หมวด</th>
                <th onClick={()=>handleSort('productType')} className={getHeaderClass('productType')}>ประเภท</th>
                <th onClick={()=>handleSort('unit')} className={getHeaderClass('unit')}>หน่วย</th>
                <th onClick={()=>handleSort('pricePerUnit')} className={getHeaderClass('pricePerUnit')}>ราคา/หน่วย</th>
                <th onClick={()=>handleSort('requiredQuantityForYear')} className={getHeaderClass('requiredQuantityForYear')}>ต้องการ/ปี</th>
                <th onClick={()=>handleSort('totalRequiredValue')} className={getHeaderClass('totalRequiredValue')}>มูลค่ารวม</th>
                <th onClick={()=>handleSort('budgetYear')} className={getHeaderClass('budgetYear')}>ปีงบ</th>
                <th className="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider w-24">Action</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {items.map((row) => (
                <tr key={row.id}>
                  <td className="px-3 py-2 text-sm">{row.productCode}</td>
                  <td className="px-3 py-2 text-sm">
                    <div className="whitespace-normal break-words" title={row.productName}>
                      {row.productName}
                    </div>
                  </td>
                  <td className="px-3 py-2 text-sm">{row.category}</td>
                  <td className="px-3 py-2 text-sm">{row.productType}</td>
                  <td className="px-3 py-2 text-sm">{row.unit}</td>
                  <td className="px-3 py-2 text-sm">{row.pricePerUnit ? Number(row.pricePerUnit).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                  <td className="px-3 py-2 text-sm">{row.requiredQuantityForYear ?? '-'}</td>
                  <td className="px-3 py-2 text-sm">{row.totalRequiredValue ? Number(row.totalRequiredValue).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                  <td className="px-3 py-2 text-sm">{row.budgetYear}</td>
                  <td className="px-3 py-2 text-sm font-medium w-24">
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
