import { NextRequest, NextResponse } from 'next/server';
import { auth } from '@/auth';
import { pgQuery } from '@/lib/pg';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { createPurchaseApprovalSchema, idParamSchema } from '@/lib/validation/schemas';
import { get_approval_doc_status_items, get_approval_doc_status_value } from '@/lib/approval-doc-status';
import { budgetYearOfDateString } from '@/lib/budget-year';
import {
  approvalStatusFields,
  findApprovalDocStatus,
  sessionActor,
  type ApprovalStatusFields,
} from '@/lib/purchase-approval';

export async function PATCH(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;
    const body = await request.json();
    
    const { status, pending_note, is_inspection } = body;

    const hasStatusUpdate = status !== undefined;
    const hasInspectionUpdate = is_inspection !== undefined;

    if (!hasStatusUpdate && !hasInspectionUpdate) {
      return NextResponse.json({ error: 'No supported fields to update' }, { status: 400 });
    }

    const statuses = hasStatusUpdate ? await get_approval_doc_status_items() : [];
    if (hasStatusUpdate && !findApprovalDocStatus(statuses, status)) {
      return NextResponse.json({ error: 'Invalid status. Must be DRAFT, PENDING, APPROVED, REJECTED, or CANCELLED' }, { status: 400 });
    }

    const existingResult = await pgQuery('SELECT id, status FROM public.purchase_approval WHERE id = $1 LIMIT 1', [numericId]);
    if (existingResult.rows.length === 0) {
      return NextResponse.json({ error: 'Purchase approval not found' }, { status: 404 });
    }

    const fields: Partial<ApprovalStatusFields> & { is_inspection?: boolean } = {};
    if (hasStatusUpdate) {
      const session = await auth();
      Object.assign(
        fields,
        approvalStatusFields(statuses, status, {
          currentCode: existingResult.rows[0].status,
          actor: sessionActor(session?.user),
          now: new Date(),
          pendingNote: pending_note,
        })
      );
    }

    if (hasInspectionUpdate) {
      fields.is_inspection = Boolean(is_inspection);
    }

    const queryParams = Object.values(fields);
    const updateFields = [
      'updated_at = CURRENT_TIMESTAMP',
      ...Object.keys(fields).map((column, index) => `${column} = $${index + 1}`),
    ];

    const updated = await pgQuery(
      `UPDATE public.purchase_approval
       SET ${updateFields.join(', ')}
       WHERE id = $${queryParams.length + 1}
       RETURNING id, doc_seq, approve_code, doc_no, doc_date, budget_year, seller_id, COALESCE(is_inspection, false) AS is_inspection, status AS status_code, total_amount, total_items, prepared_by, approved_by, approved_at, notes, pending_note, created_at, updated_at, version`,
      [...queryParams, numericId]
    );
    
    await cacheDelByPattern('erp:purchase:approvals:list:*');
    await cacheDelByPattern('erp:purchase:approvals:filters*');
    updated.rows[0].status = await get_approval_doc_status_value(updated.rows[0].status_code);
    return NextResponse.json(updated.rows[0]);
  } catch (error) {
    console.error('Error updating purchase approval status:', error);
    return NextResponse.json({ error: 'Failed to update purchase approval status' }, { status: 500 });
  }
}

