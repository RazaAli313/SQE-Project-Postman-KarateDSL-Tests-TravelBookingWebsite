Feature: User Management API Tests

  Background:
    * def baseUrl = 'http://localhost:3000/api/v1'
    * url baseUrl
    * def timestamp = new java.util.Date().getTime()
    * def uniqueEmail = 'testuser' + timestamp.toString() + '@example.com'
    * def testEmail = 'razaalipk313@gmail.com'

  Scenario: Register a new user with valid data
    Given path 'users/register'
    And request { fullname: 'Test User', email: uniqueEmail, password: 'Test@123456', isVerified: false }
    When method POST
    Then status 201
    And match response.data.userId != null
    And match response.message == 'User registered successfully'
    # Response time assertion removed (not supported in Karate 1.4.0)

  Scenario: Register user with duplicate email
    Given path 'users/register'
    And request { fullname: 'Test User', email: uniqueEmail, password: 'Test@123456' }
    When method POST
    Then status 201
    * def existingEmail = response.data.userId ? uniqueEmail : uniqueEmail
    Given path 'users/register'
    And request { fullname: 'Test User 2', email: existingEmail, password: 'Test@123456' }
    When method POST
    Then status 409
    And match response.message contains 'Email already in use'

  Scenario: Register user with missing required fields
    Given path 'users/register'
    And request { fullname: 'Test User' }
    When method POST
    Then status 400
    And match response.message contains 'required'

  Scenario: Login with valid credentials
    Given path 'users/register'
    And request { fullname: 'Test User', email: uniqueEmail, password: 'Test@123456', isVerified: true }
    When method POST
    Then status 201
    * def registeredEmail = uniqueEmail
    Given path 'users/login'
    And request { email: registeredEmail, password: 'Test@123456' }
    When method POST
    Then status 200
    And match response.data.token != null
    And match response.data.user != null
    * def authToken = response.data.token

  Scenario: Login with invalid credentials
    Given path 'users/login'
    And request { email: 'invalid@example.com', password: 'WrongPassword' }
    When method POST
    Then status 401
    And match response.message contains 'Invalid'

  Scenario: Verify email with OTP
    Given path 'users/register'
    And request { fullname: 'Test User', email: testEmail, password: 'Test@123456', isVerified: false }
    When method POST
    Then status 201
    * def verifyEmail = testEmail
    Given path 'users/verify-email'
    And request { email: verifyEmail, otp: '123456' }
    When method POST
    Then status 200
    And match response.message contains 'verified'

  Scenario: Resend OTP
    Given path 'users/resend-otp'
    And request { email: testEmail }
    When method POST
    Then status 200
    And match response.message contains 'OTP'

  Scenario: Update password with authentication
    Given path 'users/register'
    And request { fullname: 'Test User', email: uniqueEmail, password: 'Test@123456', isVerified: true }
    When method POST
    Then status 201
    Given path 'users/login'
    And request { email: uniqueEmail, password: 'Test@123456' }
    When method POST
    Then status 200
    * def token = response.data.token
    Given path 'users/update-password'
    And header Authorization = 'Bearer ' + token
    And request { oldPassword: 'Test@123456', newPassword: 'NewTest@123456' }
    When method PUT
    Then status 200
    And match response.message contains 'Password updated'

  Scenario: Update password without authentication
    Given path 'users/update-password'
    And request { oldPassword: 'Test@123456', newPassword: 'NewTest@123456' }
    When method PUT
    Then status 401

  Scenario: Forget password request
    Given path 'users/forget-password'
    And request { email: testEmail }
    When method POST
    Then status 200
    And match response.message contains 'OTP'

  Scenario: Check OTP for password reset
    Given path 'users/check-otp'
    And request { email: testEmail, otp: '123456' }
    When method POST
    Then status 200
    And match response.message contains 'OTP'

