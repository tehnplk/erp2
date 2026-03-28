'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

type InventoryTab = {
  label: string;
  href: string;
  exact?: boolean;
};

const tabs: InventoryTab[] = [
  { label: 'สินค้าคงคลัง', href: '/inventory/stock', exact: true },
  { label: 'เบิกจ่าย', href: '/inventory/issues' },
];

export function InventoryBreadcrumbs() {
  const pathname = usePathname();

  return (
    <nav aria-label="Inventory navigation" className="mb-5">
      <div className="flex flex-wrap gap-2 rounded-2xl border border-slate-200 bg-white/85 p-2 shadow-sm backdrop-blur">
        {tabs.map((tab) => {
          const isActive = tab.exact ? pathname === tab.href : pathname.startsWith(tab.href);

          return (
            <Link
              key={tab.href}
              href={tab.href}
              aria-current={isActive ? 'page' : undefined}
              className={[
                'inline-flex items-center rounded-xl px-4 py-2 text-sm font-medium transition',
                isActive
                  ? 'bg-slate-900 text-white shadow-sm'
                  : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900',
              ].join(' ')}
            >
              {tab.label}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
