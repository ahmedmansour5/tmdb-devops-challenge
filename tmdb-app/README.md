# Creates a Docker Compose Structure to solve Task 2&4

## To run from CMD

In project folder run

npm start

## Build Docker

In project folder run

docker build -t {image name} . 

docker run -p 3000 {image name}  

## To use Docker Compose

### Install Docker Compose

    https://docs.docker.com/compose/install

### Clone the Repository

    git clone https://github.com/ahmedmansour5/tmdb-devops-challenge.git
    cd tmdb-devops-challenge/tmdb-app/
    ls

### Start the Nginx/App service

    docker compose -f docker-compose.yml up --build -d

### Health check option has been added to allow services to restart automatically

```yaml
    services:
  tmdb:
    container_name: tmdb-app 
    healthcheck:
      test: ["CMD", "wget", "--spider", "--server-response", "http://127.0.0.1:3000"]
      interval: 1m
      timeout: 10s
      retries: 5
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    ports:
      - 3000:3000

  nginx:
    image: nginx:latest
    container_name: nginx-webserver
    healthcheck:
      test: ["CMD", "service", "nginx", "status"]
      interval: 30s
      timeout: 10s
      retries: 5
    restart: always
    ports:
    - 80:80
    volumes:
    - ./nginx/:/etc/nginx/conf.d/:ro
    - ./log/:/var/log/nginx
```