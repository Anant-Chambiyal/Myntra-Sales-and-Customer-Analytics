USE myntra_db;

/* 1) How has the number of new customers, repeat customers, repeat rate and customer retention rate changed on
quarterly basis. */
WITH first_orders AS (
	SELECT *,
	MIN(order_date) OVER(PARTITION BY customer_id) AS 'first_order_date',
	FIRST_VALUE(order_time) OVER(PARTITION BY customer_id ORDER BY order_date, order_time) AS 'first_order_time'
	FROM orders
),
customer_types AS (
	SELECT *,
	CASE
		WHEN order_date = first_order_date AND order_time = first_order_time THEN 'new'
		ELSE 'repeat'
	END AS 'customer_type'
	FROM first_orders
),
count_and_repeat AS (
	SELECT YEAR(order_date) AS 'purchase_year', QUARTER(order_date) AS 'purchase_quarter',
	COUNT(DISTINCT CASE WHEN customer_type = 'new' THEN customer_id END) AS 'new_customers',
	COUNT(DISTINCT CASE WHEN customer_type = 'repeat' THEN customer_id END) AS 'repeat_customers',
	ROUND((COUNT(DISTINCT CASE WHEN customer_type = 'repeat' THEN customer_id END) / COUNT(DISTINCT customer_id))
	* 100, 2) AS 'repeat_rate'
	FROM customer_types
	GROUP BY YEAR(order_date), QUARTER(order_date)
),
quarterly_customers AS (
	SELECT DISTINCT customer_id, YEAR(order_date) AS 'purchase_year', QUARTER(order_date) AS 'purchase_quarter'
	FROM orders
),
ranking AS (
	SELECT *,
    DENSE_RANK() OVER(ORDER BY purchase_year, purchase_quarter) AS 'rn'
    FROM quarterly_customers
),
retention AS (
	SELECT *
    FROM (
		SELECT this_quarter.purchase_year, this_quarter.purchase_quarter,
		ROUND((COUNT(DISTINCT next_quarter.customer_id) / COUNT(DISTINCT this_quarter.customer_id)) * 100, 2)
		AS 'customer_retention_rate'
		FROM ranking this_quarter
		LEFT JOIN ranking next_quarter
		ON this_quarter.rn + 1 = next_quarter.rn AND this_quarter.customer_id = next_quarter.customer_id
		GROUP BY this_quarter.purchase_year, this_quarter.purchase_quarter
    ) AS t
    WHERE purchase_year != (SELECT MAX(YEAR(order_date)) FROM orders)
    OR purchase_quarter != (SELECT MAX(QUARTER(order_date)) FROM orders)    
)

SELECT CONCAT(c.purchase_year, '-', c.purchase_quarter) AS 'Purchase Quarter',
c.new_customers AS 'New Customers', c.repeat_customers AS 'Repeat Customers', c.repeat_rate AS 'Repeat Rate',
r.customer_retention_rate AS 'Customer Retention Rate'
FROM count_and_repeat c
LEFT JOIN retention r
ON c.purchase_year = r.purchase_year AND c.purchase_quarter = r.purchase_quarter;

-- 2) How many customers have never placed a single order? Also, calculate their percentage.
SELECT COUNT(CASE WHEN o.customer_id IS NULL THEN 1 END) AS 'no_of_customers_who_never_placed_an_order',
ROUND((COUNT(CASE WHEN o.customer_id IS NULL THEN 1 END) / COUNT(DISTINCT c.customer_id)) * 100, 2)
AS 'pct_of_customers_who_never_placed_an_order'
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

-- 3) Calculate average quarterly sales and number of orders.
WITH quarterly_data AS (
	SELECT YEAR(o.order_date) AS 'purchase_year', QUARTER(o.order_date) AS 'purchase_quarter',
	SUM(o.qty * p.price) AS 'sales',
	COUNT(DISTINCT o.order_id) AS 'order_count'
	FROM orders o
	JOIN products p
	ON o.product_id = p.product_id
	GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
)

