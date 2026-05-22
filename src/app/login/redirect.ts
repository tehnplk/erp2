const defaultRedirect = '/';

export const sanitizeRedirectPath = (value: FormDataEntryValue | string | null | undefined) => {
  const path = String(value ?? '').trim();

  if (!path || !path.startsWith('/') || path.startsWith('//')) {
    return defaultRedirect;
  }

  return path;
};
