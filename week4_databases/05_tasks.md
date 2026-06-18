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




# 3. Create one PostgreSQL table and insert/select/update/delete data.

PostgreSQL Practice Questions for DevOps Engineers


## Section 1 — DDL: Create Tables

**Q1.** Create a `servers` table with the following columns:
- `id` — auto-incrementing primary key
- `hostname` — up to 100 chars, not null, must be unique
- `ip_address` — up to 15 chars
- `environment` — only allows values `dev`, `staging`, or `prod` (use a CHECK constraint)
- `region` — up to 30 chars
- `is_active` — boolean, defaults to `TRUE`
- `created_at` — timestamp with timezone, defaults to current time

![servers table](../images/screenshots/week4/q-1.png)

**Q2.** Create a `services` table with:
- `id` — auto-incrementing primary key
- `name` — up to 100 chars, not null
- `version` — up to 20 chars
- `server_id` — foreign key referencing `servers(id)`, set to NULL if the server is deleted
- `status` — only allows `running`, `stopped`, or `failed`; defaults to `running`
- `port` — integer
- `deployed_at` — timestamp with timezone, defaults to current time

![services table](../images/screenshots/week4/q-2.png)

**Q3.** Create a `deployments` table with:
- `id` — auto-incrementing primary key
- `service_id` — foreign key referencing `services(id)`, cascade delete if service is removed
- `deployed_by` — up to 100 chars
- `image_tag` — up to 100 chars
- `success` — boolean
- `duration_sec` — integer
- `deployed_at` — timestamp with timezone, defaults to current time

![servers table](../images/screenshots/week4/q-3.png)

**Q4.** Create an `alerts` table with:
- `id` — auto-incrementing primary key
- `server_id` — foreign key referencing `servers(id)`
- `severity` — only allows `info`, `warning`, or `critical`
- `message` — text
- `resolved` — boolean, defaults to `FALSE`
- `created_at` — timestamp with timezone, defaults to current time
![servers table](../images/screenshots/week4/q-4.png)

**Q5.** Create a `logs` table with:
- `id` — big auto-incrementing primary key (`BIGSERIAL`)
- `server_id` — foreign key referencing `servers(id)`
- `level` — only allows `DEBUG`, `INFO`, `WARN`, or `ERROR`
- `message` — text
- `metadata` — JSONB column for structured log data
- `logged_at` — timestamp with timezone, defaults to current time
![servers table](../images/screenshots/week4/q-5.png)

---

## Section 2 — INSERT

**Q6.** Insert three servers in a single statement:
- `web-prod-01`, IP `10.0.1.10`, environment `prod`, region `us-east-1`
- `api-staging-01`, IP `10.0.2.20`, environment `staging`, region `us-west-2`
- `db-dev-01`, IP `10.0.3.30`, environment `dev`, region `eu-west-1`
![Insert into servers table](../images/screenshots/week4/q-6.png)

**Q7.** Insert a service called `nginx` version `1.25.3` on server `web-prod-01`. Look up the server's `id` using a subquery inside the INSERT — do not hardcode the ID.
![servers table](../images/screenshots/week4/q-7.png)

**Q8.** Insert a deployment record for service ID `1`, deployed by `jenkins`, image tag `v2.1.0`, it succeeded and took `142` seconds. Use `RETURNING id, deployed_at` to confirm the insert.
![servers table](../images/screenshots/week4/q-8.png)

**Q9.** Insert a `critical` alert for server `web-prod-01` with message `Disk usage exceeded 90%`. Use a subquery to get the server ID.
![servers table](../images/screenshots/week4/q-9.png)

**Q10.** Insert a log entry for server ID `1` with level `ERROR`, message `OOM killed`, and a JSONB `metadata` field containing `{"pod": "api-pod-3", "namespace": "production", "exit_code": 137}`.
![servers table](../images/screenshots/week4/q-10.png)

---

## Section 3 — SELECT & Filtering

**Q11.** Retrieve `hostname`, `ip_address`, and `environment` for all active `prod` servers.
![servers table](../images/screenshots/week4/q-11.png)

**Q12.** Find all services that are currently in `failed` status. Show service name, version, and the `deployed_at` timestamp.
![servers table](../images/screenshots/week4/q-12.png)

