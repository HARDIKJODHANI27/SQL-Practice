-- Q1
SELECT
    'DATE' AS RecommendedDataType,
    'OrderDate stores only the calendar date, so DATE is sufficient and DATETIME is unnecessary.' AS Reason;


-- Q2
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employees'
  AND COLUMN_NAME = 'Salary';


-- Q3
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    ReviewText VARCHAR(500),
    ReviewDate DATE DEFAULT GETDATE()
);


-- Q4
SELECT
    'CHAR' AS DataType,
    'Fixed-length character data. Best when values have a consistent length.' AS Usage
UNION ALL
SELECT
    'VARCHAR',
    'Variable-length character data. Best for most strings whose length varies.'
UNION ALL
SELECT
    'TEXT',
    'Legacy large text data type. VARCHAR(MAX) is preferred in modern SQL Server.';


-- Q5
SELECT
    'Orders' AS TableName,
    'OrderID' AS PrimaryKey,
    'CustomerID, EmployeeID' AS ForeignKeys
UNION ALL
SELECT
    'Employees',
    'EmployeeID',
    'DepartmentID, ManagerID'
UNION ALL
SELECT
    'Employees.ManagerID',
    NULL,
    'Self-referencing foreign key because it references Employees.EmployeeID in the same table.';


-- Q6
ALTER TABLE Employees
ADD CONSTRAINT UQ_Employees_Phone UNIQUE (Phone);


-- Q7
CREATE TABLE Wishlist (
    CustomerID INT,
    ProductID INT,
    DateAdded DATE DEFAULT GETDATE(),
    CONSTRAINT PK_Wishlist PRIMARY KEY (CustomerID, ProductID),
    CONSTRAINT FK_Wishlist_Customer
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Wishlist_Product
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- Q8
CREATE TABLE Coupons (
    CouponCode VARCHAR(10) PRIMARY KEY,
    DiscountPercent DECIMAL(4,2),
    ExpiryDate DATE,
    IsActive BIT DEFAULT 1
);


-- Q9
INSERT INTO Departments (DepartmentName, Location)
VALUES ('Customer Support', 'Pune');


-- Q10
INSERT INTO Customers
    (FirstName, LastName, Email, City, State, Country)
VALUES
    ('Tanya', 'Bhatt', 'tanya.bhatt@gmail.com', 'Jaipur', 'Rajasthan', 'India');


-- Q11
INSERT INTO Products
    (ProductName, CategoryID, SupplierID, UnitPrice, StockQuantity)
VALUES
    ('Premium Notebook', 5, 5, 299, 100),
    ('Blue Ball Pen Pack', 5, 5, 129, 200),
    ('A4 Drawing Sheets', 5, 5, 249, 150);


-- Q12
SELECT *
FROM Products
WHERE UnitPrice > 1000;


-- Q13
SELECT *
FROM Customers
WHERE City IN ('Kolkata', 'Hyderabad');


-- Q14
SELECT *
FROM Orders
WHERE OrderDate BETWEEN '2023-03-01' AND '2023-06-30';


-- Q15
SELECT *
FROM Employees
WHERE JobTitle LIKE '%Manager%';


-- Q16
SELECT *
FROM Orders
WHERE ShipDate IS NULL;


-- Q17
UPDATE Employees
SET Salary = Salary * 1.10
WHERE DepartmentID = (
    SELECT DepartmentID
    FROM Departments
    WHERE DepartmentName = 'IT'
);


-- Q18
UPDATE Orders
SET
    Status = 'Shipped',
    ShipDate = '2023-03-26'
WHERE OrderID = 9;


-- Q19
UPDATE Products
SET StockQuantity = StockQuantity - 10
WHERE ProductName = 'Wireless Mouse';


-- Q20
DELETE FROM OrderDetails
WHERE OrderID IN (
    SELECT OrderID
    FROM Orders
    WHERE Status = 'Cancelled'
);

-- Q21
DELETE FROM Customers
WHERE FirstName = 'Wei'
  AND LastName = 'Zhang'
  AND NOT EXISTS (
      SELECT 1
      FROM Orders
      WHERE Orders.CustomerID = Customers.CustomerID
  );


-- Q22
SELECT COUNT(*) AS TotalProducts
FROM Products;


-- Q23
SELECT ROUND(AVG(UnitPrice), 2) AS AverageUnitPrice
FROM Products;


-- Q24
SELECT
    MAX(Salary) AS MaximumSalary,
    MIN(Salary) AS MinimumSalary
FROM Employees;


-- Q25
SELECT SUM(Quantity) AS TotalQuantitySold
FROM OrderDetails;


-- Q26
SELECT COUNT(DISTINCT CustomerID) AS DistinctCustomersWithOrders
FROM Orders
WHERE CustomerID IS NOT NULL;


-- Q27
SELECT
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID;


-- Q28
SELECT
    CategoryID,
    SUM(UnitPrice) AS TotalUnitPrice
FROM Products
GROUP BY CategoryID;


-- Q29
SELECT
    ProductID,
    SUM(Quantity) AS TotalQuantitySold
FROM OrderDetails
GROUP BY ProductID;


-- Q30
SELECT
    CustomerID,
    COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID;


-- Q31
SELECT
    DepartmentID,
    COUNT(*) AS EmployeeCount
FROM Employees
GROUP BY DepartmentID
HAVING COUNT(*) > 2;


-- Q32
SELECT
    ProductID,
    SUM(Quantity) AS TotalOrderedQuantity
FROM OrderDetails
GROUP BY ProductID
HAVING SUM(Quantity) > 5;


-- Q33
SELECT
    CustomerID,
    COUNT(*) AS OrderCount
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*) > 1;


