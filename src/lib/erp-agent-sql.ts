const MAX_ROWS = 100;

const restrictedTablePattern = /\b(?:users|user_role)\b/i;
const restrictedSchemaPattern =
  /\b(?:auth|extensions|graphql|graphql_public|information_schema|pg_catalog|realtime|storage|supabase_functions|vault)\s*\./i;
const restrictedCatalogPattern = /\bpg_[a-z0-9_]+\b/i;
const forbiddenKeywordPattern =
  /\b(?:alter|analyze|attach|begin|call|checkpoint|comment|commit|copy|create|delete|detach|do|drop|execute|grant|insert|into|listen|lock|merge|notify|prepare|reassign|refresh|reindex|release|reset|revoke|rollback|savepoint|set|show|truncate|unlisten|update|vacuum)\b/i;
const forbiddenFunctionPattern =
  /\b(?:current_setting|dblink|lo_export|lo_import|pg_advisory|pg_backend|pg_cancel|pg_file|pg_ls|pg_read|pg_reload|pg_rotate|pg_sleep|pg_stat_file|pg_terminate|pg_write|set_config)\s*\(/i;

export class AgentSqlError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'AgentSqlError';
  }
}

const stripTrailingSemicolon = (sql: string) => sql.trim().replace(/;\s*$/, '').trim();

export const prepareReadOnlySql = (inputSql: string) => {
  const sql = stripTrailingSemicolon(inputSql);
  const normalizedSql = sql.replace(/"/g, '');

  if (!sql) throw new AgentSqlError('SQL query is empty.');
  if (/--|\/\*|\*\//.test(sql)) throw new AgentSqlError('SQL comments are not allowed.');
  if (sql.includes(';')) throw new AgentSqlError('Multiple SQL statements are not allowed.');
  if (!/^(?:select|with)\b/i.test(sql) || !/\bselect\b/i.test(sql)) {
    throw new AgentSqlError('Only read-only SELECT queries are allowed.');
  }
  if (forbiddenKeywordPattern.test(normalizedSql)) {
    throw new AgentSqlError('Only read-only SELECT queries are allowed.');
  }
  if (restrictedSchemaPattern.test(normalizedSql) || restrictedCatalogPattern.test(normalizedSql)) {
    throw new AgentSqlError('The query references a restricted schema.');
  }
  if (restrictedTablePattern.test(normalizedSql)) {
    throw new AgentSqlError('The query references a restricted table.');
  }
  if (forbiddenFunctionPattern.test(normalizedSql)) {
    throw new AgentSqlError('The query calls a restricted database function.');
  }

  const limitMatch = sql.match(/\blimit\s+(\d+)\b/i);
  if (!limitMatch) return `${sql} LIMIT ${MAX_ROWS}`;

  const currentLimit = Number(limitMatch[1]);
  if (currentLimit <= MAX_ROWS) return sql;

  return sql.replace(/\blimit\s+\d+\b/i, `LIMIT ${MAX_ROWS}`);
};
