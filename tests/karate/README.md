# Karate DSL API Tests

This directory contains Karate DSL test scripts for the Travel Booking Website API.

## Prerequisites

- Java 11 or higher
- Maven 3.6 or higher
- Local Redis server running (for OTP functionality)

## Setup

1. Install Maven dependencies:
```bash
cd tests/karate
mvn clean install
```

2. Ensure Redis is running locally:
```bash
# On Mac, if installed via Homebrew
brew services start redis

# Or start manually
redis-server
```

## Running Tests

### Run all tests
```bash
mvn test
```

### Run specific feature
```bash
mvn test -Dtest=TestRunner#testUserManagement
```

### Run with HTML report
```bash
mvn test -Dkarate.options="--plugin html:target/karate-reports"
```

### Run with parallel execution
```bash
mvn test -Dkarate.options="--threads 5"
```

## Test Reports

After execution, reports are generated in:
- `target/karate-reports/karate-summary.html` - HTML summary report
- `target/surefire-reports/` - JUnit XML reports

## Features

- **UserManagement.feature**: User registration, login, email verification, password management
- **FlightManagement.feature**: Flight CRUD operations
- **HotelManagement.feature**: Hotel CRUD operations
- **BookingManagement.feature**: Booking creation and management
- **PaymentManagement.feature**: Payment intent creation
- **PlaceManagement.feature**: Place CRUD operations
- **MessageManagement.feature**: Contact message handling
- **SecurityTests.feature**: Security vulnerability tests

## Configuration

Update the base URL in each feature file if testing against a different environment:
```gherkin
* def baseUrl = 'http://localhost:3000/api/v1'  # For local development
# Or: 'https://travel-booking-website-6x9h.onrender.com/api/v1'  # For production
```

## Notes

- Tests use unique email addresses with timestamps to avoid conflicts
- Admin token is required for admin-only endpoints (configure admin user credentials)
- Some tests depend on existing data (e.g., flight IDs, booking IDs)

