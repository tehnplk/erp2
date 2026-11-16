export type PurchasePlanFlag = 'ในแผน' | 'นอกแผน';

export type PurchasePlanQuery = (
  text: string,
  params?: unknown[]
) => Promise<{ rows: any[]; rowCount?: number | null }>;

export const normalizePurchasePlanFlag = (value: string | null | undefined): PurchasePlanFlag =>
  value === 'นอกแผน' ? 'นอกแผน' : 'ในแผน';

export const purchasePlanFlagSql = (column: string) =>
  `(CASE WHEN COALESCE(${column}, 'ในแผน') = 'นอกแผน' THEN 'นอกแผน' ELSE 'ในแผน' END)`;

// Same rule as the purchase_plan view: a usage plan without an approved quota counts its requested amount.
export const usagePlanQuotaSql = (usagePlanAlias: string) =>
  `GREATEST(COALESCE(${usagePlanAlias}.approved_quota, ${usagePlanAlias}.requested_amount, 0), 0)`;

// Same key as the purchase_plan view's purchased_summary join: purchase_plan_id is never populated.
export const usagePlanHasPurchaseApprovalSql = (usagePlanAlias: string) => `EXISTS (
  SELECT 1
  FROM public.purchase_approval_detail pad
  INNER JOIN public.purchase_approval pa ON pa.id = pad.purchase_approval_id
  WHERE pad.product_code = ${usagePlanAlias}.product_code
    AND pa.budget_year = ${usagePlanAlias}.budget_year
    AND ${purchasePlanFlagSql('pad.usage_plan_flag')} = ${purchasePlanFlagSql(`${usagePlanAlias}.plan_flag`)}
)`;

export async function usagePlanHasPurchaseApproval(query: PurchasePlanQuery, usagePlanId: number) {
  const result = await query(
    `SELECT ${usagePlanHasPurchaseApprovalSql('up')} AS has_purchase_approval
     FROM public.usage_plan up
     WHERE up.id = $1`,
    [usagePlanId]
  );
  return Boolean(result.rows[0]?.has_purchase_approval);
}
