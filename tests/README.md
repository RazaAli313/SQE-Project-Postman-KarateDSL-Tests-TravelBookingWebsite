# Test Documentation and Scripts

This directory contains comprehensive test documentation, automation scripts, and test execution reports for the Travel Booking Website API.

## Directory Structure

```
tests/
├── postman/                          # Postman collection and environment
│   ├── Travel_Booking_API.postman_collection.json
│   └── environment.json
├── karate/                           # Karate DSL test scripts
│   ├── pom.xml
│   ├── src/test/java/com/travelbooking/
│   │   ├── TestRunner.java
│   │   └── features/
│   │       ├── UserManagement.feature
│   │       ├── FlightManagement.feature
│   │       ├── HotelManagement.feature
│   │       ├── BookingManagement.feature
│   │       ├── PaymentManagement.feature
│   │       ├── PlaceManagement.feature
│   │       ├── MessageManagement.feature
│   │       └── SecurityTests.feature
│   └── README.md
├── TEST_DOCUMENTATION.md             # Main test documentation
├── TEST_EXECUTION_REPORT_TEMPLATE.md # Test execution report template
├── PERFORMANCE_TESTING.md            # Performance testing guide
├── SECURITY_TESTING.md               # Security testing guide
└── README.md                         # This file
```

## Quick Start

### Prerequisites

1. **Node.js** (v16 or higher)
2. **Java** (v11 or higher) - for Karate tests
3. **Maven** (v3.6 or higher) - for Karate tests
4. **Redis** (Local on Mac) - for OTP functionality
5. **Postman** (optional, for GUI) or **Newman** (CLI)

### Setup

1. **Start Redis (Local Mac)**:
   ```bash
   # Using Homebrew
   brew services start redis
   
   # Or start manually
   redis-server
   
   # Verify Redis is running
   redis-cli ping
   # Should return: PONG
   ```

2. **Install Newman (Postman CLI)**:
   ```bash
   npm install -g newman newman-reporter-html
   ```

3. **Setup Karate Tests**:
   ```bash
   cd tests/karate
   mvn clean install
   ```

## Running Tests

### Postman Collection Tests

#### Using Newman (CLI):
```bash
# Run all tests
newman run tests/postman/Travel_Booking_API.postman_collection.json \
  --environment tests/postman/environment.json \
  --reporters html,json \
  --reporter-html-export reports/postman-report.html \
  --reporter-json-export reports/postman-report.json

# Run specific folder
newman run tests/postman/Travel_Booking_API.postman_collection.json \
  --folder "User Management" \
  --environment tests/postman/environment.json
```

#### Using Postman GUI:
1. Import `tests/postman/Travel_Booking_API.postman_collection.json`
2. Import `tests/postman/environment.json`
3. Run collection from Postman Runner

### Karate DSL Tests

```bash
# Navigate to karate directory
cd tests/karate

# Run all tests
mvn test

# Run specific feature
mvn test -Dtest=TestRunner#testUserManagement

# Run with HTML report
mvn test -Dkarate.options="--plugin html:target/karate-reports"

# Run with parallel execution
mvn test -Dkarate.options="--threads 5"
```

## Test Documentation

### Main Documentation
- **TEST_DOCUMENTATION.md**: Comprehensive test cases, execution reports, automation scripts, performance metrics, security checks, and CI/CD integration

### Specialized Documentation
- **PERFORMANCE_TESTING.md**: Performance testing strategy, scenarios, metrics, and execution procedures
- **SECURITY_TESTING.md**: Security testing strategy, OWASP Top 10 test cases, and security best practices
- **TEST_EXECUTION_REPORT_TEMPLATE.md**: Template for test execution reports

## Test Coverage

### Functional Testing
- ✅ User Management (Registration, Login, Email Verification, Password Management)
- ✅ Flight Management (CRUD operations)
- ✅ Hotel Management (CRUD operations)
- ✅ Place Management (CRUD operations)
- ✅ Booking Management (Create, Calculate, Save)
- ✅ Payment Management (Payment Intent Creation)
- ✅ Message Management (Send, Retrieve)

### Security Testing
- ✅ Authentication & Authorization
- ✅ Input Validation (XSS, SQL Injection)
- ✅ Data Protection
- ✅ Session Management
- ✅ API Security (CORS, Rate Limiting)

### Performance Testing
- ✅ Load Testing
- ✅ Stress Testing
- ✅ Endurance Testing
- ✅ Spike Testing

## CI/CD Integration

The project includes GitHub Actions workflow for automated testing:

**Location**: `.github/workflows/api-tests.yml`

**Features**:
- Automated Postman tests on push/PR
- Automated Karate tests on push/PR
- Security vulnerability scanning
- Test report generation and artifact upload

## Environment Configuration

### Local Development
- **API Base URL**: `http://localhost:8080/api/v1`
- **Redis**: Local (default: `localhost:6379`)
- **MongoDB**: Local or cloud connection

### Production/Staging
- **API Base URL**: `http://localhost:3000/api/v1` (local) or `https://travel-booking-website-6x9h.onrender.com/api/v1` (production)
- **Redis**: Local (Mac) or cloud
- **MongoDB**: Cloud connection

Update environment variables in:
- `tests/postman/environment.json` (for Postman)
- Feature files in `tests/karate/src/test/java/com/travelbooking/features/` (for Karate)

## Test Reports

Test reports are generated in the `reports/` directory:

- **Postman Reports**: `reports/postman-report.html`
- **Karate Reports**: `tests/karate/target/karate-reports/karate-summary.html`
- **Performance Reports**: `reports/performance/`
- **Security Reports**: `reports/security/`

## Troubleshooting

### Redis Connection Issues

If you encounter Redis connection errors:

1. **Check if Redis is running**:
   ```bash
   redis-cli ping
   ```

2. **Check Redis configuration** in `backend/config/redis.js`:
   - For local Redis: `host: 'localhost'`, `port: 6379`
   - No password required for local Redis

3. **Start Redis**:
   ```bash
   brew services start redis
   ```

### Karate Test Issues

1. **Java version**: Ensure Java 11+ is installed
   ```bash
   java -version
   ```

2. **Maven issues**: Clean and rebuild
   ```bash
   cd tests/karate
   mvn clean install
   ```

### Postman/Newman Issues

1. **Collection not found**: Check file paths
2. **Environment variables**: Ensure environment.json is properly configured
3. **Authentication**: Update tokens in environment file

## Contributing

When adding new test cases:

1. Add test case to `TEST_DOCUMENTATION.md`
2. Add request to Postman collection
3. Add feature to Karate (if applicable)
4. Update test execution report template
5. Update this README if needed

## Resources

- [Postman Documentation](https://learning.postman.com/docs/)
- [Newman Documentation](https://github.com/postmanlabs/newman)
- [Karate DSL Documentation](https://karatelabs.github.io/karate/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Redis Documentation](https://redis.io/documentation)

---

**Last Updated**: [Date]  
**Maintained By**: SQE Project Team

