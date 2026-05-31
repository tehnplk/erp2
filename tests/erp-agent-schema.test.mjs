import test from 'node:test';
import assert from 'node:assert/strict';

import {
  formatAccessibleSchema,
  formatAccessibleTableSchema,
  prepareAccessibleTableName,
} from '../src/lib/erp-agent-schema.ts';

test('formatAccessibleSchema exposes product_name only for trusted master-derived views', () => {
  const schema = formatAccessibleSchema([
    { table_name: 'product', column_name: 'id', data_type: 'integer' },
    { table_name: 'product', column_name: 'code', data_type: 'text' },
    { table_name: 'product', column_name: 'name', data_type: 'text' },
    { table_name: 'purchase_plan', column_name: 'product_code', data_type: 'text' },
    { table_name: 'purchase_plan', column_name: 'product_name', data_type: 'text' },
    { table_name: 'inventory_stock_summary', column_name: 'product_id', data_type: 'integer' },
    { table_name: 'inventory_stock_summary', column_name: 'product_name', data_type: 'text' },
    { table_name: 'purchase_approval_detail', column_name: 'product_name', data_type: 'text' },
  ]);

  assert.match(schema, /product: id integer, code text, name text/);
  assert.match(schema, /purchase_plan: product_code text, product_name text/);
  assert.match(schema, /inventory_stock_summary: product_id integer, product_name text/);
  assert.doesNotMatch(schema, /purchase_approval_detail:.*product_name/);
  assert.match(schema, /Trusted SSOT-derived views/);
  assert.match(schema, /source\.product_code = product\.code/);
  assert.match(schema, /source\.product_id = product\.id/);
});

test('prepareAccessibleTableName allows safe public tables and blocks restricted tables', () => {
  assert.equal(prepareAccessibleTableName('purchase_plan'), 'purchase_plan');
  assert.throws(() => prepareAccessibleTableName('users'), /restricted table/);
  assert.throws(() => prepareAccessibleTableName('user_role'), /restricted table/);
  assert.throws(() => prepareAccessibleTableName('auth.users'), /invalid table name/);
});

test('formatAccessibleTableSchema exposes product names from trusted views and includes safe relationships', () => {
  const schema = formatAccessibleTableSchema(
    'purchase_plan',
    [
      { column_name: 'id', data_type: 'integer' },
      { column_name: 'product_code', data_type: 'text' },
      { column_name: 'product_name', data_type: 'text' },
    ],
    [
      {
        column_name: 'product_code',
        foreign_table_name: 'product',
        foreign_column_name: 'code',
      },
      {
        column_name: 'user_id',
        foreign_table_name: 'users',
        foreign_column_name: 'id',
      },
    ]
  );

  assert.match(schema, /purchase_plan: id integer, product_code text, product_name text/);
  assert.match(schema, /purchase_plan\.product_code -> product\.code/);
  assert.doesNotMatch(schema, /users/);
});

test('formatAccessibleTableSchema hides duplicated product names from base tables', () => {
  const schema = formatAccessibleTableSchema(
    'purchase_approval_detail',
    [
      { column_name: 'id', data_type: 'integer' },
      { column_name: 'product_code', data_type: 'text' },
      { column_name: 'product_name', data_type: 'text' },
    ],
    []
  );

  assert.match(schema, /purchase_approval_detail: id integer, product_code text/);
  assert.doesNotMatch(schema, /product_name/);
});
