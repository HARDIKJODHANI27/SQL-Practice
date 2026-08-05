IF OBJECT_ID('DEPARTMENTS', 'U') IS NULL
BEGIN
    CREATE TABLE DEPARTMENTS (
        DEPT_ID INT PRIMARY KEY,
    DEPT_NAME VARCHAR(50)
    );
    CREATE TABLE EMPLOYEES2 (
    EMP_ID INT PRIMARY KEY,
    EMP_NAME VARCHAR(50),
    DEPT_ID INT,
    HIRE_DATE DATE,
    CITY VARCHAR(50)
    );
    CREATE TABLE PROJECTS (
    PROJECT_ID INT PRIMARY KEY,
    PROJECT_NAME VARCHAR(50),
    DEPT_ID INT,
    BUDGET INT
    );
    CREATE TABLE SALARIES (
    SAL_ID INT PRIMARY KEY,
    EMP_ID INT,
    SALARY INT,
    BONUS INT,
    PAY_MONTH DATE
    );
END;

-- DEPARTMENTS SAMPLE DATA
INSERT INTO DEPARTMENTS VALUES (1,'Finance');
INSERT INTO DEPARTMENTS VALUES (2,'HR');
INSERT INTO DEPARTMENTS VALUES (3,'IT');
INSERT INTO DEPARTMENTS VALUES (4,'Marketing');
INSERT INTO DEPARTMENTS VALUES (5,'Operations');


-- EMPLOYEES SAMPLE DATA
INSERT INTO EMPLOYEES2 VALUES (101,'Amit',1,'2022-01-10','Delhi');
INSERT INTO EMPLOYEES2 VALUES (102,'Riya',2,'2021-03-15','Mumbai');
INSERT INTO EMPLOYEES2 VALUES (103,'John',3,'2020-05-20','Bangalore');
INSERT INTO EMPLOYEES2 VALUES (104,'Sneha',4, '2019-02-10','Delhi');
INSERT INTO EMPLOYEES2 VALUES (105,'Rahul',3,'2023-01-01','Pune');
INSERT INTO EMPLOYEES2 VALUES (106,'Karan',5, '2022-11-01','Mumbai');
INSERT INTO EMPLOYEES2 VALUES (107,'Megha',1, '2020-08-01','Delhi');
INSERT INTO EMPLOYEES2 VALUES (108,'Arjun',2, '2019-09-01','Chennai');
INSERT INTO EMPLOYEES2 VALUES (109,'Sara',3,'2021-10-11','Bangalore');
INSERT INTO EMPLOYEES2 VALUES (110,'Neha',4,'2022-02-02','Pune');


-- PROJECTS SAMPLE DATA
INSERT INTO PROJECTS VALUES (1,'Loan Automation',1,200000);
INSERT INTO PROJECTS VALUES (2,'HR Portal',2,150000);
INSERT INTO PROJECTS VALUES (3,'Data Warehouse',3,500000);
INSERT INTO PROJECTS VALUES (4,'Digital Marketing',4,250000);
INSERT INTO PROJECTS VALUES (5,'Supply Optimization',5,300000);

-- SALARIES SAMPLE DATA
INSERT INTO SALARIES VALUES (1,101,60000,5000,'2024-01-01');
INSERT INTO SALARIES VALUES (2,102,55000,4000,'2024-01-01');
INSERT INTO SALARIES VALUES (3,103,75000,7000,'2024-01-01');
INSERT INTO SALARIES VALUES (4,104,65000,3000,'2024-01-01');
INSERT INTO SALARIES VALUES (5,105,72000,6000,'2024-01-01');


-- 1.
SELECT * FROM EMPLOYEES2;
SELECT * FROM departments;

-- 2.
SELECT * FROM EMPLOYEEs2 WHERE DEPT_ID = 3;

-- 3.
SELECT * FROM EMPLOYEES2 WHERE hire_date > '2021-12-31';

-- 4
SELECT
    e.emp_name,
    d.dept_name
FROM employees2 e
INNER JOIN departments d
    ON e.dept_id = d.dept_id;

-- 5
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count
FROM departments d
INNER JOIN employees2 e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- 6
SELECT * FROM employees2 WHERE city IN ('Delhi', 'Mumbai');

-- 7

SELECT
    e.emp_name,
    s.salary,
    s.bonus
