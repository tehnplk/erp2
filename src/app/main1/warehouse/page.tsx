'use client';

import { useEffect, useState } from 'react';
import Swal from 'sweetalert2';

interface WarehouseFormData {
  stockId?: string;
  transactionType?: string;
  transactionDate?: string;
  category?: string;
  productType?: string;
  productSubtype?: string;
  productCode?: string;
  productName?: string;
  productImage?: string;
  unit?: string;
  productLot?: string;
  productPrice?: number;
  receivedFromCompany?: string;
  receiptBillNumber?: string;
  requestingDepartment?: string;
  requisitionNumber?: string;
  quotaAmount?: number | null;
  carriedForwardQty?: number | null;
  carriedForwardValue?: number;
  transactionPrice?: number;
  transactionQuantity?: number | null;
  transactionValue?: number;
  remainingQuantity?: number | null;
  remainingValue?: number;
  inventoryStatus?: string;
}

export default function WarehousePage() {
  const [items, setItems] = useState<any[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState<any | null>(null);
  const [formData, setFormData] = useState<WarehouseFormData>({});

  // filters
  const [nameFilter, setNameFilter] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('');
  const [subtypeFilter, setSubtypeFilter] = useState('');
  const [departmentFilter, setDepartmentFilter] = useState('');

  // sort
  const [sortBy, setSortBy] = useState('id');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);

  const [editingId, setEditingId] = useState<number | null>(null);
  const [editData, setEditData] = useState<WarehouseFormData>({});
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

  // dynamic options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);

  useEffect(() => { fetchData(); }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, sortBy, sortOrder, page, pageSize]);
  useEffect(() => { fetchFilters(); }, []);

  useEffect(() => { setPage(1); }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, sortBy, sortOrder]);

  const fetchFilters = async () => {
    try {
      const res = await fetch('/api/warehouse/filters');
      if (res.ok) {
        const data = await res.json();
        setCategories(data.categories || []);
        setTypes(data.productTypes || []);
        setSubtypes(data.productSubtypes || []);
        setDepartments(data.requestingDepartments || []);
      }
    } catch (e) { console.error(e); }
  };

  const totalPages = Math.max(1, Math.ceil(totalCount / pageSize));
  const pageStart = totalCount === 0 ? 0 : (page - 1) * pageSize + 1;
  const pageEnd = totalCount === 0 ? 0 : Math.min(totalCount, pageStart + (items.length || 0) - 1);

  const goToPage = (newPage: number) => {
    if (newPage < 1 || newPage > totalPages) return;
    setPage(newPage);
  };

  const handlePageSizeChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const newSize = parseInt(e.target.value, 10);
    setPageSize(newSize);
    setPage(1);
  };

  const fetchData = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams();
      if (nameFilter) params.append('productName', nameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('productType', typeFilter);
      if (subtypeFilter) params.append('productSubtype', subtypeFilter);
      if (departmentFilter) params.append('requestingDepartment', departmentFilter);
      params.append('orderBy', sortBy);
      params.append('sortOrder', sortOrder);
      params.append('page', page.toString());
      params.append('pageSize', pageSize.toString());

      const res = await fetch(`/api/warehouse?${params.toString()}`);
      if (!res.ok) throw new Error('fetch failed');
      const data = await res.json();
      setItems(data.data || []);
      setTotalCount(data.totalCount || 0);
      if (data.page && data.page !== page) {
        setPage(data.page);
      }
      if (data.pageSize && data.pageSize !== pageSize) {
        setPageSize(data.pageSize);
      }
    } catch (e) { console.error(e); } finally { setLoading(false); }
  };

  const handleSort = (column: string) => {
    if (sortBy === column) setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    else { setSortBy(column); setSortOrder('asc'); }
  };

  const getHeaderClass = (col: string) => `px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${col === sortBy ? 'bg-gray-100' : ''}`;

  const handleEdit = (row: any) => {
    setEditing(row);
    setFormData({
      stockId: row.stockId || '',
      transactionType: row.transactionType || '',
      transactionDate: row.transactionDate || '',
      category: row.category || '',
      productType: row.productType || '',
      productSubtype: row.productSubtype || '',
      productCode: row.productCode || '',
      productName: row.productName || '',
      productImage: row.productImage || '',
      unit: row.unit || '',
      productLot: row.productLot || '',
      productPrice: row.productPrice ? Number(row.productPrice) : undefined,
      receivedFromCompany: row.receivedFromCompany || '',
      receiptBillNumber: row.receiptBillNumber || '',
      requestingDepartment: row.requestingDepartment || '',
      requisitionNumber: row.requisitionNumber || '',
      quotaAmount: row.quotaAmount ?? null,
      carriedForwardQty: row.carriedForwardQty ?? null,
      carriedForwardValue: row.carriedForwardValue ? Number(row.carriedForwardValue) : undefined,
      transactionPrice: row.transactionPrice ? Number(row.transactionPrice) : undefined,
      transactionQuantity: row.transactionQuantity ?? null,
      transactionValue: row.transactionValue ? Number(row.transactionValue) : undefined,
      remainingQuantity: row.remainingQuantity ?? null,
      remainingValue: row.remainingValue ? Number(row.remainingValue) : undefined,
      inventoryStatus: row.inventoryStatus || '',
    });
    setShowForm(true);
  };

  const resetForm = () => { setEditing(null); setFormData({}); setShowForm(false); };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: ['productPrice','carriedForwardValue','transactionPrice','transactionValue','remainingValue'].includes(name)
        ? (value ? parseFloat(value) : undefined)
        : ['quotaAmount','carriedForwardQty','transactionQuantity','remainingQuantity'].includes(name)
        ? (value ? parseInt(value) : null)
        : value
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const method = editing ? 'PUT' : 'POST';
    const url = editing ? `/api/warehouse/${editing.id}` : '/api/warehouse';
    const res = await fetch(url, { method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(formData) });
    if (res.ok) { resetForm(); fetchData(); }
    else { const err = await res.json().catch(()=>({})); alert(err.error || 'บันทึกล้มเหลว'); }
  };

  const handleDelete = async (id: number) => {
    const result = await Swal.fire({ title: 'ลบข้อมูล?', text: 'ยืนยันการลบรายการ', icon: 'warning', showCancelButton: true, confirmButtonText: 'ลบ', cancelButtonText: 'ยกเลิก' });
    if (!result.isConfirmed) return;
    const res = await fetch(`/api/warehouse/${id}`, { method: 'DELETE' });
    if (res.ok) { await Swal.fire('ลบแล้ว', '', 'success'); fetchData(); }
    else { await Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถลบได้', 'error'); }
  };

  // Start inline editing
  const startInlineEdit = (item: any) => {
    setEditingId(item.id);
    setEditData({
      stockId: item.stockId || '',
      transactionType: item.transactionType || '',
      transactionDate: item.transactionDate || '',
      category: item.category || '',
      productType: item.productType || '',
      productSubtype: item.productSubtype || '',
      productCode: item.productCode || '',
      productName: item.productName || '',
      productImage: item.productImage || '',
      unit: item.unit || '',
      productLot: item.productLot || '',
      productPrice: item.productPrice ? Number(item.productPrice) : undefined,
      receivedFromCompany: item.receivedFromCompany || '',
      receiptBillNumber: item.receiptBillNumber || '',
      requestingDepartment: item.requestingDepartment || '',
      requisitionNumber: item.requisitionNumber || '',
      quotaAmount: item.quotaAmount ?? null,
      carriedForwardQty: item.carriedForwardQty ?? null,
      carriedForwardValue: item.carriedForwardValue ? Number(item.carriedForwardValue) : undefined,
      transactionPrice: item.transactionPrice ? Number(item.transactionPrice) : undefined,
      transactionQuantity: item.transactionQuantity ?? null,
      transactionValue: item.transactionValue ? Number(item.transactionValue) : undefined,
      remainingQuantity: item.remainingQuantity ?? null,
      remainingValue: item.remainingValue ? Number(item.remainingValue) : undefined,
      inventoryStatus: item.inventoryStatus || '',
    });
  };

  // Save inline edit
  const saveInlineEdit = async (id: number) => {
    try {
      const response = await fetch(`/api/warehouse/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editData)
      });

      if (response.ok) {
        setEditingId(null);
        setEditData({});
        fetchData();

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
      console.error('Error updating warehouse item:', error);

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
    setEditData({});
  };

  // Save bulk warehouse items
  const saveBulkWarehouse = async () => {
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
        fetch('/api/warehouse', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            stockId: record.stockId || '',
            transactionType: record.transactionType || '',
            transactionDate: record.transactionDate || '',
            category: record.category || '',
            productType: record.productType || '',
            productSubtype: record.productSubtype || '',
            productCode: record.productCode.trim(),
            productName: record.productName.trim(),
            productImage: record.productImage || '',
            unit: record.unit || '',
            productLot: record.productLot || '',
            productPrice: record.productPrice ? parseFloat(record.productPrice) : undefined,
            receivedFromCompany: record.receivedFromCompany || '',
            receiptBillNumber: record.receiptBillNumber || '',
            requestingDepartment: record.requestingDepartment || '',
            requisitionNumber: record.requisitionNumber || '',
            quotaAmount: record.quotaAmount ? parseInt(record.quotaAmount) : null,
            carriedForwardQty: record.carriedForwardQty ? parseInt(record.carriedForwardQty) : null,
            carriedForwardValue: record.carriedForwardValue ? parseFloat(record.carriedForwardValue) : undefined,
            transactionPrice: record.transactionPrice ? parseFloat(record.transactionPrice) : undefined,
            transactionQuantity: record.transactionQuantity ? parseInt(record.transactionQuantity) : null,
            transactionValue: record.transactionValue ? parseFloat(record.transactionValue) : undefined,
            remainingQuantity: record.remainingQuantity ? parseInt(record.remainingQuantity) : null,
            remainingValue: record.remainingValue ? parseFloat(record.remainingValue) : undefined,
            inventoryStatus: record.inventoryStatus || '',
          })
        })
      );

      const results = await Promise.allSettled(promises);
      const successful = results.filter(result => result.status === 'fulfilled' && result.value.ok).length;
      const failed = results.length - successful;

      if (successful > 0) {
        setShowBulkForm(false);
        setBulkRecords([]);
        fetchData();

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
      console.error('Error saving bulk warehouse items:', error);

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
        <h1 className="text-3xl font-bold text-gray-800">คลังสินค้า</h1>
        <button
          onClick={() => {
            setShowBulkForm(true);
            setBulkRecords([
              { id: 1, transactionType: '', transactionDate: '', productName: '', productCode: '', category: '', productType: '', productSubtype: '', unit: '', productLot: '', productPrice: '', transactionQuantity: '', transactionValue: '', remainingQuantity: '', remainingValue: '', inventoryStatus: '' },
              { id: 2, transactionType: '', transactionDate: '', productName: '', productCode: '', category: '', productType: '', productSubtype: '', unit: '', productLot: '', productPrice: '', transactionQuantity: '', transactionValue: '', remainingQuantity: '', remainingValue: '', inventoryStatus: '' },
              { id: 3, transactionType: '', transactionDate: '', productName: '', productCode: '', category: '', productType: '', productSubtype: '', unit: '', productLot: '', productPrice: '', transactionQuantity: '', transactionValue: '', remainingQuantity: '', remainingValue: '', inventoryStatus: '' },
              { id: 4, transactionType: '', transactionDate: '', productName: '', productCode: '', category: '', productType: '', productSubtype: '', unit: '', productLot: '', productPrice: '', transactionQuantity: '', transactionValue: '', remainingQuantity: '', remainingValue: '', inventoryStatus: '' },
              { id: 5, transactionType: '', transactionDate: '', productName: '', productCode: '', category: '', productType: '', productSubtype: '', unit: '', productLot: '', productPrice: '', transactionQuantity: '', transactionValue: '', remainingQuantity: '', remainingValue: '', inventoryStatus: '' }
            ]);
          }}
          className="bg-blue-600 text-white p-3 rounded-full hover:bg-blue-700 transition-colors shadow-lg"
          title="เพิ่มรายการใหม่"
        >
          <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6" viewBox="0 0 20 20" fill="currentColor">
            <path fillRule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clipRule="evenodd" />
          </svg>
        </button>
      </div>

      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-3/4 shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">{editing ? 'แก้ไขรายการ' : 'เพิ่มรายการใหม่'}</h3>
              <button onClick={resetForm} className="text-gray-400 hover:text-gray-600">✕</button>
            </div>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <input placeholder="ประเภทเอกสาร" name="transactionType" value={formData.transactionType || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="วันที่" name="transactionDate" value={formData.transactionDate || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ชื่อสินค้า" name="productName" value={formData.productName || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="รหัสสินค้า" name="productCode" value={formData.productCode || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="หมวดหมู่" name="category" value={formData.category || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ประเภท" name="productType" value={formData.productType || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ประเภทย่อย" name="productSubtype" value={formData.productSubtype || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="หน่วย" name="unit" value={formData.unit || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ล็อตสินค้า" name="productLot" value={formData.productLot || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ราคา/หน่วย" type="number" step="0.01" name="productPrice" value={formData.productPrice ?? ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="จำนวนเคลื่อนไหว" type="number" name="transactionQuantity" value={formData.transactionQuantity ?? ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="มูลค่าเคลื่อนไหว" type="number" step="0.01" name="transactionValue" value={formData.transactionValue ?? ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="จำนวนคงเหลือ" type="number" name="remainingQuantity" value={formData.remainingQuantity ?? ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="มูลค่าคงเหลือ" type="number" step="0.01" name="remainingValue" value={formData.remainingValue ?? ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="สถานะ" name="inventoryStatus" value={formData.inventoryStatus || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
              </div>
              <div className="flex justify-end space-x-3">
                <button type="button" onClick={resetForm} className="px-4 py-2 border rounded">ยกเลิก</button>
                <button type="submit" className="px-4 py-2 bg-blue-600 text-white rounded">บันทึก</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Bulk Add Warehouse Modal */}
      {showBulkForm && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-7xl max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-xl font-bold">เพิ่มรายการคลังใหม่ (5 รายการพร้อมแก้ไข)</h2>
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
                <div className="overflow-x-auto">
                  <table className="w-full">
                    <thead className="bg-gray-100">
                      <tr>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ลำดับ</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">รหัสสินค้า</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ชื่อสินค้า</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">ประเภทเอกสาร</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">วันที่</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">หมวด</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">จำนวนเคลื่อนไหว</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">คงเหลือ</th>
                        <th className="px-2 py-2 text-left text-xs font-medium text-gray-500 uppercase">สถานะ</th>
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
                            <input
                              type="text"
                              value={record.transactionType || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].transactionType = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="ประเภทเอกสาร"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="date"
                              value={record.transactionDate || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].transactionDate = e.target.value;
                                setBulkRecords(updated);
                              }}
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
                            <input
                              type="number"
                              value={record.transactionQuantity || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].transactionQuantity = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="จำนวนเคลื่อนไหว"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="number"
                              value={record.remainingQuantity || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].remainingQuantity = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="คงเหลือ"
                              className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
                            />
                          </td>
                          <td className="px-2 py-3">
                            <input
                              type="text"
                              value={record.inventoryStatus || ''}
                              onChange={(e) => {
                                const updated = [...bulkRecords];
                                updated[index].inventoryStatus = e.target.value;
                                setBulkRecords(updated);
                              }}
                              placeholder="สถานะ"
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
                                      transactionType: '', transactionDate: '', productName: '', productCode: '', category: '', productType: '', productSubtype: '', unit: '', productLot: '', productPrice: '', transactionQuantity: '', transactionValue: '', remainingQuantity: '', remainingValue: '', inventoryStatus: ''
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
                                    setBulkRecords(bulkRecords.filter((r: any) => r.id !== record.id));
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
            </div>

            <div className="flex gap-3">
              <button
                onClick={saveBulkWarehouse}
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

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4 mb-4">
            <input placeholder="ชื่อสินค้า" value={nameFilter} onChange={(e)=>setNameFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2" />
            <select value={categoryFilter} onChange={(e)=>setCategoryFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หมวด</option>
              {categories.map((x: string) => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={typeFilter} onChange={(e)=>setTypeFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภท</option>
              {types.map((x: string) => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={subtypeFilter} onChange={(e)=>setSubtypeFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภทย่อย</option>
              {subtypes.map((x: string) => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={departmentFilter} onChange={(e)=>setDepartmentFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หน่วยงานขอ</option>
              {departments.map((x: string) => <option key={x} value={x}>{x}</option>)}
            </select>
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

      <div className="bg-white shadow-md rounded-lg overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th onClick={()=>handleSort('transactionDate')} className={getHeaderClass('transactionDate')}>วันที่</th>
              <th onClick={()=>handleSort('productCode')} className={getHeaderClass('productCode')}>รหัส</th>
              <th onClick={()=>handleSort('productName')} className={getHeaderClass('productName')}>ชื่อสินค้า</th>
              <th onClick={()=>handleSort('transactionQuantity')} className={getHeaderClass('transactionQuantity')}>จำนวนเคลื่อนไหว</th>
              <th onClick={()=>handleSort('remainingQuantity')} className={getHeaderClass('remainingQuantity')}>คงเหลือ</th>
              <th className="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider w-24">Action</th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {items.map((row) => (
              <tr key={row.id}>
                <td className="px-3 py-2 text-sm">{row.transactionDate}</td>
                <td className="px-3 py-2 text-sm">{row.productCode}</td>
                <td className="px-3 py-2 text-sm">
                  <div className="whitespace-normal break-words" title={row.productName}>
                    {row.productName}
                  </div>
                </td>
                <td className="px-3 py-2 text-sm">
                  {editingId === row.id ? (
                    <input
                      type="number"
                      value={editData.transactionQuantity || ''}
                      onChange={(e) => setEditData({ ...editData, transactionQuantity: e.target.value ? parseInt(e.target.value) : null })}
                      className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  ) : (
                    row.transactionQuantity ?? '-'
                  )}
                </td>
                <td className="px-3 py-2 text-sm">
                  {editingId === row.id ? (
                    <input
                      type="number"
                      value={editData.remainingQuantity || ''}
                      onChange={(e) => setEditData({ ...editData, remainingQuantity: e.target.value ? parseInt(e.target.value) : null })}
                      className="w-full px-2 py-1 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                    />
                  ) : (
                    row.remainingQuantity ?? '-'
                  )}
                </td>
                <td className="px-3 py-2 text-sm font-medium w-24">
                  {editingId === row.id ? (
                    <div className="flex gap-1">
                      <button
                        onClick={() => saveInlineEdit(row.id)}
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
                        onClick={() => startInlineEdit(row)}
                        className="text-indigo-600 hover:text-indigo-900 cursor-pointer"
                        title="แก้ไข"
                      >
                        <svg xmlns="http://www.w3.org/2000/svg" className="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                          <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
                        </svg>
                      </button>
                      <button
                        onClick={() => handleDelete(row.id)}
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
    </div>
  );
}
