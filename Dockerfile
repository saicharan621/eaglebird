FROM openjdk:17
WORKDIR /app
COPY eaglebird-1.0.jar eaglebird-1.0.jar # copy and keep the name
ENTRYPOINT ["java", "-jar", "eaglebird-1.0.jar"]