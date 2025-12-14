#!/bin/bash

# Convert Postman and Karate test reports to PDF
# This script converts existing HTML reports to PDF using Puppeteer

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Main execution
main() {
    print_info "Converting test reports to PDF...\n"
    
    # Check if Node.js and conversion script exist
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi
    
    if [ ! -f "tests/convert-to-pdf-simple.js" ]; then
        print_error "PDF conversion script not found: tests/convert-to-pdf-simple.js"
        exit 1
    fi
    
    # Run the conversion
    node tests/convert-to-pdf-simple.js
    
    if [ $? -eq 0 ]; then
        print_info "\n✨ PDF conversion completed!"
        print_info "📁 PDFs are saved in: reports/"
    else
        print_error "\n❌ PDF conversion failed."
        print_info "💡 Tip: Install puppeteer with: npm install --save-dev puppeteer"
        exit 1
    fi
}

main
