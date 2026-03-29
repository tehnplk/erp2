export function isUniqueViolation(error: unknown) {
  const candidate = error as { code?: string; constraint?: string } | null | undefined;
  return candidate?.code === '23505';
}
