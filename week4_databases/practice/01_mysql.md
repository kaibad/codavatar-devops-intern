# MySQL Practice Questions

---

## Setup
1. Pull and run MySQL 8.4 using Docker with a named volume and root password, exposed on port 3306.

```bash
docker run -itd --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -v mysql-data:/var/lib/mysql mysql:8.4
```

2. Shell into the running container and connect to MySQL as root.

```bash
docker exec -it mysql /bin/bash

mysql -u root -p # login to mysql shell without the trace of passowrd in the history

```
3. Create a database called `company_db` and switch to it.

```bash
mysql> CREATE DATABASE company_db;
Query OK, 1 row affected (0.04 sec)

mysql> show dbs
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'dbs' at line 1
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| company_db         |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.03 sec)

mysql> use company_db;
Database changed
mysql> SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| company_db |
+------------+
1 row in set (0.01 sec)

mysql> 

```
**NOte:** use ctrl + l to clear the mysql shell
---

## DDL
4. Create a `department` table with columns: `dept_id` (PK, auto increment), `dept_name` (unique, not null), `location`, `budget` (decimal, default 0).

**syntax**
```bash
CREATE TABLE table_name (
    column1 datatype constraint,
    column2 datatype constraint,
    column3 datatype constraint,
   ....
);

```

```bash
mysql> CREATE TABLE department ()
    -> ^C
mysql> CREATE TABLE department (dept_id INT NOT NULL AUTO_INCREMENT , dept_name VARCHAR(50) NOT NULL UNIQUE, location VARCHAR(50), budget DECIMAL(15,2) DEFAULT 0, PRIMARY KEY(dept_id))
    -> ;
Query OK, 0 rows affected (0.03 sec)

mysql> SHOW TABLESL
    -> ^C
mysql> SHOW TABLES;
+----------------------+
| Tables_in_company_db |
+----------------------+
| department           |
+----------------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM department;
Empty set (0.02 sec)

mysql> DESCRIBE department;
+-----------+---------------+------+-----+---------+----------------+
| Field     | Type          | Null | Key | Default | Extra          |
+-----------+---------------+------+-----+---------+----------------+
| dept_id   | int           | NO   | PRI | NULL    | auto_increment |
| dept_name | varchar(50)   | NO   | UNI | NULL    |                |
| location  | varchar(50)   | YES  |     | NULL    |                |
| budget    | decimal(15,2) | YES  |     | 0.00    |                |
+-----------+---------------+------+-----+---------+----------------+
4 rows in set (0.01 sec)

mysql> 

```

5. Create an `employee` table with: `emp_id` (PK), `first_name`, `last_name`, `email` (unique), `salary`, `dept_id` (FK to department), `manager_id` (self-referencing FK), `hire_date`, `is_active` (boolean, default true).

```bash
mysql> show tables;
+----------------------+
| Tables_in_company_db |
+----------------------+
| department           |
+----------------------+
1 row in set (0.01 sec)

mysql> CREATE TABLE employee (emp_id INT NOT NULL AUTO_INCREMENT PRIMARY_KEY,first_name VARCHAR(100), last_name VARCHAR(100), email VARCHAR(100) NOT NULL UNIQUE, salary DECIMAL(8,2), dept_id INT, manager_id INT,hire_date DATE,is_active BOOLEAN DEFAULT TRUE, CONSTRAINT fk_employee_department FOREIGN KEY (dept_id) REFERENCES department(dept_id),
CONSTRAINT fk_employee_manager FOREIGN KEY (emp_id) REFERENCES employee(emp_id));
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'PRIMARY_KEY,first_name VARCHAR(100), last_name VARCHAR(100), email VARCHAR(100) ' at line 1
mysql> CREATE TABLE employee (emp_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,first_name VARCHAR(100), last_name VARCHAR(100), email VARCHAR(100) NOT NULL UNIQUE, salary DECIMAL(8,2), dept_id INT, manager_id INT,hire_date DATE,is_active BOOLEAN DEFAULT TRUE, CONSTRAINT fk_employee_department FOREIGN KEY (dept_id) REFERENCES department(dept_id),
CONSTRAINT fk_employee_manager FOREIGN KEY (emp_id) REFERENCES employee(emp_id));
ERROR 6125 (HY000): Failed to add the foreign key constraint. Missing unique key for constraint 'fk_employee_manager' in the referenced table 'employee'
mysql> CREATE TABLE employee (emp_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,first_name VARCHAR(100), last_name VARCHAR(100), email VARCHAR(100) NOT NULL UNIQUE, salary DECIMAL(8,2), dept_id INT, manager_id INT,hire_date DATE,is_active BOOLEAN DEFAULT TRUE, CONSTRAINT fk_employee_department FOREIGN KEY (dept_id) REFERENCES department(dept_id),
CONSTRAINT fk_employee_manager FOREIGN KEY (emp_id) REFERENCES employee(manager_id));
ERROR 6125 (HY000): Failed to add the foreign key constraint. Missing unique key for constraint 'fk_employee_manager' in the referenced table 'employee'
mysql> CREATE TABLE employee (emp_id INT NOT NULL AUTO_INCREMENT PRIMARY_KEY,first_name VARCHAR(100), last_name VARCHAR(100), email VARCHAR(100) NOT NULL UNIQUE, salary DECIMAL(8,2), dept_id INT, manager_id INT,hire_date DATE,is_active BOOLEAN DEFAULT TRUE, CONSTRAINT fk_employee_department FOREIGN KEY (dept_id) REFERENCES department(dept_id),
CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id) REFERENCES employee(emp_id));
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'PRIMARY_KEY,first_name VARCHAR(100), last_name VARCHAR(100), email VARCHAR(100) ' at line 1
mysql> CREATE TABLE employee (emp_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,first_name VARCHAR(100), last_name VARCHAR(100), email VARCHAR(100) NOT NULL UNIQUE, salary DECIMAL(8,2), dept_id INT, manager_id INT,hire_date DATE,is_active BOOLEAN DEFAULT TRUE, CONSTRAINT fk_employee_department FOREIGN KEY (dept_id) REFERENCES department(dept_id),
CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id) REFERENCES employee(emp_id));
Query OK, 0 rows affected (0.03 sec)

mysql> DESCRIBE employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
+------------+--------------+------+-----+---------+----------------+
9 rows in set (0.00 sec)

mysql> 



```
6. Create a `project` table linked to department via FK.

