import test from 'node:test';
import assert from 'node:assert/strict';

import { prepareReadOnlySql } from '../src/lib/erp-agent-sql.ts';

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
