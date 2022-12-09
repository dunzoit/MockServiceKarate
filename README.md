# Karate for API Automation POC & Mock Server

## How to build a docker image
* docker build -t <image_name> .
* ```docker build -t karate-mock-server .```

## How to run the docker container
* docker run docker run -d --name=<container_name> -p <local_post>:<docker_port> <image_name>
* ```docker run -d --name=karate-mock-server -p 8080:8080 karate-mock-server```