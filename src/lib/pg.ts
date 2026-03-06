import { Pool, type QueryResultRow } from 'pg';

const globalForPg = globalThis as unknown as { pgPool?: Pool };

export const pgPool =
  globalForPg.pgPool ||
  new Pool({
    connectionString: process.env.DATABASE_URL,
  });

if (process.env.NODE_ENV !== 'production') {
  globalForPg.pgPool = pgPool;
}

export async function pgQuery<T extends QueryResultRow = QueryResultRow>(text: string, params: unknown[] = []) {
  return pgPool.query<T>(text, params);
}
