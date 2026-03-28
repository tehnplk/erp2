'use client';

import { Fragment, useEffect, useMemo, useRef, useState } from 'react';
import { ChevronDown, ChevronRight, Plus, Trash2 } from 'lucide-react';
import { InventoryBreadcrumbs } from '../_components/inventory-breadcrumbs';
import { formatBaht } from '@/lib/format-baht';

type StockRow = {
  product_id: number;
  product_code: string;
  product_name: string;
  category: string | null;
  product_type: string | null;
  product_subtype: string | null;
  unit: string | null;
  lot_count: number;
  total_qty: number;
  total_value: number;
  avg_unit_price: number;
  last_received_at: string | null;
  last_delivery_note_no: string | null;
};

type StockLotDetailRow = {
  stock_lot_id: number;
  product_id: number;
  product_code: string;
  product_name: string;
  unit: string | null;
  lot_no: string;
  total_received_qty: number;
  total_received_value: number;
  last_delivery_note_no: string | null;
  qty_on_hand: number;
  last_received_at: string | null;
};

type StockResponse = {
  rows: StockRow[];
  summary: {
    total_products: number;
    total_qty: number;
    total_value: number;
  };
  filters?: {
    categories: string[];
    category_type_map: Record<string, string[]>;
  };
};

type ApiResponse<T> = {
  success: boolean;
  data: T;
  totalCount?: number;
  error?: string;
  page?: number;
  page_size?: number;
};

type ReceiptProductOption = {
  id: number;
  code: string;
  name: string;
  unit: string | null;
  cost_price: number | null;
};

type ReceiptFormItem = {
  product_code: string;
  product_name: string;
  product_unit: string;
  lot_no: string;
  received_qty: string;
  total_price: string;
};

function formatDate(value: string | null) {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return '-';
  return date.toLocaleDateString('th-TH');
}

