# Database Fundamentals — Study Reference

---

## 1. Core Concepts

### Data vs Information vs Database

| Term            | Definition                                                                      |
| --------------- | ------------------------------------------------------------------------------- |
| **Data**        | Raw, unprocessed facts (e.g., `92`, `Jasper`, `2024-01-15`)                     |
| **Information** | Data processed to give meaning (e.g., "Jasper scored 92 on 15 Jan 2024")        |
| **Database**    | Organized collection of related data stored and accessed electronically         |
| **DBMS**        | Software layer that manages creation, querying, and administration of databases |

**Examples of databases:** university student records, e-commerce product catalogs, hospital patient management systems.

---

## 2. Data Abstraction

Hiding internal implementation details while exposing only what users need. There are **3 levels**:

```
┌─────────────────────────────────┐
│      VIEW LEVEL (External)      │  ← What the user sees (e.g., a student portal)
├─────────────────────────────────┤
│     LOGICAL LEVEL (Conceptual)  │  ← What data exists and how it relates
├─────────────────────────────────┤
│    PHYSICAL LEVEL (Internal)    │  ← How data is actually stored on disk
└─────────────────────────────────┘
```

| Level    | Also Known As | Description                                                       |
| -------- | ------------- | ----------------------------------------------------------------- |
| Physical | Internal      | B-trees, heap files, indexes, storage blocks                      |
| Logical  | Conceptual    | Tables, columns, data types, relationships                        |
| View     | External      | Custom views per user/role (e.g., student sees only their grades) |

**Interview Q:** _Why is data abstraction important?_  
It allows schema changes at one level without affecting other levels (called **data independence**). Physical independence = change storage without touching logical schema. Logical independence = change tables without breaking application views.

---

## 3. Relational Model Concepts

| Term            | Definition                             | Example                    |
| --------------- | -------------------------------------- | -------------------------- |
| **Relation**    | A table with rows and columns          | `student` table            |
| **Tuple**       | A single row in a table                | One student's record       |
| **Attribute**   | A column (field) in a table            | `student_name`, `grade`    |
| **Domain**      | Set of allowed values for an attribute | `gender` → `{M, F, Other}` |
| **Degree**      | Number of attributes in a relation     | 5 columns = degree 5       |
| **Cardinality** | Number of tuples in a relation         | 200 rows = cardinality 200 |

---

## 4. Database Languages

```
┌────────────────────────────────────────────┐
│                  SQL                       │
├──────────┬───────────┬──────────┬──────────┤
│   DDL    │    DML    │   DCL    │   TCL    │
│ (Define) │(Manipulate│ (Control)│(Transact)│
└──────────┴───────────┴──────────┴──────────┘
```

---

## 5. DDL — Data Definition Language

Used to **define and modify** the database structure/schema.

| Command    | Purpose                                |
| ---------- | -------------------------------------- |
| `CREATE`   | Create a new table/database/index      |
| `ALTER`    | Modify an existing table               |
| `DROP`     | Delete a table/database permanently    |
| `TRUNCATE` | Remove all rows but keep the structure |
| `RENAME`   | Rename a table or column               |

### CREATE TABLE

```sql
CREATE TABLE student (
    student_id   INT           PRIMARY KEY,
    first_name   VARCHAR(50)   NOT NULL,
    last_name    VARCHAR(50)   NOT NULL,
    email        VARCHAR(100)  UNIQUE,
    dob          DATE,
    gpa          DECIMAL(3, 2),  -- 3 total digits, 2 after decimal (e.g. 3.85)
    enrolled_on  TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);
```

### ALTER TABLE

```sql
-- Add a new column
ALTER TABLE student ADD COLUMN phone VARCHAR(15);

-- Modify a column's data type
ALTER TABLE student MODIFY COLUMN phone VARCHAR(20);

-- Drop a column
ALTER TABLE student DROP COLUMN phone;

-- Add a constraint
ALTER TABLE student ADD CONSTRAINT chk_gpa CHECK (gpa BETWEEN 0.00 AND 4.00);
```

### DROP vs TRUNCATE

```sql
-- TRUNCATE: removes all rows, keeps table structure, resets auto-increment
TRUNCATE TABLE student;

-- DROP: removes the entire table including structure (irreversible!)
DROP TABLE student;

-- Safe drop (won't error if table doesn't exist)
DROP TABLE IF EXISTS student;
```