export async function PUT(request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;
    const body = await request.json();
    const validation = await validateRequest(createPurchaseApprovalSchema.partial(), body);
    if (!validation.success) {
      return validation.error;
    }

    const existingResult = await pgQuery('SELECT id, status FROM public.purchase_approval WHERE id = $1 LIMIT 1', [numericId]);
    if (existingResult.rows.length === 0) {
      return NextResponse.json({ error: 'Purchase approval not found' }, { status: 404 });
    }

    const statusFields: Partial<ApprovalStatusFields> | null = validation.data.status
      ? approvalStatusFields(await get_approval_doc_status_items(), validation.data.status, {
          currentCode: existingResult.rows[0].status,
          actor: sessionActor((await auth())?.user),
          now: new Date(),
        })
      : {};
    if (!statusFields) {
      return NextResponse.json({ error: 'Invalid status. Must exist in approval_doc_status master data' }, { status: 400 });
    }

    const data: Record<string, unknown> = {
      approve_code: validation.data.approve_code ?? null,
      doc_no: validation.data.doc_no ?? null,
      doc_date: validation.data.doc_date ?? null,
      seller_id: validation.data.seller_id ?? null,
      is_inspection: validation.data.is_inspection ?? null,
      status: statusFields.status ?? null,
      total_amount: validation.data.total_amount ?? null,
      total_items: validation.data.total_items ?? null,
      prepared_by: validation.data.prepared_by ?? null,
      approved_by: validation.data.approved_by ?? statusFields.approved_by ?? null,
      approved_at: validation.data.approved_by
        ? (validation.data.approved_at || new Date().toISOString())
        : (statusFields.approved_at ?? null),
      notes: validation.data.notes ?? null,
      pending_note: validation.data.pending_note ?? null,
      updated_by: validation.data.updated_by ?? 'SYSTEM'
    };

    if (typeof validation.data.doc_date === 'string' && validation.data.doc_date) {
      data.budget_year = budgetYearOfDateString(validation.data.doc_date);
    }

    const columnMap: Record<string, string> = {
      approve_code: 'approve_code',
      doc_no: 'doc_no',
      doc_date: 'doc_date',
      seller_id: 'seller_id',
      is_inspection: 'is_inspection',
      status: 'status',
      total_amount: 'total_amount',
      total_items: 'total_items',
      prepared_by: 'prepared_by',
      approved_by: 'approved_by',
      approved_at: 'approved_at',
      notes: 'notes',
      pending_note: 'pending_note',
      budget_year: 'budget_year',
      updated_by: 'updated_by'
    };

    const assignments: string[] = [];
    const values: unknown[] = [];
    Object.entries(data).forEach(([key, value]) => {
      if (value === undefined || value === null) return;
      const column = columnMap[key];
      if (!column) return;
      values.push(value);
      assignments.push(`${column} = $${values.length}`);
    });

    if (assignments.length === 0) {
      const unchanged = await pgQuery('SELECT pa.id, pa.doc_seq, pa.approve_code, pa.doc_no, pa.doc_date, pa.budget_year, pa.seller_id, COALESCE(pa.is_inspection, false) AS is_inspection, ads.status, pa.status AS status_code, pa.total_amount, pa.total_items, pa.prepared_by, pa.approved_by, pa.approved_at, pa.notes, pa.pending_note, pa.created_at, pa.updated_at, pa.version FROM public.purchase_approval pa LEFT JOIN public.approval_doc_status ads ON ads.code = pa.status AND ads.is_active = true WHERE pa.id = $1 LIMIT 1', [numericId]);
      return NextResponse.json(unchanged.rows[0]);
    }

    assignments.push('updated_at = CURRENT_TIMESTAMP');
    values.push(numericId);
    const updated = await pgQuery(
      `UPDATE public.purchase_approval SET ${assignments.join(', ')} WHERE id = $${values.length}
       RETURNING id, doc_seq, approve_code, doc_no, doc_date, budget_year, seller_id, COALESCE(is_inspection, false) AS is_inspection, status AS status_code, total_amount, total_items, prepared_by, approved_by, approved_at, notes, pending_note, created_at, updated_at, version`,
      values
    );
    await cacheDelByPattern('erp:purchase:approvals:list:*');
    await cacheDelByPattern('erp:purchase:approvals:filters*');
    updated.rows[0].status = await get_approval_doc_status_value(updated.rows[0].status_code);
    return NextResponse.json(updated.rows[0]);
  } catch (error) {
    console.error('Error updating purchase approval:', error);
    return NextResponse.json({ error: 'Failed to update purchase approval' }, { status: 500 });
  }
}

export async function DELETE(_request: NextRequest, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;
    const parsedId = idParamSchema.safeParse({ id });
    if (!parsedId.success) {
      return NextResponse.json({ error: 'Invalid ID format' }, { status: 400 });
    }

    const numericId = parsedId.data.id;

    await pgQuery('DELETE FROM public.purchase_approval WHERE id = $1', [numericId]);
    await cacheDelByPattern('erp:purchase:approvals:list:*');
    await cacheDelByPattern('erp:purchase:approvals:filters*');
    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');
    return NextResponse.json({ success: true });
  } catch (error) {
    console.error('Error deleting purchase approval:', error);
    return NextResponse.json({ error: 'Failed to delete purchase approval' }, { status: 500 });
  }
}
