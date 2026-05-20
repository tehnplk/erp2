import NextAuth, { type NextAuthConfig } from 'next-auth';
import Credentials from 'next-auth/providers/credentials';

const authConfig = {
  session: {
    strategy: 'jwt',
  },
  pages: {
    signIn: '/login',
  },
  providers: [
    Credentials({
      credentials: {
        providerId: { label: 'Username', type: 'text' },
        password: { label: 'Password', type: 'password' },
      },
      authorize: async (credentials) => {
        const providerId = String(credentials?.providerId ?? '').trim();
        const password = String(credentials?.password ?? '');

        if (!providerId || !password) {
          return null;
        }

        const [{ getActiveUserByProviderId, touchUserLastLogin }, { verifyPassword }] = await Promise.all([
          import('@/lib/users'),
          import('@/lib/password'),
        ]);
        const user = await getActiveUserByProviderId(providerId);

        if (!user || !(await verifyPassword(password, user.password_hash))) {
          return null;
        }

        await touchUserLastLogin(user.id);

        return {
          id: user.id,
          name: user.name || user.provider_id,
          providerId: user.provider_id,
          role: user.role,
          departmentId: user.department_id,
          isDepartmentOwner: user.is_department_owner,
        };
      },
    }),
  ],
  callbacks: {
    jwt({ token, user }) {
      if (user) {
        token.providerId = user.providerId;
        token.role = user.role;
        token.departmentId = user.departmentId;
        token.isDepartmentOwner = user.isDepartmentOwner;
      }

      return token;
    },
    session({ session, token }) {
      if (session.user) {
        if (token.sub) {
          session.user.id = token.sub;
        }
        session.user.providerId = token.providerId;
        session.user.role = token.role;
        session.user.departmentId = token.departmentId;
        session.user.isDepartmentOwner = token.isDepartmentOwner;
      }

      return session;
    },
  },
} satisfies NextAuthConfig;

export const { handlers, signIn, signOut, auth } = NextAuth(authConfig);
