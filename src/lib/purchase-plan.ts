import type { PoolClient } from 'pg';

export const normalizePurchasePlanFlag = (value: string | null | undefined) =>
  value === 'นอกแผน' ? 'นอกแผน' : 'ในแผน';

function isMissingSequenceError(error: unknown) {
  return (
    typeof error === 'object' &&
    error !== null &&
    'code' in error &&
    (error as { code?: string }).code === '42P01'
  );
}

export async function allocatePurchasePlanId(client: PoolClient) {
  try {
    const result = await client.query<{ id: number }>(
      `SELECT nextval('public.purchase_plan_id_seq')::int AS id`,
    );

    const purchasePlanId = Number(result.rows[0]?.id ?? 0);
    if (!Number.isInteger(purchasePlanId) || purchasePlanId <= 0) {
      throw new Error('Failed to allocate purchase_plan_id');
    }

    return purchasePlanId;
  } catch (error) {
    if (!isMissingSequenceError(error)) {
      throw error;
    }

    await client.query('LOCK TABLE public.usage_plan IN EXCLUSIVE MODE');
    const fallbackResult = await client.query<{ id: number }>(
      `SELECT COALESCE(MAX(purchase_plan_id), 0) + 1 AS id
       FROM public.usage_plan`,
    );

    const purchasePlanId = Number(fallbackResult.rows[0]?.id ?? 0);
    if (!Number.isInteger(purchasePlanId) || purchasePlanId <= 0) {
      throw new Error('Failed to allocate purchase_plan_id');
    }

    return purchasePlanId;
  }
}
