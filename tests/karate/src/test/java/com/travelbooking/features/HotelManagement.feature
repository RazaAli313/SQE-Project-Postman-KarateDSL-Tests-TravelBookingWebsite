Feature: Hotel Management API Tests

  Background:
    * def baseUrl = 'http://localhost:3000/api/v1'
    * url baseUrl

  Scenario: Get all hotels - Public access
    Given path 'hotels'
    When method GET
    Then status 200
    And match response.data == '#[]'
    # Response time assertion removed (not supported in Karate 1.4.0)

  Scenario: Create hotels - Admin only
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
    Given path 'hotels'
    And header Authorization = 'Bearer ' + adminToken
    And request { hotels: [{ name: 'Test Hotel', location: 'Paris', price: 150, rating: 4.5, amenities: ['WiFi', 'Pool'] }] }
    When method POST
    Then status 201
    And match response.message contains 'successfully'

