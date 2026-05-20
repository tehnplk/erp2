export type PermissionAction = 'view' | 'create' | 'edit' | 'delete';
export type UserRole = 'Admin' | 'Manager' | 'User';
export type PermissionModule =
  | '/products'
  | '/sellers'
  | '/departments'
  | '/usage-plans'
  | '/purchase-plans'
  | '/purchase-approvals'
  | '/inventory/stock';

export type AccessUser = {
  role?: string | null;
  isDepartmentOwner?: boolean | null;
};

const permissionModules: PermissionModule[] = [
  '/inventory/stock',
  '/purchase-approvals',
  '/purchase-plans',
  '/usage-plans',
  '/departments',
  '/products',
  '/sellers',
];

const rolePermissions: Record<UserRole, PermissionAction[]> = {
  Admin: ['view', 'create', 'edit', 'delete'],
  Manager: ['view', 'create', 'edit'],
  User: ['view'],
};

const ownerPermissions: Partial<Record<PermissionModule, PermissionAction[]>> = {
  '/usage-plans': ['view', 'edit'],
  '/purchase-plans': ['view', 'create', 'edit'],
  '/purchase-approvals': ['view', 'edit'],
  '/inventory/stock': ['view', 'create', 'edit'],
};

const normalizePath = (pathname: string) => {
  const [pathOnly] = pathname.split('?');
  const withoutApi = pathOnly.startsWith('/api/') ? pathOnly.slice('/api'.length) : pathOnly;
  return withoutApi.replace(/\/+$/, '') || '/';
};

export const getActionForMethod = (method: string): PermissionAction | null => {
  switch (method.toUpperCase()) {
    case 'GET':
    case 'HEAD':
    case 'OPTIONS':
      return 'view';
    case 'POST':
      return 'create';
    case 'PUT':
    case 'PATCH':
      return 'edit';
    case 'DELETE':
      return 'delete';
    default:
      return null;
  }
};

export const resolvePermissionModule = (pathname: string): PermissionModule | null => {
  const normalized = normalizePath(pathname);
  return permissionModules.find((modulePath) => normalized === modulePath || normalized.startsWith(`${modulePath}/`)) ?? null;
};

const isUserRole = (role: string | null | undefined): role is UserRole =>
  role === 'Admin' || role === 'Manager' || role === 'User';

export const canAccess = (user: AccessUser | null | undefined, pathname: string, method: string) => {
  const action = getActionForMethod(method);
  const modulePath = resolvePermissionModule(pathname);
  if (!action || !modulePath) return false;

  if (!user) return action === 'view';

  const normalizedRole = isUserRole(user.role) ? user.role : null;
  if (normalizedRole && rolePermissions[normalizedRole].includes(action)) {
    return true;
  }

  const ownerModulePermissions = ownerPermissions[modulePath] ?? [];
  return Boolean(user.isDepartmentOwner && ownerModulePermissions.includes(action));
};

export const getAllowedActions = (user: AccessUser | null | undefined, modulePath: PermissionModule) => {
  if (!user) return [];

  const actions = new Set<PermissionAction>();
  if (isUserRole(user.role)) {
    rolePermissions[user.role].forEach((action) => actions.add(action));
  }
  if (user.isDepartmentOwner) {
    ownerPermissions[modulePath]?.forEach((action) => actions.add(action));
  }

  return Array.from(actions);
};
