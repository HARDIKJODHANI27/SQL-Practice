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
SELECT customer_id,
    COUNT(*) AS total_orders
FROM Orders
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 5;
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
--Question 9
SELECT p.product_id,
    SUM(
        p.selling_price * od.quantity * (1 - od.discount_percent / 100.0)
    ) Revenue
FROM Products p
    JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY Revenue DESC
LIMIT 1;
--Question 10
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
    ) MarginPercent
FROM Products p
    JOIN Order_Details od ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY MarginPercent
LIMIT 1;
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
--Question 18
SELECT customer_id,
    SUM(outstanding) Outstanding,
    credit_limit
FROM...
HAVING SUM(outstanding) > 0.8 * credit_limit;
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
SELECT region,
    customer_id,
    Revenue,
    RANK() OVER(
        PARTITION BY region
        ORDER BY Revenue DESC
    ) RankNo
FROM (...);
--Question 22
SELECT *
FROM (
        SELECT region,
            customer_id,
            Revenue,
            RANK() OVER(
                PARTITION BY region
                ORDER BY Revenue DESC
            ) rnk
        FROM (...)
    ) x
WHERE rnk = 2;
--Question 23
SELECT region,
    order_date,
    Revenue,
    SUM(Revenue) OVER(
        PARTITION BY region
        ORDER BY order_date
    ) RunningTotal
FROM (...);
--Question 24
SELECT category,
    SUM(Revenue) * 100 / SUM(SUM(Revenue)) OVER() ContributionPercent
FROM (...)
GROUP BY category;
--Question 25
SELECT *
FROM (
        SELECT category,
            product_id,
            Revenue,
            RANK() OVER(
                PARTITION BY category
                ORDER BY Revenue DESC
            ) rnk
        FROM (...)
    ) x
WHERE rnk <= 3;
--Question 26
SELECT channel,
    AVG(discount_percent) AvgDiscount
FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY channel;
--Question 27
SELECT order_id,
    COUNT(*) OrderCount,
    SUM(
        selling_price * quantity * (1 - discount_percent / 100.0)
    ) Revenue
FROM...
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