# PostgreSQL

## What is PostgreSQL?

PostgreSQL is a powerful, open-source **object-relational database system** that extends SQL with features designed to safely store and scale the most complex data workloads. It originated in 1986 as the POSTGRES project at UC Berkeley and has nearly 40 years of active development.

Key characteristics:
- Supports **table inheritance** and **user-defined types/functions**
- Handles both **relational (SQL)** and **non-relational (JSON/JSONB)** data
- Transactional, concurrent, and extensible data engine
- Guarantees **correctness, consistency, and durability** at scale

---

## Core Concepts

### ACID Properties
| Property | Description |
|---|---|
| **Atomicity** | A transaction is all-or-nothing |
| **Consistency** | DB moves from one valid state to another |
| **Isolation** | Concurrent transactions don't interfere |
| **Durability** | Committed data survives crashes |

### MVCC (Multi-Version Concurrency Control)
- PostgreSQL never overwrites existing data rows - it creates **new versions** of a row on update/delete.
- Allows **readers and writers to not block each other**.
- Old versions are cleaned up by the **VACUUM** process.
- Each transaction sees a **snapshot** of the database at a point in time.

### WAL (Write-Ahead Logging)
- All changes are written to a **WAL log before** they are applied to the actual data files.
- Ensures **crash recovery** - if the server crashes, PostgreSQL replays the WAL to restore a consistent state.
- Foundation for **replication** (streaming replication uses WAL segments).
- WAL files are stored in `$PGDATA/pg_wal/`.

### CAP Theorem
In a distributed system, you can only guarantee **two of three**:
- **C**onsistency - every read gets the most recent write
- **A**vailability - every request gets a response (not necessarily latest data)
- **P**artition Tolerance - system works despite network partitions

PostgreSQL is a **CP system** by design - it prioritizes consistency over availability.

---

## Architecture

PostgreSQL uses a **client-server architecture**.

```
Client (psql / app)
       │
       ▼
  Postmaster (main process)
       │  forks per connection
       ▼
  Backend Process --> Shared Memory (shared_buffers, WAL buffers)
       │
       ▼
  Storage Layer (heap files, indexes, WAL)
```

- **Postmaster**: The main daemon process (`postgres`). Listens for connections and forks a dedicated backend process per client connection.
- **Backend Process**: Handles a single client session - parses queries, plans, executes.
- **Background Workers**: Autovacuum, WAL writer, checkpointer, bgwriter, stats collector, etc.
- **Shared Memory**: Shared between all backend processes - includes `shared_buffers` (page cache) and WAL buffers.

---

## Storage Internals

### Database Cluster
A **database cluster** is a collection of databases managed by a single PostgreSQL server instance, stored under `$PGDATA`.

### Heap Files
- Each table is physically stored as a **heap file** on disk.
- Data is stored as a collection of **pages/blocks** in no particular order (unordered).
- Default **page size: 8 KB**.
- Each page contains:
  - **Page header**: checksum, pointers to free space start/end
  - **Item identifiers (line pointers)**: array pointing to actual tuples
  - **Tuples (rows)**: actual row data stored in the page
  - **Free space**: unused space in the middle

### TOAST (The Oversized-Attribute Storage Technique)
- PostgreSQL does **not allow a single row to span multiple data pages**.
- TOAST automatically handles large column values that would exceed 8 KB.
- Strategies: `PLAIN`, `EXTENDED` (compress + out-of-line), `EXTERNAL` (out-of-line only), `MAIN` (compress in-line if possible).
- Large values are stored in a separate **TOAST table** linked to the main table.

### Compression Algorithms
| Algorithm | Notes |
|---|---|
| **PGLZ** | Default PostgreSQL compression; lossless, LZ-family |
| **LZ4** | Optional (compile-time); faster compression/decompression than PGLZ |
| **LZW** | Used in image formats (GIF, TIFF, PDF) - **not used by PostgreSQL** |

---

## Indexes

| Index Type | Use Case |
|---|---|
| **B-Tree** | Default; equality and range queries (`=`, `<`, `>`, `BETWEEN`) |
| **Hash** | Equality only (`=`); faster for exact lookups |
| **GIN** | Full-text search, JSONB, arrays |
| **GiST** | Geometric data, full-text, range types |
| **BRIN** | Very large tables with natural physical ordering (e.g., time-series) |
| **SP-GiST** | Partitioned search trees; IP addresses, geometric data |

