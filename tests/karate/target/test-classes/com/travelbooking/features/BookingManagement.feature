Feature: Booking Management API Tests

  Background:
    * def baseUrl = 'http://localhost:3000/api/v1'
    * url baseUrl

  Scenario: Create booking with valid data
    Given path 'booking/create'
    And request { fullName: 'John Doe', age: 30, gender: 'Male', address: '123 Main Street, City', adharNumber: '123456789012', place: '507f1f77bcf86cd799439011', hotel: '507f1f77bcf86cd799439011', flight: '507f1f77bcf86cd799439011', numOfTickets: 2 }
    When method POST
    Then status 200
    And match response.data != null
    * def transactionId = response.data.transactionId

  Scenario: Get total amount for booking
    # This test requires a valid transactionId from create booking
    # For now, we'll test with an invalid transactionId to verify error handling
    Given path 'booking/total-amount'
    And request { transactionId: 'test-transaction-id-12345' }
    When method POST
    Then status 401
    And match response.message contains 'expired'

  Scenario: Save booking details - Authenticated user
    * def userTimestamp = new java.util.Date().getTime()
    * def userEmail = 'user' + userTimestamp.toString() + '@example.com'
    Given path 'users/register'
    And request { fullname: 'Test User', email: userEmail, password: 'Test@123456', isVerified: true }
    When method POST
    Then status 201
    Given path 'users/login'
    And request { email: userEmail, password: 'Test@123456' }
    When method POST
    * def authToken = response.data.token || ''
    Given path 'booking/save-booking'
    And header Authorization = 'Bearer ' + authToken
    And request { bookingId: '507f1f77bcf86cd799439011', userId: response.data.user._id || '507f1f77bcf86cd799439012', totalAmount: 1000 }
    When method POST
    Then status 201
    And match response.message contains 'successfully'

  Scenario: Save booking details - Unauthenticated (should fail)
    Given path 'booking/save-booking'
    And request { bookingId: '507f1f77bcf86cd799439011', userId: '507f1f77bcf86cd799439012', totalAmount: 1000 }
    When method POST
    Then status 401

