# ============================================
# Stage 1: Build React Client
# ============================================
FROM node:14-alpine AS client-build

WORKDIR /app/client

# Copy package files and install dependencies
COPY polling-app-client/package.json polling-app-client/package-lock.json ./
RUN npm install

# Copy source code and build
COPY polling-app-client/ ./
RUN npm run build

# ============================================
# Stage 2: Build Spring Boot Application
# ============================================
FROM maven:3.8-eclipse-temurin-11 AS server-build

WORKDIR /app/server

# Copy pom.xml and download dependencies first (cache layer)
COPY polling-app-server/pom.xml ./
RUN mvn dependency:go-offline -B

# Copy source code
COPY polling-app-server/src ./src

# Copy React build output into Spring Boot static resources
COPY --from=client-build /app/client/build/ ./src/main/resources/static/

# Build the JAR (skip tests for faster build)
RUN mvn package -DskipTests -B

# ============================================
# Stage 3: Production Runtime
# ============================================
FROM eclipse-temurin:11-jre-alpine

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=server-build /app/server/target/polls-0.0.1-SNAPSHOT.jar app.jar

# Expose the port (Render uses PORT env var)
EXPOSE ${PORT:-5000}

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
