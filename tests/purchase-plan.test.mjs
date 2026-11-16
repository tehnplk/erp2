import test from 'node:test';
import assert from 'node:assert/strict';

import {
  normalizePurchasePlanFlag,
  purchasePlanFlagSql,
  usagePlanHasPurchaseApproval,
  usagePlanHasPurchaseApprovalSql,
  usagePlanQuotaSql,
} from '../src/lib/purchase-plan.ts';

test('normalizePurchasePlanFlag treats everything except นอกแผน as ในแผน', () => {
  assert.equal(normalizePurchasePlanFlag('นอกแผน'), 'นอกแผน');
  assert.equal(normalizePurchasePlanFlag('ในแผน'), 'ในแผน');
  assert.equal(normalizePurchasePlanFlag(null), 'ในแผน');
  assert.equal(normalizePurchasePlanFlag(undefined), 'ในแผน');
  assert.equal(normalizePurchasePlanFlag(''), 'ในแผน');
});

test('purchasePlanFlagSql maps NULL to ในแผน like the purchase_plan view', () => {
  assert.equal(
    purchasePlanFlagSql('up.plan_flag'),
    "(CASE WHEN COALESCE(up.plan_flag, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END)"
  );
});

test('usage plan quota falls back to the requested amount like the purchase_plan view', () => {
  assert.equal(
    usagePlanQuotaSql('up'),
    'GREATEST(COALESCE(up.approved_quota, up.requested_amount, 0), 0)'
  );
});

test('approval reference matches on product, approval budget year and normalised flag only', () => {
  const sql = usagePlanHasPurchaseApprovalSql('up');

  assert.match(sql, /pad\.product_code = up\.product_code/);
  assert.match(sql, /pa\.budget_year = up\.budget_year/);
  assert.ok(sql.includes(`${purchasePlanFlagSql('pad.usage_plan_flag')} = ${purchasePlanFlagSql('up.plan_flag')}`));
  assert.equal(sql.includes('purchase_plan_id'), false);
  assert.equal(sql.includes('purchase_department_id'), false);
});

test('usagePlanHasPurchaseApproval queries one usage plan by id and returns a boolean', async () => {
  const calls = [];
  const query = (answer) => async (text, params) => {
    calls.push({ text, params });
    return { rows: [{ has_purchase_approval: answer }] };
  };

  assert.equal(await usagePlanHasPurchaseApproval(query(true), 42), true);
  assert.equal(await usagePlanHasPurchaseApproval(query(false), 42), false);
  assert.equal(await usagePlanHasPurchaseApproval(async () => ({ rows: [] }), 404), false);
  assert.deepEqual(calls[0].params, [42]);
  assert.ok(calls[0].text.includes(usagePlanHasPurchaseApprovalSql('up')));
  assert.match(calls[0].text, /WHERE up\.id = \$1/);
});
