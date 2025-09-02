'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useState } from 'react';

export default function Navbar() {
  const pathname = usePathname();
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const menuItems = [
    { href: '/', label: 'หน้าหลัก', icon: '🏠' },
    { href: '/categories', label: 'หมวดหมู่สินค้า', icon: '💊' },
    { href: '/departments', label: 'แผนก', icon: '🏥' },
    { href: '/products', label: 'เวชภัณฑ์', icon: '🩺' },
    { href: '/sellers', label: 'ผู้จำหน่าย', icon: '🏪' },
    { href: '/surveys', label: 'แบบสำรวจ', icon: '📋' },
    { href: '/purchase-plans', label: 'แผนจัดซื้อ', icon: '📊' },
    { href: '/purchase-approvals', label: 'อนุมัติจัดซื้อ', icon: '✅' },
    { href: '/warehouse', label: 'คลังเวชภัณฑ์', icon: '🏥' },
    { href: '/ai', label: 'AI Assistant', icon: '🤖' }
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
          <div className="hidden md:flex space-x-1">
            {menuItems.map((item) => (
              <Link
                key={item.href}
                href={item.href}
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
              {menuItems.map((item) => (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setIsMenuOpen(false)}
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
          </div>
        )}
      </div>
    </nav>
  );
}
