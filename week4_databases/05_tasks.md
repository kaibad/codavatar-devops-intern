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
![servers table](../images/screenshots/week4/q-1.png)

**Q12.** Find all services that are currently in `failed` status. Show service name, version, and the `deployed_at` timestamp.
![servers table](../images/screenshots/week4/q-1.png)

**Q13.** List all deployments that failed (`success = FALSE`) and took longer than `120` seconds, ordered by `duration_sec` descending.
![servers table](../images/screenshots/week4/q-1.png)

**Q14.** Find all alerts created in the last 24 hours that are not yet resolved.
![servers table](../images/screenshots/week4/q-1.png)

![servers table](../images/screenshots/week4/q-1.png)
**Q15.** Search logs for entries where the message contains the word `timeout` (case-insensitive). Show `level`, `message`, and `logged_at`.

---

## Section 4 — JOINs

**Q16.** List every service along with the hostname and environment of the server it runs on. Use an `INNER JOIN`. Include service `name`, `status`, server `hostname`, and `environment`.
![servers table](../images/screenshots/week4/q-1.png)

![servers table](../images/screenshots/week4/q-1.png)
**Q17.** Show all servers and any services deployed on them. Include servers that have **no services** (use a `LEFT JOIN`). Display `hostname`, `environment`, and service `name` (NULL if none).

**Q18.** List all deployments with the service name, the server hostname, and who deployed it. This requires joining `deployments → services → servers`.
![servers table](../images/screenshots/week4/q-1.png)

**Q19.** Find all services that have **never had a deployment**. Use a `LEFT JOIN` between `services` and `deployments` and filter for NULLs.
![servers table](../images/screenshots/week4/q-1.png)

**Q20.** Show every server alongside its unresolved alert count. Include servers with zero alerts (use `LEFT JOIN` + `GROUP BY`). Order by alert count descending.
![servers table](../images/screenshots/week4/q-1.png)

**Q21.** List all `critical` alerts together with the server `hostname`, `ip_address`, and the service `name` running on that server. Join `alerts → servers → services`.
![servers table](../images/screenshots/week4/q-1.png)

---

## Section 5 — Aggregation & GROUP BY

**Q22.** Count the total number of servers per environment (`dev`, `staging`, `prod`).
![servers table](../images/screenshots/week4/q-1.png)

**Q23.** For each service, show the total number of deployments, how many succeeded, and how many failed. Use conditional aggregation (`COUNT + CASE WHEN`).
![servers table](../images/screenshots/week4/q-1.png)

**Q24.** Find the average deployment duration per service. Only include services that have had at least `3` deployments. Use `HAVING`.
![servers table](../images/screenshots/week4/q-1.png)

**Q25.** Show the server with the highest number of `ERROR` level log entries. Return only the top 1 result.
![servers table](../images/screenshots/week4/q-1.png)

**Q26.** List each region along with the count of active servers and the count of distinct environments in that region.
![servers table](../images/screenshots/week4/q-1.png)

---

## Section 6 — UPDATE

**Q27.** Mark all services on `db-dev-01` as `stopped`. Use a subquery to find the server ID.
![servers table](../images/screenshots/week4/q-1.png)

**Q28.** Set `resolved = TRUE` for all `warning` alerts older than 7 days.
![servers table](../images/screenshots/week4/q-1.png)

**Q29.** Bump the version of service `nginx` to `1.26.0` and update its `deployed_at` to `NOW()` in a single `UPDATE` statement.
![servers table](../images/screenshots/week4/q-1.png)

**Q30.** For every server in the `dev` environment, set `is_active = FALSE`. Use `RETURNING hostname` to confirm which rows were affected.
![servers table](../images/screenshots/week4/q-1.png)

---

## Section 7 — DELETE

**Q31.** Delete all `DEBUG` level logs older than 30 days to simulate a log rotation job.
![servers table](../images/screenshots/week4/q-1.png)

**Q32.** Delete all deployments linked to services that are currently in `failed` status. Use a subquery.
![servers table](../images/screenshots/week4/q-1.png)

**Q33.** Delete the server with hostname `db-dev-01`. Observe what happens to services that had `server_id` referencing it — explain why based on the constraint you defined in Q2.
![servers table](../images/screenshots/week4/q-1.png)

---

## Section 8 — Indexes, Views & Transactions

**Q34.** Create a partial index on the `alerts` table that only indexes unresolved critical alerts (`resolved = FALSE AND severity = 'critical'`). Think about why a partial index is more efficient than a full index here.
![servers table](../images/screenshots/week4/q-1.png)

**Q35.** Create a view called `prod_service_health` that shows:
- Server `hostname`
- Service `name` and `status`
- Latest deployment's `image_tag` and `success` flag
- Total unresolved alerts for that server

Then write a SELECT against the view to find all services in `failed` status.
![servers table](../images/screenshots/week4/q-1.png)

---

## Bonus — Transaction Block

Write a transaction that does all of the following atomically:
1. Inserts a new server `cache-prod-01` in `prod`, region `us-east-1`
2. Inserts a `redis` service on that server (use the new server's ID — no hardcoding)
3. Inserts a successful deployment for that service with image tag `redis:7.2`
4. Rolls back everything if any step fails

```sql
BEGIN;
  -- your statements here
COMMIT;
![servers table](../images/screenshots/week4/q-1.png)
```
