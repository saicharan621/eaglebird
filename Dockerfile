# Use an official Java runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file into the container
COPY ./eaglebird-1.0.jar /app/eaglebird-1.0.jar

# Set the entry point for the container
ENTRYPOINT ["java", "-jar", "/app/eaglebird-1.0.jar"]