**Q13.** List all deployments that failed (`success = FALSE`) and took longer than `120` seconds, ordered by `duration_sec` descending.
![servers table](../images/screenshots/week4/q-13.png)

**Q14.** Find all alerts created in the last 24 hours that are not yet resolved.
![servers table](../images/screenshots/week4/q-14.png)

**Q15.** Search logs for entries where the message contains the word `timeout` (case-insensitive). Show `level`, `message`, and `logged_at`.
![servers table](../images/screenshots/week4/q-15.png)


---

## Section 4 — JOINs

**Q16.** List every service along with the hostname and environment of the server it runs on. Use an `INNER JOIN`. Include service `name`, `status`, server `hostname`, and `environment`.
![servers table](../images/screenshots/week4/q-16.png)

**Q17.** Show all servers and any services deployed on them. Include servers that have **no services** (use a `LEFT JOIN`). Display `hostname`, `environment`, and service `name` (NULL if none).
![servers table](../images/screenshots/week4/q-17.png)

**Q18.** List all deployments with the service name, the server hostname, and who deployed it. This requires joining `deployments → services → servers`.
![servers table](../images/screenshots/week4/q-18.png)

**Q19.** Find all services that have **never had a deployment**. Use a `LEFT JOIN` between `services` and `deployments` and filter for NULLs.
![servers table](../images/screenshots/week4/q-19.png)

**Q20.** Show every server alongside its unresolved alert count. Include servers with zero alerts (use `LEFT JOIN` + `GROUP BY`). Order by alert count descending.
![servers table](../images/screenshots/week4/q-20.png)

**Q21.** List all `critical` alerts together with the server `hostname`, `ip_address`, and the service `name` running on that server. Join `alerts → servers → services`.
![servers table](../images/screenshots/week4/q-21.png)

---

## Section 5 — Aggregation & GROUP BY

**Q22.** Count the total number of servers per environment (`dev`, `staging`, `prod`).
![servers table](../images/screenshots/week4/q-22.png)

**Q23.** For each service, show the total number of deployments, how many succeeded, and how many failed. Use conditional aggregation (`COUNT + CASE WHEN`).