FROM employees2 e
INNER JOIN salaries s
    ON e.emp_id = s.emp_id;

-- 8

SELECT
    e.emp_name,
    s.salary
FROM employees2 e
INNER JOIN salaries s
    ON e.emp_id = s.emp_id
WHERE s.salary > 70000;

-- 9

SELECT
    d.dept_name,
    SUM(s.salary) AS total_salary
FROM departments d
INNER JOIN employees2 e
    ON d.dept_id = e.dept_id
INNER JOIN salaries s
    ON e.emp_id = s.emp_id
GROUP BY d.dept_name;

-- 10

SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count
FROM departments d
INNER JOIN employees2 e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) >= 3;

-- 11

SELECT
    e.emp_name,
    d.dept_name,
    p.project_name
FROM employees2 e
INNER JOIN departments d
    ON e.dept_id = d.dept_id
INNER JOIN projects p
    ON d.dept_id = p.dept_id;

-- 12

SELECT
    d.dept_name,
    AVG(s.salary) AS average_salary
FROM departments d
INNER JOIN employees2 e
    ON d.dept_id = e.dept_id
INNER JOIN salaries s
    ON e.emp_id = s.emp_id
GROUP BY d.dept_name;


-- 13

SELECT
    e.emp_name,
    s.salary,
    CASE
        WHEN s.salary >= 70000 THEN 'High'
        WHEN s.salary >= 60000 THEN 'Medium'
        ELSE 'Low'
    END AS salary_category
FROM employees2 e
INNER JOIN salaries s
    ON e.emp_id = s.emp_id;

-- 14


-- 15

SELECT TOP 3
    e.emp_name,
    s.salary
FROM employees2 e
INNER JOIN salaries s
    ON e.emp_id = s.emp_id
ORDER BY s.salary DESC;

-- 16

SELECT TOP 1
    d.dept_name,
    SUM(s.salary) AS total_salary
FROM departments d
INNER JOIN employees2 e
    ON d.dept_id = e.dept_id
INNER JOIN salaries s
    ON e.emp_id = s.emp_id
GROUP BY d.dept_name
ORDER BY total_salary DESC;

-- 17

SELECT
    e.emp_name,
    s.salary,
    RANK() OVER (ORDER BY s.salary DESC) AS salary_rank
FROM employees2 e
INNER JOIN salaries s
    ON e.emp_id = s.emp_id;

-- 18

SELECT
    e.emp_name,
    e.dept_id,
    ROW_NUMBER() OVER (PARTITION BY e.dept_id ORDER BY e.emp_name) AS row_num
FROM employees2 e;

-- 19

SELECT salary
FROM (
    SELECT
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM salaries
) t
WHERE rnk = 2;

-- 20

SELECT
    emp_name,
    dept_name,
    salary
FROM (
    SELECT
        e.emp_name,
        d.dept_name,
        s.salary,
        ROW_NUMBER() OVER (PARTITION BY d.dept_id ORDER BY s.salary DESC) AS rn
    FROM employees2 e
    INNER JOIN departments d
        ON e.dept_id = d.dept_id
    INNER JOIN salaries s
        ON e.emp_id = s.emp_id
) t
WHERE rn = 1;

-- 21

SELECT
    e.emp_name,
    s.salary
FROM employees2 e
INNER JOIN salaries s
    ON e.emp_id = s.emp_id
WHERE s.salary >
(
    SELECT AVG(s2.salary)
    FROM employees2 e2
    INNER JOIN salaries s2
        ON e2.emp_id = s2.emp_id
    WHERE e2.dept_id = e.dept_id
);

-- 22
-- 23

-- 24

SELECT TOP 1
    d.dept_name,
    SUM(p.budget) AS total_budget
FROM departments d
INNER JOIN projects p
    ON d.dept_id = p.dept_id
GROUP BY d.dept_name
ORDER BY total_budget DESC;

-- 25

SELECT
    emp_name,
    dept_name,
    hire_date
FROM
(
    SELECT
        e.emp_name,
        d.dept_name,
        e.hire_date,
        ROW_NUMBER() OVER (PARTITION BY e.dept_id ORDER BY e.hire_date) AS rn
    FROM employees2 e
    INNER JOIN departments d
        ON e.dept_id = d.dept_id
) t
WHERE rn = 1;