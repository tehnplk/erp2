import test from 'node:test';
import assert from 'node:assert/strict';

import {
  PurchaseApprovalError,
  approvalStatusFields,
  createApprovalDocument,
  exceedsQuota,
  remainingQuota,
} from '../src/lib/purchase-approval.ts';

const statuses = [
  { code: '001', status: 'DRAFT' },
  { code: '002', status: 'PENDING' },
  { code: '003', status: 'APPROVED' },
  { code: '004', status: 'REJECTED' },
];

const now = new Date('2026-11-16T09:00:00Z');

const scriptedQuery = (plans) => {
  const calls = [];
  let nextDetailId = 500;
  const query = async (text, params = []) => {
    calls.push({ text, params });
    if (text.includes('FROM public.product p')) {
      return {
        rows: params[0].map((code) => ({
          code,
          name: `name ${code}`,
          category: 'ยา',
          purchase_department_id: 7,
          purchase_department_name: 'เภสัช',
        })),
      };
    }
    if (text.includes('FROM public.category')) return { rows: [{ category_code: 'MED' }] };
    if (text.includes('pg_advisory_xact_lock')) return { rows: [{}] };
    if (text.includes('FROM public.purchase_plan')) return { rows: plans };
    if (text.includes('MAX(doc_seq)')) return { rows: [{ next_doc_seq: 42 }] };
    if (text.includes('INSERT INTO public.purchase_approval\n')) {
      return { rows: [{ id: 9, status_code: params[5], approve_code: params[1] }] };
    }
    if (text.includes('INSERT INTO public.purchase_approval_detail')) {
      return { rows: [{ id: nextDetailId++, product_code: params[1], proposed_quantity: params[10] }] };
    }
    return { rows: [], rowCount: 1 };
  };
  return { query, calls };
};

const line = (product_code, qty, amount, extra = {}) => ({
  product_code,
  usage_plan_flag: 'ในแผน',
  budget_year: 2569,
  proposed_quantity: qty,
  proposed_amount: amount,
  ...extra,
});

const plan = (product_code, approved_quota, inventory_qty, purchased_qty, extra = {}) => ({
  product_code,
  budget_year: 2569,
  usage_plan_flag: 'ในแผน',
  approved_quota,
  inventory_qty,
  purchased_qty,
  ...extra,
});

const baseInput = (details, header = {}) => ({
  header: { created_by: 'system', ...header },
  details,
  docDate: '2026-11-16',
  budgetYear: 2570,
  statuses,
  actor: 'สมชาย',
  now,
});

const statementKinds = (calls) =>
  calls.map(({ text }) => {
    if (text.includes('FROM public.product p')) return 'products';
    if (text.includes('FROM public.category')) return 'category';
    if (text.includes('pg_advisory_xact_lock')) return 'lock';
    if (text.includes('FROM public.purchase_plan')) return 'quota';
    if (text.includes('MAX(doc_seq)')) return 'seq';
    if (text.includes('INSERT INTO public.purchase_approval_detail')) return 'detail';
    if (text.includes('INSERT INTO public.purchase_approval_inventory_link')) return 'link';
    if (text.includes('INSERT INTO public.purchase_approval')) return 'header';
    if (text.includes('UPDATE public.purchase_approval')) return 'totals';
    return text;
  });

test('remainingQuota mirrors the purchase-plans page arithmetic', () => {
  assert.equal(remainingQuota(100, 30, 20), 50);
  assert.equal(remainingQuota(100, 80, 40), 0);
  assert.equal(remainingQuota(null, undefined, null), 0);
  assert.equal(remainingQuota('100', '30', '20'), 50);
});

test('exceedsQuota rejects only quantities above the remaining quota', () => {
  assert.equal(exceedsQuota(100, 30, 20, 50), false);
  assert.equal(exceedsQuota(100, 30, 20, 51), true);
  assert.equal(exceedsQuota(100, 80, 40, 1), true);
  assert.equal(exceedsQuota(null, null, null, 1), true);
});

