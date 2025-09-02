const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function checkImports() {
  try {
    await prisma.$connect();
    console.log('Database connected successfully');
    
    // Check each model
    const categoryCount = await prisma.category.count();
    console.log(`Categories: ${categoryCount} records`);
    
    const departmentCount = await prisma.department.count();
    console.log(`Departments: ${departmentCount} records`);
    
    const sellerCount = await prisma.seller.count();
    console.log(`Sellers: ${sellerCount} records`);
    
    const productCount = await prisma.product.count();
    console.log(`Products: ${productCount} records`);
    
    const surveyCount = await prisma.survey.count();
    console.log(`Surveys: ${surveyCount} records`);
    
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await prisma.$disconnect();
  }
}

checkImports();