```sql
-- Create a B-Tree index
CREATE INDEX idx_users_email ON users(email);

-- Create a partial index
CREATE INDEX idx_active_users ON users(email) WHERE is_active = true;

-- Create a GIN index for JSONB
CREATE INDEX idx_meta ON orders USING GIN(metadata);
```

---

## Replication

### Streaming Replication (Physical)
- Primary sends **WAL segments** to standby(s) in real time.
- Standby continuously replays WAL - byte-for-byte copy of primary.
- `synchronous_commit = on` → primary waits for standby ACK before confirming commit.

```
# postgresql.conf (primary)
wal_level = replica
max_wal_senders = 5
```

```
# recovery.conf / postgresql.conf (standby, PG12+)
primary_conninfo = 'host=primary-host port=5432 user=replicator'
```

### Logical Replication
- Replicates **individual tables/rows**, not the full cluster.
- Useful for selective replication, cross-version upgrades, and migrations.

```sql
-- On publisher
CREATE PUBLICATION my_pub FOR TABLE orders, users;

-- On subscriber
CREATE SUBSCRIPTION my_sub
  CONNECTION 'host=pub-host dbname=mydb user=rep'
  PUBLICATION my_pub;
```

---

## Connection Pooling - PgBouncer

PostgreSQL forks a **new OS process per connection** - expensive at scale. PgBouncer sits in front of PostgreSQL and pools connections.

```
App --> PgBouncer (pool) --> PostgreSQL
```

Modes:
- **Session pooling**: connection held for the full client session
- **Transaction pooling**: connection returned after each transaction (most common)
- **Statement pooling**: returned after each statement

```ini
# pgbouncer.ini
[databases]
mydb = host=127.0.0.1 port=5432 dbname=mydb

[pgbouncer]
pool_mode = transaction
max_client_conn = 1000
default_pool_size = 20
```

---

## VACUUM and AUTOVACUUM

Because MVCC creates dead row versions, PostgreSQL needs periodic cleanup.

- **VACUUM**: Reclaims space from dead tuples; does **not** return space to OS.
- **VACUUM FULL**: Rewrites the table - returns space to OS but holds an exclusive lock.
- **ANALYZE**: Updates table statistics used by the query planner.
- **AUTOVACUUM**: Background daemon that runs VACUUM/ANALYZE automatically.

```sql
-- Manual vacuum with analysis
VACUUM ANALYZE orders;

-- Check bloat
SELECT relname, n_dead_tup, n_live_tup
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;
```

Key autovacuum tuning params:
```
autovacuum_vacuum_scale_factor = 0.01   -- trigger at 1% dead tuples
autovacuum_analyze_scale_factor = 0.005
```

---

## Query Planning and EXPLAIN

```sql
-- See the query plan
EXPLAIN SELECT * FROM users WHERE email = 'a@b.com';

-- See actual execution stats
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM orders WHERE user_id = 42;
```

Key nodes to look for:
- `Seq Scan` → full table scan; may need an index
- `Index Scan` / `Index Only Scan` → using an index
- `Hash Join` / `Merge Join` / `Nested Loop` → join strategies
- `Bitmap Heap Scan` → used with GIN/GiST indexes

---

## PostgreSQL for DevOps

### Docker Deployment
```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser -d mydb"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
```

### Key Environment Variables
| Variable | Description |
|---|---|
| `POSTGRES_DB` | Default database name |
| `POSTGRES_USER` | Superuser name |
| `POSTGRES_PASSWORD` | Superuser password |
| `PGDATA` | Data directory (default `/var/lib/postgresql/data`) |

### Backups

```bash
# Logical backup (pg_dump)
pg_dump -U myuser -h localhost -d mydb -F c -f mydb_$(date +%Y%m%d).dump

# Restore
pg_restore -U myuser -h localhost -d mydb mydb_20240601.dump

# Dump all databases
pg_dumpall -U postgres > all_databases.sql

# Point-in-time recovery (PITR) uses WAL archiving
archive_command = 'cp %p /mnt/wal_archive/%f'
restore_command = 'cp /mnt/wal_archive/%f %p'
```

