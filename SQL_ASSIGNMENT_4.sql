IF DB_ID('RetailAnalyticsDB') IS NULL
    CREATE DATABASE RealAnalyticsDB;

USE RealAnalyticsDB;


-- Departments Table
IF OBJECT_ID('Departmenrs', 'U') IS NULL
BEGIN
    CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50)
    );
END


-- Employees Table
IF OBJECT_ID('Employees', 'U') IS NULL
BEGIN
CREATE TABLE Employees (
EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100) UNIQUE,
Phone VARCHAR(15),
HireDate DATE NOT NULL,
JobTitle VARCHAR(50),
Salary DECIMAL(10,2) CHECK (Salary > 0),
DepartmentID INT NULL REFERENCES Departments(DepartmentID),
ManagerID INT NULL REFERENCES Employees(EmployeeID) -- self-referencing FK
);
END

-- Customers Table
IF OBJECT_ID('Customers', 'U') IS NULL
BEGIN
CREATE TABLE Customers (
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Email VARCHAR(100) NOT NULL UNIQUE,
City VARCHAR(50),
State VARCHAR(50),
Country VARCHAR(50),
JoinDate DATE DEFAULT GETDATE()
);
END

-- Categories Table
IF OBJECT_ID('Categories', 'U') IS NULL
BEGIN
CREATE TABLE Categories (
CategoryID INT IDENTITY(1,1) PRIMARY KEY,
CategoryName VARCHAR(50) NOT NULL UNIQUE
);
END


-- Suppliers Table
IF OBJECT_ID('Suppliers', 'U') IS NULL
BEGIN
CREATE TABLE Suppliers (
SupplierID INT IDENTITY(1,1) PRIMARY KEY,
SupplierName VARCHAR(100) NOT NULL,
City VARCHAR(50),
Country VARCHAR(50),
ContactEmail VARCHAR(100)
);
END


--Products Table
IF OBJECT_ID('Products', 'U') IS NULL
BEGIN
CREATE TABLE Products (
ProductID INT IDENTITY(1,1) PRIMARY KEY,
ProductName VARCHAR(100) NOT NULL,
CategoryID INT NULL REFERENCES Categories(CategoryID),
SupplierID INT NULL REFERENCES Suppliers(SupplierID),
UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
StockQuantity INT DEFAULT 0
);
END


-- Orders Table
IF OBJECT_ID('Orders', 'U') IS NULL
BEGIN
CREATE TABLE Orders (
OrderID INT IDENTITY(1,1) PRIMARY KEY,
CustomerID INT NULL REFERENCES Customers(CustomerID),
EmployeeID INT NULL REFERENCES Employees(EmployeeID),
OrderDate DATE NOT NULL,
ShipDate DATE NULL,
Status VARCHAR(20) DEFAULT 'Pending'
);
END


-- Orders Details Table
IF OBJECT_ID('OrderDetails', 'U') IS NULL
BEGIN
CREATE TABLE OrderDetails (
OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL REFERENCES Orders(OrderID),
ProductID INT NOT NULL REFERENCES Products(ProductID),
Quantity INT NOT NULL CHECK (Quantity > 0),
UnitPrice DECIMAL(10,2) NOT NULL,
Discount DECIMAL(4,2) DEFAULT 0
);
END


-- Payments Table
IF OBJECT_ID('Payments', 'U') IS NULL
BEGIN
CREATE TABLE Payments (
 PaymentID INT IDENTITY(1,1) PRIMARY KEY,
 OrderID INT NOT NULL REFERENCES Orders(OrderID),
 PaymentDate DATE NOT NULL,
 Amount DECIMAL(10,2) NOT NULL,
 PaymentMethod VARCHAR(20) NOT NULL
);
END


-- Returns Table
IF OBJECT_ID('Returns', 'U') IS NULL
BEGIN
CREATE TABLE Returns (
 ReturnID INT IDENTITY(1,1) PRIMARY KEY,
 OrderDetailID INT NOT NULL REFERENCES OrderDetails(OrderDetailID),
 ReturnDate DATE NOT NULL,
 Reason VARCHAR(100),
 RefundAmount DECIMAL(10,2)
);
END



INSERT INTO Departments (DepartmentName, Location) VALUES
('Sales','Kolkata'),
('Marketing','Mumbai'),
('IT','Hyderabad'),
('HR','Bengaluru'),
('Finance','Delhi');


INSERT INTO Employees (FirstName,LastName,Email,Phone,HireDate,JobTitle,Salary,DepartmentID,ManagerID) VALUES
('Arjun','Sharma','arjun.sharma@retailcorp.com','9831122334','2018-03-15','Sales Manager',65000,1,NULL),
('Priya','Das','priya.das@retailcorp.com','9831122335','2019-06-01','Sales Executive',42000,1,1),
('Rohit','Verma','rohit.verma@retailcorp.com','9831122336','2020-01-10','Sales Executive',40000,1,1),
('Sneha','Roy','sneha.roy@retailcorp.com','9831122337','2017-11-20','Marketing Manager',70000,2,NULL),
('Kabir','Khan','kabir.khan@retailcorp.com','9831122338','2021-02-14','Marketing Executive',38000,2,4),
('Ananya','Gupta','ananya.gupta@retailcorp.com','9831122339','2019-09-05','IT Manager',85000,3,NULL),
('Vikram','Singh','vikram.singh@retailcorp.com','9831122340','2022-04-18','Data Analyst',45000,3,6),
('Ishita','Mukherjee','ishita.mukherjee@retailcorp.com','9831122341','2023-01-09','Data Analyst Intern',20000,3,6),
('Rajesh','Nair','rajesh.nair@retailcorp.com','9831122342','2018-07-22','HR Manager',60000,4,NULL),
('Meera','Iyer','meera.iyer@retailcorp.com','9831122343','2020-10-30','HR Executive',35000,4,9),
('Suresh','Menon','suresh.menon@retailcorp.com','9831122344','2017-05-12','Finance Manager',72000,5,NULL),
('Divya','Pillai','divya.pillai@retailcorp.com','9831122345','2021-08-25','Finance Executive',41000,5,11);


