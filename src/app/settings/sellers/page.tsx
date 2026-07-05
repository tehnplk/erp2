'use client';

import { useEffect, useMemo, useState } from 'react';
import Swal from 'sweetalert2';
import { AlertCircle, CheckCircle2, Pencil, Plus, Save, Store, Trash2, X } from 'lucide-react';
import { useAllowedActions } from '@/hooks/use-allowed-actions';

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
  category_code_sale?: string[];
  is_active?: boolean;
}

interface CategoryOption {
  category_code: string;
  category: string;
}

type SellerFormData = {
  code: string;
  prefix: string;
  name: string;
  business: string;
  address: string;
  phone: string;
  fax: string;
  mobile: string;
  category_code_sale: string[];
  is_active: boolean;
};

const PAGE_SIZE_OPTIONS = [10, 20, 50];

const createEmptySellerRecord = (): SellerFormData => ({
  code: '',
  prefix: '',
  name: '',
  business: '',
  address: '',
  phone: '',
  fax: '',
  mobile: '',
  category_code_sale: [],
  is_active: true,
});

export default function SellersPage() {
  const { canCreate, canEdit, canDelete } = useAllowedActions('/sellers');
  const [sellers, setSellers] = useState<Seller[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<CategoryOption[]>([]);
  const [formData, setFormData] = useState<SellerFormData>(createEmptySellerRecord());
  const [modalMode, setModalMode] = useState<'create' | 'edit'>('create');
  const [editingSellerId, setEditingSellerId] = useState<number | null>(null);
  const [showSellerModal, setShowSellerModal] = useState(false);
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<{
    message: string;
    type: 'success' | 'error';
    visible: boolean;
  }>({
    message: '',
    type: 'success',
    visible: false,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const [filters, setFilters] = useState({ search: '' });

  useEffect(() => {
    void fetchSellers();
    void fetchCategoryOptions();
  }, []);

  useEffect(() => {
    setPage(1);
  }, [sellers.length]);

  const showToast = (message: string, type: 'success' | 'error') => {
    setToast({ message, type, visible: true });
    setTimeout(() => {
      setToast((current) => ({ ...current, visible: false }));
    }, 3000);
  };

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

  const fetchCategoryOptions = async () => {
    try {
      const response = await fetch('/api/categories?include_inactive=true');
      const result = await response.json();
      if (!result.success || !Array.isArray(result.data)) return;

      const uniqueOptions = new Map<string, CategoryOption>();
      result.data.forEach((item: CategoryOption) => {
        const code = String(item.category_code || '').trim();
        if (!code || uniqueOptions.has(code)) return;
        uniqueOptions.set(code, {
          category_code: code,
          category: item.category || code,
        });
      });
      setCategoryOptions(Array.from(uniqueOptions.values()).sort((a, b) => a.category_code.localeCompare(b.category_code)));
    } catch (err) {
      console.error('Error fetching category options:', err);
    }
  };

  const openCreateModal = () => {
    if (!canCreate) return;
    setModalMode('create');
    setEditingSellerId(null);
    setFormData(createEmptySellerRecord());
    setShowSellerModal(true);
  };

  const openEditModal = (seller: Seller) => {
    if (!canEdit) return;
    setModalMode('edit');
    setEditingSellerId(seller.id);
    setFormData({
      code: seller.code,
      prefix: seller.prefix || '',
      name: seller.name,
      business: seller.business || '',
      address: seller.address || '',
      phone: seller.phone || '',
      fax: seller.fax || '',
      mobile: seller.mobile || '',
      category_code_sale: Array.isArray(seller.category_code_sale) ? seller.category_code_sale : [],
      is_active: seller.is_active ?? true,
    });
    setShowSellerModal(true);
  };

  const closeSellerModal = () => {
    setShowSellerModal(false);
    setEditingSellerId(null);
    setFormData(createEmptySellerRecord());
  };

  const saveSeller = async () => {
    if ((modalMode === 'create' && !canCreate) || (modalMode === 'edit' && !canEdit)) return;

    if (!formData.code.trim() || !formData.name.trim()) {
      showToast('กรุณากรอกรหัสและชื่อผู้จำหน่าย', 'error');
      return;
    }

    try {
      setSaving(true);
      const url = modalMode === 'create' ? '/api/sellers' : `/api/sellers/${editingSellerId}`;
      const response = await fetch(url, {
        method: modalMode === 'create' ? 'POST' : 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          code: formData.code.trim(),
          prefix: formData.prefix || '',
          name: formData.name.trim(),
          business: formData.business || '',
          address: formData.address || '',
          phone: formData.phone || '',
          fax: formData.fax || '',
          mobile: formData.mobile || '',
          category_code_sale: formData.category_code_sale,
          is_active: formData.is_active,
        }),
      });

      const result = await response.json().catch(() => null);
      if (!response.ok || !result?.success) {
        throw new Error(result?.error || 'Failed to save seller');
      }

      await fetchSellers();
      closeSellerModal();
      showToast(modalMode === 'create' ? 'เพิ่มผู้จำหน่ายสำเร็จ' : 'บันทึกข้อมูลสำเร็จ', 'success');
    } catch (err) {
      console.error('Error saving seller:', err);
      showToast(err instanceof Error ? err.message : 'เกิดข้อผิดพลาดในการบันทึกข้อมูล', 'error');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (id: number) => {
    if (!canDelete) return;
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

    if (!confirmation.isConfirmed) return;

    try {
      const response = await fetch(`/api/sellers/${id}`, { method: 'DELETE' });
      const result = await response.json();

      if (result.success) {
        await fetchSellers();
        showToast('ลบผู้จำหน่ายสำเร็จ', 'success');
      } else {
        await Swal.fire('เกิดข้อผิดพลาด', result.error || 'Failed to delete seller', 'error');
      }
    } catch (err) {
      console.error('Error deleting seller:', err);
      await Swal.fire('เกิดข้อผิดพลาด', 'Failed to delete seller', 'error');
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
        seller.mobile,
        ...(seller.category_code_sale || []),
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
  const paginatedSellers = filteredSellers.slice((page - 1) * pageSize, (page - 1) * pageSize + pageSize);

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

  const toggleCategoryCode = (selectedCodes: string[], code: string, checked: boolean) => {
    const next = new Set(selectedCodes);
    if (checked) {
      next.add(code);
    } else {
      next.delete(code);
    }
    return Array.from(next).sort((a, b) => a.localeCompare(b));
  };

  const categoryNameByCode = useMemo(() => {
    return new Map(categoryOptions.map((option) => [option.category_code, option.category || option.category_code]));
  }, [categoryOptions]);

  const renderCategoryCodeSaleSelector = (selectedCodes: string[], onChange: (nextCodes: string[]) => void) => (
    <div className="grid max-h-44 grid-cols-1 gap-1 overflow-y-auto rounded border border-gray-200 bg-white p-2 sm:grid-cols-2">
      {categoryOptions.map((option) => (
        <label key={option.category_code} className="flex items-center gap-2 text-xs text-gray-700">
          <input
            type="checkbox"
            checked={selectedCodes.includes(option.category_code)}
            onChange={(event) => onChange(toggleCategoryCode(selectedCodes, option.category_code, event.target.checked))}
            className="h-3.5 w-3.5 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
          />
          <span className="font-semibold text-gray-900">{option.category_code}</span>
          <span className="truncate">{option.category}</span>
        </label>
      ))}
    </div>
  );

  const renderCategoryCodeSaleNames = (codes?: string[]) => {
    if (!codes || codes.length === 0) {
      return <span className="text-xs text-gray-400">-</span>;
    }

    return (
      <div className="max-w-64 space-y-1 whitespace-normal">
        {codes.map((code) => (
          <div key={code} className="text-xs leading-5 text-gray-700">
            {categoryNameByCode.get(code) || code}
          </div>
        ))}
      </div>
    );
  };

  return (
    <div className="min-h-screen pt-[52px]">
      <div className="container mx-auto px-4 py-6">
        {toast.visible && (
          <div className={`fixed top-4 right-4 z-50 rounded-lg p-4 shadow-lg transition-all duration-300 ${toast.type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white'}`}>
            <div className="flex items-center gap-2">
              {toast.type === 'success' ? <CheckCircle2 className="h-5 w-5" /> : <AlertCircle className="h-5 w-5" />}
              <span>{toast.message}</span>
              <button onClick={() => setToast({ ...toast, visible: false })} className="ml-2 hover:opacity-75">
                <X className="h-4 w-4" />
              </button>
            </div>
          </div>
        )}

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
                placeholder="ค้นหาจากรหัส ชื่อ หรือหมวดขาย"
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
              <button onClick={clearFilters} className="w-full rounded-md bg-slate-600 px-4 py-2 text-white transition-colors hover:bg-slate-700">
                ล้างตัวกรอง
              </button>
            </div>
          </div>
        </div>

        <div className="mb-4 flex items-center justify-end gap-2">
          <button
            onClick={openCreateModal}
            disabled={!canCreate}
            className="inline-flex items-center gap-2 rounded-md bg-blue-600 px-3 py-2 text-sm font-medium text-white transition-colors hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-blue-300"
          >
            <Plus className="h-4 w-4" />
            เพิ่มผู้จำหน่าย
          </button>
        </div>

        <div className="mb-4 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
          <div className="text-sm text-gray-600">
            แสดง {pageStart}-{pageEnd} จาก {totalCount} รายการ
          </div>
          <div className="flex flex-col gap-3 sm:flex-row sm:items-center">
            <div className="flex items-center gap-2">
              <span className="text-sm text-gray-600">แสดงต่อหน้า</span>
              <select value={pageSize} onChange={handlePageSizeChange} className="rounded border border-gray-300 px-2 py-1 text-sm">
                {PAGE_SIZE_OPTIONS.map((size) => (
                  <option key={size} value={size}>
                    {size}
                  </option>
                ))}
              </select>
            </div>
            <div className="flex items-center gap-2">
              <button
                onClick={() => goToPage(page - 1)}
                disabled={page === 1}
                className={`rounded border px-3 py-1 text-sm ${page === 1 ? 'cursor-not-allowed border-gray-200 text-gray-400' : 'border-gray-300 text-gray-700 hover:bg-gray-50'}`}
              >
                ก่อนหน้า
              </button>
              <span className="text-sm text-gray-700">
                หน้า {page} / {totalPages}
              </span>
              <button
                onClick={() => goToPage(page + 1)}
                disabled={page === totalPages || totalCount === 0}
                className={`rounded border px-3 py-1 text-sm ${page === totalPages || totalCount === 0 ? 'cursor-not-allowed border-gray-200 text-gray-400' : 'border-gray-300 text-gray-700 hover:bg-gray-50'}`}
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
                  <th className="px-6 py-3 text-left text-[10px] font-medium uppercase tracking-wider text-gray-500">รหัส</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium uppercase tracking-wider text-gray-500">ชื่อผู้จำหน่าย</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium uppercase tracking-wider text-gray-500">ประเภทธุรกิจ</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium uppercase tracking-wider text-gray-500">เบอร์โทร</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium uppercase tracking-wider text-gray-500">มือถือ</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium uppercase tracking-wider text-gray-500">หมวดขาย</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium uppercase tracking-wider text-gray-500">เปิดใช้งาน</th>
                  <th className="px-6 py-3 text-left text-[10px] font-medium uppercase tracking-wider text-gray-500">Action</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 bg-white">
                {paginatedSellers.map((seller) => (
                  <tr key={seller.id} className="hover:bg-gray-50">
                    <td className="whitespace-nowrap px-6 py-4 text-xs font-medium text-gray-900">{seller.code}</td>
                    <td className="whitespace-nowrap px-6 py-4">
                      <div>
                        <div className="text-xs font-medium text-gray-900">{`${seller.prefix || ''} ${seller.name}`.trim()}</div>
                        <div className="text-xs text-gray-500">{seller.address}</div>
                      </div>
                    </td>
                    <td className="whitespace-nowrap px-6 py-4 text-xs text-gray-500">{seller.business}</td>
                    <td className="whitespace-nowrap px-6 py-4 text-xs text-gray-500">{seller.phone}</td>
                    <td className="whitespace-nowrap px-6 py-4 text-xs text-gray-500">{seller.mobile}</td>
                    <td className="px-6 py-4 text-xs text-gray-500">{renderCategoryCodeSaleNames(seller.category_code_sale)}</td>
                    <td className="whitespace-nowrap px-6 py-4 text-xs text-gray-900">
                      <input checked={Boolean(seller.is_active)} readOnly type="checkbox" className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
                    </td>
                    <td className="whitespace-nowrap px-6 py-4 text-xs font-medium">
                      <div className="flex gap-2">
                        <button
                          onClick={() => openEditModal(seller)}
                          disabled={!canEdit}
                          className="cursor-pointer text-indigo-600 hover:text-indigo-900 disabled:cursor-not-allowed disabled:opacity-40"
                          title="แก้ไข"
                        >
                          <Pencil className="h-5 w-5" />
                        </button>
                        <button
                          onClick={() => handleDelete(seller.id)}
                          disabled={!canDelete}
                          className="cursor-pointer text-red-600 hover:text-red-900 disabled:cursor-not-allowed disabled:opacity-40"
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
        </div>

        {loading && <div className="mt-6 text-center text-gray-500">กำลังโหลดข้อมูล...</div>}
        {error && <div className="mt-6 rounded-md border border-red-200 bg-red-50 p-3 text-sm text-red-700">{error}</div>}
      </div>

      {showSellerModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
          <div className="max-h-[90vh] w-full max-w-3xl overflow-y-auto rounded-lg bg-white p-6 shadow-xl">
            <div className="mb-4 flex items-center justify-between">
              <h2 className="text-xl font-semibold text-gray-900">{modalMode === 'create' ? 'เพิ่มผู้จำหน่าย' : 'แก้ไขผู้จำหน่าย'}</h2>
              <button onClick={closeSellerModal} className="text-gray-500 hover:text-gray-700">
                <X className="h-6 w-6" />
              </button>
            </div>

            <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">รหัส</label>
                <input value={formData.code} onChange={(e) => setFormData({ ...formData, code: e.target.value })} className="w-full rounded border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">คำนำหน้า</label>
                <input value={formData.prefix} onChange={(e) => setFormData({ ...formData, prefix: e.target.value })} className="w-full rounded border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div className="md:col-span-2">
                <label className="mb-1 block text-sm font-medium text-gray-700">ชื่อผู้จำหน่าย</label>
                <input value={formData.name} onChange={(e) => setFormData({ ...formData, name: e.target.value })} className="w-full rounded border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div className="md:col-span-2">
                <label className="mb-1 block text-sm font-medium text-gray-700">ที่อยู่</label>
                <textarea value={formData.address} onChange={(e) => setFormData({ ...formData, address: e.target.value })} rows={3} className="w-full resize-none rounded border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">ประเภทธุรกิจ</label>
                <input value={formData.business} onChange={(e) => setFormData({ ...formData, business: e.target.value })} className="w-full rounded border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">เบอร์โทร</label>
                <input value={formData.phone} onChange={(e) => setFormData({ ...formData, phone: e.target.value })} className="w-full rounded border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">แฟกซ์</label>
                <input value={formData.fax} onChange={(e) => setFormData({ ...formData, fax: e.target.value })} className="w-full rounded border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div>
                <label className="mb-1 block text-sm font-medium text-gray-700">มือถือ</label>
                <input value={formData.mobile} onChange={(e) => setFormData({ ...formData, mobile: e.target.value })} className="w-full rounded border border-gray-300 px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500" />
              </div>
              <div className="md:col-span-2">
                <label className="mb-1 block text-sm font-medium text-gray-700">หมวดขาย</label>
                {renderCategoryCodeSaleSelector(formData.category_code_sale, (nextCodes) => setFormData({ ...formData, category_code_sale: nextCodes }))}
              </div>
              <label className="flex items-center gap-2 text-sm text-gray-700">
                <input
                  type="checkbox"
                  checked={formData.is_active}
                  onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                  className="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                />
                เปิดใช้งาน
              </label>
            </div>

            <div className="mt-6 flex justify-end gap-2">
              <button onClick={closeSellerModal} className="rounded border border-gray-300 px-4 py-2 text-sm text-gray-700 hover:bg-gray-50">
                ยกเลิก
              </button>
              <button
                onClick={() => void saveSeller()}
                disabled={saving}
                className="inline-flex items-center gap-2 rounded bg-blue-600 px-4 py-2 text-sm font-semibold text-white hover:bg-blue-700 disabled:cursor-not-allowed disabled:opacity-60"
              >
                <Save className="h-4 w-4" />
                {saving ? 'กำลังบันทึก...' : 'บันทึก'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