SELECT ROUND(AVG(sales)) AS 'avg_quarterly_sales',
ROUND(AVG(order_count)) AS 'avg_quarterly_order_count'
FROM quarterly_data;

-- 4) Calculate the total sales, order count, average order value (AOV) and their Quarter-over-Quarter (QoQ) growth.
WITH quarterly_data AS (
	SELECT CONCAT(YEAR(o.order_date), '-', QUARTER(o.order_date)) AS 'purchase_quarter',
	SUM(o.qty * p.price) AS 'sales',
	COUNT(DISTINCT o.order_id) AS 'order_count',
	ROUND(SUM(o.qty * p.price) / COUNT(DISTINCT o.order_id)) AS 'aov'
	FROM orders o
	JOIN products p
	ON o.product_id = p.product_id
	GROUP BY CONCAT(YEAR(o.order_date), '-', QUARTER(o.order_date))
),
prev_quarter_data AS (
	SELECT *,
	LAG(sales) OVER(ORDER BY purchase_quarter) AS 'prev_quarter_sales',
	LAG(order_count) OVER(ORDER BY purchase_quarter) AS 'prev_quarter_order_count',
	LAG(aov) OVER(ORDER BY purchase_quarter) AS 'prev_quarter_aov'
	FROM quarterly_data
)

SELECT purchase_quarter AS 'Purchase Quarter', ROUND(sales) AS 'Sales',
ROUND(((sales - prev_quarter_sales) / prev_quarter_sales) * 100, 2) AS 'Sales Growth %',
order_count AS 'Order Count',
ROUND(((order_count - prev_quarter_order_count) / prev_quarter_order_count) * 100, 2) AS 'Order Count Growth %',
ROUND(aov) AS 'AOV',
ROUND(((aov - prev_quarter_aov) / prev_quarter_aov) * 100, 2) AS 'AOV Growth %'
FROM prev_quarter_data;

-- 5) Calculate the total sales, order count, AOV and their Month-over-Month (MoM) growth.
WITH monthly_data AS (
	SELECT YEAR(o.order_date) AS 'year', DATE_FORMAT(o.order_date, '%b') AS 'month',
	MONTH(o.order_date) AS 'month_no',
	SUM(o.qty * p.price) AS 'sales',
	COUNT(DISTINCT o.order_id) AS 'order_count',
	SUM(o.qty * p.price) / COUNT(DISTINCT o.order_id) AS 'aov'
	FROM orders o
	JOIN products p
	ON o.product_id = p.product_id
    GROUP BY YEAR(o.order_date), DATE_FORMAT(o.order_date, '%b'), MONTH(o.order_date)
),
prev_month_data AS (
	SELECT *,
	LAG(sales) OVER(ORDER BY year, month_no) AS 'prev_month_sales',
	LAG(order_count) OVER(ORDER BY year, month_no) AS 'prev_month_order_count',
	LAG(aov) OVER(ORDER BY year, month_no) AS 'prev_month_aov'
	FROM monthly_data
)

SELECT year AS 'Year', month AS 'Month',
CONCAT(month, '-', year) AS 'Purchase Month', ROUND(sales) AS 'Sales',
ROUND(((sales - prev_month_sales) / prev_month_sales) * 100, 2) AS 'Sales Growth %',
order_count AS 'Order Count',
ROUND(((order_count - prev_month_order_count) / prev_month_order_count) * 100, 2) AS 'Order Count Growth %',
ROUND(aov) AS 'AOV',
ROUND(((aov - prev_month_aov) / prev_month_aov) * 100, 2) AS 'AOV Growth %'
FROM prev_month_data;

-- 6) Analyze how sales, order count and AOV vary by state.
WITH total_data AS (
	SELECT SUM(o.qty * p.price) AS 'total_sales',
    COUNT(DISTINCT o.order_id) AS 'total_order_count'
    FROM orders o
    JOIN products p
    ON o.product_id = p.product_id
)

