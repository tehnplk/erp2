'use client';

import { saveAs } from 'file-saver';
import { AlignmentType, BorderStyle, Document, ImageRun, Packer, PageOrientation, Paragraph, Table, TableCell, TableRow, TextRun, WidthType } from 'docx';
import React, { useEffect, useMemo, useRef, useState } from 'react';
import { usePathname, useRouter, useSearchParams } from 'next/navigation';
import Swal from 'sweetalert2';
import { ChevronDown, ChevronRight, Save, X, Trash2, Edit, FileText } from 'lucide-react';

const DEFAULT_DOC_NO = 'พล. 0733.301/พิเศษ';
const DOCX_FONT_FAMILY = 'TH Sarabun';

const THAI_TO_ARABIC_DIGITS: Record<string, string> = {
  '๐': '0',
  '๑': '1',
  '๒': '2',
  '๓': '3',
  '๔': '4',
  '๕': '5',
  '๖': '6',
  '๗': '7',
  '๘': '8',
  '๙': '9',
};

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
  const [editingRowId, setEditingRowId] = useState<number | null>(null);
  const [editingData, setEditingData] = useState<Record<string, string>>({});
  const [savingRowId, setSavingRowId] = useState<number | null>(null);
  const [documentPreview, setDocumentPreview] = useState<PurchaseApprovalGroup | null>(null);

  // filters
  const [nameFilter, setNameFilter] = useState(searchParams.get('product_name') || '');
  const [categoryFilter, setCategoryFilter] = useState(searchParams.get('category') || '');
  const [typeFilter, setTypeFilter] = useState(searchParams.get('product_type') || '');
  const [subtypeFilter, setSubtypeFilter] = useState(searchParams.get('product_subtype') || '');
  const [departmentFilter, setDepartmentFilter] = useState(searchParams.get('department') || '');
  const [budgetYearFilter, setBudgetYearFilter] = useState(searchParams.get('budget_year') || '');

  // sort
  const [sortBy] = useState('created_at');
  const [sortOrder] = useState<'asc' | 'desc'>('desc');
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

  useEffect(() => { fetchData(); }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, budgetYearFilter, page, pageSize]);

  // When filters or sorting change, reset to first page and refresh summary data
  useEffect(() => {
    if (!hasSyncedSearchParamsRef.current) {
      return;
    }
    setPage(1);
    fetchSummaryData();
  }, [nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, budgetYearFilter]);

  useEffect(() => { fetchFilters(); fetchSummaryData(); }, []);

  useEffect(() => {
    const nextName = searchParams.get('product_name') || '';
    const nextCategory = searchParams.get('category') || '';
    const nextType = searchParams.get('product_type') || '';
    const nextSubtype = searchParams.get('product_subtype') || '';
    const nextDepartment = searchParams.get('department') || '';
    const nextBudgetYear = searchParams.get('budget_year') || '';
    const nextPage = Math.max(1, parseInt(searchParams.get('page') || '1', 10) || 1);
    const nextPageSize = Math.max(1, parseInt(searchParams.get('page_size') || '20', 10) || 20);

    setNameFilter((prev) => (prev === nextName ? prev : nextName));
    setCategoryFilter((prev) => (prev === nextCategory ? prev : nextCategory));
    setTypeFilter((prev) => (prev === nextType ? prev : nextType));
    setSubtypeFilter((prev) => (prev === nextSubtype ? prev : nextSubtype));
    setDepartmentFilter((prev) => (prev === nextDepartment ? prev : nextDepartment));
    setBudgetYearFilter((prev) => (prev === nextBudgetYear ? prev : nextBudgetYear));
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
    if (page > 1) params.set('page', page.toString());
    if (pageSize !== 20) params.set('page_size', pageSize.toString());

    const nextUrl = params.toString() ? `${pathname}?${params.toString()}` : pathname;
    const currentUrl = searchParams.toString() ? `${pathname}?${searchParams.toString()}` : pathname;

    if (nextUrl !== currentUrl) {
      router.replace(nextUrl, { scroll: false });
    }
  }, [pathname, router, searchParams, nameFilter, categoryFilter, typeFilter, subtypeFilter, departmentFilter, budgetYearFilter, page, pageSize]);

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
      params.append('order_by', 'created_at');
      params.append('sort_order', 'desc');
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

  const handleSort = () => {};

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
    // Convert UTC to Thailand time by adding 7 hours
    const thailandTime = new Date(date.getTime() + (7 * 60 * 60 * 1000));
    return thailandTime.toLocaleString('th-TH', {
      timeZone: 'Asia/Bangkok',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hour12: false
    });
  };

  const formatDate = (value?: string) => {
    if (!value) return '-';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return value;
    // Convert UTC to Thailand time by adding 7 hours
    const thailandTime = new Date(date.getTime() + (7 * 60 * 60 * 1000));
    return new Intl.DateTimeFormat('th-TH-u-ca-buddhist-nu-latn', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      timeZone: 'Asia/Bangkok',
    }).format(thailandTime);
  };

  const formatMoney = (value?: number | string) => {
    const parsed = Number(value || 0);
    return new Intl.NumberFormat('th-TH', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(Number.isFinite(parsed) ? parsed : 0);
  };

  const formatThaiBuddhistLongDate = (value?: string) => {
    if (!value) return '-';
    const date = new Date(value);
    if (Number.isNaN(date.getTime())) return value;
    // Convert UTC to Thailand time by adding 7 hours
    const thailandTime = new Date(date.getTime() + (7 * 60 * 60 * 1000));
    return new Intl.DateTimeFormat('th-TH-u-ca-buddhist-nu-latn', {
      day: 'numeric',
      month: 'long',
      year: 'numeric',
      timeZone: 'Asia/Bangkok',
    }).format(thailandTime);
  };

  const normalizeThaiDigitsToArabic = (value?: string) => {
    if (!value) return '';
    return value.replace(/[๐-๙]/g, (digit) => THAI_TO_ARABIC_DIGITS[digit] || digit);
  };

  const convertNumberToThaiText = (value?: number | string) => {
    const amount = Number(value || 0);
    if (!Number.isFinite(amount)) {
      return '';
    }

    const numberText = ['ศูนย์', 'หนึ่ง', 'สอง', 'สาม', 'สี่', 'ห้า', 'หก', 'เจ็ด', 'แปด', 'เก้า'];
    const positionText = ['', 'สิบ', 'ร้อย', 'พัน', 'หมื่น', 'แสน', 'ล้าน'];

    const convertInteger = (num: number): string => {
      if (num === 0) return '';

      if (num >= 1000000) {
        const millionPart = Math.floor(num / 1000000);
        const remainder = num % 1000000;
        return `${convertInteger(millionPart)}ล้าน${convertInteger(remainder)}`;
      }

      const digits = String(num).split('').map(Number);
      let text = '';

      digits.forEach((digit, index) => {
        if (digit === 0) return;
        const position = digits.length - index - 1;

        if (position === 1) {
          if (digit === 1) {
            text += 'สิบ';
            return;
          }
          if (digit === 2) {
            text += 'ยี่สิบ';
            return;
          }
          text += `${numberText[digit]}สิบ`;
          return;
        }

        if (position === 0 && digit === 1 && digits.length > 1) {
          text += 'เอ็ด';
          return;
        }

        text += `${numberText[digit]}${positionText[position]}`;
      });

      return text;
    };

    const integerPart = Math.floor(amount);
    const satangPart = Math.round((amount - integerPart) * 100);

    const bahtText = integerPart === 0 ? 'ศูนย์บาท' : `${convertInteger(integerPart)}บาท`;

    if (satangPart === 0) {
      return `${bahtText}ถ้วน`;
    }

    return `${bahtText}${convertInteger(satangPart)}สตางค์`;
  };

  const handlePrintDocument = () => {
    window.print();
  };

  const handleDownloadDocx = async () => {
    if (!documentPreview) {
      return;
    }

    try {
      const createDocxTextRun = ({
        text,
        size,
        bold,
      }: {
        text: string;
        size: number;
        bold?: boolean;
      }) =>
        new TextRun({
          text,
          size,
          bold,
          font: {
            ascii: DOCX_FONT_FAMILY,
            hAnsi: DOCX_FONT_FAMILY,
            eastAsia: DOCX_FONT_FAMILY,
            cs: DOCX_FONT_FAMILY,
          },
        });

      const birdResponse = await fetch('/images/bird.jpg');
      const birdArrayBuffer = await birdResponse.arrayBuffer();
      const birdImage = new Uint8Array(birdArrayBuffer);
      const thinBorder = {
        style: BorderStyle.SINGLE,
        size: 1,
        color: '808080',
      };
      const noBorder = {
        style: BorderStyle.NONE,
        size: 0,
        color: 'FFFFFF',
      };

      const tableRows = [
        new TableRow({
          children: [
            'ลำดับ',
            'ชื่อรายการ',
            'จำนวน (หน่วย)',
            'ขนาดบรรจุ (หน่วยนับ)',
            'ราคา/หน่วย (บาท)',
            'จำนวนเงิน (บาท)',
            'หมายเหตุ เงื่อนไขแผน',
            'ลำดับแผน',
          ].map((text) =>
            new TableCell({
              borders: { top: thinBorder, bottom: thinBorder, left: thinBorder, right: thinBorder },
              children: [
                new Paragraph({
                  alignment: AlignmentType.CENTER,
                  children: [createDocxTextRun({ text, size: 30 })],
                }),
              ],
            })
          ),
        }),
        ...(documentPreview.sub_items || []).map(
          (item, index) =>
            new TableRow({
              children: [
                String(index + 1),
                `${item.product_code ? `${item.product_code} : ` : ''}${item.product_name || '-'}`,
                Number(item.requested_quantity || 0).toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 }),
                item.unit || '-',
                formatMoney(item.price_per_unit),
                formatMoney(item.total_value),
                'จำนวน วงเงิน ราคา',
                String(item.line_number || '-'),
              ].map((text, cellIndex) =>
                new TableCell({
                  borders: { top: thinBorder, bottom: thinBorder, left: thinBorder, right: thinBorder },
                  children: [
                    new Paragraph({
                      alignment:
                        cellIndex === 0 || cellIndex === 2 || cellIndex === 3 || cellIndex === 4 || cellIndex === 5 || cellIndex === 7
                          ? AlignmentType.CENTER
                          : AlignmentType.LEFT,
                      children: [createDocxTextRun({ text, size: 30 })],
                    }),
                  ],
                })
              ),
            })
        ),
        new TableRow({
          children: [
            '',
            'รวม',
            '',
            '',
            '',
            formatMoney(documentPreview.total_amount),
            '',
            '',
          ].map((text, cellIndex) =>
            new TableCell({
              borders: { top: thinBorder, bottom: thinBorder, left: thinBorder, right: thinBorder },
              children: [
                new Paragraph({
                  alignment: cellIndex === 1 ? AlignmentType.CENTER : cellIndex === 5 ? AlignmentType.RIGHT : AlignmentType.LEFT,
                  children: [createDocxTextRun({ text, size: 30, bold: cellIndex === 1 || cellIndex === 5 })],
                }),
              ],
            })
          ),
        }),
      ];

      const doc = new Document({
        styles: {
          default: {
            document: {
              run: {
                font: DOCX_FONT_FAMILY,
                size: 30,
              },
            },
          },
        },
        sections: [
          {
            properties: {
              page: {
                margin: { top: 720, right: 720, bottom: 720, left: 720 },
                size: { orientation: PageOrientation.PORTRAIT },
              },
            },
            children: [
              new Table({
                width: { size: 100, type: WidthType.PERCENTAGE },
                borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder, insideHorizontal: noBorder, insideVertical: noBorder },
                rows: [
                  new TableRow({
                    children: [
                      new TableCell({
                        width: { size: 15, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [
                          new Paragraph({
                            alignment: AlignmentType.LEFT,
                            children: [
                              new ImageRun({
                                data: birdImage,
                                transformation: { width: 55, height: 55 },
                                type: 'jpg',
                              }),
                            ],
                          }),
                        ],
                      }),
                      new TableCell({
                        width: { size: 70, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [
                          new Paragraph({
                            alignment: AlignmentType.CENTER,
                            spacing: { before: 140, after: 80 },
                            children: [createDocxTextRun({ text: 'บันทึกข้อความ', bold: true, size: 36 })],
                          }),
                        ],
                      }),
                      new TableCell({
                        width: { size: 15, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [new Paragraph({ text: '' })],
                      }),
                    ],
                  }),
                ],
              }),
              new Paragraph({
                spacing: { after: 80 },
                children: [
                  createDocxTextRun({ text: 'ส่วนราชการ ', bold: true, size: 30 }),
                  createDocxTextRun({ text: 'งานแผนยุทธศาสตร์ โรงพยาบาลวังทอง อำเภอวังทอง จังหวัดพิษณุโลก', size: 30 }),
                ],
              }),
              new Table({
                width: { size: 100, type: WidthType.PERCENTAGE },
                borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder, insideHorizontal: noBorder, insideVertical: noBorder },
                rows: [
                  new TableRow({
                    children: [
                      new TableCell({
                        width: { size: 62, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [
                          new Paragraph({
                            spacing: { before: 0, after: 100 },
                            children: [
                              createDocxTextRun({ text: 'ที่ ', bold: true, size: 30 }),
                              createDocxTextRun({ text: normalizeThaiDigitsToArabic(documentPreview.doc_no || DEFAULT_DOC_NO), size: 30 }),
                            ],
                          }),
                        ],
                      }),
                      new TableCell({
                        width: { size: 38, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [
                          new Paragraph({
                            alignment: AlignmentType.CENTER,
                            spacing: { before: 140, after: 100 },
                            children: [
                              createDocxTextRun({ text: 'วันที่ ', bold: true, size: 30 }),
                              createDocxTextRun({ text: formatDate(documentPreview.doc_date || documentPreview.created_at), size: 30 }),
                            ],
                          }),
                        ],
                      }),
                    ],
                  }),
                ],
              }),
              new Paragraph({
                spacing: { after: 80 },
                children: [
                  createDocxTextRun({ text: 'เรื่อง ', bold: true, size: 30 }),
                  createDocxTextRun({ text: 'ขอความเห็นชอบจัดซื้อ/จัดจ้าง วัสดุใช้ไป', size: 30 }),
                ],
              }),
              new Paragraph({
                spacing: { after: 120 },
                children: [
                  createDocxTextRun({ text: 'เรียน ', bold: true, size: 30 }),
                  createDocxTextRun({ text: 'ผู้อำนวยการโรงพยาบาลวังทอง', size: 30 }),
                ],
              }),
              new Paragraph({
                spacing: { after: 120 },
                indent: { firstLine: 720 },
                alignment: AlignmentType.JUSTIFIED,
                children: [
                  createDocxTextRun({
                    text: `ตามที่โรงพยาบาลวังทองได้รับการอนุมัติแผนจัดซื้อ/จัดจ้าง วัสดุใช้ไป ตามแผนงบประมาณ ${documentPreview.budget_year || '-'} นั้น ในการนี้ งานแผนยุทธศาสตร์ ขออนุมัติจัดซื้อ/จัดจ้าง วัสดุใช้ไป เพื่อให้บริการหรือสนับสนุนการจัดบริการของโรงพยาบาล เบิกจ่ายจาก เงินบำรุงโรงพยาบาล เป็นจำนวนรายการทั้งสิ้น ${documentPreview.item_count || 0} รายการ เป็นจำนวนเงินทั้งสิ้น ${formatMoney(documentPreview.total_amount)} บาท (${convertNumberToThaiText(documentPreview.total_amount)}) ดังรายการต่อไปนี้`,
                    size: 30,
                  }),
                ],
              }),
              new Table({
                width: { size: 100, type: WidthType.PERCENTAGE },
                rows: tableRows,
              }),
              new Paragraph({
                spacing: { before: 120, after: 120 },
                children: [createDocxTextRun({ text: 'หมายเหตุ :', bold: true, size: 30 })],
              }),
              new Paragraph({
                indent: { firstLine: 720 },
                spacing: { after: 320 },
                children: [createDocxTextRun({ text: 'จึงเรียนมาเพื่อโปรดพิจารณาอนุมัติ', size: 30 })],
              }),
              new Table({
                width: { size: 100, type: WidthType.PERCENTAGE },
                borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder, insideHorizontal: noBorder, insideVertical: noBorder },
                rows: [
                  new TableRow({
                    children: [
                      new TableCell({
                        width: { size: 58, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [new Paragraph({ text: '' })],
                      }),
                      new TableCell({
                        width: { size: 42, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [
                          new Paragraph({
                            alignment: AlignmentType.LEFT,
                            spacing: { after: 520 },
                            children: [createDocxTextRun({ text: 'ลงชื่อ ..........................................................', size: 30 })],
                          }),
                        ],
                      }),
                    ],
                  }),
                  new TableRow({
                    children: [
                      new TableCell({
                        width: { size: 58, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [new Paragraph({ text: '' })],
                      }),
                      new TableCell({
                        width: { size: 42, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [
                          new Paragraph({
                            alignment: AlignmentType.CENTER,
                            spacing: { after: 520 },
                            children: [createDocxTextRun({ text: 'เห็นชอบ / อนุมัติ', size: 30 })],
                          }),
                        ],
                      }),
                    ],
                  }),
                  new TableRow({
                    children: [
                      new TableCell({
                        width: { size: 58, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [new Paragraph({ text: '' })],
                      }),
                      new TableCell({
                        width: { size: 42, type: WidthType.PERCENTAGE },
                        borders: { top: noBorder, bottom: noBorder, left: noBorder, right: noBorder },
                        children: [
                          new Paragraph({
                            alignment: AlignmentType.LEFT,
                            children: [createDocxTextRun({ text: 'ลงชื่อ ..........................................................', size: 30 })],
                          }),
                          new Paragraph({
                            alignment: AlignmentType.CENTER,
                            spacing: { before: 160, after: 160 },
                            children: [createDocxTextRun({ text: '(นายจักริน สมบูรณ์จันทร์)', size: 30 })],
                          }),
                          new Paragraph({
                            alignment: AlignmentType.CENTER,
                            children: [createDocxTextRun({ text: 'ผู้อำนวยการโรงพยาบาลวังทอง', size: 30 })],
                          }),
                        ],
                      }),
                    ],
                  }),
                ],
              }),
            ],
          },
        ],
      });

      const blob = await Packer.toBlob(doc);
      saveAs(blob, `${normalizeThaiDigitsToArabic(documentPreview.doc_no || 'purchase-approval')}.docx`);
    } catch (error) {
      console.error(error);
      await Swal.fire({
        icon: 'error',
        title: 'สร้าง DOCX ไม่สำเร็จ',
        text: 'กรุณาลองใหม่อีกครั้ง',
      });
    }
  };

  const handleOpenDocumentModal = (group: PurchaseApprovalGroup) => {
    setDocumentPreview(group);
  };

  const handleCloseDocumentModal = () => {
    setDocumentPreview(null);
  };

  const handleInlineEdit = (id: number, field: string, value: string) => {
    setEditingRowId(id);
    setEditingData({ field, [field]: value });
  };

  const handleKeyDown = (e: React.KeyboardEvent, id: number) => {
    if (e.key === 'Enter') {
      e.preventDefault();
      handleSaveEdit(id);
    } else if (e.key === 'Escape') {
      e.preventDefault();
      handleCancelEdit();
    }
  };

  const handleCancelEdit = () => {
    setEditingRowId(null);
    setEditingData({});
  };

  const handleSaveEdit = async (id: number) => {
    try {
      setSavingRowId(id);
      const response = await fetch(`/api/purchase-approvals/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(editingData),
      });

      if (!response.ok) {
        throw new Error('Failed to update purchase approval');
      }

      await Swal.fire({
        icon: 'success',
        title: 'อัปเดตข้อมูลสำเร็จ',
        timer: 1500,
        showConfirmButton: false,
      });

      setEditingRowId(null);
      setEditingData({});
      await fetchData();
    } catch (error) {
      console.error(error);
      await Swal.fire({
        icon: 'error',
        title: 'อัปเดตข้อมูลไม่สำเร็จ',
        text: error instanceof Error ? error.message : 'ไม่สามารถอัปเดตข้อมูลได้',
      });
    } finally {
      setSavingRowId(null);
    }
  };

  const handleDelete = async (id: number, approveCode: string) => {
    const result = await Swal.fire({
      title: 'ยืนยันการลบข้อมูล?',
      html: `คุณต้องการลบรายการอนุมัติ <strong>${approveCode}</strong> หรือไม่?<br/>การดำเนินการนี้ไม่สามารถยกเลิกได้`,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: 'ลบข้อมูล',
      cancelButtonText: 'ยกเลิก',
      confirmButtonColor: '#ef4444',
    });

    if (!result.isConfirmed) {
      return;
    }

    try {
      const response = await fetch(`/api/purchase-approvals/${id}`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        throw new Error('Failed to delete purchase approval');
      }

      await Swal.fire({
        icon: 'success',
        title: 'ลบข้อมูลสำเร็จ',
        timer: 1500,
        showConfirmButton: false,
      });

      await fetchData();
    } catch (error) {
      console.error(error);
      await Swal.fire({
        icon: 'error',
        title: 'ลบข้อมูลไม่สำเร็จ',
        text: error instanceof Error ? error.message : 'ไม่สามารถลบข้อมูลได้',
      });
    }
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
                <th onClick={()=>handleSort()} className={getHeaderClass('created_at')}>วันที่สร้าง</th>
                {/* <th onClick={()=>handleSort('id')} className={getHeaderClass('id')}>เลขที่อนุมัติ</th> */}
                <th onClick={()=>handleSort()} className={getHeaderClass('approve_code')}>รหัสอนุมัติ</th>
                <th onClick={()=>handleSort()} className={getHeaderClass('doc_no')}>เลขที่หนังสือ</th>
                <th onClick={()=>handleSort()} className={getHeaderClass('doc_date')}>ลงวันที่</th>
                <th onClick={()=>handleSort()} className={getHeaderClass('status')}>สถานะ</th>
                <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-20">รายการ</th>
                <th className="px-3 py-3 text-center text-[10px] font-medium text-gray-500 uppercase tracking-wider w-24">พิมพ์เอกสาร</th>
                <th className="px-3 py-3 text-left text-[10px] font-medium text-gray-500 uppercase tracking-wider w-20">Action</th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {items.map((group, index) => (
                <React.Fragment key={group.id}>
                  <tr className="hover:bg-gray-50">
                    <td className="px-3 py-2 text-xs font-medium">{(page - 1) * pageSize + index + 1}</td>
                    <td className="px-3 py-2 text-xs">{formatDateTime(group.created_at)}</td>
                    {/* <td className="px-3 py-2 text-xs font-medium text-blue-600">{group.id}</td> */}
                    <td className="px-3 py-2 text-xs">
                      {editingRowId === group.id && editingData.approve_code !== undefined ? (
                        <input
                          type="text"
                          value={editingData.approve_code}
                          onChange={(e) => setEditingData({ ...editingData, approve_code: e.target.value })}
                          onKeyDown={(e) => handleKeyDown(e, group.id)}
                          className="w-full px-2 py-1 text-xs border border-blue-300 rounded focus:outline-none focus:ring-1 focus:ring-blue-500"
                          autoFocus
                        />
                      ) : (
                        <span
                          onClick={() => handleInlineEdit(group.id, 'approve_code', group.approve_code)}
                          className="cursor-pointer hover:bg-blue-50 px-1 py-0.5 rounded"
                          title="คลิกเพื่อแก้ไข"
                        >
                          {group.approve_code}
                        </span>
                      )}
                    </td>
                    <td className="px-3 py-2 text-xs">
                      {editingRowId === group.id && editingData.doc_no !== undefined ? (
                        <input
                          type="text"
                          value={editingData.doc_no}
                          onChange={(e: React.ChangeEvent<HTMLInputElement>) => setEditingData({ ...editingData, doc_no: e.target.value })}
                          onKeyDown={(e) => handleKeyDown(e, group.id)}
                          className="w-full px-2 py-1 text-xs border border-blue-300 rounded focus:outline-none focus:ring-1 focus:ring-blue-500"
                          autoFocus
                        />
                      ) : (
                        <span
                          onClick={() => handleInlineEdit(group.id, 'doc_no', group.doc_no || '')}
                          className="cursor-pointer hover:bg-blue-50 px-1 py-0.5 rounded"
                          title="คลิกเพื่อแก้ไข"
                        >
                          {normalizeThaiDigitsToArabic(group.doc_no || DEFAULT_DOC_NO)}
                        </span>
                      )}
                    </td>
                    <td className="px-3 py-2 text-xs">
                      {editingRowId === group.id && editingData.doc_date !== undefined ? (
                        <input
                          type="date"
                          value={editingData.doc_date}
                          onChange={(e: React.ChangeEvent<HTMLInputElement>) => setEditingData({ ...editingData, doc_date: e.target.value })}
                          onKeyDown={(e) => handleKeyDown(e, group.id)}
                          className="w-full px-2 py-1 text-xs border border-blue-300 rounded focus:outline-none focus:ring-1 focus:ring-blue-500"
                        />
                      ) : (
                        <span
                          onClick={() => handleInlineEdit(group.id, 'doc_date', group.doc_date)}
                          className="cursor-pointer hover:bg-blue-50 px-1 py-0.5 rounded"
                          title="คลิกเพื่อแก้ไข"
                        >
                          {formatThaiBuddhistLongDate(group.doc_date)}
                        </span>
                    )}
                  </td>
                  <td className="px-3 py-2 text-xs">
                    {editingRowId === group.id && editingData.field === 'status' ? (
                      <select
                        value={editingData.status}
                        onChange={(e) => setEditingData(prev => ({ ...prev, status: e.target.value }))}
                        onKeyDown={(e) => handleKeyDown(e, group.id)}
                        className="w-full px-2 py-1 text-xs border border-blue-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                        autoFocus
                      >
                        <option value="DRAFT">DRAFT</option>
                        <option value="PENDING">PENDING</option>
                        <option value="APPROVED">APPROVED</option>
                        <option value="REJECTED">REJECTED</option>
                        <option value="CANCELLED">CANCELLED</option>
                      </select>
                    ) : (
                      <span
                        onClick={() => handleInlineEdit(group.id, 'status', group.status)}
                        className={`inline-flex items-center px-2 py-1 rounded-full text-xs font-medium cursor-pointer hover:opacity-80 ${
                          group.status === 'DRAFT' ? 'bg-gray-100 text-gray-800' :
                          group.status === 'PENDING' ? 'bg-yellow-100 text-yellow-800' :
                          group.status === 'REJECTED' ? 'bg-red-100 text-red-800' :
                          group.status === 'CANCELLED' ? 'bg-gray-100 text-gray-800' :
                          'bg-blue-100 text-blue-800'
                        }`}
                      >
                        {group.status}
                      </span>
                    )}
                  </td>
                  <td className="px-3 py-2 text-xs font-medium w-32">
                    {editingRowId === group.id ? (
                      <div className="w-full"></div>
                    ) : (
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => toggleRowExpansion(group.id.toString())}
                          className="p-1 text-indigo-600 hover:text-indigo-800"
                          title={expandedRows.has(group.id.toString()) ? 'ย่อรายการ' : 'ขยายรายการ'}
                        >
                          {expandedRows.has(group.id.toString()) ? (
                            <ChevronDown className="h-4 w-4" />
                          ) : (
                            <ChevronRight className="h-4 w-4" />
                          )}
                        </button>
                        <span className="text-xs text-gray-600">{group.item_count}</span>
                      </div>
                    )}
                  </td>
                  <td className="px-3 py-2 text-center text-xs">
                    <button
                      type="button"
                      onClick={() => handleOpenDocumentModal(group)}
                      className="inline-flex items-center justify-center rounded-md p-1 text-blue-600 hover:bg-blue-50 hover:text-blue-800 cursor-pointer"
                      title="แสดงตัวอย่างเอกสาร"
                    >
                      <FileText className="h-4 w-4" />
                    </button>
                  </td>
                  <td className="px-3 py-2 text-xs font-medium w-32">
                    {editingRowId === group.id ? (
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleSaveEdit(group.id)}
                          disabled={savingRowId === group.id}
                          className="p-1 text-green-600 hover:text-green-800 disabled:opacity-50"
                          title="บันทึก"
                        >
                          {savingRowId === group.id ? (
                            <div className="animate-spin rounded-full h-4 w-4 border-2 border-green-600 border-t-transparent"></div>
                          ) : (
                            <Save className="h-4 w-4" />
                          )}
                        </button>
                        <button
                          onClick={handleCancelEdit}
                          className="p-1 text-gray-600 hover:text-gray-800"
                          title="ยกเลิก"
                        >
                          <X className="h-4 w-4" />
                        </button>
                      </div>
                    ) : (
                      <div className="flex items-center gap-2">
                        <button
                          onClick={() => handleInlineEdit(group.id, 'approve_code', group.approve_code)}
                          className="p-1 text-blue-600 hover:text-blue-800"
                          title="แก้ไขข้อมูล"
                        >
                          <Edit className="h-4 w-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(group.id, group.approve_code)}
                          className="p-1 text-red-600 hover:text-red-800"
                          title="ลบรายการ"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </div>
                    )}
                  </td>
                </tr>
                {expandedRows.has(group.id.toString()) && (
                  <tr>
                    <td colSpan={9} className="px-0 py-0 bg-gray-50">
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

      {documentPreview ? (
        <div className="fixed inset-0 z-50 overflow-y-auto bg-black/60 p-4 md:p-8 print:bg-white print:p-0">
          <style jsx global>{`
            @media print {
              @page {
                size: A4 portrait;
                margin: 0;
              }

              html,
              body {
                width: 210mm;
                height: 297mm;
                margin: 0 !important;
                padding: 0 !important;
                overflow: visible !important;
                background: #fff !important;
                -webkit-print-color-adjust: exact;
                print-color-adjust: exact;
              }

              body * {
                visibility: hidden;
              }

              .print-document-only,
              .print-document-only * {
                visibility: visible;
              }

              .print-document-only {
                position: absolute;
                left: 0;
                top: 0;
                width: 210mm !important;
                max-width: 210mm !important;
                margin: 0;
                padding: 0;
                box-shadow: none !important;
              }

              .print-hide {
                display: none !important;
              }

              .print-page {
                width: 210mm !important;
                min-height: auto !important;
                padding: 24px !important;
                margin: 0 !important;
                box-shadow: none !important;
                font-size: 15px !important;
                line-height: 1.4rem !important;
                background: #fff !important;
              }

              .print-page p,
              .print-page div,
              .print-page td,
              .print-page span {
                line-height: inherit !important;
              }

              .print-header {
                margin-bottom: 10px !important;
              }

              .print-header-title {
                font-size: 24px !important;
              }

              .print-emblem,
              .print-emblem-spacer {
                width: 80px !important;
                height: 80px !important;
              }

              .print-table-wrapper {
                margin-bottom: 6px !important;
                border-width: 1px !important;
              }

              .print-table {
                font-size: 14px !important;
                line-height: 1.5rem !important;
              }

              .print-table td {
                padding: 6px !important;
                vertical-align: top !important;
              }

              .print-compact {
                margin-bottom: 4px !important;
                padding-bottom: 0 !important;
              }

              .print-signature-gap {
                margin-top: 40px !important;
                margin-bottom: 32px !important;
              }

              .print-approval-title {
                font-size: 15px !important;
                font-weight: 400 !important;
                margin-top: 16px !important;
              }

              .print-signature-block {
                width: 42% !important;
                font-size: inherit !important;
              }

              .print-signature-line {
                margin-top: 8px !important;
              }

              .print-signature-name {
                margin-top: 8px !important;
              }

              .print-signature-title {
                margin-top: 8px !important;
              }
            }
          `}</style>
          <div className="mx-auto w-full max-w-[230mm] print-document-only">
            <div className="print-hide sticky top-0 z-20 mb-3 flex items-center justify-between rounded-lg border border-gray-200 bg-white px-4 py-2 shadow">
              <h2 className="text-lg font-semibold text-gray-900">เอกสารรอพิมพ์</h2>
              <div className="flex items-center gap-2">
                <button
                  type="button"
                  onClick={handleDownloadDocx}
                  className="rounded-md border border-emerald-300 px-3 py-1.5 text-sm text-emerald-700 hover:bg-emerald-50"
                >
                  DOCX
                </button>
                <button
                  type="button"
                  onClick={handlePrintDocument}
                  className="rounded-md border border-blue-300 px-3 py-1.5 text-sm text-blue-700 hover:bg-blue-50"
                >
                  พิมพ์
                </button>
                <button
                  type="button"
                  onClick={handleCloseDocumentModal}
                  className="rounded-md border border-gray-300 px-3 py-1.5 text-sm text-gray-700 hover:bg-gray-100"
                >
                  ปิด
                </button>
              </div>
            </div>

            <div className="print-page mx-auto w-[210mm] min-h-[297mm] max-w-full bg-white p-6 text-[15px] leading-7 text-black shadow-2xl print:min-h-0 print:shadow-none md:p-8">
              <div className="print-header mb-3 flex items-center justify-between">
                <div className="print-emblem flex h-20 w-20 flex-shrink-0 items-center justify-center">
                  <img src="/images/bird.jpg" alt="ตราครุฑ" className="h-20 w-20 object-contain" />
                </div>
                <div className="flex-1 text-center">
                  <h3 className="print-header-title text-[24px] font-bold">บันทึกข้อความ</h3>
                </div>
                <div className="print-emblem-spacer h-20 w-20 flex-shrink-0"></div>
              </div>

              <div className="print-compact mb-2 pb-1">
                <span className="font-bold">ส่วนราชการ</span>{' '}
                งานแผนยุทธศาสตร์ โรงพยาบาลวังทอง อำเภอวังทอง จังหวัดพิษณุโลก
              </div>

              <div className="print-compact mb-2 grid grid-cols-2 gap-3">
                <div>
                  <span className="font-bold">ที่</span>{' '}
                  {normalizeThaiDigitsToArabic(documentPreview.doc_no || DEFAULT_DOC_NO)}
                </div>
                <div className="text-left">
                  <span className="font-bold">วันที่</span>{' '}
                  {formatDate(documentPreview.doc_date || documentPreview.created_at)}
                </div>
              </div>

              <div className="print-compact mb-1"><span className="font-bold">เรื่อง</span> ขอความเห็นชอบจัดซื้อ/จัดจ้าง วัสดุใช้ไป</div>
              <div className="print-compact mb-2"><span className="font-bold">เรียน</span> ผู้อำนวยการโรงพยาบาลวังทอง</div>

              <p className="print-compact mb-2 text-justify indent-12">
                ตามที่โรงพยาบาลวังทองได้รับการอนุมัติแผนจัดซื้อ/จัดจ้าง วัสดุใช้ไป ตามแผนงบประมาณ{' '}
                {documentPreview.budget_year || '-'} นั้น ในการนี้ งานแผนยุทธศาสตร์ ขออนุมัติจัดซื้อ/จัดจ้าง วัสดุใช้ไป
                เพื่อให้บริการหรือสนับสนุนการจัดบริการของโรงพยาบาล เบิกจ่ายจาก เงินบำรุงโรงพยาบาล เป็นจำนวนรายการทั้งสิ้น{' '}
                {documentPreview.item_count || 0} รายการ เป็นจำนวนเงินทั้งสิ้น {formatMoney(documentPreview.total_amount)} บาท ({convertNumberToThaiText(documentPreview.total_amount)})
                ดังรายการต่อไปนี้
              </p>

              <div className="print-table-wrapper mb-2 overflow-x-auto border border-gray-500">
                <table className="print-table min-w-full border-collapse text-[14px] leading-7">
                  <thead>
                    <tr>
                      <td className="border border-gray-500 px-2 py-2 text-center">ลำดับ</td>
                      <td className="border border-gray-500 px-2 py-2 text-center">ชื่อรายการ</td>
                      <td className="border border-gray-500 px-2 py-2 text-center">จำนวน<br />(หน่วย)</td>
                      <td className="border border-gray-500 px-2 py-2 text-center">ขนาดบรรจุ<br />(หน่วยนับ)</td>
                      <td className="border border-gray-500 px-2 py-2 text-center">ราคา/หน่วย<br />(บาท)</td>
                      <td className="border border-gray-500 px-2 py-2 text-center">จำนวนเงิน<br />(บาท)</td>
                      <td className="border border-gray-500 px-2 py-2 text-center">หมายเหตุ<br />เงื่อนไขแผน</td>
                      <td className="border border-gray-500 px-2 py-2 text-center">ลำดับแผน</td>
                    </tr>
                  </thead>
                  <tbody>
                    {(documentPreview.sub_items || []).map((item, index) => (
                      <tr key={item.id}>
                        <td className="border border-gray-500 px-2 py-2 text-center align-top">{index + 1}</td>
                        <td className="border border-gray-500 px-2 py-2 align-top">
                          {(item.product_code ? `${item.product_code} : ` : '') + (item.product_name || '-')}
                        </td>
                        <td className="border border-gray-500 px-2 py-2 text-right align-top">
                          {Number(item.requested_quantity || 0).toLocaleString('th-TH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}
                        </td>
                        <td className="border border-gray-500 px-2 py-2 text-center align-top">{item.unit || '-'}</td>
                        <td className="border border-gray-500 px-2 py-2 text-right align-top">{formatMoney(item.price_per_unit)}</td>
                        <td className="border border-gray-500 px-2 py-2 text-right align-top">{formatMoney(item.total_value)}</td>
                        <td className="border border-gray-500 px-2 py-2 align-top">จำนวน วงเงิน ราคา</td>
                        <td className="border border-gray-500 px-2 py-2 text-center align-top">{item.line_number || '-'}</td>
                      </tr>
                    ))}
                    {(documentPreview.sub_items || []).length === 0 ? (
                      <tr>
                        <td colSpan={8} className="border border-gray-500 px-3 py-4 text-center text-gray-500">ไม่พบรายการสินค้า</td>
                      </tr>
                    ) : null}
                  </tbody>
                  <tfoot>
                    <tr>
                      <td className="border border-gray-500 px-2 py-2"></td>
                      <td className="border border-gray-500 px-2 py-2 text-center font-bold">รวม</td>
                      <td className="border border-gray-500 px-2 py-2"></td>
                      <td className="border border-gray-500 px-2 py-2"></td>
                      <td className="border border-gray-500 px-2 py-2"></td>
                      <td className="border border-gray-500 px-2 py-2 text-right font-bold">{formatMoney(documentPreview.total_amount)}</td>
                      <td className="border border-gray-500 px-2 py-2"></td>
                      <td className="border border-gray-500 px-2 py-2"></td>
                    </tr>
                  </tfoot>
                </table>
              </div>

              <div className="print-compact mb-2"><span className="font-bold">หมายเหตุ :</span></div>

              <p className="print-compact mb-3 indent-12">
                จึงเรียนมาเพื่อโปรดพิจารณาอนุมัติ
              </p>

              <div className="flex justify-end">
                <div className="print-signature-block w-[42%] pt-2 text-left">
                  <p className="print-signature-line">ลงชื่อ ..........................................................</p>
                </div>
              </div>

              <div className="print-signature-gap my-16 flex justify-end">
                <div className="print-signature-block w-[42%] text-center">
                  <p className="print-approval-title text-[15px] leading-none">เห็นชอบ / อนุมัติ</p>
                </div>
              </div>

              <div className="flex justify-end">
                <div className="print-signature-block w-[42%] text-left">
                  <p className="print-signature-line">ลงชื่อ ..........................................................</p>
                  <p className="print-signature-name mt-3 text-center">(นายจักริน สมบูรณ์จันทร์)</p>
                  <p className="print-signature-title mt-3 text-center">ผู้อำนวยการโรงพยาบาลวังทอง</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}