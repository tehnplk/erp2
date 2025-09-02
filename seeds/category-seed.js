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
        if (columns.length >= 3) {
          result.push({
            category: columns[0].trim(),
            type: columns[1].trim(),
            subtype: columns[2].trim(),
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

async function seedCategories() {
  try {
    console.log('Starting category seeding...');
    
    // Connect to database
    await prisma.$connect();
    console.log('Database connected');
    
    // Truncate table and reset ID sequence
    console.log('Truncating Category table...');
    await prisma.$executeRaw`TRUNCATE TABLE "Category" RESTART IDENTITY CASCADE`;
    console.log('Table truncated and ID reset');
    
    // Read category data from CSV
    const csvPath = path.join(__dirname, 'category.csv');
    console.log('Reading CSV file from:', csvPath);
    
    const categoryData = parseCSV(csvPath);
    console.log(`Found ${categoryData.length} categories to import`);
    
    // Show sample data
    if (categoryData.length > 0) {
      console.log('Sample data:', categoryData[0]);
    }
    
    // Import categories
    let successCount = 0;
    let errorCount = 0;
    
    for (const [index, cat] of categoryData.entries()) {
      try {
        await prisma.category.create({
          data: cat,
        });
        successCount++;
        
        // Show progress every 100 items
        if ((index + 1) % 100 === 0 || index === categoryData.length - 1) {
          console.log(`Progress: ${index + 1}/${categoryData.length} imported`);
        }
      } catch (error) {
        errorCount++;
        console.error(`Error importing row ${index + 1}: ${cat.category} - ${error}`);
        
        // Stop after 5 errors
        if (errorCount >= 5) {
          console.error('Too many errors, stopping import');
          break;
        }
      }
    }
    
    console.log(`\nImport completed. Success: ${successCount}, Errors: ${errorCount}`);
    
  } catch (error) {
    console.error('Import error:', error);
  } finally {
    await prisma.$disconnect();
    console.log('Database disconnected');
  }
}

// Run the seeding function
seedCategories()
  .catch((error) => {
    console.error('Seeding failed:', error);
    process.exit(1);
  });
