'use client';

import { useState, useEffect, useRef } from 'react';
import Swal from 'sweetalert2';
import { Upload, Plus, CheckCircle2, AlertCircle, X as XIcon, ChevronUp, ChevronDown, ArrowUpDown, Pencil, Trash2 } from 'lucide-react';

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
}

export default function SurveysPage() {
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
    approvedQuota: ''
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
    approvedQuota: ''
  });
  const [showBulkForm, setShowBulkForm] = useState(false);
  const [bulkRecords, setBulkRecords] = useState<any[]>([]);
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

  useEffect(() => {
    fetchFilterOptions();
  }, []);

  // Fetch surveys when filters, sorting or pagination change (current page only)
  useEffect(() => {
    fetchSurveys();
  }, [productNameFilter, categoryFilter, typeFilter, requestingDeptFilter, sortField, sortOrder, page, pageSize]);

  // Fetch summary data when filters change (independent of pagination)
  useEffect(() => {
    fetchSummarySurveys();
    setPage(1);
  }, [productNameFilter, categoryFilter, typeFilter, requestingDeptFilter, sortField, sortOrder]);

  const fetchFilterOptions = async () => {
    try {
      const response = await fetch('/api/surveys/filters');
      if (response.ok) {
        const data = await response.json();
        setCategories(data.categories);
        setTypes(data.types);
        setSubtypes(data.subtypes);
        setDepartments(data.departments);
      }
    } catch (error) {
      console.error('Error fetching filter options:', error);
    }
  };

  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + (surveys.length || 0) - 1);

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) return;
    setPage(newPage);
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
        body: JSON.stringify(formData),
      });
      
      if (response.ok) {
        await Swal.fire({
          title: 'สำเร็จ!',
          text: editingSurvey ? 'แก้ไขข้อมูลเรียบร้อยแล้ว' : 'เพิ่มข้อมูลเรียบร้อยแล้ว',
          icon: 'success',
          confirmButtonText: 'ตกลง'
        });
        
        closeForm();
        fetchSurveys();
      } else {
        throw new Error('Failed to save survey');
      }
    } catch (error) {
      console.error('Error saving survey:', error);
      await Swal.fire({
        title: 'เกิดข้อผิดพลาด!',
        text: 'ไม่สามารถบันทึกข้อมูลได้',
        icon: 'error',
        confirmButtonText: 'ตกลง'
      });
    }
  };

  const handleEdit = (survey: Survey) => {
    setEditingSurvey(survey);
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
      approvedQuota: survey.approvedQuota?.toString() || ''
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
      approvedQuota: ''
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
      approvedQuota: survey.approvedQuota?.toString() || ''
    });
  };

  // Save inline edit
  const saveInlineEdit = async (id: number) => {
    try {
      const response = await fetch(`/api/surveys/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editData)
      });

      if (response.ok) {
        setEditingId(null);
        setEditData({
          productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: ''
        });
        fetchSurveys();

        setToast({
          message: 'บันทึกข้อมูลสำเร็จ!',
          type: 'success',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      } else {
        setToast({
          message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
          type: 'error',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }
    } catch (error) {
      console.error('Error updating survey:', error);

      setToast({
        message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
        type: 'error',
        visible: true
      });

      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
    }
  };

  // Cancel inline edit
  const cancelInlineEdit = () => {
    setEditingId(null);
    setEditData({
      productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: ''
    });
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
        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
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
            approvedQuota: record.approvedQuota ? parseFloat(record.approvedQuota) : 0
          })
        })
      );

      const results = await Promise.allSettled(promises);
      const successful = results.filter(result => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;

      if (successful > 0) {
        setShowBulkForm(false);
        setBulkRecords([]);
        fetchSurveys();

        setToast({
          message: `บันทึกสำเร็จ ${successful} รายการ${failed > 0 ? `, ไม่สำเร็จ ${failed} รายการ` : ''}`,
          type: 'success',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }

      if (failed > 0 && successful === 0) {
        setToast({
          message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูลทั้งหมด',
          type: 'error',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }
    } catch (error) {
      console.error('Error saving bulk surveys:', error);

      setToast({
        message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
        type: 'error',
        visible: true
      });

      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
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
                setBulkRecords([
                  { id: 1, productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: '' },
                  { id: 2, productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: '' },
                  { id: 3, productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: '' },
                  { id: 4, productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: '' },
                  { id: 5, productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: '' }
                ]);
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
                        {survey.requestedAmount?.toLocaleString() || ''} {survey.unit}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        ฿{survey.pricePerUnit?.toLocaleString() || '0'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.requestingDept}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.approvedQuota?.toLocaleString() || '-'}
                      </td>
                      <td className="px-3 py-4 whitespace-nowrap text-sm font-medium w-24">
                        <button
                          onClick={() => handleEdit(survey)}
                          className="text-indigo-600 hover:text-indigo-900 mr-2 cursor-pointer"
                          title="แก้ไข"
                        >
                          <Pencil className="h-5 w-5" />
                        </button>
                        <button
                          onClick={() => handleDelete(survey)}
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
            </div>
          )}
        </div>

        {/* Form Modal */}
        {showForm && (
          <div className="fixed inset-0 bg-black bg-opacity-20 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-4xl max-h-[90vh] overflow-y-auto">
              <div className="px-6 py-4 border-b border-gray-200">
                <h2 className="text-xl font-semibold text-gray-800">
                  {editingSurvey ? 'แก้ไขข้อมูลความต้องการ' : 'เพิ่มข้อมูลความต้องการ'}
                </h2>
              </div>
              
              <form onSubmit={handleSubmit} className="px-6 py-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* Product Code */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      รหัสสินค้า *
                    </label>
                    <input
                      type="text"
                      name="productCode"
                      value={formData.productCode}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                        errors.productCode ? 'border-red-500' : 'border-gray-300'
                      }`}
                      placeholder="ระบุรหัสสินค้า"
                    />
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
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                        errors.productName ? 'border-red-500' : 'border-gray-300'
                      }`}
                      placeholder="ระบุชื่อสินค้า"
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
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
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
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
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
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
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
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ระบุหน่วยนับ"
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
                
                <div className="mt-6 flex justify-end space-x-3">
                  <button
                    type="button"
                    onClick={closeForm}
                    className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors"
                  >
                    ยกเลิก
                  </button>
                  <button
                    type="submit"
                    className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
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
          <div className="fixed inset-0 bg-black bg-opacity-20 flex items-center justify-center z-50">
            <div className="bg-white rounded-lg p-6 w-full max-w-7xl max-h-[90vh] overflow-y-auto">
              <div className="flex justify-between items-center mb-4">
                <h2 className="text-xl font-bold">เพิ่มความต้องการใหม่ (5 รายการพร้อมแก้ไข)</h2>
                <button
                  onClick={() => {
                    setShowBulkForm(false);
                    setBulkRecords([]);
                  }}
                  className="text-gray-500 hover:text-gray-700"
                >
                  <XIcon className="h-6 w-6" />
                </button>
              </div>

              <div className="mb-4">
                <div className="bg-gray-50 rounded-lg overflow-hidden">
                  <div className="overflow-x-auto">
                    <table className="w-full">
                      <thead className="bg-gray-100">
                        <tr>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ลำดับ</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">รหัสสินค้า</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ชื่อสินค้า</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หมวดสินค้า</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ประเภท</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จำนวนที่ขอ</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หน่วย</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ราคาต่อหน่วย</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หน่วยงานที่ขอ</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จำนวนที่อนุมัติ</th>
                          <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จัดการ</th>
                        </tr>
                      </thead>
                      <tbody>
                        {bulkRecords.map((record: any, index: number) => (
                          <tr key={record.id} className="border-b border-gray-200">
                            <td className="px-2 py-3 text-sm text-gray-900">{index + 1}</td>
                            <td className="px-2 py-3">
                              <input
                                type="text"
                                value={record.productCode || ''}
                                onChange={(e) => {
                                  const updated = [...bulkRecords];
                                  updated[index].productCode = e.target.value;
                                  setBulkRecords(updated);
                                }}
                                placeholder="รหัสสินค้า"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="text"
                                value={record.productName || ''}
                                onChange={(e) => {
                                  const updated = [...bulkRecords];
                                  updated[index].productName = e.target.value;
                                  setBulkRecords(updated);
                                }}
                                placeholder="ชื่อสินค้า"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <select
                                value={record.category || ''}
                                onChange={(e) => {
                                  const updated = [...bulkRecords];
                                  updated[index].category = e.target.value;
                                  setBulkRecords(updated);
                                }}
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              >
                                <option value="">เลือกหมวด</option>
                                {categories.map((cat) => (
                                  <option key={cat} value={cat}>{cat}</option>
                                ))}
                              </select>
                            </td>
                            <td className="px-2 py-3">
                              <select
                                value={record.type || ''}
                                onChange={(e) => {
                                  const updated = [...bulkRecords];
                                  updated[index].type = e.target.value;
                                  setBulkRecords(updated);
                                }}
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              >
                                <option value="">เลือกประเภท</option>
                                {types.map((type) => (
                                  <option key={type} value={type}>{type}</option>
                                ))}
                              </select>
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="number"
                                value={record.requestedAmount || ''}
                                onChange={(e) => {
                                  const updated = [...bulkRecords];
                                  updated[index].requestedAmount = e.target.value;
                                  setBulkRecords(updated);
                                }}
                                placeholder="จำนวนที่ขอ"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="text"
                                value={record.unit || ''}
                                onChange={(e) => {
                                  const updated = [...bulkRecords];
                                  updated[index].unit = e.target.value;
                                  setBulkRecords(updated);
                                }}
                                placeholder="หน่วย"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <input
                                type="number"
                                value={record.pricePerUnit || ''}
                                onChange={(e) => {
                                  const updated = [...bulkRecords];
                                  updated[index].pricePerUnit = e.target.value;
                                  setBulkRecords(updated);
                                }}
                                placeholder="ราคา"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <select
                                value={record.requestingDept || ''}
                                onChange={(e) => {
                                  const updated = [...bulkRecords];
                                  updated[index].requestingDept = e.target.value;
                                  setBulkRecords(updated);
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
                                  const updated = [...bulkRecords];
                                  updated[index].approvedQuota = e.target.value;
                                  setBulkRecords(updated);
                                }}
                                placeholder="จำนวนอนุมัติ"
                                className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                              />
                            </td>
                            <td className="px-2 py-3">
                              <div className="flex gap-1">
                                {bulkRecords.length < 5 && (
                                  <button
                                    onClick={() => {
                                      const newRecord = {
                                        id: Math.max(...bulkRecords.map((r: any) => r.id)) + 1,
                                        productCode: '', category: '', type: '', subtype: '', productName: '', requestedAmount: '', unit: '', pricePerUnit: '', requestingDept: '', approvedQuota: ''
                                      };
                                      setBulkRecords([...bulkRecords, newRecord]);
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
                                      setBulkRecords(bulkRecords.filter((r: any) => r.id !== record.id));
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

              <div className="flex gap-3">
                <button
                  onClick={saveBulkSurveys}
                  className="flex-1 bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700 transition-colors"
                >
                  บันทึกทั้งหมด ({bulkRecords.length} รายการ)
                </button>
                <button
                  onClick={() => {
                    setShowBulkForm(false);
                    setBulkRecords([]);
                  }}
                  className="flex-1 bg-gray-500 text-white py-2 rounded-md hover:bg-gray-600 transition-colors"
                >
                  ยกเลิก
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Form Modal */}
        {showForm && (
          <div className="fixed inset-0 bg-gray-900 bg-opacity-40 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-lg shadow-xl w-full max-w-4xl max-h-[90vh] overflow-y-auto">
              <div className="px-6 py-4 border-b border-gray-200">
                <h2 className="text-xl font-semibold text-gray-800">
                  {editingSurvey ? 'แก้ไขข้อมูลความต้องการ' : 'เพิ่มข้อมูลความต้องการ'}
                </h2>
              </div>

              <form onSubmit={handleSubmit} className="px-6 py-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  {/* Product Code */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      รหัสสินค้า *
                    </label>
                    <input
                      type="text"
                      name="productCode"
                      value={formData.productCode}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                        errors.productCode ? 'border-red-500' : 'border-gray-300'
                      }`}
                      placeholder="ระบุรหัสสินค้า"
                    />
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
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                        errors.productName ? 'border-red-500' : 'border-gray-300'
                      }`}
                      placeholder="ระบุชื่อสินค้า"
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
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
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
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
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
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
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
                      className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ระบุหน่วยนับ"
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

                <div className="mt-6 flex justify-end space-x-3">
                  <button
                    type="button"
                    onClick={closeForm}
                    className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 transition-colors"
                  >
                    ยกเลิก
                  </button>
                  <button
                    type="submit"
                    className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors"
                  >
                    {editingSurvey ? 'บันทึกการแก้ไข' : 'บันทึกข้อมูล'}
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
