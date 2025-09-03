'use client';

import { useState, useEffect } from 'react';
import { Product } from '@prisma/client';
import Swal from 'sweetalert2';

interface ProductFormData {
  code: string;
  category: string;
  name: string;
  type: string;
  subtype: string;
  unit: string;
  costPrice?: number;
  sellPrice?: number;
  stockBalance?: number;
  stockValue?: number;
  sellerCode?: string;
  image?: string;
  adminNote?: string;
}

export default function ProductsPage() {
  const [products, setProducts] = useState<Product[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [formData, setFormData] = useState<ProductFormData>({
    code: '',
    category: '',
    name: '',
    type: '',
    subtype: '',
    unit: '',
    costPrice: undefined,
    sellPrice: undefined,
    stockBalance: undefined,
    stockValue: undefined,
    sellerCode: '',
    image: '',
    adminNote: ''
  });
  
  // Validation state
  const [errors, setErrors] = useState<Record<string, string>>({});
  
  // Filter states
  const [nameFilter, setNameFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('');
  const [subtypeFilter, setSubtypeFilter] = useState('');
  
  // Sorting states
  const [sortBy, setSortBy] = useState('code');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('asc');
  
  // Dynamic filter options (fetched from API)
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [sellerCodes, setSellerCodes] = useState<string[]>([]);
  
  useEffect(() => {
    fetchProducts();
  }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, sortBy, sortOrder]);

  useEffect(() => {
    fetchFilterOptions();
  }, []);

  const fetchFilterOptions = async () => {
    try {
      const response = await fetch('/api/products/filters');
      if (response.ok) {
        const data = await response.json();
        setCategories(data.categories);
        setTypes(data.types);
        setSubtypes(data.subtypes);
        setSellerCodes(data.sellerCodes);
      }
    } catch (error) {
      console.error('Error fetching filter options:', error);
    }
  };

  const fetchProducts = async () => {
    try {
      setLoading(true);
      
      // Build query string with filters and sorting
      const params = new URLSearchParams();
      
      if (nameFilter) params.append('name', nameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('type', typeFilter);
      if (subtypeFilter) params.append('subtype', subtypeFilter);
      
      // Add sorting parameters
      params.append('orderBy', sortBy);
      params.append('sortOrder', sortOrder);
      
      const response = await fetch(`/api/products?${params.toString()}`);
      if (!response.ok) throw new Error('Failed to fetch products');
      const data = await response.json();
      setProducts(data.products);
      setTotalCount(data.totalCount);
    } catch (err) {
      console.error('Error fetching products:', err);
    } finally {
      setLoading(false);
    }
  };
  
  // Sorting function
  const handleSort = (column: string) => {
    if (sortBy === column) {
      // Toggle sort order if clicking the same column
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      // Set new column and default to ascending order
      setSortBy(column);
      setSortOrder('asc');
    }
  };
  
  // Function to get sort indicator
  const getSortIndicator = (column: string) => {
    if (sortBy === column) {
      return sortOrder === 'asc' ? ' ↑' : ' ↓';
    }
    return '';
  };
  
  // Function to get sort icon
  const getSortIcon = (column: string) => {
    if (sortBy === column) {
      return sortOrder === 'asc' ? (
        <svg className="w-4 h-4 inline-block ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
        </svg>
      ) : (
        <svg className="w-4 h-4 inline-block ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      );
    }
    return (
      <svg className="w-4 h-4 inline-block ml-1 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
      </svg>
    );
  };
  
  // Function to get header class
  const getHeaderClass = (column: string) => {
    return `px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${column === sortBy ? 'bg-gray-100' : ''}`;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate required fields
    const newErrors: Record<string, string> = {};
    
    if (!formData.code.trim()) {
      newErrors.code = 'กรุณาระบุรหัสสินค้า';
    }
    
    if (!formData.category.trim()) {
      newErrors.category = 'กรุณาระบุหมวดหมู่';
    }
    
    if (!formData.name.trim()) {
      newErrors.name = 'กรุณาระบุชื่อสินค้า';
    }
    
    if (!formData.type.trim()) {
      newErrors.type = 'กรุณาระบุประเภท';
    }
    
    if (!formData.subtype.trim()) {
      newErrors.subtype = 'กรุณาระบุชนิดย่อย';
    }
    
    if (!formData.unit.trim()) {
      newErrors.unit = 'กรุณาระบุหน่วย';
    }
    
    if (Object.keys(newErrors).length > 0) {
      setErrors(newErrors);
      return;
    }
    
    try {
      const url = editingProduct ? `/api/products/${editingProduct.id}` : '/api/products';
      const method = editingProduct ? 'PUT' : 'POST';
      
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        fetchProducts();
        resetForm();
      } else {
        const error = await response.json();
        alert(error.error || 'เกิดข้อผิดพลาดในการบันทึกข้อมูล');
      }
    } catch (error) {
      console.error('Error saving product:', error);
      alert('เกิดข้อผิดพลาดในการบันทึกข้อมูล');
    }
  };

  const handleEdit = (product: Product) => {
    setEditingProduct(product);
    setFormData({
      code: product.code,
      category: product.category,
      name: product.name,
      type: product.type || '',
      subtype: product.subtype || '',
      unit: product.unit || '',
      costPrice: product.costPrice ? Number(product.costPrice) : undefined,
      sellPrice: product.sellPrice ? Number(product.sellPrice) : undefined,
      stockBalance: product.stockBalance || undefined,
      stockValue: product.stockValue ? Number(product.stockValue) : undefined,
      sellerCode: product.sellerCode || '',
      image: product.image || '',
      adminNote: product.adminNote || ''
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    const result = await Swal.fire({
      title: 'คุณแน่ใจหรือไม่?',
      text: 'คุณจะไม่สามารถกู้คืนสินค้านี้ได้!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'ใช่, ลบเลย!',
      cancelButtonText: 'ยกเลิก'
    });

    if (result.isConfirmed) {
      try {
        const response = await fetch(`/api/products/${id}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          await Swal.fire({
            title: 'ลบแล้ว!',
            text: 'สินค้าของคุณถูกลบแล้ว',
            icon: 'success',
            confirmButtonColor: '#3085d6'
          });
          fetchProducts();
        } else {
          await Swal.fire({
            title: 'เกิดข้อผิดพลาด!',
            text: 'เกิดข้อผิดพลาดในการลบสินค้า',
            icon: 'error',
            confirmButtonColor: '#3085d6'
          });
        }
      } catch (error) {
        console.error('Error deleting product:', error);
        await Swal.fire({
          title: 'เกิดข้อผิดพลาด!',
          text: 'เกิดข้อผิดพลาดในการลบสินค้า',
          icon: 'error',
          confirmButtonColor: '#3085d6'
        });
      }
    }
  };

  const resetForm = () => {
    setEditingProduct(null);
    setFormData({
      code: '',
      category: '',
      name: '',
      type: '',
      subtype: '',
      unit: '',
      costPrice: undefined,
      sellPrice: undefined,
      stockBalance: undefined,
      stockValue: undefined,
      sellerCode: '',
      image: '',
      adminNote: ''
    });
    setErrors({});
    setShowForm(false);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name.includes('Price') || name.includes('Value') ? (value ? parseFloat(value) : undefined) :
               name === 'stockBalance' ? (value ? parseInt(value) : undefined) : value
    }));
    
    // Clear error when user starts typing
    if (errors[name]) {
      setErrors(prev => {
        const newErrors = { ...prev };
        delete newErrors[name];
        return newErrors;
      });
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-blue-500"></div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">รายการสินค้า</h1>
        <button
          onClick={() => setShowForm(true)}
          className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        >
          เพิ่มสินค้าใหม่
        </button>
      </div>

      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-1/2 shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">
                {editingProduct ? 'แก้ไขสินค้า' : 'เพิ่มสินค้าใหม่'}
              </h3>
              <button
                onClick={resetForm}
                className="text-gray-400 hover:text-gray-600"
              >
                <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700">รหัสสินค้า *</label>
                  <input
                    type="text"
                    name="code"
                    value={formData.code}
                    onChange={handleInputChange}
                    required
                    className={`mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ${errors.code ? 'border-red-500' : ''}`}
                  />
                  {errors.code && <p className="mt-1 text-sm text-red-600">{errors.code}</p>}
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">ชื่อสินค้า *</label>
                  <input
                    type="text"
                    name="name"
                    value={formData.name}
                    onChange={handleInputChange}
                    required
                    className={`mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ${errors.name ? 'border-red-500' : ''}`}
                  />
                  {errors.name && <p className="mt-1 text-sm text-red-600">{errors.name}</p>}
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">หมวดหมู่ *</label>
                  <input
                    type="text"
                    name="category"
                    value={formData.category}
                    onChange={handleInputChange}
                    required
                    className={`mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ${errors.category ? 'border-red-500' : ''}`}
                  />
                  {errors.category && <p className="mt-1 text-sm text-red-600">{errors.category}</p>}
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">ประเภท *</label>
                  <input
                    type="text"
                    name="type"
                    value={formData.type}
                    onChange={handleInputChange}
                    required
                    className={`mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ${errors.type ? 'border-red-500' : ''}`}
                  />
                  {errors.type && <p className="mt-1 text-sm text-red-600">{errors.type}</p>}
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">ชนิดย่อย *</label>
                  <input
                    type="text"
                    name="subtype"
                    value={formData.subtype}
                    onChange={handleInputChange}
                    required
                    className={`mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ${errors.subtype ? 'border-red-500' : ''}`}
                  />
                  {errors.subtype && <p className="mt-1 text-sm text-red-600">{errors.subtype}</p>}
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">หน่วย *</label>
                  <input
                    type="text"
                    name="unit"
                    value={formData.unit}
                    onChange={handleInputChange}
                    required
                    className={`mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 ${errors.unit ? 'border-red-500' : ''}`}
                  />
                  {errors.unit && <p className="mt-1 text-sm text-red-600">{errors.unit}</p>}
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">ราคาทุน</label>
                  <input
                    type="number"
                    step="0.01"
                    name="costPrice"
                    value={formData.costPrice || ''}
                    onChange={handleInputChange}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">ราคาขาย</label>
                  <input
                    type="number"
                    step="0.01"
                    name="sellPrice"
                    value={formData.sellPrice || ''}
                    onChange={handleInputChange}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">จำนวนคงคลัง</label>
                  <input
                    type="number"
                    name="stockBalance"
                    value={formData.stockBalance || ''}
                    onChange={handleInputChange}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">มูลค่าสต็อก</label>
                  <input
                    type="number"
                    step="0.01"
                    name="stockValue"
                    value={formData.stockValue || ''}
                    onChange={handleInputChange}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">รหัสผู้ขาย</label>
                  <input
                    type="text"
                    name="sellerCode"
                    value={formData.sellerCode}
                    onChange={handleInputChange}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700">รูปภาพ</label>
                  <input
                    type="text"
                    name="image"
                    value={formData.image}
                    onChange={handleInputChange}
                    className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  />
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700">หมายเหตุ</label>
                <textarea
                  name="adminNote"
                  value={formData.adminNote}
                  onChange={handleInputChange}
                  rows={3}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                />
              </div>
              <div className="flex justify-end space-x-3">
                <button
                  type="button"
                  onClick={resetForm}
                  className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 hover:bg-gray-50"
                >
                  ยกเลิก
                </button>
                <button
                  type="submit"
                  className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700"
                >
                  {editingProduct ? 'บันทึกการแก้ไข' : 'เพิ่มสินค้า'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        {/* Filter Section */}
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4 mb-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">ชื่อสินค้า</label>
              <input
                type="text"
                value={nameFilter}
                onChange={(e) => setNameFilter(e.target.value)}
                placeholder="ค้นหาชื่อสินค้า..."
                className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 text-sm"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">หมวดสินค้า</label>
              <select
                value={categoryFilter}
                onChange={(e) => setCategoryFilter(e.target.value)}
                className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 text-sm"
              >
                <option value="">ทั้งหมด</option>
                {categories.map((category) => (
                  <option key={category} value={category}>{category}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">ประเภทสินค้า</label>
              <select
                value={typeFilter}
                onChange={(e) => setTypeFilter(e.target.value)}
                className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 text-sm"
              >
                <option value="">ทั้งหมด</option>
                {types.map((type) => (
                  <option key={type} value={type}>{type}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">ประเภทย่อย</label>
              <select
                value={subtypeFilter}
                onChange={(e) => setSubtypeFilter(e.target.value)}
                className="w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 text-sm"
              >
                <option value="">ทั้งหมด</option>
                {subtypes.map((subtype) => (
                  <option key={subtype} value={subtype}>{subtype}</option>
                ))}
              </select>
            </div>
            <div className="flex items-end">
              <button
                onClick={() => {
                  setNameFilter('');
                  setCategoryFilter('');
                  setTypeFilter('');
                  setSubtypeFilter('');
                }}
                className="w-full px-3 py-2 text-sm border border-gray-300 rounded-md shadow-sm text-gray-700 hover:bg-gray-50"
              >
                ล้าง
              </button>
            </div>
          </div>
        </div>
        
        {/* Summary Section */}
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="flex justify-between items-center">
            <h3 className="text-lg font-medium text-gray-900">สรุปข้อมูล</h3>
            <div className="flex items-center space-x-6">
              <div className="text-sm">
                <span className="text-gray-500">จำนวนทั้งสิ้น: </span>
                <span className="font-semibold text-gray-900">{products.length.toLocaleString()} รายการ</span>
              </div>
              <div className="text-sm">
                <span className="text-gray-500">มูลค่ายกมาทั้งหมด: </span>
                <span className="font-semibold text-gray-900">
                  ฿{products.reduce((total, product) => total + (product.stockValue ? Number(product.stockValue) : 0), 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="mt-4 text-sm text-gray-600">
        แสดง {products.length} จาก {totalCount} รายการ
      </div>

      <div className="bg-white shadow-md rounded-lg overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th onClick={() => handleSort('code')} className={getHeaderClass('code')}>
                รหัสสินค้า {getSortIcon('code')}
              </th>
              <th onClick={() => handleSort('category')} className={getHeaderClass('category')}>
                หมวดสินค้า {getSortIcon('category')}
              </th>
              <th onClick={() => handleSort('name')} className={getHeaderClass('name')}>
                ชื่อสินค้า {getSortIcon('name')}
              </th>
              <th onClick={() => handleSort('type')} className={getHeaderClass('type')}>
                ประเภทสินค้า {getSortIcon('type')}
              </th>
              <th onClick={() => handleSort('subtype')} className={getHeaderClass('subtype')}>
                ประเภทสินค้าย่อย {getSortIcon('subtype')}
              </th>
              <th onClick={() => handleSort('unit')} className={getHeaderClass('unit')}>
                หน่วยนับ {getSortIcon('unit')}
              </th>
              <th onClick={() => handleSort('costPrice')} className={getHeaderClass('costPrice')}>
                ราคาทุนต่อหน่วย {getSortIcon('costPrice')}
              </th>
              <th onClick={() => handleSort('sellPrice')} className={getHeaderClass('sellPrice')}>
                ราคาขายต่อหน่วย {getSortIcon('sellPrice')}
              </th>
              <th onClick={() => handleSort('stockBalance')} className={getHeaderClass('stockBalance')}>
                ยอดยกมา {getSortIcon('stockBalance')}
              </th>
              <th onClick={() => handleSort('stockValue')} className={getHeaderClass('stockValue')}>
                มูลค่ายกมา {getSortIcon('stockValue')}
              </th>
              <th className="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider w-20">
                สถานะ
              </th>
              <th className="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider w-24">
                Action
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {products.map((product) => (
              <tr key={product.id}>
                <td className="px-3 py-4 whitespace-nowrap text-sm font-medium text-gray-900 w-24">
                  {product.code}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500 w-28">
                  {product.category}
                </td>
                <td className="px-4 py-4 text-sm text-gray-900">
                  <div className="break-words" title={product.name}>
                    {product.name}
                  </div>
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500 w-28">
                  {product.type || '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500 w-28">
                  {product.subtype || '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500 w-20">
                  {product.unit || '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500 w-24">
                  {product.costPrice ? `฿${Number(product.costPrice).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` : '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500 w-24">
                  {product.sellPrice ? `฿${Number(product.sellPrice).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` : '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500 w-20">
                  {product.stockBalance || 0}
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm text-gray-500 w-24">
                  {product.stockValue ? `฿${Number(product.stockValue).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}` : '-'}
                </td>
                <td className="px-3 py-4 whitespace-nowrap w-20">
                  <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                    product.flagActivate ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                  }`}>
                    {product.flagActivate ? (
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                        <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                      </svg>
                    ) : (
                      <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                        <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                      </svg>
                    )}
                  </span>
                </td>
                <td className="px-3 py-4 whitespace-nowrap text-sm font-medium w-24">
                  <button
                    onClick={() => handleEdit(product)}
                    className="text-indigo-600 hover:text-indigo-900 mr-2 cursor-pointer"
                    title="แก้ไข"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                      <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                    </svg>
                  </button>
                  <button
                    onClick={() => handleDelete(product.id)}
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

      {products.length === 0 && (
        <div className="text-center py-8">
          <p className="text-gray-500 text-lg">ไม่มีข้อมูลสินค้า</p>
          <button
            onClick={() => setShowForm(true)}
            className="mt-4 bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            เพิ่มสินค้าใหม่
          </button>
        </div>
      )}
    </div>
  );
}
