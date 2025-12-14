# Security Testing Documentation

## Overview

This document outlines the security testing strategy, test cases, and procedures for the Travel Booking Website API. Security testing ensures the application is protected against common vulnerabilities and follows security best practices.

## Security Testing Objectives

1. **Authentication Security**: Verify secure user authentication
2. **Authorization Security**: Ensure proper access control
3. **Input Validation**: Test for injection attacks and XSS
4. **Data Protection**: Verify sensitive data handling
5. **Session Management**: Test session security
6. **API Security**: Test API endpoint security

## OWASP Top 10 Security Risks

### A01:2021 – Broken Access Control

**Test Cases**:

#### SEC-001: Unauthorized Access to Protected Endpoints
- **Description**: Attempt to access protected endpoints without authentication
- **Test Steps**:
  1. Access `/api/v1/users/update-password` without token
  2. Access `/api/v1/booking/save-booking` without token
- **Expected Result**: 401 Unauthorized
- **Status**: [Pass/Fail]

#### SEC-002: Privilege Escalation
- **Description**: Regular user attempting admin actions
- **Test Steps**:
  1. Login as regular user
  2. Attempt to access `/api/v1/flights` (POST) as regular user
  3. Attempt to access `/api/v1/messages` (GET) as regular user
- **Expected Result**: 403 Forbidden
- **Status**: [Pass/Fail]

#### SEC-003: Direct Object Reference
- **Description**: Attempt to access other users' data
- **Test Steps**:
  1. Login as User A
  2. Attempt to access User B's booking data
- **Expected Result**: Access denied or filtered results
- **Status**: [Pass/Fail]

---

### A02:2021 – Cryptographic Failures

**Test Cases**:

#### SEC-004: Password Encryption
- **Description**: Verify passwords are hashed in database
- **Test Steps**:
  1. Register a new user
  2. Check database for password field
  3. Verify password is hashed (bcrypt)
- **Expected Result**: Password is hashed, not plain text
- **Status**: [Pass/Fail]

#### SEC-005: Sensitive Data in Transit
- **Description**: Verify HTTPS is enforced
- **Test Steps**:
  1. Attempt HTTP connection
  2. Verify redirect to HTTPS
- **Expected Result**: HTTPS enforced
- **Status**: [Pass/Fail]

#### SEC-006: Sensitive Data in Responses
- **Description**: Verify sensitive data not exposed in API responses
- **Test Steps**:
  1. Login and check response
  2. Verify password not in response
  3. Verify JWT token properly formatted
- **Expected Result**: No sensitive data exposed
- **Status**: [Pass/Fail]

---

### A03:2021 – Injection

**Test Cases**:

#### SEC-007: SQL Injection
- **Description**: Test for SQL injection vulnerabilities
- **Test Steps**:
  1. Send login request with: `email: "' OR '1'='1"`
  2. Send login request with: `email: "admin'--"`
  3. Test in all input fields
- **Expected Result**: Requests rejected, no SQL execution
- **Status**: [Pass/Fail]

#### SEC-008: NoSQL Injection
- **Description**: Test for NoSQL injection (MongoDB)
- **Test Steps**:
  1. Send request with: `{"email": {"$ne": null}}`
  2. Send request with: `{"email": {"$gt": ""}}`
- **Expected Result**: Requests rejected or sanitized
- **Status**: [Pass/Fail]

#### SEC-009: Command Injection
- **Description**: Test for command injection
- **Test Steps**:
  1. Send input: `; ls -la`
  2. Send input: `| cat /etc/passwd`
- **Expected Result**: Commands not executed
- **Status**: [Pass/Fail]

---

### A04:2021 – Insecure Design

**Test Cases**:

#### SEC-010: Security by Design
- **Description**: Verify security controls are implemented
- **Test Steps**:
  1. Review authentication flow
  2. Review authorization checks
  3. Review input validation
- **Expected Result**: Security controls in place
- **Status**: [Pass/Fail]

---

### A05:2021 – Security Misconfiguration

**Test Cases**:

#### SEC-011: CORS Configuration
- **Description**: Verify CORS is properly configured
- **Test Steps**:
  1. Send request from unauthorized origin
  2. Verify CORS headers
  3. Check allowed origins
- **Expected Result**: Only authorized origins allowed
- **Status**: [Pass/Fail]

