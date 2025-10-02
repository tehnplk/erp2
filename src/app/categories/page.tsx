'use client';

import { useState, useEffect } from 'react';

interface Category {
  id: number;
  category: string;
  type: string;
  subtype: string;
}

export default function CategoriesPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [filteredCategories, setFilteredCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingCategory, setEditingCategory] = useState<Category | null>(null);
  const [formData, setFormData] = useState({
    category: '',
    type: '',
    subtype: ''
  });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editData, setEditData] = useState({
    category: '',
    type: '',
    subtype: ''
  });
  const [addingNew, setAddingNew] = useState(false);
  const [newRecordData, setNewRecordData] = useState({
    category: '',
    type: '',
    subtype: ''
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
  const [filters, setFilters] = useState({
    search: '',
    category: '',
    type: '',
    subtype: ''
  });

  // Fetch categories
  const fetchCategories = async () => {
    try {
      const response = await fetch('/api/categories');
      const result = await response.json();
      if (result.success) {
        setCategories(result.data);
        setFilteredCategories(result.data);
      }
    } catch (error) {
      console.error('Error fetching categories:', error);
    } finally {
      setLoading(false);
    }
  };

  // Filter categories
  const applyFilters = () => {
    let filtered = categories;

    // Search filter
    if (filters.search) {
      filtered = filtered.filter(cat =>
        cat.category.toLowerCase().includes(filters.search.toLowerCase()) ||
        cat.type.toLowerCase().includes(filters.search.toLowerCase()) ||
        cat.subtype.toLowerCase().includes(filters.search.toLowerCase())
      );
    }

    // Category filter
    if (filters.category) {
      filtered = filtered.filter(cat =>
        cat.category.toLowerCase().includes(filters.category.toLowerCase())
      );
    }

    // Type filter
    if (filters.type) {
      filtered = filtered.filter(cat =>
        cat.type.toLowerCase().includes(filters.type.toLowerCase())
      );
    }

    // Subtype filter
    if (filters.subtype) {
      filtered = filtered.filter(cat =>
        cat.subtype.toLowerCase().includes(filters.subtype.toLowerCase())
      );
    }

    setFilteredCategories(filtered);
  };

  // Clear filters
  const clearFilters = () => {
    setFilters({ search: '', category: '', type: '', subtype: '' });
    setFilteredCategories(categories);
  };

  // Get unique values for filter dropdowns
  const getUniqueValues = (field: keyof Category) => {
    return [...new Set(categories.map(cat => cat[field]))].sort();
  };

  // Create category
  const createCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const response = await fetch('/api/categories', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      
      if (response.ok) {
        setFormData({ category: '', type: '', subtype: '' });
        setShowForm(false);
        fetchCategories();
      }
    } catch (error) {
      console.error('Error creating category:', error);
    }
  };

  // Update category
  const updateCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!editingCategory) return;

    try {
      const response = await fetch(`/api/categories/${editingCategory.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData)
      });
      
      if (response.ok) {
        setEditingCategory(null);
        setFormData({ category: '', type: '', subtype: '' });
        setShowForm(false);
        fetchCategories();
      }
    } catch (error) {
      console.error('Error updating category:', error);
    }
  };

  // Delete category
  const deleteCategory = async (id: number) => {
    if (!confirm('Are you sure you want to delete this category?')) return;

    try {
      const response = await fetch(`/api/categories/${id}`, {
        method: 'DELETE'
      });
      
      if (response.ok) {
        fetchCategories();
      }
    } catch (error) {
      console.error('Error deleting category:', error);
    }
  };

  // Start inline editing
  const startInlineEdit = (category: Category) => {
    setEditingId(category.id);
    setEditData({
      category: category.category,
      type: category.type,
      subtype: category.subtype
    });
  };

  // Save inline edit
  const saveInlineEdit = async (id: number) => {
    try {
      const response = await fetch(`/api/categories/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editData)
      });

      if (response.ok) {
        setEditingId(null);
        setEditData({ category: '', type: '', subtype: '' });
        fetchCategories();

        // Show success toast
        setToast({
          message: 'บันทึกข้อมูลสำเร็จ!',
          type: 'success',
          visible: true
        });

        // Auto-hide toast after 3 seconds
        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      } else {
        // Show error toast
        setToast({
          message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
          type: 'error',
          visible: true
        });

        // Auto-hide toast after 3 seconds
        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }
    } catch (error) {
      console.error('Error updating category:', error);

      // Show error toast
      setToast({
        message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
        type: 'error',
        visible: true
      });

      // Auto-hide toast after 3 seconds
      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
    }
  };

  // Save new record
  const saveNewRecord = async () => {
    try {
      const response = await fetch('/api/categories', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newRecordData)
      });

      if (response.ok) {
        setAddingNew(false);
        setNewRecordData({ category: '', type: '', subtype: '' });
        fetchCategories();

        // Show success toast
        setToast({
          message: 'เพิ่มหมวดหมู่ใหม่สำเร็จ!',
          type: 'success',
          visible: true
        });

        // Auto-hide toast after 3 seconds
        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      } else {
        // Show error toast
        setToast({
          message: 'เกิดข้อผิดพลาดในการเพิ่มหมวดหมู่',
          type: 'error',
          visible: true
        });

        // Auto-hide toast after 3 seconds
        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }
    } catch (error) {
      console.error('Error creating category:', error);

      // Show error toast
      setToast({
        message: 'เกิดข้อผิดพลาดในการเพิ่มหมวดหมู่',
        type: 'error',
        visible: true
      });

      // Auto-hide toast after 3 seconds
      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
    }
  };

  // Save bulk records
  const saveBulkRecords = async () => {
    try {
      // Filter out empty records
      const validRecords = bulkRecords.filter(record =>
        record.category.trim() !== '' &&
        record.type.trim() !== '' &&
        record.subtype.trim() !== ''
      );

      if (validRecords.length === 0) {
        setToast({
          message: 'กรุณากรอกข้อมูลอย่างน้อย 1 รายการ',
          type: 'error',
          visible: true
        });
        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
        return;
      }

      // Send all valid records to the API
      const promises = validRecords.map(record =>
        fetch('/api/categories', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            category: record.category.trim(),
            type: record.type.trim(),
            subtype: record.subtype.trim()
          })
        })
      );

      const results = await Promise.allSettled(promises);
      const successful = results.filter(result => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;

      if (successful > 0) {
        setShowBulkForm(false);
        setBulkRecords([]);
        fetchCategories();

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
      console.error('Error saving bulk records:', error);

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
    setEditData({ category: '', type: '', subtype: '' });
  };

  // Cancel form
  const cancelForm = () => {
    setShowForm(false);
    setEditingCategory(null);
    setFormData({ category: '', type: '', subtype: '' });
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  useEffect(() => {
    applyFilters();
  }, [filters, categories]);

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-screen">
        <div className="text-lg">กำลังโหลดหมวดหมู่...</div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-8">
      {/* Toast Notification */}
      {toast.visible && (
        <div className={`fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transition-all duration-300 ${
          toast.type === 'success'
            ? 'bg-green-500 text-white'
            : 'bg-red-500 text-white'
        }`}>
          <div className="flex items-center gap-2">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              {toast.type === 'success' ? (
                <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
              ) : (
                <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
              )}
            </svg>
            <span>{toast.message}</span>
            <button
              onClick={() => setToast({ ...toast, visible: false })}
              className="ml-2 hover:opacity-75"
            >
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
              </svg>
            </button>
          </div>
        </div>
      )}
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">จัดการหมวดหมู่สินค้า</h1>
      </div>

      {/* Form Modal */}
      {showForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-md">
            <h2 className="text-xl font-bold mb-4">
              {editingCategory ? 'แก้ไขหมวดหมู่' : 'เพิ่มหมวดหมู่ใหม่'}
            </h2>
            
            <form onSubmit={editingCategory ? updateCategory : createCategory}>
              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  หมวดหมู่
                </label>
                <input
                  type="text"
                  value={formData.category}
                  onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  required
                />
              </div>

              <div className="mb-4">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  ประเภท
                </label>
                <input
                  type="text"
                  value={formData.type}
                  onChange={(e) => setFormData({ ...formData, type: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  required
                />
              </div>

              <div className="mb-6">
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  ประเภทย่อย
                </label>
                <input
                  type="text"
                  value={formData.subtype}
                  onChange={(e) => setFormData({ ...formData, subtype: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  required
                />
              </div>

              <div className="flex gap-3">
                <button
                  type="submit"
                  className="flex-1 bg-blue-600 text-white py-2 rounded-md hover:bg-blue-700 transition-colors"
                >
                  {editingCategory ? 'อัพเดท' : 'สร้าง'}
                </button>
                <button
                  type="button"
                  onClick={cancelForm}
                  className="flex-1 bg-gray-500 text-white py-2 rounded-md hover:bg-gray-600 transition-colors"
                >
                  ยกเลิก
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Bulk Add Form Modal */}
      {showBulkForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-4xl max-h-[80vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold">เพิ่มหมวดหมู่ใหม่ (5 รายการพร้อมแก้ไข)</h2>
              <button
                onClick={() => {
                  setShowBulkForm(false);
                  setBulkRecords([]);
                }}
                className="text-gray-500 hover:text-gray-700"
              >
                <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
                  <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                </svg>
              </button>
            </div>

            <div className="mb-4">
              <div className="bg-gray-50 rounded-lg overflow-hidden">
                <table className="w-full">
                  <thead className="bg-gray-100">
                    <tr>
                      <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">ลำดับ</th>
                      <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">หมวดหมู่</th>
                      <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">ประเภท</th>
                      <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">ประเภทย่อย</th>
                      <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">จัดการ</th>
                    </tr>
                  </thead>
                  <tbody>
                    {bulkRecords.map((record, index) => (
                      <tr key={record.id} className="border-b border-gray-200">
                        <td className="px-4 py-3 text-sm text-gray-900">{index + 1}</td>
                        <td className="px-4 py-3">
                          <input
                            type="text"
                            value={record.category}
                            onChange={(e) => {
                              const updated = [...bulkRecords];
                              updated[index].category = e.target.value;
                              setBulkRecords(updated);
                            }}
                            placeholder="หมวดหมู่"
                            className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        </td>
                        <td className="px-4 py-3">
                          <input
                            type="text"
                            value={record.type}
                            onChange={(e) => {
                              const updated = [...bulkRecords];
                              updated[index].type = e.target.value;
                              setBulkRecords(updated);
                            }}
                            placeholder="ประเภท"
                            className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        </td>
                        <td className="px-4 py-3">
                          <input
                            type="text"
                            value={record.subtype}
                            onChange={(e) => {
                              const updated = [...bulkRecords];
                              updated[index].subtype = e.target.value;
                              setBulkRecords(updated);
                            }}
                            placeholder="ประเภทย่อย"
                            className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        </td>
                        <td className="px-4 py-3">
                          <div className="flex gap-1">
                            {bulkRecords.length < 5 && (
                              <button
                                onClick={() => {
                                  const newRecord = {
                                    id: Math.max(...bulkRecords.map(r => r.id)) + 1,
                                    category: '',
                                    type: '',
                                    subtype: ''
                                  };
                                  setBulkRecords([...bulkRecords, newRecord]);
                                }}
                                className="text-green-600 hover:text-green-900 p-1"
                                title="เพิ่มแถวใหม่"
                              >
                                <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                  <path fillRule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clipRule="evenodd" />
                                </svg>
                              </button>
                            )}
                            {bulkRecords.length > 1 && (
                              <button
                                onClick={() => {
                                  setBulkRecords(bulkRecords.filter(r => r.id !== record.id));
                                }}
                                className="text-red-600 hover:text-red-900 p-1"
                                title="ลบแถวนี้"
                              >
                                <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                                  <path fillRule="evenodd" d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" clipRule="evenodd" />
                                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clipRule="evenodd" />
                                </svg>
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

            <div className="flex gap-3">
              <button
                onClick={saveBulkRecords}
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

      {/* Filter Section */}
      <div className="bg-white rounded-lg shadow-md p-6 mb-6">
        <h3 className="text-lg font-semibold mb-4">ตัวกรอง</h3>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
          {/* Search Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              ค้นหา
            </label>
            <input
              type="text"
              placeholder="ค้นหาหมวดหมู่..."
              value={filters.search}
              onChange={(e) => setFilters({ ...filters, search: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Category Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              หมวดหมู่
            </label>
            <select
              value={filters.category}
              onChange={(e) => setFilters({ ...filters, category: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">หมวดหมู่ทั้งหมด</option>
              {getUniqueValues('category').map((cat) => (
                <option key={cat} value={cat}>{cat}</option>
              ))}
            </select>
          </div>

          {/* Type Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              ประเภท
            </label>
            <select
              value={filters.type}
              onChange={(e) => setFilters({ ...filters, type: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">ประเภททั้งหมด</option>
              {getUniqueValues('type').map((type) => (
                <option key={type} value={type}>{type}</option>
              ))}
            </select>
          </div>

          {/* Subtype Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              ประเภทย่อย
            </label>
            <select
              value={filters.subtype}
              onChange={(e) => setFilters({ ...filters, subtype: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">ประเภทย่อยทั้งหมด</option>
              {getUniqueValues('subtype').map((subtype) => (
                <option key={subtype} value={subtype}>{subtype}</option>
              ))}
            </select>
          </div>

          {/* Clear Button */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              การดำเนินการ
            </label>
            <button
              onClick={clearFilters}
              className="w-full px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition-colors"
            >
              ล้างตัวกรอง
            </button>
          </div>
        </div>

      </div>

      {/* Results Counter */}
      <div className="mt-4 text-sm text-gray-600">
        แสดง {filteredCategories.length} จาก {categories.length} รายการ
      </div>

      {/* Add New Record Button */}
      <div className="flex justify-end mb-4">
        <button
          onClick={() => {
            setShowBulkForm(true);
            setBulkRecords([
              { id: 1, category: '', type: '', subtype: '' },
              { id: 2, category: '', type: '', subtype: '' },
              { id: 3, category: '', type: '', subtype: '' },
              { id: 4, category: '', type: '', subtype: '' },
              { id: 5, category: '', type: '', subtype: '' }
            ]);
          }}
          className="bg-blue-600 text-white p-3 rounded-full hover:bg-blue-700 transition-colors shadow-lg"
          title="เพิ่มหมวดหมู่ใหม่"
        >
          <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
            <path fillRule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clipRule="evenodd" />
          </svg>
        </button>
      </div>

      {/* Categories Table */}
      <div className="bg-white rounded-lg shadow-md overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full table-auto">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  รหัส
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  หมวดหมู่
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  ประเภท
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  ประเภทย่อย
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  ACTION
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {/* Existing Categories Rows */}
              {filteredCategories.map((cat) => (
                <tr key={cat.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {cat.id}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    {editingId === cat.id ? (
                      <input
                        type="text"
                        value={editData.category}
                        onChange={(e) => setEditData({ ...editData, category: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      cat.category
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    {editingId === cat.id ? (
                      <input
                        type="text"
                        value={editData.type}
                        onChange={(e) => setEditData({ ...editData, type: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      cat.type
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    {editingId === cat.id ? (
                      <input
                        type="text"
                        value={editData.subtype}
                        onChange={(e) => setEditData({ ...editData, subtype: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      cat.subtype
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium w-32">
                    {editingId === cat.id ? (
                      <div className="flex gap-1">
                        <button
                          onClick={() => saveInlineEdit(cat.id)}
                          className="text-green-600 hover:text-green-900 cursor-pointer"
                          title="บันทึก"
                        >
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                            <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                          </svg>
                        </button>
                        <button
                          onClick={() => cancelInlineEdit()}
                          className="text-red-600 hover:text-red-900 cursor-pointer"
                          title="ยกเลิก"
                        >
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                            <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
                          </svg>
                        </button>
                      </div>
                    ) : (
                      <div className="flex gap-2">
                        <button
                          onClick={() => startInlineEdit(cat)}
                          className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                          title="แก้ไข"
                        >
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                          </svg>
                        </button>
                        <button
                          onClick={() => deleteCategory(cat.id)}
                          className="text-red-600 hover:text-red-900 cursor-pointer"
                          title="ลบ"
                        >
                          <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                            <path fillRule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clipRule="evenodd" />
                          </svg>
                        </button>
                      </div>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {filteredCategories.length === 0 && categories.length > 0 && (
          <div className="text-center py-8 text-gray-500">
            ไม่พบหมวดหมู่ที่ตรงกับตัวกรอง กรุณาปรับเกณฑ์การค้นหา
          </div>
        )}

        {categories.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            ไม่พบหมวดหมู่ เพิ่มหมวดหมู่แรกเพื่อเริ่มต้น
          </div>
        )}
      </div>

      <div className="mt-4 text-sm text-gray-600">
        หมวดหมู่ทั้งหมด: {categories.length}
      </div>
    </div>
  );
}
