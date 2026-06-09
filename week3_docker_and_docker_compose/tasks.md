# this is the doeumentation for the week3 tasks
# topic: Docker and docker compose

## Task 1: Install Docker and verify hello-world.

## Installing docker
![docker](../../images/screenshots/week2/docker-install.png)


## Verify with verify hello-world.
![docker](../../images/screenshots/week2/docker-Hello.png)


## Task 2: Build one custom Docker image using Dockerfile.

```Dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json .
RUN npm ci
COPY . .
RUN npm run build
RUN ls -lah /app/dist

FROM nginx:alpine
WORKDIR /app
COPY --from=builder /app/dist /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
```

![Dockerfile](../../images/screenshots/week2/dockerfile-1.png)

**docker build -t tictactoe .**
![docker](../../images/screenshots/week2/dockerfile-1-build.png)

**Serve the application in the web using nginx**
![docker](../../images/screenshots/week2/dockerfile-output.png)

**Push to hub.docker.com**
![docker](../../images/screenshots/week2/docker-push.png)