**Interview Q:** _Difference between DROP, DELETE, and TRUNCATE?_

|                       | DROP | TRUNCATE    | DELETE            |
| --------------------- | ---- | ----------- | ----------------- |
| Removes structure     | yes  | no          | no                |
| Removes data          | yes  | yes         | yes (conditional) |
| WHERE clause          | no   | no          | yes               |
| Rollback possible     | no   | no (mostly) | yes               |
| Resets auto-increment | N/A  | yes         | no                |
| Language category     | DDL  | DDL         | DML               |

---

## 6. SQL Data Types

```sql
-- Numeric
age         INT,
price       DECIMAL(10, 2),   -- 10 digits total, 2 after decimal
rating      FLOAT,

-- String
name        VARCHAR(100),     -- variable length, up to 100 chars
country     CHAR(2),          -- fixed length (e.g., 'NP', 'US')
bio         TEXT,             -- large text

-- Date/Time
created_at  DATE,             -- '2024-01-15'
login_time  TIME,             -- '14:30:00'
updated_at  DATETIME,         -- '2024-01-15 14:30:00'
ts          TIMESTAMP,        -- stored in UTC, auto-converts timezone

-- Boolean
is_active   BOOLEAN,          -- TRUE / FALSE

-- NULL
-- Any column can hold NULL unless constrained with NOT NULL
```

---

## 7. DML — Data Manipulation Language

Used to **read and modify** the actual data in tables.

| Command  | Purpose              |
| -------- | -------------------- |
| `SELECT` | Retrieve data        |
| `INSERT` | Add new rows         |
| `UPDATE` | Modify existing rows |
| `DELETE` | Remove rows          |

### INSERT

```sql
-- Single row
INSERT INTO student (student_id, first_name, last_name, email, gpa)
VALUES (1, 'Jasper', 'Badu', 'jasper@example.com', 3.90);

-- Multiple rows
INSERT INTO student (student_id, first_name, last_name, gpa)
VALUES
    (2, 'Riya',   'Sharma', 3.75),
    (3, 'Bikash', 'Thapa',  3.50),
    (4, 'Anita',  'Rai',    3.85);
```

### SELECT — Basic to Advanced

```sql
-- All columns
SELECT * FROM student;

-- Specific columns
SELECT first_name, last_name, gpa FROM student;

-- With alias
SELECT first_name AS fname, gpa AS score FROM student;

-- With condition
SELECT * FROM student WHERE gpa > 3.50;

-- Multiple conditions
SELECT * FROM student WHERE gpa > 3.50 AND enrolled_on > '2023-01-01';

-- ORDER BY
SELECT * FROM student ORDER BY gpa DESC;

-- LIMIT
SELECT * FROM student ORDER BY gpa DESC LIMIT 5;

-- DISTINCT
SELECT DISTINCT gpa FROM student;

-- Aggregate functions
SELECT COUNT(*), AVG(gpa), MAX(gpa), MIN(gpa) FROM student;

-- GROUP BY + HAVING
SELECT gpa, COUNT(*) AS total
FROM student
GROUP BY gpa
HAVING COUNT(*) > 1;
```

### WHERE Clause Operators

```sql
-- BETWEEN (inclusive)
SELECT * FROM student WHERE gpa BETWEEN 3.00 AND 4.00;

-- IN
SELECT * FROM student WHERE student_id IN (1, 3, 5);

-- LIKE — pattern matching
SELECT * FROM student WHERE first_name LIKE 'J%';       -- starts with J
SELECT * FROM student WHERE email LIKE '%@gmail.com';   -- ends with @gmail.com
SELECT * FROM student WHERE first_name LIKE '_a%';      -- 2nd char is 'a'
SELECT * FROM student WHERE phone LIKE '98______';      -- 98 + exactly 6 chars

-- IS NULL / IS NOT NULL
SELECT * FROM student WHERE email IS NULL;
SELECT * FROM student WHERE email IS NOT NULL;

-- NOT
SELECT * FROM student WHERE gpa NOT BETWEEN 3.00 AND 3.50;
```

