#!/bin/bash

# Run Karate tests with HTML report generation
# This script ensures HTML reports are generated

set -e

cd "$(dirname "$0")"

echo "🔧 Running Karate tests with HTML report generation..."

# Clean previous reports
rm -rf target/karate-reports

# Run tests with explicit HTML report plugin
mvn clean test -Dkarate.options="--plugin html:target/karate-reports --plugin junit:target/karate-reports"

if [ $? -eq 0 ]; then
    echo "✅ Tests completed successfully"
    
    # Check if report was generated
    if [ -f "target/karate-reports/karate-summary.html" ]; then
        echo "✅ HTML report generated: target/karate-reports/karate-summary.html"
    else
        echo "⚠️  HTML report not found. Checking for alternative locations..."
        find target -name "*.html" -type f 2>/dev/null | head -5
    fi
else
    echo "❌ Tests failed"
    exit 1
fi

