import test from 'node:test';
import assert from 'node:assert/strict';

import {
  budgetYearOf,
  budgetYearOfDateString,
  budgetYearSql,
  getConfiguredBudgetYear,
} from '../src/lib/budget-year.ts';

test('budget year rolls over on 1 October', () => {
  assert.equal(budgetYearOf(new Date(2026, 8, 30)), 2569);
  assert.equal(budgetYearOf(new Date(2026, 9, 1)), 2570);
  assert.equal(budgetYearOf(new Date(2026, 0, 1)), 2569);
  assert.equal(budgetYearOf(new Date(2025, 11, 31)), 2569);
});

test('budget year of a date string matches the date rule and rejects bad input', () => {
  assert.equal(budgetYearOfDateString('2026-09-30'), 2569);
  assert.equal(budgetYearOfDateString('2026-10-01'), 2570);
  assert.throws(() => budgetYearOfDateString('not-a-date'), /Invalid date/);
});

test('SQL expression uses the same October boundary', () => {
  const sql = budgetYearSql('ii.issue_date');
  assert.match(sql, /EXTRACT\(MONTH FROM ii\.issue_date\) >= 10/);
  assert.match(sql, /\+ 544/);
  assert.match(sql, /\+ 543/);
});

test('configured budget year wins over the calendar', async () => {
  const query = async () => ({ rows: [{ sys_value: '2571' }] });
  assert.equal(await getConfiguredBudgetYear(query, new Date(2026, 0, 1)), 2571);
});

test('configured budget year falls back to the calendar when unset or invalid', async () => {
  const now = new Date(2026, 9, 1);
  assert.equal(await getConfiguredBudgetYear(async () => ({ rows: [] }), now), 2570);
  assert.equal(await getConfiguredBudgetYear(async () => ({ rows: [{ sys_value: null }] }), now), 2570);
  assert.equal(await getConfiguredBudgetYear(async () => ({ rows: [{ sys_value: 'abc' }] }), now), 2570);
});
