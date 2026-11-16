import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';
import { findApprovalDocStatus, type ApprovalDocStatusRow } from '@/lib/purchase-approval';

const approval_doc_status_cache_key = 'erp:approval_doc_status:items';

export const get_approval_doc_status_items = async (): Promise<ApprovalDocStatusRow[]> => {
  const cached = await cacheGet<ApprovalDocStatusRow[]>(approval_doc_status_cache_key);
  if (cached) {
    return cached;
  }

  const result = await pgQuery<ApprovalDocStatusRow>(
    `SELECT code, status
     FROM public.approval_doc_status
     WHERE is_active = true
     ORDER BY code ASC`
  );

  await cacheSet(approval_doc_status_cache_key, result.rows, 3600);
  return result.rows;
};

export const get_approval_doc_status_code = async (value?: string | null) =>
  value ? findApprovalDocStatus(await get_approval_doc_status_items(), value)?.code ?? null : null;

export const get_approval_doc_status_value = async (value?: string | null) =>
  value ? findApprovalDocStatus(await get_approval_doc_status_items(), value)?.status ?? null : null;
