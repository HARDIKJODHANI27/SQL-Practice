IF DB_ID('RetailAnalyticsDB') IS NULL
    CREATE DATABASE RetailAnalyticsDB;

USE RealAnalyticsDB;

-- Departments Table
CREATE TABLE Departments (
DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
DepartmentName VARCHAR(50) NOT NULL UNIQUE,
Location VARCHAR(50)
);

-- Employees Table
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

-- Customers Table
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


-- Categories Table
CREATE TABLE Categories (
CategoryID INT IDENTITY(1,1) PRIMARY KEY,
CategoryName VARCHAR(50) NOT NULL UNIQUE
);


-- Suppliers Table
CREATE TABLE Suppliers (
SupplierID INT IDENTITY(1,1) PRIMARY KEY,
SupplierName VARCHAR(100) NOT NULL,
City VARCHAR(50),
Country VARCHAR(50),
ContactEmail VARCHAR(100)
);


--Products Table
CREATE TABLE Products (
ProductID INT IDENTITY(1,1) PRIMARY KEY,
ProductName VARCHAR(100) NOT NULL,
CategoryID INT NULL REFERENCES Categories(CategoryID),
SupplierID INT NULL REFERENCES Suppliers(SupplierID),
UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0),
StockQuantity INT DEFAULT 0
);


-- Orders Table
CREATE TABLE Orders (
OrderID INT IDENTITY(1,1) PRIMARY KEY,
CustomerID INT NULL REFERENCES Customers(CustomerID),
EmployeeID INT NULL REFERENCES Employees(EmployeeID),
OrderDate DATE NOT NULL,
ShipDate DATE NULL,
Status VARCHAR(20) DEFAULT 'Pending'
);



CREATE TABLE OrderDetails (
OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
OrderID INT NOT NULL REFERENCES Orders(OrderID),
ProductID INT NOT NULL REFERENCES Products(ProductID),
Quantity INT NOT NULL CHECK (Quantity > 0),
UnitPrice DECIMAL(10,2) NOT NULL,
Discount DECIMAL(4,2) DEFAULT 0
);


-- Payments Table
CREATE TABLE Payments (
 PaymentID INT IDENTITY(1,1) PRIMARY KEY,
 OrderID INT NOT NULL REFERENCES Orders(OrderID),
 PaymentDate DATE NOT NULL,
 Amount DECIMAL(10,2) NOT NULL,
 PaymentMethod VARCHAR(20) NOT NULL
);


-- Returns Table
CREATE TABLE Returns (
 ReturnID INT IDENTITY(1,1) PRIMARY KEY,
 OrderDetailID INT NOT NULL REFERENCES OrderDetails(OrderDetailID),
 ReturnDate DATE NOT NULL,
 Reason VARCHAR(100),
 RefundAmount DECIMAL(10,2)
);



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