```SQL
task4=# For each service, show the total number of deployments, how many succeeded, and how many failed. Use conditional aggregation (`COUNT + CASE WHEN`).
task4-# 
task4=# SELECT * FROM services;
 id |   name   | version | server_id | status  | port |          deployed_at          
----+----------+---------+-----------+---------+------+-------------------------------
  1 | nginx    | 1.25.3  |         1 | running |   80 | 2026-06-17 03:21:32.881805+00
  2 | nginx    | 1.25.3  |         1 | running |   80 | 2026-06-17 03:54:01.772098+00
  3 | apache   | 2.4.58  |         2 | stopped | 8080 | 2026-06-17 03:54:01.772098+00
  4 | postgres | 16.2    |         3 | failed  | 5432 | 2026-06-17 03:54:01.772098+00
(4 rows)

task4=# selecct * from deployments;
ERROR:  syntax error at or near "selecct"
LINE 1: selecct * from deployments;
        ^
task4=# select * from deployments;
 id | service_id |  deployed_by   | image_tag | success | duration_sec |          deployed_at          
----+------------+----------------+-----------+---------+--------------+-------------------------------
  1 |          1 | jenkins        | v2.1.0    | t       |          142 | 2026-06-17 03:30:52.289168+00
  2 |          1 | jenkins        | v2.1.0    | f       |          180 | 2026-06-17 04:09:36.819063+00
  3 |          2 | gitlab-ci      | v1.5.0    | f       |          250 | 2026-06-17 04:09:36.819063+00
  4 |          3 | jenkins        | v3.0.1    | f       |          320 | 2026-06-17 04:09:36.819063+00
  5 |          1 | github-actions | v2.2.0    | t       |           90 | 2026-06-17 04:09:36.819063+00
  6 |          2 | jenkins        | v1.6.0    | t       |          140 | 2026-06-17 04:09:36.819063+00
(6 rows)

task4=# SELECT s.name, COUNT(d.id) AS total_number_of_deployments  FROM serv
servers          servers_id_seq   services         services_id_seq 
task4=# SELECT s.name, COUNT(d.id) AS total_number_of_deployments  FROM services s INNER JOIN deployments AS d ON s.id = d.service_id;
ERROR:  column "s.name" must appear in the GROUP BY clause or be used in an aggregate function
LINE 1: SELECT s.name, COUNT(d.id) AS total_number_of_deployments  F...
               ^
task4=# SELECT s.name, COUNT(d.id) AS total_number_of_deployments  FROM services s INNER JOIN deployments AS d ON s.id = d.service_id GROUP BY s.name;
  name  | total_number_of_deployments 
--------+-----------------------------
 apache |                           1
 nginx  |                           5
(2 rows)

task4=# SELECT s.id, s.name, COUNT(d.id) AS total_number_of_deployments, COUNT (CASE WHEN d.success = true THEN 1 END) AS succeful_deployments, COUNT (CASE WHEN d.success =
false THEN 1 END) AS failed_deploymenrs  FROM services s INNER JOIN deployments AS d ON s.id = d.service_id GROUP BY s.id,s.name ORDER BY s.id;
 id |  name  | total_number_of_deployments | succeful_deployments | failed_deploymenrs 
----+--------+-----------------------------+----------------------+--------------------
  1 | nginx  |                           3 |                    2 |                  1
  2 | nginx  |                           2 |                    1 |                  1
  3 | apache |                           1 |                    0 |                  1
(3 rows)

task4=# SELECT s.id, s.name, COUNT(d.id) AS total_number_of_deployments, COUNT (CASE WHEN d.success = true THEN 1 END) AS succeful_deployments, COUNT (CASE WHEN d.success =
false THEN 1 END) AS failed_deploymenrs  FROM services s LEFT JOIN deployments AS d ON s.id = d.service_id GROUP BY s.id,s.name ORDER BY s.id;
 id |   name   | total_number_of_deployments | succeful_deployments | failed_deploymenrs 
----+----------+-----------------------------+----------------------+--------------------
  1 | nginx    |                           3 |                    2 |                  1
  2 | nginx    |                           2 |                    1 |                  1
  3 | apache   |                           1 |                    0 |                  1
  4 | postgres |                           0 |                    0 |                  0
(4 rows)

task4=# 

```

**Q24.** Find the average deployment duration per service. Only include services that have had at least `3` deployments. Use `HAVING`.
![servers table](../images/screenshots/week4/q-24.png)

**Q25.** Show the server with the highest number of `ERROR` level log entries. Return only the top 1 result.
![servers table](../images/screenshots/week4/q-25.png)

**Q26.** List each region along with the count of active servers and the count of distinct environments in that region.
![servers table](../images/screenshots/week4/q-26.png)

---

## Section 6 — UPDATE

**ref**: https://www.w3schools.com/postgresql/postgresql_update.php


**Q27.** Mark all services on `db-dev-01` as `stopped`. Use a subquery to find the server ID.
![servers table](../images/screenshots/week4/q-27.png)

**Q28.** Set `resolved = TRUE` for all `warning` alerts older than 7 days.
![servers table](../images/screenshots/week4/q-28.png)

**Q29.** Bump the version of service `nginx` to `1.26.0` and update its `deployed_at` to `NOW()` in a single `UPDATE` statement.
![servers table](../images/screenshots/week4/q-29.png)

**Q30.** For every server in the `dev` environment, set `is_active = FALSE`. Use `RETURNING hostname` to confirm which rows were affected.
![servers table](../images/screenshots/week4/q-30.png)

---

## Section 7 — DELETE

**Q31.** Delete all `DEBUG` level logs older than 30 days to simulate a log rotation job.
![servers table](../images/screenshots/week4/q-31.png)

**Q32.** Delete all deployments linked to services that are currently in `failed` status. Use a subquery.
![servers table](../images/screenshots/week4/q-32.png)

**Q33.** Delete the server with hostname `db-dev-01`. Observe what happens to services that had `server_id` referencing it — explain why based on the constraint you defined in Q2.
![servers table](../images/screenshots/week4/q-33.png)

