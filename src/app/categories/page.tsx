'use client';

import { useState, useEffect } from 'react';
import Swal from 'sweetalert2';
import { Plus, Check, X, Pencil, Trash2 } from 'lucide-react';

interface Category {
  id: number;
  category_code: string;
  category: string;
  type: string;
  subtype: string;
}

export default function CategoriesPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [filteredCategories, setFilteredCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(true);
  const [formData, setFormData] = useState({
    category_code: '',
    category: '',
    type: '',
    subtype: ''
  });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editData, setEditData] = useState({
    category_code: '',
    category: '',
    type: '',
    subtype: ''
  });
  const [addingNew, setAddingNew] = useState(false);
  const [newRecordData, setNewRecordData] = useState({
    category_code: '',
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
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const PAGE_SIZE_OPTIONS = [10, 20, 50];

  const createEmptyCategoryRecord = () => ({
    category_code: '',
    category: '',
    type: '',
    subtype: ''
  });

  const createEmptyBulkCategoryRecord = () => ({
    id: Date.now() + Math.random(),
    ...createEmptyCategoryRecord()
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
        String(cat.category_code || '').toLowerCase().includes(filters.search.toLowerCase()) ||
        String(cat.category || '').toLowerCase().includes(filters.search.toLowerCase()) ||
        String(cat.type || '').toLowerCase().includes(filters.search.toLowerCase()) ||
        String(cat.subtype || '').toLowerCase().includes(filters.search.toLowerCase())
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
    setPage(1);
  };

  // Clear filters
  const clearFilters = () => {
    setFilters({ search: '', category: '', type: '', subtype: '' });
    setFilteredCategories(categories);
  };

  const openBulkForm = () => {
    setShowBulkForm(true);
    setBulkRecords([createEmptyBulkCategoryRecord()]);
  };

  const addBulkRow = () => {
    setBulkRecords((current) => [...current, createEmptyBulkCategoryRecord()]);
  };

  // Get unique values for filter dropdowns
  const getUniqueValues = (field: keyof Category) => {
    return [...new Set(categories.map(cat => cat[field]))].sort();
  };

  const filteredTypeOptions = [...new Set(
    categories
      .filter((cat) => !filters.category || cat.category === filters.category)
      .map((cat) => cat.type)
      .filter(Boolean)
  )].sort();

  const filteredSubtypeOptions = [...new Set(
    categories
      .filter((cat) => (!filters.category || cat.category === filters.category) && (!filters.type || cat.type === filters.type))
      .map((cat) => cat.subtype)
      .filter(Boolean)
  )].sort();

  // Delete category
  const deleteCategory = async (id: number) => {
    const confirmation = await Swal.fire({
      title: 'Delete category?',
      text: 'Are you sure you want to delete this category?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'Delete',
      cancelButtonText: 'Cancel',
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
    });
    if (!confirmation.isConfirmed) return;

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
      category_code: category.category_code,
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
        setEditData({ category_code: '', category: '', type: '', subtype: '' });
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
    if (
      !newRecordData.category_code.trim() ||
      !newRecordData.category.trim() ||
      !newRecordData.type.trim() ||
      !newRecordData.subtype.trim()
    ) {
      setToast({
        message: 'กรุณากรอกข้อมูลให้ครบถ้วน',
        type: 'error',
        visible: true
      });
      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
      return;
    }

    try {
      const response = await fetch('/api/categories', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          category_code: newRecordData.category_code.trim(),
          category: newRecordData.category.trim(),
          type: newRecordData.type.trim(),
          subtype: newRecordData.subtype.trim()
        })
      });

      if (response.ok) {
        setAddingNew(false);
        setNewRecordData({ category_code: '', category: '', type: '', subtype: '' });
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
        record.category_code.trim() !== '' &&
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
            category_code: record.category_code.trim(),
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
    setEditData({ category_code: '', category: '', type: '', subtype: '' });
  };

  const cancelNewRecord = () => {
    setAddingNew(false);
    setNewRecordData(createEmptyCategoryRecord());
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  useEffect(() => {
    applyFilters();
  }, [filters, categories]);

  const totalCount = filteredCategories.length;
  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + pageSize - 1);

  const paginatedCategories = filteredCategories.slice(
    (page - 1) * pageSize,
    (page - 1) * pageSize + pageSize
  );

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) return;
    setPage(newPage);
  };

  const handlePageSizeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPageSize(parseInt(e.target.value, 10));
    setPage(1);
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-screen">
        <div className="text-lg">กำลังโหลดหมวดหมู่...</div>
      </div>
    );
  }

  return (
    <div className="container mx-auto px-4 py-6">
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
      <div className="mb-4">
        <h1 className="text-2xl font-semibold text-gray-900">จัดการหมวดสินค้า</h1>
      </div>

      {/* Bulk Add Form Modal */}
      {showBulkForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-4xl max-h-[80vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <div>
                <h2 className="text-xl font-bold">Bulk insert หมวดสินค้า</h2>
                <p className="mt-1 text-sm text-gray-500">เพิ่มหลายรายการพร้อมกัน และกดปุ่ม + เพื่อเพิ่มแถวได้ตามต้องการ</p>
              </div>
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
                      <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">รหัสหมวด</th>
                      <th className="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">หมวด</th>
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
                            value={record.category_code}
                            onChange={(e) => {
                              const updated = [...bulkRecords];
                              updated[index].category_code = e.target.value;
                              setBulkRecords(updated);
                            }}
                            placeholder="รหัสหมวด"
                            className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                          />
                        </td>
                        <td className="px-4 py-3">
                          <input
                            type="text"
                            value={record.category}
                            onChange={(e) => {
                              const updated = [...bulkRecords];
                              updated[index].category = e.target.value;
                              setBulkRecords(updated);
                            }}
                            placeholder="หมวด"
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
                            <button
                              onClick={addBulkRow}
                              className="text-green-600 hover:text-green-900 p-1"
                              title="เพิ่มแถวใหม่"
                            >
                              <Plus className="h-4 w-4" />
                            </button>
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
      <div className="mb-4 rounded-lg border border-slate-200 bg-white p-4 shadow-sm">
        <div className="grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-5">
          {/* Search Filter */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              ค้นหา
            </label>
            <input
              type="text"
              placeholder="ค้นหารหัสหมวด / หมวด / ประเภท / ประเภทย่อย..."
              value={filters.search}
              onChange={(e) => setFilters({ ...filters, search: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Category Filter */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              หมวด
            </label>
            <select
              value={filters.category}
              onChange={(e) => setFilters({ ...filters, category: e.target.value, type: '', subtype: '' })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">หมวด</option>
              {getUniqueValues('category').map((cat) => (
                <option key={cat} value={cat}>{cat}</option>
              ))}
            </select>
          </div>

          {/* Type Filter */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              ประเภท
            </label>
            <select
              value={filters.type}
              onChange={(e) => setFilters({ ...filters, type: e.target.value, subtype: '' })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">ประเภท</option>
              {filteredTypeOptions.map((type) => (
                <option key={type} value={type}>{type}</option>
              ))}
            </select>
          </div>

          {/* Subtype Filter */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              ประเภทย่อย
            </label>
            <select
              value={filters.subtype}
              onChange={(e) => setFilters({ ...filters, subtype: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">ประเภทย่อย</option>
              {filteredSubtypeOptions.map((subtype) => (
                <option key={subtype} value={subtype}>{subtype}</option>
              ))}
            </select>
          </div>

          {/* Clear Button */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              รีเซ็ต
            </label>
            <button
              onClick={clearFilters}
              className="w-full rounded-md bg-slate-600 px-4 py-2 text-white transition-colors hover:bg-slate-700"
            >
              ล้างตัวกรอง
            </button>
          </div>
        </div>
      </div>

      <div className="mb-4 flex items-center justify-end gap-2">
        <button
          onClick={openBulkForm}
          className="rounded-md border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition-colors hover:bg-slate-50"
        >
          Bulk insert
        </button>
        <button
          onClick={() => {
            setAddingNew(true);
            setNewRecordData(createEmptyCategoryRecord());
          }}
          disabled={addingNew}
          className="rounded-md bg-blue-600 px-3 py-2 text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
          title="เพิ่มหมวดใหม่"
        >
          <Plus className="h-5 w-5" />
        </button>
      </div>

      {/* Pagination Controls (survey-style) */}
      <div className="mb-4 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
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
              {PAGE_SIZE_OPTIONS.map((size) => (
                <option key={size} value={size}>{size}</option>
              ))}
            </select>
          </div>
          <div className="flex items-center gap-2">
            <button
              onClick={() => goToPage(page - 1)}
              disabled={page === 1}
              className={`px-3 py-1 rounded border text-sm ${page === 1 ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-50'}`}
            >
              ก่อนหน้า
            </button>
            <span className="text-sm text-gray-700">
              หน้า {page} / {totalPages}
            </span>
            <button
              onClick={() => goToPage(page + 1)}
              disabled={page === totalPages || totalCount === 0}
              className={`px-3 py-1 rounded border text-sm ${page === totalPages || totalCount === 0 ? 'text-gray-400 border-gray-200 cursor-not-allowed' : 'text-gray-700 border-gray-300 hover:bg-gray-50'}`}
            >
              ถัดไป
            </button>
          </div>
        </div>
      </div>

      {/* Categories Table */}
      <div className="overflow-hidden rounded-lg border border-slate-200 bg-white shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full table-auto">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">
                  ลำดับที่
                </th>
                <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">
                  รหัสหมวด
                </th>
                <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">
                  หมวด
                </th>
                <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">
                  ประเภท
                </th>
                <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">
                  ประเภทย่อย
                </th>
                <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">
                  ACTION
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {addingNew && (
                <tr className="bg-blue-50/60">
                  <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-500">ใหม่</td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs">
                    <input
                      type="text"
                      value={newRecordData.category_code}
                      onChange={(e) => setNewRecordData({ ...newRecordData, category_code: e.target.value })}
                      className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="รหัสหมวด"
                    />
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs">
                    <input
                      type="text"
                      value={newRecordData.category}
                      onChange={(e) => setNewRecordData({ ...newRecordData, category: e.target.value })}
                      className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="หมวด"
                    />
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs">
                    <input
                      type="text"
                      value={newRecordData.type}
                      onChange={(e) => setNewRecordData({ ...newRecordData, type: e.target.value })}
                      className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ประเภท"
                    />
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs">
                    <input
                      type="text"
                      value={newRecordData.subtype}
                      onChange={(e) => setNewRecordData({ ...newRecordData, subtype: e.target.value })}
                      className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ประเภทย่อย"
                    />
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs font-medium w-32">
                    <div className="flex gap-1">
                      <button
                        onClick={saveNewRecord}
                        className="text-green-600 hover:text-green-900 cursor-pointer"
                        title="บันทึก"
                      >
                        <Check className="h-4 w-4" />
                      </button>
                      <button
                        onClick={cancelNewRecord}
                        className="text-red-600 hover:text-red-900 cursor-pointer"
                        title="ยกเลิก"
                      >
                        <X className="h-4 w-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              )}
              {paginatedCategories.map((cat) => (
                <tr key={cat.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                    {cat.id}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                    {editingId === cat.id ? (
                      <input
                        type="text"
                        value={editData.category_code}
                        onChange={(e) => setEditData({ ...editData, category_code: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      cat.category_code
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs">
                    {editingId === cat.id ? (
                      <input
                        type="text"
                        value={editData.category}
                        onChange={(e) => setEditData({ ...editData, category: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      cat.category
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs">
                    {editingId === cat.id ? (
                      <input
                        type="text"
                        value={editData.type}
                        onChange={(e) => setEditData({ ...editData, type: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      cat.type
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs">
                    {editingId === cat.id ? (
                      <input
                        type="text"
                        value={editData.subtype}
                        onChange={(e) => setEditData({ ...editData, subtype: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      cat.subtype
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-xs font-medium w-32">
                    {editingId === cat.id ? (
                      <div className="flex gap-1">
                        <button
                          onClick={() => saveInlineEdit(cat.id)}
                          className="text-green-600 hover:text-green-900 cursor-pointer"
                          title="บันทึก"
                        >
                          <Check className="h-4 w-4" />
                        </button>
                        <button
                          onClick={() => cancelInlineEdit()}
                          className="text-red-600 hover:text-red-900 cursor-pointer"
                          title="ยกเลิก"
                        >
                          <X className="h-4 w-4" />
                        </button>
                      </div>
                    ) : (
                      <div className="flex gap-2">
                        <button
                          onClick={() => startInlineEdit(cat)}
                          className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                          title="แก้ไข"
                        >
                          <Pencil className="h-5 w-5" />
                        </button>
                        <button
                          onClick={() => deleteCategory(cat.id)}
                          className="text-red-600 hover:text-red-900 cursor-pointer"
                          title="ลบ"
                        >
                          <Trash2 className="h-5 w-5" />
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
            ไม่พบข้อมูลตามตัวกรอง
          </div>
        )}

        {categories.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            ไม่พบหมวดสินค้า เพิ่มหมวดแรกเพื่อเริ่มต้น
          </div>
        )}
      </div>

      <div className="mt-4 text-sm text-gray-600">
        หมวดทั้งหมด: {categories.length}
      </div>
    </div>
  );
}
