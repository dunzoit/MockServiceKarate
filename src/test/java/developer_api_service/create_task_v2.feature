@createTask @createTaskV2
Feature: Create Tasks through Developer API using /api/v2/tasks endpoint

  Background:
    # global variables
    * def getRandomUuid = function(){ return java.util.UUID.randomUUID() + '' }
    * def urlString = 'http://developer-api-service-' + env + '.dev.dunzo.com/api/v2/tasks'
    * def headerMap = { Authorization: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkIjp7InNlY3JldF9rZXkiOiIwNmI2ZjE4Ni0zNDUwLTRjNmQtODMwOC1hYTk4OGU2NDQ1NzQiLCJyb2xlIjoxMDAsInVpZCI6IjdkODUxM2RlLWNmMDUtNDhiYi05Y2E0LTA0ZjhmYzY4NWIwMCJ9LCJtZXJjaGFudF90eXBlIjpudWxsLCJ1dWlkIjoiN2Q4NTEzZGUtY2YwNS00OGJiLTljYTQtMDRmOGZjNjg1YjAwIiwiYXBwX3R5cGUiOiJBUFAiLCJhdWQiOiJodHRwczovL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbS9nb29nbGUuaWRlbnRpdHkuaWRlbnRpdHl0b29sa2l0LnYxLklkZW50aXR5VG9vbGtpdCIsIm5hbWUiOiJKaW9NYXJ0Iiwicm9sZSI6MTAwLCJleHAiOjE4MTM2NTc4NTQsInYiOjAsImlhdCI6MTY1ODEzNzg1NCwic2VjcmV0X2tleSI6IjA2YjZmMTg2LTM0NTAtNGM2ZC04MzA4LWFhOTg4ZTY0NDU3NCIsImVtYWlsIjoiYW5rdXNoLnZlcm1hK3JpbEBkdW56by5pbiJ9.SgCvvHtTz7LcWwYEpkFILFDNlZTcYyGGbTAbpRmRHK8', client-id: 'adf8121b-f694-4d16-a8b4-78ed26184915'}

  Scenario: Verify that a PND order can be created, for an item which is paid through COD & the shipping charges are
  recovered through COD
    # local variables
    * def requestBodyJson = read('requestBody.json')
    * requestBodyJson.request_id = getRandomUuid()

    # request & response
    Given url urlString
    And headers headerMap
    And request requestBodyJson
    When method POST
    Then status 201

    # assertions
    And match $.task_id == '#uuid'
    And match $.state == 'created'

  Scenario: Verify that a PND order can be created, for an item which is paid through COD & the shipping charges are
  recovered through DUNZO CREDIT
    # local variables
    * def requestBodyJson = read('requestBody.json')
    * requestBodyJson.request_id = getRandomUuid()
    * requestBodyJson.payment_method = 'DUNZO_CREDIT'

    # request & response
    Given url urlString
    And headers headerMap
    And request requestBodyJson
    When method POST
    Then status 201

    # assertions
    And match $.task_id == '#uuid'
    And match $.state == 'created'


  Scenario: Verify that a PND order can be created, for an item which is prepaid & the shipping charges are
  recovered through COD
    # local variables
    * def requestBodyJson = read('requestBody.json')
    * requestBodyJson.request_id = getRandomUuid()
    * remove requestBodyJson.drop_details[0].payment_data

    # request & response
    Given url urlString
    And headers headerMap
    And request requestBodyJson
    When method POST
    Then status 201

    # assertions
    And match $.task_id == '#uuid'
    And match $.state == 'created'

  Scenario: Verify that a PND order can be created, for an item which is prepaid & the shipping charges are
  recovered through DUNZO CREDIT
    # local variables
    * def requestBodyJson = read('requestBody.json')
    * requestBodyJson.request_id = getRandomUuid()
    * remove requestBodyJson.drop_details[0].payment_data
    * requestBodyJson.payment_method = 'DUNZO_CREDIT'

    # request & response
    Given url urlString
    And headers headerMap
    And request requestBodyJson
    When method POST
    Then status 201

    # assertions
    And match $.task_id == '#uuid'
    And match $.state == 'created'


  Scenario Outline: Verify that a PND order cannot be created by providing invalid pick up latitude and longitude
    # local variables
    * def requestBodyJson = read('requestBody.json')
    * requestBodyJson.request_id = getRandomUuid()
    * requestBodyJson.pickup_details[0].address.lat = (pickUpLat * 1)
    * requestBodyJson.pickup_details[0].address.lng = (pickUpLong * 1)
    * requestBodyJson.drop_details[0].address.lat = (dropLat * 1)
    * requestBodyJson.drop_details[0].address.lng = (dropLong * 1)

    # request & response
    Given url urlString
    And headers headerMap
    And request requestBodyJson
    When method POST
    Then status 200
    And match $.code == 'unserviceable_location_error'
    And match $.message contains 'Location is not serviceable'

    # data
    @data1
    Examples:
      | pickUpLat | pickUpLong | dropLat   | dropLong  |
      | -1        | 77.647606  | 12.959172 | 77.697418 |
      | 12.908136 | -1         | 12.959172 | 77.697418 |
      | 12.908136 | 77.647606  | -1        | 77.697418 |
      | 12.908136 | 77.647606  | 12.959172 | -1        |

    @data2
    Examples:
      | pickUpLat | pickUpLong | dropLat   | dropLong  |
      | -1        | 77.647606  | 12.959172 | 77.697418 |
      | 12.908136 | -1         | 12.959172 | 77.697418 |
      | 12.908136 | 77.647606  | -1        | 77.697418 |
      | 12.908136 | 77.647606  | 12.959172 | -1        |

    @data3
    Examples:
      | pickUpLat | pickUpLong | dropLat   | dropLong  |
      | -1        | 77.647606  | 12.959172 | 77.697418 |
      | 12.908136 | -1         | 12.959172 | 77.697418 |
      | 12.908136 | 77.647606  | -1        | 77.697418 |
      | 12.908136 | 77.647606  | 12.959172 | -1        |

