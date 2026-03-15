import { pgQuery } from '@/lib/pg';
import { cacheGet, cacheSet } from '@/lib/redis';

type approval_doc_status_row = {
  code: string;
  status: string;
};

const approval_doc_status_cache_key = 'erp:approval_doc_status:items';

const get_approval_doc_status_items = async (): Promise<approval_doc_status_row[]> => {
  const cached = await cacheGet<approval_doc_status_row[]>(approval_doc_status_cache_key);
  if (cached) {
    return cached;
  }

  const result = await pgQuery<approval_doc_status_row>(
    `SELECT code, status
     FROM public.approval_doc_status
     ORDER BY code ASC`
  );

  await cacheSet(approval_doc_status_cache_key, result.rows, 3600);
  return result.rows;
};

export const get_approval_doc_status_code = async (value?: string | null) => {
  if (!value) {
    return null;
  }

  const rows = await get_approval_doc_status_items();
  const matchedByStatus = rows.find((item) => item.status === value);
  if (matchedByStatus) {
    return matchedByStatus.code;
  }

  const matchedByCode = rows.find((item) => item.code === value);
  if (matchedByCode) {
    return matchedByCode.code;
  }

  return null;
};

export const get_approval_doc_status_value = async (value?: string | null) => {
  if (!value) {
    return null;
  }

  const rows = await get_approval_doc_status_items();
  const matchedByCode = rows.find((item) => item.code === value);
  if (matchedByCode) {
    return matchedByCode.status;
  }

  const matchedByStatus = rows.find((item) => item.status === value);
  if (matchedByStatus) {
    return matchedByStatus.status;
  }

  return null;
};