SELECT c.state,
ROUND(SUM(o.qty * p.price)) AS 'sales',
ROUND((SUM(o.qty * p.price) / (SELECT total_sales FROM total_data)) * 100, 2) AS 'sales %',
COUNT(DISTINCT o.order_id) AS 'order_count',
ROUND((COUNT(DISTINCT o.order_id) / (SELECT total_order_count FROM total_data)) * 100, 2) AS 'order count %',
ROUND(SUM(o.qty * p.price) / COUNT(DISTINCT o.order_id)) AS 'aov'
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY c.state;

-- 7) Calculate average sales, average order count and AOV on weekday v/s weekend.
WITH day_wise_data AS (
	SELECT DAYNAME(o.order_date) AS 'day_name',
	SUM(o.qty * p.price) AS 'sales',
	COUNT(DISTINCT o.order_id) AS 'order_count'
	FROM orders o
	JOIN products p
	ON o.product_id = p.product_id
	GROUP BY DAYNAME(o.order_date)
)

SELECT CASE WHEN day_name IN ('Saturday', 'Sunday') THEN 'weekend' ELSE 'weekday' END AS 'day_type',
ROUND(AVG(sales)) AS 'avg_sales',
ROUND(AVG(order_count)) AS 'avg_order_count',
ROUND(AVG(sales) / AVG(order_count)) AS 'aov'
FROM day_wise_data
GROUP BY CASE WHEN day_name IN ('Saturday', 'Sunday') THEN 'weekend' ELSE 'weekday' END;

-- 8) Analyze the effect of coupons on sales, order count and AOV.
SELECT CASE WHEN o.coupon = 'No coupon' THEN 'No' ELSE 'Yes' END AS 'is_coupon_used',
ROUND(SUM(o.qty * p.price)) AS 'sales',
COUNT(DISTINCT o.order_id) AS 'order_count',
ROUND(SUM(o.qty * p.price) / COUNT(DISTINCT o.order_id)) AS 'aov'
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY CASE WHEN o.coupon = 'No coupon' THEN 'No' ELSE 'Yes' END;

-- 9) How do sales, order count and AOV vary by time of day?
SELECT o.time_of_day,
ROUND(SUM(o.qty * p.price)) AS 'sales',
COUNT(DISTINCT o.order_id) AS 'order_count',
ROUND(SUM(o.qty * p.price) / COUNT(DISTINCT o.order_id)) AS 'aov'
FROM orders o
JOIN products p
ON o.product_id = p.product_id
GROUP BY o.time_of_day;

-- 10) How do sales, order count and AOV vary by age group?
WITH total_data AS (
	SELECT SUM(o.qty * p.price) AS 'total_sales',
    COUNT(DISTINCT o.order_id) AS 'total_order_count'
    FROM orders o
    JOIN products p
    ON o.product_id = p.product_id
)

SELECT c.age_group AS 'Age Group',
ROUND(SUM(o.qty * p.price)) AS 'Sales',
ROUND((SUM(o.qty * p.price) / (SELECT total_sales FROM total_data)) * 100, 2) AS 'Sales %',
COUNT(DISTINCT o.order_id) AS 'Order Count',
ROUND((COUNT(DISTINCT o.order_id) / (SELECT total_order_count FROM total_data)) * 100, 2) AS 'Order Count %',
ROUND(SUM(o.qty * p.price) / COUNT(DISTINCT o.order_id)) AS 'AOV'
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY c.age_group;

-- 11) How does return rate vary by age group and gender?
SELECT c.age_group AS 'Age Group', c.gender AS 'Gender',
ROUND((COUNT(DISTINCT CASE WHEN `return/refund` = 'approved' THEN r.order_id END) / COUNT(DISTINCT o.order_id))
* 100, 2) AS 'Refund Rate'
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
LEFT JOIN returns_refund r
ON o.order_id = r.order_id
GROUP BY c.age_group, c.gender;