***explanation:*** The deletion of db-dev-01 failed because the logs table's foreign key (fk_server_logs) prevented removing a server that is still referenced by log records. Since the server row was not deleted, no effect occurred on the services table. The effect on services (cascade delete, set null, or restriction) would only be observable after resolving the blocking log references and successfully deleting the server.

---


# 4.  Run MongoDB using Docker Compose.


```yml
services:
  mongodb:
    image: mongo:7
    container_name: mongodb
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: adminpass
      MONGO_INITDB_DATABASE: task4
    volumes:
      - mongodata:/data/db
    ports:
      - "27017:27017"
    healthcheck:
      test: ["CMD","mongosh","--eval","db.adminCommand('ping')"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
    networks:
      - "mongonet"

volumes:
  mongodata:

networks:
  mongonet:
    driver: bridge
```

```bash
docker compose -f week4_databases/postgresql-compose.yml up -d
```

![MONGODB with docker compose](../images/screenshots/week4/mongo-1.png)


## mongo compass (since the mongo compass image is not availabe we will use similar but light weight web ui called mongo express)

```yaml
services:
  mongodb:
    image: mongo:7
    container_name: mongodb
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: adminpass
      MONGO_INITDB_DATABASE: task4
    volumes:
      - mongodata:/data/db
    ports:
      - "27017:27017"
    healthcheck:
      test: ["CMD","mongosh","--eval","db.adminCommand('ping')"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
    networks:
      - "mongonet"

  mongo-express:
    image: mongo-express:latest
    container_name: mongo-express
    restart: unless-stopped
    depends_on:
      - mongodb
    environment:
      # mongo db connection setting
      ME_CONFIG_MONGODB_ENABLE_ADMIN: "true"
      ME_CONFIG_MONGODB_URL: mongodb://admin:adminpass@mongodb:27017/

      # web ui basic auth access
      ME_CONFIG_BASICAUTH_ENABLED: "true"
      ME_CONFIG_BASICAUTH_USERNAME: kailash
      ME_CONFIG_BASICAUTH_PASSWORD: kailash
    ports:
      - "8085:8081"
    networks:
      - mongonet

volumes:
  mongodata:

networks:
  mongonet:
    driver: bridge

```

### error and trouble shooting

```bash


Could not connect to database using connectionString: mongodb://admin:****@mongodb:27017/"
/app/node_modules/mongodb/lib/cmap/connection.js:227
                    callback(new error_1.MongoServerError(document));
                             ^

MongoServerError: Authentication failed.
    at Connection.onMessage (/app/node_modules/mongodb/lib/cmap/connection.js:227:30)
    at MessageStream.<anonymous> (/app/node_modules/mongodb/lib/cmap/connection.js:60:60)
    at MessageStream.emit (node:events:517:28)
    at processIncomingData (/app/node_modules/mongodb/lib/cmap/message_stream.js:125:16)
    at MessageStream._write (/app/node_modules/mongodb/lib/cmap/message_stream.js:33:9)
    at writeOrBuffer (node:internal/streams/writable:392:12)
    at _write (node:internal/streams/writable:333:10)
    at Writable.write (node:internal/streams/writable:337:10)
    at Socket.ondata (node:internal/streams/readable:809:22)
    at Socket.emit (node:events:517:28) {
  ok: 0,
  code: 18,
  codeName: 'AuthenticationFailed',
  connectionGeneration: 0,
  [Symbol(errorLabels)]: Set(2) { 'HandshakeError', 'ResetPool' }
}

Node.js v18.20.3


```

This error is caused by a MongoDB username/password mismatch.

In our mongodb service we create the root user:

```yml
MONGO_INITDB_ROOT_USERNAME: admin
MONGO_INITDB_ROOT_PASSWORD: adminpass
```

So the valid credentials are:

username: admin
password: adminpass

But our mongo-express container is trying to connect with:

```yml
ME_CONFIG_MONGODB_URL: mongodb://admin:adminpass123@mongodb:27017/
```
It uses:

username: admin
password: adminpass123  this is wrong

which causes:

MongoServerError: Authentication failed.
codeName: AuthenticationFailed


**Fix**

Change:
```
ME_CONFIG_MONGODB_URL: mongodb://admin:adminpass@mongodb:27017/
```

