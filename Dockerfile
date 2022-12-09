FROM openjdk:11-jre-slim-buster
COPY dockerfile-entrypoint.sh .
COPY src/test/resources/ .
COPY src/test/java/mocks/health/ .
COPY src/test/java/mocks/instamojo/ .
EXPOSE 8080/tcp
CMD ["/bin/sh", "dockerfile-entrypoint.sh"]