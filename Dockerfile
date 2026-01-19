#STAGE1: Base Image
FROM maven:3.8.6-openjdk-11-slim AS build
#RUN apt-get update && \
    #apt-get install -y maven unzip

#STAGE2: Copy artifacts
WORKDIR /tmp
COPY pom.xml /tmp/
COPY src /tmp/src
RUN mvn clean install

#STAGE3: Runtime configuration
FROM adoptopenjdk/openjdk11
COPY --from=build /tmp/target/*.jar spring-boot-application.jar

#STAGE4: Expose required port
EXPOSE 8080

# Create user and set ownership and permissions as required
RUN adduser --disabled-password --gecos "" acamtestuser && chown -R acamtestuser /tmp
USER acamtestuser

ENTRYPOINT ["java", "-jar", "/spring-boot-application.jar"]