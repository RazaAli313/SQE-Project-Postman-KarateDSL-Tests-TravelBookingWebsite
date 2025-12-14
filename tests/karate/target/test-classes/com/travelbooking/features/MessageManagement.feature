Feature: Message Management API Tests

  Background:
    * def baseUrl = 'http://localhost:3000/api/v1'
    * url baseUrl
    * def testEmail = 'razaalipk313@gmail.com'

  Scenario: Send message - Public access
    Given path 'messages'
    And request { email: testEmail, mobile: '1234567890', message: 'This is a test message that is long enough to pass validation' }
    When method POST
    Then status 201
    And match response.message contains 'successfully'

  Scenario: Get all messages - Admin only
    * def adminTimestamp = new java.util.Date().getTime()
    * def adminEmail = 'admin' + adminTimestamp.toString() + '@example.com'
    Given path 'users/register'
    And request { fullname: 'Admin User', email: adminEmail, password: 'Admin@123456', isVerified: true, role: 'admin' }
    When method POST
    Then status 201
    Given path 'users/login'
    And request { email: adminEmail, password: 'Admin@123456' }
    When method POST
    * def adminToken = response.data.token || ''
    Given path 'messages'
    And header Authorization = 'Bearer ' + adminToken
    When method GET
    Then status 200
    And match response.data == '#[]'

  Scenario: Get all messages - Non-admin user (should fail)
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
    Given path 'messages'
    And header Authorization = 'Bearer ' + userToken
    When method GET
    Then status 403