test('createApprovalDocument runs every statement on the given query in order and locks before numbering', async () => {
  const { query, calls } = scriptedQuery([plan('A1', 100, 10, 0), plan('B2', 50, 0, 0)]);

  const created = await createApprovalDocument(
    query,
    baseInput([line('A1', 10, 1000), line('B2', 5, 250.5)])
  );

  assert.deepEqual(statementKinds(calls), [
    'products', 'category', 'lock', 'quota', 'seq', 'header', 'detail', 'link', 'detail', 'link', 'totals',
  ]);
  assert.equal(created.docSeq, 42);
  assert.equal(created.approveCode, 'MED-2570-0042');
  assert.equal(created.header.status, 'DRAFT');
  assert.equal(created.details.length, 2);

  const totals = calls.at(-1);
  assert.match(totals.text, /SET total_items = \(\s*SELECT COUNT\(\*\)/);
  assert.match(totals.text, /SUM\(COALESCE\(pad\.proposed_amount, pad\.approved_amount, 0\)\)/);
  assert.deepEqual(totals.params, [9]);

  const detail = calls.find(({ text }) => text.includes('purchase_approval_detail'));
  assert.equal(detail.params[0], 9);
  assert.equal(detail.params[14], 100);
});

test('createApprovalDocument uses the session actor when the body sends the system placeholder', async () => {
  const { query, calls } = scriptedQuery([plan('A1', 100, 0, 0)]);
  await createApprovalDocument(query, baseInput([line('A1', 1, 10)]));

  const header = calls.find(({ text }) => text.includes('INSERT INTO public.purchase_approval\n'));
  assert.equal(header.params[6], 'สมชาย');
  assert.equal(header.params[10], 'สมชาย');
  assert.equal(header.params[7], null);
  assert.equal(header.params[8], null);
});

test('createApprovalDocument keeps SYSTEM when there is no session and a real body value when given', async () => {
  const anonymous = scriptedQuery([plan('A1', 100, 0, 0)]);
  await createApprovalDocument(anonymous.query, { ...baseInput([line('A1', 1, 10)]), actor: null, header: {} });
  const anonymousHeader = anonymous.calls.find(({ text }) => text.includes('INSERT INTO public.purchase_approval\n'));
  assert.equal(anonymousHeader.params[6], 'SYSTEM');
  assert.equal(anonymousHeader.params[10], 'SYSTEM');

  const named = scriptedQuery([plan('A1', 100, 0, 0)]);
  await createApprovalDocument(named.query, baseInput([line('A1', 1, 10)], { created_by: 'นภา' }));
  const namedHeader = named.calls.find(({ text }) => text.includes('INSERT INTO public.purchase_approval\n'));
  assert.equal(namedHeader.params[10], 'นภา');
});

test('createApprovalDocument rejects a line that exceeds its plan quota before numbering or inserting', async () => {
  const { query, calls } = scriptedQuery([plan('A1', 100, 30, 20)]);

  await assert.rejects(
    () => createApprovalDocument(query, baseInput([line('A1', 51, 510)])),
    (error) => {
      assert.ok(error instanceof PurchaseApprovalError);
      assert.equal(error.status, 409);
      assert.match(error.message, /A1/);
      assert.match(error.message, /เกินโควต้า/);
      return true;
    }
  );
  assert.deepEqual(statementKinds(calls), ['products', 'category', 'lock', 'quota']);
});

test('createApprovalDocument sums repeated lines of one plan row and matches the normalised flag', async () => {
  const plans = [plan('A1', 100, 0, 0), plan('A1', 5, 0, 0, { usage_plan_flag: 'นอกแผน' })];

  const repeated = scriptedQuery(plans);
  await assert.rejects(
    () => createApprovalDocument(repeated.query, baseInput([line('A1', 60, 1), line('A1', 41, 1)])),
    PurchaseApprovalError
  );

  const outOfPlan = scriptedQuery(plans);
  await assert.rejects(
    () => createApprovalDocument(outOfPlan.query, baseInput([line('A1', 6, 1, { usage_plan_flag: 'นอกแผน' })])),
    PurchaseApprovalError
  );

  const withinPlan = scriptedQuery(plans);
  await createApprovalDocument(withinPlan.query, baseInput([line('A1', 6, 1)]));
});

test('createApprovalDocument treats a line without a plan row as having no quota', async () => {
  const { query } = scriptedQuery([]);
  await assert.rejects(() => createApprovalDocument(query, baseInput([line('A1', 1, 1)])), PurchaseApprovalError);
});

test('createApprovalDocument without lines skips product and quota checks but still locks before numbering', async () => {
  const { query, calls } = scriptedQuery([]);
  const created = await createApprovalDocument(query, baseInput([]));

  assert.deepEqual(statementKinds(calls), ['lock', 'seq', 'header', 'totals']);
  assert.equal(created.approveCode, null);
});

test('createApprovalDocument rejects an unknown status before touching the database', async () => {
  const { query, calls } = scriptedQuery([]);
  await assert.rejects(
    () => createApprovalDocument(query, baseInput([line('A1', 1, 1)], { status: 'ARCHIVED' })),
    /Invalid approval status/
  );
  assert.equal(calls.length, 0);
});

test('approvalStatusFields rejects an unknown status', () => {
  assert.equal(approvalStatusFields(statuses, 'ARCHIVED', { currentCode: '001', actor: 'a', now }), null);
  assert.equal(approvalStatusFields(statuses, '', { currentCode: '001', actor: 'a', now }), null);
});

test('approvalStatusFields stamps approver only when the document becomes APPROVED', () => {
  assert.deepEqual(approvalStatusFields(statuses, 'APPROVED', { currentCode: '002', actor: 'สมชาย', now }), {
    status: '003',
    approved_at: now,
    approved_by: 'สมชาย',
  });
  assert.deepEqual(approvalStatusFields(statuses, '003', { currentCode: '002', actor: null, now }), {
    status: '003',
    approved_at: now,
  });
  assert.deepEqual(approvalStatusFields(statuses, 'APPROVED', { currentCode: '003', actor: 'สมชาย', now }), {
    status: '003',
  });
  assert.deepEqual(approvalStatusFields(statuses, 'REJECTED', { currentCode: '002', actor: 'สมชาย', now }), {
    status: '004',
  });
});

test('approvalStatusFields writes pending_note only for PENDING', () => {
  assert.deepEqual(
    approvalStatusFields(statuses, 'PENDING', { currentCode: '001', actor: null, now, pendingNote: 'รอเอกสาร' }),
    { status: '002', pending_note: 'รอเอกสาร' }
  );
  assert.deepEqual(
    approvalStatusFields(statuses, 'REJECTED', { currentCode: '001', actor: null, now, pendingNote: 'รอเอกสาร' }),
    { status: '004' }
  );
});
