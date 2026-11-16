import { NextRequest } from 'next/server';
import { auth } from '@/auth';
import { pgPool } from '@/lib/pg';
import { apiSuccess, apiError } from '@/lib/api-response';
import { cacheDelByPattern } from '@/lib/redis';
import { validateRequest } from '@/lib/validation/validate';
import { createPurchaseApprovalWithDetailsSchema } from '@/lib/validation/schemas';
import { get_approval_doc_status_items } from '@/lib/approval-doc-status';
import { budgetYearOfDateString } from '@/lib/budget-year';
import {
  PurchaseApprovalError,
  createApprovalDocument,
  localDateString,
  sessionActor,
} from '@/lib/purchase-approval';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    const validation = await validateRequest(createPurchaseApprovalWithDetailsSchema, body);

    if (!validation.success) {
      return validation.error;
    }

    const { header, details } = validation.data;
    const now = new Date();
    const docDate = header.doc_date || localDateString(now);
    let budgetYear: number;
    try {
      budgetYear = budgetYearOfDateString(docDate);
    } catch {
      throw new Error('Invalid doc_date');
    }

    const [session, statuses] = await Promise.all([auth(), get_approval_doc_status_items()]);

    const client = await pgPool.connect();
    let created;
    try {
      await client.query('BEGIN');
      created = await createApprovalDocument(client.query.bind(client), {
        header,
        details,
        docDate,
        budgetYear,
        statuses,
        actor: sessionActor(session?.user),
        now,
      });
      await client.query('COMMIT');
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }

    await cacheDelByPattern('erp:purchase:approvals:list:*');
    await cacheDelByPattern('erp:purchase:approvals:filters*');
    await cacheDelByPattern('erp:purchase:plans:list:*');
    await cacheDelByPattern('erp:purchase:plans:filters*');

    return apiSuccess(
      {
        created: details.length,
        header: created.header,
        details: created.details,
        doc_seq: created.docSeq,
        approve_code: created.approveCode,
        doc_no: created.docNo
      },
      `Created purchase approval with ${details.length} items successfully`,
      undefined,
      201
    );
  } catch (error) {
    if (error instanceof PurchaseApprovalError) {
      return apiError(error.message, error.status);
    }
    console.error('Error creating bulk purchase approvals:', error);
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    console.error('Error details:', errorMessage);
    if (error instanceof Error) {
      console.error('Error stack:', error.stack);
    }
    return apiError(`Failed to create bulk purchase approvals: ${errorMessage}`);
  }
}
