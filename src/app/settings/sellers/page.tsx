'use client';

import { useState, useEffect, useMemo } from 'react';
import Swal from 'sweetalert2';
import { Store, X, Plus, Trash2, Check, Pencil, CheckCircle2, AlertCircle } from 'lucide-react';

interface Seller {
  id: number;
  code: string;
  prefix?: string;
  name: string;
  business?: string;
  address?: string;
  phone?: string;
  fax?: string;
  mobile?: string;
  is_active?: boolean;
}

export default function SellersPage() {
  const [sellers, setSellers] = useState<Seller[]>([]);
  const [addingNew, setAddingNew] = useState(false);
  const [formData, setFormData] = useState({
    code: '',
    prefix: '',
    name: '',
    business: '',
    address: '',
    phone: '',
    fax: '',
    mobile: '',
    is_active: true
  });
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editData, setEditData] = useState({
    code: '',
    prefix: '',
    name: '',
    business: '',
    address: '',
    phone: '',
    fax: '',
    mobile: '',
    is_active: true
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
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const PAGE_SIZE_OPTIONS = [10, 20, 50];
  const [filters, setFilters] = useState({
    search: ''
  });

  const createEmptySellerRecord = () => ({
    code: '',
    prefix: '',
    name: '',
    business: '',
    address: '',
    phone: '',
    fax: '',
    mobile: '',
    is_active: true
  });

  const createEmptyBulkSellerRecord = () => ({
    id: Date.now() + Math.random(),
    ...createEmptySellerRecord()
  });

  useEffect(() => {
    fetchSellers();
  }, []);

  useEffect(() => {
    // Reset to first page when data changes
    setPage(1);
  }, [sellers.length]);

  const fetchSellers = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/sellers?include_inactive=true');
      const result = await response.json();
      
      if (result.success) {
        setSellers(result.data);
        setError(null);
      } else {
        setError(result.error || 'Failed to fetch sellers');
      }
    } catch (err) {
      setError('Failed to connect to server');
      console.error('Error fetching sellers:', err);
    } finally {
      setLoading(false);
    }
  };

  const openBulkForm = () => {
    setShowBulkForm(true);
    setBulkRecords([createEmptyBulkSellerRecord()]);
  };

  const addBulkRow = () => {
    setBulkRecords((current) => [...current, createEmptyBulkSellerRecord()]);
  };

  const saveNewRecord = async () => {
    if (!formData.code.trim() || !formData.name.trim()) {
      setToast({
        message: 'กรุณากรอกรหัสและชื่อผู้จำหน่าย',
        type: 'error',
        visible: true
      });
      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
      return;
    }

    try {
      const response = await fetch('/api/sellers', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          code: formData.code.trim(),
          prefix: formData.prefix || '',
          name: formData.name.trim(),
          business: formData.business || '',
          address: formData.address || '',
          phone: formData.phone || '',
          fax: formData.fax || '',
          mobile: formData.mobile || '',
          is_active: formData.is_active
        }),
      });

      const result = await response.json();

      if (result.success) {
        await fetchSellers();
        setAddingNew(false);
        resetForm();
        setToast({
          message: 'เพิ่มผู้จำหน่ายใหม่สำเร็จ!',
          type: 'success',
          visible: true
        });
      } else {
        setToast({
          message: result.error || 'เกิดข้อผิดพลาดในการเพิ่มผู้จำหน่าย',
          type: 'error',
          visible: true
        });
      }
      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
    } catch (err) {
      console.error('Error saving seller:', err);
      setToast({
        message: 'เกิดข้อผิดพลาดในการเพิ่มผู้จำหน่าย',
        type: 'error',
        visible: true
      });
      setTimeout(() => {
        setToast({ ...toast, visible: false });
      }, 3000);
    }
  };

  const handleDelete = async (id: number) => {
    const confirmation = await Swal.fire({
      title: 'ลบข้อมูล?',
      text: 'คุณต้องการลบผู้จำหน่ายนี้หรือไม่?',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'ลบ',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
    });

    if (confirmation.isConfirmed) {
      try {
        const response = await fetch(`/api/sellers/${id}`, {
          method: 'DELETE',
        });
        
        const result = await response.json();
        
        if (result.success) {
          await fetchSellers(); // Refresh the list
        } else {
          await Swal.fire('เกิดข้อผิดพลาด', result.error || 'Failed to delete seller', 'error');
        }
      } catch (err) {
        console.error('Error deleting seller:', err);
        await Swal.fire('เกิดข้อผิดพลาด', 'Failed to delete seller', 'error');
      }
    }
  };

  const filteredSellers = useMemo(() => {
    if (!filters.search.trim()) return sellers;
    const keyword = filters.search.trim().toLowerCase();
    return sellers.filter((seller) => {
      const target = [
        seller.code,
        seller.name,
        seller.business,
        seller.address,
        seller.phone,
        seller.mobile
      ]
        .filter(Boolean)
        .join(' ')
        .toLowerCase();
      return target.includes(keyword);
    });
  }, [filters.search, sellers]);

  const totalCount = filteredSellers.length;
  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + pageSize - 1);

  const paginatedSellers = filteredSellers.slice(
    (page - 1) * pageSize,
    (page - 1) * pageSize + pageSize
  );

  const clearFilters = () => {
    setFilters({ search: '' });
    setPage(1);
  };

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) return;
    setPage(newPage);
  };

  const handlePageSizeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    setPageSize(parseInt(e.target.value, 10));
    setPage(1);
  };

  const resetForm = () => {
    setFormData(createEmptySellerRecord());
    setAddingNew(false);
  };

  // Start inline editing
  const startInlineEdit = (seller: Seller) => {
    setEditingId(seller.id);
    setEditData({
      code: seller.code,
      prefix: seller.prefix || '',
      name: seller.name,
      business: seller.business || '',
      address: seller.address || '',
      phone: seller.phone || '',
      fax: seller.fax || '',
      mobile: seller.mobile || '',
      is_active: seller.is_active ?? true
    });
  };

  // Save inline edit
  const saveInlineEdit = async (id: number) => {
    try {
      const response = await fetch(`/api/sellers/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editData)
      });

      if (response.ok) {
        setEditingId(null);
        setEditData(createEmptySellerRecord());
        fetchSellers();

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
      console.error('Error updating seller:', error);

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
    setEditData(createEmptySellerRecord());
  };

  // Save bulk sellers
  const saveBulkSellers = async () => {
    try {
      const validRecords = bulkRecords.filter(record =>
        record.code.trim() !== '' && record.name.trim() !== ''
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
        fetch('/api/sellers', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            code: record.code.trim(),
            prefix: record.prefix || '',
            name: record.name.trim(),
            business: record.business || '',
            address: record.address || '',
            phone: record.phone || '',
            fax: record.fax || '',
            mobile: record.mobile || ''
          })
        })
      );

      const results = await Promise.allSettled(promises);
      const successful = results.filter(result => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;

      if (successful > 0) {
        setShowBulkForm(false);
        setBulkRecords([]);
        fetchSellers();

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
      console.error('Error saving bulk sellers:', error);

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
  return (
    <div className="min-h-screen pt-[52px]">
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
                <X className="h-4 w-4" />
              </button>
            </div>
          </div>
        )}

        {/* Header */}
        <div className="mb-4">
          <h1 className="flex items-center gap-3 text-2xl font-semibold text-gray-900">
            <Store className="h-7 w-7 text-blue-600" />
            จัดการผู้จำหน่าย
          </h1>
        </div>

        <div className="mb-4 rounded-lg border border-slate-200 bg-white p-4 shadow-sm">
          <div className="grid grid-cols-1 gap-3 md:grid-cols-[minmax(0,1fr)_220px]">
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">ค้นหา</label>
              <input
                type="text"
                placeholder="ค้นหาจากรหัส ชื่อ หรือคำอธิบาย"
                value={filters.search}
                onChange={(e) => {
                  setFilters({ search: e.target.value });
                  setPage(1);
                }}
                className="w-full rounded-md border border-gray-300 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="mb-1 block text-sm font-medium text-gray-700">รีเซ็ต</label>
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
              setFormData(createEmptySellerRecord());
            }}
            disabled={addingNew}
            className="rounded-md bg-blue-600 px-3 py-2 text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
            title="เพิ่มผู้จำหน่ายใหม่"
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

        <div className="overflow-hidden rounded-lg border border-slate-200 bg-white shadow-sm">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">รหัส</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">ชื่อผู้จำหน่าย</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">ประเภทธุรกิจ</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">เบอร์โทร</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">มือถือ</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">เปิดใช้งาน</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider">ACTION</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {addingNew && (
                  <tr className="bg-blue-50/60">
                    <td className="px-6 py-4 whitespace-nowrap text-xs font-medium text-gray-900">
                      <input
                        type="text"
                        value={formData.code}
                        onChange={(e) => setFormData({ ...formData, code: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="รหัส"
                      />
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="space-y-2">
                        <div className="grid grid-cols-1 gap-2 md:grid-cols-2">
                          <input
                            type="text"
                            value={formData.prefix}
                            onChange={(e) => setFormData({ ...formData, prefix: e.target.value })}
                            className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="คำนำหน้า"
                          />
                          <input
                            type="text"
                            value={formData.name}
                            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                            className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                            placeholder="ชื่อผู้จำหน่าย"
                          />
                        </div>
                        <textarea
                          value={formData.address}
                          onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                          className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs resize-none"
                          rows={2}
                          placeholder="ที่อยู่"
                        />
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-500">
                      <input
                        type="text"
                        value={formData.business}
                        onChange={(e) => setFormData({ ...formData, business: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="ประเภทธุรกิจ"
                      />
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-500">
                      <input
                        type="tel"
                        value={formData.phone}
                        onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="เบอร์โทร"
                      />
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-500">
                      <input
                        type="tel"
                        value={formData.mobile}
                        onChange={(e) => setFormData({ ...formData, mobile: e.target.value })}
                        className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                        placeholder="มือถือ"
                      />
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                      <input
                        type="checkbox"
                        checked={formData.is_active}
                        onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                        className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
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
                          onClick={resetForm}
                          className="text-red-600 hover:text-red-900 cursor-pointer"
                          title="ยกเลิก"
                        >
                          <X className="h-4 w-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                )}
                {paginatedSellers.map((seller) => (
                  <tr key={seller.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap text-xs font-medium text-gray-900">
                      {seller.code}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div>
                        <div className="text-xs font-medium text-gray-900">
                          {editingId === seller.id ? (
                            <input
                              type="text"
                              value={editData.name}
                              onChange={(e) => setEditData({ ...editData, name: e.target.value })}
                              className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                            />
                          ) : (
                            `${seller.prefix || ''} ${seller.name}`.trim()
                          )}
                        </div>
                        <div className="text-xs text-gray-500">
                          {editingId === seller.id ? (
                            <textarea
                              value={editData.address || ''}
                              onChange={(e) => setEditData({ ...editData, address: e.target.value })}
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs resize-none"
                              rows={2}
                            />
                          ) : (
                            seller.address
                          )}
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-500">
                      {editingId === seller.id ? (
                        <input
                          type="text"
                          value={editData.business || ''}
                          onChange={(e) => setEditData({ ...editData, business: e.target.value })}
                          className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      ) : (
                        seller.business
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-500">
                      {editingId === seller.id ? (
                        <input
                          type="tel"
                          value={editData.phone || ''}
                          onChange={(e) => setEditData({ ...editData, phone: e.target.value })}
                          className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      ) : (
                        seller.phone
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-500">
                      {editingId === seller.id ? (
                        <input
                          type="tel"
                          value={editData.mobile || ''}
                          onChange={(e) => setEditData({ ...editData, mobile: e.target.value })}
                          className="w-full px-2 py-1 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                      ) : (
                        seller.mobile
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs text-gray-900">
                      {editingId === seller.id ? (
                        <input
                          type="checkbox"
                          checked={Boolean(editData.is_active)}
                          onChange={(e) => setEditData({ ...editData, is_active: e.target.checked })}
                          className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                        />
                      ) : (
                        <input
                          type="checkbox"
                          checked={Boolean(seller.is_active)}
                          readOnly
                          className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                        />
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-xs font-medium w-32">
                      {editingId === seller.id ? (
                        <div className="flex gap-1">
                          <button
                            onClick={() => saveInlineEdit(seller.id)}
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
                            onClick={() => startInlineEdit(seller)}
                            className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                            title="แก้ไข"
                          >
                            <Pencil className="h-5 w-5" />
                          </button>
                          <button
                            onClick={() => handleDelete(seller.id)}
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
        </div>

      </div>

      {/* Bulk Add Sellers Modal */}
      {showBulkForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-6xl max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <div>
                <h2 className="text-xl font-bold">Bulk insert ผู้จำหน่าย</h2>
                <p className="mt-1 text-sm text-gray-500">เพิ่มหลายรายการพร้อมกัน และกดปุ่ม + เพื่อเพิ่มแถวได้ตามต้องการ</p>
              </div>
              <button
                onClick={() => {
                  setShowBulkForm(false);
                  setBulkRecords([]);
                }}
                className="text-gray-500 hover:text-gray-700"
              >
                <X className="h-6 w-6" />
              </button>
            </div>

            <div className="mb-4">
              <div className="bg-gray-50 rounded-lg overflow-hidden">
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-gray-100">
                      <tr>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ลำดับ</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">รหัส</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">คำนำหน้า</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ชื่อผู้จำหน่าย</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ประเภทธุรกิจ</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">ที่อยู่</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">เบอร์โทร</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">มือถือ</th>
                        <th className="px-2 py-2 text-left text-[10px] font-medium text-gray-500 uppercase">จัดการ</th>
                      </tr>
                    </thead>
                    <tbody>
                      {bulkRecords.map((record, index) => (
                        <tr key={record.id} className="border-b border-gray-200">
                          <td className="px-2 py-3 text-xs text-gray-900">{index + 1}</td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.code || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].code = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="รหัส"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.prefix || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].prefix = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="คำนำหน้า"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.name || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].name = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ชื่อผู้จำหน่าย"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.business || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].business = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ประเภทธุรกิจ"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <textarea
                              value={record.address || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].address = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ที่อยู่"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs resize-none"
                              rows={2}
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="tel"
                              value={record.phone || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].phone = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="เบอร์โทร"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="tel"
                              value={record.mobile || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].mobile = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="มือถือ"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-xs"
                            />
                          </td>
                          <td className="px-2 py-3">
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
                                  <Trash2 className="h-4 w-4" />
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
                onClick={saveBulkSellers}
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

    </div>
  );
}