INSERT INTO Customers (FirstName,LastName,Email,City,State,Country,JoinDate) VALUES
('Aditya','Bose','aditya.bose@gmail.com','Kolkata','West Bengal','India','2022-01-15'),
('Riya','Chatterjee','riya.chatterjee@gmail.com','Kolkata','West Bengal','India','2022-02-20'),
('Karan','Malhotra','karan.malhotra@gmail.com','Delhi','Delhi','India','2021-11-05'),
('Neha','Kapoor','neha.kapoor@gmail.com','Mumbai','Maharashtra','India','2023-03-10'),
('Arnav','Joshi','arnav.joshi@gmail.com','Pune','Maharashtra','India','2022-07-19'),
('Simran','Kaur','simran.kaur@gmail.com','Chandigarh','Punjab','India','2023-05-01'),
('Farhan','Ali','farhan.ali@gmail.com','Hyderabad','Telangana','India','2021-09-12'),
('Pooja','Reddy','pooja.reddy@gmail.com','Hyderabad','Telangana','India','2022-12-03'),
('Devansh','Trivedi','devansh.trivedi@gmail.com','Ahmedabad','Gujarat','India','2023-06-25'),
('Kavya','Nambiar','kavya.nambiar@gmail.com','Bengaluru','Karnataka','India','2021-04-08'),
('Rohan','Bhatt','rohan.bhatt@gmail.com','Bengaluru','Karnataka','India','2022-10-17'),
('Anjali','Desai','anjali.desai@gmail.com','Surat','Gujarat','India','2023-02-14'),
('James','Carter','james.carter@gmail.com','New York','NY','USA','2022-08-09'),
('Emily','Clark','emily.clark@gmail.com','London','England','UK','2023-01-22'),
('Wei','Zhang','wei.zhang@gmail.com','Singapore','Singapore','Singapore','2022-05-30');


INSERT INTO Categories (CategoryName) VALUES
('Electronics'),
('Grocery'),
('Apparel'),
('Furniture'),
('Stationery'),
('Beauty');

SELECT * FROM Categories

INSERT INTO Suppliers (SupplierName,City,Country,ContactEmail) VALUES
('TechSource Pvt Ltd','Bengaluru','India','contact@techsource.com'),
('FreshFarm Distributors','Kolkata','India','sales@freshfarm.com'),
('UrbanThreads Apparel','Mumbai','India','info@urbanthreads.com'),
('HomeStyle Furniture Co','Chennai','India','support@homestyle.com'),
('WriteWell Stationers','Delhi','India','hello@writewell.com'),
('GlowBeauty Imports','Hyderabad','India','sales@glowbeauty.com');

INSERT INTO Products (ProductName,CategoryID,SupplierID,UnitPrice,StockQuantity) VALUES
('Wireless Mouse',1,1,599,150),('Bluetooth Headphones',1,1,1999,80),
('USB-C Charger',1,1,799,200),('Laptop Stand',1,1,1299,60),
('Basmati Rice 5kg',2,2,650,300),('Organic Honey 500g',2,2,320,120),
('Green Tea Pack',2,2,180,250),('Almonds 1kg',2,2,900,90),
('Men''s Cotton T-Shirt',3,3,499,200),('Women''s Kurti',3,3,899,150),
('Denim Jeans',3,3,1499,100),('Winter Jacket',3,3,2999,40),
('Office Chair',4,4,4999,25),('Study Table',4,4,3499,30),
('Bookshelf',4,4,2799,20),('Notebook Pack of 5',5,5,150,400),
('Gel Pen Set',5,5,99,500),('Sketchbook',5,5,199,220),
('Face Moisturizer',6,6,349,130),('Herbal Shampoo',6,6,279,160);

SELECT * FROM Products;


INSERT INTO Orders (CustomerID,EmployeeID,OrderDate,ShipDate,Status) VALUES
(1,2,'2023-01-05','2023-01-08','Delivered'),(2,3,'2023-01-12','2023-01-15','Delivered'),
(3,2,'2023-01-20','2023-01-25','Delivered'),(4,1,'2023-02-02','2023-02-06','Delivered'),
(5,3,'2023-02-14',NULL,'Cancelled'),(1,2,'2023-02-28','2023-03-02','Delivered'),
(6,2,'2023-03-10','2023-03-14','Delivered'),(7,3,'2023-03-15','2023-03-20','Delivered'),
(8,1,'2023-03-22',NULL,'Pending'),(2,2,'2023-04-01','2023-04-05','Delivered'),
(9,3,'2023-04-11','2023-04-15','Delivered'),(10,2,'2023-04-18','2023-04-22','Delivered'),
(3,1,'2023-05-02','2023-05-06','Delivered'),(11,3,'2023-05-15',NULL,'Cancelled'),
(12,2,'2023-05-25','2023-05-29','Delivered'),(4,1,'2023-06-05','2023-06-10','Delivered'),
(13,2,'2023-06-18','2023-06-24','Delivered'),(14,3,'2023-07-01','2023-07-07','Delivered'),
(15,1,'2023-07-15',NULL,'Pending'),(5,2,'2023-08-02','2023-08-07','Delivered'),
(1,3,'2023-09-10','2023-09-14','Delivered'),(7,1,'2023-10-05','2023-10-10','Delivered'),
(9,2,'2023-11-20','2023-11-25','Delivered'),(2,3,'2024-01-08','2024-01-12','Delivered'),
(6,1,'2024-02-14',NULL,'Pending');


INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitPrice,Discount) VALUES
(1,1,2,599,0),
(1,3,1,799,0),
(2,5,3,650,0.05),
(2,6,2,320,0),
(3,9,2,499,0),
(3,11,1,1499,0.10),
(4,13,1,4999,0),
(4,16,5,150,0),
(5,2,1,1999,0),
(6,1,1,599,0),
(6,4,1,1299,0),
(7,19,2,349,0),
(7,20,2,279,0),
(8,10,1,899,0),
(8,12,1,2999,0.15),
(9,17,10,99,0),
(9,18,5,199,0),
(10,5,2,650,0),
(10,8,1,900,0),
(11,2,2,1999,0.05),
(12,14,1,3499,0),
(12,15,1,2799,0),
(13,1,3,599,0),
(13,3,2,799,0),
(14,9,4,499,0),
(15,6,1,320,0),
(15,7,2,180,0),
(16,13,2,4999,0.10),
(17,11,1,1499,0),
(17,12,1,2999,0),
(18,16,3,150,0),
(18,17,5,99,0),
(19,19,1,349,0),
(20,2,1,1999,0),
(20,4,1,1299,0),
(21,5,4,650,0),
(21,8,2,900,0),
(22,9,3,499,0),
(22,10,2,899,0),
(23,1,5,599,0.05),
(24,20,3,279,0),
(24,19,3,349,0),
(25,6,2,320,0),
(25,7,4,180,0);



INSERT INTO Payments (OrderID, PaymentDate, Amount, PaymentMethod) VALUES
(1, '2023-01-05', 1997.00, 'UPI'),
(2, '2023-01-12', 2492.50, 'Credit Card'),
(3, '2023-01-20', 2347.10, 'Net Banking'),
(4, '2023-02-02', 5749.00, 'Credit Card'),
(6, '2023-02-28', 1898.00, 'UPI'),
(7, '2023-03-10', 1256.00, 'Debit Card'),
(8, '2023-03-15', 3448.15, 'UPI'),
(10, '2023-04-01', 2200.00, 'Credit Card'),
(11, '2023-04-11', 3798.10, 'Cash on Delivery'),
(12, '2023-04-18', 6298.00, 'Credit Card'),
(13, '2023-05-02', 3395.00, 'UPI'),
(15, '2023-05-25', 680.00, 'Debit Card'),
(16, '2023-06-05', 8998.20, 'Credit Card'),
(17, '2023-06-18', 4498.00, 'UPI'),
(18, '2023-07-01', 945.00, 'Net Banking'),
(20, '2023-08-02', 3298.00, 'Credit Card'),
(21, '2023-09-10', 4400.00, 'UPI'),
(22, '2023-10-05', 3295.00, 'Debit Card'),
(23, '2023-11-20', 2845.25, 'UPI'),
(24, '2024-01-08', 1884.00, 'Credit Card');


INSERT INTO Returns (OrderDetailID, ReturnDate, Reason, RefundAmount) VALUES
(8, '2023-02-10', 'Wrong item received', 300.00),
(15, '2023-03-25', 'Defective product', 2549.15),
(22, '2023-04-25', 'Damaged in transit', 2799.00),
(37, '2023-09-20', 'Changed mind', 900.00),
(2, '2023-01-12', 'Not compatible', 799.00);


-- Question 1:
SELECT * FROM Payments WHERE (PaymentMethod = 'UPI' OR PaymentMethod = 'Credit Card') AND Amount > 2000;


-- Question 2:
SELECT * FROM [Returns] WHERE Reason LIKE '%damaged%' Or Reason LIKE '%defective%';


-- Question 3:
SELECT SUM(RefundAmount) FROM [Returns];


-- Question 4:
SELECT SUM(Amount) AS Total_Amount ,COUNT(Amount) AS Payment_Count, SUM(Amount)/COUNT(Amount) AS Average_Amount FROM Payments;


-- Question 5:
SELECT MIN(PaymentDate) AS EARLIEST, MAX(PaymentDate) AS LATEST FROM Payments;

-- Question 6:
SELECT SUM(Amount) AS Collected_Payment, PaymentMethod FROM Payments GROUP BY PaymentMethod;


-- Question 7:


-- Question8:
SELECT p.CategoryID,
 o.OrderDate,
SUM(od.UnitPrice*od.Quantity) AS Total_Revenue
FROM OrderDetails AS od
JOIN Products p ON od.ProductID = p.ProductID
JOIN Orders o ON o.OrderID = od.OrderID
GROUP BY ROLLUP(p.CategoryID,  o.OrderDate);


-- Question 9:
SELECT SUM(Amount) AS Total_Revenue, PaymentMethod FROm Payments
GROUP BY PaymentMethod HAVING SUM(Amount) > 5000;


-- Question 10:
SELECT 
SUM(od.quantity*od.unitprice) AS Total_Revenue,
c.CategoryName
FROM OrderDetails od
JOIN Products p ON p.ProductID = od.ProductID
JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY CategoryName;


-- Question 11:
SELECT o.customerID, p.amount, COUNT(od.orderID)
FROM OrderDetails od
JOIN Orders o on o.orderID = od.orderID
JOIN Payments p on p.orderID = od.orderID
GROUP BY p.amount, o.customerID
HAVING p.amount > 3000 AND COUNT(od.orderID) > 2;

-- Question 12:
SELECT Count(od.OrderID)  AS Returned
FROM [Returns] r
JOIN OrderDetails od on od.OrderDetailID = r.OrderDetailID
GROUP BY od.OrderID
HAVING Count(od.OrderID) > 2

