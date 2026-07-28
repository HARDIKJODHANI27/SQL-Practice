--Question 2
SELECT segment,
    COUNT(*) AS total_customers
FROM Customers
GROUP BY segment;


--Question 3

SELECT customer_id,
    customer_name,
    credit_limit
FROM Customers
WHERE credit_limit > 500000;


--Question 4

SELECT region,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY region;


--Question 5

SELECT TOP 5
    customer_id,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY customer_id
ORDER BY total_orders DESC;


--Question 6

SELECT od.order_id,
    SUM(
        p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
    ) AS Revenue
FROM Order_Details od
    JOIN Products p ON od.product_id = p.product_id
GROUP BY od.order_id;


--Question 7

SELECT p.product_id,
    SUM(
        (
            (
                p.selling_price *(1 - od.discount_percent / 100.0)
            ) - p.cost_price
        ) * od.quantity
    ) AS GrossProfit
FROM Products p
    JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id;


--Question 8

SELECT p.product_id,
    ROUND(
        SUM(
            (
                (
                    p.selling_price *(1 - od.discount_percent / 100.0)
                ) - p.cost_price
            ) * od.quantity
        ) / SUM(
            p.selling_price *(1 - od.discount_percent / 100.0) * od.quantity
        ) * 100,
        2
    ) AS MarginPercent
FROM Products p
    JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id;


-- Question 9

SELECT TOP 1
    p.product_id,
    SUM(
        p.selling_price * od.quantity *
        (1 - od.discount_percent / 100.0)
    ) AS Revenue
FROM Products p
JOIN Order_Details od
    ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY Revenue DESC;


-- Question 10

SELECT TOP 1
    p.product_id,
    ROUND(
        SUM(
            (
                (p.selling_price * (1 - od.discount_percent / 100.0))
                - p.cost_price
            ) * od.quantity
        )
        /
        SUM(
            (p.selling_price * (1 - od.discount_percent / 100.0))
            * od.quantity
        )
        * 100,
        2
    ) AS MarginPercent
FROM Products p
JOIN Order_Details od
ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY MarginPercent;


--Question 11

SELECT o.region,
    SUM(
        p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
    ) Revenue
FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
GROUP BY o.region;


--Question 12

SELECT o.channel,
    SUM(
        p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
    ) Revenue
FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
GROUP BY o.channel;


--Question 13

SELECT DATE_FORMAT(o.order_date, '%Y-%m') Month,
    SUM(
        p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
    ) Revenue
FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
GROUP BY Month
ORDER BY Month;


--Question 14

SELECT *
FROM Order_Details
WHERE discount_percent > 15;


--Question 15

SELECT od.order_id,
    od.product_id
FROM Order_Details od
    JOIN Products p ON od.product_id = p.product_id
WHERE (
        (
            p.selling_price *(1 - od.discount_percent / 100.0)
        ) - p.cost_price
    ) < 0;


--Question 16

SELECT r.order_id,
    r.revenue,
    IFNULL(p.payment_amount, 0) Payment,
    r.revenue - IFNULL(p.payment_amount, 0) Outstanding
FROM (
        SELECT od.order_id,
            SUM(
                pr.selling_price * quantity * (1 - discount_percent / 100.0)
            ) revenue
        FROM Order_Details od
            JOIN Products pr ON od.product_id = pr.product_id
        GROUP BY od.order_id
    ) r
    LEFT JOIN Payments p ON r.order_id = p.order_id;


--Question 17

SELECT o.order_id
FROM Orders o
    LEFT JOIN Payments p ON o.order_id = p.order_id
WHERE p.order_id IS NULL;


-- Question 18

SELECT
    c.customer_id,
    c.customer_name,
    c.credit_limit,
    SUM((pr.selling_price * od.quantity * (1 - od.discount_percent / 100.0))
        - ISNULL(p.payment_amount, 0)) AS Outstanding
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
JOIN Order_Details od
    ON o.order_id = od.order_id
JOIN Products pr
    ON od.product_id = pr.product_id
LEFT JOIN Payments p
    ON o.order_id = p.order_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.credit_limit
HAVING SUM((pr.selling_price * od.quantity * (1 - od.discount_percent / 100.0))
           - ISNULL(p.payment_amount, 0))
       > 0.8 * c.credit_limit;


--Question 19

