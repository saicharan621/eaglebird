FROM openjdk:11-jre-slim  # Use an appropriate JDK version
WORKDIR /app
COPY target/*.jar helloworld.jar
CMD ["java", "-jar", "/app/helloworld.jar"]