### Kubernetes Deployment
Use **CloudNativePG** or **Zalando PostgreSQL Operator** for production K8s deployments. They handle:
- Automatic failover
- Streaming replication
- Backup/restore via WAL-G or Barman
- PodDisruptionBudgets

```yaml
# CloudNativePG example
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: pg-cluster
spec:
  instances: 3
  storage:
    size: 10Gi
```

### Important Config Parameters (`postgresql.conf`)
| Parameter | Default | Notes |
|---|---|---|
| `max_connections` | 100 | Increase with caution; use PgBouncer |
| `shared_buffers` | 128MB | Set to ~25% of RAM |
| `work_mem` | 4MB | Per sort/hash operation; can multiply fast |
| `maintenance_work_mem` | 64MB | For VACUUM, CREATE INDEX |
| `effective_cache_size` | 4GB | Hint to planner; set to ~75% of RAM |
| `wal_level` | replica | Set to `logical` for logical replication |
| `checkpoint_completion_target` | 0.9 | Spread checkpoint I/O |
| `log_slow_queries` | off | Enable with `log_min_duration_statement` |

### Monitoring Queries
```sql
-- Active connections
SELECT count(*), state FROM pg_stat_activity GROUP BY state;

-- Long-running queries
SELECT pid, now() - pg_stat_activity.query_start AS duration, query
FROM pg_stat_activity
WHERE state = 'active' AND (now() - query_start) > interval '5 minutes';

-- Table sizes
SELECT relname, pg_size_pretty(pg_total_relation_size(relid))
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Index usage
SELECT relname, indexrelname, idx_scan, idx_tup_read
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC;

-- Replication lag
SELECT client_addr, state, sent_lsn, replay_lsn,
       (sent_lsn - replay_lsn) AS replication_lag_bytes
FROM pg_stat_replication;

-- Locks
SELECT pid, relation::regclass, mode, granted
FROM pg_locks
WHERE NOT granted;
```

### Prometheus Monitoring
Use **postgres_exporter** to expose metrics to Prometheus:
```yaml
# docker-compose addition
  postgres-exporter:
    image: prometheuscommunity/postgres-exporter
    environment:
      DATA_SOURCE_NAME: "postgresql://myuser:mypassword@postgres:5432/mydb?sslmode=disable"
    ports:
      - "9187:9187"
```

Key metrics to alert on:
- `pg_stat_activity_count` - connection count
- `pg_replication_lag` - replication delay
- `pg_stat_bgwriter_checkpoint_write_time` - checkpoint pressure
- `pg_database_size_bytes` - disk usage growth

---

## Common SQL Quick Reference

```sql
-- DDL
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE users ADD COLUMN is_active BOOLEAN DEFAULT true;

-- JSONB queries
SELECT metadata->>'name' FROM users WHERE metadata @> '{"role": "admin"}';

-- Window functions
SELECT user_id, order_total,
       RANK() OVER (PARTITION BY user_id ORDER BY order_total DESC) AS rank
FROM orders;

-- CTEs
WITH recent_orders AS (
    SELECT * FROM orders WHERE created_at > NOW() - INTERVAL '7 days'
)
SELECT user_id, COUNT(*) FROM recent_orders GROUP BY user_id;

-- UPSERT
INSERT INTO users (email, metadata)
VALUES ('a@b.com', '{"role": "admin"}')
ON CONFLICT (email) DO UPDATE SET metadata = EXCLUDED.metadata;
```

---

# PostgreSQL Commands After Docker Compose Up

## 1. Start the Stack

```bash
docker compose up -d
```

Check containers are running:

```bash
docker compose ps
docker compose logs postgres
```

---

## 2. Connect to PostgreSQL

### Shell into the container first
```bash
docker exec -it <container_name> bash
# e.g.
docker exec -it postgres bash
```

### Then open psql
```bash
psql -U myuser -d mydb
# or connect to default postgres db
psql -U postgres
```

### One-liner (no shell needed)
```bash
docker exec -it postgres psql -U myuser -d mydb
```

### Connect from host machine (if port 5432 is mapped)
```bash
psql -h localhost -p 5432 -U myuser -d mydb
```

---

## 3. psql Meta Commands (Slash Commands)