-- Question 13:
SELECT DATENAME(month, OrderDate), SUM(od.Quantity * od.UnitPrice) AS TOTAL_SALES
FROM Orders o
JOIN OrderDetails od on o.OrderID = od.OrderID
GROUP BY od.Quantity, od.UnitPrice, o.OrderDate
HAVING SUM(od.Quantity * od.UnitPrice) > 2000;

-- Question 14:
SELECT PaymentID, FirstName, LastName, OrderDate, PaymentDate, Amount, PaymentMethod
FROM Payments p
JOIN  Orders o on p.OrderID = o.OrderID
JOIN Customers c on o.CustomerID = c.CustomerID

-- Question 15:
SELECT ProductName, OrderDate, ReturnDate, Reason
FROM [Returns] r
JOIN OrderDetails od on od.OrderDetailID = r.OrderDetailID
JOIN Products p on p.ProductID = od.ProductID
JOIN Orders o on o.OrderID = od.OrderID 

-- Question 16:
SELECT o.OrderID, p.PaymentID, p.PaymentMethod
FROM Orders o
LEFT JOIN Payments p on p.OrderID = o.OrderID
WHERE [Status] = 'Delivered'

-- Question 17:
SELECT od.OrderDetailID,od.OrderID, r.ReturnID, r.Reason
FROm OrderDetails od
LEFT JOIN [Returns] r on r.OrderDetailID = od.OrderDetailID

-- Question 18:
SELECT c.FirstName, c.LastName, p.Amount, p.PaymentMethod
FROM Orders o
JOIN Payments p on o.OrderID = p.OrderID
RIGHT JOIN Customers c on c.CustomerID = o.CustomerID

-- Questioin 19:
SELECT c.CategoryName, p.PaymentMethod
FROM Payments p
JOIN OrderDetails od on p.OrderID = od.OrderID
CROSS JOIN Categories c
GROUP BY c.CategoryName, p.PaymentMethod;

--Question 20:
SELECT od.OrderDetailID, od.OrderID, r.ReturnID, r.Reason, r.RefundAmount
FROM OrderDetails od
FULL OUTER JOIN [Returns] r on r.OrderDetailID = od.OrderDetailID

--Question 21:
SELECT CONCAT_WS(':', PaymentID, PaymentMethod) AS pay_method FROM Payments

-- Q22
SELECT
    Email,
    SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS EmailDomain
FROM Customers;

-- Q23
SELECT
    ProductName,
    REPLACE(ProductName, ' ', '_') AS ModifiedProductName
FROM Products;

-- Q24
SELECT
    Reason,
    TRIM(Reason) AS TrimmedReason
FROM Returns;

-- Q25
SELECT
    p.PaymentID,
    p.OrderID,
    o.OrderDate,
    p.PaymentDate,
    DATEDIFF(DAY, o.OrderDate, p.PaymentDate) AS DaysAfterOrder
FROM Payments p
JOIN Orders o
    ON p.OrderID = o.OrderID;

-- Q26
SELECT
    PaymentID,
    PaymentDate,
    FORMAT(PaymentDate, 'dd-MMM-yyyy') AS FormattedPaymentDate
FROM Payments;

-- Q27
SELECT
    r.ReturnID,
    r.OrderDetailID,
    r.ReturnDate,
    o.OrderDate,
    DATEDIFF(DAY, o.OrderDate, r.ReturnDate) AS DaysToReturn,
    r.Reason,
    r.RefundAmount
FROM Returns r
JOIN OrderDetails od
    ON r.OrderDetailID = od.OrderDetailID
JOIN Orders o
    ON od.OrderID = o.OrderID
WHERE DATEDIFF(DAY, o.OrderDate, r.ReturnDate) <= 30;

-- Q28
WITH CustomerPayments AS
(
    SELECT
        o.CustomerID,
        SUM(p.Amount) AS TotalPayments
    FROM Orders o
    JOIN Payments p
        ON o.OrderID = p.OrderID
    GROUP BY o.CustomerID
)
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    cp.TotalPayments
FROM CustomerPayments cp
JOIN Customers c
    ON cp.CustomerID = c.CustomerID
WHERE cp.TotalPayments > 5000;

-- Q29
WITH ProductRefunds AS
(
    SELECT
        od.ProductID,
        SUM(r.RefundAmount) AS TotalRefunded
    FROM Returns r
    JOIN OrderDetails od
        ON r.OrderDetailID = od.OrderDetailID
    GROUP BY od.ProductID
)
SELECT
    p.ProductID,
    p.ProductName,
    COALESCE(pr.TotalRefunded, 0) AS TotalRefunded
FROM Products p
LEFT JOIN ProductRefunds pr
    ON p.ProductID = pr.ProductID;

-- Q30
WITH MonthlyPayments AS
(
    SELECT
        YEAR(PaymentDate) AS PaymentYear,
        MONTH(PaymentDate) AS PaymentMonth,
        SUM(Amount) AS TotalPayments
    FROM Payments
    GROUP BY YEAR(PaymentDate), MONTH(PaymentDate)
)
SELECT TOP 1
    PaymentYear,
    PaymentMonth,
    TotalPayments
FROM MonthlyPayments
ORDER BY TotalPayments;

-- Q31
WITH CustomerRevenue AS
(
    SELECT
        o.CustomerID,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalRevenue
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
),
CustomerRefunds AS
(
    SELECT
        o.CustomerID,
        SUM(r.RefundAmount) AS TotalRefunds
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    JOIN Returns r
        ON od.OrderDetailID = r.OrderDetailID
    GROUP BY o.CustomerID
)
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    COALESCE(cr.TotalRevenue, 0) AS TotalRevenue,
    COALESCE(cf.TotalRefunds, 0) AS TotalRefunds,
    COALESCE(cr.TotalRevenue, 0) - COALESCE(cf.TotalRefunds, 0) AS NetRevenue
