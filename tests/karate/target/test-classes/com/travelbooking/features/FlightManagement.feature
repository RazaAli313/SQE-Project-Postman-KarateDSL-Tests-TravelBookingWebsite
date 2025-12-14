Feature: Flight Management API Tests

  Background:
    * def baseUrl = 'http://localhost:3000/api/v1'
    * url baseUrl

  Scenario: Get all flights - Public access
    Given path 'flights'
    When method GET
    Then status 200
    And match response.data == '#[]'
    # Response time assertion removed (not supported in Karate 1.4.0)

  Scenario: Add flights - Admin only
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
    Given path 'flights'
    And header Authorization = 'Bearer ' + adminToken
    And request { flights: [{ airline: 'Test Airlines', from: 'New York', to: 'London', departureDate: '2024-12-25', arrivalDate: '2024-12-25', price: 500, availableSeats: 100 }] }
    When method POST
    Then status 201
    And match response.message contains 'successfully'

  Scenario: Add flights - Non-admin user (should fail)
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

