import type { PurchasePlanQuery } from './purchase-plan';

export const USAGE_PLAN_LIMIT_MESSAGE = 'ในปีงบประมาณนี้ แผนกนี้ ขอใช้สินค้านี้ ครบ 2 ครั้งแล้ว';

const SEQUENCE_SLOTS = [1, 2];

export type UsagePlanKey = {
  budgetYear: number;
  requestingDeptCode: string | null;
  productCode: string | null;
};

// Call inside an open transaction: the advisory lock serialises claims on one key until COMMIT/ROLLBACK.
export async function claimUsagePlanSequence(
  query: PurchasePlanQuery,
  key: UsagePlanKey,
  requestedSequenceNo: number | null,
  excludeUsagePlanId: number | null = null
): Promise<number | null> {
  await query('SELECT pg_advisory_xact_lock(hashtext($1))', [
    JSON.stringify(['usage_plan', key.budgetYear, key.requestingDeptCode, key.productCode]),
  ]);

  const { rows } = await query(
    `SELECT sequence_no
     FROM public.usage_plan
     WHERE budget_year = $1
       AND requesting_dept_code IS NOT DISTINCT FROM $2
       AND product_code IS NOT DISTINCT FROM $3
       AND id IS DISTINCT FROM $4`,
    [key.budgetYear, key.requestingDeptCode, key.productCode, excludeUsagePlanId]
  );

  if (rows.length >= SEQUENCE_SLOTS.length) return null;

  const taken = new Set(rows.map((row) => Number(row.sequence_no)));
  if (requestedSequenceNo !== null) {
    return taken.has(requestedSequenceNo) ? null : requestedSequenceNo;
  }
  return SEQUENCE_SLOTS.find((slot) => !taken.has(slot)) ?? null;
}