**Interview Q:** _Why can't you use `= NULL` in SQL?_  
`NULL` represents unknown/missing data. Comparing `NULL = NULL` evaluates to `UNKNOWN`, not `TRUE`. You must use `IS NULL` or `IS NOT NULL`.

### UPDATE

```sql
-- Update single row
UPDATE student SET gpa = 3.95 WHERE student_id = 1;

-- Update multiple columns
UPDATE student
SET gpa = 3.80, email = 'jasper.new@example.com'
WHERE student_id = 1;

--  Always use WHERE with UPDATE or you'll update every row
```

### DELETE

```sql
-- Delete specific rows
DELETE FROM student WHERE student_id = 4;

-- Delete with condition
DELETE FROM student WHERE gpa < 2.00;

--   DELETE without WHERE removes ALL rows (but unlike TRUNCATE, it's rollbackable)
```

---

## 8. Joins

```sql
-- Setup: two tables
CREATE TABLE department (
    dept_id   INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employee (
    emp_id    INT PRIMARY KEY,
    name      VARCHAR(100),
    dept_id   INT,
    salary    DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);
```

### INNER JOIN — only matching rows

```sql
SELECT e.name, d.dept_name
FROM employee e
INNER JOIN department d ON e.dept_id = d.dept_id;
```

### LEFT JOIN — all left rows + matching right

```sql
-- Returns all employees, even those with no department
SELECT e.name, d.dept_name
FROM employee e
LEFT JOIN department d ON e.dept_id = d.dept_id;
```

### RIGHT JOIN — all right rows + matching left

```sql
SELECT e.name, d.dept_name
FROM employee e
RIGHT JOIN department d ON e.dept_id = d.dept_id;
```

### Self Join — join a table to itself

```sql
-- Find employees and their managers (both in same table)
SELECT e.name AS employee, m.name AS manager
FROM employee e
JOIN employee m ON e.manager_id = m.emp_id;
```

**Interview Q:** _Difference between INNER JOIN and LEFT JOIN?_  
INNER JOIN returns only rows where the join condition matches in **both** tables. LEFT JOIN returns **all** rows from the left table even when there's no match on the right (unmatched right columns are NULL).

---

## 9. Aliases and Ambiguous Attribute Names

When querying multiple tables with same column names, prefix with table name or alias:

```sql
-- Without alias — ambiguous if both tables have 'name' column
SELECT employee.name, department.name
FROM employee, department
WHERE employee.dept_id = department.dept_id;

-- With alias — cleaner
SELECT e.name AS emp_name, d.name AS dept_name
FROM employee AS e
JOIN department AS d ON e.dept_id = d.dept_id;
```

---

## 10. Subqueries / Nested Queries

```sql
-- Scalar subquery: returns single value
SELECT name FROM employee
WHERE salary > (SELECT AVG(salary) FROM employee);

-- IN subquery: returns a list
SELECT name FROM employee
WHERE dept_id IN (SELECT dept_id FROM department WHERE dept_name = 'Engineering');

-- EXISTS subquery: checks for existence
SELECT name FROM employee e
WHERE EXISTS (
    SELECT 1 FROM department d
    WHERE d.dept_id = e.dept_id AND d.dept_name = 'DevOps'
);

-- Correlated subquery: references outer query
SELECT name, salary
FROM employee e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employee e2
    WHERE e1.dept_id = e2.dept_id  -- compares within same department
);
```

---

## 11. DCL — Data Control Language

Used to **grant or revoke** access permissions.

```sql
-- Grant specific privileges
GRANT SELECT, INSERT ON student TO 'john'@'localhost';

-- Grant all privileges
GRANT ALL PRIVILEGES ON university_db.* TO 'admin'@'%';

-- Revoke specific privileges
REVOKE INSERT ON student FROM 'john'@'localhost';

-- Revoke all privileges
REVOKE ALL PRIVILEGES ON student FROM 'john'@'localhost';

-- Show grants for a user
SHOW GRANTS FOR 'john'@'localhost';
```

