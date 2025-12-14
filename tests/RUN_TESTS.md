# How to Run Tests

## Postman Tests (Using Newman)

### Quick Run
```bash
# From project root
npx newman run tests/postman/Travel_Booking_API.postman_collection.json \
  --environment tests/postman/environment.json \
  --reporters cli,html \
  --reporter-html-export reports/postman-report.html
```

### View Results
Open `reports/postman-report.html` in your browser to see detailed test results.

---

## Karate DSL Tests

### Prerequisites
1. **Java 11+** (already installed ✅)
2. **Maven** - Install using one of these methods:

#### Option 1: Install Maven via Homebrew
```bash
brew install maven
```

#### Option 2: Download Maven Manually
1. Download from: https://maven.apache.org/download.cgi
2. Extract and add to PATH

#### Option 3: Use Maven Wrapper (if available)
```bash
cd tests/karate
./mvnw test
```

### Run Karate Tests
```bash
# Navigate to karate directory
cd tests/karate

# Install dependencies and run tests
mvn clean test

# Run with HTML report
mvn test -Dkarate.options="--plugin html:target/karate-reports"

# Run specific feature
mvn test -Dtest=TestRunner#testUserManagement
```

### View Karate Results
After running, open:
- `tests/karate/target/karate-reports/karate-summary.html`

---

## Test Results Summary

### Postman Tests (Just Ran)
✅ **22 requests executed**
✅ **16 assertions passed**
⚠️ **2 assertions failed**:
1. Response time > 500ms (one test)
2. Payment client secret missing (needs Stripe key configured)

### Test Status:
- ✅ User Registration - Working
- ✅ User Login - Working  
- ✅ Flight/Hotel/Place GET - Working
- ⚠️ Admin endpoints - Need admin token
- ⚠️ Email/OTP - Need email configuration
- ⚠️ Payment - Need Stripe key

---

## Next Steps

1. **Configure Missing Environment Variables**:
   - `AUTH_MAIL_USER` and `AUTH_MAIL_PASS` for email tests
   - `STRIPE_SECRET_KEY` for payment tests
   - Create admin user for admin endpoint tests

2. **Install Maven for Karate Tests**:
   ```bash
   brew install maven
   ```

3. **Run Full Test Suite**:
   ```bash
   # Postman tests
   npx newman run tests/postman/Travel_Booking_API.postman_collection.json \
     --environment tests/postman/environment.json \
     --reporters cli,html \
     --reporter-html-export reports/postman-report.html
   
   # Karate tests (after Maven is installed)
   cd tests/karate && mvn test
   ```

---

## Troubleshooting

### Postman Tests Fail
- Check backend is running: `curl http://localhost:3000/`
- Check Redis is running: `redis-cli ping`
- Verify environment variables in `backend/.env`

### Karate Tests Fail
- Ensure Java 11+ is installed: `java -version`
- Install Maven: `brew install maven`
- Check Maven: `mvn --version`

---

**Last Updated**: [Date]