#### SEC-012: Security Headers
- **Description**: Verify security headers are present
- **Test Steps**:
  1. Check for X-Content-Type-Options
  2. Check for X-Frame-Options
  3. Check for X-XSS-Protection
  4. Check for Strict-Transport-Security
- **Expected Result**: Security headers present
- **Status**: [Pass/Fail]

#### SEC-013: Error Message Information Disclosure
- **Description**: Verify error messages don't expose system details
- **Test Steps**:
  1. Trigger various errors
  2. Check error messages
  3. Verify no stack traces in production
- **Expected Result**: Generic error messages, no system details
- **Status**: [Pass/Fail]

---

### A06:2021 – Vulnerable and Outdated Components

**Test Cases**:

#### SEC-014: Dependency Vulnerability Scan
- **Description**: Scan for known vulnerabilities in dependencies
- **Test Steps**:
  1. Run `npm audit`
  2. Run OWASP Dependency Check
  3. Review vulnerability reports
- **Expected Result**: No critical/high vulnerabilities
- **Status**: [Pass/Fail]

#### SEC-015: Outdated Packages
- **Description**: Check for outdated packages
- **Test Steps**:
  1. Run `npm outdated`
  2. Review package versions
  3. Update critical packages
- **Expected Result**: Packages up to date
- **Status**: [Pass/Fail]

---

### A07:2021 – Identification and Authentication Failures

**Test Cases**:

#### SEC-016: Weak Password Policy
- **Description**: Test password strength requirements
- **Test Steps**:
  1. Attempt registration with weak password: "123"
  2. Attempt registration with common password: "password"
  3. Verify password policy enforcement
- **Expected Result**: Weak passwords rejected
- **Status**: [Pass/Fail]

#### SEC-017: Brute Force Protection
- **Description**: Test for brute force protection
- **Test Steps**:
  1. Attempt multiple failed logins
  2. Verify rate limiting or account lockout
- **Expected Result**: Brute force attempts blocked
- **Status**: [Pass/Fail]

#### SEC-018: Session Management
- **Description**: Test JWT token security
- **Test Steps**:
  1. Verify token expiration
  2. Test token tampering
  3. Test token reuse after logout
- **Expected Result**: Tokens properly secured
- **Status**: [Pass/Fail]

#### SEC-019: OTP Security
- **Description**: Test OTP implementation
- **Test Steps**:
  1. Test OTP expiration (10 minutes)
  2. Test OTP reuse prevention
  3. Test OTP brute force
- **Expected Result**: OTP properly secured
- **Status**: [Pass/Fail]

---

### A08:2021 – Software and Data Integrity Failures

**Test Cases**:

#### SEC-020: Dependency Integrity
- **Description**: Verify dependency integrity
- **Test Steps**:
  1. Check package-lock.json
  2. Verify package signatures
- **Expected Result**: Dependencies verified
- **Status**: [Pass/Fail]

---

### A09:2021 – Security Logging and Monitoring Failures

**Test Cases**:

#### SEC-021: Security Event Logging
- **Description**: Verify security events are logged
- **Test Steps**:
  1. Attempt failed login
  2. Attempt unauthorized access
  3. Check logs for security events
- **Expected Result**: Security events logged
- **Status**: [Pass/Fail]

#### SEC-022: Log Monitoring
- **Description**: Verify log monitoring is in place
- **Test Steps**:
  1. Review logging configuration
  2. Verify log aggregation
- **Expected Result**: Logs monitored
- **Status**: [Pass/Fail]

---

### A10:2021 – Server-Side Request Forgery (SSRF)

**Test Cases**:

#### SEC-023: SSRF Prevention
- **Description**: Test for SSRF vulnerabilities
- **Test Steps**:
  1. Review code for external requests
  2. Test URL validation
- **Expected Result**: SSRF not applicable or protected
- **Status**: [Pass/Fail]

---

## XSS (Cross-Site Scripting) Testing

### SEC-024: Stored XSS
- **Description**: Test for stored XSS vulnerabilities
- **Test Steps**:
  1. Send input: `<script>alert('XSS')</script>`
  2. Send input: `<img src=x onerror=alert('XSS')>`
  3. Check if script executes when data is retrieved
- **Expected Result**: Input sanitized, scripts not executed
- **Status**: [Pass/Fail]

