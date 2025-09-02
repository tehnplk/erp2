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
        // Handle CSV with potential commas in quoted fields
        const columns = [];
        let current = '';
        let inQuotes = false;
        
        for (let j = 0; j < line.length; j++) {
          const char = line[j];
          if (char === '"') {
            inQuotes = !inQuotes;
          } else if (char === ',' && !inQuotes) {
            columns.push(current);
            current = '';
          } else {
            current += char;
          }
        }
        columns.push(current); // Add the last column
        
        if (columns.length >= 8) {
          // Clean and validate data with better error handling
          const requestedAmount = columns[5] ? columns[5].trim() : '0';
          const pricePerUnit = columns[7] ? columns[7].trim() : '';
          const requestingDept = columns[8] ? columns[8].trim() : '';
          const approvedQuota = columns[9] ? columns[9].trim() : '0';
          
          // Skip rows with invalid data
          if (!columns[0] || !columns[4]) {
            continue;
          }
          
          result.push({
            productId: columns[0].trim(),
            category: columns[1] ? columns[1].trim() : '',
            type: columns[2] ? columns[2].trim() : '',
            subtype: columns[3] ? columns[3].trim() : '',
            productName: columns[4].trim(),
            requestedAmount: !isNaN(parseInt(requestedAmount)) ? parseInt(requestedAmount) : 0,
            unit: columns[6] ? columns[6].trim() : '',
            pricePerUnit: !isNaN(parseFloat(pricePerUnit)) ? parseFloat(pricePerUnit) : null,
            requestingDept: requestingDept,
            approvedQuota: !isNaN(parseInt(approvedQuota)) ? parseInt(approvedQuota) : 0,
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

async function seedSurveys() {
  try {
    console.log('Starting survey seeding...');
    
    // Connect to database
    await prisma.$connect();
    console.log('Database connected');
    
    // Truncate table and reset ID sequence
    console.log('Truncating Survey table...');
    await prisma.$executeRaw`TRUNCATE TABLE "Survey" RESTART IDENTITY CASCADE`;
    console.log('Table truncated and ID reset');
    
    // Read survey data from CSV
    const csvPath = path.join(__dirname, 'สำรวจความต้องการใช้.csv');
    console.log('Reading CSV file from:', csvPath);
    
    const surveyData = parseCSV(csvPath);
    console.log(`Found ${surveyData.length} survey records to import`);
    
    // Show sample data
    if (surveyData.length > 0) {
      console.log('Sample data:', surveyData[0]);
    }
    
    // Import surveys
    let successCount = 0;
    let errorCount = 0;
    
    for (const [index, survey] of surveyData.entries()) {
      try {
        await prisma.survey.create({
          data: survey,
        });
        successCount++;
        
        // Show progress every 50 items
        if ((index + 1) % 50 === 0 || index === surveyData.length - 1) {
          console.log(`Progress: ${index + 1}/${surveyData.length} imported - ${survey.productName}`);
        }
      } catch (error) {
        errorCount++;
        console.error(`Error importing row ${index + 1}: ${survey.productName} - ${error.message}`);
        
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
seedSurveys()
  .catch((error) => {
    console.error('Seeding failed:', error);
    process.exit(1);
  });
