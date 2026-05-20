import type { DefaultSession } from 'next-auth';
import type { UserRole } from '@/lib/access-control';

declare module 'next-auth' {
  interface User {
    providerId?: string;
    role?: UserRole;
    departmentId?: number | null;
    isDepartmentOwner?: boolean;
  }

  interface Session {
    user: {
      id?: string;
      providerId?: string;
      role?: UserRole;
      departmentId?: number | null;
      isDepartmentOwner?: boolean;
    } & DefaultSession['user'];
  }
}

declare module 'next-auth/jwt' {
  interface JWT {
    providerId?: string;
    role?: UserRole;
    departmentId?: number | null;
    isDepartmentOwner?: boolean;
  }
}
