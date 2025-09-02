const { PrismaClient } = require('@prisma/client');
const fs = require('fs');
const path = require('path');

const prisma = new PrismaClient();

function parseCSV(filePath) {
  try {
    const data = fs.readFileSync(filePath, 'utf8');
    const lines = data.split('\n');
    const result = [];
    
    // Process data rows (skip header)
    for (let i = 1; i < lines.length; i++) {
      const line = lines[i].trim();
      if (line) {
        const columns = line.split(',');
        if (columns.length >= 8) {
          result.push({
            code: columns[0].trim(),
            prefix: columns[1].trim() || null,
            name: columns[2].trim(),
            business: columns[3].trim() || null,
            address: columns[4].trim() || null,
            phone: columns[5].trim() || null,
            fax: columns[6].trim() || null,
            mobile: columns[7].trim() || null,
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

async function seedSellers() {
  try {
    console.log('Starting seller seeding...');
    
    // Connect to database
    await prisma.$connect();
    console.log('Database connected');
    
    // Truncate table and reset ID sequence
    console.log('Truncating Seller table...');
    await prisma.$executeRaw`TRUNCATE TABLE "Seller" RESTART IDENTITY CASCADE`;
    console.log('Table truncated and ID reset');
    
    // Read seller data from CSV
    const csvPath = path.join(__dirname, 'saller.csv');
    console.log('Reading CSV file from:', csvPath);
    
    const sellerData = parseCSV(csvPath);
    console.log(`Found ${sellerData.length} sellers to import`);
    
    // Show sample data
    if (sellerData.length > 0) {
      console.log('Sample data:', sellerData[0]);
    }
    
    // Import sellers
    let successCount = 0;
    let errorCount = 0;
    
    for (const [index, seller] of sellerData.entries()) {
      try {
        await prisma.seller.create({
          data: seller,
        });
        successCount++;
        
        // Show progress every 5 items
        if ((index + 1) % 5 === 0 || index === sellerData.length - 1) {
          console.log(`Progress: ${index + 1}/${sellerData.length} imported - ${seller.name}`);
        }
      } catch (error) {
        errorCount++;
        console.error(`Error importing row ${index + 1}: ${seller.name} - ${error.message}`);
        
        // Stop after 3 errors
        if (errorCount >= 3) {
          console.error('Too many errors, stopping import');
          break;
        }
      }
    }
    
    console.log(`\nImport completed. Success: ${successCount}, Errors: ${errorCount}`);
    
  } catch (error) {
    console.error('Import error:', error.message);
  } finally {
    await prisma.$disconnect();
    console.log('Database disconnected');
  }
}

// Run the seeding function
seedSellers()
  .catch((error) => {
    console.error('Seeding failed:', error);
    process.exit(1);
  });
