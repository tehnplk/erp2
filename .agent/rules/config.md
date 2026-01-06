---
trigger: always_on
---

---
applyTo: "src/app/modules/<modulesName>/config/<nameConfig>.ts"
---

## General Rules for Creating ConfigName.ts 
1. Store constant variables for various pages in JSON format

Example:
```typescript
// modules/e-borrow/config/sidebarConfig.ts

export const eBorrowSidebarConfig = {
  title: 'e-borrow System',
  subtitle: 'Equipment Borrowing System',
  logo: '📚',
  
  menuItems: [
    {
      id: 'dashboard',
      label: 'Dashboard',
      icon: '📊',
      href: '/main/e-borrow/dashboard',
      description: 'Borrowing system overview'
    },
    {
      id: 'borrowings',
      label: 'Equipment Borrowing',
      icon: '📋',
      children: [
        {
          id: 'new-borrow',
          label: 'New Borrowing',
          icon: '➕',
          href: '/main/e-borrow/borrowings/new',
          description: 'Create new borrowing request'
        },
        {
          id: 'active-borrowings',
          label: 'Active Borrowings',
          icon: '📝',
          href: '/main/e-borrow/borrowings/active',
          description: 'Currently borrowed items'
        },
        {
          id: 'pending-approval',
          label: 'Pending Approval',
          icon: '⏳',
          href: '/main/e-borrow/borrowings/pending',
          description: 'Requests awaiting approval',
          badge: 'pending'
        },
        {
          id: 'overdue',
          label: 'Overdue',
          icon: '⚠️',
          href: '/main/e-borrow/borrowings/overdue',
          description: 'Overdue return items',
          badge: 'danger'
        }
      ]
    },
    {
      id: 'returns',
      label: 'Equipment Returns',
      icon: '📤',
      children: [
        {
          id: 'return-process',
          label: 'Process Return',
          icon: '✅',
          href: '/main/e-borrow/returns/process',
          description: 'Process equipment returns'
        },
        {
          id: 'return-history',
          label: 'Return History',
          icon: '📜',
          href: '/main/e-borrow/returns/history',
          description: 'Equipment return history'
        },
        {
          id: 'damaged-items',
          label: 'Damaged Items',
          icon: '🔧',
          href: '/main/e-borrow/returns/damaged',
          description: 'List of damaged equipment',
          badge: 'warning'
        }
      ]
    },
    {
      id: 'inventory',
      label: 'Equipment Inventory',
      icon: '📦',
      children: [
        {
          id: 'all-items',
          label: 'All Equipment',
          icon: '📋',
          href: '/main/e-borrow/inventory/items',
          description: 'List of all equipment'
        },
        {
          id: 'add-item',
          label: 'Add Equipment',
          icon: '➕',
          href: '/main/e-borrow/inventory/add',
          description: 'Add new equipment'
        },
        {
          id: 'maintenance',
          label: 'Maintenance',
          icon: '🔧',
          href: '/main/e-borrow/inventory/maintenance',
          description: 'Equipment maintenance'
        }
      ]
    }
  ],

  // Additional configuration
  config: {
    showUserInfo: true,
    showLogout: true,
    collapsible: true,
    theme: 'light',
    maxWidth: '280px',
    compactMode: false
  },

  // Role-based menu filtering
  rolePermissions: {
    'admin': ['*'], // Admin can access all menus
    'manager': [
      'dashboard', 
      'borrowings', 
      'returns', 
      'inventory', 
      'users', 
      'reports', 
      'settings'
    ],
    'staff': [
      'dashboard', 
      'borrowings', 
      'returns', 
      'inventory.all-items',
      'inventory.categories',
      'users.borrowers',
      'reports.borrowing-stats',
      'reports.popular-items'
    ],
    'user': [
      'dashboard',
      'borrowings.new-borrow',
      'borrowings.active-borrowings',
      'returns.return-process',
      'returns.return-history'
    ],
    'e-borrow': [ // Role for e-borrow users
      'dashboard',
      'borrowings',
      'returns',
      'inventory.all-items',
      'reports.borrowing-stats'
    ]
  }
}

export default eBorrowSidebarConfig
````
