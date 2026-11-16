import test from 'node:test';
import assert from 'node:assert/strict';

import { runListQuery } from '../src/lib/list-query.ts';

function recorder(rowsResult = [{ id: 1 }, { id: 2 }], count = 42) {
  const calls = [];
  const query = async (text, params) => {
    calls.push({ text, params });
    return text.startsWith('SELECT COUNT') ? { rows: [{ count }] } : { rows: rowsResult };
  };
  return { calls, query };
}

function memoryCache() {
  const store = new Map();
  return {
    store,
    get: async (key) => store.get(key) ?? null,
    set: async (key, data) => {
      store.set(key, data);
    },
  };
}

const baseSpec = {
  columns: 'id, name',
  from: 'public.seller',
  where: ['is_active = true', 'name ILIKE $1'],
  params: ['%a%'],
  orderBy: 'id ASC',
};

test('unpaged list runs one rows query and counts the rows', async () => {
  const { calls, query } = recorder();
  const result = await runListQuery(baseSpec, query);

  assert.deepEqual(calls, [
    {
      text: 'SELECT id, name FROM public.seller WHERE is_active = true AND name ILIKE $1 ORDER BY id ASC',
      params: ['%a%'],
    },
  ]);
  assert.deepEqual(result, { rows: [{ id: 1 }, { id: 2 }], totalCount: 2, meta: undefined });
});

test('paged list adds LIMIT/OFFSET after the filter params and counts with the filter only', async () => {
  const { calls, query } = recorder();
  const result = await runListQuery({ ...baseSpec, page: 3, pageSize: 10 }, query);

  assert.deepEqual(calls, [
    {
      text: 'SELECT COUNT(*)::int AS count FROM public.seller WHERE is_active = true AND name ILIKE $1',
      params: ['%a%'],
    },
    {
      text: 'SELECT id, name FROM public.seller WHERE is_active = true AND name ILIKE $1 ORDER BY id ASC LIMIT $2 OFFSET $3',
      params: ['%a%', 10, 20],
    },
  ]);
  assert.deepEqual(result, { rows: [{ id: 1 }, { id: 2 }], totalCount: 42, meta: { page: 3, page_size: 10 } });
});

test('page without page_size stays unpaged', async () => {
  const { calls, query } = recorder();
  const result = await runListQuery({ ...baseSpec, page: 2 }, query);

  assert.equal(calls.length, 1);
  assert.doesNotMatch(calls[0].text, /LIMIT/);
  assert.equal(result.meta, undefined);
});

test('no filters produce no WHERE clause', async () => {
  const { calls, query } = recorder();
  await runListQuery({ ...baseSpec, where: [], params: [] }, query);

  assert.doesNotMatch(calls[0].text, /WHERE/);
  assert.deepEqual(calls[0].params, []);
});

test('sort uses a whitelisted key and falls back on unknown or missing keys', async () => {
  const sortSpec = (key) => ({
    ...baseSpec,
    orderBy: { key, allowed: ['id', 'name'], fallback: 'id', direction: 'DESC' },
  });
  const orderOf = async (key) => {
    const { calls, query } = recorder();
    await runListQuery(sortSpec(key), query);
    return calls[0].text.split('ORDER BY ')[1];
  };

  assert.equal(await orderOf('name'), 'name DESC');
  assert.equal(await orderOf('name; DROP TABLE seller'), 'id DESC');
  assert.equal(await orderOf(undefined), 'id DESC');
});

test('cache hit skips the database and keeps the paging meta', async () => {
  const cache = memoryCache();
  const spec = { ...baseSpec, page: 1, pageSize: 5, cache: { namespace: 'erp:sellers:list', ttlSeconds: 3600, ...cache } };

  const first = recorder();
  await runListQuery(spec, first.query);
  assert.equal(first.calls.length, 2);

  const second = recorder([{ id: 99 }], 0);
  const result = await runListQuery(spec, second.query);

  assert.equal(second.calls.length, 0);
  assert.deepEqual(result, { rows: [{ id: 1 }, { id: 2 }], totalCount: 42, meta: { page: 1, page_size: 5 } });
});

test('cache keys live under the namespace so pattern invalidation matches them', async () => {
  const cache = memoryCache();
  const { query } = recorder();
  await runListQuery({ ...baseSpec, cache: { namespace: 'erp:sellers:list', ttlSeconds: 3600, ...cache } }, query);

  const [key] = cache.store.keys();
  assert.match(key, /^erp:sellers:list:[^:]+$/);
});

test('cache key changes when any input that affects the result changes', async () => {
  const keyFor = async (spec) => {
    const cache = memoryCache();
    const { query } = recorder();
    await runListQuery({ ...spec, cache: { namespace: 'erp:x:list', ttlSeconds: 60, ...cache } }, query);
    return [...cache.store.keys()][0];
  };

  const base = await keyFor(baseSpec);
  const variants = {
    includeInactive: { ...baseSpec, where: ['name ILIKE $1'] },
    params: { ...baseSpec, params: ['%b%'] },
    columns: { ...baseSpec, columns: 'id' },
    from: { ...baseSpec, from: 'public.department' },
    orderBy: { ...baseSpec, orderBy: 'name ASC' },
    sortDirection: { ...baseSpec, orderBy: { key: 'id', allowed: ['id'], fallback: 'id', direction: 'DESC' } },
    paged: { ...baseSpec, page: 1, pageSize: 10 },
  };
  const keys = { base };
  for (const [name, spec] of Object.entries(variants)) {
    keys[name] = await keyFor(spec);
  }
  keys.nextPage = await keyFor({ ...baseSpec, page: 2, pageSize: 10 });
  keys.otherPageSize = await keyFor({ ...baseSpec, page: 1, pageSize: 20 });

  assert.equal(new Set(Object.values(keys)).size, Object.keys(keys).length, JSON.stringify(keys, null, 2));
});

test('include_inactive regression: dropping the is_active filter with identical params gets its own cache entry', async () => {
  const cache = memoryCache();
  const cacheConfig = { namespace: 'erp:sellers:list', ttlSeconds: 3600, ...cache };

  const activeOnly = recorder([{ id: 1, is_active: true }]);
  await runListQuery({ ...baseSpec, where: ['is_active = true'], params: [], cache: cacheConfig }, activeOnly.query);

  const all = recorder([{ id: 1, is_active: true }, { id: 2, is_active: false }]);
  const result = await runListQuery({ ...baseSpec, where: [], params: [], cache: cacheConfig }, all.query);

  assert.equal(all.calls.length, 1);
  assert.equal(result.totalCount, 2);
  assert.equal(cache.store.size, 2);
});

test('without cache config nothing is cached', async () => {
  const { calls, query } = recorder();
  await runListQuery(baseSpec, query);
  await runListQuery(baseSpec, query);

  assert.equal(calls.length, 2);
});
