# Shiny R 🚀

## Shiny App Dockerized

This guide will walk you through the steps to build and run the Shiny web application using Docker.


## Prerequisites

- Docker installed on your system

## Steps with Docker

1. **Clone the Repository**: Clone this repository to your local machine:

   ```bash
   git clone https://github.com/arifulislamat/dockerize-shiny-r.git
   cd dockerize-shiny-r
   ```

2. **Build the Docker Image:** Build the Docker image using the provided Dockerfile
   
   ```bash
   docker build -t shiny-app .
   ```
3. **Run the Docker Container:** Run the Docker container, mapping the host port to the container port

   ```bash
   docker run -p 8082:8082 shiny-app
   ```

4. **Access the Shiny App:** Open your web browser and navigate to http://localhost:8082 to access the Shiny application.



