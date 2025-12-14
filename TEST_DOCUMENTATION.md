# Test Documentation - Travel Booking Website

## Table of Contents
1. [Overview](#overview)
2. [Test Strategy](#test-strategy)
3. [Test Cases](#test-cases)
4. [Test Execution Reports](#test-execution-reports)
5. [Automation Scripts](#automation-scripts)
6. [Performance Metrics](#performance-metrics)
7. [Security Checks](#security-checks)
8. [CI/CD Integration](#cicd-integration)

---

## Overview

This document provides comprehensive test documentation for the Travel Booking Website API. The application is built with Node.js/Express backend and includes the following modules:

- **User Management**: Registration, login, email verification, password management
- **Booking Management**: Flight and hotel bookings
- **Payment Processing**: Stripe integration
- **Content Management**: Places, hotels, flights, messages

**Base URL**: `https://travel-booking-website-6x9h.onrender.com/api/v1`

**Testing Tools**:
- Postman (Manual & Automated Testing)
- Karate DSL (BDD-style API Testing)
- Performance Testing (Load Testing)
- Security Testing (OWASP Top 10)

---

## Test Strategy

### Testing Levels
1. **Unit Testing**: Individual components and functions
2. **Integration Testing**: API endpoints and database interactions
3. **System Testing**: End-to-end workflows
4. **Performance Testing**: Load and stress testing
5. **Security Testing**: Authentication, authorization, input validation

### Testing Approach
- **Manual Testing**: Initial exploratory testing using Postman
- **Automated Testing**: Karate DSL for regression and CI/CD integration
- **Performance Testing**: Load testing with Postman/Newman
- **Security Testing**: OWASP security checklist validation

---

## Test Cases

### 1. User Management Module

#### TC-001: User Registration - Valid Data
- **Priority**: High
- **Description**: Register a new user with valid data
- **Preconditions**: None
- **Test Steps**:
  1. Send POST request to `/api/v1/users/register`
  2. Include valid fullname, email, password in request body
- **Expected Result**: 
  - Status Code: 201
  - Response contains userId
  - Message: "User registered successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-002: User Registration - Duplicate Email
- **Priority**: High
- **Description**: Attempt to register with existing email
- **Preconditions**: User with email already exists
- **Test Steps**:
  1. Send POST request to `/api/v1/users/register`
  2. Use existing email address
- **Expected Result**: 
  - Status Code: 409
  - Message: "Email already in use"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-003: User Registration - Missing Fields
- **Priority**: High
- **Description**: Register without required fields
- **Preconditions**: None
- **Test Steps**:
  1. Send POST request to `/api/v1/users/register`
  2. Omit one or more required fields (fullname, email, password)
- **Expected Result**: 
  - Status Code: 400
  - Message: "All fields are required"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-004: User Login - Valid Credentials
- **Priority**: High
- **Description**: Login with valid email and password
- **Preconditions**: User exists and is verified
- **Test Steps**:
  1. Send POST request to `/api/v1/users/login`
  2. Include valid email and password
- **Expected Result**: 
  - Status Code: 200
  - Response contains JWT token
  - User data returned
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-005: User Login - Invalid Credentials
- **Priority**: High
- **Description**: Login with incorrect password
- **Preconditions**: User exists
- **Test Steps**:
  1. Send POST request to `/api/v1/users/login`
  2. Use incorrect password
- **Expected Result**: 
  - Status Code: 401
  - Message: "Invalid credentials"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-006: Email Verification - Valid OTP
- **Priority**: Medium
- **Description**: Verify email with correct OTP
- **Preconditions**: User registered, OTP sent to email
- **Test Steps**:
  1. Send POST request to `/api/v1/users/verify-email`
  2. Include email and valid OTP
- **Expected Result**: 
  - Status Code: 200
  - Message: "Email verified successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-007: Email Verification - Invalid OTP
- **Priority**: Medium
- **Description**: Verify email with incorrect OTP
- **Preconditions**: User registered, OTP sent
- **Test Steps**:
  1. Send POST request to `/api/v1/users/verify-email`
  2. Include invalid OTP
- **Expected Result**: 
  - Status Code: 400
  - Message: "Invalid or expired OTP"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-008: Resend OTP
- **Priority**: Medium
- **Description**: Request new OTP for email verification
- **Preconditions**: User registered
- **Test Steps**:
  1. Send POST request to `/api/v1/users/resend-otp`
  2. Include email address
- **Expected Result**: 
  - Status Code: 200
  - Message: "OTP sent successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-009: Update Password - Authenticated User
- **Priority**: High
- **Description**: Update password for logged-in user
- **Preconditions**: User logged in, valid JWT token
- **Test Steps**:
  1. Send PUT request to `/api/v1/users/update-password`
  2. Include Authorization header with JWT token
  3. Include oldPassword and newPassword
- **Expected Result**: 
  - Status Code: 200
  - Message: "Password updated successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-010: Update Password - Unauthenticated
- **Priority**: High
- **Description**: Attempt to update password without token
- **Preconditions**: None
- **Test Steps**:
  1. Send PUT request to `/api/v1/users/update-password`
  2. Do not include Authorization header
- **Expected Result**: 
  - Status Code: 401
  - Message: "Unauthorized"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-011: Forget Password - Valid Email
- **Priority**: Medium
- **Description**: Request password reset OTP
- **Preconditions**: User exists
- **Test Steps**:
  1. Send POST request to `/api/v1/users/forget-password`
  2. Include email address
- **Expected Result**: 
  - Status Code: 200
  - Message: "OTP sent to email"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-012: Check OTP - Valid OTP
- **Priority**: Medium
- **Description**: Verify OTP for password reset
- **Preconditions**: OTP sent via forget password
- **Test Steps**:
  1. Send POST request to `/api/v1/users/check-otp`
  2. Include email and valid OTP
- **Expected Result**: 
  - Status Code: 200
  - Message: "OTP verified"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

### 2. Flight Management Module

#### TC-013: Get All Flights - Public Access
- **Priority**: High
- **Description**: Retrieve all available flights
- **Preconditions**: None
- **Test Steps**:
  1. Send GET request to `/api/v1/flights`
- **Expected Result**: 
  - Status Code: 200
  - Response contains array of flights
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-014: Add Flights - Admin Only
- **Priority**: High
- **Description**: Add new flights (admin only)
- **Preconditions**: User logged in as admin
- **Test Steps**:
  1. Send POST request to `/api/v1/flights`
  2. Include Authorization header with admin JWT token
  3. Include flight data in body
- **Expected Result**: 
  - Status Code: 201
  - Message: "Flights added successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-015: Add Flights - Non-Admin User
- **Priority**: High
- **Description**: Attempt to add flights as regular user
- **Preconditions**: User logged in (not admin)
- **Test Steps**:
  1. Send POST request to `/api/v1/flights`
  2. Include Authorization header with regular user token
- **Expected Result**: 
  - Status Code: 403
  - Message: "Access denied"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

### 3. Hotel Management Module

#### TC-016: Get All Hotels - Public Access
- **Priority**: High
- **Description**: Retrieve all available hotels
- **Preconditions**: None
- **Test Steps**:
  1. Send GET request to `/api/v1/hotels`
- **Expected Result**: 
  - Status Code: 200
  - Response contains array of hotels
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-017: Create Hotels - Admin Only
- **Priority**: High
- **Description**: Create new hotels (admin only)
- **Preconditions**: User logged in as admin
- **Test Steps**:
  1. Send POST request to `/api/v1/hotels`
  2. Include Authorization header with admin JWT token
  3. Include hotel data in body
- **Expected Result**: 
  - Status Code: 201
  - Message: "Hotels created successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

### 4. Place Management Module

#### TC-018: Get All Places - Public Access
- **Priority**: High
- **Description**: Retrieve all available places
- **Preconditions**: None
- **Test Steps**:
  1. Send GET request to `/api/v1/places`
- **Expected Result**: 
  - Status Code: 200
  - Response contains array of places
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-019: Add Places - Admin Only
- **Priority**: High
- **Description**: Add new places (admin only)
- **Preconditions**: User logged in as admin
- **Test Steps**:
  1. Send POST request to `/api/v1/places`
  2. Include Authorization header with admin JWT token
  3. Include place data in body
- **Expected Result**: 
  - Status Code: 201
  - Message: "Places added successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

### 5. Booking Management Module

#### TC-020: Create Booking - Valid Data
- **Priority**: High
- **Description**: Create a new booking
- **Preconditions**: None
- **Test Steps**:
  1. Send POST request to `/api/v1/booking/create`
  2. Include booking details (flight/hotel, dates, passengers)
- **Expected Result**: 
  - Status Code: 200
  - Response contains booking details
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-021: Get Total Amount
- **Priority**: High
- **Description**: Calculate total booking amount
- **Preconditions**: None
- **Test Steps**:
  1. Send POST request to `/api/v1/booking/total-amount`
  2. Include booking details
- **Expected Result**: 
  - Status Code: 200
  - Response contains total amount
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-022: Save Booking Details - Authenticated
- **Priority**: High
- **Description**: Save booking to database (authenticated)
- **Preconditions**: User logged in
- **Test Steps**:
  1. Send POST request to `/api/v1/booking/save-booking`
  2. Include Authorization header with JWT token
  3. Include booking data
- **Expected Result**: 
  - Status Code: 201
  - Message: "Booking saved successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

### 6. Payment Management Module

#### TC-023: Create Payment Intent
- **Priority**: High
- **Description**: Create Stripe payment intent
- **Preconditions**: Valid booking exists
- **Test Steps**:
  1. Send POST request to `/api/v1/payments/create-payment-intent`
  2. Include amount and booking details
- **Expected Result**: 
  - Status Code: 200
  - Response contains client secret
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

### 7. Message Management Module

#### TC-024: Send Message - Public
- **Priority**: Medium
- **Description**: Send contact message
- **Preconditions**: None
- **Test Steps**:
  1. Send POST request to `/api/v1/messages`
  2. Include message details (name, email, message)
- **Expected Result**: 
  - Status Code: 201
  - Message: "Message sent successfully"
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

#### TC-025: Get All Messages - Admin Only
- **Priority**: Medium
- **Description**: Retrieve all messages (admin only)
- **Preconditions**: User logged in as admin
- **Test Steps**:
  1. Send GET request to `/api/v1/messages`
  2. Include Authorization header with admin JWT token
- **Expected Result**: 
  - Status Code: 200
  - Response contains array of messages
- **Actual Result**: [To be filled during execution]
- **Status**: [Pass/Fail]

---

## Test Execution Reports

### Test Execution Summary Template

**Project**: Travel Booking Website  
**Test Cycle**: [Cycle Name]  
**Execution Date**: [Date]  
**Executed By**: [Tester Name]  
**Environment**: Production/Staging/Development

| Test Case ID | Test Case Name | Priority | Status | Execution Time | Notes |
|-------------|----------------|----------|--------|----------------|-------|
| TC-001 | User Registration - Valid Data | High | Pass | 2s | - |
| TC-002 | User Registration - Duplicate Email | High | Pass | 1s | - |
| ... | ... | ... | ... | ... | ... |

**Summary**:
- Total Test Cases: 25
- Passed: [Count]
- Failed: [Count]
- Blocked: [Count]
- Not Executed: [Count]
- Pass Rate: [Percentage]%

**Defects Found**: [Count]
**Critical Defects**: [Count]
**High Priority Defects**: [Count]
**Medium Priority Defects**: [Count]
**Low Priority Defects**: [Count]

---

## Automation Scripts

### Postman Collection
Location: `tests/postman/Travel_Booking_API.postman_collection.json`

### Karate DSL Tests
Location: `tests/karate/`

### Execution Instructions

#### Postman Collection Execution
```bash
# Install Newman (Postman CLI)
npm install -g newman

# Run collection
newman run tests/postman/Travel_Booking_API.postman_collection.json \
  --environment tests/postman/environment.json \
  --reporters html,json \
  --reporter-html-export reports/postman-report.html \
  --reporter-json-export reports/postman-report.json
```

#### Karate DSL Execution
```bash
# Navigate to tests directory
cd tests/karate

# Run all tests
mvn test

# Run specific feature
mvn test -Dtest=UserManagementTest

# Generate HTML report
mvn test -Dkarate.options="--plugin html:target/karate-reports"
```

---

## Performance Metrics

### Performance Test Scenarios

#### Scenario 1: Load Testing - User Registration
- **Concurrent Users**: 50
- **Duration**: 5 minutes
- **Ramp-up Time**: 1 minute
- **Expected Response Time**: < 500ms (p95)
- **Expected Throughput**: > 100 requests/second
- **Error Rate**: < 1%

#### Scenario 2: Stress Testing - Flight Search
- **Concurrent Users**: 100
- **Duration**: 10 minutes
- **Ramp-up Time**: 2 minutes
- **Expected Response Time**: < 1s (p95)
- **Expected Throughput**: > 200 requests/second
- **Error Rate**: < 0.5%

#### Scenario 3: Endurance Testing - Booking Flow
- **Concurrent Users**: 25
- **Duration**: 1 hour
- **Expected Response Time**: < 2s (p95)
- **Memory Leak Check**: No memory increase > 10%
- **Error Rate**: < 0.1%

### Performance Metrics Dashboard

| Endpoint | Avg Response Time | P95 Response Time | P99 Response Time | Throughput (req/s) | Error Rate |
|----------|-------------------|-------------------|-------------------|-------------------|------------|
| POST /users/register | [ms] | [ms] | [ms] | [req/s] | [%] |
| POST /users/login | [ms] | [ms] | [ms] | [req/s] | [%] |
| GET /flights | [ms] | [ms] | [ms] | [req/s] | [%] |
| GET /hotels | [ms] | [ms] | [ms] | [req/s] | [%] |
| POST /booking/create | [ms] | [ms] | [ms] | [req/s] | [%] |
| POST /payments/create-payment-intent | [ms] | [ms] | [ms] | [req/s] | [%] |

### Performance Benchmarks

- **API Response Time**: < 500ms (average), < 1s (p95)
- **Database Query Time**: < 100ms (average)
- **Authentication Time**: < 200ms (average)
- **Payment Processing**: < 2s (average)
- **Concurrent Users Support**: 100+ users
- **System Availability**: 99.9% uptime

---

## Security Checks

### Security Test Cases

#### SEC-001: SQL Injection Prevention
- **Description**: Test for SQL injection vulnerabilities
- **Test Steps**: 
  1. Send requests with SQL injection payloads: `' OR '1'='1`
  2. Test in email, password, and other input fields
- **Expected Result**: Requests rejected, no database exposure
- **Status**: [Pass/Fail]

#### SEC-002: XSS (Cross-Site Scripting) Prevention
- **Description**: Test for XSS vulnerabilities
- **Test Steps**: 
  1. Send requests with XSS payloads: `<script>alert('XSS')</script>`
  2. Test in all text input fields
- **Expected Result**: Input sanitized, scripts not executed
- **Status**: [Pass/Fail]

#### SEC-003: Authentication Bypass
- **Description**: Attempt to access protected endpoints without token
- **Test Steps**: 
  1. Access protected endpoints without JWT token
  2. Access with invalid/expired token
- **Expected Result**: All requests rejected with 401 status
- **Status**: [Pass/Fail]

#### SEC-004: Authorization Bypass
- **Description**: Attempt admin actions as regular user
- **Test Steps**: 
  1. Login as regular user
  2. Attempt to access admin-only endpoints
- **Expected Result**: All requests rejected with 403 status
- **Status**: [Pass/Fail]

#### SEC-005: Password Security
- **Description**: Verify password encryption and strength
- **Test Steps**: 
  1. Register user and check database
  2. Verify password is hashed (bcrypt)
  3. Test weak passwords
- **Expected Result**: Passwords hashed, weak passwords rejected
- **Status**: [Pass/Fail]

#### SEC-006: CORS Configuration
- **Description**: Verify CORS is properly configured
- **Test Steps**: 
  1. Send requests from unauthorized origins
  2. Verify CORS headers
- **Expected Result**: Only authorized origins allowed
- **Status**: [Pass/Fail]

#### SEC-007: Rate Limiting
- **Description**: Test for rate limiting on sensitive endpoints
- **Test Steps**: 
  1. Send multiple rapid requests to login/register
  2. Verify rate limiting is enforced
- **Expected Result**: Rate limiting active, excessive requests blocked
- **Status**: [Pass/Fail]

#### SEC-008: Input Validation
- **Description**: Test input validation on all endpoints
- **Test Steps**: 
  1. Send invalid data types, lengths, formats
  2. Verify proper validation messages
- **Expected Result**: All invalid inputs rejected with appropriate messages
- **Status**: [Pass/Fail]

#### SEC-009: Sensitive Data Exposure
- **Description**: Verify sensitive data is not exposed
- **Test Steps**: 
  1. Check API responses for passwords, tokens
  2. Verify error messages don't expose system details
- **Expected Result**: No sensitive data in responses
- **Status**: [Pass/Fail]

#### SEC-010: OTP Security
- **Description**: Verify OTP implementation security
- **Test Steps**: 
  1. Test OTP expiration (10 minutes)
  2. Test OTP reuse prevention
  3. Test brute force on OTP
- **Expected Result**: OTP expires correctly, reuse prevented, brute force blocked
- **Status**: [Pass/Fail]

### OWASP Top 10 Checklist

- [ ] **A01:2021 – Broken Access Control**: Authorization checks implemented
- [ ] **A02:2021 – Cryptographic Failures**: Passwords hashed, HTTPS enforced
- [ ] **A03:2021 – Injection**: Input sanitization (XSS library)
- [ ] **A04:2021 – Insecure Design**: Security by design principles followed
- [ ] **A05:2021 – Security Misconfiguration**: CORS, headers properly configured
- [ ] **A06:2021 – Vulnerable Components**: Dependencies up to date
- [ ] **A07:2021 – Authentication Failures**: JWT implementation secure
- [ ] **A08:2021 – Software and Data Integrity**: Dependencies verified
- [ ] **A09:2021 – Security Logging**: Logging implemented
- [ ] **A10:2021 – Server-Side Request Forgery**: Not applicable (no external requests)

---

## CI/CD Integration

### GitHub Actions Workflow

The CI/CD pipeline is configured in `.github/workflows/api-tests.yml`

**Pipeline Stages**:
1. **Checkout Code**: Clone repository
2. **Setup Node.js**: Install Node.js environment
3. **Install Dependencies**: Install backend dependencies
4. **Run Unit Tests**: Execute unit tests (if available)
5. **Run API Tests (Karate)**: Execute Karate DSL tests
6. **Run Postman Tests**: Execute Postman collection via Newman
7. **Generate Reports**: Generate and publish test reports
8. **Security Scan**: Run security vulnerability scan

**Trigger Events**:
- Push to main branch
- Pull requests
- Manual trigger

**Test Reports**: Published as GitHub Actions artifacts

---

## Appendix

### Environment Variables Required
```
MONGODB_URI=<MongoDB connection string>
PORT=8080
SECRET_KEY=<JWT secret key>
AUTH_MAIL_USER=<Email for sending OTPs>
AUTH_MAIL_PASS=<Email password>
REDIS_HOST=localhost (for local Redis on Mac)
REDIS_PORT=6379 (default Redis port)
REDIS_PASSWORD= (empty for local Redis, or set if password protected)
STRIPE_SECRET_KEY=<Stripe secret key>
```

### Local Redis Setup (Mac)
```bash
# Install Redis (if not installed)
brew install redis

# Start Redis service
brew services start redis

# Or start manually
redis-server

# Verify Redis is running
redis-cli ping
# Should return: PONG
```

### Test Data
- **Admin User**: [To be configured]
- **Regular User**: [To be configured]
- **Test Email**: [To be configured]

### Tools and Versions
- **Postman**: Latest version
- **Newman**: Latest version
- **Karate DSL**: 1.4.0+
- **Node.js**: 16+
- **MongoDB**: Latest
- **Redis**: Latest

---

**Document Version**: 1.0  
**Last Updated**: [Date]  
**Maintained By**: SQE Project Team


