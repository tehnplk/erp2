import test from 'node:test';
import assert from 'node:assert/strict';

import {
  InventoryIssueRuleError,
  insertIssueHeader,
  reduceStockLot,
  restoreStockLot,
  validateIssueQuota,
} from '../src/lib/inventory-issue.ts';

function scriptedQuery(responders) {
  const calls = [];
  const query = async (text, params) => {
    calls.push({ text, params });
    const responder = responders.find(([pattern]) => pattern.test(text));
    if (!responder) throw new Error(`unexpected query: ${text}`);
    return responder[1](params);
  };
  return { query, calls };
}

function quotaQuery({ approved, issued, department = [{ department_code: 'D01' }] }) {
  return scriptedQuery([
    [/FROM public\.department WHERE id/, () => ({ rows: department })],
    [/FROM public\.inventory_stock_lot isl/, () => ({
      rows: [
        { stock_lot_id: 11, product_code: 'P-A' },
        { stock_lot_id: 12, product_code: 'P-A' },
        { stock_lot_id: 21, product_code: 'P-B' },
      ],
    })],
    [/FROM public\.usage_plan up/, () => ({
      rows: Object.entries(approved).map(([product_code, approved_quota]) => ({ product_code, approved_quota })),
    })],
    [/FROM public\.inventory_issue_item iit/, () => ({
      rows: Object.entries(issued).map(([product_code, issued_qty]) => ({ product_code, issued_qty })),
    })],
  ]);
}

const items = [
  { stock_lot_id: 11, issued_qty: 3 },
  { stock_lot_id: 12, issued_qty: 2 },
  { stock_lot_id: 21, issued_qty: 1 },
];

test('validateIssueQuota passes when every product fits its remaining quota', async () => {
  const { query } = quotaQuery({ approved: { 'P-A': 10, 'P-B': 1 }, issued: { 'P-A': 5 } });
  await validateIssueQuota(query, { requestingDepartmentId: 7, issueDate: '2026-10-05', items });
});

test('validateIssueQuota sums lots of one product and rejects when over quota', async () => {
  const { query } = quotaQuery({ approved: { 'P-A': 10, 'P-B': 1 }, issued: { 'P-A': '6' } });
  await assert.rejects(
    () => validateIssueQuota(query, { requestingDepartmentId: 7, issueDate: '2026-10-05', items }),
    (error) => {
      assert.ok(error instanceof InventoryIssueRuleError);
      assert.equal(error.message, 'สินค้า P-A เบิกเกินโควต้าปีงบ 2570 (โควต้า 10, เบิกแล้ว 6, ขอเบิก 5)');
      return true;
    }
  );
});

test('validateIssueQuota treats a product with no usage plan as zero quota', async () => {
  const { query } = quotaQuery({ approved: { 'P-A': 10 }, issued: {} });
  await assert.rejects(
    () => validateIssueQuota(query, { requestingDepartmentId: 7, issueDate: '2026-10-05', items }),
    /สินค้า P-B เบิกเกินโควต้า/
  );
});

test('validateIssueQuota forwards excludeIssueId and budget year to the issued-qty query', async () => {
  const { query, calls } = quotaQuery({ approved: { 'P-A': 10, 'P-B': 1 }, issued: {} });
  await validateIssueQuota(query, { requestingDepartmentId: 7, issueDate: '2026-10-05', items, excludeIssueId: 99 });
  const issuedCall = calls.find((call) => /FROM public\.inventory_issue_item iit/.test(call.text));
  assert.deepEqual(issuedCall.params, [7, ['P-A', 'P-B'], 2570, 99]);
  assert.match(issuedCall.text, /EXTRACT\(MONTH FROM ii\.issue_date\) >= 10/);

  const { query: query2, calls: calls2 } = quotaQuery({ approved: { 'P-A': 10, 'P-B': 1 }, issued: {} });
  await validateIssueQuota(query2, { requestingDepartmentId: 7, issueDate: '2026-10-05', items });
  assert.equal(calls2.find((call) => /FROM public\.inventory_issue_item iit/.test(call.text)).params[3], null);
});

test('validateIssueQuota rejects an unknown department as a rule violation', async () => {
  const { query } = quotaQuery({ approved: {}, issued: {}, department: [] });
  await assert.rejects(
    () => validateIssueQuota(query, { requestingDepartmentId: 7, issueDate: '2026-10-05', items }),
    (error) => error instanceof InventoryIssueRuleError && error.message === 'ไม่พบหน่วยงานที่ระบุ'
  );
});

test('validateIssueQuota rejects an unknown lot as a rule violation', async () => {
  const { query } = quotaQuery({ approved: {}, issued: {} });
  await assert.rejects(
    () => validateIssueQuota(query, { requestingDepartmentId: 7, issueDate: '2026-10-05', items: [{ stock_lot_id: 404, issued_qty: 1 }] }),
    (error) => error instanceof InventoryIssueRuleError && error.message === 'ไม่พบข้อมูลล็อตสินค้า 404'
  );
});

function fiscalYearQuotaQuery({ approvedByYear, issuedByYear }) {
  return scriptedQuery([
    [/FROM public\.department WHERE id/, () => ({ rows: [{ department_code: 'D01' }] })],
    [/FROM public\.inventory_stock_lot isl/, () => ({ rows: [{ stock_lot_id: 11, product_code: 'P-A' }] })],
    [/FROM public\.usage_plan up/, (params) => ({
      rows: [{ product_code: 'P-A', approved_quota: approvedByYear[params[1]] ?? 0 }],
    })],
    [/FROM public\.inventory_issue_item iit/, (params) => ({
      rows: [{ product_code: 'P-A', issued_qty: issuedByYear[params[2]] ?? 0 }],
    })],
  ]);
}

