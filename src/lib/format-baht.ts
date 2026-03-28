export function formatBaht(value: number | string | null | undefined, fractionDigits = 2): string {
  const parsed = Number(value ?? 0);
  const safeValue = Number.isFinite(parsed) ? parsed : 0;
  return `${safeValue.toLocaleString('th-TH', {
    minimumFractionDigits: fractionDigits,
    maximumFractionDigits: fractionDigits,
  })} บาท`;
}

export function formatNumber(value: number | string | null | undefined, fractionDigits = 2): string {
  const parsed = Number(value ?? 0);
  const safeValue = Number.isFinite(parsed) ? parsed : 0;
  return safeValue.toLocaleString('th-TH', {
    minimumFractionDigits: fractionDigits,
    maximumFractionDigits: fractionDigits,
  });
}
