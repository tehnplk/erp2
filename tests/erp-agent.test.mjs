import test from 'node:test';
import assert from 'node:assert/strict';

import { prepareProbeSql, prepareReadOnlySql } from '../src/lib/erp-agent-sql.ts';

test('prepareReadOnlySql appends a result limit', () => {
  assert.equal(
    prepareReadOnlySql('SELECT id, name FROM public.department ORDER BY id'),
    'SELECT id, name FROM public.department ORDER BY id LIMIT 100'
  );
});

test('prepareReadOnlySql preserves a smaller result limit', () => {
  assert.equal(
    prepareReadOnlySql('SELECT id FROM public.department LIMIT 5;'),
    'SELECT id FROM public.department LIMIT 5'
  );
});

test('prepareReadOnlySql caps a larger result limit', () => {
  assert.equal(
    prepareReadOnlySql('SELECT id FROM public.department LIMIT 500'),
    'SELECT id FROM public.department LIMIT 100'
  );
});

test('prepareReadOnlySql allows a read-only CTE', () => {
  assert.equal(
    prepareReadOnlySql('WITH active AS (SELECT id FROM public.department WHERE is_active = true) SELECT id FROM active'),
    'WITH active AS (SELECT id FROM public.department WHERE is_active = true) SELECT id FROM active LIMIT 100'
  );
});

test('prepareReadOnlySql blocks mutations', () => {
  assert.throws(
    () => prepareReadOnlySql('UPDATE public.department SET name = \'x\' WHERE id = 1'),
    /Only read-only SELECT queries are allowed/
  );
  assert.throws(
    () => prepareReadOnlySql('SELECT id INTO copied_department FROM public.department'),
    /Only read-only SELECT queries are allowed/
  );
});

test('prepareReadOnlySql blocks multiple statements and comments', () => {
  assert.throws(
    () => prepareReadOnlySql('SELECT id FROM public.department; SELECT id FROM public.category'),
    /Multiple SQL statements are not allowed/
  );
  assert.throws(
    () => prepareReadOnlySql('SELECT id FROM public.department -- bypass'),
    /SQL comments are not allowed/
  );
});

test('prepareReadOnlySql blocks user and role tables', () => {
  assert.throws(
    () => prepareReadOnlySql('SELECT provider_id FROM public.users'),
    /restricted table/
  );
  assert.throws(
    () => prepareReadOnlySql('SELECT role FROM public.user_role'),
    /restricted table/
  );
});

test('prepareReadOnlySql blocks auth and system schemas', () => {
  assert.throws(
    () => prepareReadOnlySql('SELECT email FROM auth.users'),
    /restricted schema/
  );
  assert.throws(
    () => prepareReadOnlySql('SELECT provider FROM "auth"."identities"'),
    /restricted schema/
  );
  assert.throws(
    () => prepareReadOnlySql('SELECT table_name FROM information_schema.tables'),
    /restricted schema/
  );
  assert.throws(
    () => prepareReadOnlySql('SELECT usename, passwd FROM pg_shadow'),
    /restricted schema/
  );
});

test('prepareReadOnlySql allows product_name from trusted master-derived views', () => {
  assert.equal(
    prepareReadOnlySql('SELECT product_name FROM public.purchase_plan'),
    'SELECT product_name FROM public.purchase_plan LIMIT 100'
  );
  assert.equal(
    prepareReadOnlySql('SELECT pp.product_name FROM public.purchase_plan pp'),
    'SELECT pp.product_name FROM public.purchase_plan pp LIMIT 100'
  );
  assert.equal(
    prepareReadOnlySql('SELECT product_name FROM public.inventory_stock_summary'),
    'SELECT product_name FROM public.inventory_stock_summary LIMIT 100'
  );
});

test('prepareReadOnlySql blocks duplicated product_name fields from base tables', () => {
  assert.throws(
    () => prepareReadOnlySql('SELECT pad.product_name FROM public.purchase_approval_detail pad'),
    /product\.name/
  );
  assert.throws(
    () => prepareReadOnlySql('SELECT product_name FROM public.purchase_approval_detail'),
    /product\.name/
  );
  assert.equal(
    prepareReadOnlySql('SELECT p.name AS product_name FROM public.product p'),
    'SELECT p.name AS product_name FROM public.product p LIMIT 100'
  );
});

test('prepareProbeSql keeps research queries small', () => {
  assert.equal(
    prepareProbeSql('SELECT id, code FROM public.product'),
    'SELECT id, code FROM public.product LIMIT 5'
  );
  assert.equal(
    prepareProbeSql('SELECT id, code FROM public.product LIMIT 40'),
    'SELECT id, code FROM public.product LIMIT 5'
  );
});
