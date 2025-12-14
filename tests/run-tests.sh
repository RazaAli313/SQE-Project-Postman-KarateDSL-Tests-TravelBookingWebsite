#!/bin/bash

# Test Execution Script for Travel Booking Website API
# This script helps run Postman and Karate tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Redis is running
check_redis() {
    print_info "Checking Redis connection..."
    if redis-cli ping > /dev/null 2>&1; then
        print_info "Redis is running ✓"
        return 0
    else
        print_warning "Redis is not running. Starting Redis..."
        if command -v brew &> /dev/null; then
            brew services start redis
            sleep 2
            if redis-cli ping > /dev/null 2>&1; then
                print_info "Redis started successfully ✓"
                return 0
            else
                print_error "Failed to start Redis. Please start it manually: brew services start redis"
                return 1
            fi
        else
            print_error "Redis is not running. Please start it manually."
            return 1
        fi
    fi
}

# Run Postman tests
run_postman_tests() {
    print_info "Running Postman tests..."
    
    # Use npx instead of global installation (avoids permission issues)
    if ! command -v npx &> /dev/null; then
        print_error "npx is not available. Please install Node.js."
        return 1
    fi
    
    mkdir -p reports
    
    # Use npx to run newman (will download if needed, no global install required)
    # Pass baseUrl as global variable to ensure it's resolved
    npx --yes newman run tests/postman/Travel_Booking_API.postman_collection.json \
        --environment tests/postman/environment.json \
        --global-var "baseUrl=http://127.0.0.1:3000" \
        --reporters cli,html,json \
        --reporter-html-export reports/postman-report.html \
        --reporter-json-export reports/postman-report.json
    
    if [ $? -eq 0 ]; then
        print_info "Postman tests completed successfully ✓"
        print_info "Report available at: reports/postman-report.html"
        
        # Convert to PDF if puppeteer is available
        if command -v node &> /dev/null && [ -f "tests/convert-to-pdf-simple.js" ]; then
            print_info "Converting Postman report to PDF..."
            node tests/convert-to-pdf-simple.js 2>/dev/null || print_warning "PDF conversion skipped (install puppeteer: npm install puppeteer)"
        fi
    else
        print_error "Postman tests failed"
        return 1
    fi
}

# Run Karate tests
run_karate_tests() {
    print_info "Running Karate DSL tests..."
    
    if ! command -v mvn &> /dev/null; then
        print_error "Maven is not installed. Please install Maven first."
        return 1
    fi
    
    if ! command -v java &> /dev/null; then
        print_error "Java is not installed. Please install Java 11+ first."
        return 1
    fi
    
    cd tests/karate
    
    mvn clean test
    
    if [ $? -eq 0 ]; then
        print_info "Karate tests completed successfully ✓"
        # Check for report in common locations
        if [ -f "target/karate-reports/karate-summary.html" ]; then
            print_info "Report available at: tests/karate/target/karate-reports/karate-summary.html"
        elif [ -f "target/karate-reports/index.html" ]; then
            print_info "Report available at: tests/karate/target/karate-reports/index.html"
        else
            print_info "Reports generated in: tests/karate/target/"
            find target -name "*.html" -type f 2>/dev/null | head -3
        fi
        cd ../..
        
        # Convert to PDF if puppeteer is available
        if command -v node &> /dev/null && [ -f "tests/convert-to-pdf-simple.js" ]; then
            print_info "Converting Karate report to PDF..."
            node tests/convert-to-pdf-simple.js 2>/dev/null || print_warning "PDF conversion skipped (install puppeteer: npm install puppeteer)"
        fi
    else
        print_error "Karate tests failed"
        cd ../..
        return 1
    fi
}

# Run security scan
run_security_scan() {
    print_info "Running security vulnerability scan..."
    
    cd backend
    
    if [ -f "package.json" ]; then
        npm audit --audit-level=moderate
        print_info "Security scan completed"
    else
        print_warning "package.json not found in backend directory"
    fi
    
    cd ..
}

# Main menu
show_menu() {
    echo ""
    echo "=========================================="
    echo "  Travel Booking Website - Test Runner"
    echo "=========================================="
    echo ""
    echo "1. Run Postman Tests"
    echo "2. Run Karate DSL Tests"
    echo "3. Run All Tests"
    echo "4. Run Security Scan"
    echo "5. Check Redis Status"
    echo "6. Exit"
    echo ""
    read -p "Select an option (1-6): " choice
    
    case $choice in
        1)
            check_redis
            run_postman_tests
            ;;
        2)
            check_redis
            run_karate_tests
            ;;
        3)
            check_redis
            run_postman_tests
            run_karate_tests
            print_info "All tests completed!"
            ;;
        4)
            run_security_scan
            ;;
        5)
            check_redis
            ;;
        6)
            print_info "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid option. Please select 1-6."
            show_menu
            ;;
    esac
}

# Check if script is run with arguments
if [ $# -eq 0 ]; then
    show_menu
else
    case $1 in
        --postman)
            check_redis
            run_postman_tests
            ;;
        --karate)
            check_redis
            run_karate_tests
            ;;
        --all)
            check_redis
            run_postman_tests
            run_karate_tests
            ;;
        --security)
            run_security_scan
            ;;
        --redis)
            check_redis
            ;;
        --help)
            echo "Usage: ./run-tests.sh [OPTION]"
            echo ""
            echo "Options:"
            echo "  --postman    Run Postman tests"
            echo "  --karate     Run Karate DSL tests"
            echo "  --all        Run all tests"
            echo "  --security   Run security scan"
            echo "  --redis      Check Redis status"
            echo "  --help       Show this help message"
            echo ""
            echo "If no option is provided, an interactive menu will be shown."
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
fi

