import { pgPool, pgQuery } from '@/lib/pg';
import {
  AgentSchemaError,
  formatAccessibleTableSchema,
  getAgentSchemaRules,
  prepareAccessibleTableName,
} from '@/lib/erp-agent-schema';
import { prepareProbeSql, prepareReadOnlySql } from '@/lib/erp-agent-sql';

const MAX_DB_OUTPUT_LENGTH = 30_000;

const serializeRows = (rows: unknown[]) =>
  JSON.stringify(rows, null, 2).slice(0, MAX_DB_OUTPUT_LENGTH);

export const queryErpDatabase = async (inputSql: string, phase: 'probe' | 'answer' = 'answer') => {
  const sql = phase === 'probe' ? prepareProbeSql(inputSql) : prepareReadOnlySql(inputSql);
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
  const result = await pgQuery<{ table_name: string }>(`
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = 'public'
      AND table_name NOT IN ('users', 'user_role')
      AND table_type IN ('BASE TABLE', 'VIEW')
    ORDER BY table_name
  `);

  return `Accessible public tables:
${result.rows.map((row) => row.table_name).join(', ')}

${getAgentSchemaRules()}`;
};

export const inspectErpTable = async (inputTableName: string) => {
  const tableName = prepareAccessibleTableName(inputTableName);
  const [columnResult, relationshipResult] = await Promise.all([
    pgQuery<{ column_name: string; data_type: string }>(
      `
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'public'
          AND table_name = $1
        ORDER BY ordinal_position
      `,
      [tableName]
    ),
    pgQuery<{ column_name: string; foreign_table_name: string; foreign_column_name: string }>(
      `
        SELECT
          kcu.column_name,
          ccu.table_name AS foreign_table_name,
          ccu.column_name AS foreign_column_name
        FROM information_schema.table_constraints tc
        JOIN information_schema.key_column_usage kcu
          ON tc.constraint_name = kcu.constraint_name
          AND tc.table_schema = kcu.table_schema
        JOIN information_schema.constraint_column_usage ccu
          ON ccu.constraint_name = tc.constraint_name
          AND ccu.table_schema = tc.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY'
          AND tc.table_schema = 'public'
          AND tc.table_name = $1
        ORDER BY kcu.column_name
      `,
      [tableName]
    ),
  ]);

  if (columnResult.rows.length === 0) {
    throw new AgentSchemaError('The requested table is not accessible.');
  }

  return formatAccessibleTableSchema(tableName, columnResult.rows, relationshipResult.rows);
};
