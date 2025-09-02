const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

const csvPath = path.join(__dirname, 'คลังสินค้า.csv');

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
        
        if (columns.length >= 26) {
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
            stockId: cleanString(columns[1]),
            transactionType: cleanString(columns[2]),
            transactionDate: cleanString(columns[3]),
            category: cleanString(columns[4]),
            productType: cleanString(columns[5]),
            productSubtype: cleanString(columns[6]),
            productCode: cleanString(columns[7]),
            productName: cleanString(columns[8]),
            productImage: cleanString(columns[9]),
            unit: cleanString(columns[10]),
            productLot: cleanString(columns[11]),
            productPrice: cleanNumber(columns[12]),
            receivedFromCompany: cleanString(columns[13]),
            receiptBillNumber: cleanString(columns[14]),
            requestingDepartment: cleanString(columns[15]),
            requisitionNumber: cleanString(columns[16]),
            quotaAmount: cleanNumber(columns[17]),
            carriedForwardQty: cleanNumber(columns[18]),
            carriedForwardValue: cleanNumber(columns[19]),
            transactionPrice: cleanNumber(columns[20]),
            transactionQuantity: cleanNumber(columns[21]),
            transactionValue: cleanNumber(columns[22]),
            remainingQuantity: cleanNumber(columns[23]),
            remainingValue: cleanNumber(columns[24]),
            inventoryStatus: cleanString(columns[25])
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

async function seedWarehouse() {
  try {
    console.log('Starting Warehouse seeding...');
    
    // Connect to database
    await prisma.$connect();
    console.log('Connected to database');
    
    // Truncate table and reset sequence
    console.log('Truncating Warehouse table...');
    await prisma.$executeRaw`TRUNCATE TABLE "Warehouse" RESTART IDENTITY CASCADE`;
    console.log('Table truncated and ID sequence reset');
    
    // Read and parse CSV data
    console.log('Reading CSV data...');
    const warehouseData = parseCSV(csvPath);
    console.log(`Found ${warehouseData.length} warehouse records`);
    
    // Insert data
    let successCount = 0;
    let errorCount = 0;
    
    for (let i = 0; i < warehouseData.length; i++) {
      try {
        await prisma.warehouse.create({
          data: warehouseData[i]
        });
        successCount++;
        
        if (successCount % 100 === 0) {
          console.log(`Imported ${successCount} warehouse records...`);
        }
      } catch (error) {
        errorCount++;
        console.error(`Error importing warehouse record ${i + 1}:`, error.message);
        console.error('Data:', JSON.stringify(warehouseData[i], null, 2));
        
        // Stop if too many errors
        if (errorCount > 10) {
          console.error('Too many errors, stopping import');
          break;
        }
      }
    }
    
    console.log(`\nWarehouse seeding completed!`);
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
seedWarehouse()
  .then(() => {
    console.log('Warehouse seeding process finished');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
