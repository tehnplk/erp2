'use client';

import { useEffect, useMemo, useState } from 'react';
import Link from 'next/link';

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
  const [loading, setLoading] = useState(true);

  const selectedOption = useMemo(
    () => balanceOptions.find((item) => String(item.inventoryItemId) === selectedItemId),
    [balanceOptions, selectedItemId]
  );

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
      setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด');
    } finally {
      setLoading(false);
    }
  };

  const handleApprove = async (item: RequisitionRow) => {
    if (!item.items || item.items.length === 0) {
      return;
    }

    try {
      setApprovingId(item.id);
      setMessage('');
      const response = await fetch(`/api/inventory/requisitions/approve?requisitionId=${item.id}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          approvedBy: requestedBy || 'warehouse-admin',
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
    if (!selectedItemId) {
      setMessage('กรุณาเลือกสินค้า');
      return;
    }

    try {
      setSubmitting(true);
      setMessage('');
      const response = await fetch('/api/inventory/requisitions', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          requestingDepartment: department,
          requestedBy: requestedBy || null,
          items: [
            {
              inventoryItemId: Number(selectedItemId),
              requestedQty: Number(requestedQty),
            },
          ],
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'สร้าง requisition ไม่สำเร็จ');
      }

      setMessage('บันทึกคำขอเบิกสินค้าเรียบร้อยแล้ว');
      setRequestedQty('1');
      setSelectedItemId('');
      await fetchRequisitions();
    } catch (error) {
      console.error(error);
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

        <div className="mb-6 grid grid-cols-1 gap-4 rounded-3xl border border-slate-200 bg-white p-5 shadow-sm lg:grid-cols-4">
          <label className="text-sm text-slate-600">
            หน่วยงานที่ขอ
            <input value={department} onChange={(e) => setDepartment(e.target.value)} className="mt-2 w-full rounded-xl border border-slate-300 px-3 py-2 focus:border-blue-500" />
          </label>
          <label className="text-sm text-slate-600">
            ผู้ขอ
            <input value={requestedBy} onChange={(e) => setRequestedBy(e.target.value)} className="mt-2 w-full rounded-xl border border-slate-300 px-3 py-2 focus:border-blue-500" />
          </label>
          <label className="text-sm text-slate-600 lg:col-span-2">
            สินค้า
            <select value={selectedItemId} onChange={(e) => setSelectedItemId(e.target.value)} className="mt-2 w-full rounded-xl border border-slate-300 px-3 py-2 focus:border-blue-500">
              <option value="">เลือกสินค้า</option>
              {balanceOptions.map((item) => (
                <option key={item.inventoryItemId} value={item.inventoryItemId}>
                  {item.productCode} - {item.productName} (พร้อมใช้ {formatNumber(item.availableQty)})
                </option>
              ))}
            </select>
          </label>
          <label className="text-sm text-slate-600">
            จำนวนที่ขอ
            <input value={requestedQty} onChange={(e) => setRequestedQty(e.target.value)} type="number" min="1" className="mt-2 w-full rounded-xl border border-slate-300 px-3 py-2 focus:border-blue-500" />
          </label>
          <div className="flex items-end">
            <button type="button" onClick={handleCreate} disabled={submitting} className="w-full rounded-xl bg-blue-600 px-4 py-2.5 text-sm font-medium text-white shadow-sm transition hover:bg-blue-700 disabled:bg-slate-300">
              {submitting ? 'กำลังบันทึก...' : 'บันทึกคำขอเบิก'}
            </button>
          </div>
          <div className="rounded-2xl bg-slate-50 p-4 text-sm text-slate-600">
            <p className="font-medium text-slate-900">รายการที่เลือก</p>
            <p className="mt-2">{selectedOption ? `${selectedOption.productCode} - ${selectedOption.productName}` : 'ยังไม่ได้เลือกสินค้า'}</p>
            <p className="mt-1">จำนวนพร้อมใช้: {formatNumber(selectedOption?.availableQty || 0)}</p>
          </div>
        </div>

        {message ? <div className="mb-4 rounded-2xl border border-blue-200 bg-blue-50 px-4 py-3 text-sm text-blue-800">{message}</div> : null}

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
                            <button
                              type="button"
                              onClick={() => handleApprove(item)}
                              disabled={approvingId === item.id || !['DRAFT', 'SUBMITTED', 'PARTIALLY_APPROVED'].includes(item.status)}
                              className="rounded-xl bg-emerald-600 px-3 py-2 text-xs font-medium text-white shadow-sm transition hover:bg-emerald-700 disabled:cursor-not-allowed disabled:bg-slate-300"
                            >
                              {approvingId === item.id ? 'กำลังอนุมัติ...' : 'อนุมัติ'}
                            </button>
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