-- Q34
SELECT
    o.OrderID,
    o.OrderDate,
    o.ShipDate,
    o.Status,
    c.FirstName,
    c.LastName
FROM Orders AS o
INNER JOIN Customers AS c
    ON o.CustomerID = c.CustomerID;


-- Q35
SELECT
    p.ProductID,
    p.ProductName,
    p.UnitPrice,
    c.CategoryName
FROM Products AS p
INNER JOIN Categories AS c
    ON p.CategoryID = c.CategoryID;


-- Q36
SELECT
    od.OrderDetailID,
    od.OrderID,
    od.ProductID,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.Discount,
    o.OrderDate
FROM OrderDetails AS od
INNER JOIN Products AS p
    ON od.ProductID = p.ProductID
INNER JOIN Orders AS o
    ON od.OrderID = o.OrderID;


-- Q37
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    d.DepartmentName
FROM Employees AS e
INNER JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID;


-- Q38
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate,
    o.Status
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID;


-- Q39
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.JobTitle,
    d.DepartmentName
FROM Employees AS e
LEFT JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID;


-- Q40
SELECT
    p.ProductID,
    p.ProductName,
    COALESCE(SUM(od.Quantity), 0) AS TotalQuantityOrdered
FROM Products AS p
LEFT JOIN OrderDetails AS od
    ON p.ProductID = od.ProductID
GROUP BY
    p.ProductID,
    p.ProductName;

-- Q41
SELECT
    d.DepartmentID,
    d.DepartmentName,
    e.EmployeeID,
    e.FirstName,
    e.LastName
FROM Employees AS e
RIGHT JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID;


-- Q42
SELECT
    c.CategoryID,
    c.CategoryName,
    p.ProductID,
    p.ProductName
FROM Products AS p
RIGHT JOIN Categories AS c
    ON p.CategoryID = c.CategoryID;


-- Q43
SELECT
    d.DepartmentID,
    d.DepartmentName,
    c.CategoryID,
    c.CategoryName
FROM Departments AS d
CROSS JOIN Categories AS c;


-- Q44
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    p.ProductID,
    p.ProductName
FROM Employees AS e
CROSS JOIN Products AS p
WHERE e.DepartmentID = (
    SELECT DepartmentID
    FROM Departments
    WHERE DepartmentName = 'IT'
)
AND p.CategoryID = (
    SELECT CategoryID
    FROM Categories
    WHERE CategoryName = 'Electronics'
);


