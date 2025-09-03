const { PrismaClient } = require('@prisma/client');
const XLSX = require('xlsx');
const path = require('path');

const prisma = new PrismaClient();

async function seedProducts() {
  try {
    // Load the Excel file
    const filePath = path.join(__dirname, 'Product.xlsx');
    const workbook = XLSX.readFile(filePath);
    
    // Get the first worksheet
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    
    // Convert to JSON
    const data = XLSX.utils.sheet_to_json(worksheet);
    
    console.log(`Found ${data.length} products in the Excel file`);
    
    // Process each row
    let successCount = 0;
    
    for (const row of data) {
      try {
        // Map Excel columns to Prisma model fields
        // You may need to adjust these field names based on your Excel structure
        const productData = {
          code: row.code || row.Code || row.productCode || '',
          category: row.category || row.Category || '',
          name: row.name || row.Name || row.productName || '',
          type: row.type || row.Type || '',
          subtype: row.subtype || row.Subtype || row.subType || '',
          unit: row.unit || row.Unit || '',
          costPrice: row.costPrice !== undefined ? parseFloat(row.costPrice) : null,
          sellPrice: row.sellPrice !== undefined ? parseFloat(row.sellPrice) : null,
          stockBalance: row.stockBalance !== undefined ? parseInt(row.stockBalance) : null,
          stockValue: row.stockValue !== undefined ? parseFloat(row.stockValue) : null,
          sellerCode: row.sellerCode || row.SellerCode || null,
          image: row.image || row.Image || null,
          flagActivate: row.flagActivate !== undefined ? Boolean(row.flagActivate) : true,
          adminNote: row.adminNote || row.AdminNote || null,
        };
        
        // Skip rows without a product code
        if (!productData.code) {
          console.log('Skipping row without product code');
          continue;
        }
        
        // Create or update product
        const product = await prisma.product.upsert({
          where: { code: productData.code },
          update: productData,
          create: productData,
        });
        
        successCount++;
        console.log(`Processed product: ${product.code}`);
      } catch (error) {
        console.error(`Error processing row: ${error.message}`);
        console.error('Row data:', row);
      }
    }
    
    console.log(`Successfully processed ${successCount} products`);
  } catch (error) {
    console.error('Error seeding products:', error);
  } finally {
    await prisma.$disconnect();
  }
}

// Run the seed function
seedProducts().catch(console.error);
