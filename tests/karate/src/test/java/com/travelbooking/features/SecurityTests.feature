Feature: Security Tests

  Background:
    * def baseUrl = 'http://localhost:3000/api/v1'
    * url baseUrl

  Scenario: SQL Injection attempt in login
    Given path 'users/login'
    And request { email: "' OR '1'='1", password: "' OR '1'='1" }
    When method POST
    Then status 401

  Scenario: XSS attempt in registration
    * def xssTimestamp = new java.util.Date().getTime()
    * def xssEmail = 'xss' + xssTimestamp.toString() + '@example.com'
    Given path 'users/register'
    And request { fullname: '<script>alert("XSS")</script>', email: xssEmail, password: 'Test@123456' }
    When method POST
    Then status 201
    # Verify input is sanitized (should not contain script tags in response)
    And match response.data.fullname != '<script>alert("XSS")</script>'

  Scenario: Access protected endpoint without token
    Given path 'users/update-password'
    And request { oldPassword: 'Test@123456', newPassword: 'NewTest@123456' }
    When method PUT
    Then status 401

  Scenario: Access admin endpoint as regular user
    * def userTimestamp = new java.util.Date().getTime()
    * def userEmail = 'user' + userTimestamp.toString() + '@example.com'
    Given path 'users/register'
    And request { fullname: 'Regular User', email: userEmail, password: 'User@123456', isVerified: true }
    When method POST
    Then status 201
    Given path 'users/login'
    And request { email: userEmail, password: 'User@123456' }
    When method POST
    * def userToken = response.data.token || ''
    Given path 'flights'
    And header Authorization = 'Bearer ' + userToken
    And request { flights: [{ airline: 'Test Airlines', from: 'New York', to: 'London', departureDate: '2024-12-25', arrivalDate: '2024-12-25', price: 500, availableSeats: 100 }] }
    When method POST
    Then status 403

  Scenario: Invalid JWT token
    Given path 'users/update-password'
    And header Authorization = 'Bearer invalid_token_12345'
    And request { oldPassword: 'Test@123456', newPassword: 'NewTest@123456' }
    When method PUT
    Then status 401

