@mock @instamojo @ignore
Feature: Instamojo mock for automation

  Background:
    * def getRandomUuid = function(){ return java.util.UUID.randomUUID() + '' }
    * def sleep = function(pause){ java.lang.Thread.sleep(pause) }
    * def webhook_response_template = read("callback-response-template.json")
    * def link_generator_response_template = read("link_generator_response_template.json")
    * def flag = false

  Scenario: pathMatches('/payment-requests/') && methodIs('post')
    # reading request
    * def incoming_request = request
    * print 'Captured request from caller : ', incoming_request
    * def webhook_url = incoming_request.webhook
    * def request_amount = incoming_request.amount
    * def phone_number = incoming_request.phone
    * def purpose = incoming_request.purpose
    * def name = incoming_request.buyer_name
    * def allow_repeated_payment = incoming_request.allow_repeated_payments

      # updating response
    * def payment_request = link_generator_response_template.payment_request
    * def paymentId = getRandomUuid()
    * payment_request.id = paymentId
    * payment_request.amount = request_amount
    * payment_request.buyer_name = name
    * payment_request.webhook = webhook_url
    * payment_request.phone = phone_number
    * def long_temp_url = 'https://test.instamojo.com/process-payment/'+paymentId
    * payment_request.longurl = long_temp_url

      # sending response
    * print 'Sending back response to caller: ', link_generator_response_template
    * def response = link_generator_response_template
    * def responseStatus = 200
    * def webhook_response = webhook_response_template
    * webhook_response.payment_request_id = paymentId
    * webhook_response.buyer_name = name
    * webhook_response.buyer_phone = phone_number
    * webhook_response.amount = request_amount
    * webhook_response.longurl = long_temp_url
    * def id = getRandomUuid()
    * webhook_response.payment_id = 'MOJO'+id
    * print 'Webhook callback response: ', webhook_response
    * sleep(1000)
    * karate.call('webhook-updater.feature', { webhook_url: webhook_url, request_body: webhook_response })