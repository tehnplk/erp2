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

  // dynamic options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);

  useEffect(() => { fetchData(); }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, sortBy, sortOrder]);
  useEffect(() => { fetchFilters(); }, []);

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

      const res = await fetch(`/api/warehouse?${params.toString()}`);
      if (!res.ok) throw new Error('fetch failed');
      const data = await res.json();
      setItems(data.items || []);
      setTotalCount(data.totalCount || 0);
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

  if (loading) return <div className="flex justify-center items-center h-screen">Loading...</div>;

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">คลังสินค้า</h1>
        <button onClick={() => setShowForm(true)} className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">เพิ่มรายการ</button>
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

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4 mb-4">
            <input placeholder="ชื่อสินค้า" value={nameFilter} onChange={(e)=>setNameFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2" />
            <select value={categoryFilter} onChange={(e)=>setCategoryFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หมวด</option>
              {categories.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={typeFilter} onChange={(e)=>setTypeFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภท</option>
              {types.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={subtypeFilter} onChange={(e)=>setSubtypeFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภทย่อย</option>
              {subtypes.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={departmentFilter} onChange={(e)=>setDepartmentFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หน่วยงานขอ</option>
              {departments.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
          </div>
        </div>
      </div>

      <div className="mt-4 text-sm text-gray-600">แสดง {items.length} จาก {totalCount} รายการ</div>

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
                <td className="px-3 py-2 text-sm">{row.transactionQuantity ?? '-'}</td>
                <td className="px-3 py-2 text-sm">{row.remainingQuantity ?? '-'}</td>
                <td className="px-3 py-2 text-sm font-medium w-24">
                  <button
                    onClick={() => handleEdit(row)}
                    className="text-indigo-600 hover:text-indigo-900 mr-2 cursor-pointer"
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
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
