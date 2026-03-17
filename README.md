DevOps Containerized Task manager Web Application
Overview:
    This project demonstrates a containerized Task manager web application architecture using Docker, Docker Compose, and Jenkins.
  The system is divided into multiple services following modern DevOps and microservice deployment practices:

  Frontend – Static web interface
  Backend – Python-based application logic for CRUD operations
  Nginx – Reverse proxy and traffic router
  Jenkins – CI/CD pipeline automation
  Redis - this used for caching
  Postgres - the ultimate source truth also known as the Database


Architecture:
Nginx -> Frontend -> Backend -> Redis -> Postgres

Project Structure:
project/
│
├── backend/
│   ├── appcode.py
│   ├── dependencies(requirements.txt)
│   └── Dockerfile
│
├── frontend/
│   ├── index.html
│   └── Dockerfile
│
├── nginx/
│   ├── nginx.conf
│   └── Dockerfile
│
├── docker-compose.yaml
├── Jenkinsfile.deploy
├── .gitignore
└── README.md

.gitignore:
  Specifies files and directories that Git should ignore.
  This prevents committing unnecessary or sensitive files such as:
 -environment files
 -temporary files
 -build artifacts

docker-compose.yml:
  Defines and orchestrates the multi-container application.

Docker Compose allows all services to be started with a single command.
Example services defined:
-Posgtgres(Database)
-Redis(caching)
-backend
-frontend
-nginx(reverse-proxy)
-networks

Jenkinsfile.deploy:
  Defines the CI/CD deployment pipeline for Jenkins.
pipeline stages include:
  -Pull code from repository
  -SSH into an EC2 server
  -Build Docker images
  -Run tests (no tests yet)
  -Deploy containers on the EC2 server using Docker Compose
  -This enables automated deployment whenever new changes are pushed.

Posgtres:
  This is the main database of the application where all records of completed and uncompleted tasks are stored.

Redis:
  Redis is a software in this case that temporarily stores frequently requested operations into the memory for for subsequent
  fast retrievals on later requestd

Backend:
  The backend is a Python application responsible for CRUD requests, application logic or API endpoints.
Files:
  appcode.py – main backend application
  dependencies – Python dependencies
  Dockerfile – builds the backend container image

Frontend:
  The frontend is the static website that provides a suitable user interface for tasks related request.
Files:
  index.html – main web page
  Dockerfile – builds the frontend container

Nginx:
  Nginx functions as a reverse proxy and web server.
  
Responsibilities:
 -Serve frontend content
 -Route API calls to the backend
 -Manage HTTP traffic
 -protect the backend from unauthorized access

Files:
  nginx.conf – Nginx configuration
  Dockerfile – builds the nginx container

PS: Edits to likely be made on the project and thus this README.md