| Command | Description |
|---|---|
| `\l` | List all databases |
| `\c mydb` | Switch to database `mydb` |
| `\dt` | List all tables in current DB |
| `\dt+` | List tables with sizes |
| `\d tablename` | Describe table (columns, types, constraints) |
| `\di` | List indexes |
| `\du` | List users/roles |
| `\dn` | List schemas |
| `\df` | List functions |
| `\x` | Toggle expanded output (useful for wide rows) |
| `\timing` | Toggle query execution time display |
| `\e` | Open last query in editor |
| `\i file.sql` | Run a SQL file |
| `\o output.txt` | Send query output to a file |
| `\q` | Quit psql |

---

## 4. Database Operations

```sql
-- List databases
\l

-- Create a database
CREATE DATABASE mydb;

-- Drop a database
DROP DATABASE mydb;

-- Connect to a database
\c mydb

-- Check current database and user
SELECT current_database(), current_user;
```

---

## 5. User and Role Management

```sql
-- Create a user
CREATE USER codavatar WITH PASSWORD 'secret123';

-- Create a superuser
CREATE USER admin WITH SUPERUSER PASSWORD 'adminpass';

-- Grant all privileges on a database
GRANT ALL PRIVILEGES ON DATABASE mydb TO codavatar;

-- Grant privileges on a table
GRANT SELECT, INSERT, UPDATE ON TABLE orders TO codavatar;

-- Grant privileges on all tables in schema
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO codavatar;

-- Revoke privileges
REVOKE ALL PRIVILEGES ON DATABASE mydb FROM codavatar;

-- Drop a user
DROP USER codavatar;

-- List all roles
\du
```

---

## 6. Table Operations

```sql
-- Create table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create table with foreign key
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    total NUMERIC(10, 2),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Rename a table
ALTER TABLE orders RENAME TO invoices;

-- Add a column
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Drop a column
ALTER TABLE users DROP COLUMN phone;

-- Change column type
ALTER TABLE users ALTER COLUMN name TYPE TEXT;

-- Drop a table
DROP TABLE users;

-- Drop table only if it exists
DROP TABLE IF EXISTS users;

-- Truncate (delete all rows, fast)
TRUNCATE TABLE users;

-- Truncate with cascade (also clears FK-dependent tables)
TRUNCATE TABLE users CASCADE;
```

---

## 7. CRUD Operations

```sql
-- Insert a row
INSERT INTO users (name, email) VALUES ('Jasper', 'codavatar@example.com');

-- Insert multiple rows
INSERT INTO users (name, email) VALUES
  ('Alice', 'alice@example.com'),
  ('Bob', 'bob@example.com');

-- Insert or update (UPSERT)
INSERT INTO users (email, name)
VALUES ('codavatar@example.com', 'Jasper K')
ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name;

-- Select
SELECT * FROM users;
SELECT id, name FROM users WHERE is_active = true ORDER BY created_at DESC LIMIT 10;

-- Update
UPDATE users SET is_active = false WHERE email = 'bob@example.com';

-- Delete
DELETE FROM users WHERE id = 3;
```

---

## 8. Index Operations

```sql
-- Create a B-Tree index (default)
CREATE INDEX idx_users_email ON users(email);

-- Create a unique index
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- Create a partial index (only active users)
CREATE INDEX idx_active_users ON users(email) WHERE is_active = true;

-- Create GIN index for JSONB column
CREATE INDEX idx_metadata ON products USING GIN(metadata);

-- List indexes on a table
\d users

-- Drop an index
DROP INDEX idx_users_email;

-- Rebuild an index (useful after bloat)
REINDEX INDEX idx_users_email;
REINDEX TABLE users;
```

---

## 9. Query Analysis

```sql
-- Show query plan (estimated)
EXPLAIN SELECT * FROM users WHERE email = 'codavatar@example.com';

-- Show actual execution stats
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT * FROM orders WHERE user_id = 1;

-- Timing toggle in psql
\timing
SELECT COUNT(*) FROM orders;
```

---

## 10. Transactions

```sql
-- Begin a transaction
BEGIN;

UPDATE users SET is_active = false WHERE id = 1;
DELETE FROM orders WHERE user_id = 1;

-- Commit the transaction
COMMIT;

-- Or rollback if something went wrong
ROLLBACK;

-- Savepoints
BEGIN;
UPDATE users SET name = 'Test' WHERE id = 1;
SAVEPOINT sp1;
DELETE FROM users WHERE id = 2;
ROLLBACK TO SAVEPOINT sp1;   -- undo delete, keep update
COMMIT;
```

