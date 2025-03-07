FROM openjdk:17
WORKDIR /app
COPY target/eaglebird-1.0.jar eaglebird-1.0.jar  # Use correct path
ENTRYPOINT ["java", "-jar", "eaglebird-1.0.jar"]