**connection anme** task4
**hostname** container name i.e postgres
**db name** task4
**username** kailash
**password** kailash


![Mongo express](../images/screenshots/week4/mongo-2.png)

**mongo express web ui**
![mongo express web uid](../images/screenshots/week4/mongo-3.png)


## using env vars in docker compose

```bash
vim week4_databases/.env

```

```yml
services:
  mongodb:
    image: mongo:7
    container_name: mongodb
    restart: always
    env_file:
      - .env
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_ROOT_USERNAME}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_ROOT_PASSWORD}
      MONGO_INITDB_DATABASE: ${MONGO_DATABASE}
    volumes:
      - mongodata:/data/db
    ports:
      - "27017:27017"
    healthcheck:
      test:
        [
          "CMD",
          "mongosh",
          "--username",
          "${MONGO_ROOT_USERNAME}",
          "--password",
          "${MONGO_ROOT_PASSWORD}",
          "--authenticationDatabase",
          "admin",
          "--eval",
          "db.adminCommand('ping')"
        ]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
    networks:
      - "mongonet"

  mongo-express:
    image: mongo-express:latest
    container_name: mongo-express
    restart: unless-stopped
    depends_on:
      mongodb:
        condition: service_healthy

    env_file:
      - .env

    environment:
      # mongo db connection setting
      ME_CONFIG_MONGODB_ENABLE_ADMIN: "true"
      ME_CONFIG_MONGODB_URL: mongodb://${MONGO_ROOT_USERNAME}:${MONGO_ROOT_PASSWORD}@mongodb:27017/?authSource=admin

      # web ui basic auth access
      ME_CONFIG_BASICAUTH_ENABLED: "true"
      ME_CONFIG_BASICAUTH_USERNAME: ${MONGO_EXPRESS_USERNAME}
      ME_CONFIG_BASICAUTH_PASSWORD: ${MONGO_EXPRESS_PASSWORD}
    ports:
      - "8085:8081"
    networks:
      - mongonet

volumes:
  mongodata:

networks:
  mongonet:
    driver: bridge

```

**enter into the mongodb container** 

```bash
docker exec -it mongodb mongosh \
-u admin \
-p adminpass \
--authenticationDatabase admin

```
```bash

kailashbadu@ubuntu:~/Desktop/Learning/codavatar-devops-intern$ docker exec -it mongodb /bin/bash
root@dd777441418b:/# mongosh
Current Mongosh Log ID:	6a3390da6789a2a1679df8a2
Connecting to:		mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+2.8.3
Using MongoDB:		7.0.37
Using Mongosh:		2.8.3

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

test> use task4;
switched to db task4
task4> db.task,insertOne({})
ReferenceError: insertOne is not defined
task4> 

task4> db.tasks.insertOne({ name: "Kailash Badu",status: "created", createdAt: new Date()})
MongoServerError[Unauthorized]: Command insert requires authentication
task4> exit
root@dd777441418b:/# mongosh  -u admin -p adminpass --authenticationDatabase admin
Current Mongosh Log ID:	6a33918ea38894ecb79df8a2
Connecting to:		mongodb://<credentials>@127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&authSource=admin&appName=mongosh+2.8.3
Using MongoDB:		7.0.37
Using Mongosh:		2.8.3

For mongosh info see: https://www.mongodb.com/docs/mongodb-shell/

------
   The server generated these startup warnings when booting
   2026-06-18T06:28:49.516+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
   2026-06-18T06:28:49.779+00:00: Soft rlimits for open file descriptors too low
------

test> db.tasks.insertOne({ name: "Kailash Badu",status: "created", createdAt: new Date()})
{
  acknowledged: true,
  insertedId: ObjectId('6a339193a38894ecb79df8a3')
}
test> show ebs
MongoshInvalidInputError: [COMMON-10001] 'ebs' is not a valid argument for "show".
test> show dbs
admin   100.00 KiB
config  108.00 KiB
local    72.00 KiB
test      8.00 KiB
test> db.tasks.find()
[
  {
    _id: ObjectId('6a339193a38894ecb79df8a3'),
    name: 'Kailash Badu',
    status: 'created',
    createdAt: ISODate('2026-06-18T06:34:59.147Z')
  }
]
test> 

```
---

