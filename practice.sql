IF OBJECT_ID('employees', 'U') IS NULL
BEGIN
    CREATE TABLE employees (
        id INT IDENTITY(1,1) PRIMARY KEY,
        fname VARCHAR(20) NOT NULL,
        lname VARCHAR(20) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        job_title VARCHAR(50) NOT NULL,
        department VARCHAR(50),
        salary DECIMAL(10,2) DEFAULT 30000.00,
        hire_date DATE NOT NULL DEFAULT CONVERT(date, GETDATE()),
        city VARCHAR(50)
    );
END;

EXEC sp_help 'employees';

INSERT INTO employees

(fname, lname, email, job_title, department, salary, hire_date, city)

VALUES

('Aarav', 'Sharma', 'aarav.sharma@example.com', 'Director', 'Management', 180000, '2019-02-10', 'Mumbai'),

('Diya', 'Patel', 'diya.patel@example.com', 'Lead Engineer', 'Tech', 120000, '2020-08-15', 'Bengaluru'),

('Rohan', 'Mehra', 'rohan.mehra@example.com', 'Software Engineer', 'Tech', 85000, '2022-05-20', 'Bengaluru'),

('Priya', 'Singh', 'priya.singh@example.com', 'HR Manager', 'Human Resources', 95000, '2019-11-05', 'Mumbai'),

('Arjun', 'Kumar', 'arjun.kumar@example.com', 'Data Scientist', 'Tech', 110000, '2021-07-12', 'Hyderabad'),

('Ananya', 'Gupta', 'ananya.gupta@example.com', 'Marketing Lead', 'Marketing', 90000, '2020-03-01', 'Delhi'),

('Vikram', 'Reddy', 'vikram.reddy@example.com', 'Sales Executive', 'Sales', 75000, '2023-01-30', 'Mumbai'),

('Sameera', 'Rao', 'sameera.rao@example.com', 'Software Engineer', 'Tech', 88000, '2023-06-25', 'Pune'),

('Ishaan', 'Verma', 'ishaan.verma@example.com', 'Recruiter', 'Human Resources', 65000, '2022-09-01', 'Mumbai'),

('Kavya', 'Joshi', 'kavya.joshi@example.com', 'Product Designer', 'Design', 92000, '2021-04-18', 'Bengaluru'),

('Zain', 'Khan', 'zain.khan@example.com', 'Sales Manager', 'Sales', 115000, '2019-09-14', 'Delhi'),

('Nisha', 'Desai', 'nisha.desai@example.com', 'Jr. Data Analyst', 'Tech', 70000, '2024-02-01', 'Hyderabad'),

('Aditya', 'Nair', 'aditya.nair@example.com', 'Marketing Analyst', 'Marketing', 68000, '2022-10-10', 'Delhi'),

('Fatima', 'Ali', 'fatima.ali@example.com', 'Sales Executive', 'Sales', 78000, '2022-11-22', 'Mumbai'),

('Kabir', 'Shah', 'kabir.shah@example.com', 'DevOps Engineer', 'Tech', 105000, '2020-12-01', 'Pune');

SELECT * FROM employees;

--   WHERE CLAUSE

SELECT * FROM employees WHERE department = 'Tech';

SELECT * FROM employees WHERE department != 'Tech';
SELECT * FROM employees;

SELECT * FROM employees WHERE salary > 100000;

SELECT * FROM employees WHERE hire_date >= '2021-01-01';


-- DISTINCT CLAUSE

SELECT DISTINCT department FROM employees;

SELECT DISTINCT city FROM employees;


-- ORDER BY CLAUSE

SELECT * FROM employees ORDER BY salary DESC;

SELECT department,fname,lname FROM employees ORDER BY department, lname;

-- LIKE CLAUSE

SELECT * FROM employees WHERE department LIKE '%H% %R%';

SELECT * FROM employees WHERE lname LIKE '%a';

