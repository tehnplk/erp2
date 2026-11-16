import { createHash } from 'node:crypto';

export type ListSort = {
  key: string | undefined;
  allowed: readonly string[];
  fallback: string;
  direction: 'ASC' | 'DESC';
};

export type ListSpec = {
  columns: string;
  from: string;
  where: string[];
  params: unknown[];
  orderBy: string | ListSort;
  page?: number;
  pageSize?: number;
  cache?: {
    namespace: string;
    ttlSeconds: number;
    get: <T>(key: string) => Promise<T | null>;
    set: (key: string, data: unknown, ttlSeconds: number) => Promise<void>;
  };
};

export type ListQueryFn = (text: string, params?: unknown[]) => Promise<{ rows: any[] }>;

export type ListResult = {
  rows: any[];
  totalCount: number;
  meta?: { page: number; page_size: number };
};

function orderBySql(orderBy: string | ListSort) {
  if (typeof orderBy === 'string') return orderBy;
  const column = orderBy.key && orderBy.allowed.includes(orderBy.key) ? orderBy.key : orderBy.fallback;
  return `${column} ${orderBy.direction}`;
}

export async function runListQuery(spec: ListSpec, query: ListQueryFn): Promise<ListResult> {
  const whereSql = spec.where.length ? `WHERE ${spec.where.join(' AND ')}` : '';
  const meta = spec.page && spec.pageSize ? { page: spec.page, page_size: spec.pageSize } : undefined;
  const limitSql = meta ? ` LIMIT $${spec.params.length + 1} OFFSET $${spec.params.length + 2}` : '';
  const rowsSql = `SELECT ${spec.columns} FROM ${spec.from} ${whereSql} ORDER BY ${orderBySql(spec.orderBy)}${limitSql}`;
  const rowsParams = meta ? [...spec.params, meta.page_size, (meta.page - 1) * meta.page_size] : spec.params;

  // The key hashes the final SQL and params, so every input that changes the result changes the key.
  const cache = spec.cache;
  const cacheKey = cache
    ? `${cache.namespace}:${createHash('sha1').update(JSON.stringify([rowsSql, rowsParams])).digest('hex')}`
    : '';
  if (cache) {
    const cached = await cache.get<{ rows: any[]; totalCount: number }>(cacheKey);
    if (cached) return { ...cached, meta };
  }

  let rows: any[];
  let totalCount: number;
  if (meta) {
    const [countResult, rowsResult] = await Promise.all([
      query(`SELECT COUNT(*)::int AS count FROM ${spec.from} ${whereSql}`, spec.params),
      query(rowsSql, rowsParams),
    ]);
    rows = rowsResult.rows;
    totalCount = countResult.rows[0]?.count ?? 0;
  } else {
    rows = (await query(rowsSql, rowsParams)).rows;
    totalCount = rows.length;
  }

  if (cache) {
    await cache.set(cacheKey, { rows, totalCount }, cache.ttlSeconds);
  }
  return { rows, totalCount, meta };
}