**Object-level privileges** (controlled by DCL, executed via DML):  
`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `EXECUTE`, `REFERENCES`

**Interview Q:** _Difference between GRANT and REVOKE?_  
`GRANT` gives a user permission to perform actions. `REVOKE` removes previously granted permissions. Both are DCL commands and take effect immediately.

---

## 12. TCL — Transaction Control Language

A **transaction** is a logical unit of work — all operations must succeed together or none at all.

### ACID Properties

| Property        | Meaning                                 | Example                                                       |
| --------------- | --------------------------------------- | ------------------------------------------------------------- |
| **Atomicity**   | All or nothing                          | Transfer ₹1000: debit AND credit both happen, or neither does |
| **Consistency** | DB stays in valid state                 | Total money before = total money after transfer               |
| **Isolation**   | Concurrent transactions don't interfere | Two users booking the same seat — only one succeeds           |
| **Durability**  | Committed changes survive crashes       | After COMMIT, power failure won't lose the data               |

### TCL Commands

```sql
-- COMMIT: permanently save all changes in current transaction
BEGIN;
    UPDATE accounts SET balance = balance - 1000 WHERE acc_id = 1;
    UPDATE accounts SET balance = balance + 1000 WHERE acc_id = 2;
COMMIT;  -- both updates are now permanent

-- ROLLBACK: undo all changes since last COMMIT
BEGIN;
    DELETE FROM student WHERE gpa < 2.0;
ROLLBACK;  -- mistake! all deleted rows are restored

-- SAVEPOINT: create a named checkpoint within a transaction
BEGIN;
    INSERT INTO orders VALUES (101, 'Laptop', 80000);
    SAVEPOINT after_insert;

    UPDATE inventory SET stock = stock - 1 WHERE item = 'Laptop';
    -- something went wrong with update...
    ROLLBACK TO after_insert;  -- rolls back only the UPDATE, keeps the INSERT

COMMIT;
```

**Interview Q:** _What happens if a COMMIT is not issued?_  
Changes remain in a pending/uncommitted state. Other transactions may not see those changes (depending on isolation level), and they'll be lost if the session terminates or crashes.

---

## 13. Views

A **view** is a virtual table derived from a SELECT query. The underlying data isn't duplicated.

```sql
-- Create a view
CREATE VIEW high_gpa_students AS
SELECT student_id, first_name, last_name, gpa
FROM student
WHERE gpa >= 3.75;

-- Query a view just like a table
SELECT * FROM high_gpa_students;

-- Update a view definition
CREATE OR REPLACE VIEW high_gpa_students AS
SELECT student_id, first_name, last_name, gpa, email
FROM student
WHERE gpa >= 3.75;

-- Drop a view
DROP VIEW high_gpa_students;
```

**Use cases for views:**

- Security: expose only certain columns to certain users
- Simplify complex joins into a reusable query
- Backward compatibility when table schema changes

**Interview Q:** _Can you UPDATE data through a view?_  
Yes, but only if the view maps directly to a single base table without aggregations, DISTINCT, GROUP BY, HAVING, or subqueries. Complex views are generally read-only.

---

## 14. Normalization

Process of organizing tables to **reduce redundancy** and improve data integrity.

| Normal Form | Rule                                                                              |
| ----------- | --------------------------------------------------------------------------------- |
| **1NF**     | Each column has atomic values; no repeating groups                                |
| **2NF**     | 1NF + no partial dependency (non-key column depends on entire PK)                 |
| **3NF**     | 2NF + no transitive dependency (non-key column depends on another non-key column) |
| **BCNF**    | Stricter 3NF — every determinant must be a candidate key                          |

**Interview Q:** _What is a transitive dependency?_  
When column C depends on column B, and column B depends on the primary key A. So A → B → C. In 3NF you remove this by splitting the table so B → C lives in its own table.

---

## 15. Indexes

Used to speed up read queries at the cost of slower writes and extra storage.

```sql
-- Create an index
CREATE INDEX idx_student_email ON student(email);

-- Create a unique index
CREATE UNIQUE INDEX idx_student_email_unique ON student(email);

-- Composite index (useful when filtering on multiple columns together)
CREATE INDEX idx_name_gpa ON student(last_name, gpa);

-- Drop an index
DROP INDEX idx_student_email ON student;

-- Check if a query uses an index
EXPLAIN SELECT * FROM student WHERE email = 'jasper@example.com';
```

**Interview Q:** _When should you NOT create an index?_  
On columns with low cardinality (e.g., boolean, gender), on small tables where a full scan is faster, or on columns that are frequently updated — every write must also update the index.

---

## 16. Running MySQL with Docker

```bash
# Start MySQL 8.4 container with persistent volume
docker run -d \
  --name mysql-container \
  -e MYSQL_ROOT_PASSWORD=root \
  -p 3306:3306 \
  -v mysql-data:/var/lib/mysql \
  mysql:8.4