SELECT * FROM employees WHERE email LIKE '%Gupta%';

SELECT * FROM employees WHERE fname LIKE '[^A]%';

SELECT * FROM employees WHERE fname LIKE '_A%';

SELECT * FROM employees WHERE fname LIKE '____';


-- TOP CLAUSE

SELECT TOP 3 * FROM employees;

SELECT TOP 3 * FROM employees ORDER By  salary DESC;


-- EXCERCISE

--Show records of employees who are working in the 'Tech' department and have a salary greater than 90000.
SELECT * FROM employees WHERE department = 'Tech' AND salary > 90000;

-- Show records of employees where length of the last name is 4 letters.
SELECT * FROM employees WHERE lname LIKE '____'; 



--  CASE STATEMENT

-- Show records of employees with a salary greater than 100000 and label them as 'High Earner', those with a salary between 75000 and 100000 as 'Medium Earner', and those with a salary less than 75000 as 'Low Earner'.
SELECT fname, lname, salary,
      CASE 
            WHEN salary > 100000 THEN 'High Earner'
            WHEN salary BETWEEN 75000 AND 100000 THEN 'Medium Earner'
            ELSE 'Low Earner'
        END AS salary_category
FROM employees ORDER BY salary DESC;


-- Show records with bonus based on the department. Employees in the 'Tech' department receive a bonus of 12% of their salary, those in 'Sales' and 'Marketing' receive 10%, and all others receive 5%.
SELECT fname, lname, salary, department,
      CASE 
            WHEN department LIKE 'Tech' THEN salary + salary * 0.12
            WHEN department IN('Sales', 'Marketing ') THEN salary + salary * 0.10
            ELSE salary + salary * 0.05
        END AS BONUS
FROM employees ORDER BY salary DESC;


-- Excercise 2

--Display the top 5 highest-paid employees who work in either the Tech or Sales department and were hired after 1 January 2021.
SELECT TOP 5 * FROM employees WHERE department IN ('Tech', 'Sales') AND hire_date > '2021-01-01' ORDER BY salary DESC;

--Show the first name, last name, department, salary, and city of employees who do not work in Marketing and earn between ₹80,000 and ₹1,20,000, sorted by salary in descending order.
SELECT fname, lname, department, salary, city FROM employees WHERE department != 'Marketing' AND salary BETWEEN 80000 AND 120000 ORDER BY salary DESC;



--Show all employees hired before 2022. Create another column named Experience Level: 
--Before 2020 → Senior
--2020–2021 → Mid-Level
--Sort by hire date.


SELECT fname, lname, hire_date, salary, department,
    CASE
        WHEN hire_date < '2020-01-01' THEN 'Senior Employee'
        WHEN hire_date BETWEEN '2020-01-01' AND '2022-01-01' THEN 'Mid-level Employee'
        ELSE 'Junior Employee'
    END AS Experience
FROM employees
ORDER BY hire_date ASC;


-- Display all employees with the following columns:

-- Full Name (fname + lname)
-- Department
-- Salary
-- Salary Category

-- ₹1,20,000 → Platinum

-- ₹90,000–₹1,20,000 → Gold
-- ₹70,000–₹89,999 → Silver
-- Otherwise → Bronze

-- Order the results by department and then salary (highest first).

SELECT fname, lname, department, salary,
    CASE
        WHEN salary >= 120000 THEN 'Platinum'
        WHEN salary BETWEEN 90000 AND 119999 THEN 'GOLD'
        WHEN salary BETWEEN 70000 AND 89999 THEN 'SILVER'
        ELSE 'BRONZE'
    END AS Salary_Category
FROM employees
ORDER BY department, salary DESC;


-- Write one SQL query that returns:

