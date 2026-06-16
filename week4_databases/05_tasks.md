# 1. Run PostgreSQL using Docker Compose


```yml
services:
  postgres:
    image: postgres:16-alpine
    container_name: postgres
    restart: always
    environment:
      POSTGRES_DB: task4
      POSTGRES_USER: kailash
      POSTGRES_PASSWORD: kailash
    ports:
      - "5432:5432"
    volumes:
      - local-pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL","pg_isready -U kailash -d task4"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

volumes:
  local-pgdata:


```

```bash
docker compose -f week4_databases/postgresql-compose.yml up -d
```

![Postgres with docker compose](../images/screenshots/week4/postgres-1.png)
![Postgres with docker compose](../images/screenshots/week4/postgres-2.png)



## Pgadmin

```yaml

services:
  postgres:
    image: postgres:16-alpine
    container_name: postgres
    restart: always
    environment:
      POSTGRES_DB: task4
      POSTGRES_USER: kailash
      POSTGRES_PASSWORD: kailash
    ports:
      - "5432:5432"
    volumes:
      - local-pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL","pg_isready -U kailash -d task4"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s

  pgadmin:
    image: dpage/pgadmin4
    container_name: pgadmin
    restart: always
    depends_on:
      - postgres
    ports:
      - "8888:80"
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@kailash.com
      PGADMIN_DEFAULT_PASSWORD: pgpass


volumes:
  local-pgdata:
```
**connection anme** task4
**hostname** container name i.e postgres
**db name** task4
**username** kailash
**password** kailash


![Postgres with docker compose](../images/screenshots/week4/postgres-3.png)

**pgadmin dashboard**
![Pgadmin dashboard](../images/screenshots/week4/postgres-4.png)


## using env vars in docker compose

```bash
vim week4_databases/.env


```
![env vars with docker compose](../images/screenshots/week4/postgres-5.png)


---

# 2. Explain why volumes are needed for databases.

Docker volumes are important because they solve one of the biggest problems with containers: containers are temporary, but data should not be.

## What happens without a volume?

If we run PostgreSQL in Docker without a volume, the database files are stored inside the container filesystem.

That means:

 - we insert data into PostgreSQL
 - we stop or delete the container: docker rm postgres
 - Our entire data in the database with in that conatiner is also gone because containers are designed to be ephemeral (temporary).

## What a Docker volume does

This line in our compose file:

```yaml
volumes:
  - local-pgdata:/var/lib/postgresql/data
```
means: “Store PostgreSQL data outside the container, in a persistent Docker-managed storage area.”

So now:

 - Container can be deleted
 - Image can be updated
 - We can recreate the container anytime
 - But our data remains safe.

## Why local-pgdata: is written like this

```yaml
volumes:
  local-pgdata:
```

This tells Docker: “Create and manage a named volume for me.”

Docker stores it internally (not inside our project folder), usually like:`/var/lib/docker/volumes/`

## Why volumes are critical for databases

For systems like: PostgreSQL, MySQL, MongoDB data persistence is EVERYTHING.

Without volumes:

 - logs disappear
 - tables disappear
 - users disappear

With volumes: database behaves like a real production system.


### Bind mount vs Volume

| Feature                  | Bind Mount                                    | Docker Volume                             |
| ------------------------ | --------------------------------------------- | ----------------------------------------- |
| Definition               | Maps a specific folder/file from host machine | Docker-managed storage location           |
| Where data is stored     | our computer (we choose path)                 | Inside Docker storage system              |
| Example (Docker Compose) | `- ./data:/var/lib/postgresql/data`           | `- local-pgdata:/var/lib/postgresql/data` |
| Example (Docker run)     | `docker run -v $(pwd)/data:/data ubuntu`      | `docker run -v myvolume:/data ubuntu`     |
| Control                  | Full control by user                          | Controlled by Docker                      |
| Portability              | Depends on host path                          | Works anywhere                            |
| Best use case            | Development, live code editing                | Databases, production apps                |
| Visibility               | Easy (visible in your folder)                 | Hidden (`/var/lib/docker/volumes/`)       |
| Risk                     | Higher (accidental deletion/modification)     | Lower (safer managed storage)             |