FROM Customers c
LEFT JOIN CustomerRevenue cr
    ON c.CustomerID = cr.CustomerID
LEFT JOIN CustomerRefunds cf
    ON c.CustomerID = cf.CustomerID;

-- Q32
WITH CustomerAOV AS
(
    SELECT
        o.CustomerID,
        AVG(OrderTotals.OrderValue) AS AverageOrderValue
    FROM Orders o
    JOIN
    (
        SELECT
            OrderID,
            SUM(Quantity * UnitPrice * (1 - Discount)) AS OrderValue
        FROM OrderDetails
        GROUP BY OrderID
    ) OrderTotals
        ON o.OrderID = OrderTotals.OrderID
    GROUP BY o.CustomerID
)
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    ca.AverageOrderValue
FROM CustomerAOV ca
JOIN Customers c
    ON ca.CustomerID = c.CustomerID
WHERE ca.AverageOrderValue >
(
    SELECT AVG(AverageOrderValue)
    FROM CustomerAOV
);

-- Q33
SELECT
    o.CustomerID,
    o.OrderID,
    o.OrderDate,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS OrderRevenue,
    SUM(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))
    ) OVER (
        PARTITION BY o.CustomerID
    ) AS CustomerTotalRevenue
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY o.CustomerID, o.OrderID, o.OrderDate;

-- Q34
WITH RankedOrders AS
(
    SELECT
        o.*,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate DESC, OrderID DESC
        ) AS rn
    FROM Orders o
)
SELECT *
FROM RankedOrders
WHERE rn = 1;

-- Q35
WITH PaymentTotals AS
(
    SELECT
        PaymentMethod,
        SUM(Amount) AS TotalCollected
    FROM Payments
    GROUP BY PaymentMethod
)
SELECT
    PaymentMethod,
    TotalCollected,
    RANK() OVER (
        ORDER BY TotalCollected DESC
    ) AS PaymentMethodRank
FROM PaymentTotals;

-- Q36
WITH CustomerPayments AS
(
    SELECT
        p.PaymentID,
        o.CustomerID,
        p.PaymentDate,
        p.Amount,
        LAG(p.Amount) OVER (
            PARTITION BY o.CustomerID
            ORDER BY p.PaymentDate, p.PaymentID
        ) AS PreviousAmount
    FROM Payments p
    JOIN Orders o
        ON p.OrderID = o.OrderID
)
SELECT
    PaymentID,
    CustomerID,
    PaymentDate,
    Amount,
    PreviousAmount,
    CASE
        WHEN PreviousAmount IS NULL THEN 'First Payment'
        WHEN Amount > PreviousAmount THEN 'Increased'
        WHEN Amount < PreviousAmount THEN 'Decreased'
        ELSE 'No Change'
    END AS PaymentTrend
FROM CustomerPayments;

-- Q37
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    PERCENT_RANK() OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice
    ) AS PricePercentRank
FROM Products;

-- Q38
SELECT
    r.ReturnID,
    od.ProductID,
    p.ProductName,
    r.ReturnDate,
    r.Reason,
    COUNT(*) OVER (
        PARTITION BY od.ProductID
    ) AS ProductReturnCount
FROM Returns r
JOIN OrderDetails od
    ON r.OrderDetailID = od.OrderDetailID
JOIN Products p
    ON od.ProductID = p.ProductID;