-- Full Name
-- Department
-- Job Title
-- Salary
-- Hire Date
-- City
-- A CASE column called Employee Grade
-- Salary > ₹1,20,000 → Grade A
-- ₹90,000–₹1,20,000 → Grade B
-- ₹70,000–₹89,999 → Grade C
-- Otherwise → Grade D
-- Show only employees:
-- from Tech, Sales, or Marketing
-- hired after 1 January 2020
-- whose first name starts with A or D
-- salary between ₹70,000 and ₹1,20,000
-- Sort by salary (highest first).
-- Return only the top 5 records.


SELECT TOP 5 fname, lname, department, salary,
    CASE
        WHEN salary >= 120000 THEN 'Grade A'
        WHEN salary BETWEEN 90000 AND 119999 THEN 'Grade B'
        WHEN salary BETWEEN 70000 AND 89999 THEN 'Grade C'
        ELSE 'Grade D'
    END AS Salary_Category
FROM employees WHERE department IN ('Tech', 'Sales', 'Marketing') AND hire_date > '2020-01-01' AND (fname LIKE 'A%' OR fname LIKE 'D%') AND salary BETWEEN 70000 AND 120000 ORDER BY salary DESC;

-- Aggregate functions

SELECT COUNT(id) FROM employees;
SELECT MIN(salary) FROM employees;
SELECT MAX(salary) FROM employees;
SELECT AVG(salary) FROM employees;
SELECT SUM(salary) FROM employees;

-- GROUP BY Function

SELECT department, COUNT(id) AS Employee_Count FROM employees GROUP BY department;
SELECT city, COUNT(id) AS Employee_Count FROM employees GROUP BY city;
SELECT department, AVG(salary) AS Average_Salary FROM employees GROUP BY department;
SELECT department, SUM(salary) AS Total_Salary FROM employees GROUP BY department;

SELECT department, city, COUNT(id) AS Employee_count
FROM employees GROUP BY department, city
ORDER BY department, city;


-- HAVING CLAUSE
SELECT department, COUNT(id) AS Employee_count
FROM employees
GROUP BY department HAVING COUNT(id) > 2;

SELECT job_title, AVG(salary) AS Average_Salary
FROM employees
GROUP BY job_title HAVING AVG(salary) > 90000;

SELECT department, SUM(salary) AS Total_Salary
FROM employees
GROUP BY department HAVING SUM(salary) > 300000; 


-- GROUP BY ROLLUP

SELECT department, COUNT(id) AS Employee_count
FROM employees GROUP BY ROLLUP(department);


SELECT department, city, COUNT(id) AS Employee_count
FROM employees GROUP BY ROLLUP(department, city);


-- SUB QUERIES

SELECT * FROM employees WHERE salary < (SELECT AVG(salary) FROM employees);

SELECT fname, lname, department, city
FROM employees WHERE department IN 
(SELECT department FROM employees WHERE city = 'Mumbai');

SELECT fname, lname, department FROM employees WHERE salary = (SELECT MAX(salary) FROM employees) GROUP BY department;

--- CORRELATED SUB QUERIES

SELECT id, fname, lname, salary, department
FROM employees e1
WHERE salary = (SELECT MAX(salary) FROM employees e2 WHERE e2.department = e1.department);

SELECT department FROM employees
GROUP BY department
 HAVING avg(salary) > 90000;
 
-- STRING FUNCTIONS
SELECT CONCAT(fname, ' ', lname) AS 'Full Name' FROM employees;
SELECT CONCAT_WS(':', 'One', 'Two', 'Three')
SELECT SUBSTRING('HELLO WORLD', 1, 5)
SELECT REPLACE('Hey World', 'Hey', 'Hello')

-- STRING EXERCISE
SELECT CONCAT_WS(':', id, fname, lname, department, salary) AS Emp_Details FROM EMPLOYEES;

SELECT CONCAT_WS(':', id, CONCAT(fname, ' ', lname), department, salary) AS Emp_Details FROM EMPLOYEES;


-- ALTER FUNCTION
ALTER TABLE employees
ADD phone_number VARCHAR(15);

ALTER TABLE employees
DROP COLUMN phone_number;

