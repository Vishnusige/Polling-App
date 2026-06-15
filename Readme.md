# Polling App - Full Stack Polls Application

A full-stack polling application similar to Twitter polls, built with React, Spring Boot, Spring Security, JWT authentication, and PostgreSQL.

## Live Demo

Production URL: [https://polling-app-z854.onrender.com](https://polling-app-z854.onrender.com)

The app is hosted on Render's free tier. The first request may take about 30 seconds if the service has spun down due to inactivity.

## Screenshots

| Login Page | Create Poll |
| --- | --- |
| <img src="screenshots/login_page.png" alt="Login Page" width="400"/> | <img src="screenshots/create_poll.png" alt="Create Poll" width="400"/> |

| Voting Page | Dashboard |
| --- | --- |
| <img src="screenshots/voting_page.png" alt="Voting Page" width="400"/> | <img src="screenshots/dashboard.png" alt="Dashboard" width="400"/> |

## Architecture

```text
Browser
  |
  | REST API (JSON)
  v
React single-page app served by Spring Boot
  |
  v
Spring MVC controllers
  |
  v
Spring Security + JWT authentication
  |
  v
Spring Data JPA repositories
  |
  v
PostgreSQL
```

## Tech Stack

| Layer | Technology |
| --- | --- |
| Frontend | React 16, Ant Design 3, React Router 4 |
| Backend | Spring Boot 2.7.18, Spring MVC, Spring Data JPA |
| Security | Spring Security, JWT |
| Database | PostgreSQL |
| Build Tools | Maven, npm |
| Deployment | Render Blueprint, Docker multi-stage build |

## Features

- User signup and login with JWT-based authentication
- Poll creation with up to 6 choices and configurable expiration
- Voting on active polls, limited to one vote per user per poll
- Poll result percentages with visual progress bars
- User profiles with created polls and voting history
- Paginated poll lists with "Load More"
- USER and ADMIN roles initialized automatically on startup
- Responsive layout for desktop and mobile browsers

## Project Structure

```text
Polling-App/
|-- polling-app-client/          React frontend
|   |-- public/                  Static template assets
|   `-- src/
|       |-- app/                 App component and routing
|       |-- common/              Shared components
|       |-- constants/           App constants and API config
|       |-- poll/                Poll UI components
|       |-- user/                Login, signup, and profile views
|       `-- util/                API utilities and helpers
|
|-- polling-app-server/          Spring Boot backend
|   `-- src/main/java/com/example/polls/
|       |-- config/              Security and MVC configuration
|       |-- controller/          REST API controllers
|       |-- exception/           Application exceptions
|       |-- model/               JPA entities
|       |-- payload/             Request and response DTOs
|       |-- repository/          Spring Data repositories
|       |-- security/            JWT and authentication components
|       |-- service/             Business logic
|       `-- util/                Utility classes
|
|-- Dockerfile                   Multi-stage production image
|-- render.yaml                  Render Blueprint
`-- Readme.md
```

## API Endpoints

| Method | Endpoint | Description | Auth |
| --- | --- | --- | --- |
| POST | `/api/auth/signin` | Login | No |
| POST | `/api/auth/signup` | Register | No |
| GET | `/api/polls` | Get all polls | No |
| POST | `/api/polls` | Create a poll | Yes |
| POST | `/api/polls/{pollId}/votes` | Cast a vote | Yes |
| GET | `/api/user/me` | Get current user | Yes |
| GET | `/api/users/{username}` | Get user profile | No |
| GET | `/api/users/{username}/polls` | Get a user's polls | No |
| GET | `/api/users/{username}/votes` | Get a user's votes | No |
| GET | `/api/user/checkUsernameAvailability` | Check username availability | No |
| GET | `/api/user/checkEmailAvailability` | Check email availability | No |

## Local Development

### Prerequisites

- Java 11 or newer
- Maven 3.6 or newer
- Node.js 14
- PostgreSQL 12 or newer

### 1. Clone the repository

```bash
git clone https://github.com/Vishnusige/Polling-App.git
cd Polling-App
```

### 2. Create the database

```sql
CREATE DATABASE polling_app;
```

### 3. Configure environment variables

Set these values before starting the backend:

```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=polling_app
export DB_USERNAME=postgres
export DB_PASSWORD=postgres
export JWT_SECRET=replace-with-a-long-random-secret
```

For Windows PowerShell:

```powershell
$env:DB_HOST="localhost"
$env:DB_PORT="5432"
$env:DB_NAME="polling_app"
$env:DB_USERNAME="postgres"
$env:DB_PASSWORD="postgres"
$env:JWT_SECRET="replace-with-a-long-random-secret"
```

### 4. Run the backend

```bash
cd polling-app-server
mvn spring-boot:run
```

The backend starts on `http://localhost:5000`. Default roles (`ROLE_USER` and `ROLE_ADMIN`) are inserted automatically on startup.

### 5. Run the frontend

```bash
cd polling-app-client
npm install
npm start
```

The development client starts on `http://localhost:3000`.

## Docker

Build and run the production image:

```bash
docker build -t polling-app .
docker run -p 5000:5000 \
  -e DB_HOST=your-db-host \
  -e DB_PORT=5432 \
  -e DB_NAME=polling_app \
  -e DB_USERNAME=postgres \
  -e DB_PASSWORD=replace-with-db-password \
  -e JWT_SECRET=replace-with-a-long-random-secret \
  polling-app
```

## Deployment on Render

This app is configured for Render Blueprint deployment using `render.yaml`.

1. Fork or connect this repository in Render.
2. Create a new Blueprint from the repository and select the deployment branch.
3. Render provisions a Docker web service and a PostgreSQL database.
4. Database environment variables are wired from the managed PostgreSQL service.
5. `JWT_SECRET` is generated by Render.
6. The deployed app is available at [https://polling-app-z854.onrender.com](https://polling-app-z854.onrender.com).

## Production Notes

- The frontend is built into Spring Boot static resources during the Docker build.
- The backend serves the React app and API from the same origin.
- PostgreSQL schema management uses Hibernate `ddl-auto=update`.
- Role initialization is handled by `polling-app-server/src/main/resources/data.sql`.
- Sensitive values are supplied through environment variables.

## License

This project is open source and available under the MIT License.
