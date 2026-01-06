# Use Maven to build the project
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Use Tomcat to run the WAR
FROM tomcat:10.1-jre17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/ebanking-backend.jar /usr/local/tomcat/webapps/ROOT.war

# Let Tomcat listen on the port Railway provides
ENV CATALINA_OPTS="-Dport.http=${PORT:-8080} -Djava.awt.headless=true"

# Expose the port dynamically
EXPOSE ${PORT:-8080}

# Start Tomcat using the environment variable
CMD ["catalina.sh", "run"]