test('validateIssueQuota checks the fiscal year of the issue date, not a fixed year', async () => {
  const fiscalData = { approvedByYear: { 2569: 3, 2570: 10 }, issuedByYear: { 2569: 3, 2570: 0 } };
  const lines = [{ stock_lot_id: 11, issued_qty: 2 }];

  const { query: octoberQuery } = fiscalYearQuotaQuery(fiscalData);
  await validateIssueQuota(octoberQuery, { requestingDepartmentId: 7, issueDate: '2026-10-05', items: lines });

  const { query: septemberQuery } = fiscalYearQuotaQuery(fiscalData);
  await assert.rejects(
    () => validateIssueQuota(septemberQuery, { requestingDepartmentId: 7, issueDate: '2026-09-30', items: lines }),
    (error) => error instanceof InventoryIssueRuleError
      && error.message === 'สินค้า P-A เบิกเกินโควต้าปีงบ 2569 (โควต้า 3, เบิกแล้ว 3, ขอเบิก 2)'
  );
});

test('validateIssueQuota rejects an unparseable issue date as a rule violation', async () => {
  const { query } = quotaQuery({ approved: {}, issued: {} });
  await assert.rejects(
    () => validateIssueQuota(query, { requestingDepartmentId: 7, issueDate: 'not-a-date', items }),
    InventoryIssueRuleError
  );
});

function issueTableQuery() {
  let sequence = 40;
  const rows = [];
  const { query } = scriptedQuery([
    [/nextval\(pg_get_serial_sequence\('public\.inventory_issue', 'id'\)\)/, () => ({ rows: [{ id: ++sequence }] })],
    [/INSERT INTO public\.inventory_issue /, (params) => {
      const [id, issue_no, issue_date, requesting_department_id, note] = params;
      if (rows.some((row) => row.issue_no === issue_no)) throw new Error('duplicate issue_no');
      rows.push({ id, issue_no, issue_date, requesting_department_id, note });
      return { rows: [], rowCount: 1 };
    }],
  ]);
  return { query, rows };
}

test('insertIssueHeader gives issues created in the same second distinct numbers tied to their ids', async () => {
  const { query, rows } = issueTableQuery();
  const sameSecond = new Date('2026-11-16T03:04:05.123Z');
  const header = { issueDate: '2026-11-16', requestingDepartmentId: 7, note: null };

  const first = await insertIssueHeader(query, header, sameSecond);
  const second = await insertIssueHeader(query, header, new Date('2026-11-16T03:04:05.987Z'));

  assert.deepEqual(first, { id: 41, issue_no: 'ISS-20261116030405-41' });
  assert.deepEqual(second, { id: 42, issue_no: 'ISS-20261116030405-42' });
  assert.deepEqual(rows.map((row) => [row.id, row.issue_no]), [[41, 'ISS-20261116030405-41'], [42, 'ISS-20261116030405-42']]);
});

function lotQuery(lotRows, updateRowCount = 1) {
  return scriptedQuery([
    [/^\s*SELECT[\s\S]*FROM public\.inventory_stock_lot/, () => ({ rows: lotRows })],
    [/UPDATE public\.inventory_stock_lot/, () => ({ rows: [], rowCount: updateRowCount })],
  ]);
}

test('reduceStockLot prices the line from the lot average and decrements the lot', async () => {
  const { query, calls } = lotQuery([{ id: 5, qty_on_hand: 10, avg_unit_price: 12.3456 }]);
  const result = await reduceStockLot(query, 5, 3);
  assert.deepEqual(result, { unitPrice: 12.3456, lineValue: 37.04 });
  assert.deepEqual(calls[1].params, [5, 3, 37.04]);
  assert.match(calls[1].text, /qty_on_hand = qty_on_hand - \$2/);
});

test('reduceStockLot rejects issuing more than the lot holds', async () => {
  const { query, calls } = lotQuery([{ id: 5, qty_on_hand: 2, avg_unit_price: 1 }]);
  await assert.rejects(
    () => reduceStockLot(query, 5, 3),
    (error) => error instanceof InventoryIssueRuleError && error.message === 'ไม่สามารถเบิกเกินคงเหลือของล็อต 5'
  );
  assert.equal(calls.length, 1);
});

test('reduceStockLot rejects a missing lot as a rule violation', async () => {
  const { query } = lotQuery([]);
  await assert.rejects(() => reduceStockLot(query, 5, 1), InventoryIssueRuleError);
});

test('reduceStockLot reports a lost update as an unexpected error', async () => {
  const { query } = lotQuery([{ id: 5, qty_on_hand: 10, avg_unit_price: 1 }], 0);
  await assert.rejects(
    () => reduceStockLot(query, 5, 1),
    (error) => !(error instanceof InventoryIssueRuleError) && error.message === 'ไม่สามารถอัปเดตล็อต 5 ได้'
  );
});

test('restoreStockLot adds quantity and value back to the lot', async () => {
  const { query, calls } = lotQuery([{ id: 5 }]);
  await restoreStockLot(query, 5, 4, 49.38);
  assert.deepEqual(calls[1].params, [5, 4, 49.38]);
  assert.match(calls[1].text, /qty_on_hand = qty_on_hand \+ \$2/);
  assert.match(calls[1].text, /total_value = total_value \+ \$3/);
});

test('restoreStockLot rejects a missing lot without updating', async () => {
  const { query, calls } = lotQuery([]);
  await assert.rejects(() => restoreStockLot(query, 5, 4, 49.38), InventoryIssueRuleError);
  assert.equal(calls.length, 1);
});
