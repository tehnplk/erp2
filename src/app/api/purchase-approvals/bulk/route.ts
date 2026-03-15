import { NextRequest } from 'next/server';
import { pgQuery } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { createPurchaseApprovalWithDetailsSchema } from '@/lib/validation/schemas';

const DEFAULT_DOC_NO = 'พล. 0733.301/พิเศษ';

const getCurrentDateString = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    const validation = await validateRequest(createPurchaseApprovalWithDetailsSchema, body);
    
    if (!validation.success) {
      return validation.error;
    }

    const { header, details } = validation.data;
    const purchasePlanIds = Array.from(new Set(details.map((detail) => detail.purchase_plan_id)));

    const purchasePlanMetaResult = await pgQuery<{
      id: number;
      category: string | null;
      budget_year: number | null;
      category_code: string | null;
    }>(
      `SELECT
         pp.id,
         up.category,
         up.budget_year,
         category_map.category_code
       FROM public.purchase_plan pp
       INNER JOIN public.usage_plan up ON up.id = pp.usage_plan_id
       LEFT JOIN (
         SELECT category, MIN(category_code) AS category_code
         FROM public.category
         GROUP BY category
       ) category_map ON category_map.category = up.category
       WHERE pp.id = ANY($1::int[])`,
      [purchasePlanIds]
    );

    if (purchasePlanMetaResult.rows.length !== purchasePlanIds.length) {
      return apiError('พบรายการแผนจัดซื้อไม่ครบถ้วนสำหรับการสร้างเอกสารอนุมัติจัดซื้อ');
    }

    const categories = Array.from(
      new Set(
        purchasePlanMetaResult.rows
          .map((row) => row.category)
          .filter((category): category is string => Boolean(category))
      )
    );

    if (categories.length !== 1) {
      return apiError('การสร้างเอกสารอนุมัติจัดซื้อสามารถเลือกรายการสินค้าได้เฉพาะหมวดเดียวกันเท่านั้น');
    }

    const categoryCode = purchasePlanMetaResult.rows[0]?.category_code;
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
    const budgetYear = purchasePlanMetaResult.rows[0]?.budget_year || null;
    const approveCode = header.approve_code || `${categoryCode}-${budgetYear || '0000'}-${String(docSeq).padStart(4, '0')}`;
    const docNo = header.doc_no || DEFAULT_DOC_NO;

    // Create purchase approval header
    const headerResult = await pgQuery(
      `INSERT INTO public.purchase_approval 
       (id, doc_seq, approve_code, doc_no, doc_date, status, prepared_by, approved_by, approved_at, notes, total_amount, total_items, created_by, updated_by, version)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, 1)
       RETURNING id, doc_seq, approve_code, doc_no, doc_date, status, total_amount, total_items, 
                prepared_by, approved_by, approved_at, notes, created_at, updated_at, version`,
      [
        seqId,
        docSeq,
        approveCode,
        docNo,
        header.doc_date || currentDate,
        header.status || 'DRAFT',
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

    const purchaseApprovalId = headerResult.rows[0].id;
    const createdItems = [headerResult.rows[0]];

    // Create purchase approval details
    for (let i = 0; i < details.length; i++) {
      const detail = details[i];
      const detailWithApprovalId = {
        ...detail,
        purchase_approval_id: purchaseApprovalId,
        line_number: detail.line_number || (i + 1)
      };
      
      const detailResult = await pgQuery(
        `INSERT INTO public.purchase_approval_detail 
         (purchase_approval_id, purchase_plan_id, line_number, status, approved_quantity, 
          approved_amount, remarks, created_by, updated_by, version)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 1)
         RETURNING id, purchase_approval_id, purchase_plan_id, line_number, status,
                  approved_quantity, approved_amount, remarks, created_at, updated_at, version`,
        [
          detailWithApprovalId.purchase_approval_id,
          detailWithApprovalId.purchase_plan_id,
          detailWithApprovalId.line_number,
          detailWithApprovalId.status || 'PENDING',
          detailWithApprovalId.approved_quantity || 0,
          detailWithApprovalId.approved_amount || 0,
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
           SELECT $1, $1, 'PENDING', 0
           WHERE NOT EXISTS (
             SELECT 1
             FROM public.purchase_approval_inventory_link
             WHERE purchase_approval_detail_id = $1
           )`,
          [createdDetail.id]
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
         SELECT COALESCE(SUM(pp.purchase_value), 0)
         FROM public.purchase_approval_detail pad
         INNER JOIN public.purchase_plan pp ON pp.id = pad.purchase_plan_id
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