export default function InventoryStockPage() {
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');
  const [search, setSearch] = useState('');
  const [categoryFilter, setCategoryFilter] = useState('');
  const [typeFilter, setTypeFilter] = useState('');
  const [lotFilter, setLotFilter] = useState('');
  const [categoryOptions, setCategoryOptions] = useState<string[]>([]);
  const [categoryTypeMap, setCategoryTypeMap] = useState<Record<string, string[]>>({});
  const [rows, setRows] = useState<StockRow[]>([]);
  const [summary, setSummary] = useState<StockResponse['summary']>({
    total_products: 0,
    total_qty: 0,
    total_value: 0,
  });
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const [totalCount, setTotalCount] = useState(0);
  const [expandedProductIds, setExpandedProductIds] = useState<number[]>([]);
  const [lotRowsByProduct, setLotRowsByProduct] = useState<Record<number, StockLotDetailRow[]>>({});
  const [lotLoadingByProduct, setLotLoadingByProduct] = useState<Record<number, boolean>>({});
  const [receiptModalOpen, setReceiptModalOpen] = useState(false);
  const [receiptType, setReceiptType] = useState<'OPENING_BALANCE' | 'DELIVERY_NOTE'>('OPENING_BALANCE');
  const [receiptDate, setReceiptDate] = useState(() => new Date().toISOString().slice(0, 10));
  const [deliveryNoteNo, setDeliveryNoteNo] = useState('');
  const [receiptNote, setReceiptNote] = useState('');
  const [receiptItems, setReceiptItems] = useState<ReceiptFormItem[]>([]);
  const [receiptSaving, setReceiptSaving] = useState(false);
  const [receiptMessage, setReceiptMessage] = useState('');
  const [receiptSearchText, setReceiptSearchText] = useState('');
  const [receiptProductOptions, setReceiptProductOptions] = useState<ReceiptProductOption[]>([]);
  const [receiptSearching, setReceiptSearching] = useState(false);
  const [receiptActiveOptionIndex, setReceiptActiveOptionIndex] = useState(-1);
  const receiptOptionRefs = useRef<Array<HTMLButtonElement | null>>([]);

  const totalPages = useMemo(() => Math.max(1, Math.ceil(totalCount / pageSize)), [totalCount, pageSize]);

  const availableTypeOptions = useMemo(() => {
    if (!categoryFilter.trim()) return [];
    return (categoryTypeMap[categoryFilter.trim()] || []).slice().sort((a, b) => a.localeCompare(b));
  }, [categoryFilter, categoryTypeMap]);

  const receiptTotalQty = useMemo(
    () => receiptItems.reduce((sum, item) => sum + Number(item.received_qty || 0), 0),
    [receiptItems]
  );

  const receiptTotalPrice = useMemo(
    () => receiptItems.reduce((sum, item) => sum + Number(item.total_price || 0), 0),
    [receiptItems]
  );

  const fetchLotRows = async (productId: number) => {
    setLotLoadingByProduct((prev) => ({ ...prev, [productId]: true }));
    try {
      const params = new URLSearchParams({
        product_id: String(productId),
        page_size: '100',
        sort_order: 'asc',
      });
      const response = await fetch(`/api/inventory/stock/lots?${params.toString()}`);
      const payload: ApiResponse<StockLotDetailRow[]> = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'โหลดรายละเอียดล็อตไม่สำเร็จ');
      }

      setLotRowsByProduct((prev) => ({
        ...prev,
        [productId]: payload.data || [],
      }));
    } catch (error) {
      console.error(error);
      setLotRowsByProduct((prev) => ({ ...prev, [productId]: [] }));
      setMessage(error instanceof Error ? error.message : 'โหลดรายละเอียดล็อตไม่สำเร็จ');
    } finally {
      setLotLoadingByProduct((prev) => ({ ...prev, [productId]: false }));
    }
  };

  const fetchStockData = async () => {
    setLoading(true);
    setMessage('');

    try {
      const params = new URLSearchParams({
        page: String(page),
        page_size: String(pageSize),
        order_by: 'product_code',
        sort_order: 'asc',
      });

      if (search.trim()) {
        params.set('search', search.trim());
      }
      if (categoryFilter.trim()) {
        params.set('category', categoryFilter.trim());
      }
      if (typeFilter.trim()) {
        params.set('product_type', typeFilter.trim());
      }
      if (lotFilter.trim()) {
        params.set('lot', lotFilter.trim());
      }

      const response = await fetch(`/api/inventory/stock?${params.toString()}`);
      const payload: ApiResponse<StockResponse> = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'โหลดรายการสินค้าคงคลังไม่สำเร็จ');
      }

      setRows(payload.data.rows || []);
      setSummary(
        payload.data.summary || {
          total_products: 0,
          total_qty: 0,
          total_value: 0,
        }
      );
      setCategoryOptions(payload.data.filters?.categories || []);
      setCategoryTypeMap(payload.data.filters?.category_type_map || {});
      setTotalCount(payload.totalCount || 0);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const timeout = window.setTimeout(async () => {
      try {
        await fetchStockData();
      } catch (error) {
        console.error(error);
        setRows([]);
        setSummary({
          total_products: 0,
          total_qty: 0,
          total_value: 0,
        });
        setCategoryOptions([]);
        setCategoryTypeMap({});
        setTotalCount(0);
        setMessage(error instanceof Error ? error.message : 'เกิดข้อผิดพลาด');
      } finally {
        setLoading(false);
      }
    }, 200);

    return () => window.clearTimeout(timeout);
  }, [page, pageSize, search, categoryFilter, typeFilter, lotFilter]);

  useEffect(() => {
    setExpandedProductIds([]);
    setLotRowsByProduct({});
    setLotLoadingByProduct({});
  }, [page, pageSize, search, categoryFilter, typeFilter, lotFilter]);

  useEffect(() => {
    if (!categoryFilter.trim()) return;
    if (availableTypeOptions.length === 0) return;
    if (typeFilter && !availableTypeOptions.includes(typeFilter)) {
      setTypeFilter('');
    }
  }, [availableTypeOptions, categoryFilter, typeFilter]);

  useEffect(() => {
    const q = receiptSearchText.trim();
    if (q.length < 2) {
      setReceiptProductOptions([]);
      setReceiptActiveOptionIndex(-1);
      return;
    }

    const timeout = window.setTimeout(async () => {
      try {
        setReceiptSearching(true);
        const response = await fetch(`/api/inventory/receipts/product-search?q=${encodeURIComponent(q)}&limit=20`);
        const payload: ApiResponse<ReceiptProductOption[]> = await response.json();
        if (!response.ok || !payload.success) {
          throw new Error(payload.error || 'ค้นหาสินค้าไม่สำเร็จ');
        }
        setReceiptProductOptions(payload.data || []);
      } catch (error) {
        console.error(error);
        setReceiptProductOptions([]);
      } finally {
        setReceiptSearching(false);
      }
    }, 250);

    return () => window.clearTimeout(timeout);
  }, [receiptSearchText]);

  useEffect(() => {
    if (receiptProductOptions.length === 0) {
      setReceiptActiveOptionIndex(-1);
      return;
    }

    if (receiptActiveOptionIndex >= receiptProductOptions.length) {
      setReceiptActiveOptionIndex(0);
      return;
    }

    if (receiptActiveOptionIndex >= 0) {
      receiptOptionRefs.current[receiptActiveOptionIndex]?.scrollIntoView({ block: 'nearest' });
    }
  }, [receiptActiveOptionIndex, receiptProductOptions]);

  const openReceiptModal = () => {
    setReceiptMessage('');
    setReceiptType('OPENING_BALANCE');
    setReceiptDate(new Date().toISOString().slice(0, 10));
    setDeliveryNoteNo('');
    setReceiptNote('');
    setReceiptItems([]);
    setReceiptSearchText('');
    setReceiptProductOptions([]);
    setReceiptActiveOptionIndex(-1);
    setReceiptModalOpen(true);
  };

  const selectReceiptProduct = (product: ReceiptProductOption) => {
    setReceiptItems((prev) => {
      if (prev.some((item) => item.product_code === product.code)) return prev;
      return [
        ...prev,
        {
          product_code: product.code,
          product_name: product.name,
          product_unit: product.unit || '-',
          lot_no: '',
          received_qty: '',
          total_price: '',
        },
      ];
    });
    setReceiptSearchText('');
    setReceiptProductOptions([]);
    setReceiptActiveOptionIndex(-1);
  };

  const updateReceiptItemField = (index: number, field: keyof ReceiptFormItem, value: string) => {
    setReceiptItems((prev) => prev.map((item, i) => (i === index ? { ...item, [field]: value } : item)));
  };

  const removeReceiptItem = (index: number) => {
    setReceiptItems((prev) => prev.filter((_, i) => i !== index));
  };

  const toggleExpandedRow = async (productId: number) => {
    if (expandedProductIds.includes(productId)) {
      setExpandedProductIds((prev) => prev.filter((id) => id !== productId));
      return;
    }

    setExpandedProductIds((prev) => [...prev, productId]);

    if (!lotRowsByProduct[productId] && !lotLoadingByProduct[productId]) {
      await fetchLotRows(productId);
    }
  };

  const handleReceiptSubmit = async () => {
    if (receiptItems.length === 0) {
      setReceiptMessage('กรุณาเพิ่มรายการสินค้าอย่างน้อย 1 รายการ');
      return;
    }
    if (receiptType === 'DELIVERY_NOTE' && !deliveryNoteNo.trim()) {
      setReceiptMessage('กรุณากรอกเลขที่ใบส่งของ');
      return;
    }
    if (receiptType === 'OPENING_BALANCE' && !receiptNote.trim()) {
      setReceiptMessage('กรุณากรอกหมายเหตุสำหรับยอดยกมา');
      return;
    }
    if (receiptItems.some((item) => !item.lot_no.trim())) {
      setReceiptMessage('กรุณากรอกล็อตให้ครบทุก รายการ');
      return;
    }
    if (receiptItems.some((item) => Number(item.received_qty) <= 0)) {
      setReceiptMessage('จำนวนรับเข้าต้องมากกว่า 0 ทุกรายการ');
      return;
    }
    if (receiptItems.some((item) => Number(item.total_price) < 0)) {
      setReceiptMessage('ราคารวมต้องไม่ติดลบ');
      return;
    }

    try {
      setReceiptSaving(true);
      setReceiptMessage('');
      const response = await fetch('/api/inventory/receipts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          receipt_type: receiptType,
          receipt_date: receiptDate,
          delivery_note_no: receiptType === 'DELIVERY_NOTE' ? deliveryNoteNo.trim() : undefined,
          note: receiptNote.trim() || undefined,
          items: receiptItems.map((item) => ({
            product_code: item.product_code,
            lot_no: item.lot_no.trim(),
            received_qty: Number(item.received_qty),
            total_price: Number(item.total_price),
          })),
        }),
      });

      const payload = await response.json();
      if (!response.ok || !payload.success) {
        throw new Error(payload.error || 'บันทึกรับเข้าคลังไม่สำเร็จ');
      }

      setReceiptModalOpen(false);
      setMessage(`บันทึกรับเข้าคลังสำเร็จ เลขที่เอกสาร ${payload.data.receipt_no}`);
      await fetchStockData();
    } catch (error) {
      console.error(error);
      setReceiptMessage(error instanceof Error ? error.message : 'บันทึกรับเข้าคลังไม่สำเร็จ');
    } finally {
      setReceiptSaving(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="space-y-6">
        <InventoryBreadcrumbs />

        <section className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
          <div className="mb-4 flex items-center justify-between gap-3">
            <h1 className="text-xl font-bold text-slate-900">สินค้าคงคลัง</h1>
            <button
              type="button"
              onClick={openReceiptModal}
              className="inline-flex items-center gap-2 rounded-lg bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700"
            >
              <Plus className="h-4 w-4" />
              รับเข้าคลัง
            </button>
          </div>
          <div className="mb-4 flex flex-wrap gap-3">
            <select
              value={categoryFilter}
              onChange={(event) => {
                setCategoryFilter(event.target.value);
                setPage(1);
              }}
              className="flex-1 min-w-[140px] rounded-lg border border-slate-300 px-3 py-2 text-sm"
            >
              <option value="">ทุกหมวด</option>
              {categoryOptions.map((category) => (
                <option key={category} value={category}>
                  {category}
                </option>
              ))}
            </select>

            <select
              value={typeFilter}
              onChange={(event) => {
                setTypeFilter(event.target.value);
                setPage(1);
              }}
              disabled={!categoryFilter.trim()}
              className="flex-1 min-w-[140px] rounded-lg border border-slate-300 px-3 py-2 text-sm disabled:cursor-not-allowed disabled:bg-slate-100"
            >
              <option value="">ทุกประเภท</option>
              {availableTypeOptions.map((type) => (
                <option key={type} value={type}>
                  {type}
                </option>
              ))}
            </select>

            <input
              type="text"
              value={lotFilter}
              onChange={(event) => {
                setLotFilter(event.target.value);
                setPage(1);
              }}
              placeholder="กรองเลข lot"
              className="flex-1 min-w-[180px] rounded-lg border border-slate-300 px-3 py-2 text-sm"
            />

            <input
              type="text"
              value={search}
              onChange={(event) => {
                setSearch(event.target.value);
                setPage(1);
              }}
              placeholder="ค้นหารหัส/ชื่อสินค้า"
              className="flex-1 min-w-[180px] rounded-lg border border-slate-300 px-3 py-2 text-sm"
            />
          </div>

          <div className="mb-3 flex flex-col gap-2 rounded-lg border border-gray-100 bg-gray-50 px-3 py-2 text-sm text-gray-600 md:flex-row md:items-center md:justify-between">
            <div className="font-medium text-gray-700">
              หน้า {page} / {totalPages}
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <div className="rounded border border-gray-200 bg-white px-2 py-1 text-xs text-gray-600">
                รวม {totalCount.toLocaleString('th-TH')} รายการ
              </div>
              <div className="rounded border border-gray-200 bg-white px-2 py-1 text-xs text-gray-600">
                มูลค่ารวม {formatBaht(summary.total_value)}
              </div>
              <select
                aria-label="เลือกจำนวนรายการต่อหน้า"
                value={String(pageSize)}
                onChange={(event) => {
                  const nextSize = Number(event.target.value);
                  if (![20, 50, 100].includes(nextSize)) return;
                  setPageSize(nextSize);
                  setPage(1);
                }}
                className="rounded border border-gray-300 px-2 py-1 text-sm"
              >
                <option value="20">20</option>
                <option value="50">50</option>
                <option value="100">100</option>
              </select>
              <button
                type="button"
                disabled={page <= 1 || loading}
                onClick={() => setPage((prev) => Math.max(1, prev - 1))}
                className="rounded border border-gray-300 px-2 py-1 disabled:opacity-50"
              >
                ก่อนหน้า
              </button>
              <button
                type="button"
                disabled={page >= totalPages || loading}
                onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))}
                className="rounded border border-gray-300 px-2 py-1 disabled:opacity-50"
              >
                ถัดไป
              </button>
            </div>
          </div>

          {message ? <div className="mb-4 rounded-lg border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700">{message}</div> : null}

          <div className="overflow-x-auto rounded-xl border border-slate-200">
            <table className="w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="whitespace-nowrap px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">#</th>
                  <th className="whitespace-nowrap px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">รหัสสินค้า</th>
                  <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">สินค้า</th>
                  <th className="px-3 py-2 text-left text-xs font-semibold uppercase text-gray-500">หน่วย</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">คงคลัง</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">มูลค่า/หน่วย (บาท)</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">รวมมูลค่า (บาท)</th>
                  <th className="px-3 py-2 text-right text-xs font-semibold uppercase text-gray-500">จัดการ</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100 bg-white">
                {loading ? (
                  <tr>
                    <td colSpan={8} className="px-3 py-6 text-center text-sm text-gray-500">กำลังโหลดข้อมูล...</td>
                  </tr>
                ) : rows.length === 0 ? (
                  <tr>
                    <td colSpan={8} className="px-3 py-6 text-center text-sm text-gray-500">ไม่พบรายการสินค้าคงคลัง</td>
                  </tr>
                ) : (
                  rows.map((row, index) => {
                    const isExpanded = expandedProductIds.includes(row.product_id);
                    const lotRows = lotRowsByProduct[row.product_id] || [];
                    const lotLoading = !!lotLoadingByProduct[row.product_id];

                    return (
                      <Fragment key={row.product_id}>
                        <tr
                          className={
                            isExpanded
                              ? 'bg-emerald-100/80 hover:bg-emerald-100'
                              : Number(row.total_qty) <= 0
                                ? 'bg-rose-50/40 hover:bg-rose-50'
                                : 'hover:bg-gray-50'
                          }
                        >
                          <td className="whitespace-nowrap px-3 py-2 text-xs text-gray-700 align-top">{(page - 1) * pageSize + index + 1}</td>
                          <td className="whitespace-nowrap px-3 py-2 text-xs text-gray-700 align-top">{row.product_code || '-'}</td>
                          <td className="w-[320px] pr-2 py-2 text-xs text-gray-700">
                            <div className="font-medium text-gray-800 text-xs break-words">{row.product_name || '-'}</div>
                            <div className="mt-0.5 text-[10px] text-yellow-600">
                              {[row.category, row.product_type, row.product_subtype].filter(Boolean).join(' - ') || '-'}
                            </div>
                          </td>
                          <td className="px-3 py-2 text-xs text-gray-700 align-top">{row.unit || '-'}</td>
                          <td
                            className={`px-3 py-2 text-right text-xs align-top ${
                              Number(row.total_qty) <= 0 ? 'font-semibold text-rose-700' : 'text-gray-700'
                            }`}
                          >
                            {Number(row.total_qty).toLocaleString('th-TH')}
                          </td>
                          <td className="px-3 py-2 text-right text-xs text-gray-700 align-top">
                            {Number(row.avg_unit_price).toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                          </td>
                          <td className="px-3 py-2 text-right text-xs text-gray-700 align-top">
                            {Number(row.total_value).toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                          </td>
                          <td className="px-3 py-2 text-right align-top">
                            <button
                              type="button"
                              onClick={() => void toggleExpandedRow(row.product_id)}
                              aria-label={isExpanded ? `ยุบรายละเอียด ${row.product_code}` : `ขยายรายละเอียด ${row.product_code}`}
                              title={isExpanded ? 'ยุบรายละเอียด' : 'ขยายรายละเอียด'}
                              className="inline-flex h-8 w-8 items-center justify-center rounded-md border border-gray-300 text-gray-700 hover:bg-gray-100"
                            >
                              {isExpanded ? <ChevronDown className="h-4 w-4" /> : <ChevronRight className="h-4 w-4" />}
                            </button>
                          </td>
                        </tr>
                        {isExpanded ? (
                          <tr className="bg-emerald-50/70">
                            <td colSpan={8} className="px-4 py-3">
                              <div className="rounded-lg border border-emerald-200 bg-emerald-50">
                                <div className="border-b border-emerald-200 px-3 py-2 text-xs font-medium text-emerald-800">
                                  รายละเอียดล็อตของ {row.product_code}
                                </div>
                                <table className="min-w-full text-xs">
                                  <thead className="bg-emerald-100 text-left text-emerald-700">
                                    <tr>
                                      <th className="px-3 py-2">LOT-NO</th>
                                      <th className="px-3 py-2">วันที่รับเข้าคลัง</th>
                                      <th className="px-3 py-2">เลขที่ใบส่งของ</th>
                                      <th className="px-3 py-2 text-right">จำนวนที่รับ</th>
                                      <th className="px-3 py-2 text-right">มูลค่ารวมตอนรับเข้า (บาท)</th>
                                      <th className="px-3 py-2 text-right">คงเหลือในคลัง</th>
                                    </tr>
                                  </thead>
                                  <tbody className="divide-y divide-emerald-100 bg-white/70">
                                    {lotLoading ? (
                                      <tr>
                                        <td colSpan={6} className="px-3 py-4 text-center text-emerald-600">กำลังโหลดรายละเอียดล็อต...</td>
                                      </tr>
                                    ) : lotRows.length === 0 ? (
                                      <tr>
                                        <td colSpan={6} className="px-3 py-4 text-center text-emerald-600">ไม่พบรายละเอียดล็อต</td>
                                      </tr>
                                    ) : (
                                      lotRows.map((lotRow) => (
                                        <tr key={lotRow.stock_lot_id} className="hover:bg-emerald-100/60">
                                          <td className="px-3 py-2 text-emerald-900">{lotRow.lot_no || '-'}</td>
                                          <td className="px-3 py-2 text-emerald-900">{formatDate(lotRow.last_received_at)}</td>
                                          <td className="px-3 py-2 text-emerald-900">{lotRow.last_delivery_note_no || '-'}</td>
                                          <td className="px-3 py-2 text-right text-emerald-900">{Number(lotRow.total_received_qty).toLocaleString('th-TH')}</td>
                                          <td className="px-3 py-2 text-right text-emerald-900">
                                            {Number(lotRow.total_received_value).toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                                          </td>
                                          <td className="px-3 py-2 text-right text-emerald-900">{Number(lotRow.qty_on_hand).toLocaleString('th-TH')}</td>
                                        </tr>
                                      ))
                                    )}
                                  </tbody>
                                </table>
                              </div>
                            </td>
                          </tr>
                        ) : null}
                      </Fragment>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </section>

        {receiptModalOpen ? (
          <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 p-4">
            <div className="max-h-[90vh] w-full max-w-5xl overflow-y-auto rounded-2xl border border-slate-200 bg-white p-5 shadow-xl">
              <div className="mb-4 flex items-center justify-between gap-3">
                <h2 className="text-xl font-semibold text-slate-900">รับเข้าคลัง</h2>
                <button
                  type="button"
                  onClick={() => setReceiptModalOpen(false)}
                  className="rounded-md border border-slate-300 px-3 py-1 text-sm text-slate-700 hover:bg-slate-100"
                >
                  ปิด
                </button>
              </div>

              {receiptMessage ? (
                <div className="mb-4 rounded-lg border border-blue-200 bg-blue-50 px-3 py-2 text-sm text-blue-800">{receiptMessage}</div>
              ) : null}

              <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-4">
                <label className="text-sm text-slate-700">
                  ประเภทรับเข้า
                  <select
                    value={receiptType}
                    onChange={(event) => setReceiptType(event.target.value as 'OPENING_BALANCE' | 'DELIVERY_NOTE')}
                    className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2"
                  >
                    <option value="OPENING_BALANCE">รับจากยอดยกมา</option>
                    <option value="DELIVERY_NOTE">รับจากใบส่งของ</option>
                  </select>
                </label>

                <label className="text-sm text-slate-700">
                  วันที่รับเข้า
                  <input
                    type="date"
                    value={receiptDate}
                    onChange={(event) => setReceiptDate(event.target.value)}
                    className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2"
                  />
                </label>

                <label className="text-sm text-slate-700">
                  เลขที่ใบส่งของ
                  <input
                    type="text"
                    value={deliveryNoteNo}
                    onChange={(event) => setDeliveryNoteNo(event.target.value)}
                    disabled={receiptType !== 'DELIVERY_NOTE'}
                    placeholder={receiptType === 'DELIVERY_NOTE' ? 'กรอกเลขที่ใบส่งของ' : 'ใช้เฉพาะประเภทใบส่งของ'}
                    className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2 disabled:bg-slate-100"
                  />
                </label>

                <label className="text-sm text-slate-700">
                  หมายเหตุ
                  <input
                    type="text"
                    value={receiptNote}
                    onChange={(event) => setReceiptNote(event.target.value)}
                    placeholder={receiptType === 'OPENING_BALANCE' ? 'บังคับกรอกสำหรับยอดยกมา' : '(ไม่บังคับ)'}
                    className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2"
                  />
                </label>
              </div>

              <div className="relative mt-5">
                <label className="text-sm text-slate-700">ค้นหาสินค้า (ชื่อ/รหัส)</label>
                <input
                  type="text"
                  value={receiptSearchText}
                  onChange={(event) => setReceiptSearchText(event.target.value)}
                  onBlur={() => {
                    window.setTimeout(() => {
                      setReceiptProductOptions([]);
                      setReceiptActiveOptionIndex(-1);
                    }, 120);
                  }}
                  onKeyDown={(event) => {
                    if (receiptProductOptions.length === 0) return;
                    if (event.key === 'ArrowDown') {
                      event.preventDefault();
                      setReceiptActiveOptionIndex((prev) => (prev + 1) % receiptProductOptions.length);
                      return;
                    }
                    if (event.key === 'ArrowUp') {
                      event.preventDefault();
                      setReceiptActiveOptionIndex((prev) => (prev <= 0 ? receiptProductOptions.length - 1 : prev - 1));
                      return;
                    }
                    if (event.key === 'Enter') {
                      event.preventDefault();
                      const selected = receiptActiveOptionIndex >= 0 ? receiptProductOptions[receiptActiveOptionIndex] : receiptProductOptions[0];
                      if (selected) selectReceiptProduct(selected);
                    }
                    if (event.key === 'Escape') {
                      setReceiptProductOptions([]);
                      setReceiptActiveOptionIndex(-1);
                    }
                  }}
                  placeholder="พิมพ์อย่างน้อย 2 ตัวอักษร"
                  className="mt-1 w-full rounded-lg border border-slate-300 px-3 py-2"
                />
                {receiptSearching ? <p className="mt-1 text-xs text-slate-500">กำลังค้นหา...</p> : null}
                {receiptProductOptions.length > 0 ? (
                  <div className="absolute z-10 mt-1 max-h-56 w-full overflow-y-auto rounded-lg border border-slate-200 bg-white shadow-sm">
                    {receiptProductOptions.map((option, index) => (
                      <button
                        key={option.id}
                        ref={(el) => {
                          receiptOptionRefs.current[index] = el;
                        }}
                        type="button"
                        onClick={() => selectReceiptProduct(option)}
                        className={`block w-full border-b border-slate-100 px-3 py-2 text-left text-sm hover:bg-slate-50 ${
                          index === receiptActiveOptionIndex ? 'bg-blue-50' : ''
                        }`}
                      >
                        <span className="font-medium text-slate-900">{option.code}</span>
                        <span className="text-slate-600"> - {option.name}</span>
                      </button>
                    ))}
                  </div>
                ) : null}
              </div>

              <div className="mt-5 overflow-x-auto rounded-xl border border-slate-200">
                <table className="min-w-full text-xs">
                  <thead className="bg-gray-50 text-left text-gray-500">
                    <tr>
                      <th className="px-3 py-2">รหัสสินค้า</th>
                      <th className="px-3 py-2">ชื่อสินค้า</th>
                      <th className="px-3 py-2">ล็อต</th>
                      <th className="px-3 py-2 text-right">จำนวน</th>
                      <th className="px-3 py-2 text-right">ราคารวม (บาท)</th>
                      <th className="px-3 py-2 text-right">จัดการ</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100 bg-white">
                    {receiptItems.length === 0 ? (
                      <tr>
                        <td className="px-3 py-6 text-center text-gray-500" colSpan={6}>
                          ยังไม่มีรายการสินค้า
                        </td>
                      </tr>
                    ) : (
                      receiptItems.map((item, index) => (
                        <tr key={`${item.product_code}-${index}`} className="hover:bg-gray-50">
                          <td className="px-3 py-2 font-medium text-gray-900 align-top">{item.product_code}</td>
                          <td className="px-3 py-2 text-gray-700 align-top">{item.product_name}</td>
                          <td className="px-3 py-2 align-top">
                            <input
                              type="text"
                              value={item.lot_no}
                              onChange={(event) => updateReceiptItemField(index, 'lot_no', event.target.value)}
                              className="w-full rounded-lg border border-slate-300 px-2 py-1"
                              placeholder="ล็อต"
                            />
                          </td>
                          <td className="px-3 py-2 align-top">
                            <div className="flex items-center gap-2">
                              <input
                                type="number"
                                min="0"
                                step="0.01"
                                value={item.received_qty}
                                onChange={(event) => updateReceiptItemField(index, 'received_qty', event.target.value)}
                                className="w-full rounded-lg border border-slate-300 px-2 py-1 text-right"
                                placeholder="0"
                              />
                              <span className="whitespace-nowrap text-xs text-slate-600">{item.product_unit}</span>
                            </div>
                          </td>
                          <td className="px-3 py-2 align-top">
                            <input
                              type="number"
                              min="0"
                              step="0.01"
                              value={item.total_price}
                              onChange={(event) => updateReceiptItemField(index, 'total_price', event.target.value)}
                              className="w-full rounded-lg border border-slate-300 px-2 py-1 text-right"
                              placeholder="0.00"
                            />
                          </td>
                          <td className="px-3 py-2 text-right align-top">
                            <button
                              type="button"
                              onClick={() => removeReceiptItem(index)}
                              aria-label="ลบรายการ"
                              title="ลบรายการ"
                              className="inline-flex h-8 w-8 items-center justify-center rounded-md border border-red-300 text-red-700 hover:bg-red-50"
                            >
                              <Trash2 className="h-4 w-4" />
                            </button>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>

              <div className="mt-4 flex flex-col gap-3 md:flex-row md:items-center md:justify-between">
                <p className="text-sm text-slate-700">
                  รวมจำนวน {receiptTotalQty.toLocaleString('th-TH')} | รวมราคา {formatBaht(receiptTotalPrice)}
                </p>
                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => {
                      setReceiptItems([]);
                      setReceiptSearchText('');
                      setReceiptProductOptions([]);
                      setReceiptActiveOptionIndex(-1);
                      setReceiptMessage('');
                    }}
                    className="rounded-lg border border-slate-300 px-4 py-2 text-sm text-slate-700 hover:bg-slate-100"
                  >
                    ล้างฟอร์ม
                  </button>
                  <button
                    type="button"
                    onClick={handleReceiptSubmit}
                    disabled={receiptSaving}
                    className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-700 disabled:cursor-not-allowed disabled:bg-slate-300"
                  >
                    {receiptSaving ? 'กำลังบันทึก...' : 'บันทึกรับเข้าคลัง'}
                  </button>
                </div>
              </div>
            </div>
          </div>
        ) : null}
      </div>
    </div>
  );
}



