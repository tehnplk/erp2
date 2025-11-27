'use client';

import { useEffect, useState } from 'react';
import Swal from 'sweetalert2';

interface PurchaseApprovalFormData {
  approvalId?: string;
  department?: string;
  recordNumber?: string;
  requestDate?: string;
  productName?: string;
  productCode?: string;
  category?: string;
  productType?: string;
  productSubtype?: string;
  requestedQuantity?: number | null;
  unit?: string;
  pricePerUnit?: number;
  totalValue?: number;
  overPlanCase?: string;
  requester?: string;
  approver?: string;
}

export default function PurchaseApprovalsPage() {
  const [items, setItems] = useState<any[]>([]);
  const [summaryItems, setSummaryItems] = useState<any[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editing, setEditing] = useState<any | null>(null);
  const [formData, setFormData] = useState<PurchaseApprovalFormData>({});
  const [showMemo, setShowMemo] = useState(false);
  const [memoPreview, setMemoPreview] = useState(false);
  const [memoText, setMemoText] = useState(
    `บันทึกข้อความ\n` +
    `ส่วนราชการ  โรงพยาบาลวังทอง   อำเภอวังทอง จังหวัดพิษณุโลก   โทร..............................\n` +
    `ที่  วถ..............................\n` +
    `วันที่  ......................................................\n` +
    `เรื่อง  ขอความเห็นชอบจัดซื้อ.........................................................\n\n` +
    `เรียน  ผู้อำนวยการโรงพยาบาลวังทอง\n\n` +
    `         ด้วย  .................................................................................\n` +
    `.................................................................................................\n` +
    `.................................................................................................\n\n` +
    `         จึงเรียนมาเพื่อโปรดพิจารณา........................................................\n` +
    `.................................................................................................\n\n` +
    `ลงชื่อ...............................................................   ผู้เสนอเรื่อง\n` +
    `(............................................................)\n` +
    `ตำแหน่ง.....................................................\n\n` +
    `ความเห็นผู้บังคับบัญชา/หัวหน้าหน่วยงาน\n` +
    `.................................................................................................\n` +
    `.................................................................................................\n` +
    `ลงชื่อ...............................................................\n` +
    `(............................................................)\n` +
    `ตำแหน่ง.....................................................\n\n` +
    `ความเห็นผู้อำนวยการโรงพยาบาลวังทอง\n` +
    `.................................................................................................\n` +
    `.................................................................................................\n` +
    `ลงชื่อ...............................................................\n` +
    `(............................................................)\n` +
    `ผู้อำนวยการโรงพยาบาลวังทอง`
  );

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

  // dynamic options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);
  const [requesters, setRequesters] = useState<string[]>([]);
  const [approvers, setApprovers] = useState<string[]>([]);

  useEffect(() => { fetchData(); }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, sortBy, sortOrder, page, pageSize]);

  // When filters or sorting change, reset to first page and refresh summary data
  useEffect(() => {
    setPage(1);
    fetchSummaryData();
  }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, sortBy, sortOrder]);

  useEffect(() => { fetchFilters(); fetchSummaryData(); }, []);

  const fetchFilters = async () => {
    try {
      const res = await fetch('/api/purchase-approvals/filters');
      if (res.ok) {
        const data = await res.json();
        setCategories(data.categories || []);
        setTypes(data.productTypes || []);
        setSubtypes(data.productSubtypes || []);
        setDepartments(data.departments || []);
        setRequesters(data.requesters || []);
        setApprovers(data.approvers || []);
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
      if (departmentFilter) params.append('department', departmentFilter);
      params.append('orderBy', sortBy);
      params.append('sortOrder', sortOrder);
      params.append('page', page.toString());
      params.append('pageSize', pageSize.toString());

      const res = await fetch(`/api/purchase-approvals?${params.toString()}`);
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

  // Fetch full filtered dataset for summary (independent of pagination)
  const fetchSummaryData = async () => {
    try {
      const params = new URLSearchParams();
      if (nameFilter) params.append('productName', nameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('productType', typeFilter);
      if (subtypeFilter) params.append('productSubtype', subtypeFilter);
      if (departmentFilter) params.append('department', departmentFilter);
      params.append('orderBy', sortBy);
      params.append('sortOrder', sortOrder);

      const res = await fetch(`/api/purchase-approvals?${params.toString()}`);
      if (!res.ok) return;
      const data = await res.json();
      setSummaryItems(data.data || []);
    } catch (e) {
      console.error(e);
    }
  };

  const handleSort = (column: string) => {
    if (sortBy === column) setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    else { setSortBy(column); setSortOrder('asc'); }
  };

  const getHeaderClass = (col: string) => `px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${col === sortBy ? 'bg-gray-100' : ''}`;

  const handleEdit = (row: any) => {
    setEditing(row);
    setFormData({
      approvalId: row.approvalId || '',
      department: row.department || '',
      recordNumber: row.recordNumber || '',
      requestDate: row.requestDate || '',
      productName: row.productName || '',
      productCode: row.productCode || '',
      category: row.category || '',
      productType: row.productType || '',
      productSubtype: row.productSubtype || '',
      requestedQuantity: row.requestedQuantity ?? null,
      unit: row.unit || '',
      pricePerUnit: row.pricePerUnit ? Number(row.pricePerUnit) : undefined,
      totalValue: row.totalValue ? Number(row.totalValue) : undefined,
      overPlanCase: row.overPlanCase || '',
      requester: row.requester || '',
      approver: row.approver || '',
    });
    setShowForm(true);
  };

  const resetForm = () => { setEditing(null); setFormData({}); setShowForm(false); };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: ['pricePerUnit','totalValue'].includes(name)
        ? (value ? parseFloat(value) : undefined)
        : ['requestedQuantity'].includes(name)
        ? (value ? parseInt(value) : null)
        : value
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const method = editing ? 'PUT' : 'POST';
    const url = editing ? `/api/purchase-approvals/${editing.id}` : '/api/purchase-approvals';
    const res = await fetch(url, { method, headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(formData) });
    if (res.ok) { resetForm(); fetchData(); }
    else { const err = await res.json().catch(()=>({})); alert(err.error || 'บันทึกล้มเหลว'); }
  };

  const handleDelete = async (id: number) => {
    const result = await Swal.fire({ title: 'ลบข้อมูล?', text: 'ยืนยันการลบรายการ', icon: 'warning', showCancelButton: true, confirmButtonText: 'ลบ', cancelButtonText: 'ยกเลิก' });
    if (!result.isConfirmed) return;
    const res = await fetch(`/api/purchase-approvals/${id}`, { method: 'DELETE' });
    if (res.ok) { await Swal.fire('ลบแล้ว', '', 'success'); fetchData(); }
    else { await Swal.fire('เกิดข้อผิดพลาด', 'ไม่สามารถลบได้', 'error'); }
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">ขออนุมัติจัดซื้อ</h1>
        <div className="flex gap-2">
          <button
            onClick={() => setShowMemo(true)}
            className="bg-emerald-500 hover:bg-emerald-700 text-white font-bold py-2 px-4 rounded"
          >
            ขอความเห็นชอบจัดซื้อ
          </button>
          <button
            onClick={() => setShowForm(true)}
            className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          >
            เพิ่มรายการ
          </button>
        </div>
      </div>

      {showMemo && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-3/4 shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">บันทึกข้อความ</h3>
              <button onClick={() => setShowMemo(false)} className="text-gray-400 hover:text-gray-600">✕</button>
            </div>
            <div className="space-y-4">
              <div className="flex justify-end space-x-2 text-sm">
                <button
                  type="button"
                  onClick={() => setMemoPreview(false)}
                  className={`px-3 py-1 rounded border ${!memoPreview ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-700 border-gray-300'}`}
                >
                  โหมดแก้ไข
                </button>
                <button
                  type="button"
                  onClick={() => setMemoPreview(true)}
                  className={`px-3 py-1 rounded border ${memoPreview ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-700 border-gray-300'}`}
                >
                  ตัวอย่างก่อนพิมพ์
                </button>
              </div>

              {!memoPreview ? (
                <textarea
                  className="w-full border rounded px-3 py-2 h-80 resize-none text-sm"
                  value={memoText}
                  onChange={(e) => setMemoText(e.target.value)}
                  placeholder="พิมพ์บันทึกข้อความที่นี่..."
                  style={{ whiteSpace: 'pre-wrap', fontFamily: 'Tahoma, system-ui, sans-serif' }}
                />
              ) : (
                <div className="flex justify-center">
                  <div
                    className="bg-white border shadow-sm rounded px-10 py-10 max-h-[32rem] overflow-auto text-sm w-full md:w-[800px]"
                    style={{ whiteSpace: 'pre-wrap', fontFamily: 'Tahoma, system-ui, sans-serif', lineHeight: 1.8 }}
                  >
                    {memoText}
                  </div>
                </div>
              )}
              <div className="flex justify-end space-x-3">
                <button
                  type="button"
                  onClick={() => setShowMemo(false)}
                  className="px-4 py-2 border rounded"
                >
                  ปิด
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {showForm && (
        <div className="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
          <div className="relative top-20 mx-auto p-5 border w-11/12 md:w-3/4 lg:w-3/4 shadow-lg rounded-md bg-white">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-medium">{editing ? 'แก้ไขรายการ' : 'เพิ่มรายการใหม่'}</h3>
              <button onClick={resetForm} className="text-gray-400 hover:text-gray-600">✕</button>
            </div>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <input placeholder="รหัสอนุมัติ" name="approvalId" value={formData.approvalId || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="หน่วยงาน" name="department" value={formData.department || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="เลขที่บันทึก" name="recordNumber" value={formData.recordNumber || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="วันที่ขอ" name="requestDate" value={formData.requestDate || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ชื่อสินค้า" name="productName" value={formData.productName || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="รหัสสินค้า" name="productCode" value={formData.productCode || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="หมวดหมู่" name="category" value={formData.category || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ประเภท" name="productType" value={formData.productType || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ประเภทย่อย" name="productSubtype" value={formData.productSubtype || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ปริมาณที่ขอ" type="number" name="requestedQuantity" value={formData.requestedQuantity ?? ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="หน่วย" name="unit" value={formData.unit || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ราคา/หน่วย" type="number" step="0.01" name="pricePerUnit" value={formData.pricePerUnit ?? ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="มูลค่ารวม" type="number" step="0.01" name="totalValue" value={formData.totalValue ?? ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="กรณีเกินแผน" name="overPlanCase" value={formData.overPlanCase || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ผู้ขอ" name="requester" value={formData.requester || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
                <input placeholder="ผู้อนุมัติ" name="approver" value={formData.approver || ''} onChange={handleInputChange} className="border rounded px-3 py-2" />
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
          <div className="grid grid-cols-1 md:grid-cols-6 gap-4 mb-4">
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
              <option value="">หน่วยงาน</option>
              {departments.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
          </div>
        </div>
      </div>

      {/* Summary Section (based on filtered dataset, not pagination) */}
      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <h3 className="text-lg font-medium text-gray-900">สรุปมูลค่าการขออนุมัติจัดซื้อ</h3>
            <div className="flex flex-wrap items-center gap-6 text-sm">
              <div>
                <span className="text-gray-500">มูลค่ารวม (totalValue): </span>
                <span className="font-semibold text-gray-900">
                  ฿{summaryItems
                    .reduce((sum, row) => sum + (Number(row.totalValue) || 0), 0)
                    .toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
            </div>
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
              <th onClick={()=>handleSort('approvalId')} className={getHeaderClass('approvalId')}>เลขอนุมัติ</th>
              <th onClick={()=>handleSort('department')} className={getHeaderClass('department')}>หน่วยงาน</th>
              <th onClick={()=>handleSort('productName')} className={getHeaderClass('productName')}>ชื่อสินค้า</th>
              <th onClick={()=>handleSort('requestedQuantity')} className={getHeaderClass('requestedQuantity')}>จำนวน</th>
              <th onClick={()=>handleSort('pricePerUnit')} className={getHeaderClass('pricePerUnit')}>ราคา/หน่วย</th>
              <th onClick={()=>handleSort('totalValue')} className={getHeaderClass('totalValue')}>มูลค่ารวม</th>
              <th className="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider w-24">Action</th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {items.map((row) => (
              <tr key={row.id}>
                <td className="px-3 py-2 text-sm">{row.approvalId}</td>
                <td className="px-3 py-2 text-sm">{row.department}</td>
                <td className="px-3 py-2 text-sm">
                  <div className="whitespace-normal break-words" title={row.productName}>
                    {row.productName}
                  </div>
                </td>
                <td className="px-3 py-2 text-sm">{row.requestedQuantity ?? '-'}</td>
                <td className="px-3 py-2 text-sm">{row.pricePerUnit ? Number(row.pricePerUnit).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                <td className="px-3 py-2 text-sm">{row.totalValue ? Number(row.totalValue).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
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
