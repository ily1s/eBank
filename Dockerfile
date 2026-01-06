# Use Maven to build the project
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy the pom and src to build
COPY pom.xml .
COPY src ./src

# Build the war
RUN mvn clean package -DskipTests

# Use Tomcat to run the WAR
FROM tomcat:10.1-jre17

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file to Tomcat webapps
COPY --from=build /app/target/ebanking-backend.jar /usr/local/tomcat/webapps/ROOT.jar

# Expose your custom port
EXPOSE 8085

# Configure Tomcat to use port 8085
RUN sed -i 's/port="8080"/port="8085"/' /usr/local/tomcat/conf/server.xml

# Start Tomcat
CMD ["catalina.sh", "run"]
