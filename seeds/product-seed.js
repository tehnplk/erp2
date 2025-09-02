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
        if (columns.length >= 14) {
          result.push({
            code: columns[0].trim(),
            category: columns[1].trim(),
            name: columns[2].trim(),
            type: columns[3].trim(),
            subtype: columns[4].trim(),
            unit: columns[5].trim(),
            costPrice: columns[6].trim() ? parseFloat(columns[6].trim()) : null,
            sellPrice: columns[7].trim() ? parseFloat(columns[7].trim()) : null,
            stockBalance: columns[8].trim() ? parseInt(columns[8].trim()) : null,
            stockValue: columns[9].trim() ? parseFloat(columns[9].trim()) : null,
            sellerCode: columns[10].trim() || null,
            image: columns[11].trim() || null,
            flagActivate: columns[12].trim() === 'TRUE',
            adminNote: columns[13].trim() || null,
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

async function seedProducts() {
  try {
    console.log('Starting product seeding...');
    
    // Connect to database
    await prisma.$connect();
    console.log('Database connected');
    
    // Truncate table and reset ID sequence
    console.log('Truncating Product table...');
    await prisma.$executeRaw`TRUNCATE TABLE "Product" RESTART IDENTITY CASCADE`;
    console.log('Table truncated and ID reset');
    
    // Read product data from CSV
    const csvPath = path.join(__dirname, 'รายการสินค้า.csv');
    console.log('Reading CSV file from:', csvPath);
    
    const productData = parseCSV(csvPath);
    console.log(`Found ${productData.length} products to import`);
    
    // Show sample data
    if (productData.length > 0) {
      console.log('Sample data:', productData[0]);
    }
    
    // Import products
    let successCount = 0;
    let errorCount = 0;
    
    for (const [index, product] of productData.entries()) {
      try {
        await prisma.product.create({
          data: product,
        });
        successCount++;
        
        // Show progress every 50 items
        if ((index + 1) % 50 === 0 || index === productData.length - 1) {
          console.log(`Progress: ${index + 1}/${productData.length} imported - ${product.name}`);
        }
      } catch (error) {
        errorCount++;
        console.error(`Error importing row ${index + 1}: ${product.name} - ${error.message}`);
        
        // Stop after 5 errors
        if (errorCount >= 5) {
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
seedProducts()
  .catch((error) => {
    console.error('Seeding failed:', error);
    process.exit(1);
  });