# 5. Create one MongoDB collection and insert/find/update/delete documents.

## 1. Create Database and Collection

**1. Create a database named `task4`.**

```mongosh
test> show dbs;
admin   100.00 KiB
config  148.00 KiB
local    72.00 KiB
test     40.00 KiB
test> use task4;
switched to db task4
task4> show dbs;
admin   100.00 KiB
config  148.00 KiB
local    72.00 KiB
test     40.00 KiB
task4>
```

**2. Create a collection named `users` inside the `task4` database.**

```mongosh
task4> show collections;

task4> db.createCollection("users");
{ ok: 1 }
task4> show collections;
users
task4> 

```

## 2. Insert Documents

**3. Insert one user document with the following fields:**

```json
{
  "name": "Kailash",
  "age": 25,
  "email": "kailash@example.com",
  "role": "developer"
}
```
```mongosh

MongoshInvalidInputError: [COMMON-10001] Missing required argument at position 0 (Collection.insertOne)
task4> db.users.insertOne(
| {
| "name": "Kailash",
| "age": 24,
| "email": "kailash@codavatr.com"
| "role": "DevOps Intern"
Uncaught:
SyntaxError: Unexpected token, expected "," (6:0)

  4 | "age": 24,
  5 | "email": "kailash@codavatr.com"
> 6 | "role": "DevOps Intern"
    | ^
  7 |

task4> db.users.insertOne( { "name": "Kailash", "age": 24, "email": "kailash@codavatr.com" "role": "DevOps Intern"})
Uncaught:
SyntaxError: Unexpected token, expected "," (1:84)

> 1 | db.users.insertOne( { "name": "Kailash", "age": 24, "email": "kailash@codavatr.com" "role": "DevOps Intern"})
    |                                                                                     ^
  2 |

task4> db.users.insertOne( { "name": "Kailash", "age": 24, "email": "kailash@codavatr.com", "role": "DevOps Intern"})
{
  acknowledged: true,
  insertedId: ObjectId('6a339abfa38894ecb79df8a4')
}
task4> db.users.find();
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'DevOps Intern'
  }
]
task4> 


```

**4. Insert multiple user documents at once:**
```json
[
  {
    "name": "Ram",
    "age": 30,
    "email": "ram@example.com",
    "role": "admin"
  },
  {
    "name": "Sita",
    "age": 22,
    "email": "sita@example.com",
    "role": "tester"
  },
  {
    "name": "Hari",
    "age": 28,
    "email": "hari@example.com",
    "role": "developer"
  }
]
```

```mongosh

task4> db.users.insertMany([
|   {
|     "name": "Ram",
|     "age": 30,
|     "email": "ram@example.com",
|     "role": "admin"
|   },
|   {
|     "name": "Sita",
|     "age": 22,
|     "email": "sita@example.com",
|     "role": "tester"
|   },
|   {
|     "name": "Hari",
|     "age": 28,
|     "email": "hari@example.com",
|     "role": "developer"
|   }
| ]);
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId('6a339b34a38894ecb79df8a5'),
    '1': ObjectId('6a339b34a38894ecb79df8a6'),
    '2': ObjectId('6a339b34a38894ecb79df8a7')
  }
}
task4> db.users.find();
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'DevOps Intern'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a6'),
    name: 'Sita',
    age: 22,
    email: 'sita@example.com',
    role: 'tester'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 28,
    email: 'hari@example.com',
    role: 'developer'
  }
]
task4> 


```

**5. Insert a new user with additional fields:**

```json

{
  "name": "John",
  "age": 35,
  "email": "john@example.com",
  "role": "manager",
  "skills": [
    "Docker",
    "MongoDB",
    "Node.js"
  ]
}
```
```mongosh
task4> db.users.insertOne({
|   "name": "John",
|   "age": 35,
|   "email": "john@example.com",
|   "role": "manager",
|   "skills": [
|     "Docker",
|     "MongoDB",
|     "Node.js"
|   ]
| });
{
  acknowledged: true,
  insertedId: ObjectId('6a339b9aa38894ecb79df8a8')
}
task4> db.users.find();
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'DevOps Intern'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a6'),
    name: 'Sita',
    age: 22,
    email: 'sita@example.com',
    role: 'tester'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 28,
    email: 'hari@example.com',
    role: 'developer'
  },
  {
    _id: ObjectId('6a339b9aa38894ecb79df8a8'),
    name: 'John',
    age: 35,
    email: 'john@example.com',
    role: 'manager',
    skills: [ 'Docker', 'MongoDB', 'Node.js' ]
  }
]
task4> 


```