-- 12) Find the return rate for each transaction mode.
WITH orders_returned AS (
	SELECT *
	FROM returns_refund
	WHERE `return/refund` = 'Approved'
)

SELECT t.transaction_mode,
ROUND((COUNT(o.order_id) / COUNT(t.order_id)) * 100, 2) AS 'return rate %'
FROM transactions t
LEFT JOIN orders_returned o
ON t.order_id = o.order_id
WHERE t.transaction_mode IS NOT NUll
GROUP BY t.transaction_mode;

-- 13) Which product category have the highest return rate? Arrange the result in decscending order.
SELECT p.category,
ROUND((COUNT(CASE WHEN r.`return/refund` = 'Approved' THEN r.order_id END) / COUNT(o.order_id)) * 100, 2)
AS 'refund_rate'
FROM products p
JOIN orders o
ON p.product_id = o.product_id
LEFT JOIN returns_refund r
ON o.order_id = r.order_id
GROUP BY p.category
ORDER BY refund_rate DESC;

-- 14) How does return rate vary by geographic attribute of customers?
WITH returned_orders AS (
	SELECT *
    FROM returns_refund
    WHERE `return/refund` = 'Approved'
)

SELECT c.state,
ROUND((COUNT(r.order_id) / COUNT(o.order_id)) * 100, 2) AS 'return_rate'
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
LEFT JOIN returned_orders r
ON o.order_id = r.order_id
GROUP BY c.state;

-- 15) How does return rate vary for each product category over the quarters?
WITH returned_orders AS (
	SELECT *
    FROM returns_refund
    WHERE `return/refund` = 'Approved'
)

SELECT p.category AS 'Product Category',
CONCAT(YEAR(o.order_date), '-', QUARTER(o.order_date)) AS 'Purchase Quarter',
ROUND((COUNT(r.order_id) / COUNT(*)) * 100, 2) AS 'return_rate'
FROM products p
JOIN orders o
ON p.product_id = o.product_id
LEFT JOIN returned_orders r
ON o.order_id = r.order_id
GROUP BY p.category, CONCAT(YEAR(o.order_date), '-', QUARTER(o.order_date))
ORDER BY p.category, CONCAT(YEAR(o.order_date), '-', QUARTER(o.order_date));

-- 16) How do sales and order count vary by product category?
WITH total_data AS (
	SELECT SUM(o.qty * p.price) AS 'total_sales',
    COUNT(DISTINCT o.order_id) AS 'total_order_count'
    FROM products p
    JOIN orders o
    ON p.product_id = o.product_id
)

SELECT p.category,
SUM(o.qty * p.price) AS 'sales',
ROUND((SUM(o.qty * p.price) / (SELECT total_sales FROM total_data)) * 100, 2) AS 'sales %',
COUNT(DISTINCT o.order_id) AS 'order_count',
ROUND((COUNT(DISTINCT o.order_id) / (SELECT total_order_count FROM total_data)) * 100, 2) AS 'order_count %'
FROM products p
JOIN orders o
ON p.product_id = o.product_id
GROUP BY p.category;

-- 17) Do customers prefer different product categories based on their gender?
SELECT c.gender, p.category,
COUNT(DISTINCT o.order_id) AS 'order_count'
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN products p
ON o.product_id = p.product_id
GROUP BY c.gender, p.category
ORDER BY c.gender, order_count DESC;