-- Q39
CREATE TABLE Cart
(
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    DateAdded DATE NOT NULL DEFAULT GETDATE(),
    Quantity INT NOT NULL DEFAULT 1
        CHECK (Quantity > 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Cart (CustomerID, ProductID, Quantity)
VALUES
(1, 1, 2),
(2, 5, 1),
(3, 12, 3);

-- Q40
WITH RankedPayments AS
(
    SELECT
        p.PaymentID,
        o.CustomerID,
        p.OrderID,
        p.PaymentDate,
        p.Amount,
        ROW_NUMBER() OVER (
            PARTITION BY o.CustomerID
            ORDER BY p.Amount DESC
        ) AS rn
    FROM Payments p
    JOIN Orders o
        ON p.OrderID = o.OrderID
)
SELECT
    CustomerID,
    PaymentID,
    OrderID,
    PaymentDate,
    Amount
FROM RankedPayments
WHERE rn <= 2;

-- Q41
SELECT
    od.ProductID,
    p.ProductName,
    COUNT(*) AS ReturnCount
FROM Returns r
JOIN OrderDetails od
    ON r.OrderDetailID = od.OrderDetailID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY od.ProductID, p.ProductName
HAVING COUNT(*) >
(
    SELECT AVG(ReturnCount * 1.0)
    FROM
    (
        SELECT
            od2.ProductID,
            COUNT(*) AS ReturnCount
        FROM Returns r2
        JOIN OrderDetails od2
            ON r2.OrderDetailID = od2.OrderDetailID
        GROUP BY od2.ProductID
    ) x
);

-- Q42
WITH Revenue AS
(
    SELECT
        o.CustomerID,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalRevenue
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
),
Refunds AS
(
    SELECT
        o.CustomerID,
        SUM(r.RefundAmount) AS TotalRefunds
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    JOIN Returns r
        ON od.OrderDetailID = r.OrderDetailID
    GROUP BY o.CustomerID
)
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    COALESCE(rev.TotalRevenue, 0) AS TotalRevenue,
    COALESCE(ref.TotalRefunds, 0) AS TotalRefunds,
    COALESCE(rev.TotalRevenue, 0) - COALESCE(ref.TotalRefunds, 0) AS NetRevenue
FROM Customers c
LEFT JOIN Revenue rev
    ON c.CustomerID = rev.CustomerID
LEFT JOIN Refunds ref
    ON c.CustomerID = ref.CustomerID
WHERE COALESCE(rev.TotalRevenue, 0) - COALESCE(ref.TotalRefunds, 0) <= 0;

-- Q43
SELECT
    ReturnID,
    ReturnDate,
    RefundAmount,
    SUM(RefundAmount) OVER (
        ORDER BY ReturnDate, ReturnID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningRefundTotal
FROM Returns;

-- Q44
WITH PreviousOrders AS
(
    SELECT
        OrderID,
        CustomerID,
        OrderDate,
        LAG(OrderDate) OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate, OrderID
        ) AS PreviousOrderDate
    FROM Orders
)
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    PreviousOrderDate,
    DATEDIFF(DAY, PreviousOrderDate, OrderDate) AS DaysSincePreviousOrder,
    CASE
        WHEN PreviousOrderDate IS NULL THEN 'First Order'
        WHEN DATEDIFF(DAY, PreviousOrderDate, OrderDate) > 60
            THEN 'Inactive Period'
        ELSE 'Active Period'
    END AS CustomerActivity
FROM PreviousOrders;

-- Q45
WITH DateSpine AS
(
    SELECT MIN(OrderDate) AS CalendarDate
    FROM Orders

    UNION ALL

    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM DateSpine
    WHERE CalendarDate < (SELECT MAX(OrderDate) FROM Orders)
),
DailyOrders AS
(
    SELECT
        OrderDate,
        COUNT(*) AS OrderCount
    FROM Orders
    GROUP BY OrderDate
)
SELECT
    ds.CalendarDate,
    COALESCE(do.OrderCount, 0) AS OrderCount
FROM DateSpine ds
LEFT JOIN DailyOrders do
    ON ds.CalendarDate = do.OrderDate
ORDER BY ds.CalendarDate
OPTION (MAXRECURSION 0);

-- Q46
WITH ProductMethodRevenue AS
(
    SELECT
        p.PaymentMethod,
        od.ProductID,
        pr.ProductName,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS Revenue
    FROM Payments p
    JOIN OrderDetails od
        ON p.OrderID = od.OrderID
    JOIN Products pr
        ON od.ProductID = pr.ProductID
    GROUP BY p.PaymentMethod, od.ProductID, pr.ProductName
),
RankedProducts AS
(
    SELECT
        *,
        RANK() OVER (
            PARTITION BY PaymentMethod
            ORDER BY Revenue DESC
        ) AS ProductRank
    FROM ProductMethodRevenue
)
SELECT *
FROM RankedProducts
WHERE ProductRank = 1;

-- Q47
WITH CategoryRevenue AS
(
    SELECT
        c.CategoryID,
        c.CategoryName,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS Revenue
    FROM Categories c
    JOIN Products p
        ON c.CategoryID = p.CategoryID
    JOIN OrderDetails od
        ON p.ProductID = od.ProductID
    GROUP BY c.CategoryID, c.CategoryName
)
SELECT
    CategoryID,
    CategoryName,
    Revenue,
    ROUND(
        Revenue * 100.0 / SUM(Revenue) OVER (),
        2
    ) AS RevenuePercentage
FROM CategoryRevenue;

-- Q48
WITH ProductPrices AS
(
    SELECT
        ProductID,
        ProductName,
        UnitPrice,
        CUME_DIST() OVER (
            ORDER BY UnitPrice DESC
        ) AS PriceCumeDist
    FROM Products
)
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    PriceCumeDist
FROM ProductPrices
WHERE PriceCumeDist <= 0.10;

-- Q49
WITH CustomerMonths AS
(
    SELECT
        CustomerID,
        YEAR(OrderDate) AS OrderYear,
        MONTH(OrderDate) AS OrderMonth
    FROM Orders
    GROUP BY CustomerID, YEAR(OrderDate), MONTH(OrderDate)
)
SELECT
    CustomerID,
    COUNT(*) AS DifferentMonths
FROM CustomerMonths
GROUP BY CustomerID
HAVING COUNT(*) >= 3;

-- Q50
WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.OrderDate) AS OrderYear,
        MONTH(o.OrderDate) AS OrderMonth,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS Revenue
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
),
RevenueWithPrevious AS
(
    SELECT
        *,
        LAG(Revenue) OVER (
            ORDER BY OrderYear, OrderMonth
        ) AS PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT
    OrderYear,
    OrderMonth,
    Revenue,
    PreviousMonthRevenue,
    ROUND(
        (Revenue - PreviousMonthRevenue) * 100.0
        / NULLIF(PreviousMonthRevenue, 0),
        2
    ) AS MoMGrowthPercentage
FROM RevenueWithPrevious
ORDER BY OrderYear, OrderMonth;

-- Q51
WITH MonthlyRevenue AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(o.OrderDate),
            MONTH(o.OrderDate),
            1
        ) AS RevenueMonth,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS Revenue
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
),
SlidingRevenue AS
(
    SELECT
        RevenueMonth,
        Revenue,
        SUM(Revenue) OVER (
            ORDER BY RevenueMonth
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS ThreeMonthRevenue
    FROM MonthlyRevenue
)
SELECT TOP 1
    RevenueMonth,
    ThreeMonthRevenue
FROM SlidingRevenue
ORDER BY ThreeMonthRevenue DESC;

-- Q52
WITH CategorySales AS
(
    SELECT
        p.CategoryID,
        SUM(od.Quantity) AS TotalUnitsSold
    FROM Products p
    JOIN OrderDetails od
        ON p.ProductID = od.ProductID
    GROUP BY p.CategoryID
),
CategoryReturns AS
(
    SELECT
        p.CategoryID,
        SUM(od.Quantity) AS ReturnedUnits
    FROM Returns r
    JOIN OrderDetails od
        ON r.OrderDetailID = od.OrderDetailID
    JOIN Products p
        ON od.ProductID = p.ProductID
    GROUP BY p.CategoryID
)
SELECT
    c.CategoryName,
    cs.TotalUnitsSold,
    COALESCE(cr.ReturnedUnits, 0) AS ReturnedUnits,
    ROUND(
        COALESCE(cr.ReturnedUnits, 0) * 100.0
        / NULLIF(cs.TotalUnitsSold, 0),
        2
    ) AS ReturnRate
FROM Categories c
JOIN CategorySales cs
    ON c.CategoryID = cs.CategoryID
LEFT JOIN CategoryReturns cr
    ON c.CategoryID = cr.CategoryID
WHERE COALESCE(cr.ReturnedUnits, 0) * 100.0
    / NULLIF(cs.TotalUnitsSold, 0) > 10;

-- Q53
WITH RankedReturns AS
(
    SELECT
        r.ReturnID,
        od.ProductID,
        p.ProductName,
        r.ReturnDate,
        r.Reason,
        r.RefundAmount,
        ROW_NUMBER() OVER (
            PARTITION BY od.ProductID
            ORDER BY r.ReturnDate, r.ReturnID
        ) AS ReturnNumber
    FROM Returns r
    JOIN OrderDetails od
        ON r.OrderDetailID = od.OrderDetailID
    JOIN Products p
        ON od.ProductID = p.ProductID
)
SELECT
    ReturnID,
    ProductID,
    ProductName,
    ReturnDate,
    Reason,
    RefundAmount,
    CASE
        WHEN ReturnNumber = 1 THEN 'First Return'
        ELSE 'Repeat Return'
    END AS ReturnStatus
FROM RankedReturns;

-- Q54
SELECT
    o1.CustomerID,
    o1.OrderID AS Order1,
    o1.OrderDate AS Order1Date,
    o2.OrderID AS Order2,
    o2.OrderDate AS Order2Date,
    DATEDIFF(DAY, o1.OrderDate, o2.OrderDate) AS DaysBetween
FROM Orders o1
JOIN Orders o2
    ON o1.CustomerID = o2.CustomerID
    AND o1.OrderID < o2.OrderID
WHERE DATEDIFF(DAY, o1.OrderDate, o2.OrderDate) <= 7;

-- Q55
WITH OrderTotals AS
(
    SELECT
        OrderID,
        SUM(Quantity * UnitPrice * (1 - Discount)) AS OrderTotal
    FROM OrderDetails
    GROUP BY OrderID
),
PaymentTotals AS
(
    SELECT
        OrderID,
        SUM(Amount) AS PaidAmount
    FROM Payments
    GROUP BY OrderID
)
SELECT
    COALESCE(ot.OrderID, pt.OrderID) AS OrderID,
    COALESCE(ot.OrderTotal, 0) AS OrderTotal,
    COALESCE(pt.PaidAmount, 0) AS PaidAmount,
    COALESCE(pt.PaidAmount, 0) - COALESCE(ot.OrderTotal, 0) AS Difference,
    CASE
        WHEN COALESCE(ot.OrderTotal, 0) = COALESCE(pt.PaidAmount, 0)
            THEN 'Matched'
        ELSE 'Mismatch'
    END AS ReconciliationStatus
FROM OrderTotals ot
FULL OUTER JOIN PaymentTotals pt
    ON ot.OrderID = pt.OrderID
ORDER BY OrderID;

-- Q56
WITH CustomerSpend AS
(
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        COALESCE(
            SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)),
            0
        ) AS TotalSpend
    FROM Customers c
    LEFT JOIN Orders o
        ON c.CustomerID = o.CustomerID
    LEFT JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
),
TieredCustomers AS
(
    SELECT
        *,
        NTILE(3) OVER (
            ORDER BY TotalSpend DESC
        ) AS TierNumber
    FROM CustomerSpend
)
SELECT
    CustomerID,
    FirstName,
    LastName,
    TotalSpend,
    CASE TierNumber
        WHEN 1 THEN 'Gold'
        WHEN 2 THEN 'Silver'
        WHEN 3 THEN 'Bronze'
    END AS CustomerTier
