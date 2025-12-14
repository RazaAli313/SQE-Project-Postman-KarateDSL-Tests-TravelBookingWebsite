#!/usr/bin/env node

/**
 * Convert Postman and Karate test reports to PDF
 * Requires: npm install puppeteer
 */

const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

async function convertHtmlToPdf(htmlPath, pdfPath) {
  try {
    if (!fs.existsSync(htmlPath)) {
      console.error(`❌ HTML file not found: ${htmlPath}`);
      return false;
    }

    console.log(`📄 Converting ${htmlPath} to PDF...`);
    
    const browser = await puppeteer.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'],
      timeout: 60000
    });
    
    const page = await browser.newPage();
    
    // Read HTML file
    const htmlContent = fs.readFileSync(htmlPath, 'utf8');
    
    // Set content
    await page.setContent(htmlContent, {
      waitUntil: 'networkidle0'
    });
    
    // Generate PDF
    await page.pdf({
      path: pdfPath,
      format: 'A4',
      printBackground: true,
      margin: {
        top: '20mm',
        right: '15mm',
        bottom: '20mm',
        left: '15mm'
      }
    });
    
    await browser.close();
    
    console.log(`✅ PDF created: ${pdfPath}`);
    return true;
  } catch (error) {
    console.error(`❌ Error converting to PDF: ${error.message}`);
    return false;
  }
}

async function main() {
  const projectRoot = path.join(__dirname, '..');
  const reportsDir = path.join(projectRoot, 'reports');
  
  // Ensure reports directory exists
  if (!fs.existsSync(reportsDir)) {
    fs.mkdirSync(reportsDir, { recursive: true });
  }
  
  const conversions = [
    {
      name: 'Postman Report',
      html: path.join(reportsDir, 'postman-report.html'),
      pdf: path.join(reportsDir, 'postman-report.pdf')
    },
    {
      name: 'Karate Report',
      html: path.join(projectRoot, 'tests', 'karate', 'target', 'karate-reports', 'karate-summary.html'),
      pdf: path.join(reportsDir, 'karate-report.pdf')
    }
  ];
  
  console.log('🔄 Converting test reports to PDF...\n');
  
  let successCount = 0;
  
  for (const conversion of conversions) {
    if (fs.existsSync(conversion.html)) {
      const success = await convertHtmlToPdf(conversion.html, conversion.pdf);
      if (success) successCount++;
    } else {
      console.log(`⚠️  ${conversion.name} HTML not found: ${conversion.html}`);
      console.log(`   Run tests first to generate the report.\n`);
    }
  }
  
  console.log(`\n✨ Conversion complete! ${successCount}/${conversions.length} PDFs created.`);
  console.log(`📁 PDFs saved in: ${reportsDir}`);
}

main().catch(console.error);