SELECT payment_id,
    order_id,
    DATEDIFF(payment_date, order_date) DelayDays
FROM Payments p
    JOIN Orders o ON p.order_id = o.order_id
WHERE DATEDIFF(payment_date, order_date) > 30;


--Question 20

SELECT payment_id,
    order_id,
    DATEDIFF(payment_date, order_date) DelayDays
FROM Payments p
    JOIN Orders o ON p.order_id = o.order_id
WHERE DATEDIFF(payment_date, order_date) > 60;


--Question 21

SELECT
    region,
    customer_id,
    Revenue,
    RANK() OVER(
        PARTITION BY region
        ORDER BY Revenue DESC
    ) AS RankNo
FROM Sales;


--Question 22

SELECT *
FROM (
    SELECT
        region,
        customer_id,
        Revenue,
        RANK() OVER(
            PARTITION BY region
            ORDER BY Revenue DESC
        ) AS rnk
    FROM Sales
) x
WHERE rnk = 2;


--Question 23
SELECT
    region,
    order_date,
    Revenue,
    SUM(Revenue) OVER (
        PARTITION BY region
        ORDER BY order_date
    ) AS RunningTotal
FROM Sales;


--Question 24

SELECT
    category,
    SUM(Revenue) * 100.0 /
    SUM(SUM(Revenue)) OVER () AS ContributionPercent
FROM Sales
GROUP BY category;


--Question 25

SELECT *
FROM (
    SELECT
        category,
        product_id,
        Revenue,
        RANK() OVER (
            PARTITION BY category
            ORDER BY Revenue DESC
        ) AS rnk
    FROM Sales
) x
WHERE rnk <= 3;

--Question 26

SELECT
    o.channel,
    AVG(od.discount_percent) AS AvgDiscount
FROM Orders AS o
JOIN Order_Details AS od
    ON o.order_id = od.order_id
GROUP BY o.channel;

--Question 27

SELECT
    order_id,
    COUNT(*) AS OrderCount,
    SUM(selling_price * quantity * (1 - discount_percent / 100.0)) AS Revenue
FROM Order_Details
GROUP BY order_id;


--Question 28

SELECT order_id,
    payment_date,
    payment_amount,
    COUNT(*) DuplicateCount
FROM Payments
GROUP BY order_id,
    payment_date,
    payment_amount
HAVING COUNT(*) > 1;


-- Question 29

SELECT c.customer_id,
    c.customer_name
FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Question 30

SELECT o.region,
    SUM(
        (
            (
                p.selling_price * (1 - od.discount_percent / 100.0)
            ) - p.cost_price
        ) * od.quantity
    ) AS TotalProfit
FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
GROUP BY o.region
ORDER BY TotalProfit DESC;


-- Question 31

SELECT p.payment_id,
    p.order_id,
    DATEDIFF(DAY, o.order_date, p.payment_date) AS DaysTaken,
    CASE
        WHEN DATEDIFF(DAY, o.order_date, p.payment_date) <= 30 THEN '0-30'
        WHEN DATEDIFF(DAY, o.order_date, p.payment_date) <= 60 THEN '31-60'
        WHEN DATEDIFF(DAY, o.order_date, p.payment_date) <= 90 THEN '61-90'
        ELSE '90+'
    END AS AgingBucket
FROM Payments p
    JOIN Orders o ON p.order_id = o.order_id;


-- Question 32

WITH Revenue AS (
    SELECT o.order_id,
        o.region,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.order_id,
        o.region
)
SELECT r.order_id,
    r.region,
    r.Revenue,
    a.allocation_percent,
    r.Revenue * a.allocation_percent / 100.0 AS AllocatedRevenue
FROM Revenue r
    JOIN Allocation_Rules a ON r.region = a.region;


-- Question 33

WITH Revenue AS (
    SELECT o.order_id,
        o.region,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.order_id,
        o.region
)
SELECT r.order_id,
    Revenue,
    allocation_percent,
    Revenue - (Revenue * allocation_percent / 100.0) AS AdjustedRevenue
FROM Revenue r
    JOIN Allocation_Rules a ON r.region = a.region;


-- Question 34

SELECT c.segment,
    SUM(
        (
            (
                p.selling_price * (1 - od.discount_percent / 100.0)
            ) - p.cost_price
        ) * od.quantity
    ) AS Profit
FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Order_Details od ON o.order_id = od.order_id
    JOIN Products p ON od.product_id = p.product_id
GROUP BY c.segment;


-- Question 35

WITH Revenue AS (
    SELECT o.order_id,
        o.customer_id,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.order_id,
        o.customer_id
)
SELECT c.segment,
    AVG(r.Revenue) AS AvgOrderValue
FROM Revenue r
    JOIN Customers c ON r.customer_id = c.customer_id
GROUP BY c.segment;


-- Question 36

WITH Revenue AS (
    SELECT o.order_id,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.order_id
)
SELECT *
FROM Revenue
WHERE Revenue > (
        SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (
                ORDER BY Revenue
            ) OVER ()
    );


-- Question 37

WITH MonthlyRevenue AS (
    SELECT FORMAT(o.order_date, 'yyyy-MM') AS Month,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY FORMAT(o.order_date, 'yyyy-MM')
)
SELECT Month,
    Revenue,
    Revenue - LAG(Revenue) OVER(
        ORDER BY Month
    ) AS RevenueVariance
FROM MonthlyRevenue;


-- Question 38

SELECT FORMAT(MIN(order_date), 'yyyy-MM') AS AcquisitionMonth,
    COUNT(customer_id) AS Customers
FROM Orders
GROUP BY customer_id
ORDER BY AcquisitionMonth;


-- Question 39

SELECT 100.0 * COUNT(
        CASE
            WHEN OrderCount > 1 THEN 1
        END
    ) / COUNT(*) AS RepeatPurchaseRate
FROM (
        SELECT customer_id,
            COUNT(*) AS OrderCount
        FROM Orders
        GROUP BY customer_id
    ) x;


-- Question 40

WITH Revenue AS (
    SELECT o.channel,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.channel
)
SELECT channel,
    Revenue,
    Revenue * 100.0 / SUM(Revenue) OVER() AS ContributionPercent
FROM Revenue;


-- Question 41

WITH Revenue AS (
    SELECT o.region,
        p.category,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.region,
        p.category
)
SELECT region,
    category,
    Revenue,
    Revenue * 100.0 / SUM(Revenue) OVER(PARTITION BY region) AS CategoryPercent
FROM Revenue;


-- Question 42

WITH CustomerRevenue AS (
    SELECT o.customer_id,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.customer_id
)
SELECT *
FROM (
        SELECT *,
            NTILE(10) OVER(
                ORDER BY Revenue DESC
            ) AS RevenueGroup
        FROM CustomerRevenue
    ) x
WHERE RevenueGroup = 1;


-- Question 43

SELECT category,
    SUM(
        CASE
            WHEN channel = 'Online' THEN Revenue
            ELSE 0
        END
    ) AS Online,
    SUM(
        CASE
            WHEN channel = 'Retail' THEN Revenue
            ELSE 0
        END
    ) AS Retail,
    SUM(
        CASE
            WHEN channel = 'Distributor' THEN Revenue
            ELSE 0
        END
    ) AS Distributor
FROM (
        SELECT p.category,
            o.channel,
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0) AS Revenue
        FROM Orders o
            JOIN Order_Details od ON o.order_id = od.order_id
            JOIN Products p ON od.product_id = p.product_id
    ) x
GROUP BY category;


-- Question 44

WITH Revenue AS (
    SELECT o.order_id,
        FORMAT(o.order_date, 'yyyy-MM') AS Month,
        SUM(
            p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
        ) AS Revenue
    FROM Orders o
        JOIN Order_Details od ON o.order_id = od.order_id
        JOIN Products p ON od.product_id = p.product_id
    GROUP BY o.order_id,
        FORMAT(o.order_date, 'yyyy-MM')
)
SELECT *
FROM Revenue r
WHERE Revenue > (
        SELECT SUM(Revenue) * 0.5
        FROM Revenue x
        WHERE x.Month = r.Month
    );


-- Question 45

SELECT customer_id,
    credit_limit,
    CASE
        WHEN credit_limit >= 1000000 THEN 'High'
        WHEN credit_limit >= 500000 THEN 'Medium'
        ELSE 'Low'
    END AS RiskCategory
FROM Customers;


-- Question 46

SELECT COUNT(DISTINCT customer_id) AS TotalCustomers,
    COUNT(DISTINCT order_id) AS TotalOrders,
    SUM(payment_amount) AS TotalPayments
FROM Payments;