## Find Operations

**6. Find all users: Write a query to display all documents from the users collection.**

```mongosh
task4> db.users.find({}).pretty()
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'DevOps Intern'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a6'),
    name: 'Sita',
    age: 22,
    email: 'sita@example.com',
    role: 'tester'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 28,
    email: 'hari@example.com',
    role: 'developer'
  },
  {
    _id: ObjectId('6a339b9aa38894ecb79df8a8'),
    name: 'John',
    age: 35,
    email: 'john@example.com',
    role: 'manager',
    skills: [ 'Docker', 'MongoDB', 'Node.js' ]
  }
]
task4> 

```

**7. Find a user by name: Find the user whose name is: kailash**

```mongosh
task4> db.users.find({name: "kailash"})

task4> db.users.find({name: "Kailash"})
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'DevOps Intern'
  }
]
task4> db.users.find({name: {$regex: "^kailash$",$options: "i"}})
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'DevOps Intern'
  }
]
task4> 

```

**8. Find users by role. Find all users who have the role: developer**

```mongosh
task4> db.users.find({role: "developer"})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 28,
    email: 'hari@example.com',
    role: 'developer'
  }
]
task4> 

```

**9. Find users older than 25. Write a query to find users where: age > 25**
```mongosh
task4> db.users.find({age: {$gt: 25}})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 28,
    email: 'hari@example.com',
    role: 'developer'
  },
  {
    _id: ObjectId('6a339b9aa38894ecb79df8a8'),
    name: 'John',
    age: 35,
    email: 'john@example.com',
    role: 'manager',
    skills: [ 'Docker', 'MongoDB', 'Node.js' ]
  }
]
task4> db.users.find({age: {$gte: 25}})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 28,
    email: 'hari@example.com',
    role: 'developer'
  },
  {
    _id: ObjectId('6a339b9aa38894ecb79df8a8'),
    name: 'John',
    age: 35,
    email: 'john@example.com',
    role: 'manager',
    skills: [ 'Docker', 'MongoDB', 'Node.js' ]
  }
]
task4> db.users.find({age: {$lt: 25}})
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'DevOps Intern'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a6'),
    name: 'Sita',
    age: 22,
    email: 'sita@example.com',
    role: 'tester'
  }
]
task4> db.users.find({age: {$lte: 25}})
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'DevOps Intern'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a6'),
    name: 'Sita',
    age: 22,
    email: 'sita@example.com',
    role: 'tester'
  }
]
task4> 

```


**10. Find only specific fields**

Display only: name, email

Do not display:_id

```mongosh
task4> db.users.find({},{name:1,email:1})
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    email: 'kailash@codavatr.com'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    email: 'ram@example.com'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a6'),
    name: 'Sita',
    email: 'sita@example.com'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    email: 'hari@example.com'
  },
  {
    _id: ObjectId('6a339b9aa38894ecb79df8a8'),
    name: 'John',
    email: 'john@example.com'
  }
]
task4> db.users.find({},{_id:0,name:1,email:1})
[
  { name: 'Kailash', email: 'kailash@codavatr.com' },
  { name: 'Ram', email: 'ram@example.com' },
  { name: 'Sita', email: 'sita@example.com' },
  { name: 'Hari', email: 'hari@example.com' },
  { name: 'John', email: 'john@example.com' }
]
task4> 

```

## Update Operations

**11. Update one document. Change Kailash's role from: developer to senior developer**
```mongosh
task4> db.users.find({name:"Kailash"},{$set: {role: "Associate DevOps Engineer"}})
MongoServerError[Location16410]: FieldPath field names may not start with '$'. Consider using $getField or $setField.
task4> db.users.updateOne({name:"Kailash"},{$set: {role: "Associate DevOps Engineer"}})
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
task4> db.users.find({name:"Kailash"})
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'Associate DevOps Engineer'
  }
]
task4> 

```

