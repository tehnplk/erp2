import type { DefaultSession } from 'next-auth';
import type { UserRole } from '@/lib/access-control';

declare module 'next-auth' {
  interface User {
    role?: UserRole;
    departmentId?: number | null;
    isDepartmentOwner?: boolean;
  }

  interface Session {
    user: {
      id?: string;
      role?: UserRole;
      departmentId?: number | null;
      isDepartmentOwner?: boolean;
    } & DefaultSession['user'];
  }
}

declare module 'next-auth/jwt' {
  interface JWT {
    role?: UserRole;
    departmentId?: number | null;
    isDepartmentOwner?: boolean;
  }
}
