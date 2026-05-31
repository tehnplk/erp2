import { pgPool, pgQuery } from '@/lib/pg';
import { prepareReadOnlySql } from '@/lib/erp-agent-sql';

const MAX_DB_OUTPUT_LENGTH = 30_000;

const serializeRows = (rows: unknown[]) =>
  JSON.stringify(rows, null, 2).slice(0, MAX_DB_OUTPUT_LENGTH);

export const queryErpDatabase = async (inputSql: string) => {
  const sql = prepareReadOnlySql(inputSql);
  const client = await pgPool.connect();

  try {
    await client.query('BEGIN READ ONLY');
    await client.query(`SET LOCAL statement_timeout = '10s'`);
    const result = await client.query(sql);
    await client.query('COMMIT');

    return {
      sql,
      rows: result.rows,
      output: serializeRows(result.rows),
    };
  } catch (error) {
    try {
      await client.query('ROLLBACK');
    } catch {
      // Preserve the original query error if the connection is already closed.
    }
    throw error;
  } finally {
    client.release();
  }
};

export const getAccessibleSchema = async () => {
  const result = await pgQuery<{ table_name: string; columns: string }>(`
    SELECT
      table_name,
      string_agg(column_name || ' ' || data_type, ', ' ORDER BY ordinal_position) AS columns
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name NOT IN ('users', 'user_role')
    GROUP BY table_name
    ORDER BY table_name
  `);

  return result.rows
    .map((row) => `${row.table_name}: ${row.columns}`)
    .join('\n');
};
