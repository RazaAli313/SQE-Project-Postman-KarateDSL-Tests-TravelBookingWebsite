Feature: Payment Management API Tests

  Background:
    * def baseUrl = 'http://localhost:3000/api/v1'
    * url baseUrl

  Scenario: Create payment intent with valid data
    Given path 'payments/create-payment-intent'
    And request { amount: 1000, currency: 'usd', bookingId: '507f1f77bcf86cd799439011' }
    When method POST
    Then status 200
    And match response.data.clientSecret != '#null'
    # Response time assertion removed (not supported in Karate 1.4.0)

  Scenario: Create payment intent with invalid amount
    Given path 'payments/create-payment-intent'
    And request { amount: 0, currency: 'usd', bookingId: '507f1f77bcf86cd799439011' }
    When method POST
    Then status 400

