export const approval_doc_status_items = [
  { code: '001', status: 'DRAFT' },
  { code: '002', status: 'PENDING' },
  { code: '003', status: 'APPROVED' },
  { code: '004', status: 'REJECTED' },
  { code: '005', status: 'CANCELLED' },
] as const;

export const approval_doc_status_codes = approval_doc_status_items.map((item) => item.code) as [string, ...string[]];
export const approval_doc_status_values = approval_doc_status_items.map((item) => item.status) as [string, ...string[]];

const code_to_status_map = new Map<string, string>(approval_doc_status_items.map((item) => [item.code, item.status]));
const status_to_code_map = new Map<string, string>(approval_doc_status_items.map((item) => [item.status, item.code]));

export const get_approval_doc_status_code = (value?: string | null) => {
  if (!value) {
    return null;
  }

  if (status_to_code_map.has(value)) {
    return status_to_code_map.get(value) ?? null;
  }

  if (code_to_status_map.has(value)) {
    return value;
  }

  return null;
};

export const get_approval_doc_status_value = (value?: string | null) => {
  if (!value) {
    return null;
  }

  if (code_to_status_map.has(value)) {
    return code_to_status_map.get(value) ?? null;
  }

  if (status_to_code_map.has(value)) {
    return value;
  }

  return null;
};
