#!/bin/sh
java -jar karate.jar  \
  -m instamojo-mock.feature \
  -m health.feature \
  -p 8080