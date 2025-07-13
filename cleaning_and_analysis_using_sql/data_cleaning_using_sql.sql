-- Rename some columns in all tables
ALTER TABLE customers
RENAME COLUMN c_id TO customer_id,
RENAME COLUMN c_name TO customer_name;

ALTER TABLE delivery
RENAME COLUMN dp_id TO delivery_partner_id,
RENAME COLUMN dp_name TO delivery_partner_name,
RENAME COLUMN dp_ratings TO delivery_partner_ratings;

ALTER TABLE orders
RENAME COLUMN or_id TO order_id,
RENAME COLUMN c_id TO customer_id,
RENAME COLUMN p_id TO product_id,
RENAME COLUMN dp_id TO delivery_partner_id;

ALTER TABLE products
RENAME COLUMN p_id TO product_id,
RENAME COLUMN p_name TO product_name;

ALTER TABLE ratings
RENAME COLUMN r_id TO rating_id,
RENAME COLUMN or_id TO order_id;

ALTER TABLE returns_refund
RENAME COLUMN rt_id TO return_id,
RENAME COLUMN or_id TO order_id;

ALTER TABLE transactions
RENAME COLUMN tr_id TO transaction_id,
RENAME COLUMN or_id TO order_id;

-- Add a new column 'age_group' to 'customers' table
ALTER TABLE customers
ADD COLUMN age_group VARCHAR (255);

UPDATE customers
SET age_group = CASE
	WHEN age BETWEEN 18 AND 24 THEN 'Youth (18-24)'
    WHEN age BETWEEN 25 AND 34 THEN 'Young Adults (25-34)'
    WHEN age BETWEEN 35 AND 50 THEN 'Adults (35-50)'
    ELSE 'Senior (50+)'
END;

-- Add a new column 'time_of_day' to 'orders' table
ALTER TABLE orders
ADD COLUMN time_of_day VARCHAR (255);

UPDATE orders
SET time_of_day = CASE
	WHEN order_time BETWEEN '6:00:00' AND '11:59:59' THEN 'Morning (6 AM - 11:59 AM)'
    WHEN order_time BETWEEN '12:00:00' AND '16:59:59' THEN 'Afternoon (12 PM - 4:59 PM)'
    WHEN order_time BETWEEN '17:00:00' AND '20:59:59' THEN 'Evening (5 PM - 8:59 PM)'
    ELSE 'Night (9 PM - 5:59 AM)'
END;

-- Handle missing values in 'coupon' and 'discount' columns of 'orders' table
UPDATE orders
SET coupon = 'No coupon', discount = 0
WHERE coupon IS NULL AND discount IS NULL;

-- Data inconsistency in 'coupon' and 'discount' columns of 'orders' table
SELECT *
FROM orders
WHERE coupon IS NOT NULL AND discount IS NULL;

-- Missing values in 'prod_rating' and 'delivery/service_rating' of 'ratings' table
SELECT *
FROM ratings
WHERE prod_rating IS NULL OR `delivery/service_rating` IS NULL;

-- Missing values in 'transaction_mode' column of 'transactions' table
SELECT *
FROM transactions
WHERE transaction_mode IS NULL;

-- Adjusting the data inconsistency in 'returns_refund' table
UPDATE returns_refund r
JOIN orders o
ON r.order_id = o.order_id
SET date = NULL
WHERE r.date < o.order_date;
