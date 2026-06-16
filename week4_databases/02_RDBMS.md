# DevOps Prerequisites – Basic RDBMS

A Relational Database Management System (RDBMS) is software that stores data in structured tables (rows and columns), and enforces relationships between those tables using keys. Data integrity is guaranteed through rules called constraints.

### Core Concepts

| Concept              | Description                           | Real-World Example                       |
| -------------------- | ------------------------------------- | ---------------------------------------- |
| **Table**            | Stores data in rows and columns       | `users` table with `id`, `name`, `email` |
| **Row (Record)**     | A single entry in a table             | One user's full data                     |
| **Column (Field)**   | A named attribute                     | `email VARCHAR(255)`                     |
| **Primary Key (PK)** | Unique identifier for each row        | `user_id INT AUTO_INCREMENT`             |
| **Foreign Key (FK)** | Links two tables together             | `orders.user_id` → `users.id`            |
| **Index**            | Speeds up lookups                     | Index on `email` for fast login queries  |
| **Schema**           | The structure/blueprint of a database | All table definitions and relationships  |
| **Constraint**       | Enforces data rules                   | `NOT NULL`, `UNIQUE`, `CHECK`            |

### ACID Properties

These are the four guarantees a proper RDBMS makes for every transaction:

```
A — Atomicity    -> All steps succeed, or none do
                   (transferring money: debit AND credit both happen, or neither)

C — Consistency  -> Data always moves from one valid state to another
                   (you can't have a negative bank balance after a withdrawal)

I — Isolation    -> Concurrent transactions don't interfere with each other
                   (two users booking the last flight seat simultaneously)

D — Durability   -> Once committed, data survives crashes
                   (your order confirmation persists even if the server dies)
```

### Real-World Scenario: Why DevOps Engineers Need This

Our team deploys a new version of the backedn application. The app fails on startup with:

```
ERROR 1045 (28000): Access denied for user 'app_user'@'172.18.0.3' (using password: YES)
```

To debug this, we need to:

1. Log into MySQL as root
2. Check what users exist and what host they're allowed from
3. Understand that `172.18.0.3` is the Docker container's IP, not `localhost`
4. Fix the grant or create a new host-based user

Without RDBMS basics, we will stuck waiting for a developer.

---
## POpular RDBMS

1. MySQL: Open source and widely used for web applications, Popular with PHP, WordPress, and many e-commerce sites.
2. PostgreSQL: Open source and feature-rich, Known for reliability, advanced SQL features, and extensibility.
3. Microsoft SQL Server: Developed by Microsoft, Common in enterprise environments and integrates well with the Microsoft ecosystem.
4. Oracle Database: eveloped by Oracle, Widely used by large enterprises for mission-critical applications.
5. SQLite: Lightweight and serverless, Commonly used in mobile apps and desktop applications.
6. MariaDB: Open-source fork of MySQL, Compatible with many MySQL applications while offering additional features.
7. IBM Db2: Developed by IBM, Often used in large enterprise and mainframe environments.

### Which one should you learn?

**PostgreSQL:** Best overall choice for learning modern database concepts.
**MySQL:** Very common in web development and easy to get started with.
**SQLite:** Great for learning SQL basics and small projects.
**SQL Server:** Valuable if you plan to work in Microsoft-heavy enterprise environments.

### PostgreSQL vs. MySQL

| Feature           | MySQL                                                  | PostgreSQL                                                                          |
| ----------------- | ------------------------------------------------------ | ----------------------------------------------------------------------------------- |
| Ease of use       | Generally simpler to learn and set up                  | More advanced features, slightly steeper learning curve                             |
| Performance       | Often very fast for simple read-heavy web applications | Excellent for complex queries and large datasets                                    |
| SQL Compliance    | Good, but historically less strict                     | Very standards-compliant and feature-rich                                           |
| Advanced Features | Basic JSON support, stored procedures, replication     | Advanced JSON support, window functions, CTEs, custom data types, extensions        |
| Extensibility     | Limited                                                | Highly extensible (custom functions, operators, data types)                         |
| Concurrency       | Good                                                   | Excellent handling of concurrent transactions (MVCC)                                |
| Use Cases         | Websites, blogs, e-commerce, simple applications       | Enterprise applications, analytics, GIS, financial systems, complex data processing |