### SEC-025: Reflected XSS
- **Description**: Test for reflected XSS
- **Test Steps**:
  1. Send XSS payload in query parameters
  2. Check response for script execution
- **Expected Result**: Input sanitized
- **Status**: [Pass/Fail]

---

## Security Test Execution

### Pre-requisites

1. **Environment Setup**:
   - API server running
   - MongoDB connected
   - Redis running locally (Mac)
   - Test tools installed

2. **Redis Setup (Local Mac)**:
   ```bash
   # Start Redis
   brew services start redis
   # Or manually
   redis-server
   
   # Verify Redis is running
   redis-cli ping
   # Should return: PONG
   ```

3. **Security Testing Tools**:
   - Postman (for manual security testing)
   - OWASP ZAP (for automated security scanning)
   - Burp Suite (for advanced security testing)
   - npm audit (for dependency scanning)

### Execution Steps

1. **Manual Security Testing**:
   - Execute security test cases using Postman
   - Document findings
   - Verify fixes

2. **Automated Security Scanning**:
   - Run OWASP ZAP scan
   - Run npm audit
   - Review scan results

3. **Penetration Testing**:
   - Attempt to exploit vulnerabilities
   - Document successful exploits
   - Verify fixes

### Security Test Reports

**Location**: `reports/security/security-test-report-[date].html`

**Contents**:
- Executive Summary
- Vulnerability Summary
- Detailed Findings
- Risk Assessment
- Remediation Recommendations
- OWASP Top 10 Compliance

---

## Security Checklist

### Authentication & Authorization
- [ ] Strong password policy enforced
- [ ] Password hashing (bcrypt) implemented
- [ ] JWT tokens properly secured
- [ ] Token expiration implemented
- [ ] Role-based access control (RBAC) implemented
- [ ] Admin endpoints protected

### Input Validation
- [ ] Input sanitization (XSS library) implemented
- [ ] SQL injection prevention
- [ ] NoSQL injection prevention
- [ ] Input length validation
- [ ] Input type validation

### Data Protection
- [ ] Sensitive data encrypted in transit (HTTPS)
- [ ] Passwords not exposed in responses
- [ ] Error messages don't expose system details
- [ ] Database credentials secured

### Session Management
- [ ] Secure session handling
- [ ] Session timeout implemented
- [ ] Token refresh mechanism
- [ ] Logout functionality

### API Security
- [ ] CORS properly configured
- [ ] Rate limiting implemented
- [ ] API versioning
- [ ] Request size limits

### Infrastructure Security
- [ ] Security headers configured
- [ ] Dependencies up to date
- [ ] Security logging implemented
- [ ] Monitoring and alerting

---

## Security Testing Tools

### 1. Postman
- Manual security testing
- Test case execution
- Security test collection

### 2. OWASP ZAP
- Automated vulnerability scanning
- Active and passive scanning
- API security testing

**Installation**:
```bash
# Download from https://www.zaproxy.org/download/
# Or use Docker
docker run -t owasp/zap2docker-stable zap-baseline.py -t http://localhost:8080
```

### 3. npm audit
- Dependency vulnerability scanning

**Execution**:
```bash
cd backend
npm audit
npm audit fix
```

### 4. OWASP Dependency Check
- Dependency vulnerability analysis

**Execution**:
```bash
# Using Maven plugin or standalone
dependency-check --project Travel-Booking --scan backend/
```

---

## Remediation Process

1. **Identify Vulnerability**: Document vulnerability details
2. **Assess Risk**: Determine risk level (Critical/High/Medium/Low)
3. **Prioritize**: Prioritize based on risk and impact
4. **Fix**: Implement security fix
5. **Verify**: Re-test to verify fix
6. **Document**: Update security documentation

---

## Security Best Practices

1. **Always validate and sanitize user input**
2. **Use parameterized queries (if applicable)**
3. **Implement proper authentication and authorization**
4. **Use HTTPS for all communications**
5. **Keep dependencies up to date**
6. **Implement security logging and monitoring**
7. **Follow principle of least privilege**
8. **Regular security audits**
9. **Security code reviews**
10. **Penetration testing**

---

**Document Version**: 1.0  
**Last Updated**: [Date]  
**Maintained By**: SQE Project Team

