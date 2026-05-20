import { canAccess, resolvePermissionModule } from '@/lib/access-control';
import { getToken } from 'next-auth/jwt';
import { NextResponse, type NextRequest } from 'next/server';

const publicPathPrefixes = ['/', '/api/auth', '/api/sys-setting/public', '/login'];

const isPublicPath = (pathname: string) =>
  publicPathPrefixes.some((prefix) => pathname === prefix || pathname.startsWith(`${prefix}/`));

const isApiPath = (pathname: string) => pathname.startsWith('/api/');

export async function middleware(request: NextRequest) {
  const pathname = request.nextUrl.pathname;

  if (isPublicPath(pathname)) {
    return NextResponse.next();
  }

  if (canAccess(null, pathname, request.method)) {
    return NextResponse.next();
  }

  const authSecret = process.env.AUTH_SECRET ?? process.env.NEXTAUTH_SECRET;
  if (!authSecret) {
    return NextResponse.json({ error: 'Auth secret is not configured' }, { status: 500 });
  }

  const secureCookie = request.nextUrl.protocol === 'https:';
  const token = await getToken({
    req: request,
    secret: authSecret,
    secureCookie,
    salt: secureCookie ? '__Secure-authjs.session-token' : 'authjs.session-token',
  });
  if (!token) {
    if (isApiPath(pathname)) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const loginUrl = new URL('/login', request.nextUrl.origin);
    loginUrl.searchParams.set('callbackUrl', `${request.nextUrl.pathname}${request.nextUrl.search}`);
    return NextResponse.redirect(loginUrl);
  }

  const permissionModule = resolvePermissionModule(pathname);
  if (
    permissionModule &&
    !canAccess(
      {
        role: token.role,
        departmentId: token.departmentId,
      },
      pathname,
      request.method
    )
  ) {
    if (isApiPath(pathname)) {
      return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
    }

    return NextResponse.redirect(new URL('/', request.nextUrl.origin));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * Feel free to modify this pattern to include more paths.
     */
    '/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp|ttf|otf|woff|woff2)$).*)',
  ],
}
