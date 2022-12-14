Feature:

  Scenario: pathMatches('/health') && methodIs('get')
    * def statusCode = 200
    * def response = { "status" : "Running" , "version" : "1.6"}
