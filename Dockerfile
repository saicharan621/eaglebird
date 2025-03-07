FROM openjdk:17

# Ensure /app directory exists
RUN mkdir -p /app

# Set working directory
WORKDIR /app

# Copy jar file into the /app directory
COPY ./eaglebird-1.0.jar /app/eaglebird-1.0.jar

# List files in /app for debugging
RUN ls -l /app

# Set the entrypoint
ENTRYPOINT ["java", "-jar", "eaglebird-1.0.jar"]
