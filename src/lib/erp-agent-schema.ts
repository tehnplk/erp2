type AccessibleSchemaColumn = {
  table_name: string;
  column_name: string;
  data_type: string;
};

type AccessibleTableColumn = Omit<AccessibleSchemaColumn, 'table_name'>;

type AccessibleTableRelationship = {
  column_name: string;
  foreign_table_name: string;
  foreign_column_name: string;
};

const restrictedTableNames = new Set(['users', 'user_role']);
const trustedProductNameViewNames = new Set([
  'inventory_stock_lot_detail_summary',
  'inventory_stock_summary',
  'purchase_plan',
]);
const safeTableNamePattern = /^[a-z_][a-z0-9_]*$/i;

const agentSchemaRules = `Schema relationships and authoritative field rules:
- product.name is the single source of truth for product names.
- Trusted SSOT-derived views may expose product_name computed directly from product.name: purchase_plan, inventory_stock_summary, inventory_stock_lot_detail_summary.
- Never read a duplicated product_name field from a base table.
- When a source table has product_code, join product with source.product_code = product.code to read product.name.
- When a source table has product_id, join product with source.product_id = product.id to read product.name.`;

export class AgentSchemaError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'AgentSchemaError';
  }
}

export const prepareAccessibleTableName = (inputTableName: string) => {
  const tableName = inputTableName.trim().toLowerCase();

  if (!safeTableNamePattern.test(tableName)) {
    throw new AgentSchemaError('The schema tool received an invalid table name.');
  }
  if (restrictedTableNames.has(tableName)) {
    throw new AgentSchemaError('The schema tool references a restricted table.');
  }

  return tableName;
};

export const formatAccessibleSchema = (rows: AccessibleSchemaColumn[]) => {
  const tableColumns = new Map<string, string[]>();

  for (const row of rows) {
    if (row.column_name === 'product_name' && !trustedProductNameViewNames.has(row.table_name)) continue;

    const columns = tableColumns.get(row.table_name) ?? [];
    columns.push(`${row.column_name} ${row.data_type}`);
    tableColumns.set(row.table_name, columns);
  }

  const schema = [...tableColumns.entries()]
    .map(([tableName, columns]) => `${tableName}: ${columns.join(', ')}`)
    .join('\n');

  return `${schema}\n\n${agentSchemaRules}`;
};

export const formatAccessibleTableSchema = (
  inputTableName: string,
  rows: AccessibleTableColumn[],
  relationships: AccessibleTableRelationship[]
) => {
  const tableName = prepareAccessibleTableName(inputTableName);
  const columns = rows
    .filter((row) => row.column_name !== 'product_name' || trustedProductNameViewNames.has(tableName))
    .map((row) => `${row.column_name} ${row.data_type}`);
  const relationshipSet = new Set(
    relationships
      .filter((relationship) => !restrictedTableNames.has(relationship.foreign_table_name))
      .map(
        (relationship) =>
          `${tableName}.${relationship.column_name} -> ${relationship.foreign_table_name}.${relationship.foreign_column_name}`
      )
  );

  if (tableName !== 'product' && rows.some((row) => row.column_name === 'product_code')) {
    relationshipSet.add(`${tableName}.product_code -> product.code`);
  }
  if (tableName !== 'product' && rows.some((row) => row.column_name === 'product_id')) {
    relationshipSet.add(`${tableName}.product_id -> product.id`);
  }

  const relationshipLines =
    relationshipSet.size > 0
      ? `\nRelationships:\n${[...relationshipSet].map((relationship) => `- ${relationship}`).join('\n')}`
      : '';

  return `${tableName}: ${columns.join(', ')}${relationshipLines}`;
};

export const getAgentSchemaRules = () => agentSchemaRules;
