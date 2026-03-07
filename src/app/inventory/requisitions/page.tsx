'use client';

import { useEffect, useMemo, useState } from 'react';
import Link from 'next/link';
import Swal from 'sweetalert2';

type RequisitionRow = {
  id: number;
  requisitionNo: string;
  requestDate: string;
  requestingDepartment: string;
  status: string;
  requestedBy: string | null;
  approvedBy: string | null;
  requestedQtyTotal: number;
  approvedQtyTotal: number;
  issuedQtyTotal: number;
  items: RequisitionItemRow[];
};

type RequisitionItemRow = {
  id: number;
  requisitionId: number;
  inventoryItemId: number;
  requestedQty: number;
  approvedQty: number;
  issuedQty: number;
  lineStatus: string;
  note: string | null;
  productCode: string | null;
  productName: string | null;
  availableQty: number;
};

type BalanceOption = {
  inventoryItemId: number;
  productCode: string;
  productName: string;
  availableQty: number;
  avgCost: number;
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
  const [balanceOptions, setBalanceOptions] = useState<BalanceOption[]>([]);
  const [department, setDepartment] = useState('กลุ่มงานบริหารทั่วไป');
  const [requestedBy, setRequestedBy] = useState('');
  const [selectedItemId, setSelectedItemId] = useState('');
  const [requestedQty, setRequestedQty] = useState('1');
  const [submitting, setSubmitting] = useState(false);
  const [approvingId, setApprovingId] = useState<number | null>(null);
  const [expandedRequisitionId, setExpandedRequisitionId] = useState<number | null>(null);
  const [message, setMessage] = useState('');
  const [isError, setIsError] = useState(false);
  const [loading, setLoading] = useState(true);

  const [cancellingId, setCancellingId] = useState<number | null>(null);

  const [cart, setCart] = useState<{ inventoryItemId: number; productCode: string; productName: string; requestedQty: number }[]>([]);

  const selectedOption = useMemo(
    () => balanceOptions.find((item) => String(item.inventoryItemId) === selectedItemId),
    [balanceOptions, selectedItemId]
  );

  const handleAddToCart = () => {
    if (!selectedItemId || !selectedOption) {
      setIsError(true);
      setMessage('กรุณาเลือกสินค้า');
      return;
    }
    const qty = Number(requestedQty);
    if (qty <= 0) {
      setIsError(true);
      setMessage('กรุณาระบุจำนวนที่ถูกต้อง');
      return;
    }

    if (qty > selectedOption.availableQty) {
      setIsError(true);
      setMessage(`จำนวนที่ขอ (${formatNumber(qty)}) เกินกว่าจำนวนคงเหลือ (${formatNumber(selectedOption.availableQty)})`);
      return;
    }

    // Check if item already in cart
    const existing = cart.find(c => c.inventoryItemId === selectedOption.inventoryItemId);
    if (existing) {
      setCart(cart.map(c => c.inventoryItemId === selectedOption.inventoryItemId ? { ...c, requestedQty: c.requestedQty + qty } : c));
    } else {
      setCart([...cart, {
        inventoryItemId: selectedOption.inventoryItemId,
        productCode: selectedOption.productCode,
        productName: selectedOption.productName,
        requestedQty: qty
      }]);
    }
    
    setSelectedItemId('');
    setRequestedQty('1');
    setMessage('');
  };

  const handleRemoveFromCart = (id: number) => {
    setCart(cart.filter(c => c.inventoryItemId !== id));
  };

  const fetchRequisitions = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/inventory/requisitions?page=1&pageSize=100');
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
      text: `ต้องการยกเลิกคำขอเบิก ${item.requisitionNo} ใช่หรือไม่?`,
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
      const response = await fetch(`/api/inventory/requisitions/cancel?requisitionId=${item.id}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          cancelledBy: requestedBy || undefined,
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'ยกเลิก requisition ไม่สำเร็จ');
      }

      setMessage(`ยกเลิก ${item.requisitionNo} สำเร็จ`);
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
      const response = await fetch(`/api/inventory/requisitions/approve?requisitionId=${item.id}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          approvedBy: requestedBy || undefined,
          items: item.items.map((line) => ({
            requisitionItemId: line.id,
            approvedQty: Math.min(Number(line.requestedQty || 0), Number(line.availableQty || 0)),
          })),
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'อนุมัติ requisition ไม่สำเร็จ');
      }

      setMessage(`อนุมัติ ${item.requisitionNo} สำเร็จ`);
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
      const response = await fetch('/api/inventory/balances?page=1&pageSize=200');
      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'โหลด stock options ไม่สำเร็จ');
      }
      setBalanceOptions(
        (payload.data || []).map((item: any) => ({
          inventoryItemId: item.inventoryItemId,
          productCode: item.productCode,
          productName: item.productName,
          availableQty: Number(item.availableQty || 0),
          avgCost: Number(item.avgCost || 0),
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
          requestingDepartment: department,
          requestedBy: requestedBy || undefined,
          items: cart.map(item => ({
            inventoryItemId: item.inventoryItemId,
            requestedQty: item.requestedQty,
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
              <input value={requestedBy} onChange={(e) => setRequestedBy(e.target.value)} className="mt-2 w-full rounded-xl border border-slate-300 px-3 py-2 focus:border-blue-500 focus:ring-1 focus:ring-blue-500" />
            </label>
          </div>

          <div className="grid grid-cols-1 gap-4 rounded-2xl bg-slate-50 p-4 lg:grid-cols-5">
            <div className="lg:col-span-2">
              <label className="text-sm font-medium text-slate-700">สินค้าที่ต้องการเบิก</label>
              <select value={selectedItemId} onChange={(e) => setSelectedItemId(e.target.value)} className="mt-2 w-full rounded-xl border border-slate-300 bg-white px-3 py-2 focus:border-blue-500">
                <option value="">เลือกสินค้า</option>
                {balanceOptions.map((item) => (
                  <option key={item.inventoryItemId} value={item.inventoryItemId}>
                    {item.productCode} - {item.productName} (พร้อมใช้ {formatNumber(item.availableQty)})
                  </option>
                ))}
              </select>
            </div>
            <div>
              <label className="text-sm font-medium text-slate-700">จำนวน</label>
              <input value={requestedQty} onChange={(e) => setRequestedQty(e.target.value)} type="number" min="1" className="mt-2 w-full rounded-xl border border-slate-300 bg-white px-3 py-2 focus:border-blue-500" />
            </div>
            <div className="flex items-end">
              <button type="button" onClick={handleAddToCart} className="w-full rounded-xl bg-slate-800 px-4 py-2.5 text-sm font-medium text-white transition hover:bg-slate-900">
                เพิ่มลงรายการ
              </button>
            </div>
            <div className="flex items-end">
                <div className="text-xs text-slate-500">
                    {selectedOption && (
                        <span>พร้อมใช้: {formatNumber(selectedOption.availableQty)}</span>
                    )}
                </div>
            </div>
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
                    <tr key={item.inventoryItemId}>
                      <td className="px-4 py-3">
                        <div className="font-medium text-slate-900">{item.productCode}</div>
                        <div className="text-xs text-slate-500">{item.productName}</div>
                      </td>
                      <td className="px-4 py-3 text-right font-medium">{formatNumber(item.requestedQty)}</td>
                      <td className="px-4 py-3 text-right">
                        <button type="button" onClick={() => handleRemoveFromCart(item.inventoryItemId)} className="text-red-600 hover:text-red-800">ลบ</button>
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

        {message ? (
          <div className={`mb-4 rounded-2xl border px-4 py-3 text-sm ${
            isError ? 'border-red-200 bg-red-50 text-red-800' : 'border-emerald-200 bg-emerald-50 text-emerald-800'
          }`}>
            {message}
          </div>
        ) : null}

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
                    const isExpanded = expandedRequisitionId === item.id;
                    const canApprove = ['DRAFT', 'SUBMITTED', 'PARTIALLY_APPROVED'].includes(item.status);
                    const canCancel = !['ISSUED', 'CANCELLED', 'REJECTED'].includes(item.status);

                    return [
                      <tr key={`row-${item.id}`} className="hover:bg-slate-50">
                        <td className="px-4 py-3 font-medium text-slate-900">{item.requisitionNo}</td>
                        <td className="px-4 py-3 text-slate-600">{item.requestDate ? new Date(item.requestDate).toLocaleString('th-TH') : '-'}</td>
                        <td className="px-4 py-3 text-slate-700">{item.requestingDepartment}</td>
                        <td className="px-4 py-3"><span className="rounded-full bg-violet-100 px-3 py-1 text-xs font-medium text-violet-800">{item.status}</span></td>
                        <td className="px-4 py-3 text-right text-slate-700">{formatNumber(Number(item.requestedQtyTotal || 0))}</td>
                        <td className="px-4 py-3 text-right text-slate-700">{formatNumber(Number(item.approvedQtyTotal || 0))}</td>
                        <td className="px-4 py-3 text-right font-semibold text-emerald-700">{formatNumber(Number(item.issuedQtyTotal || 0))}</td>
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
                                disabled={approvingId === item.id}
                                className="rounded-xl bg-emerald-600 px-3 py-2 text-xs font-medium text-white shadow-sm transition hover:bg-emerald-700 disabled:cursor-not-allowed disabled:bg-slate-300"
                              >
                                {approvingId === item.id ? 'กำลังอนุมัติ...' : 'อนุมัติ'}
                              </button>
                            )}
                            {canCancel && (
                              <button
                                type="button"
                                onClick={() => handleCancel(item)}
                                disabled={cancellingId === item.id}
                                className="rounded-xl border border-red-200 bg-red-50 text-red-600 px-3 py-2 text-xs font-medium shadow-sm transition hover:bg-red-100 disabled:cursor-not-allowed disabled:opacity-50"
                              >
                                {cancellingId === item.id ? 'กำลังยกเลิก...' : 'ยกเลิก'}
                              </button>
                            )}
                            <Link
                              href={`/inventory/issues?requisitionId=${item.id}`}
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
                                              <div className="font-medium text-slate-900">{line.productCode || '-'}</div>
                                              <div>{line.productName || '-'}</div>
                                            </td>
                                            <td className="px-3 py-2 text-right">{formatNumber(Number(line.requestedQty || 0))}</td>
                                            <td className="px-3 py-2 text-right">{formatNumber(Number(line.approvedQty || 0))}</td>
                                            <td className="px-3 py-2 text-right">{formatNumber(Number(line.issuedQty || 0))}</td>
                                            <td className="px-3 py-2 text-right">{formatNumber(Number(line.availableQty || 0))}</td>
                                            <td className="px-3 py-2 text-slate-600">{line.lineStatus}</td>
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
