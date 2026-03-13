'use client';

import React, { useEffect, useMemo, useRef, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { ChevronDown, ChevronRight } from 'lucide-react';

interface PurchaseApprovalGroup {
  id: number;
  approve_code: string;
  doc_no: string;
  doc_date: string;
  status: string;
  total_amount: string;
  total_items: number;
  prepared_by: string;
  approved_by?: string;
  approved_at?: string;
  notes?: string;
  created_at: string;
  updated_at: string;
  version: number;
  department?: string;
  budget_year?: number;
  item_count: number;
  sub_items: PurchaseApprovalSubItem[];
}

interface PurchaseApprovalSubItem {
  id: number;
  purchase_approval_id: number;
  approve_code: string;
  purchase_plan_id: number;
  line_number: number;
  detail_status: string;
  approved_quantity?: number;
  approved_amount?: string;
  remarks?: string;
  detail_created_at: string;
  detail_updated_at: string;
  detail_version: number;
  product_name?: string;
  product_code?: string;
  category?: string;
  product_type?: string;
  product_subtype?: string;
  requested_quantity?: number;
  unit?: string;
  price_per_unit?: number;
  total_value?: number;
  plan_budget_year?: number;
  usage_plan_dept?: string;
  purchase_qty?: number;
  purchase_value?: number;
}

export default function PurchaseApprovalsPage() {
  const router = useRouter();
  const pathname = usePathname();
  const searchParams = useSearchParams();
  const [items, setItems] = useState<PurchaseApprovalGroup[]>([]);
  const [summaryItems, setSummaryItems] = useState<PurchaseApprovalGroup[]>([]);
  const [totalCount, setTotalCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [filtersLoading, setFiltersLoading] = useState(true);
  const hasSyncedSearchParamsRef = useRef(false);
  const filtersLoadedRef = useRef(false);
  const [expandedRows, setExpandedRows] = useState<Set<string>>(new Set());

  // filters
  const [nameFilter, setNameFilter] = useState(searchParams.get('product_name') || '');
  const [categoryFilter, setCategoryFilter] = useState(searchParams.get('category') || '');
  const [typeFilter, setTypeFilter] = useState(searchParams.get('product_type') || '');
  const [subtypeFilter, setSubtypeFilter] = useState(searchParams.get('product_subtype') || '');
  const [departmentFilter, setDepartmentFilter] = useState(searchParams.get('department') || '');
  const [budgetYearFilter, setBudgetYearFilter] = useState(searchParams.get('budget_year') || '');

  // sort
  const [sortBy, setSortBy] = useState(searchParams.get('order_by') || 'created_at');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>((searchParams.get('sort_order') === 'asc' ? 'asc' : 'desc'));
  const [page, setPage] = useState(Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1));
  const [pageSize, setPageSize] = useState(Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20));

  // dynamic options
  const [categories, setCategories] = useState<string[]>([]);
  const [types, setTypes] = useState<string[]>([]);
  const [subtypes, setSubtypes] = useState<string[]>([]);
  const [categoryOptions, setCategoryOptions] = useState<any[]>([]);
  const [departments, setDepartments] = useState<string[]>([]);
  const [preparedBy, setPreparedBy] = useState<string[]>([]);
  const [approvedBy, setApprovedBy] = useState<string[]>([]);
  const [statusOptions, setStatusOptions] = useState<string[]>([]);

  const availableTypes = useMemo(() => {
    if (!categoryFilter) {
      return types;
    }

    return Array.from(
      new Set(
        categoryOptions
          .filter((option) => option.category === categoryFilter)
          .map((option) => option.type)
          .filter(Boolean)
      )
    );
  }, [categoryFilter, categoryOptions, types]);

  const availableSubtypes = useMemo(() => {
    return Array.from(
      new Set(
        categoryOptions
          .filter((option) => {
            const categoryMatched = categoryFilter ? option.category === categoryFilter : true;
            const typeMatched = typeFilter ? option.type === typeFilter : true;
            return categoryMatched && typeMatched;
          })
          .map((option) => option.subtype)
          .filter(Boolean)
      )
    ) as string[];
  }, [categoryFilter, typeFilter, categoryOptions]);

  useEffect(() => {
    if (!filtersLoadedRef.current) {
      return;
    }
    if (typeFilter && !availableTypes.includes(typeFilter)) {
      setTypeFilter('');
      setSubtypeFilter('');
    }
  }, [availableTypes, typeFilter]);

  useEffect(() => {
    if (!filtersLoadedRef.current) {
      return;
    }
    if (subtypeFilter && !availableSubtypes.includes(subtypeFilter)) {
      setSubtypeFilter('');
    }
  }, [availableSubtypes, subtypeFilter]);

  useEffect(() => { fetchData(); }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, budgetYearFilter, sortBy, sortOrder, page, pageSize]);

  // When filters or sorting change, reset to first page and refresh summary data
  useEffect(() => {
    if (!hasSyncedSearchParamsRef.current) {
      return;
    }
    setPage(1);
    fetchSummaryData();
  }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, budgetYearFilter, sortBy, sortOrder]);

  useEffect(() => { fetchFilters(); fetchSummaryData(); }, []);

  useEffect(() => {
    const nextName = searchParams.get('product_name') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('product_type') || '';
    const nextSubtype = searchParams.get('product_subtype') || '';
    const nextDepartment = searchParams.get('department') || '';
    const nextBudgetYear = searchParams.get('budget_year') || '';
    const nextSortBy = searchParams.get('order_by') || 'created_at';
    const nextSortOrder = (searchParams.get('sort_order') === 'asc' ? 'asc' : 'desc') as 'asc' | 'desc';
    const nextPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const nextPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);

    setNameFilter((prev) => (prev === nextName ? prev : nextName));
    setCategoryFilter((prev) => (prev === nextCategory ? prev : nextCategory));
    setTypeFilter((prev) => (prev === nextType ? prev : nextType));
    setSubtypeFilter((prev) => (prev === nextSubtype ? prev : nextSubtype));
    setDepartmentFilter((prev) => (prev === nextDepartment ? prev : nextDepartment));
    setBudgetYearFilter((prev) => (prev === nextBudgetYear ? prev : nextBudgetYear));
    setSortBy((prev) => (prev === nextSortBy ? prev : nextSortBy));
    setSortOrder((prev) => (prev === nextSortOrder ? prev : nextSortOrder));
    setPage((prev) => (prev === nextPage ? prev : nextPage));
    setPageSize((prev) => (prev === nextPageSize ? prev : nextPageSize));
    hasSyncedSearchParamsRef.current = true;
  }, [searchParams]);

  useEffect(() => {
    if (!hasSyncedSearchParamsRef.current) {
      return;
    }

    const params = new URLSearchParams();
    if (nameFilter) params.set('product_name', nameFilter);
    if (categoryFilter) params.set('category', categoryFilter);
    if (typeFilter) params.set('product_type', typeFilter);
    if (subtypeFilter) params.set('product_subtype', subtypeFilter);
    if (departmentFilter) params.set('department', departmentFilter);
    if (budgetYearFilter) params.set('budget_year', budgetYearFilter);
    if (sortBy && sortBy !== 'created_at') params.set('order_by', sortBy);
    if (sortOrder !== 'desc') params.set('sort_order', sortOrder);
    if (page > 1) params.set('page', page.toString());
    if (pageSize !== 20) params.set('page_size', pageSize.toString());

    const nextUrl = params.toString() ? `${pathname}?${params.toString()}` : pathname;
    const currentUrl = searchParams.toString() ? `${pathname}?${searchParams.toString()}` : pathname;

    if (nextUrl !== currentUrl) {
      router.replace(nextUrl, { scroll: false });
    }
  }, [pathname, router, searchParams, nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, budgetYearFilter, sortBy, sortOrder, page, pageSize]);

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
      if (nameFilter) params.append('product_name', nameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('product_type', typeFilter);
      if (subtypeFilter) params.append('product_subtype', subtypeFilter);
      if (departmentFilter) params.append('department', departmentFilter);
      if (budgetYearFilter) params.append('budget_year', budgetYearFilter);
      params.append('order_by', sortBy);
      params.append('sort_order', sortOrder);
      params.append('page', page.toString());
      params.append('page_size', pageSize.toString());

      const res = await fetch(`/api/purchase-approvals/grouped?${params.toString()}`);
      if (!res.ok) throw new Error('fetch failed');
      const data = await res.json();
      setItems(data.data || data.items || []);
      setTotalCount(data.totalCount || 0);
      if (data.page && data.page !== page) {
        setPage(data.page);
      }
      if (data.page_size && data.page_size !== pageSize) {
        setPageSize(data.page_size);
      }
    } catch (e) { console.error(e); } finally { setLoading(false); }
  };

  // Fetch full filtered dataset for summary (independent of pagination)
  const fetchSummaryData = async () => {
    try {
      const params = new URLSearchParams();
      if (nameFilter) params.append('product_name', nameFilter);
      if (categoryFilter) params.append('category', categoryFilter);
      if (typeFilter) params.append('product_type', typeFilter);
      if (subtypeFilter) params.append('product_subtype', subtypeFilter);
      if (departmentFilter) params.append('department', departmentFilter);
      if (budgetYearFilter) params.append('budget_year', budgetYearFilter);
      params.append('order_by', sortBy);
      params.append('sort_order', sortOrder);

      const res = await fetch(`/api/purchase-approvals/grouped?${params.toString()}`);
      if (!res.ok) return;
      const data = await res.json();
      setSummaryItems(data.data || data.items || []);
    } catch (e) {
      console.error(e);
    }
  };

  const fetchFilters = async () => {
    try {
      setFiltersLoading(true);
      const res = await fetch('/api/purchase-approvals/filters');
      if (res.ok) {
        const data = await res.json();
        setCategories(data.categories || []);
        setTypes(data.product_types || []);
        setSubtypes(data.product_subtypes || []);
        setCategoryOptions(data.category_options || []);
        setDepartments(data.departments || []);
        setPreparedBy(data.prepared_by || []);
        setApprovedBy(data.approved_by || []);
        setStatusOptions(data.status_options || []);
        filtersLoadedRef.current = true;
      }
    } catch (e) { console.error(e); }
    finally { setFiltersLoading(false); }
  };

  const handleSort = (column: string) => {
    if (sortBy === column) setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    else { setSortBy(column); setSortOrder('asc'); }
  };

  const getHeaderClass = (col: string) => `px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100 ${col === sortBy ? 'bg-gray-100' : ''}`;

  const toggleRowExpansion = (approvalId: string) => {
    const newExpanded = new Set(expandedRows);
    if (newExpanded.has(approvalId)) {
      newExpanded.delete(approvalId);
    } else {
      newExpanded.add(approvalId);
    }
    setExpandedRows(newExpanded);
  };

  const formatDateTime = (value?: string) => {
    if (!value) return '-';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return value;
    return date.toLocaleString('th-TH');
  };

  const formatDate = (value?: string) => {
    if (!value) return '-';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return value;
    return date.toLocaleDateString('th-TH');
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold text-gray-800">ขออนุมัติจัดซื้อ</h1>
      </div>

      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="grid grid-cols-1 md:grid-cols-6 gap-4 mb-4">
            <input placeholder="ชื่อสินค้า" value={nameFilter} onChange={(e)=>setNameFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2" />
            <select value={categoryFilter} onChange={(e)=>{ setCategoryFilter(e.target.value); setTypeFilter(''); setSubtypeFilter(''); }} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หมวด</option>
              {categories.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={typeFilter} onChange={(e)=>{ setTypeFilter(e.target.value); setSubtypeFilter(''); }} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภท</option>
              {availableTypes.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={subtypeFilter} onChange={(e)=>setSubtypeFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ประเภทย่อย</option>
              {availableSubtypes.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={departmentFilter} onChange={(e)=>setDepartmentFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">หน่วยงาน</option>
              {departments.map(x => <option key={x} value={x}>{x}</option>)}
            </select>
            <select value={budgetYearFilter} onChange={(e)=>setBudgetYearFilter(e.target.value)} className="w-full rounded-md border-gray-300 shadow-sm text-sm px-3 py-2">
              <option value="">ปีงบประมาณ</option>
              {departments.map((x: string) => <option key={x} value={x}>{x}</option>)}
            </select>
          </div>
          {filtersLoading && <div className="text-sm text-gray-500">กำลังโหลดตัวกรอง...</div>}
        </div>
      </div>

      {/* Summary Section (based on filtered dataset, not pagination) */}
      <div className="bg-white shadow-md rounded-lg overflow-hidden mb-4">
        <div className="px-4 py-3 bg-gray-50 border-b border-gray-200">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <h3 className="text-lg font-medium text-gray-900">รายการชุดอนุมัติจัดซื้อ</h3>
            <div className="flex flex-wrap items-center gap-6 text-sm">
              <div>
                <span className="text-gray-500">มูลค่ารวม (total_value): </span>
                <span className="font-semibold text-gray-900">
                  ฿{summaryItems
                    .reduce((sum, group) => sum + (group.sub_items?.reduce((subSum, item) => subSum + (Number(item.total_value) || 0), 0) || 0), 0)
                    .toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                </span>
              </div>
              <div>
                <span className="text-gray-500">จำนวนชุด: </span>
                <span className="font-semibold text-gray-900">
                  {summaryItems.length}
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
        {loading ? (
          <div className="flex justify-center items-center py-12">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
          </div>
        ) : items.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-500">ไม่พบข้อมูล</p>
          </div>
        ) : (
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-12">ลำดับ</th>
                <th onClick={()=>handleSort('created_at')} className={getHeaderClass('created_at')}>วันที่สร้าง</th>
                {/* <th onClick={()=>handleSort('id')} className={getHeaderClass('id')}>เลขที่อนุมัติ</th> */}
                <th onClick={()=>handleSort('approve_code')} className={getHeaderClass('approve_code')}>รหัสอนุมัติ</th>
                <th onClick={()=>handleSort('doc_no')} className={getHeaderClass('doc_no')}>เลขที่หนังสือ</th>
                <th onClick={()=>handleSort('doc_date')} className={getHeaderClass('doc_date')}>ลงวันที่</th>
                <th onClick={()=>handleSort('status')} className={getHeaderClass('status')}>สถานะ</th>
                <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-24">Action</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {items.map((group, index) => (
                <React.Fragment key={group.id}>
                  <tr className="hover:bg-gray-50">
                    <td className="px-3 py-2 text-xs font-medium">{(page - 1) * pageSize + index + 1}</td>
                    <td className="px-3 py-2 text-xs">{formatDateTime(group.created_at)}</td>
                    {/* <td className="px-3 py-2 text-xs font-medium text-blue-600">{group.id}</td> */}
                    <td className="px-3 py-2 text-xs">{group.approve_code}</td>
                    <td className="px-3 py-2 text-xs">{group.doc_no}</td>
                    <td className="px-3 py-2 text-xs">{formatDate(group.doc_date)}</td>
                    <td className="px-3 py-2 text-xs">
                      <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                        group.status === 'APPROVED' ? 'bg-green-100 text-green-800' :
                        group.status === 'PENDING' ? 'bg-yellow-100 text-yellow-800' :
                        group.status === 'REJECTED' ? 'bg-red-100 text-red-800' :
                        group.status === 'CANCELLED' ? 'bg-gray-100 text-gray-800' :
                        'bg-blue-100 text-blue-800'
                      }`}>
                        {group.status}
                      </span>
                    </td>
                    <td className="px-3 py-2 text-xs font-medium w-24">
                      <button
                        onClick={() => toggleRowExpansion(group.id.toString())}
                        className="text-indigo-600 hover:text-indigo-900 cursor-pointer flex items-center gap-1"
                        title={expandedRows.has(group.id.toString()) ? 'ย่อรายการ' : 'ขยายรายการ'}
                      >
                        {expandedRows.has(group.id.toString()) ? (
                          <ChevronDown className="h-4 w-4" />
                        ) : (
                          <ChevronRight className="h-4 w-4" />
                        )}
                        <span className="text-xs">{group.item_count} รายการ</span>
                      </button>
                    </td>
                  </tr>
                  {expandedRows.has(group.id.toString()) && (
                    <tr>
                      <td colSpan={6} className="px-0 py-0 bg-gray-50">
                        <div className="px-4 py-3">
                          <div className="text-sm font-medium text-gray-700 mb-2">รายการย่อย ({group.item_count} รายการ)</div>
                          <div className="overflow-x-auto">
                            <table className="min-w-full divide-y divide-gray-200 border border-gray-200">
                              <thead className="bg-gray-100">
                                <tr>
                                  <th className="px-3 py-2 text-left text-[10px] font-medium text-gray-600 uppercase tracking-wider">รหัสสินค้า</th>
                                  <th className="px-3 py-2 text-left text-[10px] font-medium text-gray-600 uppercase tracking-wider">ชื่อสินค้า</th>
                                  {/* <th className="px-3 py-2 text-left text-[10px] font-medium text-gray-600 uppercase tracking-wider">หมวด</th> */}
                                  <th className="px-3 py-2 text-left text-[10px] font-medium text-gray-600 uppercase tracking-wider">จำนวน</th>
                                  <th className="px-3 py-2 text-left text-[10px] font-medium text-gray-600 uppercase tracking-wider">หน่วย</th>
                                  <th className="px-3 py-2 text-left text-[10px] font-medium text-gray-600 uppercase tracking-wider">ราคา/หน่วย</th>
                                  <th className="px-3 py-2 text-left text-[10px] font-medium text-gray-600 uppercase tracking-wider">มูลค่ารวม</th>
                                </tr>
                              </thead>
                              <tbody className="bg-white divide-y divide-gray-100">
                                {group.sub_items?.map((item, subIndex) => (
                                  <tr key={item.id} className="hover:bg-gray-50">
                                    <td className="px-3 py-2 text-xs font-medium">{item.product_code || '-'}</td>
                                    <td className="px-3 py-2 text-sm">
                                      <div className="font-medium text-gray-900">{item.product_name || '-'}</div>
                                      <div className="mt-1 text-[11px] text-gray-500">
                                        {[item.category || '-', item.product_type || '-', item.product_subtype || '-']
                                          .filter((value, index, arr) => !(value === '-' && arr.every(v => v === '-')))
                                          .join(' · ')}
                                      </div>
                                    </td>
                                    {/* <td className="px-3 py-2 text-xs">{item.category || '-'}</td> */}
                                    <td className="px-3 py-2 text-xs text-right">{item.requested_quantity?.toLocaleString() || '-'}</td>
                                    <td className="px-3 py-2 text-xs">{item.unit || '-'}</td>
                                    <td className="px-3 py-2 text-xs text-right">{item.price_per_unit ? Number(item.price_per_unit).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                                    <td className="px-3 py-2 text-xs text-right font-medium">{item.total_value ? Number(item.total_value).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '-'}</td>
                                  </tr>
                                ))}
                              </tbody>
                            </table>
                          </div>
                        </div>
                      </td>
                    </tr>
                  )}
                </React.Fragment>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}