-- 18) How do different product categories have perfomed over quarters?
WITH category_wise_data AS (
	SELECT p.category, CONCAT(YEAR(o.order_date), '-', QUARTER(o.order_date)) AS 'purchase_quarter',
	SUM(o.qty * p.price) AS 'sales',
	COUNT(DISTINCT o.order_id) AS 'order_count'
	FROM products p
	JOIN orders o
	ON p.product_id = o.product_id
	GROUP BY p.category, CONCAT(YEAR(o.order_date), '-', QUARTER(o.order_date))
),
prev_quarter_data AS (
	SELECT *,
	LAG(sales) OVER(PARTITION BY category ORDER BY purchase_quarter) AS 'prev_quarter_sales',
	LAG(order_count) OVER(PARTITION BY category ORDER BY purchase_quarter) AS 'prev_quarter_order_count'
	FROM category_wise_data
)

SELECT category, purchase_quarter, sales,
ROUND(((sales - prev_quarter_sales) / prev_quarter_sales) * 100, 2) AS 'Sales Growth %',
order_count,
ROUND(((order_count - prev_quarter_order_count) / prev_quarter_order_count) * 100, 2) AS 'Order Count Growth %'
FROM prev_quarter_data;

-- 19) Find the top 5 customers with maximum amount of sales.
WITH customer_wise_data AS (
	SELECT c.customer_id, c.customer_name,
	SUM(o.qty * p.price) AS 'sales'
	FROM customers c
	JOIN orders o
	ON c.customer_id = o.customer_id
	JOIN products p
	ON o.product_id = p.product_id
	GROUP BY c.customer_id, c.customer_name
)

SELECT customer_id, customer_name, sales
FROM (
	SELECT *,
	DENSE_RANK() OVER(ORDER BY sales DESC) AS 'rn'
	FROM customer_wise_data
) AS t
WHERE rn <= 5;

-- 20) Do some product categories highly dominate some locations?
WITH state_and_category_wise_data AS (
	SELECT c.state, p.category,
	COUNT(DISTINCT o.order_id) AS 'order_count'
	FROM customers c
	JOIN orders o
	ON c.customer_id = o.customer_id
	JOIN products p
	ON o.product_id = p.product_id
	GROUP BY c.state, p.category
),
state_wise_data AS (
	SELECT c.state,
    COUNT(DISTINCT o.order_id) AS 'total_order_count'
    FROM customers c
    JOIN orders o
    ON c.customer_id = o.customer_id
    GROUP BY c.state
)

SELECT sc.state, sc.category, s.total_order_count AS 'total_orders_in_state',
sc.order_count AS 'total_orders_in_category',
ROUND((sc.order_count / s.total_order_count) * 100, 2) AS 'category to state order count %'
FROM state_and_category_wise_data sc
JOIN state_wise_data s
ON sc.state = s.state;

/* 21) Which state has the maximum number of customers who did not place a single order? Arrange the result in
descending order. */
SELECT c.state,
COUNT(*) AS 'total_customers',
COUNT(CASE WHEN o.customer_id IS NULL THEN c.customer_id END) AS 'customers_without_a_single_order',
ROUND((COUNT(CASE WHEN o.customer_id IS NULL THEN c.customer_id END) / COUNT(*)) * 100, 2)
AS 'pct_of_customers_without_a_single_order'
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.state
ORDER BY pct_of_customers_without_a_single_order DESC;

-- 22) Calculate the average number of days required to solve the refund or return issue.
SELECT ROUND(AVG(TIMESTAMPDIFF(DAY, o.order_date, r.date))) AS 'avg_no_of_days'
FROM orders o
JOIN returns_refund r
ON o.order_id = r.order_id
WHERE r.date IS NOT NULL;

-- 23) Calculate the cumulative quarterly sales.
WITH quarterly_sales AS (
	SELECT YEAR(o.order_date) AS 'purchase_year', QUARTER(o.order_date) AS 'purchase_quarter',
    SUM(o.qty * p.price) AS 'sales'
	FROM orders o
	JOIN products p
	ON o.product_id = p.product_id
	GROUP BY YEAR(o.order_date), QUARTER(o.order_date)
)

SELECT *,
SUM(sales) OVER(ORDER BY purchase_year, purchase_quarter) AS 'running_total_sales'
FROM quarterly_sales;