# Enter the container shell
docker exec -it mysql-container /bin/bash

# Connect to MySQL CLI inside container
mysql -u root -p

# Or connect directly from host (if mysql-client is installed)
mysql -h 127.0.0.1 -P 3306 -u root -p
```

```sql
-- Basic MySQL admin commands
SHOW DATABASES;
CREATE DATABASE university_db;
USE university_db;
SHOW TABLES;
DESCRIBE student;
```

---

## 17. Common Database Port Numbers

| Database   | Default Port |
| ---------- | ------------ |
| MySQL      | 3306         |
| PostgreSQL | 5432         |
| MongoDB    | 27017        |
| Redis      | 6379         |
| MSSQL      | 1433         |
| Oracle     | 1521         |

---

## 18. Relational vs Non-Relational Databases

|                  | Relational (SQL)                        | Non-Relational (NoSQL)                    |
| ---------------- | --------------------------------------- | ----------------------------------------- |
| **Structure**    | Tables with fixed schema                | Documents, key-value, graphs, columns     |
| **Schema**       | Rigid, defined upfront                  | Flexible, dynamic                         |
| **Scaling**      | Vertical (scale up)                     | Horizontal (scale out)                    |
| **Transactions** | ACID by default                         | Eventual consistency (usually)            |
| **Examples**     | MySQL, PostgreSQL, MSSQL                | MongoDB, Redis, Cassandra, DynamoDB       |
| **Best for**     | Financial systems, ERP, structured data | Caching, catalogs, IoT, unstructured data |

**Interview Q:** _Why would you choose PostgreSQL over MongoDB for a banking application?_  
Banking requires strict ACID compliance, complex joins across normalized tables, and consistent schemas. PostgreSQL guarantees transactional integrity natively. MongoDB's flexible schema and eventual consistency model are a poor fit where every debit/credit must be atomic and auditable.

---

## 19. How MySQL Stores Data

- Data is stored in **tablespace files** (`.ibd` files per table with InnoDB engine)
- InnoDB uses a **clustered index** — the primary key IS the physical storage order (B+ tree)
- Row data, indexes, undo logs, and redo logs are all separate structures
- Default storage engine: **InnoDB** (supports ACID, foreign keys, row-level locking)
- Alternative: **MyISAM** (faster reads, no transactions, table-level locking)

---

## 20. Questions

### Conceptual

1. What is the difference between a primary key and a unique key?
2. What is a foreign key? What happens on DELETE of a referenced row?
3. Explain ACID properties with a real-world example.
4. What is the difference between clustered and non-clustered indexes?
5. What are the different types of JOINs? When would you use each?
6. What is normalization? Why is it important? What are its trade-offs?
7. What is a deadlock in a database? How do you prevent it?
8. What is the difference between optimistic and pessimistic locking?

### Query Writing (expect live coding)

1. Find the second highest salary from an `employee` table.

```sql
SELECT MAX(salary) FROM employee WHERE salary < (SELECT MAX(salary) FROM employee);
-- or
SELECT salary FROM employee ORDER BY salary DESC LIMIT 1 OFFSET 1;
```

2. Find employees who earn more than their department average.

```sql
SELECT e.name, e.salary, e.dept_id
FROM employee e
WHERE e.salary > (SELECT AVG(salary) FROM employee WHERE dept_id = e.dept_id);
```

3. Find duplicate emails in a `users` table.

```sql
SELECT email, COUNT(*) AS cnt
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

4. Delete duplicate rows keeping only the one with the lowest `id`.

```sql
DELETE FROM users
WHERE id NOT IN (
    SELECT MIN(id) FROM users GROUP BY email
);
```

---

# REFERENCES

1. https://dev.to/gbengelebs/unboxing-a-database-how-databases-work-internally-155h
2. https://stackoverflow.com/questions/10378693/how-does-mysql-store-data
3. https://vijayasimhabr.medium.com/running-mysql-database-server-with-docker-ad10533473c7
4. https://www.geeksforgeeks.org/dbms/database-languages-in-dbms/
