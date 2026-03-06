'use client';

import { useState, useEffect, useRef } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { Upload, Plus, CheckCircle2, AlertCircle, X as XIcon, ChevronUp, ChevronDown, ArrowUpDown, Pencil, Trash2 } from 'lucide-react';

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

export default function SurveysPage() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
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
  
  // Validation state
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [productNameFilter, setProductNameFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('');
  const [requestingDeptFilter, setRequestingDeptFilter] = useState('');
  const [budgetYearFilter, setBudgetYearFilter] = useState(getCurrentBudgetYear().toString());
  
  // Sort states
  const [sortField, setSortField] = useState('id');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  
  // Filter options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);
  const [budgetYears, setBudgetYears] = useState<number[]>([]);
  const [productOptions, setProductOptions] = useState<ProductOption[]>([]);
  const [productSearch, setProductSearch] = useState('');

  const fallbackBudgetYears = Array.from({ length: 6 }, (_, index) => getCurrentBudgetYear() - index);
  const availableBudgetYears = Array.from(new Set([...budgetYears, ...fallbackBudgetYears])).sort((a, b) => b - a);

  useEffect(() => {
    const nextProductName = searchParams.get('productName') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('type') || '';
    const nextRequestingDept = searchParams.get('requestingDept') || '';
    const nextBudgetYear = searchParams.get('budgetYear') || getCurrentBudgetYear().toString();
    const nextSortField = searchParams.get('orderBy') || 'id';
    const nextSortOrder = (searchParams.get('sortOrder') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
    const nextPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const nextPageSize = Math.max(1, parseInt(searchParams.get('pageSize') || '20', 10) || 20);

    setProductNameFilter((prev) => prev === nextProductName ? prev : nextProductName);
    setCategoryFilter((prev) => prev === nextCategory ? prev : nextCategory);
    setTypeFilter((prev) => prev === nextType ? prev : nextType);
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
    if (requestingDeptFilter) params.set('requestingDept', requestingDeptFilter);
    if (budgetYearFilter) params.set('budgetYear', budgetYearFilter);
    if (sortField && sortField !== 'id') params.set('orderBy', sortField);
    if (sortOrder !== 'desc') params.set('sortOrder', sortOrder);
    if (page > 1) params.set('page', page.toString());
    if (pageSize !== 20) params.set('pageSize', pageSize.toString());

    const nextUrl = params.toString() ? `${pathname}?${params.toString()}` : pathname;
    router.replace(nextUrl, { scroll: false });
  }, [pathname, router, productNameFilter, categoryFilter, typeFilter, requestingDeptFilter, budgetYearFilter, sortField, sortOrder, page, pageSize]);

  useEffect(() => {
    fetchFilterOptions();
    fetchProductOptions();
  }, []);

  // Fetch surveys when filters, sorting or pagination change (current page only)
  useEffect(() => {
    fetchSurveys();
  }, [productNameFilter, categoryFilter, typeFilter, requestingDeptFilter, budgetYearFilter, sortField, sortOrder, page, pageSize]);

  // Fetch summary data when filters change (independent of pagination)
  useEffect(() => {
    fetchSummarySurveys();
    setPage(1);
  }, [productNameFilter, categoryFilter, typeFilter, requestingDeptFilter, budgetYearFilter, sortField, sortOrder]);

  const fetchFilterOptions = async () => {
    try {
      const response = await fetch('/api/surveys/filters');
      if (response.ok) {
        const data = await response.json();
        setCategories(data.categories);
        setTypes(data.types);
        setSubtypes(data.subtypes);
        setDepartments(data.departments);
        setBudgetYears((data.budgetYears || []).sort((a: number, b: number) => b - a));
      }
    } catch (error) {
      console.error('Error fetching filter options:', error);
    }
  };

  const fetchProductOptions = async () => {
    try {
      const response = await fetch('/api/products?page=1&pageSize=200');
      if (!response.ok) {
        throw new Error('Failed to fetch products');
      }

      const data = await response.json();
      setProductOptions(data.data || []);
    } catch (error) {
      console.error('Error fetching product options:', error);
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
    try {
      setLoading(true);
      const params = new URLSearchParams();
      
      if (productNameFilter) params.append('productName', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (requestingDeptFilter) params.append('requestingDept', requestingDeptFilter);
      if (budgetYearFilter) params.append('budgetYear', budgetYearFilter);
      if (sortField) params.append('orderBy', sortField);
      if (sortOrder) params.append('sortOrder', sortOrder);
      params.append('page', page.toString());
      params.append('pageSize', pageSize.toString());
      
      const response = await fetch(`/api/surveys?${params.toString()}`);
      if (response.ok) {
        const data = await response.json();
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
      setLoading(false);
    }
  };

  // Fetch full filtered dataset for summary (not paginated)
  const fetchSummarySurveys = async () => {
    try {
      const params = new URLSearchParams();

      if (productNameFilter) params.append('productName', productNameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (requestingDeptFilter) params.append('requestingDept', requestingDeptFilter);
      if (sortField) params.append('orderBy', sortField);
      if (sortOrder) params.append('sortOrder', sortOrder);

      const response = await fetch(`/api/surveys?${params.toString()}`);
      if (response.ok) {
        const data = await response.json();
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
      setFormData((prev) => ({
        ...prev,
        productCode: value,
      }));
      return;
    }

    setFormData((prev) => ({
      ...prev,
      productCode: selectedProduct.code || '',
      productName: selectedProduct.name || '',
      category: selectedProduct.category || '',
      type: selectedProduct.type || '',
      subtype: selectedProduct.subtype || '',
      unit: selectedProduct.unit || '',
    }));

    setErrors((prev) => ({
      ...prev,
      productCode: '',
      productName: '',
    }));
  };

  const updateInlineField = (field: 'requestedAmount' | 'pricePerUnit' | 'approvedQuota', value: string) => {
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
      const url = editingSurvey ? `/api/surveys/${editingSurvey.id}` : '/api/surveys';
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
        await Swal.fire({
          title: 'สำเร็จ!',
          text: editingSurvey ? 'แก้ไขข้อมูลเรียบร้อยแล้ว' : 'เพิ่มข้อมูลเรียบร้อยแล้ว',
          icon: 'success',
          confirmButtonText: 'ตกลง'
        });
        
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
    setProductSearch(survey.productCode && survey.productName ? `${survey.productCode} - ${survey.productName}` : survey.productCode || survey.productName || '');
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
        const response = await fetch(`/api/surveys/${survey.id}`, {
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

      const res = await fetch('/api/surveys/import', {
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
  const startInlineEdit = (survey: Survey) => {
    setEditingId(survey.id);
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
  const saveInlineEdit = async (id: number) => {
    try {
      const response = await fetch(`/api/surveys/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          requestedAmount: editData.requestedAmount,
          approvedQuota: editData.approvedQuota,
          requestingDept: editData.requestingDept,
        })
      });

      if (response.ok) {
        setEditingId(null);
        setEditData({
          productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: '', budgetYear: getCurrentBudgetYear().toString(), sequenceNo: '1'
        });
        resetToNewestFirst();
        await fetchSurveys();
        await fetchSummarySurveys();

        setToast({
          message: 'บันทึกข้อมูลสำเร็จ!',
          type: 'success',
          visible: true
        });

        hideToastLater();
      } else {
        const errorData = await response.json().catch(() => null);
        setToast({
          message: errorData?.error || 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
          type: 'error',
          visible: true
        });

        hideToastLater();
      }
    } catch (error) {
      console.error('Error updating survey:', error);

      setToast({
        message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
        type: 'error',
        visible: true
      });

      hideToastLater();
    }
  };

  // Cancel inline edit
  const cancelInlineEdit = () => {
    setEditingId(null);
    setEditData({
      productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: '', budgetYear: getCurrentBudgetYear().toString(), sequenceNo: '1'
    });
  };

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

  const handleBulkProductSelect = (id: number, value: string) => {
    const normalizedValue = value.trim().toLowerCase();
    const selectedProduct = productOptions.find((product) => {
      const label = `${product.code} - ${product.name}`.toLowerCase();
      return label === normalizedValue || product.code.toLowerCase() === normalizedValue || product.name.toLowerCase() === normalizedValue;
    });

    if (!selectedProduct) {
      updateBulkRecord(id, (record) => ({
        ...record,
        productSearch: value,
      }));
      return;
    }

    updateBulkRecord(id, (record) => ({
      ...record,
      productSearch: `${selectedProduct.code} - ${selectedProduct.name}`,
      productCode: selectedProduct.code || '',
      category: selectedProduct.category || '',
      type: selectedProduct.type || '',
      subtype: selectedProduct.subtype || '',
      productName: selectedProduct.name || '',
      unit: selectedProduct.unit || '',
      pricePerUnit: selectedProduct.costPrice?.toString() || '0'
    }));
  };

  // Save bulk surveys
  const saveBulkSurveys = async () => {
    try {
      const validRecords = bulkRecords.filter(record =>
        record.productCode.trim() !== '' && record.productName.trim() !== ''
      );

      if (validRecords.length === 0) {
        setToast({
          message: 'กรุณากรอกข้อมูลให้ครบถ้วนอย่างน้อย 1 รายการ',
          type: 'error',
          visible: true
        });
        hideToastLater();
        return;
      }

      const promises = validRecords.map(record =>
        fetch('/api/surveys', {
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
    return `px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${
      sortField === field ? 'bg-gray-100' : ''
    }`;
  };

  const clearFilters = () => {
    setProductNameFilter('');
    setCategoryFilter('');
    setTypeFilter('');
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
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">ข้อมูลความต้องการ</h1>

          </div>
          <div className="flex items-center gap-3">
            <input
              ref={fileInputRef}
              type="file"
              accept=".xlsx,.xls,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel"
              onChange={handleFileChange}
              className="hidden"
            />
            <button
              onClick={handleImportClick}
              disabled={importing}
              className={`bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition-colors flex items-center space-x-2 ${importing ? 'opacity-70 cursor-not-allowed' : ''}`}
            >
              <Upload className="h-5 w-5" />
              <span>{importing ? 'กำลังนำเข้า...' : 'นำเข้า Excel'}</span>
            </button>
            <button
              onClick={() => {
                setShowBulkForm(true);
                setBulkRecords([createEmptyBulkRecord(1)]);
              }}
              className="bg-blue-600 text-white p-3 rounded-full hover:bg-blue-700 transition-colors shadow-lg"
              title="เพิ่มความต้องการใหม่"
            >
              <Plus className="h-6 w-6" />
            </button>
          </div>
        </div>
        {/* Filter Section */}
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">ปีงบ</label>
              <select
                value={budgetYearFilter}
                onChange={(e) => setBudgetYearFilter(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                {availableBudgetYears.map((year) => (
                  <option key={year} value={year.toString()}>{year}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">หน่วยงานที่ขอ</label>
              <select
                value={requestingDeptFilter}
                onChange={(e) => setRequestingDeptFilter(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">ทั้งหมด</option>
                {departments.map((dept) => (
                  <option key={dept} value={dept}>{dept}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">ชื่อสินค้า</label>
              <input
                type="text"
                value={productNameFilter}
                onChange={(e) => setProductNameFilter(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="ค้นหาชื่อสินค้า"
              />
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">หมวดสินค้า</label>
              <select
                value={categoryFilter}
                onChange={(e) => setCategoryFilter(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">ทั้งหมด</option>
                {categories.map((cat) => (
                  <option key={cat} value={cat}>{cat}</option>
                ))}
              </select>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">ประเภท</label>
              <select
                value={typeFilter}
                onChange={(e) => setTypeFilter(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">ทั้งหมด</option>
                {types.map((type) => (
                  <option key={type} value={type}>{type}</option>
                ))}
              </select>
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
                    <th className="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider w-24">
                      Action
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {surveys.map((survey) => (
                    <tr key={survey.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.budgetYear || '-'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.sequenceNo || '-'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.productCode}
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-900 break-words max-w-xs">
                        {survey.productName}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.category}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.type}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {editingId === survey.id ? (
                          <div className="flex items-center gap-2">
                            <input
                              type="number"
                              min="0"
                              value={editData.requestedAmount}
                              onChange={(e) => updateInlineField('requestedAmount', e.target.value)}
                              className="w-24 rounded border border-gray-300 px-2 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                            />
                            <span className="text-xs text-gray-500">{survey.unit || ''}</span>
                          </div>
                        ) : (
                          <>
                            {survey.requestedAmount?.toLocaleString() || ''} {survey.unit}
                          </>
                        )}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        <>฿{survey.pricePerUnit?.toLocaleString() || '0'}</>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {editingId === survey.id ? (
                          <select
                            value={editData.requestingDept}
                            onChange={(e) => setEditData((prev) => ({ ...prev, requestingDept: e.target.value }))}
                            className="rounded border border-gray-300 px-2 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                          >
                            <option value="">เลือกหน่วยงาน</option>
                            {departments.map((dept) => (
                              <option key={dept} value={dept}>{dept}</option>
                            ))}
                          </select>
                        ) : (
                          survey.requestingDept
                        )}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {editingId === survey.id ? (
                          <input
                            type="number"
                            min="0"
                            value={editData.approvedQuota}
                            onChange={(e) => updateInlineField('approvedQuota', e.target.value)}
                            className="w-24 rounded border border-gray-300 px-2 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        ) : (
                          <>{survey.approvedQuota?.toLocaleString() || '-'}</>
                        )}
                      </td>
                      <td className="px-3 py-4 whitespace-nowrap text-sm font-medium w-24">
                        <div className="flex items-center gap-2">
                          {editingId === survey.id ? (
                            <>
                              <button
                                onClick={() => saveInlineEdit(survey.id)}
                                className="text-green-600 hover:text-green-800 cursor-pointer"
                                title="บันทึก"
                              >
                                <CheckCircle2 className="h-5 w-5" />
                              </button>
                              <button
                                onClick={cancelInlineEdit}
                                className="text-gray-500 hover:text-gray-700 cursor-pointer"
                                title="ยกเลิก"
                              >
                                <XIcon className="h-5 w-5" />
                              </button>
                            </>
                          ) : (
                            <button
                              onClick={() => startInlineEdit(survey)}
                              className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                              title="แก้ไข"
                            >
                              <Pencil className="h-5 w-5" />
                            </button>
                          )}
                          <button
                            onClick={() => handleDelete(survey)}
                            className="text-red-600 hover:text-red-900 cursor-pointer"
                            title="ลบ"
                          >
                            <Trash2 className="h-5 w-5" />
                          </button>
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
              
              <form onSubmit={handleSubmit} className="overflow-y-auto px-6 py-6">
                <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
                  {/* Product Code */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ค้นหา/เลือกสินค้า *
                    </label>
                    <input
                      list="survey-product-options"
                      type="text"
                      value={productSearch}
                      onChange={(e) => handleProductSelect(e.target.value)}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                        errors.productCode ? 'border-red-500' : 'border-gray-300'
                      }`}
                      placeholder="พิมพ์รหัสหรือชื่อสินค้า"
                    />
                    <datalist id="survey-product-options">
                      {productOptions.map((product) => (
                        <option key={product.id} value={`${product.code} - ${product.name}`} />
                      ))}
                    </datalist>
                    {errors.productCode && <p className="mt-1 text-sm text-red-600">{errors.productCode}</p>}
                  </div>
                  
                  {/* Product Name */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ชื่อสินค้า *
                    </label>
                    <input
                      type="text"
                      name="productName"
                      value={formData.productName}
                      onChange={handleInputChange}
                      readOnly
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                        errors.productName ? 'border-red-500' : 'border-gray-300 bg-gray-50'
                      }`}
                      placeholder="เลือกสินค้าจากรายการ"
                    />
                    {errors.productName && <p className="mt-1 text-sm text-red-600">{errors.productName}</p>}
                  </div>
                  
                  {/* Category */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      หมวดสินค้า
                    </label>
                    <select
                      name="category"
                      value={formData.category}
                      onChange={handleInputChange}
                      disabled
                      className="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-50 focus:outline-none"
                    >
                      <option value="">เลือกหมวดสินค้า</option>
                      {categories.map((cat) => (
                        <option key={cat} value={cat}>{cat}</option>
                      ))}
                    </select>
                  </div>
                  
                  {/* Type */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ประเภท
                    </label>
                    <select
                      name="type"
                      value={formData.type}
                      onChange={handleInputChange}
                      disabled
                      className="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-50 focus:outline-none"
                    >
                      <option value="">เลือกประเภท</option>
                      {types.map((type) => (
                        <option key={type} value={type}>{type}</option>
                      ))}
                    </select>
                  </div>
                  
                  {/* Subtype */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ประเภทย่อย
                    </label>
                    <select
                      name="subtype"
                      value={formData.subtype}
                      onChange={handleInputChange}
                      disabled
                      className="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-50 focus:outline-none"
                    >
                      <option value="">เลือกประเภทย่อย</option>
                      {subtypes.map((subtype) => (
                        <option key={subtype} value={subtype}>{subtype}</option>
                      ))}
                    </select>
                  </div>
                  
                  {/* Unit */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      หน่วยนับ
                    </label>
                    <input
                      type="text"
                      name="unit"
                      value={formData.unit}
                      onChange={handleInputChange}
                      readOnly
                      className="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-50 focus:outline-none"
                      placeholder="เลือกสินค้าจากรายการ"
                    />
                  </div>
                  
                  {/* Requested Amount */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      จำนวนที่ขอ
                    </label>
                    <input
                      type="number"
                      name="requestedAmount"
                      value={formData.requestedAmount}
                      onChange={handleInputChange}
                      min="0"
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ระบุจำนวนที่ขอ"
                    />
                  </div>
                  
                  {/* Price Per Unit */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ราคาต่อหน่วย (บาท)
                    </label>
                    <input
                      type="number"
                      name="pricePerUnit"
                      value={formData.pricePerUnit}
                      onChange={handleInputChange}
                      min="0"
                      step="0.01"
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ระบุราคาต่อหน่วย"
                    />
                  </div>
                  
                  {/* Requesting Department */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      หน่วยงานที่ขอ
                    </label>
                    <select
                      name="requestingDept"
                      value={formData.requestingDept}
                      onChange={handleInputChange}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="">เลือกหน่วยงานที่ขอ</option>
                      {departments.map((dept) => (
                        <option key={dept} value={dept}>{dept}</option>
                      ))}
                    </select>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ปีงบ
                    </label>
                    <select
                      name="budgetYear"
                      value={formData.budgetYear}
                      onChange={handleInputChange}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      {availableBudgetYears.map((year) => (
                        <option key={year} value={year.toString()}>{year}</option>
                      ))}
                    </select>
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ครั้งที่
                    </label>
                    <select
                      name="sequenceNo"
                      value={formData.sequenceNo}
                      onChange={handleInputChange}
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                    >
                      <option value="1">ครั้งที่ 1</option>
                      <option value="2">ครั้งที่ 2</option>
                    </select>
                  </div>
                  
                  {/* Approved Quota */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      จำนวนที่ได้รับอนุมัติ
                    </label>
                    <input
                      type="number"
                      name="approvedQuota"
                      value={formData.approvedQuota}
                      onChange={handleInputChange}
                      min="0"
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ระบุจำนวนที่ได้รับอนุมัติ"
                    />
                  </div>
                </div>
                
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
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-100/80 p-4 backdrop-blur-sm">
            <div className="w-full max-w-7xl max-h-[90vh] overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-[0_24px_80px_rgba(15,23,42,0.18)] ring-1 ring-slate-200">
              <div className="flex items-start justify-between border-b border-slate-200 bg-gradient-to-r from-blue-50 via-white to-slate-50 px-6 py-5">
                <div>
                  <h2 className="text-xl font-bold text-slate-900">เพิ่มรายการสินค้าเข้าแผนการใช้</h2>
                  <p className="mt-1 text-sm text-slate-500">เลือกสินค้าแบบสะสมหลายรายการก่อนกดบันทึกครั้งเดียว</p>
                </div>
                <button
                  onClick={() => {
                    setShowBulkForm(false);
                    setBulkRecords([]);
                  }}
                  className="rounded-full p-2 text-slate-500 transition-colors hover:bg-white hover:text-slate-700"
                >
                  <XIcon className="h-6 w-6" />
                </button>
              </div>

              <div className="px-6 py-6">
                <p className="mb-4 text-sm text-slate-600">ค้นหาสินค้าด้วยรหัสสินค้า หรือชื่อสินค้า แล้วกรอกเฉพาะจำนวนที่ขอ หน่วยงานที่ขอ และจำนวนที่อนุมัติ สามารถเพิ่มหลายรายการก่อนกดบันทึกได้</p>
                <div className="overflow-hidden rounded-xl border border-slate-200 bg-slate-50">
                  <div className="overflow-x-auto">
                    <table className="w-full">
                      <thead className="bg-slate-100">
                        <tr>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ลำดับ</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ค้นหาสินค้า</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">รหัสสินค้า</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ชื่อสินค้า</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จำนวนที่ขอ</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หน่วย</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หน่วยงานที่ขอ</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จำนวนที่อนุมัติ</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จัดการ</th>
                        </tr>
                      </thead>
                      <tbody>
                        {bulkRecords.map((record, index) => (
                          <tr key={record.id} className="border-b border-slate-200 bg-white">
                            <td className="px-2 py-3 text-sm text-gray-900">{index + 1}</td>
                            <td className="px-2 py-3">
                              <input
                                type="text"
                                list={`survey-bulk-product-options-${record.id}`}
                                value={record.productSearch}
                                onChange={(e) => handleBulkProductSelect(record.id, e.target.value)}
                                placeholder="ค้นหารหัสหรือชื่อสินค้า"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                              <datalist id={`survey-bulk-product-options-${record.id}`}>
                                {productOptions.map((product) => (
                                  <option key={product.id} value={`${product.code} - ${product.name}`} />
                                ))}
                              </datalist>
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="text"
                                value={record.productCode}
                                readOnly
                                placeholder="รหัสสินค้า"
                                className="w-full px-2 py-1 border border-gray-300 rounded bg-gray-100 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="text"
                                value={record.productName}
                                readOnly
                                placeholder="ชื่อสินค้า"
                                className="w-full px-2 py-1 border border-gray-300 rounded bg-gray-100 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="number"
                                value={record.requestedAmount || ''}
                                onChange={(e) => {
                                  updateBulkRecord(record.id, (current) => ({ ...current, requestedAmount: e.target.value }));
                                }}
                                placeholder="จำนวนที่ขอ"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="text"
                                value={record.unit || ''}
                                readOnly
                                placeholder="หน่วย"
                                className="w-full px-2 py-1 border border-gray-300 rounded bg-gray-100 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <select
                                value={record.requestingDept || ''}
                                onChange={(e) => {
                                  updateBulkRecord(record.id, (current) => ({ ...current, requestingDept: e.target.value }));
                                }}
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              >
                                <option value="">เลือกหน่วยงาน</option>
                                {departments.map((dept) => (
                                  <option key={dept} value={dept}>{dept}</option>
                                ))}
                              </select>
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="number"
                                value={record.approvedQuota || ''}
                                onChange={(e) => {
                                  updateBulkRecord(record.id, (current) => ({ ...current, approvedQuota: e.target.value }));
                                }}
                                placeholder="จำนวนอนุมัติ"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <div className="flex gap-1">
                                {bulkRecords.length < 10 && (
                                  <button
                                    onClick={() => {
                                      const nextId = bulkRecords.length > 0 ? Math.max(...bulkRecords.map((r) => r.id)) + 1 : 1;
                                      setBulkRecords([...bulkRecords, createEmptyBulkRecord(nextId)]);
                                    }}
                                    className="text-green-600 hover:text-green-900 p-1"
                                    title="เพิ่มแถวใหม่"
                                  >
                                    <Plus className="h-4 w-4" />
                                  </button>
                                )}
                                {bulkRecords.length > 1 && (
                                  <button
                                    onClick={() => {
                                      setBulkRecords(bulkRecords.filter((r) => r.id !== record.id));
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

              <div className="flex gap-3 border-t border-slate-200 bg-slate-50 px-6 py-5">
                <button
                  onClick={saveBulkSurveys}
                  className="flex-1 rounded-lg bg-blue-600 py-2.5 text-white shadow-sm transition-colors hover:bg-blue-700"
                >
                  บันทึกทั้งหมด ({bulkRecords.length} รายการ)
                </button>
                <button
                  onClick={() => {
                    setShowBulkForm(false);
                    setBulkRecords([]);
                  }}
                  className="flex-1 rounded-lg bg-slate-500 py-2.5 text-white transition-colors hover:bg-slate-600"
                >
                  ยกเลิก
                </button>
              </div>
            </div>
          </div>
        )}

      </div>
    </div>
  );
}