```bash
mysql> 
mysql> CREATE TABLE project (project_id INT AUTO_INCREMENT PRIMARY KEY,project_name VARCHAR(100) NOT NULL , start_date DATE, end_date DATE, budget DECIMAL(10,2) DEFAULT 0, dept_id INT CONSTRAINT fk_project_department FOREIGN KEY (dept_id) REFERENCES department(dept_id));
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'FOREIGN KEY (dept_id) REFERENCES department(dept_id))' at line 1
mysql> CREATE TABLE project (project_id INT AUTO_INCREMENT PRIMARY KEY,project_name VARCHAR(100) NOT NULL , start_date DATE, end_date DATE, budget DECIMAL(10,2) DEFAULT 0, dept_id INT, CONSTRAINT fk_project_department FOREIGN KEY (dept_id) REFERENCES department(dept_id));
Query OK, 0 rows affected (0.02 sec)

mysql> DESCRIBE project;
+--------------+---------------+------+-----+---------+----------------+
| Field        | Type          | Null | Key | Default | Extra          |
+--------------+---------------+------+-----+---------+----------------+
| project_id   | int           | NO   | PRI | NULL    | auto_increment |
| project_name | varchar(100)  | NO   |     | NULL    |                |
| start_date   | date          | YES  |     | NULL    |                |
| end_date     | date          | YES  |     | NULL    |                |
| budget       | decimal(10,2) | YES  |     | 0.00    |                |
| dept_id      | int           | YES  | MUL | NULL    |                |
+--------------+---------------+------+-----+---------+----------------+
6 rows in set (0.01 sec)

```

7. Create a `works_on` junction table with composite PK (`emp_id`, `proj_id`) and an `hours` column.

```bash
mysql> CREATE table works_on (emp_id INT,project_id int, hours DECIMAL(5,2), PRIMARY KEY(emp_id,project_id). CONSTRAINT fk_workson_employee FOREIGN KEY (emp_id) REFERENCES employee(emp_id), CONSTRAINT fk_workson_project FOREIGN KEY(project_id) REFERENCES project(project_id) )
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '. CONSTRAINT fk_workson_employee FOREIGN KEY (emp_id) REFERENCES employee(emp_id' at line 1
mysql> CREATE table works_on (emp_id INT,project_id int, hours DECIMAL(5,2), PRIMARY KEY(emp_id,project_id), CONSTRAINT fk_workson_employee FOREIGN KEY (emp_id) REFERENCES employee(emp_id), CONSTRAINT fk_workson_project FOREIGN KEY(project_id) REFERENCES project(project_id) );
Query OK, 0 rows affected (0.03 sec)

mysql> DESCRIBE works_on;
+------------+--------------+------+-----+---------+-------+
| Field      | Type         | Null | Key | Default | Extra |
+------------+--------------+------+-----+---------+-------+
| emp_id     | int          | NO   | PRI | NULL    |       |
| project_id | int          | NO   | PRI | NULL    |       |
| hours      | decimal(5,2) | YES  |     | NULL    |       |
+------------+--------------+------+-----+---------+-------+
3 rows in set (0.00 sec)

mysql> 

```

8. Add a `phone` column to `employee` using ALTER.

**synact**

```bash
ALTER TABLE table_name
ADD COLUMN column1 datatype,
ADD COLUMN column2 datatype,
ADD COLUMN column3 datatype;
```


