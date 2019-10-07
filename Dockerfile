#Download image from artifactory
ARG REGISTRY
FROM openjdk:11-jdk
#FROM $REGISTRY/openjdk:11-jdk

WORKDIR /app

#Define ARG Again -ARG variables declared before the first FROM need to be declered again
ARG MAVEN_REPO_NAME
ARG NPM_REPO_NAME
ARG REGISTRY
MAINTAINER Elad Hirsch

RUN echo $REGISTRY/$NPM_REPO_NAME/frontend/-/frontend-3.0.0.tgz --output client.tgz

# Download artifacts from Artifactory
RUN curl $REGISTRY/$MAVEN_REPO_NAME/com/jfrog/backend/1.0.0/backend-1.0.0.jar --output server.jar \
    && curl $REGISTRY/$NPM_REPO_NAME/frontend/-/frontend-3.0.0.tgz --output client.tgz \
    && tar -xzf client.tgz \
    && rm client.tgz

# Set JAVA OPTS + Static file location
ENV STATIC_FILE_LOCATION="/app/package/target/dist/"
ENV JAVA_OPTS=""

# Fire up our Spring Boot app
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Dspring.profiles.active=remote -Djava.security.egd=file:/dev/./urandom -jar /app/server.jar" ]