---

## 11. Monitoring and Diagnostics

```sql
-- Show all active connections
SELECT pid, usename, datname, state, query
FROM pg_stat_activity
WHERE state != 'idle';

-- Kill a connection by PID
SELECT pg_terminate_backend(1234);

-- Long running queries (>5 min)
SELECT pid, now() - query_start AS duration, query
FROM pg_stat_activity
WHERE state = 'active'
  AND (now() - query_start) > interval '5 minutes';

-- Check table sizes
SELECT relname AS table,
       pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Check database size
SELECT pg_size_pretty(pg_database_size('mydb'));

-- Dead tuple count (MVCC bloat)
SELECT relname, n_live_tup, n_dead_tup
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC;

-- Active locks
SELECT pid, relation::regclass, mode, granted
FROM pg_locks
WHERE NOT granted;

-- Replication status (on primary)
SELECT client_addr, state, sent_lsn, replay_lsn,
       (sent_lsn - replay_lsn) AS lag_bytes
FROM pg_stat_replication;
```

---

## 12. Backup and Restore Inside Docker

### Dump a database
```bash
# From host
docker exec -t postgres pg_dump -U myuser mydb > mydb_backup.sql

# Compressed format
docker exec -t postgres pg_dump -U myuser -F c mydb > mydb_backup.dump
```

### Restore a database
```bash
# From SQL dump
docker exec -i postgres psql -U myuser -d mydb < mydb_backup.sql

# From compressed dump
docker exec -i postgres pg_restore -U myuser -d mydb mydb_backup.dump
```

### Dump all databases
```bash
docker exec -t postgres pg_dumpall -U postgres > all_databases.sql
```

---

## 13. VACUUM and Maintenance

```sql
-- Run VACUUM on a table
VACUUM users;

-- VACUUM with analysis (updates planner stats)
VACUUM ANALYZE users;

-- VACUUM FULL (rewrites table, reclaims disk — locks table)
VACUUM FULL users;

-- Analyze only (no cleanup)
ANALYZE users;

-- Manually trigger autovacuum (set threshold very low temporarily)
-- Or just run:
VACUUM VERBOSE ANALYZE users;
```

---

## 14. Useful One-liners for DevOps

```bash
# Check PostgreSQL version
docker exec -it postgres psql -U postgres -c "SELECT version();"

# Check connection count
docker exec -it postgres psql -U postgres -c "SELECT count(*) FROM pg_stat_activity;"

# Run a SQL file
docker exec -i postgres psql -U myuser -d mydb < ./init.sql

# Check if postgres is ready (for healthchecks/scripts)
docker exec -it postgres pg_isready -U myuser -d mydb

# Stream postgres logs
docker compose logs -f postgres
```

---

## 15. Sample docker-compose.yml Reference

```yaml
services:
  postgres:
    image: postgres:16-alpine
    container_name: postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: myuser
      POSTGRES_PASSWORD: mypassword
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql  # auto-runs on first start
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U myuser -d mydb"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
```

> **Note:** Any `.sql` or `.sh` files placed in `/docker-entrypoint-initdb.d/` are automatically executed when the container is first initialized (only on a fresh volume).

---


## References
1. PostgreSQL Official Docs: https://www.postgresql.org/about/
2. CAP Theorem: https://www.geeksforgeeks.org/dbms/the-cap-theorem-in-dbms/
3. PostgreSQL Architecture Video: https://youtu.be/P8rrhZTPEAQ?si=b5P8kQPldCxrO1dp
4. TOAST: https://www.postgresql.org/docs/current/storage-toast.html
5. WAL: https://www.postgresql.org/docs/current/wal-intro.html
6. CloudNativePG: https://cloudnative-pg.io/
7. PgBouncer: https://www.pgbouncer.org/
8. postgres_exporter: https://github.com/prometheus-community/postgres_exporter
9. PostgreSQL Docs: https://www.postgresql.org/docs/current/
10. psql Meta-Commands: https://www.postgresql.org/docs/current/app-psql.html
11. pg_stat_activity: https://www.postgresql.org/docs/current/monitoring-stats.html

