import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { createPurchaseApprovalWithDetailsSchema } from '@/lib/validation/schemas';
import { get_approval_doc_status_code, get_approval_doc_status_value } from '@/lib/approval-doc-status';

const DEFAULT_DOC_NO = 'พล. 0733.301/พิเศษ';

const getCurrentDateString = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const getBudgetYearFromDate = (dateValue: string) => {
  const parsedDate = new Date(`${dateValue}T00:00:00`);
  if (Number.isNaN(parsedDate.getTime())) {
    throw new Error('Invalid doc_date');
  }

  const year = parsedDate.getFullYear();
  const month = parsedDate.getMonth();
  return month >= 9 ? year + 544 : year + 543;
};

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    const validation = await validateRequest(createPurchaseApprovalWithDetailsSchema, body);
    
    if (!validation.success) {
      return validation.error;
    }

    const { header, details } = validation.data;
    const detailProductCodes = Array.from(
      new Set(
        details
          .map((detail) => detail.product_code?.trim())
          .filter((code): code is string => Boolean(code))
      )
    );

    if (detailProductCodes.length === 0) {
      return apiError('ไม่พบรหัสสินค้าสำหรับสร้างเอกสารอนุมัติ');
    }

    const productMetaResult = await pgQuery<{
      code: string;
      name: string | null;
      category: string | null;
      type: string | null;
      subtype: string | null;
      purchase_department_id: number | null;
      purchase_department_name: string | null;
    }>(
      `SELECT
         p.code,
         p.name,
         p.category,
         p.type,
         p.subtype,
         p.purchase_department_id,
         COALESCE(pd.name, pd.department_code) AS purchase_department_name
       FROM public.product p
       LEFT JOIN public.department pd ON pd.id = p.purchase_department_id
       WHERE p.code = ANY($1::text[])`,
      [detailProductCodes]
    );

    if (productMetaResult.rows.length !== detailProductCodes.length) {
      return apiError('พบบางรายการรหัสสินค้าไม่ถูกต้องสำหรับสร้างเอกสารอนุมัติ');
    }

    const categories = Array.from(
      new Set(
        productMetaResult.rows
          .map((row) => row.category)
          .filter((category): category is string => Boolean(category))
      )
    );

    if (categories.length !== 1) {
      return apiError('การสร้างเอกสารอนุมัติจัดซื้อสามารถเลือกรายการสินค้าได้เฉพาะหมวดเดียวกันเท่านั้น');
    }

    const purchaseDepartmentIds = Array.from(
      new Set(
        productMetaResult.rows
          .map((row) => Number(row.purchase_department_id))
          .filter((id) => Number.isFinite(id) && id > 0)
      )
    );

    if (purchaseDepartmentIds.length !== 1) {
      return apiError('การสร้างเอกสารอนุมัติจัดซื้อกำหนดได้เฉพาะหน่วยงานจัดซื้อเดียวกันเท่านั้น');
    }

    const categoryCodeResult = await pgQuery<{ category_code: string | null }>(
      `SELECT MIN(category_code) AS category_code
       FROM public.category
       WHERE is_active = true
         AND category = $1`,
      [categories[0]]
    );
    const categoryCode = categoryCodeResult.rows[0]?.category_code;
    if (!categoryCode) {
      return apiError('ไม่พบรหัสหมวดสำหรับการสร้างรหัสเอกสาร');
    }

    const seqResult = await pgQuery(
      `SELECT NEXTVAL('purchase_approval_id_seq') as seq_id`
    );
    const seqId = seqResult.rows[0].seq_id;
    const docSeqResult = await pgQuery<{ next_doc_seq: number }>(
      `SELECT COALESCE(MAX(doc_seq), 0) + 1 AS next_doc_seq FROM public.purchase_approval`
    );
    const docSeq = docSeqResult.rows[0]?.next_doc_seq || 1;
    
    const currentDate = getCurrentDateString();
    const docDate = header.doc_date || currentDate;
    const budgetYear = getBudgetYearFromDate(docDate);
    const approveCode = header.approve_code || `${categoryCode}-${budgetYear || '0000'}-${String(docSeq).padStart(4, '0')}`;
    const docNo = header.doc_no || DEFAULT_DOC_NO;

    // Create purchase approval header
    const normalizedHeaderStatusCode = await get_approval_doc_status_code(header.status);
    if (header.status && !normalizedHeaderStatusCode) {
      return apiError('Invalid approval status');
    }

    const headerResult = await pgQuery(
      `INSERT INTO public.purchase_approval 
       (id, doc_seq, approve_code, doc_no, doc_date, budget_year, status, prepared_by, approved_by, approved_at, notes, total_amount, total_items, created_by, updated_by, version)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, 1)
       RETURNING id, doc_seq, approve_code, doc_no, doc_date, budget_year, status AS status_code, total_amount, total_items, 
                prepared_by, approved_by, approved_at, notes, created_at, updated_at, version`,
      [
        seqId,
        docSeq,
        approveCode,
        docNo,
        docDate,
        budgetYear,
        normalizedHeaderStatusCode || '001',
        header.prepared_by || header.created_by || 'SYSTEM',
        header.approved_by || null,
        header.approved_at || null,
        header.notes || null,
        0, // total_amount will be updated later
        0, // total_items will be updated later
        header.created_by || 'SYSTEM',
        header.updated_by || header.created_by || 'SYSTEM'
      ]
    );
    headerResult.rows[0].status = await get_approval_doc_status_value(headerResult.rows[0].status_code);

    const purchaseApprovalId = headerResult.rows[0].id;
    const createdItems = [headerResult.rows[0]];

    // Create purchase approval details
    for (let i = 0; i < details.length; i++) {
      const detail = details[i];
      const productMeta = productMetaResult.rows.find((row) => row.code === detail.product_code?.trim());
      if (!productMeta) {
        throw new Error(`ไม่พบข้อมูลสินค้าสำหรับรหัส ${detail.product_code}`);
      }

      const detailWithApprovalId = {
        ...detail,
        purchase_approval_id: purchaseApprovalId,
        line_number: detail.line_number || (i + 1),
        product_code: productMeta.code,
        product_name: detail.product_name || productMeta.name || null,
        requesting_dept_text: detail.requesting_dept_text || null,
        purchase_department_id: productMeta.purchase_department_id,
        purchase_department_name: detail.purchase_department_name || productMeta.purchase_department_name || null,
        usage_plan_flag: detail.usage_plan_flag || 'ในแผน',
        budget_year: Number(detail.budget_year || budgetYear),
      };
      const normalizedQty = Number(detailWithApprovalId.proposed_quantity ?? detailWithApprovalId.approved_quantity ?? 0);
      const normalizedAmount = Number(detailWithApprovalId.proposed_amount ?? detailWithApprovalId.approved_amount ?? 0);
      const normalizedUnitPrice = normalizedQty > 0
        ? Number((normalizedAmount / normalizedQty).toFixed(2))
        : 0;
      
      const detailResult = await pgQuery(
        `INSERT INTO public.purchase_approval_detail 
         (purchase_approval_id, product_code, product_name, requesting_dept_text, purchase_department_id,
          purchase_department_name, usage_plan_flag, budget_year, line_number, status, proposed_quantity, proposed_amount,
          approved_quantity, approved_amount, cal_unit_price, remarks, created_by, updated_by, version)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, 1)
         RETURNING id, purchase_approval_id, product_code, product_name, requesting_dept_text,
                  purchase_department_id, purchase_department_name, usage_plan_flag, budget_year, line_number, status,
                  proposed_quantity, proposed_amount, approved_quantity, approved_amount, cal_unit_price, remarks, created_at, updated_at, version`,
        [
          detailWithApprovalId.purchase_approval_id,
          detailWithApprovalId.product_code,
          detailWithApprovalId.product_name,
          detailWithApprovalId.requesting_dept_text,
          detailWithApprovalId.purchase_department_id,
          detailWithApprovalId.purchase_department_name,
          detailWithApprovalId.usage_plan_flag,
          detailWithApprovalId.budget_year,
          detailWithApprovalId.line_number,
          detailWithApprovalId.status || 'PENDING',
          normalizedQty,
          normalizedAmount,
          Number(detailWithApprovalId.approved_quantity || 0),
          Number(detailWithApprovalId.approved_amount || 0),
          normalizedUnitPrice,
          detailWithApprovalId.remarks || null,
          detailWithApprovalId.created_by || header.created_by || 'SYSTEM',
          detailWithApprovalId.updated_by || detailWithApprovalId.created_by || header.created_by || 'SYSTEM'
        ]
      );
      
      if (detailResult.rows.length > 0) {
        const createdDetail = detailResult.rows[0];
        createdItems.push(createdDetail);

        await pgQuery(
          `INSERT INTO public.purchase_approval_inventory_link
           (purchase_approval_id, purchase_approval_detail_id, inventory_receipt_status, received_qty)
           SELECT $1, $2, 'PENDING', 0
           WHERE NOT EXISTS (
             SELECT 1
             FROM public.purchase_approval_inventory_link
             WHERE purchase_approval_detail_id = $2
           )`,
          [purchaseApprovalId, createdDetail.id]
        );
      }
    }

    // Update totals on header
    await pgQuery(
      `UPDATE public.purchase_approval 
       SET total_items = (
         SELECT COUNT(*) 
         FROM public.purchase_approval_detail 
         WHERE purchase_approval_id = $1
       ),
       total_amount = (
         SELECT COALESCE(SUM(COALESCE(pad.proposed_amount, pad.approved_amount, 0)), 0)
         FROM public.purchase_approval_detail pad
         WHERE pad.purchase_approval_id = $1
       )
       WHERE id = $1`,
      [purchaseApprovalId]
    );
    
    // Clear cache
    await cacheDelByPattern('erp:purchase:approvals:list:*');
    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');
    
    return apiSuccess(
      { 
        created: details.length,
        header: createdItems[0],
        details: createdItems.slice(1),
        doc_seq: docSeq,
        approve_code: approveCode,
        doc_no: docNo
      }, 
      `Created purchase approval with ${details.length} items successfully`, 
      undefined, 
      201
    );
  } catch (error) {
    console.error('Error creating bulk purchase approvals:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    console.error('Error details:', errorMessage);
    if (error instanceof Error) {
      console.error('Error stack:', error.stack);
    }
    return apiError(`Failed to create bulk purchase approvals: ${errorMessage}`);
  }
}
