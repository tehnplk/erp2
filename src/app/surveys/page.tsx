'use client';

import { useState, useEffect } from 'react';
import Swal from 'sweetalert2';

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
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingSurvey, setEditingSurvey] = useState<Survey | null>(null);
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
  
  // Validation state
  const [errors, setErrors] = useState<Record<string, string>>({});
  
  // Filter states
  const [productNameFilter, setProductNameFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('');
  const [requestingDeptFilter, setRequestingDeptFilter] = useState('');
  
  // Sort states
  const [sortField, setSortField] = useState('id');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');
  
  // Filter options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);

  useEffect(() => {
    fetchSurveys();
  }, [productNameFilter, categoryFilter, typeFilter, requestingDeptFilter, sortField, sortOrder]);

  useEffect(() => {
    fetchFilterOptions();
  }, []);

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
      
      const response = await fetch(`/api/surveys?${params.toString()}`);
      if (response.ok) {
        const data = await response.json();
        setSurveys(data.surveys);
        setTotalCount(data.totalCount);
      }
    } catch (error) {
      console.error('Error fetching surveys:', error);
    } finally {
      setLoading(false);
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

  const getSortIcon = (field: string) => {
    if (sortField !== field) return '↕️';
    return sortOrder === 'asc' ? '↑' : '↓';
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
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">ข้อมูลความต้องการ</h1>
            
          </div>
          <button
            onClick={() => setShowForm(true)}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2"
          >
            <span>➕</span>
            <span>เพิ่มความต้องการ</span>
          </button>
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
            
            <div className="flex items-end">
              <button
                onClick={clearFilters}
                className="w-full px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition-colors"
              >
                ล้างตัวกรอง
              </button>
            </div>
          </div>
        </div>

        {/* Summary Section */}
        <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
          <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
            <div className="flex justify-between items-center">
              <h3 className="text-lg font-medium text-gray-900">สรุปข้อมูล</h3>
              <div className="flex flex-wrap items-center gap-6">
                <div className="text-sm">
                  <span className="text-gray-500">มูลค่ารวมที่ขอ: </span>
                  <span className="font-semibold text-gray-900">
                    ฿{surveys.reduce((sum, s) => sum + ((s.requestedAmount || 0) * (s.pricePerUnit || 0)), 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </span>
                </div>
                <div className="text-sm">
                  <span className="text-gray-500">มูลค่ารวมที่อนุมัติ: </span>
                  <span className="font-semibold text-gray-900">
                    ฿{surveys.reduce((sum, s) => sum + ((s.approvedQuota || 0) * (s.pricePerUnit || 0)), 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="mb-4 text-sm text-gray-600">
          แสดง {surveys.length} จาก {totalCount} รายการ
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
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => handleDelete(survey)}
                          className="text-red-600 hover:text-red-900 cursor-pointer"
                          title="ลบ"
                        >
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fillRule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clipRule="evenodd" />
                          </svg>
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
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
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
