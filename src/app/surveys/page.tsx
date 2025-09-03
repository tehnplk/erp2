'use client';

import { useState, useEffect } from 'react';

interface Survey {
  id: number;
  productId: string;
  category: string;
  type: string;
  subtype: string;
  productName: string;
  requestedAmount: number;
  unit: string;
  pricePerUnit: number | null;
  requestingDept: string;
  approvedQuota: number;
}

interface SurveyFormData {
  productId: string;
  category: string;
  type: string;
  subtype: string;
  productName: string;
  requestedAmount: number;
  unit: string;
  pricePerUnit: number | null;
  requestingDept: string;
  approvedQuota: number;
}

const initialFormData: SurveyFormData = {
  productId: '',
  category: '',
  type: '',
  subtype: '',
  productName: '',
  requestedAmount: 0,
  unit: '',
  pricePerUnit: null,
  requestingDept: '',
  approvedQuota: 0
};

export default function SurveysPage() {
  const [surveys, setSurveys] = useState<Survey[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingSurvey, setEditingSurvey] = useState<Survey | null>(null);
  const [formData, setFormData] = useState<SurveyFormData>(initialFormData);
  const [errors, setErrors] = useState<Partial<SurveyFormData>>({});
  const [totalCount, setTotalCount] = useState(0);
  
  // Filter states
  const [productNameFilter, setProductNameFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('');
  const [requestingDeptFilter, setRequestingDeptFilter] = useState('');
  
  // Sort states
  const [sortField, setSortField] = useState<string>('id');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');
  
  // Options for dropdowns (fetched from API)
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
        await fetchSurveys();
        closeForm();
      }
    } catch (error) {
      console.error('Error saving survey:', error);
    }
  };

  const validateForm = () => {
    const newErrors: Partial<SurveyFormData> = {};
    
    if (!formData.productId.trim()) {
      newErrors.productId = 'กรุณาระบุรหัสสินค้า';
    }
    
    if (!formData.productName.trim()) {
      newErrors.productName = 'กรุณาระบุชื่อสินค้า';
    }
    
    if (!formData.category) {
      newErrors.category = 'กรุณาเลือกหมวดสินค้า';
    }
    
    if (!formData.type) {
      newErrors.type = 'กรุณาเลือกประเภท';
    }
    
    if (!formData.subtype) {
      newErrors.subtype = 'กรุณาเลือกประเภทย่อย';
    }
    
    if (!formData.unit.trim()) {
      newErrors.unit = 'กรุณาระบุหน่วยนับ';
    }
    
    if (!formData.requestedAmount || formData.requestedAmount <= 0) {
      newErrors.requestedAmount = 'กรุณาระบุจำนวนที่ขอให้มากกว่า 0';
    }
    
    if (!formData.requestingDept) {
      newErrors.requestingDept = 'กรุณาเลือกหน่วยงานที่ขอ';
    }
    
    if (formData.approvedQuota < 0) {
      newErrors.approvedQuota = 'จำนวนที่ได้รับอนุมัติต้องไม่ติดลบ';
    }
    
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name === 'requestedAmount' || name === 'approvedQuota' 
        ? parseInt(value) || 0
        : name === 'pricePerUnit'
        ? (value === '' ? null : parseFloat(value) || null)
        : value
    }));
    
    // Clear error when user starts typing
    if (errors[name as keyof SurveyFormData]) {
      setErrors(prev => ({ ...prev, [name]: undefined }));
    }
  };

  const handleEdit = (survey: Survey) => {
    setEditingSurvey(survey);
    setFormData({
      productId: survey.productId,
      category: survey.category,
      type: survey.type,
      subtype: survey.subtype,
      productName: survey.productName,
      requestedAmount: survey.requestedAmount,
      unit: survey.unit,
      pricePerUnit: survey.pricePerUnit,
      requestingDept: survey.requestingDept,
      approvedQuota: survey.approvedQuota
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    if (confirm('คุณแน่ใจหรือไม่ที่จะลบข้อมูลนี้?')) {
      try {
        const response = await fetch(`/api/surveys/${id}`, {
          method: 'DELETE',
        });
        
        if (response.ok) {
          await fetchSurveys();
        }
      } catch (error) {
        console.error('Error deleting survey:', error);
      }
    }
  };

  const closeForm = () => {
    setShowForm(false);
    setEditingSurvey(null);
    setFormData(initialFormData);
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
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">ข้อมูลความต้องการ (Survey)</h1>
            <p className="mt-2 text-gray-600">จัดการข้อมูลความต้องการสินค้าและบริการ</p>
          </div>
          <button
            onClick={() => setShowForm(true)}
            className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors flex items-center space-x-2"
          >
            <span>➕</span>
            <span>เพิ่มความต้องการ</span>
          </button>
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
                  {/* Product ID */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      รหัสสินค้า *
                    </label>
                    <input
                      type="text"
                      name="productId"
                      value={formData.productId}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.productId ? 'border-red-500' : 'border-gray-300'}`}
                      placeholder="ระบุรหัสสินค้า"
                    />
                    {errors.productId && <p className="mt-1 text-sm text-red-600">{errors.productId}</p>}
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
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.productName ? 'border-red-500' : 'border-gray-300'}`}
                      placeholder="ระบุชื่อสินค้า"
                    />
                    {errors.productName && <p className="mt-1 text-sm text-red-600">{errors.productName}</p>}
                  </div>
                  
                  {/* Category */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      หมวดสินค้า *
                    </label>
                    <select
                      name="category"
                      value={formData.category}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.category ? 'border-red-500' : 'border-gray-300'}`}
                    >
                      <option value="">เลือกหมวดสินค้า</option>
                      {categories.map((cat) => (
                        <option key={cat} value={cat}>{cat}</option>
                      ))}
                    </select>
                    {errors.category && <p className="mt-1 text-sm text-red-600">{errors.category}</p>}
                  </div>
                  
                  {/* Type */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ประเภท *
                    </label>
                    <select
                      name="type"
                      value={formData.type}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.type ? 'border-red-500' : 'border-gray-300'}`}
                    >
                      <option value="">เลือกประเภท</option>
                      {types.map((type) => (
                        <option key={type} value={type}>{type}</option>
                      ))}
                    </select>
                    {errors.type && <p className="mt-1 text-sm text-red-600">{errors.type}</p>}
                  </div>
                  
                  {/* Subtype */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ประเภทย่อย *
                    </label>
                    <select
                      name="subtype"
                      value={formData.subtype}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.subtype ? 'border-red-500' : 'border-gray-300'}`}
                    >
                      <option value="">เลือกประเภทย่อย</option>
                      {subtypes.map((subtype) => (
                        <option key={subtype} value={subtype}>{subtype}</option>
                      ))}
                    </select>
                    {errors.subtype && <p className="mt-1 text-sm text-red-600">{errors.subtype}</p>}
                  </div>
                  
                  {/* Unit */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      หน่วยนับ *
                    </label>
                    <input
                      type="text"
                      name="unit"
                      value={formData.unit}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.unit ? 'border-red-500' : 'border-gray-300'}`}
                      placeholder="ระบุหน่วยนับ"
                    />
                    {errors.unit && <p className="mt-1 text-sm text-red-600">{errors.unit}</p>}
                  </div>
                  
                  {/* Requested Amount */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      จำนวนที่ขอ *
                    </label>
                    <input
                      type="number"
                      name="requestedAmount"
                      value={formData.requestedAmount}
                      onChange={handleInputChange}
                      min="1"
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.requestedAmount ? 'border-red-500' : 'border-gray-300'}`}
                      placeholder="ระบุจำนวนที่ขอ"
                    />
                    {errors.requestedAmount && <p className="mt-1 text-sm text-red-600">{errors.requestedAmount}</p>}
                  </div>
                  
                  {/* Price Per Unit */}
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      ราคาต่อหน่วย (บาท)
                    </label>
                    <input
                      type="number"
                      name="pricePerUnit"
                      value={formData.pricePerUnit || ''}
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
                      หน่วยงานที่ขอ *
                    </label>
                    <select
                      name="requestingDept"
                      value={formData.requestingDept}
                      onChange={handleInputChange}
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.requestingDept ? 'border-red-500' : 'border-gray-300'}`}
                    >
                      <option value="">เลือกหน่วยงานที่ขอ</option>
                      {departments.map((dept) => (
                        <option key={dept} value={dept}>{dept}</option>
                      ))}
                    </select>
                    {errors.requestingDept && <p className="mt-1 text-sm text-red-600">{errors.requestingDept}</p>}
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
                      className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.approvedQuota ? 'border-red-500' : 'border-gray-300'}`}
                      placeholder="ระบุจำนวนที่ได้รับอนุมัติ"
                    />
                    {errors.approvedQuota && <p className="mt-1 text-sm text-red-600">{errors.approvedQuota}</p>}
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
        
        {/* Filter Section */}
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
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
          
          <div className="mt-4 flex justify-end">
            <button
              onClick={clearFilters}
              className="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition-colors"
            >
              ล้างตัวกรอง
            </button>
          </div>
        </div>
        
        <div className="mt-4 text-sm text-gray-600">
          แสดง {surveys.length} จาก {totalCount} รายการ
        </div>
        
        {/* Surveys Table */}
        <div className="bg-white shadow-md rounded-lg overflow-hidden">
          {loading ? (
            <div className="p-8 text-center">
              <div className="inline-block animate-spin rounded-full h-8 w-8 border-t-2 border-b-2 border-blue-500"></div>
              <p className="mt-2 text-gray-600">กำลังโหลดข้อมูล...</p>
            </div>
          ) : surveys.length === 0 ? (
            <div className="p-8 text-center">
              <p className="text-gray-600">ไม่พบข้อมูลความต้องการ</p>
            </div>
          ) : (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th onClick={() => handleSort('productId')} className={getHeaderClass('productId')}>
                      รหัสสินค้า {getSortIcon('productId')}
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
                    <th onClick={() => handleSort('unit')} className={getHeaderClass('unit')}>
                      หน่วยนับ {getSortIcon('unit')}
                    </th>
                    <th onClick={() => handleSort('requestingDept')} className={getHeaderClass('requestingDept')}>
                      หน่วยงานที่ขอ {getSortIcon('requestingDept')}
                    </th>
                    <th onClick={() => handleSort('approvedQuota')} className={getHeaderClass('approvedQuota')}>
                      ได้รับอนุมัติ {getSortIcon('approvedQuota')}
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      การดำเนินการ
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {surveys.map((survey) => (
                    <tr key={survey.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.productId}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.productName}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.category}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.type}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.requestedAmount.toLocaleString()}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.unit}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.requestingDept}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                        {survey.approvedQuota.toLocaleString()}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <button
                          onClick={() => handleEdit(survey)}
                          className="text-indigo-600 hover:text-indigo-900 mr-3"
                          title="แก้ไข"
                        >
                          ✏️
                        </button>
                        <button
                          onClick={() => handleDelete(survey.id)}
                          className="text-red-600 hover:text-red-900"
                          title="ลบ"
                        >
                          🗑️
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
