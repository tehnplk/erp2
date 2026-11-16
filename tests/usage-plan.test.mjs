import test from 'node:test';
import assert from 'node:assert/strict';

import { claimUsagePlanSequence } from '../src/lib/usage-plan.ts';

const key = { budgetYear: 2569, requestingDeptCode: '0001', productCode: 'P-1' };

const fakeUsagePlanTable = (rows = []) => {
  const calls = [];
  const query = async (text, params) => {
    calls.push({ text, params });
    if (text.includes('pg_advisory_xact_lock')) return { rows: [{}] };
    const [budgetYear, deptCode, productCode, excludeId] = params;
    return {
      rows: rows.filter(
        (row) =>
          row.budget_year === budgetYear &&
          row.requesting_dept_code === deptCode &&
          row.product_code === productCode &&
          row.id !== excludeId
      ),
    };
  };
  const insert = (sequenceNo) =>
    rows.push({ id: rows.length + 1, budget_year: 2569, requesting_dept_code: '0001', product_code: 'P-1', sequence_no: sequenceNo });
  return { calls, query, insert, rows };
};

test('allows the first and second request for a key and rejects the third', async () => {
  const table = fakeUsagePlanTable();

  const first = await claimUsagePlanSequence(table.query, key, null);
  assert.equal(first, 1);
  table.insert(first);

  const second = await claimUsagePlanSequence(table.query, key, null);
  assert.equal(second, 2);
  table.insert(second);

  assert.equal(await claimUsagePlanSequence(table.query, key, null), null);
});

test('takes the advisory lock on the key before reading the existing rows', async () => {
  const table = fakeUsagePlanTable();
  await claimUsagePlanSequence(table.query, key, null);

  assert.match(table.calls[0].text, /pg_advisory_xact_lock\(hashtext\(\$1\)\)/);
  assert.deepEqual(table.calls[0].params, [JSON.stringify(['usage_plan', 2569, '0001', 'P-1'])]);
  assert.deepEqual(table.calls[1].params, [2569, '0001', 'P-1', null]);
});

test('rejects a requested sequence already taken and fills the free slot otherwise', async () => {
  const table = fakeUsagePlanTable();
  table.insert(2);

  assert.equal(await claimUsagePlanSequence(table.query, key, 2), null);
  assert.equal(await claimUsagePlanSequence(table.query, key, 1), 1);
  assert.equal(await claimUsagePlanSequence(table.query, key, null), 1);
});

test('ignores the row being edited so it can keep its own sequence', async () => {
  const table = fakeUsagePlanTable();
  table.insert(1);
  table.insert(2);

  assert.equal(await claimUsagePlanSequence(table.query, key, 1), null);
  assert.equal(await claimUsagePlanSequence(table.query, key, 1, 1), 1);
  assert.equal(await claimUsagePlanSequence(table.query, key, 2, 1), null);
});