ALTER TABLE employees
ADD CONSTRAINT default_dept DEFAULT 'Trainee'
FOR department;

EXEC sp_help 'employees';

INSERT INTO employees (fname, lname, email, job_title, salary, city)
VALUES ('Riya', 'Chopra',  'riyachopra@example.com', 'Fresher', 30000, 'Mumbai');

 
SELECT * FROM employees;

UPDATE employees
SET id = 16
WHERE id = 2002;

-- CHECK CONSTRAINT

ALTER TABLE employees
ADD CONSTRAINT chk_pos_sal CHECK (salary > 0);

INSERT INTO employees (fname, lname, email, job_title, salary, city)
VALUES ('Paul', 'Verma',  'paulverma@example.com', 'Fresher', -30000, 'Mumbai');
-- The above input fails and gives an error because of the check constraint on salary.

ALTER TABLE employees
ADD CONSTRAINT valid_email CHECK (email LIKE '%@%.%');


INSERT INTO employees (fname, lname, email, job_title, salary, city)
VALUES ('Paul', 'Verma',  'paulverma@example_com', 'Fresher', -30000, 'Mumbai');
-- The above input fails and gives an error because of the check constraint on email.









-- CREATING a COMPLETELY NEW SET OF TABLES AND ADDING NEW DATA FOR FURTHER LEARNING AND PRACTICE
IF OBJECT_ID('Customers', 'U') IS NULL
BEGIN
    CREATE TABLE Customers (
        customer_id INT IDENTITY(100,1) PRIMARY KEY,
        customer_name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE
    );
END;



IF OBJECT_ID('Orders', 'U') IS NULL
BEGIN
    CREATE TABLE Orders (
        order_id INT IDENTITY(500,1) PRIMARY KEY,
        order_date DATE NOT NULL,
        total_amount DECIMAL(10, 2),
        customer_id INT,
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
    ); 
END;


INSERT INTO Customers (customer_name, email) VALUES 
('Raju', 'raju@example.com'), 
('Sham', 'sham@example.com'), 
('Baburao', 'baburao@example.com');

INSERT INTO Orders (order_date, total_amount, customer_id) VALUES 
('2025-09-15', 1500.00, 100),
('2025-09-28', 800.00, 101), 
('2025-10-05', 2200.00, 100), 
('2025-10-12', 500.00, 102),
 ('2025-10-17', 1200.00, 101);


SELECT * FROM Customers;
SELECT * FROM Orders;


-- There may be a customer who hasn't placed an order yet but has an account in the Customers table. We can add a new customer without an order.
INSERT INTO customers (customer_name, email) VALUES 
('Ramesh', 'ramesh@example.com');

-- There may be an order where the customer refused to provide their details. We can add a new order without a customer_id.
INSERT INTO Orders (order_date, total_amount) VALUES 
('2025-10-20', 1800.00);   


DELETE FROM customers WHERE customer_id = 102;

-- JOINS

-- CROSS JOIN
SELECT * FROM customers CROSS JOIN orders;


-- INNER JOIN
SELECT c1.customer_name, COUNT(o1.order_id) AS Total_Orders, SUM(o1.total_amount) AS Total_Amount FROM 
customers c1
INNER JOIN orders o1
ON c1.customer_id = o1.customer_id
GROUP BY customer_name;


--LEFT & RIGHT JOIN
SELECT c1.customer_name, COUNT(o1.order_id) AS Total_Orders, SUM(o1.total_amount) AS Total_Amount FROM 
customers c1
LEFT JOIN orders o1
ON c1.customer_id = o1.customer_id
GROUP BY customer_name;

SELECT c1.customer_name, COUNT(o1.order_id) AS Total_Orders, SUM(o1.total_amount) AS Total_Amount FROM 
customers c1
RIGHT JOIN orders o1
ON c1.customer_id = o1.customer_id
GROUP BY customer_name;