**12. Add a new field, Add a new field called: 'experience' to Hari's document.* 
```mongosh
task4> db.users.updateOne({name: "Hari"},{$set {"experience": {role:"sales",years:2}})
Uncaught:
SyntaxError: Unexpected token, expected "," (1:40)

> 1 | db.users.updateOne({name: "Hari"},{$set {"experience": {role:"sales",years:2}})
    |                                         ^
  2 |

task4> db.users.updateOne({name: "Hari"},{$set: {experience: {role:"sales",years:2}})
Uncaught:
SyntaxError: Unexpected token, expected "," (1:77)

> 1 | db.users.updateOne({name: "Hari"},{$set: {experience: {role:"sales",years:2}})
    |                                                                              ^
  2 |

task4> db.users.updateOne({name: "Hari"},{$set: {experience: {role:"sales",years:2}}})
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
task4> db.users.find({name: "Hari"})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 28,
    email: 'hari@example.com',
    role: 'developer',
    experience: { role: 'sales', years: 2 }
  }
]
task4> 

```

**13. Update multiple documents. Increase the age of all developers by 1.**
```mongosh

task4> db.users.find({name: "Hari"})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 28,
    email: 'hari@example.com',
    role: 'developer',
    experience: { role: 'sales', years: 2 }
  }
]
task4> db.users.updateMany({role:'developer'},{$inc: {age: 1}})
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
task4> db.users.find({name: "Hari"})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 29,
    email: 'hari@example.com',
    role: 'developer',
    experience: { role: 'sales', years: 2 }
  }
]

```

## Delete Operations

**14. Delete one document**

Delete the user whose email is: john@example.com


```mongosh
task4> db.users.deleteOne({email: "john@example.com"})
{ acknowledged: true, deletedCount: 1 }
task4> db.users.find({email:"john@example.com"})

task4> 

```
**15. Delete multiple documents**

Delete all users whose role is:tester

```mongosh
task4> db.users.find({role: "tester"})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a6'),
    name: 'Sita',
    age: 22,
    email: 'sita@example.com',
    role: 'tester'
  }
]
task4> db.users.deleteMany({role: "tester"})
{ acknowledged: true, deletedCount: 1 }
task4> db.users.find({role: "tester"})

task4> 
```

**16. Count documents**

Find the total number of users in the collection.

```mongosh

task4> db.users.countDocuments();
3
task4> 


```

**17. Sort users**

Display users sorted by:

- age ascending

- age descending

```mongosh
task4> db.users.find().sort({age:1})
[
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'Associate DevOps Engineer'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 29,
    email: 'hari@example.com',
    role: 'developer',
    experience: { role: 'sales', years: 2 }
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  }
]
task4> db.users.find().sort({age:-1})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 29,
    email: 'hari@example.com',
    role: 'developer',
    experience: { role: 'sales', years: 2 }
  },
  {
    _id: ObjectId('6a339abfa38894ecb79df8a4'),
    name: 'Kailash',
    age: 24,
    email: 'kailash@codavatr.com',
    role: 'Associate DevOps Engineer'
  }
]
task4> 

```

**18. Limit results**

Display only the first 2 users.

```mongosh

task4> db.users.find().sort({age:-1}).limit(2)
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 29,
    email: 'hari@example.com',
    role: 'developer',
    experience: { role: 'sales', years: 2 }
  }
]
task4> 


```

**19. Search using multiple conditions**

Find users where: age > 25 AND role = developer

```mongosh

task4> db.users.find({age: {$gt: 25}, $or: [{role: "developer"},{role: "admin"}]})
[
  {
    _id: ObjectId('6a339b34a38894ecb79df8a5'),
    name: 'Ram',
    age: 30,
    email: 'ram@example.com',
    role: 'admin'
  },
  {
    _id: ObjectId('6a339b34a38894ecb79df8a7'),
    name: 'Hari',
    age: 29,
    email: 'hari@example.com',
    role: 'developer',
    experience: { role: 'sales', years: 2 }
  }
]
task4>

```

**20. Drop collection**

Delete the entire users collection.

```mongosh
task4> db.users.drop();
true
task4> show collections;

task4> 


```