``bash
mysql> DESC employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
+------------+--------------+------+-----+---------+----------------+
9 rows in set (0.00 sec)

mysql> ALTER TABLE employee ADD COLUMNE phone VARCHAR(20);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'phone VARCHAR(20)' at line 1
mysql> ALTER TABLE employee ADD COLUMN phone VARCHAR(20);
Query OK, 0 rows affected (0.06 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> DESC employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
| phone      | varchar(20)  | YES  |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
10 rows in set (0.01 sec)

mysql> 

```

9. Drop the `phone` column.

```bash
mysql> DESC employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
| phone      | varchar(20)  | YES  |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
10 rows in set (0.01 sec)

mysql> clear
mysql> 
mysql> desc works
    -> ^C
mysql> desc works_on;
+------------+--------------+------+-----+---------+-------+
| Field      | Type         | Null | Key | Default | Extra |
+------------+--------------+------+-----+---------+-------+
| emp_id     | int          | NO   | PRI | NULL    |       |
| project_id | int          | NO   | PRI | NULL    |       |
| hours      | decimal(5,2) | YES  |     | NULL    |       |
+------------+--------------+------+-----+---------+-------+
3 rows in set (0.00 sec)

mysql> ALTER TABLE employee DROP COLUMN phone;
Query OK, 0 rows affected (0.05 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> DESC employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
+------------+--------------+------+-----+---------+----------------+
9 rows in set (0.00 sec)

mysql> 
```

10. What is the difference between `DROP TABLE`, `TRUNCATE`, and `DELETE`?

DELETE is a DML command that removes specific rows based on a WHERE condition, retains the table structure, supports rollback, fires triggers, and is the slowest due to row-by-row processing.  TRUNCATE is a DDL command that removes all rows instantly by deallocating data pages, retains the table structure and constraints, resets identity values, does not fire triggers, and is faster than DELETE.  DROP is a DDL command that permanently removes the entire table object, including its structure, data, indexes, and constraints, which cannot be rolled back. 

---

## DML — INSERT
11. Insert 5 departments with different locations and budgets.
```SQL

mysql> DESC department;
+-----------+---------------+------+-----+---------+----------------+
| Field     | Type          | Null | Key | Default | Extra          |
+-----------+---------------+------+-----+---------+----------------+
| dept_id   | int           | NO   | PRI | NULL    | auto_increment |
| dept_name | varchar(50)   | NO   | UNI | NULL    |                |
| location  | varchar(50)   | YES  |     | NULL    |                |
| budget    | decimal(15,2) | YES  |     | 0.00    |                |
+-----------+---------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

mysql> Insert 5 departments with different locations and budgets^C
mysql> INSERT INTO department (dept_name,location,budget)
    -> VALUES
    -> ("krispcall","Kalopul",10000.004)
    -> ("Tivazo","baneswor",12221.232)
    -> ("Dialaxy","Chabahill",1212121.1212)
    -> ("Lumbinni medical College","lumbini",1752615.71267)
    -> ("Entegra","Bagbazaar",122233.98);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '("Tivazo","baneswor",12221.232)
("Dialaxy","Chabahill",1212121.1212)
("Lumbinni ' at line 4
mysql> INSERT INTO department (dept_name,location,budget) VALUES ("krispcall","Kalopul",10000.004), ("Tivazo","baneswor",12221.232), (DDD"Dialaxy","Chabahill",1212121.1212)
,("Lumbinni medical College","lumbini",1752615.71267), ("Entegra","Bagbazaar",122233.98);
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '"Dialaxy","Chabahill",1212121.1212) ,("Lumbinni medical College","lumbini",17526' at line 1
mysql> INSERT INTO department (dept_name,location,budget) VALUES ("krispcall","Kalopul",10000.004), ("Tivazo","baneswor",12221.232), ("Dialaxy","Chabahill",1212121.1212) ,("Lumbinni medical College","lumbini",1752615.71267), ("Entegra","Bagbazaar",122233.98);
Query OK, 5 rows affected, 4 warnings (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 4

mysql> SELECT * FROM department;
+---------+--------------------------+-----------+------------+
| dept_id | dept_name                | location  | budget     |
+---------+--------------------------+-----------+------------+
|       1 | krispcall                | Kalopul   |   10000.00 |
|       2 | Tivazo                   | baneswor  |   12221.23 |
|       3 | Dialaxy                  | Chabahill | 1212121.12 |
|       4 | Lumbinni medical College | lumbini   | 1752615.71 |
|       5 | Entegra                  | Bagbazaar |  122233.98 |
+---------+--------------------------+-----------+------------+
5 rows in set (0.00 sec)

mysql> 

```
12. Insert 10 employees — make sure some have `manager_id` pointing to existing employees.

```sql
mysql> DESC employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
+------------+--------------+------+-----+---------+----------------+
9 rows in set (0.00 sec)

mysql> Insert 10 employees  make sure some have `manager_id` pointing to existing employees.^C
mysql> INSERT INTO employee (first_name,last_name,email,salary,dept_id,manager_id,hire_date,is_active)
    -> VALUES
    -> ('John',"Smith","john.smith@codavatar.tech","90000",1,NULL,'2020-01-15',TRUE),
    -> ('Sarah',   'Johnson',  'sarah.johnson@company.com', 85000.00, 2, NULL, '2020-03-20', 1),
    -> ('Michael', 'Brown',    'michael.brown@company.com', 80000.00, 3, NULL, '2021-02-10', 1),
    -> ('Emily',   'Davis',    'emily.davis@company.com',   65000.00, 1, 1,    '2021-06-01', 1),
    -> ('David',   'Wilson',   'david.wilson@company.com',  62000.00, 1, 1,    '2021-08-15', 1),
    -> ('Jessica', 'Miller',   'jessica.miller@company.com',60000.00, 2, 2,    '2022-01-12', 1),
    -> ('Daniel',  'Moore',    'daniel.moore@company.com',  58000.00, 2, 2,    '2022-04-18', 1),
    -> ('Ashley',  'Taylor',   'ashley.taylor@company.com', 61000.00, 3, 3,    '2022-07-22', 1),
    -> ('Matthew', 'Anderson', 'matthew.anderson@company.com',59000.00,3,3,    '2023-01-09', 1),
    -> ('Olivia',  'Thomas',   'olivia.thomas@company.com', 55000.00, 1, 1,    '2023-05-11', 1);
Query OK, 10 rows affected (0.01 sec)
Records: 10  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM employee;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql>

```

13. Insert 5 projects and assign employees to projects via `works_on`.
```sql
mysql> DESC works_on;
+------------+--------------+------+-----+---------+-------+
| Field      | Type         | Null | Key | Default | Extra |
+------------+--------------+------+-----+---------+-------+
| emp_id     | int          | NO   | PRI | NULL    |       |
| project_id | int          | NO   | PRI | NULL    |       |
| hours      | decimal(5,2) | YES  |     | NULL    |       |
+------------+--------------+------+-----+---------+-------+
3 rows in set (0.00 sec)

mysql> Insert 5 projects and assign employees to projects via `works_on
    `> ^C
mysql> DESC project;
+--------------+---------------+------+-----+---------+----------------+
| Field        | Type          | Null | Key | Default | Extra          |
+--------------+---------------+------+-----+---------+----------------+
| project_id   | int           | NO   | PRI | NULL    | auto_increment |
| project_name | varchar(100)  | NO   |     | NULL    |                |
| start_date   | date          | YES  |     | NULL    |                |
| end_date     | date          | YES  |     | NULL    |                |
| budget       | decimal(10,2) | YES  |     | 0.00    |                |
| dept_id      | int           | YES  | MUL | NULL    |                |
+--------------+---------------+------+-----+---------+----------------+
6 rows in set (0.00 sec)

mysql> INSERT INTO project
    -> VALUES
    -> ('ERP Upgrade',      '2025-01-01', '2025-12-31', 500000.00, 1),
    -> ('Mobile App',       '2025-02-15', '2025-10-30', 250000.00, 2),
    -> ('Data Warehouse',   '2025-03-01', '2025-11-30', 400000.00, 3),
    -> ('Website Redesign', '2025-04-01', '2025-08-31', 120000.00, 1),
    -> ('Cloud Migration',  '2025-05-01', '2026-01-31', 600000.00, 3);
ERROR 1136 (21S01): Column count doesn't match value count at row 1
mysql> INSERT INTO project (project_name,start_date,end_date,budget,dept_id) VALUES ('ERP Upgrade',      '2025-01-01', '2025-12-31', 500000.00, 1), ('Mobile App',       '202
5-02-15', '2025-10-30', 250000
d Migration',  '2025-05-01', '2026-01-31', 600000.
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM project;
+------------+------------------+------------+------------+-----------+---------+
| project_id | project_name     | start_date | end_date   | budget    | dept_id |
+------------+------------------+------------+------------+-----------+---------+
|          1 | ERP Upgrade      | 2025-01-01 | 2025-12-31 | 500000.00 |       1 |
|          2 | Mobile App       | 2025-02-15 | 2025-10-30 | 250000.00 |       2 |
|          3 | Data Warehouse   | 2025-03-01 | 2025-11-30 | 400000.00 |       3 |
|          4 | Website Redesign | 2025-04-01 | 2025-08-31 | 120000.00 |       1 |
|          5 | Cloud Migration  | 2025-05-01 | 2026-01-31 | 600000.00 |       3 |
+------------+------------------+------------+------------+-----------+---------+
5 rows in set (0.01 sec)

mysql> INSERT INTO works_on (emp_id,project_id,hours)
    -> VALUES
    -> (1,140.00),
    -> (1, 5, 25.00),
    -> 
    -> (2, 2, 35.00),
    -> (2, 3, 20.00),
    -> 
    -> (3, 3, 45.00),
    -> (3, 5, 30.00),
    -> 
    -> (4, 1, 30.00),
    -> (4, 4, 15.00),
    -> 
    -> (5, 1, 25.00),
    -> 
    -> (6, 2, 40.00),
    -> (6, 4, 10.00),
    -> 
    -> (7, 2, 20.00),
    -> 
    -> (8, 3, 35.00),
    -> 
    -> (9, 5, 40.00),
    -> 
    -> (10, 4, 25.00),
    -> (10, 5, 15.00);
ERROR 1136 (21S01): Column count doesn't match value count at row 1
mysql> INSERT INTO works_on (emp_id,project_id,hours) VALUES (1,1,40.00), (1, 5, 25.00),  (2, 2, 35.00), (2, 3, 20.00),  (3, 3, 45.00), (3, 5, 30.00),  (4, 1, 30.00), (4, 4,
 15.00),  (5, 1, 25.00),  (6, 2, 40.00), (6, 4, 10.00),  (7, 2, 20.00),  (8, 3, 35.00),  (9, 5, 40.00),  (10, 4, 25.00), (10, 5, 15.00);
Query OK, 16 rows affected (0.00 sec)
Records: 16  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM works_on;
+--------+------------+-------+
| emp_id | project_id | hours |
+--------+------------+-------+
|      1 |          1 | 40.00 |
|      1 |          5 | 25.00 |
|      2 |          2 | 35.00 |
|      2 |          3 | 20.00 |
|      3 |          3 | 45.00 |
|      3 |          5 | 30.00 |
|      4 |          1 | 30.00 |
|      4 |          4 | 15.00 |
|      5 |          1 | 25.00 |
|      6 |          2 | 40.00 |
|      6 |          4 | 10.00 |
|      7 |          2 | 20.00 |
|      8 |          3 | 35.00 |
|      9 |          5 | 40.00 |
|     10 |          4 | 25.00 |
|     10 |          5 | 15.00 |
+--------+------------+-------+
16 rows in set (0.00 sec)

mysql> 


```

---

## SELECT — Basic
14. Select all columns from `employee`.

```sql

mysql> SHOW TABLES;
+----------------------+
| Tables_in_company_db |
+----------------------+
| department           |
| employee             |
| project              |
| works_on             |
+----------------------+
4 rows in set (0.00 sec)

mysql> SELECT * FROM employee;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql>

```
15. Select only `first_name`, `last_name`, and `salary` with column aliases.

```sql

mysql> show tables;
+----------------------+
| Tables_in_company_db |
+----------------------+
| department           |
| employee             |
| project              |
| works_on             |
+----------------------+
4 rows in set (0.01 sec)

mysql> DESC employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
+------------+--------------+------+-----+---------+----------------+
9 rows in set (0.00 sec)

mysql> SELECT first_name AS fname, last_name AS lname, salary AS sal FROM employee;
+---------+----------+----------+
| fname   | lname    | sal      |
+---------+----------+----------+
| John    | Smith    | 90000.00 |
| Sarah   | Johnson  | 85000.00 |
| Michael | Brown    | 80000.00 |
| Emily   | Davis    | 65000.00 |
| David   | Wilson   | 62000.00 |
| Jessica | Miller   | 60000.00 |
| Daniel  | Moore    | 58000.00 |
| Ashley  | Taylor   | 61000.00 |
| Matthew | Anderson | 59000.00 |
| Olivia  | Thomas   | 55000.00 |
+---------+----------+----------+
10 rows in set (0.00 sec)

mysql> 

```

16. Select all employees sorted by salary descending.

The ORDER BY keyword is used to sort the result set in ascending or descending order,

The ORDER BY keyword sorts the result set in ascending order (ASC) by default

***example*** SELECT * FROM products ORDER BY prices;

For string values, the ORDER BY  keyword will sort the values in the column alphabetically.

***syntax***

```sql
SELECT col1,col2,....
FROM table_name
ORDER BY col1,col2,... ASC|DESC;
```

```sql

mysql> SELECT * FROM employee ORDERBY salary DESC;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'salary DESC' at line 1
mysql> SELECT * FROM employee ORDER BY salary DESC;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql> SELECT * FROM employee ORDER BY salary;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql> 

```

17. Select the top 3 highest paid employees.

in this we first do the ordering and limit  3.

```sql
mysql> 
mysql> SELECT * FROM employee ORDER BY salary DESC LIMIT 3;
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                     | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
3 rows in set (0.00 sec)

mysql>

```




18. Select all distinct salary values.

```sql
mysql> select * from employee;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql> Select all distinct salary values.^C
mysql> SELECT DISTINCT salary FROM employee;
+----------+
| salary   |
+----------+
| 90000.00 |
| 85000.00 |
| 80000.00 |
| 65000.00 |
| 62000.00 |
| 60000.00 |
| 58000.00 |
| 61000.00 |
| 59000.00 |
| 55000.00 |
+----------+
10 rows in set (0.01 sec)


```
---

## WHERE & Operators
19. Find employees with salary greater than 90000.

```mysql
mysql> 
mysql> SELECT * FROM employee WHERE salary > 90000;
Empty set (0.01 sec)

mysql> SELECT * FROM employee WHERE salary > 80000;
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                     | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
2 rows in set (0.00 sec)

mysql> 

```

20. Find employees with salary between 70000 and 95000.

```SQL
mysql> SELECT * FROM employee WHERE salary BETWEEN 70000 AND 95000;
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                     | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
3 rows in set (0.01 sec)

mysql> 


```

21. Find employees in `dept_id` 1 or 2 using `IN`.

```SQL
mysql> Find employees in `dept_id` 1 or 2 using `IN`^C
mysql> SELECT * FROM employee IN dept_id 1 or 2;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'IN dept_id 1 or 2' at line 1
mysql> SELECT * FROM employee WHERE dept_id IN 1 or 2;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '1 or 2' at line 1
mysql> SELECT * FROM employee WHERE dept_id IN (1 or 2);
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                     | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com   | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com  | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
4 rows in set (0.01 sec)

mysql> SELECT * FROM employee WHERE dept_id IN (1 and 2);
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                     | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com   | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com  | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
4 rows in set (0.00 sec)

mysql> SELECT * FROM employee WHERE dept_id IN (1 , 2);
+--------+------------+-----------+----------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                      | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+----------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech  | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com    | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com   | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com  | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com  | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com   | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
+--------+------------+-----------+----------------------------+----------+---------+------------+------------+-----------+
7 rows in set (0.00 sec)

mysql> 

```

22. Find employees whose `first_name` starts with 'A'.

```SQL
mysql> SELECT * FROM employee WHERE first_name =A%
    -> ;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' at line 1
mysql> SELECT * FROM employee WHERE first_name A%;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'A%' at line 1
mysql> SELECT * FROM employee WHERE first_name LIKE A%;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '%' at line 1
mysql> SELECT * FROM employee WHERE first_name LIKE 'A%';
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                     | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
|      8 | Ashley     | Taylor    | ashley.taylor@company.com | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
1 row in set (0.01 sec)

mysql>
```
23. Find employees whose email ends with `@codavatar.tech`.

```SQL
mysql> SELECT * FROM employee WHERE email LIKE '%codavatar.tech';
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                     | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
1 row in set (0.00 sec)

mysql> 

```

24. Find all top-level managers (no manager assigned).

```sql

mysql> SELECT * FROM employee WHERE emp_id IS NULL;
Empty set (0.01 sec)

mysql> SELECT * FROM employee;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql> SELECT * FROM employee WHERE manager_id IS NULL;
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                     | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
+--------+------------+-----------+---------------------------+----------+---------+------------+------------+-----------+
3 rows in set (0.01 sec)

```

25. Find all employees who have a manager assigned.

```SQL

mysql> SELECT * FROM employee WHERE manager_id IS NOT NULL ORDER BY first_name;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
7 rows in set (0.00 sec)

mysql> 

```

---

## Aggregates & GROUP BY
**ref:** https://learnsql.com/blog/sql-group-by-aggregate-functions-overview/

26. Count total number of employees.

```sql
mysql> DESC employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
+------------+--------------+------+-----+---------+----------------+
9 rows in set (0.00 sec)

mysql> SELECT COUNT (*) AS no_of_employee FROM employee GROUP BY emp_id;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '*) AS no_of_employee FROM employee GROUP BY emp_id' at line 1
mysql> Count total number of employees.^C
mysql> SELECT COUNT(*) AS no_of_employee FROM employee;
+----------------+
| no_of_employee |
+----------------+
|             10 |
+----------------+
1 row in set (0.00 sec)

mysql> 

```
27. Find the average, min, and max salary across all employees.

```sql
mysql> DESC employee;
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| emp_id     | int          | NO   | PRI | NULL    | auto_increment |
| first_name | varchar(100) | YES  |     | NULL    |                |
| last_name  | varchar(100) | YES  |     | NULL    |                |
| email      | varchar(100) | NO   | UNI | NULL    |                |
| salary     | decimal(8,2) | YES  |     | NULL    |                |
| dept_id    | int          | YES  | MUL | NULL    |                |
| manager_id | int          | YES  | MUL | NULL    |                |
| hire_date  | date         | YES  |     | NULL    |                |
| is_active  | tinyint(1)   | YES  |     | 1       |                |
+------------+--------------+------+-----+---------+----------------+
9 rows in set (0.00 sec)

mysql> Find the average, min, and max salary across all employees.^C
mysql> SELECT AVG(salary) AS average_salary_of_employee, MIN(salary) AS min_sal_of_employee, MAX(salary) AS max_sal_od_employee FROM employee;
+----------------------------+---------------------+---------------------+
| average_salary_of_employee | min_sal_of_employee | max_sal_od_employee |
+----------------------------+---------------------+---------------------+
|               67500.000000 |            55000.00 |            90000.00 |
+----------------------------+---------------------+---------------------+
1 row in set (0.00 sec)

mysql> 

```


28. Find total salary expenditure per department.

```sql

mysql> DESC department;
+-----------+---------------+------+-----+---------+----------------+
| Field     | Type          | Null | Key | Default | Extra          |
+-----------+---------------+------+-----+---------+----------------+
| dept_id   | int           | NO   | PRI | NULL    | auto_increment |
| dept_name | varchar(50)   | NO   | UNI | NULL    |                |
| location  | varchar(50)   | YES  |     | NULL    |                |
| budget    | decimal(15,2) | YES  |     | 0.00    |                |
+-----------+---------------+------+-----+---------+----------------+
4 rows in set (0.00 sec)

mysql> SELECT * FROM department;
+---------+--------------------------+-----------+------------+
| dept_id | dept_name                | location  | budget     |
+---------+--------------------------+-----------+------------+
|       1 | krispcall                | Kalopul   |   10000.00 |
|       2 | Tivazo                   | baneswor  |   12221.23 |
|       3 | Dialaxy                  | Chabahill | 1212121.12 |
|       4 | Lumbinni medical College | lumbini   | 1752615.71 |
|       5 | Entegra                  | Bagbazaar |  122233.98 |
+---------+--------------------------+-----------+------------+
5 rows in set (0.00 sec)

mysql> Find total salary expenditure per department.^C
mysql> select * from employee;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql> select dept_id, SUM(salary) as total_sal_exp FROM employee GROUP BY dept_id;
+---------+---------------+
| dept_id | total_sal_exp |
+---------+---------------+
|       1 |     272000.00 |
|       2 |     203000.00 |
|       3 |     200000.00 |
+---------+---------------+
3 rows in set (0.00 sec)

mysql> SELECT d.dept_id,d.dept_name, SUM(salary) AS total_sal_exp FROM employee e JOIN department d ON e.dept_id = d.dept_id GROUP BY d,dept_id,d,dept_name;
ERROR 1054 (42S22): Unknown column 'd' in 'group statement'
mysql> SELECT d.dept_id,d.dept_name, SUM(e.salary) AS total_sal_exp FROM employee e JOIN department d ON e.deCpt_id = d.dept_id GROUP BY d.dept_id,d.dept_name;
ERROR 1054 (42S22): Unknown column 'e.deCpt_id' in 'on clause'
mysql> SELECT d.dept_id,d.dept_name, SUM(e.salary) AS total_sal_exp FROM employee e JOIN department d ON e.dept_id = d.dept_id GROUP BY d.dept_id,d.dept_name;
+---------+-----------+---------------+
| dept_id | dept_name | total_sal_exp |
+---------+-----------+---------------+
|       1 | krispcall |     272000.00 |
|       2 | Tivazo    |     203000.00 |
|       3 | Dialaxy   |     200000.00 |
+---------+-----------+---------------+
3 rows in set (0.01 sec)

mysql> 


```
29. Find the number of employees per department.

```sql
ysql> SELECT * FROM employee;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql> SELECT det_id, COUNT(*) AS no_of_empoyee FROM employee GROUP BY dept_id;
ERROR 1054 (42S22): Unknown column 'det_id' in 'field list'
mysql> SELECT dept_id, COUNT(*) AS no_of_empoyee FROM employee GROUP BY dept_id;
+---------+---------------+
| dept_id | no_of_empoyee |
+---------+---------------+
|       1 |             4 |
|       2 |             3 |
|       3 |             3 |
+---------+---------------+
3 rows in set (0.00 sec)

mysql> 

```

30. Find departments where the average salary is above 80000 (use HAVING).

```SQL
mysql> SELECT * FROM employee;
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
| emp_id | first_name | last_name | email                        | salary   | dept_id | manager_id | hire_date  | is_active |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
|      1 | John       | Smith     | john.smith@codavatar.tech    | 90000.00 |       1 |       NULL | 2020-01-15 |         1 |
|      2 | Sarah      | Johnson   | sarah.johnson@company.com    | 85000.00 |       2 |       NULL | 2020-03-20 |         1 |
|      3 | Michael    | Brown     | michael.brown@company.com    | 80000.00 |       3 |       NULL | 2021-02-10 |         1 |
|      4 | Emily      | Davis     | emily.davis@company.com      | 65000.00 |       1 |          1 | 2021-06-01 |         1 |
|      5 | David      | Wilson    | david.wilson@company.com     | 62000.00 |       1 |          1 | 2021-08-15 |         1 |
|      6 | Jessica    | Miller    | jessica.miller@company.com   | 60000.00 |       2 |          2 | 2022-01-12 |         1 |
|      7 | Daniel     | Moore     | daniel.moore@company.com     | 58000.00 |       2 |          2 | 2022-04-18 |         1 |
|      8 | Ashley     | Taylor    | ashley.taylor@company.com    | 61000.00 |       3 |          3 | 2022-07-22 |         1 |
|      9 | Matthew    | Anderson  | matthew.anderson@company.com | 59000.00 |       3 |          3 | 2023-01-09 |         1 |
|     10 | Olivia     | Thomas    | olivia.thomas@company.com    | 55000.00 |       1 |          1 | 2023-05-11 |         1 |
+--------+------------+-----------+------------------------------+----------+---------+------------+------------+-----------+
10 rows in set (0.00 sec)

mysql> Find departments where the average salary is above 80000 (use HAVING).^C
mysql> SEELCT dept_id FROM employee WHERE AVG(salary) > 80000;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'SEELCT dept_id FROM employee WHERE AVG(salary) > 80000' at line 1
mysql> SELECT dept_id FROM employee HAVN AVG(salary) > 80000;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'AVG(salary) > 80000' at line 1
mysql> SELECT dept_id FROM employee HAVING(salary) > 80000;
ERROR 1054 (42S22): Unknown column 'salary' in 'having clause'
mysql> SELECT dept_id FROM employee HAVING AVG(salary) > 80000;
ERROR 1140 (42000): In aggregated query without GROUP BY, expression #1 of SELECT list contains nonaggregated column 'company_db.employee.dept_id'; this is incompatible with sql_mode=only_full_group_by
mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING AVG(salary) > 80000;
Empty set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING AVG(salary) > 50000;
+---------+
| dept_id |
+---------+
|       1 |
|       2 |
|       3 |
+---------+
3 rows in set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING AVG(salary) > 60000;
+---------+
| dept_id |
+---------+
|       1 |
|       2 |
|       3 |
+---------+
3 rows in set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING AVG(salary) > 65000;
+---------+
| dept_id |
+---------+
|       1 |
|       2 |
|       3 |
+---------+
3 rows in set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING AVG(salary) > 75000;
Empty set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING AVG(salary) > 70000;
Empty set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING AVG(salary) > 68000;
Empty set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING AVG(salary) > 66000;
+---------+
| dept_id |
+---------+
|       1 |
|       2 |
|       3 |
+---------+
3 rows in set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING MAX(salary) > 90000;
Empty set (0.00 sec)

mysql> SELECT dept_id FROM employee GROUP BY dept_id HAVING MIN(salary) > 60000;
Empty set (0.00 sec)

mysql> 

```

---

## JOINs
31. INNER JOIN `employee` and `department` to show each employee's name and their department name.
32. LEFT JOIN to show all employees including those with no department assigned.
33. RIGHT JOIN to show all departments including those with no employees.
34. Self JOIN to show each employee alongside their manager's name.
35. 3-table JOIN: show employee name, department name, and the project they work on.
36. JOIN with aggregate: show total hours logged per employee across all projects.
37. JOIN with aggregate: show headcount, avg salary, max salary per department.

---

## Subqueries
38. Find employees earning more than the company-wide average salary.
39. Find employees working in the same department as a specific employee by name.
40. Find employees assigned to a specific project using an `IN` subquery.
41. Find departments that have at least one employee using `EXISTS`.
42. Find employees earning more than the average salary of their own department (correlated subquery).

---

## Views
43. Create a view `v_employee_details` showing full name, email, salary, department name for active employees only.
44. Query the view filtering by a specific department.
45. Create a view `v_dept_summary` showing headcount, avg salary, max and min salary per department.
46. List all views in the current database.
47. Drop a view.

---

## UPDATE & DELETE
48. Give all employees in a specific department a 10% salary raise.
Insert 5 departments with different locations and budgets.
12. Insert 10 employees — make sure some have `manager_id` pointing to existing employees.
13. Insert 5 projects and assign employees to projects via `works_on`.

---

## SELECT — Basic
14. Select all columns from `employee`.
15. Select only `first_name`, `last_name`, and `salary` with column aliases.
16. Select all employees sorted by salary descending.
17. Select the top 3 highest paid employees.
18. Select all distinct salary values.

49. Soft-delete an employee by setting `is_active` to false.
50. Hard-delete all inactive employees (handle FK constraint on `works_on` first).

---

## Transactions
51. Write a transaction that transfers salary between two employees — commit only if both updates succeed.
52. Use `SAVEPOINT` to insert a department, then attempt a bad employee insert, roll back only the bad insert, and commit the department.

---

## DCL
53. Create a read-only user with SELECT access on the entire database.
54. Create an app user with SELECT, INSERT, UPDATE on `employee` and `works_on` only.
55. Show grants for both users.
56. Revoke INSERT from the app user.
57. Drop both users.
