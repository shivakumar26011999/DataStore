FROM amazoncorretto:11-alpine-jdk
ARG JAR_FILE=./target/datastore-0.0.1.jar
WORKDIR /opt/app
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]