-- Q45
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate,
    o.Status
FROM Customers AS c
FULL OUTER JOIN Orders AS o
    ON c.CustomerID = o.CustomerID;


-- Q46
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    o.OrderID,
    o.OrderDate,
    o.Status
FROM Employees AS e
FULL OUTER JOIN Orders AS o
    ON e.EmployeeID = o.EmployeeID;


-- Q47
SELECT
    CustomerID,
    CONCAT(LastName, ', ', FirstName) AS FullName
FROM Customers;


-- Q48
SELECT
    ProductID,
    UPPER(ProductName) AS ProductNameUpper
FROM Products;


-- Q49
SELECT
    CustomerID,
    Email,
    LEN(Email) AS EmailLength
FROM Customers;


-- Q50
SELECT
    ProductID,
    ProductName,
    LEFT(ProductName, 3) AS FirstThreeCharacters
FROM Products;


-- Q51
SELECT
    OrderID,
    OrderDate,
    YEAR(OrderDate) AS OrderYear
FROM Orders;


-- Q52
SELECT
    OrderID,
    OrderDate,
    ShipDate,
    DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM Orders;


-- Q53
GO

CREATE VIEW vw_CustomerOrderSummary
AS
SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS FullCustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    COALESCE(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)),
        0
    ) AS TotalAmountSpent
FROM Customers AS c
LEFT JOIN Orders AS o
    ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
    ON o.OrderID = od.OrderID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName;
GO


-- Q54
CREATE VIEW vw_ProductSales
AS
SELECT
    p.ProductID,
    p.ProductName,
    c.CategoryName,
    COALESCE(SUM(od.Quantity), 0) AS TotalQuantitySold,
    COALESCE(
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)),
        0
    ) AS TotalRevenue
FROM Products AS p
LEFT JOIN Categories AS c
    ON p.CategoryID = c.CategoryID
LEFT JOIN OrderDetails AS od
    ON p.ProductID = od.ProductID
GROUP BY
    p.ProductID,
    p.ProductName,
    c.CategoryName;
GO


-- Q55
SELECT TOP 5
    ProductID,
    ProductName,
    CategoryName,
    TotalQuantitySold,
    TotalRevenue
FROM vw_ProductSales
ORDER BY TotalRevenue DESC;

-- Q56
WITH DeptEmpCount AS (
    SELECT
        DepartmentID,
        COUNT(*) AS EmployeeCount
    FROM Employees
    GROUP BY DepartmentID
)
SELECT
    DepartmentID,
    EmployeeCount
FROM DeptEmpCount
WHERE EmployeeCount > 2;


-- Q57
WITH CustomerSpend AS (
    SELECT
        o.CustomerID,
        SUM(
            od.Quantity * od.UnitPrice * (1 - od.Discount)
        ) AS TotalSpend
    FROM Orders AS o
    INNER JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
)
SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    cs.TotalSpend
FROM Customers AS c
INNER JOIN CustomerSpend AS cs
    ON c.CustomerID = cs.CustomerID
WHERE cs.TotalSpend > 5000;


-- Q58
WITH MonthlyRevenue AS (
    SELECT
        YEAR(o.OrderDate) AS OrderYear,
        MONTH(o.OrderDate) AS OrderMonth,
        SUM(
            od.Quantity * od.UnitPrice * (1 - od.Discount)
        ) AS TotalRevenue
    FROM Orders AS o
    INNER JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    GROUP BY
        YEAR(o.OrderDate),
        MONTH(o.OrderDate)
),
RankedMonths AS (
    SELECT
        OrderYear,
        OrderMonth,
        TotalRevenue,
        RANK() OVER (
            ORDER BY TotalRevenue DESC
        ) AS RevenueRank
    FROM MonthlyRevenue
)
SELECT
    OrderYear,
    OrderMonth,
    TotalRevenue,
    RevenueRank
FROM RankedMonths
WHERE RevenueRank <= 3
ORDER BY RevenueRank, OrderYear, OrderMonth;


