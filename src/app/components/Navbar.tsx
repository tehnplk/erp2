'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useState, useEffect, useRef } from 'react';
import { signOut, useSession } from 'next-auth/react';
import {
  BadgeCheck,
  BarChart4,
  Building2,
  ClipboardList,
  Home as HomeIcon,
  Hospital,
  Menu,
  Package,
  Pill,
  Settings,
  Store,
  LogIn,
  LogOut,
  UserCircle,
  Users,
  Warehouse,
  X,
} from 'lucide-react';
import { useSysSetting } from '@/hooks/use-sys-setting';

export default function Navbar() {
  const pathname = usePathname();
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isProfileOpen, setIsProfileOpen] = useState(false);
  const [departmentName, setDepartmentName] = useState('');
  const settingsRef = useRef<HTMLDivElement>(null);
  const profileRef = useRef<HTMLDivElement>(null);
  const { data: session, status } = useSession();
  const budgetYear = useSysSetting('budget_year', '');
  const user = session?.user;
  const isAdmin = user?.role === 'Admin';
  const rawProfileName = user?.name || user?.providerId || '';
  const [shortProfileName, inferredDepartmentName] = rawProfileName.split(' - ', 2);
  const profileName = shortProfileName || user?.providerId || '';
  const profileDepartmentName = departmentName || inferredDepartmentName || '';

  const settingsItems = [
    { href: '/sellers', label: 'ผู้จำหน่าย', icon: Store },
    { href: '/categories', label: 'หมวดหมู่สินค้า', icon: Pill },
    { href: '/products', label: 'รายการสินค้า', icon: Package },
    { href: '/departments', label: 'แผนก', icon: Hospital },
    { href: '/setting', label: 'ตั้งค่าระบบ', icon: Settings },
  ];

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (settingsRef.current && !settingsRef.current.contains(event.target as Node)) {
        setIsSettingsOpen(false);
      }
      if (profileRef.current && !profileRef.current.contains(event.target as Node)) {
        setIsProfileOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);

  useEffect(() => {
    let cancelled = false;

    const loadDepartmentName = async () => {
      if (!user?.departmentId) {
        setDepartmentName('');
        return;
      }

      try {
        const response = await fetch('/api/departments', { cache: 'no-store' });
        const payload = await response.json();
        const department = (payload.data || []).find((item: any) => item.id === user.departmentId);
        if (!cancelled) {
          setDepartmentName(department?.name || '');
        }
      } catch {
        if (!cancelled) {
          setDepartmentName('');
        }
      }
    };

    loadDepartmentName();

    return () => {
      cancelled = true;
    };
  }, [user?.departmentId]);

  const handleSignOut = () => {
    setIsProfileOpen(false);
    setIsMenuOpen(false);
    signOut({ callbackUrl: '/login' });
  };

  return (
    <nav className="bg-blue-600 text-white shadow-lg fixed top-0 left-0 right-0 z-50">
      <div className="container mx-auto px-4">
        <div className="flex justify-between items-center" style={{height: '52px'}}>
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-2">
            <Building2 className="h-6 w-6" />
            <span className="text-xl font-bold">Hospital ERP</span>
            <span className="hidden sm:inline-flex rounded-full bg-blue-500/80 px-3 py-1 text-xs font-semibold text-blue-50">
              ปีงบประมาณ {budgetYear || '-'}
            </span>
          </Link>

          {/* Desktop Menu */}
          <div className="hidden md:flex space-x-1 items-center">
            {/* Home */}
            <Link
              href="/"
              className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <HomeIcon className="mr-2 h-4 w-4" />
              หน้าหลัก
            </Link>

            {/* Other top-level links */}
            <Link
              href="/usage-plans"
              className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/usage-plans'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <ClipboardList className="mr-2 h-4 w-4" />
              แผนการใช้
            </Link>
            <Link
              href="/purchase-plans"
              className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/purchase-plans'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <BarChart4 className="mr-2 h-4 w-4" />
              แผนจัดซื้อ
            </Link>
            <Link
              href="/purchase-approvals"
              className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/purchase-approvals'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <BadgeCheck className="mr-2 h-4 w-4" />
              อนุมัติจัดซื้อ
            </Link>
            <Link
              href="/inventory"
              className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname.startsWith('/inventory')
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <Warehouse className="mr-2 h-4 w-4" />
              ระบบคลัง
            </Link>
            {/* ตั้งค่า Dropdown - rightmost */}
            <div className="relative" ref={settingsRef}>
              <button
                type="button"
                onClick={() => setIsSettingsOpen((v) => !v)}
                className="px-3 py-2 rounded-md text-sm font-medium transition-colors text-blue-100 hover:bg-blue-500 hover:text-white flex items-center"
                aria-haspopup="true"
                aria-expanded={isSettingsOpen}
              >
                <Settings className="mr-2 h-4 w-4" />
                ตั้งค่า
                <span className="ml-1">▾</span>
              </button>
              {isSettingsOpen && (
                <div className="absolute right-0 mt-2 min-w-max bg-white text-gray-800 rounded-md shadow-lg py-1 z-50 whitespace-nowrap">
                  {settingsItems.map((item) => {
                    const Icon = item.icon;
                    return (
                      <Link
                        key={item.href}
                        href={item.href}
                        onClick={() => setIsSettingsOpen(false)}
                        className={`flex items-center px-4 py-2 text-sm hover:bg-gray-100 ${
                          pathname === item.href ? 'bg-gray-100 font-medium' : ''
                        }`}
                      >
                        <Icon className="mr-2 h-4 w-4" />
                        {item.label}
                      </Link>
                    );
                  })}
                </div>
              )}
            </div>

            <div className="relative ml-2 border-l border-blue-500 pl-3" ref={profileRef}>
              {status === 'authenticated' && user ? (
                <>
                  <button
                    type="button"
                    onClick={() => setIsProfileOpen((v) => !v)}
                    className="flex max-w-[210px] items-center gap-2 rounded-md px-3 py-2 text-sm font-medium text-blue-50 transition-colors hover:bg-blue-500"
                    aria-haspopup="true"
                    aria-expanded={isProfileOpen}
                  >
                    <UserCircle className="h-5 w-5 shrink-0" />
                    <span className="truncate">{profileName}</span>
                  </button>
                  {isProfileOpen && (
                    <div className="absolute right-0 mt-2 w-64 overflow-hidden rounded-md bg-white py-1 text-gray-800 shadow-lg">
                      <div className="border-b border-gray-100 px-4 py-3">
                        <div className="truncate text-sm font-semibold text-gray-900">{profileName}</div>
                        <div className="truncate text-xs text-gray-500">{user.providerId}</div>
                        {profileDepartmentName && (
                          <div className="mt-1 truncate text-xs text-gray-500">{profileDepartmentName}</div>
                        )}
                        <div className="mt-1 text-xs font-medium text-blue-700">{user.role || 'User'}</div>
                      </div>
                      <Link
                        href="/profile"
                        onClick={() => setIsProfileOpen(false)}
                        className={`flex items-center px-4 py-2 text-sm hover:bg-gray-100 ${
                          pathname === '/profile' ? 'bg-gray-100 font-medium' : ''
                        }`}
                      >
                        <UserCircle className="mr-2 h-4 w-4" />
                        โปรไฟล์
                      </Link>
                      {isAdmin && (
                        <Link
                          href="/users"
                          onClick={() => setIsProfileOpen(false)}
                          className={`flex items-center px-4 py-2 text-sm hover:bg-gray-100 ${
                            pathname === '/users' ? 'bg-gray-100 font-medium' : ''
                          }`}
                        >
                          <Users className="mr-2 h-4 w-4" />
                          ผู้ใช้งาน
                        </Link>
                      )}
                      <button
                        type="button"
                        onClick={handleSignOut}
                        className="flex w-full items-center px-4 py-2 text-left text-sm text-red-700 hover:bg-red-50"
                      >
                        <LogOut className="mr-2 h-4 w-4" />
                        ออกจากระบบ
                      </button>
                    </div>
                  )}
                </>
              ) : (
                <Link
                  href="/login"
                  className="flex items-center gap-2 rounded-md px-3 py-2 text-sm font-medium text-blue-50 transition-colors hover:bg-blue-500"
                >
                  <LogIn className="h-4 w-4" />
                  เข้าสู่ระบบ
                </Link>
              )}
            </div>
          </div>

          {/* Mobile Menu Button */}
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="md:hidden p-2 rounded-md hover:bg-blue-500"
            aria-label="Toggle navigation menu"
          >
            {isMenuOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
          </button>
        </div>

        {/* Mobile Menu */}
        {isMenuOpen && (
          <div className="md:hidden pb-4">
            <div className="flex flex-col space-y-2">
              {/* Home */}
              <Link
                href="/"
                onClick={() => setIsMenuOpen(false)}
                className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <HomeIcon className="mr-2 h-4 w-4" />
                หน้าหลัก
              </Link>

              {/* Other links */}
              <Link
                href="/usage-plans"
                onClick={() => setIsMenuOpen(false)}
                className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/usage-plans'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <ClipboardList className="mr-2 h-4 w-4" />
                แผนการใช้
              </Link>
              <Link
                href="/purchase-plans"
                onClick={() => setIsMenuOpen(false)}
                className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/purchase-plans'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <BarChart4 className="mr-2 h-4 w-4" />
                แผนจัดซื้อ
              </Link>
              <Link
                href="/purchase-approvals"
                onClick={() => setIsMenuOpen(false)}
                className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/purchase-approvals'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <BadgeCheck className="mr-2 h-4 w-4" />
                อนุมัติจัดซื้อ
              </Link>
              <Link
                href="/inventory"
                onClick={() => setIsMenuOpen(false)}
                className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname.startsWith('/inventory')
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <Warehouse className="mr-2 h-4 w-4" />
                ระบบคลัง
              </Link>
              {/* ตั้งค่า collapsible - last in mobile menu */}
              <button
                onClick={() => setIsSettingsOpen(!isSettingsOpen)}
                className="flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors text-blue-100 hover:bg-blue-500 hover:text-white text-left"
              >
                <Settings className="mr-2 h-4 w-4" />
                ตั้งค่า {isSettingsOpen ? '▴' : '▾'}
              </button>
              {isSettingsOpen && (
                <div className="ml-4 flex flex-col space-y-2">
                  {settingsItems.map((item) => {
                    const Icon = item.icon;
                    return (
                      <Link
                        key={item.href}
                        href={item.href}
                        onClick={() => { setIsMenuOpen(false); setIsSettingsOpen(false); }}
                        className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                          pathname === item.href
                            ? 'bg-blue-700 text-white'
                            : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                        }`}
                      >
                        <Icon className="mr-2 h-4 w-4" />
                        {item.label}
                      </Link>
                    );
                  })}
                </div>
              )}

              <div className="mt-2 border-t border-blue-500 pt-3">
                {status === 'authenticated' && user ? (
                  <div className="space-y-2">
                    <div className="px-3 py-2">
                      <div className="truncate text-sm font-semibold text-white">{profileName}</div>
                      <div className="truncate text-xs text-blue-100">{user.providerId}</div>
                      {profileDepartmentName && (
                        <div className="mt-1 truncate text-xs text-blue-100">{profileDepartmentName}</div>
                      )}
                    </div>
                    <Link
                      href="/profile"
                      onClick={() => setIsMenuOpen(false)}
                      className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                        pathname === '/profile'
                          ? 'bg-blue-700 text-white'
                          : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                      }`}
                    >
                      <UserCircle className="mr-2 h-4 w-4" />
                      โปรไฟล์
                    </Link>
                    {isAdmin && (
                      <Link
                        href="/users"
                        onClick={() => setIsMenuOpen(false)}
                        className={`flex items-center px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                          pathname === '/users'
                            ? 'bg-blue-700 text-white'
                            : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                        }`}
                      >
                        <Users className="mr-2 h-4 w-4" />
                        ผู้ใช้งาน
                      </Link>
                    )}
                    <button
                      type="button"
                      onClick={handleSignOut}
                      className="flex w-full items-center rounded-md px-3 py-2 text-left text-sm font-medium text-blue-100 transition-colors hover:bg-blue-500 hover:text-white"
                    >
                      <LogOut className="mr-2 h-4 w-4" />
                      ออกจากระบบ
                    </button>
                  </div>
                ) : (
                  <Link
                    href="/login"
                    onClick={() => setIsMenuOpen(false)}
                    className="flex items-center rounded-md px-3 py-2 text-sm font-medium text-blue-100 transition-colors hover:bg-blue-500 hover:text-white"
                  >
                    <LogIn className="mr-2 h-4 w-4" />
                    เข้าสู่ระบบ
                  </Link>
                )}
              </div>
            </div>
          </div>
        )}
      </div>
    </nav>
  );
}
