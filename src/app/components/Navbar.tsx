'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useState } from 'react';

export default function Navbar() {
  const pathname = usePathname();
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);

  const settingsItems = [
    { href: '/sellers', label: 'ผู้จำหน่าย', icon: '🏪' },
    { href: '/categories', label: 'หมวดหมู่สินค้า', icon: '💊' },
    { href: '/products', label: 'รายการสินค้า', icon: '📦' },
    { href: '/departments', label: 'แผนก', icon: '🏥' },
  ];

  return (
    <nav className="bg-blue-600 text-white shadow-lg fixed top-0 left-0 right-0 z-50">
      <div className="container mx-auto px-4">
        <div className="flex justify-between items-center" style={{height: '52px'}}>
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-2">
            <span className="text-2xl">🏥</span>
            <span className="text-xl font-bold">Hospital ERP</span>
          </Link>

          {/* Desktop Menu */}
          <div className="hidden md:flex space-x-1 items-center">
            {/* Home */}
            <Link
              href="/"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <span className="mr-2">🏠</span>
              หน้าหลัก
            </Link>

            {/* ตั้งค่า Dropdown */}
            <div className="relative">
              <button
                type="button"
                onClick={() => setIsSettingsOpen((v) => !v)}
                className="px-3 py-2 rounded-md text-sm font-medium transition-colors text-blue-100 hover:bg-blue-500 hover:text-white flex items-center"
                aria-haspopup="true"
                aria-expanded={isSettingsOpen}
              >
                <span className="mr-2">⚙️</span>
                ตั้งค่า
                <span className="ml-1">▾</span>
              </button>
              {isSettingsOpen && (
                <div className="absolute mt-2 w-56 bg-white text-gray-800 rounded-md shadow-lg py-1 z-50">
                  {settingsItems.map((item) => (
                    <Link
                      key={item.href}
                      href={item.href}
                      className={`flex items-center px-4 py-2 text-sm hover:bg-gray-100 ${
                        pathname === item.href ? 'bg-gray-100 font-medium' : ''
                      }`}
                    >
                      <span className="mr-2">{item.icon}</span>
                      {item.label}
                    </Link>
                  ))}
                </div>
              )}
            </div>

            {/* Other top-level links */}
            <Link
              href="/surveys"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/surveys'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <span className="mr-2">📋</span>
              แผนการใช้
            </Link>
            <Link
              href="/purchase-plans"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/purchase-plans'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <span className="mr-2">📊</span>
              แผนจัดซื้อ
            </Link>
            <Link
              href="/purchase-approvals"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/purchase-approvals'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <span className="mr-2">✅</span>
              อนุมัติจัดซื้อ
            </Link>
            <Link
              href="/warehouse"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/warehouse'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <span className="mr-2">🏥</span>
              คลัง
            </Link>
            <Link
              href="/ai"
              className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                pathname === '/ai'
                  ? 'bg-blue-700 text-white'
                  : 'text-blue-100 hover:bg-blue-500 hover:text-white'
              }`}
            >
              <span className="mr-2">🤖</span>
              AI Assistant
            </Link>
          </div>

          {/* Mobile Menu Button */}
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="md:hidden p-2 rounded-md hover:bg-blue-500"
          >
            <span className="text-xl">{isMenuOpen ? '✖️' : '☰'}</span>
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
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <span className="mr-2">🏠</span>
                หน้าหลัก
              </Link>

              {/* ตั้งค่า collapsible */}
              <button
                onClick={() => setIsSettingsOpen(!isSettingsOpen)}
                className="px-3 py-2 rounded-md text-sm font-medium transition-colors text-blue-100 hover:bg-blue-500 hover:text-white text-left"
              >
                <span className="mr-2">⚙️</span>
                ตั้งค่า {isSettingsOpen ? '▴' : '▾'}
              </button>
              {isSettingsOpen && (
                <div className="ml-4 flex flex-col space-y-2">
                  {settingsItems.map((item) => (
                    <Link
                      key={item.href}
                      href={item.href}
                      onClick={() => { setIsMenuOpen(false); setIsSettingsOpen(false); }}
                      className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                        pathname === item.href
                          ? 'bg-blue-700 text-white'
                          : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                      }`}
                    >
                      <span className="mr-2">{item.icon}</span>
                      {item.label}
                    </Link>
                  ))}
                </div>
              )}

              {/* Other links */}
              <Link
                href="/surveys"
                onClick={() => setIsMenuOpen(false)}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/surveys'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <span className="mr-2">📋</span>
                แผนการใช้
              </Link>
              <Link
                href="/purchase-plans"
                onClick={() => setIsMenuOpen(false)}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/purchase-plans'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <span className="mr-2">📊</span>
                แผนจัดซื้อ
              </Link>
              <Link
                href="/purchase-approvals"
                onClick={() => setIsMenuOpen(false)}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/purchase-approvals'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <span className="mr-2">✅</span>
                อนุมัติจัดซื้อ
              </Link>
              <Link
                href="/warehouse"
                onClick={() => setIsMenuOpen(false)}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/warehouse'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <span className="mr-2">🏥</span>
                คลัง
              </Link>
              <Link
                href="/ai"
                onClick={() => setIsMenuOpen(false)}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === '/ai'
                    ? 'bg-blue-700 text-white'
                    : 'text-blue-100 hover:bg-blue-500 hover:text-white'
                }`}
              >
                <span className="mr-2">🤖</span>
                AI Assistant
              </Link>
            </div>
          </div>
        )}
      </div>
    </nav>
  );
}