-- Q59
WITH RankedProducts AS (
    SELECT
        ProductID,
        ProductName,
        CategoryID,
        UnitPrice,
        DENSE_RANK() OVER (
            PARTITION BY CategoryID
            ORDER BY UnitPrice DESC
        ) AS PriceRank
    FROM Products
)
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice
FROM RankedProducts
WHERE PriceRank = 2;


-- Q60
SELECT
    EmployeeID,
    FirstName,
    LastName,
    DepartmentID,
    Salary,
    ROW_NUMBER() OVER (
        PARTITION BY DepartmentID
        ORDER BY Salary DESC
    ) AS DepartmentSalaryRank
FROM Employees;


-- Q61
SELECT
    ProductID,
    ProductName,
    CategoryID,
    UnitPrice,
    RANK() OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice DESC
    ) AS PriceRank,
    DENSE_RANK() OVER (
        PARTITION BY CategoryID
        ORDER BY UnitPrice DESC
    ) AS DensePriceRank
FROM Products;


-- Q62
SELECT
    CustomerID,
    OrderID,
    OrderDate,
    LAG(OrderDate) OVER (
        PARTITION BY CustomerID
        ORDER BY OrderDate
    ) AS PreviousOrderDate
FROM Orders
ORDER BY CustomerID, OrderDate;


-- Q63
SELECT
    EmployeeID,
    FirstName,
    LastName,
    HireDate,
    LEAD(HireDate) OVER (
        ORDER BY HireDate
    ) AS NextEmployeeHireDate
FROM Employees
ORDER BY HireDate;


-- Q64
SELECT
    ProductID,
    ProductName,
    UnitPrice,
    NTILE(4) OVER (
        ORDER BY UnitPrice
    ) AS PriceQuartile
FROM Products
ORDER BY UnitPrice;


-- Q65
SELECT City
FROM Customers
WHERE City IS NOT NULL

UNION

SELECT City
FROM Suppliers
WHERE City IS NOT NULL;


-- Q66
SELECT
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS CustomerName,
    'High Value' AS CustomerType
FROM Customers
WHERE CustomerID IN (
    SELECT o.CustomerID
    FROM Orders AS o
    INNER JOIN OrderDetails AS od
        ON o.OrderID = od.OrderID
    GROUP BY o.CustomerID
    HAVING SUM(
        od.Quantity * od.UnitPrice * (1 - od.Discount)
    ) > 5000
)

UNION ALL

SELECT
    CustomerID,
    CONCAT(FirstName, ' ', LastName) AS CustomerName,
    'Frequent' AS CustomerType
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    GROUP BY CustomerID
    HAVING COUNT(*) > 2
);


-- Q67
SELECT
    'UNION removes duplicate rows and therefore requires duplicate elimination.' AS UNION_Explanation,
    'UNION ALL keeps duplicate rows and generally avoids the extra duplicate-elimination operation.' AS UNION_ALL_Explanation;


-- Q68
CREATE TABLE #ProductPriceUpdates (
    ProductID INT,
    NewPrice DECIMAL(10,2)
);

INSERT INTO #ProductPriceUpdates (ProductID, NewPrice)
VALUES
    (1, 649.00),
    (2, 2099.00);

MERGE Products AS Target
USING #ProductPriceUpdates AS Source
    ON Target.ProductID = Source.ProductID
WHEN MATCHED THEN
    UPDATE SET Target.UnitPrice = Source.NewPrice;

DROP TABLE #ProductPriceUpdates;


-- Q69
CREATE TABLE OrderAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ChangeType VARCHAR(20),
    ChangeDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE #StockCount (
    ProductID INT,
    CountedQty INT
);

INSERT INTO #StockCount (ProductID, CountedQty)
VALUES
    (1, 140),
    (2, 75),
    (3, 190);

MERGE Products AS Target
USING #StockCount AS Source
    ON Target.ProductID = Source.ProductID
WHEN MATCHED AND Target.StockQuantity <> Source.CountedQty THEN
    UPDATE SET Target.StockQuantity = Source.CountedQty
OUTPUT
    inserted.ProductID,
    $action
INTO OrderAudit (ProductID, ChangeType);

