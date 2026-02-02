-- Create orders table
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id VARCHAR(10),
    customer_id INTEGER,
    order_datetime TIMESTAMP,
    item_id VARCHAR(10),
    order_quantity INTEGER,
    PRIMARY KEY (order_id, item_id)
);

-- Inserting the sample data
INSERT INTO orders (order_id, customer_id, order_datetime, item_id, order_quantity) VALUES
('O-005', 1, '2023-01-12 11:48:00', 'C005', 1),
('O-005', 1, '2023-01-12 00:48:00', 'C008', 1),
('O-006', 4, '2023-01-16 02:52:00', 'C012', 2),
('O-001', 4, '2023-06-15 04:35:00', 'C004', 3),
('O-007', 1, '2024-07-13 09:15:00', 'C007', 2),
('O-010', 3, '2024-07-13 13:45:00', 'C008', 5),
('O-011', 3, '2024-07-13 16:20:00', 'C006', 2),
('O-012', 1, '2024-07-14 10:15:00', 'C005', 3),
('O-008', 1, '2024-07-14 11:00:00', 'C004', 4),
('O-013', 2, '2024-07-14 12:40:00', 'C007', 1),
('O-009', 3, '2024-07-14 14:22:00', 'C006', 3),
('O-014', 2, '2024-07-14 15:30:00', 'C004', 6),
('O-015', 1, '2024-07-15 05:00:00', 'C012', 4);

-- Create items table
DROP TABLE IF EXISTS items;
CREATE TABLE items (
    item_id VARCHAR(10) PRIMARY KEY,
    item_category VARCHAR(50)
);

-- Inserting sample data
INSERT INTO items (item_id, item_category) VALUES
('C004', 'Books'),
('C005', 'Books'),
('C006', 'Apparel'),
('C007', 'Electronics'),
('C008', 'Electronics'),
('C012', 'Apparel');



/* Q.1 How many units were ordered yesterday?
*/
-- Solution
SELECT order_quantity, DATE_TRUNC('DAY', order_datetime)::DATE
FROM orders
WHERE DATE_TRUNC('DAY', order_datetime)::DATE= CURRENT_DATE - INTERVAL '1 DAY'


/* Q.2 In the last 7 days (including today), how many units were ordered in each category?
*/
-- Solution
SELECT i.item_category, sum(o.order_quantity)
FROM orders AS o
LEFT JOIN items AS i ON i.item_id=o.item_id
WHERE o.order_datetime::DATE >= CURRENT_DATE - INTERVAL '7 DAYS'
GROUP BY 1;


/* Q.3 Write a query to get the earliest order_id for all customers for each date they placed an order.
*/
-- Solution
WITH earliest_orders AS (
SELECT customer_id, order_id, order_datetime,
		ROW_NUMBER() OVER(PARTITION BY customer_id, order_datetime::DATE ORDER BY order_datetime ASC) 
					AS earliest_order
FROM orders)
SELECT customer_id, order_id, order_datetime
FROM earliest_orders
WHERE earliest_order=1;


/*
Q.4 Write a query to find the second earliest order_id for each customer for each date they placed 
two or more orders.
*/
-- Solution 
WITH earliest_orders AS (
SELECT customer_id, order_id, order_datetime,
		ROW_NUMBER() OVER(PARTITION BY customer_id, order_datetime::DATE ORDER BY order_datetime ASC) 
					AS earliest_order,
		COUNT(order_id) OVER (PARTITION BY customer_id, order_datetime::DATE) AS total_orders
FROM orders)
SELECT customer_id, order_id, order_datetime
FROM earliest_orders
WHERE earliest_order=2 AND total_orders>=2;