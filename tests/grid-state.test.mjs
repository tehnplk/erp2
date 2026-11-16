import test from 'node:test';
import assert from 'node:assert/strict';

import { readGridParams, writeGridParams } from '../src/hooks/use-grid-state.ts';

const pages = {
  'purchase-plans': {
    defaults: { sortBy: 'id', sortOrder: 'desc', pageSizes: [20, 50, 100] },
    read: (sp) => {
      const pageSizeRaw = parseInt(sp.get('page_size') || '20', 10) || 20;
      return {
        sortBy: sp.get('order_by') || 'id',
        sortOrder: sp.get('sort_order') === 'asc' ? 'asc' : 'desc',
        page: Math.max(1, parseInt(sp.get('page') || '1', 10) || 1),
        pageSize: [20, 50, 100].includes(pageSizeRaw) ? pageSizeRaw : 20,
      };
    },
    write: (params, { sortBy, sortOrder, page, pageSize }) => {
      if (sortBy && sortBy !== 'id') params.set('order_by', sortBy);
      if (sortOrder !== 'desc') params.set('sort_order', sortOrder);
      if (page > 1) params.set('page', page.toString());
      if (pageSize !== 20) params.set('page_size', pageSize.toString());
    },
  },
  'purchase-approvals': {
    defaults: { sortBy: 'created_at', sortOrder: 'desc' },
    read: (sp) => ({
      sortBy: sp.get('order_by') || 'created_at',
      sortOrder: sp.get('sort_order') === 'asc' ? 'asc' : 'desc',
      page: Math.max(1, parseInt(sp.get('page') || '1', 10) || 1),
      pageSize: Math.max(1, parseInt(sp.get('page_size') || '20', 10) || 20),
    }),
    write: (params, { sortBy, sortOrder, page, pageSize }) => {
      if (sortBy && sortBy !== 'created_at') params.set('order_by', sortBy);
      else params.delete('order_by');
      if (sortOrder !== 'desc') params.set('sort_order', sortOrder);
      else params.delete('sort_order');
      if (page > 1) params.set('page', page.toString());
      if (pageSize !== 20) params.set('page_size', pageSize.toString());
    },
  },
  'settings/products': {
    defaults: { sortBy: 'code', sortOrder: 'asc' },
    read: (sp) => ({
      sortBy: sp.get('order_by') || 'code',
      sortOrder: sp.get('sort_order') === 'desc' ? 'desc' : 'asc',
      page: Math.max(1, parseInt(sp.get('page') || '1', 10) || 1),
      pageSize: Math.max(1, parseInt(sp.get('page_size') || '20', 10) || 20),
    }),
    write: (params, { sortBy, sortOrder, page, pageSize }) => {
      if (sortBy !== 'code') params.set('order_by', sortBy);
      if (sortOrder !== 'asc') params.set('sort_order', sortOrder);
      if (page > 1) params.set('page', page.toString());
      if (pageSize !== 20) params.set('page_size', pageSize.toString());
    },
  },
};

const queries = [
  '',
  'order_by=name',
  'order_by=',
  'sort_order=asc',
  'sort_order=desc',
  'sort_order=ASC',
  'sort_order=bogus',
  'page=3',
  'page=0',
  'page=-4',
  'page=2.7',
  'page=abc',
  'page=5x',
  'page_size=50',
  'page_size=100',
  'page_size=10',
  'page_size=0',
  'page_size=-3',
  'page_size=33',
  'page_size=50abc',
  'page_size=nope',
  'order_by=code&sort_order=asc&page=2&page_size=100',
  'order_by=id&sort_order=desc&page=1&page_size=20',
];

for (const [name, { defaults, read, write }] of Object.entries(pages)) {
  test(`${name}: reading grid params matches the original inline parse`, () => {
    for (const query of queries) {
      const sp = new URLSearchParams(query);
      assert.deepEqual(readGridParams(sp, defaults), read(sp), query);
    }
  });

  test(`${name}: writing grid params matches the original inline writer`, () => {
    for (const query of queries) {
      const grid = read(new URLSearchParams(query));
      const expected = new URLSearchParams('product_name=x');
      write(expected, grid);
      const actual = new URLSearchParams('product_name=x');
      writeGridParams(actual, grid, defaults);
      assert.equal(actual.toString(), expected.toString(), query);
    }
  });
}
