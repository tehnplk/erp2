'use client';

import { useState, useEffect } from 'react';
import Swal from 'sweetalert2';
import { Plus, Check, X, Pencil, Trash2, CheckCircle2, AlertCircle, X as XIcon } from 'lucide-react';

interface Department {
  id: number;
  name: string;
}

export default function DepartmentsPage() {
  const [departments, setDepartments] = useState<Department[]>([]);
  const [filteredDepartments, setFilteredDepartments] = useState<Department[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    name: ''
  });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editData, setEditData] = useState({
    name: ''
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
    search: ''
  });
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const PAGE_SIZE_OPTIONS = [10, 20, 50];

  const createEmptyDepartmentRecord = () => ({
    name: ''
  });

  const createEmptyBulkDepartmentRecord = () => ({
    id: Date.now() + Math.random(),
    ...createEmptyDepartmentRecord()
  });

  const fetchDepartments = async () => {
    try {
      const response = await fetch('/api/departments');
      if (response.ok) {
        const json = await response.json();
        const items: Department[] = Array.isArray(json)
          ? json
          : (Array.isArray(json?.data) ? json.data : []);
        setDepartments(items);
      } else {
        const errorData = await response.json().catch(() => ({}));
        console.error('Failed to fetch departments:', {
          status: response.status,
          statusText: response.statusText,
          error: errorData
        });
      }
    } catch (error) {
      console.error('Error fetching departments:', error);
    } finally {
      setLoading(false);
    }
  };

  const saveNewRecord = async () => {
    if (!formData.name.trim()) {
      setToast({
        message: 'กรุณากรอกชื่อแผนก',
        type: 'error',
        visible: true
      });

      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
      return;
    }

    try {
      const response = await fetch('/api/departments', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ name: formData.name.trim() }),
      });

      if (response.ok) {
        await fetchDepartments();
        setShowForm(false);
        setFormData(createEmptyDepartmentRecord());

        setToast({
          message: 'เพิ่มแผนกใหม่สำเร็จ!',
          type: 'success',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      } else {
        setToast({
          message: 'เกิดข้อผิดพลาดในการเพิ่มแผนก',
          type: 'error',
          visible: true
        });

        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
      }
    } catch (error) {
      console.error('Error creating department:', error);

      setToast({
        message: 'เกิดข้อผิดพลาดในการเพิ่มแผนก',
        type: 'error',
        visible: true
      });

      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
    }
  };

  // Apply filters
  const applyFilters = () => {
    let filtered: Department[] = Array.isArray(departments) ? departments : [];

    // Search filter
    if (filters.search) {
      filtered = filtered.filter(dept =>
        dept.name.toLowerCase().includes(filters.search.toLowerCase())
      );
    }

    setFilteredDepartments(filtered);
    setPage(1);
  };

  // Clear all filters
  const clearFilters = () => {
    setFilters({
      search: ''
    });
  };

  const openBulkForm = () => {
    setShowBulkForm(true);
    setBulkRecords([createEmptyBulkDepartmentRecord()]);
  };

  const addBulkRow = () => {
    setBulkRecords((current) => [...current, createEmptyBulkDepartmentRecord()]);
  };

  // Delete department
  const deleteDepartment = async (id: number) => {
    const confirmation = await Swal.fire({
      title: 'ลบข้อมูล?',
      text: 'คุณแน่ใจหรือไม่ที่จะลบแผนกนี้?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'ลบ',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
    });
    if (confirmation.isConfirmed) {
      try {
        const response = await fetch(`/api/departments/${id}`, {
          method: 'DELETE',
        });

        if (response.ok) {
          await fetchDepartments();
        } else {
          console.error('Failed to delete department');
        }
      } catch (error) {
        console.error('Error deleting department:', error);
      }
    }
  };

  // Start inline editing
  const startInlineEdit = (department: Department) => {
    setEditingId(department.id);
    setEditData({
      name: department.name
    });
  };

  // Save inline edit
  const saveInlineEdit = async (id: number) => {
    try {
      const response = await fetch(`/api/departments/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editData)
      });

      if (response.ok) {
        setEditingId(null);
        setEditData({ name: '' });
        fetchDepartments();

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
      console.error('Error updating department:', error);

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
    setEditData({ name: '' });
  };

  // Save bulk departments
  const saveBulkDepartments = async () => {
    try {
      const validRecords = bulkRecords.filter(record => record.name.trim() !== '');

      if (validRecords.length === 0) {
        setToast({
          message: 'กรุณากรอกชื่อแผนกอย่างน้อย 1 รายการ',
          type: 'error',
          visible: true
        });
        setTimeout(() => {
          setToast({ ...toast, visible: false });
        }, 3000);
        return;
      }

      const promises = validRecords.map(record =>
        fetch('/api/departments', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            name: record.name.trim()
          })
        })
      );

      const results = await Promise.allSettled(promises);
      const successful = results.filter(result => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;

      if (successful > 0) {
        setShowBulkForm(false);
        setBulkRecords([]);
        fetchDepartments();

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
      console.error('Error saving bulk departments:', error);

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

  // Cancel form
  const cancelForm = () => {
    setShowForm(false);
    setFormData({ name: '' });
  };

  // Initialize data on component mount
  useEffect(() => {
    fetchDepartments();
  }, []);

  useEffect(() => {
    applyFilters();
  }, [filters, departments]);

  const totalCount = filteredDepartments.length;
  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + pageSize - 1);

  const paginatedDepartments = filteredDepartments.slice(
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
        <div className="text-lg">กำลังโหลดแผนก...</div>
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

      <div className="mb-4">
        <h1 className="text-2xl font-semibold text-gray-900">จัดการแผนก</h1>
      </div>

      {/* Bulk Add Departments Modal */}
      {showBulkForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-2xl max-h-[80vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <div>
                <h2 className="text-xl font-bold">Bulk insert แผนก</h2>
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
                      <th className="px-4 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ลำดับ</th>
                      <th className="px-4 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ชื่อแผนก</th>
                      <th className="px-4 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">จัดการ</th>
                    </tr>
                  </thead>
                  <tbody>
                    {bulkRecords.map((record, index) => (
                      <tr key={record.id} className="border-b border-gray-200">
                        <td className="px-4 py-3 text-xs text-gray-900">{index + 1}</td>
                        <td className="px-4 py-3">
                          <input
                            type="text"
                            value={record.name || ''}
                            onChange={(e) => {
                              const updated = [...bulkRecords];
                              updated[index].name = e.target.value;
                              setBulkRecords(updated);
                            }}
                            placeholder="ชื่อแผนก"
                            className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
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
                onClick={saveBulkDepartments}
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
        <div className="grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-[minmax(0,1fr)_220px]">
          {/* Search Filter */}
          <div>
            <label className="mb-1 block text-sm font-medium text-gray-700">
              ค้นหา
            </label>
            <input
              type="text"
              placeholder="ค้นหาแผนก..."
              value={filters.search}
              onChange={(e) => setFilters({ ...filters, search: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
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
            setShowForm(true);
            setFormData(createEmptyDepartmentRecord());
          }}
          disabled={showForm}
          className="rounded-md bg-blue-600 px-3 py-2 text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
          title="เพิ่มแผนกใหม่"
        >
          <Plus className="h-5 w-5" />
        </button>
      </div>

      {/* Pagination Controls */}
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

      {/* Departments Table */}
      <div className="overflow-hidden rounded-lg border border-slate-200 bg-white shadow-sm">
        <div className="overflow-x-auto">
          <table className="w-full table-auto">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  รหัส
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  ชื่อแผนก
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  ACTION
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {showForm && (
                <tr className="bg-blue-50/60">
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">ใหม่</td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    <input
                      type="text"
                      value={formData.name}
                      onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                      className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="ชื่อแผนก"
                    />
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium w-32">
                    <div className="flex gap-1">
                      <button
                        onClick={saveNewRecord}
                        className="text-green-600 hover:text-green-900 cursor-pointer"
                        title="บันทึก"
                      >
                        <Check className="h-4 w-4" />
                      </button>
                      <button
                        onClick={cancelForm}
                        className="text-red-600 hover:text-red-900 cursor-pointer"
                        title="ยกเลิก"
                      >
                        <X className="h-4 w-4" />
                      </button>
                    </div>
                  </td>
                </tr>
              )}
              {paginatedDepartments.map((dept) => (
                <tr key={dept.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                    {dept.id}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm">
                    {editingId === dept.id ? (
                      <input
                        type="text"
                        value={editData.name}
                        onChange={(e) => setEditData({ ...editData, name: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                      />
                    ) : (
                      dept.name
                    )}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium w-32">
                    {editingId === dept.id ? (
                      <div className="flex gap-1">
                        <button
                          onClick={() => saveInlineEdit(dept.id)}
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
                          onClick={() => startInlineEdit(dept)}
                          className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                          title="แก้ไข"
                        >
                          <Pencil className="h-5 w-5" />
                        </button>
                        <button
                          onClick={() => deleteDepartment(dept.id)}
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

        {filteredDepartments.length === 0 && departments.length > 0 && (
          <div className="text-center py-8 text-gray-500">
            ไม่พบข้อมูลตามตัวกรอง
          </div>
        )}

        {departments.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            ไม่พบแผนก เพิ่มแผนกแรกเพื่อเริ่มต้น
          </div>
        )}
      </div>

      <div className="mt-4 pb-8 text-sm text-gray-600">
        แผนกทั้งหมด: {departments.length}
      </div>
    </div>
  );
}
