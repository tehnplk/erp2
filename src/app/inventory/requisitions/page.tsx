'use client';

import { useEffect, useMemo, useRef, useState, type KeyboardEvent } from 'react';
import Link from 'next/link';
import { X } from 'lucide-react';
import Swal from 'sweetalert2';

type RequisitionRow = {
  id: number;
  requisition_no: string;
  request_date: string;
  requesting_department: string;
  status: string;
  requested_by: string | null;
  approved_by: string | null;
  requested_qty_total: number;
  approved_qty_total: number;
  issued_qty_total: number;
  items: RequisitionItemRow[];
};

type RequisitionItemRow = {
  id: number;
  requisition_id: number;
  inventory_item_id: number;
  requested_qty: number;
  approved_qty: number;
  issued_qty: number;
  line_status: string;
  note: string | null;
  product_code: string | null;
  product_name: string | null;
  available_qty: number;
};

type BalanceOption = {
  inventory_item_id: number;
  product_code: string;
  product_name: string;
  available_qty: number;
  avg_cost: number;
  unit?: string | null;
};

type ApiResponse<T> = {
  success: boolean;
  data: T;
  error?: string;
};

function formatNumber(value: number) {
  return new Intl.NumberFormat('th-TH').format(value);
}

export default function InventoryRequisitionsPage() {
  const [items, setItems] = useState<RequisitionRow[]>([]);
  const [balance_options, setBalanceOptions] = useState<BalanceOption[]>([]);
  const [department, setDepartment] = useState('กลุ่มงานบริหารทั่วไป');
  const [requested_by, setRequestedBy] = useState('');
  const [selected_item_id, setSelectedItemId] = useState('');
  const [product_search, setProductSearch] = useState('');
  const [showProductSuggestions, setShowProductSuggestions] = useState(false);
  const [highlightedProductIndex, setHighlightedProductIndex] = useState(-1);
  const [requested_qty, setRequestedQty] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [approving_id, setApprovingId] = useState<number | null>(null);
  const [expanded_requisition_id, setExpandedRequisitionId] = useState<number | null>(null);
  const [message, setMessage] = useState('');
  const [isError, setIsError] = useState(false);
  const [loading, setLoading] = useState(true);

  const [cancelling_id, setCancellingId] = useState<number | null>(null);
  const productSearchInputRef = useRef<HTMLInputElement | null>(null);
  const requestedQtyInputRef = useRef<HTMLInputElement | null>(null);

  const [cart, setCart] = useState<{ inventory_item_id: number; product_code: string; product_name: string; requested_qty: number }[]>([]);

  const selectedOption = useMemo(
    () => balance_options.find((item) => String(item.inventory_item_id) === selected_item_id),
    [balance_options, selected_item_id]
  );

  const filteredBalanceOptions = useMemo(() => {
    const keyword = product_search.trim().toLowerCase();
    if (!keyword) {
      return balance_options.slice(0, 20);
    }

    return balance_options
      .filter((item) => `${item.product_code} ${item.product_name}`.toLowerCase().includes(keyword))
      .slice(0, 20);
  }, [balance_options, product_search]);

  const handleAddToCart = () => {
    if (!selected_item_id || !selectedOption) {
      setIsError(true);
      setMessage('กรุณาเลือกสินค้า');
      return;
    }
    if (!requested_qty.trim()) {
      setIsError(true);
      setMessage('กรุณากรอกจำนวนที่ต้องการ');
      return;
    }

    const qty = Number(requested_qty);
    if (qty <= 0) {
      setIsError(true);
      setMessage('กรุณาระบุจำนวนที่ถูกต้อง');
      return;
    }

    if (qty > selectedOption.available_qty) {
      setIsError(true);
      setMessage(`จำนวนที่ขอ (${formatNumber(qty)}) เกินกว่าจำนวนคงเหลือ (${formatNumber(selectedOption.available_qty)})`);
      return;
    }

    // Check if item already in cart
    const existing = cart.find(c => c.inventory_item_id === selectedOption.inventory_item_id);
    if (existing) {
      setCart(cart.map(c => c.inventory_item_id === selectedOption.inventory_item_id ? { ...c, requested_qty: c.requested_qty + qty } : c));
    } else {
      setCart([...cart, {
        inventory_item_id: selectedOption.inventory_item_id,
        product_code: selectedOption.product_code,
        product_name: selectedOption.product_name,
        requested_qty: qty
      }]);
    }
    
    setSelectedItemId('');
    setProductSearch('');
    setShowProductSuggestions(false);
    setHighlightedProductIndex(-1);
    setRequestedQty('');
    setMessage('');

    window.setTimeout(() => {
      productSearchInputRef.current?.focus();
    }, 0);
  };

  const handleSelectProduct = (item: BalanceOption) => {
    setSelectedItemId(String(item.inventory_item_id));
    setProductSearch(`${item.product_code} - ${item.product_name}`);
    setShowProductSuggestions(false);
    setHighlightedProductIndex(-1);
    setIsError(false);
    setMessage('');

    window.setTimeout(() => {
      requestedQtyInputRef.current?.focus();
    }, 0);
  };

  const handleClearProductSearch = () => {
    setSelectedItemId('');
    setProductSearch('');
    setShowProductSuggestions(false);
    setHighlightedProductIndex(-1);
  };

  const handleProductSearchKeyDown = (event: KeyboardEvent<HTMLInputElement>) => {
    if (!showProductSuggestions && (event.key === 'ArrowDown' || event.key === 'ArrowUp')) {
      setShowProductSuggestions(true);
    }

    if (event.key === 'ArrowDown') {
      event.preventDefault();
      if (filteredBalanceOptions.length === 0) {
        return;
      }
      setHighlightedProductIndex((prev) => (prev + 1) % filteredBalanceOptions.length);
      return;
    }

    if (event.key === 'ArrowUp') {
      event.preventDefault();
      if (filteredBalanceOptions.length === 0) {
        return;
      }
      setHighlightedProductIndex((prev) => (prev <= 0 ? filteredBalanceOptions.length - 1 : prev - 1));
      return;
    }

    if (event.key === 'Enter') {
      if (!showProductSuggestions || filteredBalanceOptions.length === 0) {
        return;
      }
      event.preventDefault();
      const selectedItem = filteredBalanceOptions[highlightedProductIndex >= 0 ? highlightedProductIndex : 0];
      if (selectedItem) {
        handleSelectProduct(selectedItem);
      }
      return;
    }

    if (event.key === 'Escape') {
      setShowProductSuggestions(false);
      setHighlightedProductIndex(-1);
    }
  };

  const handleRemoveFromCart = (id: number) => {
    setCart(cart.filter(c => c.inventory_item_id !== id));
  };

  const fetchRequisitions = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/inventory/requisitions?page=1&page_size=100');
      const payload: ApiResponse<RequisitionRow[]> = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'โหลด requisition ไม่สำเร็จ');
      }
      setItems(payload.data || []);
    } catch (error) {
      console.error(error);
      setIsError(true);
      setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด');
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = async (item: RequisitionRow) => {
    const confirmation = await Swal.fire({
      title: 'ยืนยันการยกเลิก?',
      text: `ต้องการยกเลิกคำขอเบิก ${item.requisition_no} ใช่หรือไม่?`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'ยืนยัน',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
    });
    if (!confirmation.isConfirmed) return;
    
    try {
      setCancellingId(item.id);
      setIsError(false);
      setMessage('');
      const response = await fetch(`/api/inventory/requisitions/cancel?requisition_id=${item.id}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          cancelled_by: requested_by || undefined,
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'ยกเลิก requisition ไม่สำเร็จ');
      }

      setMessage(`ยกเลิก ${item.requisition_no} สำเร็จ`);
      setIsError(false);
      await fetchRequisitions();
      await fetchBalances();
    } catch (error) {
      console.error(error);
      setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการยกเลิก');
    } finally {
      setCancellingId(null);
    }
  };

  const handleApprove = async (item: RequisitionRow) => {
    if (!item.items || item.items.length === 0) {
      return;
    }

    try {
      setApprovingId(item.id);
      setIsError(false);
      setMessage('');
      const response = await fetch(`/api/inventory/requisitions/approve?requisition_id=${item.id}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          approved_by: requested_by || undefined,
          items: item.items.map((line) => ({
            requisition_item_id: line.id,
            approved_qty: Math.min(Number(line.requested_qty || 0), Number(line.available_qty || 0)),
          })),
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'อนุมัติ requisition ไม่สำเร็จ');
      }

      setMessage(`อนุมัติ ${item.requisition_no} สำเร็จ`);
      setIsError(false);
      await fetchRequisitions();
      await fetchBalances();
    } catch (error) {
      console.error(error);
      setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการอนุมัติ');
    } finally {
      setApprovingId(null);
    }
  };

  const fetchBalances = async () => {
    try {
      const response = await fetch('/api/inventory/balances?page=1&page_size=200');
      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'โหลด stock options ไม่สำเร็จ');
      }
      setBalanceOptions(
        (payload.data || []).map((item: any) => ({
          inventory_item_id: item.inventory_item_id,
          product_code: item.product_code,
          product_name: item.product_name,
          available_qty: Number(item.available_qty || 0),
          avg_cost: Number(item.avg_cost || 0),
          unit: item.unit || null,
        }))
      );
    } catch (error) {
      console.error(error);
    }
  };

  useEffect(() => {
    fetchRequisitions();
    fetchBalances();
  }, []);

  useEffect(() => {
    if (!selectedOption) {
      return;
    }

    setProductSearch(`${selectedOption.product_code} - ${selectedOption.product_name}`);
  }, [selectedOption]);

  useEffect(() => {
    setHighlightedProductIndex(filteredBalanceOptions.length > 0 ? 0 : -1);
  }, [filteredBalanceOptions]);

  const handleCreate = async () => {
    if (cart.length === 0) {
      setIsError(true);
      setMessage('กรุณาเลือกสินค้าอย่างน้อย 1 รายการ');
      return;
    }

    try {
      setSubmitting(true);
      setIsError(false);
      setMessage('');
      const response = await fetch('/api/inventory/requisitions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          requesting_department: department,
          requested_by: requested_by || undefined,
          items: cart.map(item => ({
            inventory_item_id: item.inventory_item_id,
            requested_qty: item.requested_qty,
          })),
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'สร้าง requisition ไม่สำเร็จ');
      }

      setMessage('บันทึกคำขอเบิกสินค้าเรียบร้อยแล้ว');
      setIsError(false);
      setCart([]);
      await fetchRequisitions();
      await fetchBalances();
    } catch (error) {
      console.error(error);
      setIsError(true);
      setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-6 flex items-center justify-between gap-4">
          <div>
            <p className="text-sm font-medium uppercase tracking-[0.2em] text-slate-500">Inventory Requisitions</p>
            <h1 className="mt-1 text-3xl font-bold text-slate-900">คำขอเบิกสินค้า</h1>
            <p className="mt-2 text-sm text-slate-600">จัดทำคำขอเบิกจากยอดคงเหลือในคลัง เพื่อส่งต่อเข้าสู่กระบวนการอนุมัติและจ่ายสินค้า</p>
          </div>
          <Link href="/inventory" className="rounded-xl border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-100">
            กลับหน้าหลักระบบคลังสินค้า
          </Link>
        </div>

        <div className="mb-6 space-y-4 rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
          <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
            <label className="text-sm font-medium text-slate-700">
              หน่วยงานที่ขอ
              <input value={department} onChange={(e) => setDepartment(e.target.value)} className="mt-2 w-full rounded-xl border border-slate-300 px-3 py-2 focus:border-blue-500 focus:ring-1 focus:ring-blue-500" />
            </label>
            <label className="text-sm font-medium text-slate-700">
              ผู้ขอ
              <input value={requested_by} onChange={(e) => setRequestedBy(e.target.value)} className="mt-2 w-full rounded-xl border border-slate-300 px-3 py-2 focus:border-blue-500 focus:ring-1 focus:ring-blue-500" />
            </label>
          </div>

          <div className="rounded-3xl border border-slate-200 bg-white p-5 shadow-sm">
            <div className="grid grid-cols-1 gap-4 lg:grid-cols-[minmax(0,1fr)_180px_140px_150px] lg:items-end">
              <div className="min-w-0">
                <label className="text-sm font-medium text-slate-700">สินค้าที่ต้องการเบิก</label>
                <div className="relative mt-2">
                  <input
                    ref={productSearchInputRef}
                    value={product_search}
                    onChange={(e) => {
                      setProductSearch(e.target.value);
                      setSelectedItemId('');
                      setShowProductSuggestions(true);
                      setHighlightedProductIndex(0);
                    }}
                    onFocus={() => setShowProductSuggestions(true)}
                    onKeyDown={handleProductSearchKeyDown}
                    onBlur={() => {
                      window.setTimeout(() => {
                        setShowProductSuggestions(false);
                      }, 150);
                    }}
                    placeholder="ค้นหาจากรหัสหรือชื่อสินค้า"
                    className="w-full rounded-2xl border border-slate-300 bg-white px-4 py-3 pr-11 text-sm focus:border-blue-500"
                  />
                  {product_search ? (
                    <button
                      type="button"
                      onMouseDown={(event) => event.preventDefault()}
                      onClick={handleClearProductSearch}
                      className="absolute right-3 top-1/2 -translate-y-1/2 rounded-full p-1 text-slate-400 transition hover:bg-slate-100 hover:text-slate-600"
                      aria-label="ล้างคำค้นสินค้า"
                    >
                      <X className="h-4 w-4" />
                    </button>
                  ) : null}
                  {showProductSuggestions && filteredBalanceOptions.length > 0 ? (
                    <div className="absolute z-20 mt-2 max-h-72 w-full overflow-y-auto rounded-2xl border border-slate-200 bg-white shadow-lg">
                      {filteredBalanceOptions.map((item) => (
                        <button
                          key={item.inventory_item_id}
                          type="button"
                          onMouseDown={(event) => event.preventDefault()}
                          onClick={() => handleSelectProduct(item)}
                          onMouseEnter={() => setHighlightedProductIndex(filteredBalanceOptions.findIndex((option) => option.inventory_item_id === item.inventory_item_id))}
                          className={`flex w-full flex-col gap-1 border-b border-slate-100 px-4 py-3 text-left last:border-b-0 hover:bg-slate-50 ${
                            highlightedProductIndex >= 0 && filteredBalanceOptions[highlightedProductIndex]?.inventory_item_id === item.inventory_item_id
                              ? 'bg-slate-100'
                              : ''
                          }`}
                        >
                          <span className="text-sm font-medium text-slate-900">{item.product_code}</span>
                          <span className="text-sm text-slate-600">{item.product_name}</span>
                        </button>
                      ))}
                    </div>
                  ) : null}
                </div>
              </div>
              <div className="min-w-0">
                <label className="text-sm font-medium text-slate-700">สถานะคงเหลือ</label>
                <div className="mt-2 flex h-[50px] items-center rounded-2xl border border-slate-200 bg-slate-50 px-4 text-sm font-semibold text-slate-900">
                  {selectedOption ? `${formatNumber(selectedOption.available_qty)} ${selectedOption.unit || ''}` : ''}
                </div>
              </div>
              <div className="min-w-0">
                <label className="text-sm font-medium text-slate-700">จำนวนขอเบิก</label>
                <input
                  ref={requestedQtyInputRef}
                  value={requested_qty}
                  onChange={(e) => setRequestedQty(e.target.value)}
                  onKeyDown={(event) => {
                    if (event.key === 'Enter') {
                      event.preventDefault();
                      handleAddToCart();
                    }
                  }}
                  type="number"
                  min="1"
                  className="mt-2 h-[50px] w-full rounded-2xl border border-slate-300 bg-white px-4 text-sm focus:border-blue-500"
                />
              </div>
              <div className="min-w-0">
                <div className="h-5" aria-hidden="true" />
                <button
                  type="button"
                  onClick={handleAddToCart}
                  className="mt-2 h-[50px] w-full rounded-2xl bg-slate-900 px-4 text-sm font-semibold text-white shadow-sm transition hover:bg-slate-800"
                >
                  เพิ่มลงรายการ
                </button>
              </div>
            </div>
            {message ? (
              <div
                className={`mt-4 rounded-2xl border px-4 py-3 text-sm ${
                  isError ? 'border-red-200 bg-red-50 text-red-800' : 'border-emerald-200 bg-emerald-50 text-emerald-800'
                }`}
              >
                {message}
              </div>
            ) : null}
          </div>

          {cart.length > 0 && (
            <div className="mt-4 overflow-hidden rounded-2xl border border-slate-200 bg-white">
              <div className="bg-slate-50 px-4 py-2 text-xs font-bold uppercase tracking-wider text-slate-500">รายการเบิกที่รอการส่ง</div>
              <table className="min-w-full divide-y divide-slate-100 text-sm">
                <thead>
                  <tr className="text-left text-slate-600">
                    <th className="px-4 py-2">สินค้า</th>
                    <th className="px-4 py-2 text-right">จำนวน</th>
                    <th className="px-4 py-2 text-right">จัดการ</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {cart.map((item) => (
                    <tr key={item.inventory_item_id}>
                      <td className="px-4 py-3">
                        <div className="font-medium text-slate-900">{item.product_code}</div>
                        <div className="text-xs text-slate-500">{item.product_name}</div>
                      </td>
                      <td className="px-4 py-3 text-right font-medium">{formatNumber(item.requested_qty)}</td>
                      <td className="px-4 py-3 text-right">
                        <button type="button" onClick={() => handleRemoveFromCart(item.inventory_item_id)} className="text-red-600 hover:text-red-800">ลบ</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
                <tfoot className="bg-slate-50">
                  <tr>
                    <td colSpan={3} className="px-4 py-3">
                      <button type="button" onClick={handleCreate} disabled={submitting} className="w-full rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-medium text-white shadow-sm transition hover:bg-blue-700 disabled:bg-slate-300">
                        {submitting ? 'กำลังบันทึก...' : `ยืนยันบันทึกคำขอเบิก (${cart.length} รายการ)`}
                      </button>
                    </td>
                  </tr>
                </tfoot>
              </table>
            </div>
          )}
        </div>

        <div className="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200 text-sm">
              <thead className="bg-slate-100 text-left text-xs uppercase tracking-wider text-slate-500">
                <tr>
                  <th className="px-4 py-3">เลขที่เอกสาร</th>
                  <th className="px-4 py-3">วันที่ขอ</th>
                  <th className="px-4 py-3">หน่วยงาน</th>
                  <th className="px-4 py-3">สถานะ</th>
                  <th className="px-4 py-3 text-right">ที่ขอ</th>
                  <th className="px-4 py-3 text-right">อนุมัติ</th>
                  <th className="px-4 py-3 text-right">จ่ายแล้ว</th>
                  <th className="px-4 py-3 text-right">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 bg-white">
                {loading ? (
                  <tr>
                    <td colSpan={8} className="px-4 py-10 text-center text-slate-500">กำลังโหลดข้อมูล...</td>
                  </tr>
                ) : items.length === 0 ? (
                  <tr>
                    <td colSpan={8} className="px-4 py-10 text-center text-slate-500">ยังไม่มีคำขอเบิกในระบบ</td>
                  </tr>
                ) : (
                  items.flatMap((item) => {
                    const isExpanded = expanded_requisition_id === item.id;
                    const canApprove = ['DRAFT', 'SUBMITTED', 'PARTIALLY_APPROVED'].includes(item.status);
                    const canCancel = !['ISSUED', 'CANCELLED', 'REJECTED'].includes(item.status);

                    return [
                      <tr key={`row-${item.id}`} className="hover:bg-slate-50">
                        <td className="px-4 py-3 font-medium text-slate-900">{item.requisition_no}</td>
                        <td className="px-4 py-3 text-slate-600">{item.request_date ? new Date(item.request_date).toLocaleString('th-TH') : '-'}</td>
                        <td className="px-4 py-3 text-slate-700">{item.requesting_department}</td>
                        <td className="px-4 py-3"><span className="rounded-full bg-violet-100 px-3 py-1 text-xs font-medium text-violet-800">{item.status}</span></td>
                        <td className="px-4 py-3 text-right text-slate-700">{formatNumber(Number(item.requested_qty_total || 0))}</td>
                        <td className="px-4 py-3 text-right text-slate-700">{formatNumber(Number(item.approved_qty_total || 0))}</td>
                        <td className="px-4 py-3 text-right font-semibold text-emerald-700">{formatNumber(Number(item.issued_qty_total || 0))}</td>
                        <td className="px-4 py-3 text-right">
                          <div className="flex justify-end gap-2">
                            <button
                              type="button"
                              onClick={() => setExpandedRequisitionId(isExpanded ? null : item.id)}
                              className="rounded-xl border border-slate-300 bg-white px-3 py-2 text-xs font-medium text-slate-700 shadow-sm hover:bg-slate-100"
                            >
                              {isExpanded ? 'ซ่อนรายการ' : 'ดูรายการ'}
                            </button>
                            {canApprove && (
                              <button
                                type="button"
                                onClick={() => handleApprove(item)}
                                disabled={approving_id === item.id}
                                className="rounded-xl bg-emerald-600 px-3 py-2 text-xs font-medium text-white shadow-sm transition hover:bg-emerald-700 disabled:cursor-not-allowed disabled:bg-slate-300"
                              >
                                {approving_id === item.id ? 'กำลังอนุมัติ...' : 'อนุมัติ'}
                              </button>
                            )}
                            {canCancel && (
                              <button
                                type="button"
                                onClick={() => handleCancel(item)}
                                disabled={cancelling_id === item.id}
                                className="rounded-xl border border-red-200 bg-red-50 text-red-600 px-3 py-2 text-xs font-medium shadow-sm transition hover:bg-red-100 disabled:cursor-not-allowed disabled:opacity-50"
                              >
                                {cancelling_id === item.id ? 'กำลังยกเลิก...' : 'ยกเลิก'}
                              </button>
                            )}
                            <Link
                              href={`/inventory/issues?requisition_id=${item.id}`}
                              className="rounded-xl border border-slate-300 bg-white px-3 py-2 text-xs font-medium text-slate-700 shadow-sm hover:bg-slate-100"
                            >
                              ไปหน้าจ่าย
                            </Link>
                          </div>
                        </td>
                      </tr>,
                      ...(isExpanded
                        ? [
                            <tr key={`detail-${item.id}`} className="bg-slate-50">
                              <td colSpan={8} className="px-4 py-4">
                                <div className="rounded-2xl border border-slate-200 bg-white p-4">
                                  <div className="mb-3 text-sm font-medium text-slate-900">รายละเอียดสินค้าในคำขอเบิก</div>
                                  <div className="overflow-x-auto">
                                    <table className="min-w-full text-sm">
                                      <thead>
                                        <tr className="border-b border-slate-200 text-left text-xs uppercase tracking-wider text-slate-500">
                                          <th className="px-3 py-2">สินค้า</th>
                                          <th className="px-3 py-2 text-right">ขอเบิก</th>
                                          <th className="px-3 py-2 text-right">อนุมัติ</th>
                                          <th className="px-3 py-2 text-right">จ่ายแล้ว</th>
                                          <th className="px-3 py-2 text-right">พร้อมใช้</th>
                                          <th className="px-3 py-2">สถานะรายการ</th>
                                        </tr>
                                      </thead>
                                      <tbody>
                                        {item.items.map((line) => (
                                          <tr key={line.id} className="border-b border-slate-100 last:border-b-0">
                                            <td className="px-3 py-2 text-slate-700">
                                              <div className="font-medium text-slate-900">{line.product_code || '-'}</div>
                                              <div>{line.product_name || '-'}</div>
                                            </td>
                                            <td className="px-3 py-2 text-right">{formatNumber(Number(line.requested_qty || 0))}</td>
                                            <td className="px-3 py-2 text-right">{formatNumber(Number(line.approved_qty || 0))}</td>
                                            <td className="px-3 py-2 text-right">{formatNumber(Number(line.issued_qty || 0))}</td>
                                            <td className="px-3 py-2 text-right">{formatNumber(Number(line.available_qty || 0))}</td>
                                            <td className="px-3 py-2 text-slate-600">{line.line_status}</td>
                                          </tr>
                                        ))}
                                      </tbody>
                                    </table>
                                  </div>
                                </div>
                              </td>
                            </tr>,
                          ]
                        : []),
                    ];
                  })
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
