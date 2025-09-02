const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

const csvPath = path.join(__dirname, 'แผนจัดซื้อ.csv');

function parseCSV(filePath) {
  try {
    const data = fs.readFileSync(filePath, 'utf8');
    const lines = data.split('\n');
    const result = [];
    
    for (let i = 1; i < lines.length; i++) {
      const line = lines[i].trim();
      if (line) {
        // Handle quoted fields that may contain commas
        const columns = [];
        let current = '';
        let inQuotes = false;
        
        for (let j = 0; j < line.length; j++) {
          const char = line[j];
          if (char === '"') {
            inQuotes = !inQuotes;
          } else if (char === ',' && !inQuotes) {
            columns.push(current.trim());
            current = '';
          } else {
            current += char;
          }
        }
        columns.push(current.trim());
        
        if (columns.length >= 17) {
          // Clean numeric values by removing quotes and commas
          const cleanNumber = (str) => {
            if (!str || str === '') return 0;
            return parseFloat(str.replace(/[",]/g, '')) || 0;
          };
          
          const cleanString = (str) => {
            if (!str) return '';
            return str.replace(/^"|"$/g, '').trim();
          };
          
          result.push({
            productCode: cleanString(columns[0]),
            category: cleanString(columns[1]),
            productName: cleanString(columns[2]),
            productType: cleanString(columns[3]),
            productSubtype: cleanString(columns[4]),
            unit: cleanString(columns[5]),
            pricePerUnit: cleanNumber(columns[6]),
            budgetYear: parseInt(columns[7]) || 2568,
            planId: parseInt(columns[8]) || 0,
            inPlan: cleanString(columns[9]),
            carriedForwardQuantity: cleanNumber(columns[10]),
            carriedForwardValue: cleanNumber(columns[11]),
            requiredQuantityForYear: cleanNumber(columns[12]),
            totalRequiredValue: cleanNumber(columns[13]),
            additionalPurchaseQty: cleanNumber(columns[14]),
            additionalPurchaseValue: cleanNumber(columns[15]),
            purchasingDepartment: cleanString(columns[16])
          });
        }
      }
    }
    
    return result;
  } catch (error) {
    console.error('Error reading CSV file:', error);
    process.exit(1);
  }
}

async function seedPurchasePlans() {
  try {
    console.log('Starting PurchasePlan seeding...');
    
    // Connect to database
    await prisma.$connect();
    console.log('Connected to database');
    
    // Truncate table and reset sequence
    console.log('Truncating PurchasePlan table...');
    await prisma.$executeRaw`TRUNCATE TABLE "PurchasePlan" RESTART IDENTITY CASCADE`;
    console.log('Table truncated and ID sequence reset');
    
    // Read and parse CSV data
    console.log('Reading CSV data...');
    const purchasePlanData = parseCSV(csvPath);
    console.log(`Found ${purchasePlanData.length} purchase plan records`);
    
    // Insert data
    let successCount = 0;
    let errorCount = 0;
    
    for (let i = 0; i < purchasePlanData.length; i++) {
      try {
        await prisma.purchasePlan.create({
          data: purchasePlanData[i]
        });
        successCount++;
        
        if (successCount % 100 === 0) {
          console.log(`Imported ${successCount} purchase plans...`);
        }
      } catch (error) {
        errorCount++;
        console.error(`Error importing purchase plan ${i + 1}:`, error.message);
        
        // Stop if too many errors
        if (errorCount > 10) {
          console.error('Too many errors, stopping import');
          break;
        }
      }
    }
    
    console.log(`\nPurchasePlan seeding completed!`);
    console.log(`Successfully imported: ${successCount} records`);
    console.log(`Errors encountered: ${errorCount} records`);
    
  } catch (error) {
    console.error('Error during seeding:', error);
  } finally {
    await prisma.$disconnect();
    console.log('Database connection closed');
  }
}

// Run the seeding function
seedPurchasePlans()
  .then(() => {
    console.log('PurchasePlan seeding process finished');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
