"use client";

import { useEffect, useState } from 'react';
import Link from 'next/link';

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

type RequisitionRow = {
  id: number;
  requisitionNo: string;
  requestDate: string;
  requestingDepartment: string;
  status: string;
  items: RequisitionItemRow[];
};

type IssueRow = {
  id: number;
  issueNo: string;
  issueDate: string;
  requisitionId: number;
  requestingDepartment: string;
  status: string;
  issuedBy: string | null;
  approvedBy: string | null;
  issuedQtyTotal: number;
};

type ApiResponse<T> = {
  success: boolean;
  data: T;
  error?: string;
};

function formatNumber(value: number) {
  return new Intl.NumberFormat('th-TH').format(value);
}

export default function InventoryIssuesPage() {
  const [items, setItems] = useState<IssueRow[]>([]);
  const [requisitions, setRequisitions] = useState<RequisitionRow[]>([]);
  const [selectedRequisitionId, setSelectedRequisitionId] = useState('');
  const [issueQuantities, setIssueQuantities] = useState<Record<number, number>>({});
  const [posting, setPosting] = useState(false);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');

  useEffect(() => {
    const fetchIssues = async () => {
      try {
        setLoading(true);
        const response = await fetch('/api/inventory/issues');
        const payload: ApiResponse<IssueRow[]> = await response.json();
        if (!response.ok || !payload.success) {
          throw new Error(payload.error || 'โหลดรายการจ่ายไม่สำเร็จ');
        }
        setItems(payload.data || []);
      } catch (error) {
        console.error(error);
        setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด');
      } finally {
        setLoading(false);
      }
    };

    fetchIssues();
  }, []);

  useEffect(() => {
    const fetchApprovedRequisitions = async () => {
      try {
        const response = await fetch('/api/inventory/requisitions?page=1&pageSize=100');
        const payload: ApiResponse<RequisitionRow[]> = await response.json();
        if (!response.ok || !payload.success) {
          throw new Error(payload.error || 'โหลด requisition ไม่สำเร็จ');
        }
        setRequisitions((payload.data || []).filter((item) => ['APPROVED', 'PARTIALLY_APPROVED', 'PARTIALLY_ISSUED'].includes(item.status)));
      } catch (error) {
        console.error(error);
      }
    };

    fetchApprovedRequisitions();
  }, []);

  useEffect(() => {
    const requisitionId = new URLSearchParams(window.location.search).get('requisitionId');
    if (requisitionId) {
      setSelectedRequisitionId(requisitionId);
    }
  }, []);

  const selectedRequisition = requisitions.find((item) => String(item.id) === selectedRequisitionId);

  useEffect(() => {
    if (selectedRequisition) {
      const initialQuantities: Record<number, number> = {};
      selectedRequisition.items.forEach(item => {
        const remaining = Math.max(Number(item.approvedQty || 0) - Number(item.issuedQty || 0), 0);
        initialQuantities[item.id] = remaining;
      });
      setIssueQuantities(initialQuantities);
    } else {
      setIssueQuantities({});
    }
  }, [selectedRequisition]);

  const handleQtyChange = (itemId: number, qty: string) => {
    const numValue = qty ? Number(qty) : 0;
    setIssueQuantities(prev => ({
      ...prev,
      [itemId]: numValue
    }));
  };

  const handlePostIssue = async () => {
    if (!selectedRequisition) {
      setMessage('กรุณาเลือก requisition ที่อนุมัติแล้ว');
      return;
    }

    try {
      setPosting(true);
      setMessage('');
      
      const issueItems = selectedRequisition.items
        .map((item) => ({
          requisitionItemId: item.id,
          inventoryItemId: item.inventoryItemId,
          issuedQty: Math.max(0, issueQuantities[item.id] || 0),
        }))
        .filter((item) => item.issuedQty > 0);

      if (issueItems.length === 0) {
        setMessage('ไม่มีรายการที่ระบุจำนวนพร้อมจ่ายใน requisition นี้');
        return;
      }

      // Validate quantities before sending
      for (const item of selectedRequisition.items) {
        const qtyToIssue = issueQuantities[item.id] || 0;
        const remainingIssueQty = Math.max(Number(item.approvedQty || 0) - Number(item.issuedQty || 0), 0);
        if (qtyToIssue > remainingIssueQty) {
           setMessage(`รายการ ${item.productName || item.productCode} ระบุจำนวนจ่ายเกินยอดอนุมัติคงเหลือ`);
           return;
        }
      }

      const response = await fetch('/api/inventory/issues', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          requisitionId: selectedRequisition.id,
          requestingDepartment: selectedRequisition.requestingDepartment,
          issuedBy: 'warehouse-admin',
          approvedBy: 'warehouse-admin',
          items: issueItems,
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'จ่ายสินค้าไม่สำเร็จ');
      }

      setMessage(`บันทึกการจ่ายจาก ${selectedRequisition.requisitionNo} สำเร็จ`);
      setSelectedRequisitionId('');

      const refreshResponse = await fetch('/api/inventory/issues');
      const refreshPayload: ApiResponse<IssueRow[]> = await refreshResponse.json();
      if (refreshResponse.ok && refreshPayload.success) {
        setItems(refreshPayload.data || []);
      }
    } catch (error) {
      console.error(error);
      setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาดในการจ่าย');
    } finally {
      setPosting(false);
    }
  };

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
        <div className="mb-6 flex items-center justify-between gap-4">
          <div>
            <p className="text-sm font-medium uppercase tracking-[0.2em] text-slate-500">Inventory Issues</p>
            <h1 className="mt-1 text-3xl font-bold text-slate-900">รายการจ่ายสินค้า</h1>
            <p className="mt-2 text-sm text-slate-600">บันทึกและติดตามเอกสารจ่ายสินค้าจากคำขอเบิกที่ผ่านการอนุมัติแล้ว</p>
          </div>
          <Link href="/inventory" className="rounded-xl border border-slate-300 bg-white px-4 py-2 text-sm font-medium text-slate-700 shadow-sm hover:bg-slate-100">
            กลับหน้าหลักระบบคลังสินค้า
          </Link>
        </div>

        {message ? <div className="mb-4 rounded-2xl border border-blue-200 bg-blue-50 px-4 py-3 text-sm text-blue-800">{message}</div> : null}

        <div className="mb-6 rounded-3xl border border-slate-200 bg-white shadow-sm p-6 overflow-hidden">
          <div className="grid grid-cols-1 md:grid-cols-[2fr_auto] gap-6 max-w-4xl">
            <div className="flex flex-col justify-end">
              <label className="text-sm font-medium text-slate-700 mb-2">
                เลือกคำขอเบิกที่อนุมัติแล้ว
              </label>
              <select
                value={selectedRequisitionId}
                onChange={(e) => setSelectedRequisitionId(e.target.value)}
                className="w-full rounded-xl border border-slate-300 px-4 py-2.5 focus:border-blue-500 bg-slate-50 text-slate-900"
              >
                <option value="">-- กรุณาเลือกคำขอเบิก --</option>
                {requisitions.map((item) => (
                  <option key={item.id} value={item.id}>
                    {item.requisitionNo} - {item.requestingDepartment} ({item.status})
                  </option>
                ))}
              </select>
            </div>
            <div className="flex items-end">
              <button
                type="button"
                onClick={handlePostIssue}
                disabled={posting || !selectedRequisitionId}
                className="w-full md:w-auto rounded-xl bg-emerald-600 px-6 py-2.5 text-sm font-medium text-white shadow-sm transition hover:bg-emerald-700 disabled:bg-slate-300 whitespace-nowrap"
              >
                {posting ? 'กำลังบันทึก...' : 'บันทึกจ่ายสินค้า'}
              </button>
            </div>
          </div>
          
          {selectedRequisition ? (
            <div className="mt-8">
              <h3 className="mb-4 text-base font-medium text-slate-900 flex items-center gap-2">
                <span>รายการสินค้าเตรียมจ่าย</span>
                <span className="rounded bg-slate-100 px-2 py-0.5 text-xs text-slate-600 shrink-0 border border-slate-200">
                  {selectedRequisition.requisitionNo}
                </span>
              </h3>
              <div className="overflow-x-auto rounded-xl border border-slate-200">
                <table className="min-w-full divide-y divide-slate-200 text-sm">
                  <thead className="bg-slate-50 text-left text-xs uppercase text-slate-500">
                    <tr>
                      <th className="px-4 py-3 font-medium">รหัส / ชื่อสินค้า</th>
                      <th className="px-4 py-3 text-right font-medium">ยอดอนุมัติ</th>
                      <th className="px-4 py-3 text-right font-medium">จ่ายแล้ว</th>
                      <th className="px-4 py-3 text-right font-medium">ยอดรอจ่าย</th>
                      <th className="px-4 py-3 text-right font-medium w-40">จ่ายครั้งนี้</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100 bg-white">
                    {selectedRequisition.items.map((item) => {
                      const remainingIssueQty = Math.max(Number(item.approvedQty || 0) - Number(item.issuedQty || 0), 0);
                      const isFullyIssued = remainingIssueQty === 0;
                      return (
                        <tr key={item.id} className={isFullyIssued ? 'bg-slate-50 opacity-60' : 'hover:bg-slate-50'}>
                          <td className="px-4 py-3">
                            <div className="font-medium text-slate-900">{item.productCode || '-'}</div>
                            <div className="text-slate-500">{item.productName || '-'}</div>
                          </td>
                          <td className="px-4 py-3 text-right text-slate-600">{formatNumber(Number(item.approvedQty || 0))}</td>
                          <td className="px-4 py-3 text-right text-slate-600">{formatNumber(Number(item.issuedQty || 0))}</td>
                          <td className="px-4 py-3 text-right font-medium text-slate-900">{formatNumber(remainingIssueQty)}</td>
                          <td className="px-4 py-3 text-right">
                            <input
                              type="number"
                              min="0"
                              max={remainingIssueQty}
                              disabled={isFullyIssued}
                              value={issueQuantities[item.id] !== undefined ? issueQuantities[item.id] : ''}
                              onChange={(e) => handleQtyChange(item.id, e.target.value)}
                              className="w-24 rounded-lg border border-slate-300 px-2 py-1.5 text-right font-medium focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-500 disabled:bg-slate-100"
                            />
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          ) : null}
        </div>

        <div className="overflow-hidden rounded-3xl border border-slate-200 bg-white shadow-sm">
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-slate-200 text-sm">
              <thead className="bg-slate-100 text-left text-xs uppercase tracking-wider text-slate-500">
                <tr>
                  <th className="px-4 py-3">เลขที่เอกสารจ่าย</th>
                  <th className="px-4 py-3">วันที่จ่าย</th>
                  <th className="px-4 py-3">Requisition ID</th>
                  <th className="px-4 py-3">หน่วยงาน</th>
                  <th className="px-4 py-3">สถานะ</th>
                  <th className="px-4 py-3">ผู้จ่าย</th>
                  <th className="px-4 py-3 text-right">จำนวนที่จ่าย</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100 bg-white">
                {loading ? (
                  <tr>
                    <td colSpan={7} className="px-4 py-10 text-center text-slate-500">กำลังโหลดข้อมูล...</td>
                  </tr>
                ) : items.length === 0 ? (
                  <tr>
                    <td colSpan={7} className="px-4 py-10 text-center text-slate-500">ยังไม่มีเอกสารจ่ายสินค้าในระบบ</td>
                  </tr>
                ) : (
                  items.map((item) => (
                    <tr key={item.id} className="hover:bg-slate-50">
                      <td className="px-4 py-3 font-medium text-slate-900">{item.issueNo}</td>
                      <td className="px-4 py-3 text-slate-600">{item.issueDate ? new Date(item.issueDate).toLocaleString('th-TH') : '-'}</td>
                      <td className="px-4 py-3 text-slate-700">{item.requisitionId}</td>
                      <td className="px-4 py-3 text-slate-700">{item.requestingDepartment}</td>
                      <td className="px-4 py-3"><span className="rounded-full bg-emerald-100 px-3 py-1 text-xs font-medium text-emerald-800">{item.status}</span></td>
                      <td className="px-4 py-3 text-slate-600">{item.issuedBy || '-'}</td>
                      <td className="px-4 py-3 text-right font-semibold text-slate-900">{formatNumber(Number(item.issuedQtyTotal || 0))}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
