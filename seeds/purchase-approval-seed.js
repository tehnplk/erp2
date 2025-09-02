const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

const csvPath = path.join(__dirname, 'ขอความเห็นชอบจัดซื้อ.csv');

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
        
        if (columns.length >= 16) {
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
            approvalId: cleanString(columns[0]),
            department: cleanString(columns[1]),
            recordNumber: cleanString(columns[2]),
            requestDate: cleanString(columns[3]),
            productName: cleanString(columns[4]),
            productCode: cleanString(columns[5]),
            category: cleanString(columns[6]),
            productType: cleanString(columns[7]),
            productSubtype: cleanString(columns[8]),
            requestedQuantity: cleanNumber(columns[9]),
            unit: cleanString(columns[10]),
            pricePerUnit: cleanNumber(columns[11]),
            totalValue: cleanNumber(columns[12]),
            overPlanCase: cleanString(columns[13]),
            requester: cleanString(columns[14]),
            approver: cleanString(columns[15])
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

async function seedPurchaseApprovals() {
  try {
    console.log('Starting PurchaseApproval seeding...');
    
    // Connect to database
    await prisma.$connect();
    console.log('Connected to database');
    
    // Truncate table and reset sequence
    console.log('Truncating PurchaseApproval table...');
    await prisma.$executeRaw`TRUNCATE TABLE "PurchaseApproval" RESTART IDENTITY CASCADE`;
    console.log('Table truncated and ID sequence reset');
    
    // Read and parse CSV data
    console.log('Reading CSV data...');
    const approvalData = parseCSV(csvPath);
    console.log(`Found ${approvalData.length} purchase approval records`);
    
    // Insert data
    let successCount = 0;
    let errorCount = 0;
    
    for (let i = 0; i < approvalData.length; i++) {
      try {
        await prisma.purchaseApproval.create({
          data: approvalData[i]
        });
        successCount++;
        
        if (successCount % 50 === 0) {
          console.log(`Imported ${successCount} purchase approvals...`);
        }
      } catch (error) {
        errorCount++;
        console.error(`Error importing approval ${i + 1}:`, error.message);
        console.error('Data:', JSON.stringify(approvalData[i], null, 2));
        
        // Stop if too many errors
        if (errorCount > 10) {
          console.error('Too many errors, stopping import');
          break;
        }
      }
    }
    
    console.log(`\nPurchaseApproval seeding completed!`);
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
seedPurchaseApprovals()
  .then(() => {
    console.log('PurchaseApproval seeding process finished');
    process.exit(0);
  })
  .catch((error) => {
    console.error('Fatal error:', error);
    process.exit(1);
  });
