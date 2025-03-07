FROM openjdk:17
WORKDIR /app
COPY ./eaglebird-1.0.jar /app/eaglebird-1.0.jar
RUN ls -l /app   # Debugging line to list files
ENTRYPOINT ["java", "-jar", "eaglebird-1.0.jar"]