FROM TieredCustomers;

-- Q57
WITH OrderValues AS
(
    SELECT
        o.OrderID,
        o.OrderDate,
        DATEPART(WEEKDAY, o.OrderDate) AS DayNumber,
        DATENAME(WEEKDAY, o.OrderDate) AS DayName,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS OrderValue
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY o.OrderID, o.OrderDate
),
DayAverages AS
(
    SELECT
        DayNumber,
        DayName,
        AVG(OrderValue) AS AverageOrderValue
    FROM OrderValues
    GROUP BY DayNumber, DayName
)
SELECT
    DayNumber,
    DayName,
    AverageOrderValue
FROM DayAverages
WHERE AverageOrderValue =
(
    SELECT MAX(AverageOrderValue)
    FROM DayAverages
);

-- Q58
WITH ProductMonthlyRevenue AS
(
    SELECT
        YEAR(o.OrderDate) AS OrderYear,
        MONTH(o.OrderDate) AS OrderMonth,
        od.ProductID,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS Revenue
    FROM Orders o
    JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    WHERE YEAR(o.OrderDate) = 2023
        AND MONTH(o.OrderDate) IN (1, 4)
    GROUP BY
        YEAR(o.OrderDate),
        MONTH(o.OrderDate),
        od.ProductID
),
JanuaryRanks AS
(
    SELECT
        ProductID,
        Revenue,
        RANK() OVER (
            ORDER BY Revenue DESC
        ) AS JanRank
    FROM ProductMonthlyRevenue
    WHERE OrderMonth = 1
),
AprilRanks AS
(
    SELECT
        ProductID,
        Revenue,
        RANK() OVER (
            ORDER BY Revenue DESC
        ) AS AprRank
    FROM ProductMonthlyRevenue
    WHERE OrderMonth = 4
)
SELECT
    p.ProductID,
    p.ProductName,
    jr.Revenue AS JanuaryRevenue,
    jr.JanRank,
    ar.Revenue AS AprilRevenue,
    ar.AprRank,
    COALESCE(jr.JanRank, 0) - COALESCE(ar.AprRank, 0) AS RankChange
