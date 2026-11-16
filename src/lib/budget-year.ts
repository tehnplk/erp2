export type BudgetYearQuery = (
  text: string,
  params?: unknown[]
) => Promise<{ rows: Array<{ sys_value: string | null }> }>;

const FISCAL_YEAR_START_MONTH = 10;

export function budgetYearOf(date: Date): number {
  const year = date.getFullYear();
  return date.getMonth() + 1 >= FISCAL_YEAR_START_MONTH ? year + 544 : year + 543;
}

export function budgetYearOfDateString(dateValue: string): number {
  const parsedDate = new Date(`${dateValue}T00:00:00`);
  if (Number.isNaN(parsedDate.getTime())) {
    throw new Error(`Invalid date: ${dateValue}`);
  }
  return budgetYearOf(parsedDate);
}

export function currentBudgetYear(now: Date = new Date()): number {
  return budgetYearOf(now);
}

export function budgetYearSql(dateExpression: string): string {
  return `(CASE
    WHEN EXTRACT(MONTH FROM ${dateExpression}) >= ${FISCAL_YEAR_START_MONTH}
      THEN EXTRACT(YEAR FROM ${dateExpression})::int + 544
    ELSE EXTRACT(YEAR FROM ${dateExpression})::int + 543
  END)`;
}

export async function getConfiguredBudgetYear(query: BudgetYearQuery, now: Date = new Date()): Promise<number> {
  const result = await query(
    `SELECT NULLIF(TRIM(sys_value), '') AS sys_value
     FROM public.sys_setting
     WHERE sys_name = 'budget_year'
     LIMIT 1`
  );
  const configured = Number(result.rows[0]?.sys_value ?? '');
  return Number.isFinite(configured) && configured > 0 ? configured : budgetYearOf(now);
}
