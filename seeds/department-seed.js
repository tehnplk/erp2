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
        if (columns.length >= 2) {
          const departmentName = columns[1].trim();
          if (departmentName) {
            result.push({
              name: departmentName
            });
          }
        }
      }
    }
    
    return result;
  } catch (error) {
    console.error('Error reading CSV file:', error);
    process.exit(1);
  }
}

async function seedDepartments() {
  try {
    console.log('Starting department seeding...');
    
    // Connect to database
    await prisma.$connect();
    console.log('Database connected');
    
    // Truncate table and reset ID sequence
    console.log('Truncating Department table...');
    await prisma.$executeRaw`TRUNCATE TABLE "Department" RESTART IDENTITY CASCADE`;
    console.log('Table truncated and ID reset');
    
    // Read department data from CSV
    const csvPath = path.join(__dirname, 'department.csv');
    console.log('Reading CSV file from:', csvPath);
    
    const departmentData = parseCSV(csvPath);
    console.log(`Found ${departmentData.length} departments to import`);
    
    // Show sample data
    if (departmentData.length > 0) {
      console.log('Sample data:', departmentData[0]);
    }
    
    // Import departments
    let successCount = 0;
    let errorCount = 0;
    
    for (const [index, dept] of departmentData.entries()) {
      try {
        await prisma.department.create({
          data: dept,
        });
        successCount++;
        
        // Show progress every 10 items
        if ((index + 1) % 10 === 0 || index === departmentData.length - 1) {
          console.log(`Progress: ${index + 1}/${departmentData.length} imported`);
        }
      } catch (error) {
        errorCount++;
        console.error(`Error importing row ${index + 1}: ${dept.name} - ${error.message}`);
        
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
seedDepartments()
  .catch((error) => {
    console.error('Seeding failed:', error);
    process.exit(1);
  });
