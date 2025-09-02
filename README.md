# Hospital Resource Planning System (ERP)

This is a comprehensive Hospital Resource Planning System built with Next.js, designed specifically for healthcare facilities to manage their resources efficiently.

## Overview

The system provides a complete solution for hospitals to manage various aspects of their operations including:
- Product/medicine inventory management
- Departmental resource planning
- Vendor/supplier information
- Purchase planning and approval workflows
- Warehouse stock tracking
- AI-powered analytics and recommendations

## Key Features

- **Category Management**: Organize products by category, type, and subtype
- **Department Management**: Track hospital departments and their resource needs
- **Product Management**: Comprehensive inventory of medical supplies and equipment
- **Vendor Management**: Maintain supplier information and relationships
- **Survey System**: Collect requirements and feedback from departments
- **Purchase Planning**: Create and manage annual purchase plans with budget tracking
- **Approval Workflow**: Streamline purchase approval processes
- **Warehouse Management**: Track inventory movements and stock levels
- **AI Assistant**: Intelligent recommendations and analytics

## Technology Stack

- **Frontend**: Next.js 15, React 19, TypeScript
- **Styling**: Tailwind CSS
- **Backend**: Next.js API Routes
- **Database**: PostgreSQL with Prisma ORM
- **Data Seeding**: CSV-based data import scripts

## Getting Started

### Prerequisites

- Node.js (version 18 or higher)
- PostgreSQL database
- npm, yarn, pnpm, or bun package manager

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   # or
   yarn install
   # or
   pnpm install
   # or
   bun install
   ```
3. Set up your database:
   - Create a PostgreSQL database
   - Update the `DATABASE_URL` in your `.env` file
4. Run database migrations:
   ```bash
   npx prisma migrate dev
   ```
5. Seed initial data (optional):
   ```bash
   node seeds/category-seed.js
   node seeds/department-seed.js
   # Run other seed files as needed
   ```

### Development Server

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the application.

## Data Models

The system includes the following core data models:

- **User**: System users with authentication
- **Department**: Hospital departments
- **Seller**: Product vendors and suppliers
- **Product**: Medical supplies and equipment
- **Category**: Product categorization system
- **Survey**: Departmental requirements collection
- **PurchasePlan**: Annual purchasing plans
- **PurchaseApproval**: Purchase request approvals
- **Warehouse**: Inventory tracking and movements

## Project Structure

```
├── prisma/          # Database schema and migrations
├── seeds/           # Data seeding scripts and CSV files
├── src/
│   ├── app/         # Next.js app directory
│   │   ├── api/     # API routes
│   │   ├── ai/      # AI assistant functionality
│   │   └── [module]/ # Module-specific pages
└── public/          # Static assets
```

## Learn More

To learn more about the technologies used in this project:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API
- [Prisma Documentation](https://www.prisma.io/docs/) - database toolkit documentation
- [Tailwind CSS Documentation](https://tailwindcss.com/docs) - utility-first CSS framework

## Deployment

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
