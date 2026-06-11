# MySQL Practice Questions

---

## Setup
1. Pull and run MySQL 8.4 using Docker with a named volume and root password, exposed on port 3306.
2. Shell into the running container and connect to MySQL as root.
3. Create a database called `company_db` and switch to it.

---

## DDL
4. Create a `department` table with columns: `dept_id` (PK, auto increment), `dept_name` (unique, not null), `location`, `budget` (decimal, default 0).
5. Create an `employee` table with: `emp_id` (PK), `first_name`, `last_name`, `email` (unique), `salary`, `dept_id` (FK to department), `manager_id` (self-referencing FK), `hire_date`, `is_active` (boolean, default true).
6. Create a `project` table linked to department via FK.
7. Create a `works_on` junction table with composite PK (`emp_id`, `proj_id`) and an `hours` column.
8. Add a `phone` column to `employee` using ALTER.
9. Drop the `phone` column.
10. What is the difference between `DROP TABLE`, `TRUNCATE`, and `DELETE`?

---

## DML — INSERT
11. Insert 5 departments with different locations and budgets.
12. Insert 10 employees — make sure some have `manager_id` pointing to existing employees.
13. Insert 5 projects and assign employees to projects via `works_on`.

---

## SELECT — Basic
14. Select all columns from `employee`.
15. Select only `first_name`, `last_name`, and `salary` with column aliases.
16. Select all employees sorted by salary descending.
17. Select the top 3 highest paid employees.
18. Select all distinct salary values.

---

## WHERE & Operators
19. Find employees with salary greater than 90000.
20. Find employees with salary between 70000 and 95000.
21. Find employees in `dept_id` 1 or 2 using `IN`.
22. Find employees whose `first_name` starts with 'A'.
23. Find employees whose email ends with `@company.com`.
24. Find all top-level managers (no manager assigned).
25. Find all employees who have a manager assigned.

---

## Aggregates & GROUP BY
26. Count total number of employees.
27. Find the average, min, and max salary across all employees.
28. Find total salary expenditure per department.
29. Find the number of employees per department.
30. Find departments where the average salary is above 80000 (use HAVING).

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