DROP TABLE #StockCount;


-- Q70
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID
ON Orders(CustomerID);


-- Q71
CREATE UNIQUE INDEX IX_Customers_Email
ON Customers(Email);


-- Q72
SELECT
    'Clustered Index' AS IndexType,
    'The table data is physically organized according to the clustered index key. The Employees primary key normally creates a clustered index by default.' AS Description
UNION ALL
SELECT
    'Non-Clustered Index',
    'A separate index structure stores the indexed values and references the underlying table rows.';


-- Q73
BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO Orders
        (CustomerID, EmployeeID, OrderDate, ShipDate, Status)
    VALUES
        (1, 2, GETDATE(), NULL, 'Pending');

    DECLARE @NewOrderID INT = SCOPE_IDENTITY();

    INSERT INTO OrderDetails
        (OrderID, ProductID, Quantity, UnitPrice, Discount)
    VALUES
        (@NewOrderID, 1, 2, 599, 0);

    INSERT INTO OrderDetails
        (OrderID, ProductID, Quantity, UnitPrice, Discount)
    VALUES
        (@NewOrderID, 3, 1, 799, 0);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;


-- Q74
BEGIN TRANSACTION;

INSERT INTO Customers
    (FirstName, LastName, Email, City, State, Country)
VALUES
    ('Savepoint', 'Customer', 'savepoint.customer@gmail.com', 'Pune', 'Maharashtra', 'India');

DECLARE @NewCustomerID INT = SCOPE_IDENTITY();

SAVE TRANSACTION CustomerSavepoint;

INSERT INTO Orders
    (CustomerID, EmployeeID, OrderDate, ShipDate, Status)
VALUES
    (@NewCustomerID, 2, GETDATE(), NULL, 'Pending');

ROLLBACK TRANSACTION CustomerSavepoint;

COMMIT TRANSACTION;


-- Q75
SELECT
    'COMMIT' AS TransactionAction,
    'Makes all changes in the transaction permanent and releases the transaction locks.' AS Effect
UNION ALL
SELECT
    'ROLLBACK',
    'Undoes the transaction changes and releases the transaction locks. The transaction log records the changes and supports recovery and rollback.';

-- Q76
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET ARITHABORT ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE VIEW dbo.vw_CategoryRevenue
WITH SCHEMABINDING
AS
SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(
        od.Quantity * od.UnitPrice *
        (1.00 - ISNULL(od.Discount, 0.00))
    ) AS TotalRevenue,
    COUNT_BIG(*) AS TotalRows
FROM dbo.Categories AS c
INNER JOIN dbo.Products AS p
    ON c.CategoryID = p.CategoryID
INNER JOIN dbo.OrderDetails AS od
    ON p.ProductID = od.ProductID
GROUP BY
    c.CategoryID,
    c.CategoryName;
GO

CREATE UNIQUE CLUSTERED INDEX IX_vw_CategoryRevenue
ON dbo.vw_CategoryRevenue(CategoryID);
GO


-- Q77
SELECT
    'SCHEMABINDING' AS Restriction,
    'The view must be created with WITH SCHEMABINDING and referenced tables must use two-part names.' AS Explanation
UNION ALL
SELECT
    'GROUP BY requirements',
    'If GROUP BY is used, the indexed view must contain COUNT_BIG(*) and cannot contain HAVING.';


-- Q78
TRUNCATE TABLE Reviews;


-- Q79
SELECT
    'DROP TABLE' AS Command,
    'Removes the table definition and all its data. The table no longer exists.' AS Effect
UNION ALL
SELECT
    'TRUNCATE TABLE',
    'Removes all rows while keeping the table structure. The identity counter is reset to its seed value.';


-- Q80
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    SUM(
        od.Quantity * od.UnitPrice * (1 - od.Discount)
    ) AS TotalRevenue
FROM Employees AS e
INNER JOIN Orders AS o
    ON e.EmployeeID = o.EmployeeID
INNER JOIN OrderDetails AS od
    ON o.OrderID = od.OrderID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY TotalRevenue DESC;