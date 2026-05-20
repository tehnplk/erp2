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
        email: { label: 'Username', type: 'text' },
        password: { label: 'Password', type: 'password' },
      },
      authorize: async (credentials) => {
        const username = String(credentials?.email ?? '').trim();
        const password = String(credentials?.password ?? '');

        if (!username || !password) {
          return null;
        }

        const [{ getActiveUserByEmail, touchUserLastLogin }, { verifyPassword }] = await Promise.all([
          import('@/lib/users'),
          import('@/lib/password'),
        ]);
        const user = await getActiveUserByEmail(username);

        if (!user || !(await verifyPassword(password, user.password_hash))) {
          return null;
        }

        await touchUserLastLogin(user.id);

        return {
          id: user.id,
          email: user.email,
          name: user.name || user.email,
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
        session.user.role = token.role;
        session.user.departmentId = token.departmentId;
        session.user.isDepartmentOwner = token.isDepartmentOwner;
      }

      return session;
    },
  },
} satisfies NextAuthConfig;

export const { handlers, signIn, signOut, auth } = NextAuth(authConfig);
