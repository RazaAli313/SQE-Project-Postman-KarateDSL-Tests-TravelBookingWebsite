#!/usr/bin/env node

/**
 * Simple PDF conversion using file:// protocol
 * Alternative to puppeteer that works better on macOS
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

    console.log(`📄 Converting ${path.basename(htmlPath)} to PDF...`);
    
    const browser = await puppeteer.launch({
      headless: 'new',
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu'
      ]
    });
    
    const page = await browser.newPage();
    
    // Use file:// protocol for local files
    const fileUrl = `file://${path.resolve(htmlPath)}`;
    await page.goto(fileUrl, {
      waitUntil: 'networkidle0',
      timeout: 30000
    });
    
    // Wait a bit for any dynamic content (using setTimeout instead of deprecated waitForTimeout)
    await new Promise(resolve => setTimeout(resolve, 2000));
    
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
    if (error.message.includes('Browser closed') || error.message.includes('timeout')) {
      console.error(`   Try: npm install puppeteer --save-dev`);
    }
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
      pdf: path.join(reportsDir, 'karate-report.pdf'),
      // Alternative paths to check
      altPaths: [
        path.join(projectRoot, 'tests', 'karate', 'target', 'karate-reports', 'index.html'),
        path.join(projectRoot, 'tests', 'karate', 'target', 'surefire-reports', 'karate-summary.html'),
        path.join(projectRoot, 'tests', 'karate', 'target', 'karate-reports', 'karate-summary.html')
      ]
    }
  ];
  
  console.log('🔄 Converting test reports to PDF...\n');
  
  let successCount = 0;
  
  for (const conversion of conversions) {
    let htmlPath = conversion.html;
    
    // Check alternative paths if main path doesn't exist
    if (!fs.existsSync(htmlPath) && conversion.altPaths) {
      for (const altPath of conversion.altPaths) {
        if (fs.existsSync(altPath)) {
          htmlPath = altPath;
          console.log(`📋 Found ${conversion.name} at alternative path: ${path.basename(altPath)}`);
          break;
        }
      }
    }
    
    if (fs.existsSync(htmlPath)) {
      const success = await convertHtmlToPdf(htmlPath, conversion.pdf);
      if (success) successCount++;
    } else {
      console.log(`⚠️  ${conversion.name} HTML not found: ${path.basename(conversion.html)}`);
      console.log(`   Expected location: ${conversion.html}`);
      if (conversion.altPaths) {
        console.log(`   Alternative locations checked:`);
        conversion.altPaths.forEach(p => console.log(`     - ${p}`));
      }
      console.log(`   Run tests first to generate the report: ./tests/run-tests.sh --karate\n`);
    }
  }
  
  if (successCount > 0) {
    console.log(`\n✨ Conversion complete! ${successCount}/${conversions.length} PDFs created.`);
    console.log(`📁 PDFs saved in: ${reportsDir}`);
  } else {
    console.log(`\n⚠️  No PDFs were created.`);
    console.log(`💡 Tip: Install puppeteer with: npm install --save-dev puppeteer`);
  }
}

main().catch(console.error);