FROM Products p
LEFT JOIN JanuaryRanks jr
    ON p.ProductID = jr.ProductID
LEFT JOIN AprilRanks ar
    ON p.ProductID = ar.ProductID
WHERE jr.ProductID IS NOT NULL
    OR ar.ProductID IS NOT NULL;

-- Q59
WITH SupplierRevenue AS
(
    SELECT
        s.SupplierID,
        s.SupplierName,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalRevenue
    FROM Suppliers s
    JOIN Products p
        ON s.SupplierID = p.SupplierID
    JOIN OrderDetails od
        ON p.ProductID = od.ProductID
    GROUP BY s.SupplierID, s.SupplierName
)
SELECT
    SupplierID,
    SupplierName,
    TotalRevenue
FROM SupplierRevenue
WHERE TotalRevenue > 5000;

-- Q60
SELECT
    o.OrderID,
    STRING_AGG(p.ProductName, ', ') AS Products
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
JOIN Products p
    ON od.ProductID = p.ProductID
GROUP BY o.OrderID;

-- Q61
WITH PaymentDuplicates AS
(
    SELECT
        p.PaymentID,
        o.CustomerID,
        p.PaymentDate,
        p.Amount,
        COUNT(*) OVER (
            PARTITION BY o.CustomerID, p.PaymentDate, p.Amount
        ) AS DuplicateCount
    FROM Payments p
    JOIN Orders o
        ON p.OrderID = o.OrderID
)
SELECT
    PaymentID,
    CustomerID,
    PaymentDate,
    Amount,
    DuplicateCount,
    CASE
        WHEN DuplicateCount > 1 THEN 'Potential Duplicate'
        ELSE 'Normal'
    END AS PaymentStatus
FROM PaymentDuplicates
WHERE DuplicateCount > 1;

-- Q62
CREATE TABLE OrderStatusHistory
(
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    ChangedDate DATE NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderStatusHistory
    (OrderID, OldStatus, NewStatus, ChangedDate)
VALUES
(1, 'Pending', 'Processing', '2023-01-05'),
(1, 'Processing', 'Shipped', '2023-01-06'),
(1, 'Shipped', 'Delivered', '2023-01-08'),
(2, 'Pending', 'Processing', '2023-01-12');

WITH StatusChanges AS
(
    SELECT
        HistoryID,
        OrderID,
        OldStatus,
        NewStatus,
        ChangedDate,
        LAG(ChangedDate) OVER (
            PARTITION BY OrderID
            ORDER BY ChangedDate, HistoryID
        ) AS PreviousChangedDate
    FROM OrderStatusHistory
)
SELECT
    HistoryID,
    OrderID,
    OldStatus,
    NewStatus,
    ChangedDate,
    DATEDIFF(
        DAY,
        PreviousChangedDate,
        ChangedDate
    ) AS DaysInPreviousStatus
FROM StatusChanges
ORDER BY OrderID, ChangedDate;

-- Q63
WITH CustomerSpend AS
(
    SELECT
        c.CustomerID,
        c.FirstName,
        c.LastName,
        c.State,
        COALESCE(
            SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)),
            0
        ) AS TotalSpend
    FROM Customers c
    LEFT JOIN Orders o
        ON c.CustomerID = o.CustomerID
    LEFT JOIN OrderDetails od
        ON o.OrderID = od.OrderID
    GROUP BY
        c.CustomerID,
        c.FirstName,
        c.LastName,
        c.State
)
SELECT
    CustomerID,
    FirstName,
    LastName,
    State,
    TotalSpend,
    RANK() OVER (
        ORDER BY TotalSpend DESC
    ) AS OverallRank,
    RANK() OVER (
        PARTITION BY State
        ORDER BY TotalSpend DESC
    ) AS StateRank
FROM CustomerSpend
ORDER BY OverallRank;

-- Q64
WITH CategoryQuarterRevenue AS
(
    SELECT
        c.CategoryID,
        c.CategoryName,
        DATEPART(QUARTER, o.OrderDate) AS QuarterNumber,
        SUM(
            od.Quantity *
            od.UnitPrice *
            (1 - od.Discount)
        ) AS Revenue
    FROM Categories c
    JOIN Products p
        ON c.CategoryID = p.CategoryID
    JOIN OrderDetails od
        ON p.ProductID = od.ProductID
    JOIN Orders o
        ON od.OrderID = o.OrderID
    GROUP BY
        c.CategoryID,
        c.CategoryName,
        DATEPART(QUARTER, o.OrderDate)
)
SELECT
    CategoryID,
    CategoryName,
    COALESCE(SUM(CASE WHEN QuarterNumber = 1 THEN Revenue END), 0) AS Q1,
    COALESCE(SUM(CASE WHEN QuarterNumber = 2 THEN Revenue END), 0) AS Q2,
    COALESCE(SUM(CASE WHEN QuarterNumber = 3 THEN Revenue END), 0) AS Q3,
    COALESCE(SUM(CASE WHEN QuarterNumber = 4 THEN Revenue END), 0) AS Q4
FROM CategoryQuarterRevenue
GROUP BY CategoryID, CategoryName
ORDER BY CategoryID;