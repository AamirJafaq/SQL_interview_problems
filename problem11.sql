
-- Walmart SQL Question

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    store_name VARCHAR(50),
    sale_date DATE,
    sales_amount DECIMAL(10, 2)
);


INSERT INTO sales (store_name, sale_date, sales_amount) 
VALUES
('A', '2024-01-01', 1000.00),
('A', '2024-02-01', 1500.00),
('A', '2024-03-01', 2000.00),
('A', '2024-04-01', 3000.00),
('A', '2024-05-01', 4500.00),
('A', '2024-06-01', 6000.00),
('B', '2024-01-01', 2000.00),
('B', '2024-02-01', 2200.00),
('B', '2024-03-01', 2400.00),
('B', '2024-04-01', 2600.00),
('B', '2024-05-01', 2800.00),
('B', '2024-06-01', 3000.00),
('C', '2024-01-01', 3000.00),
('C', '2024-02-01', 3100.00),
('C', '2024-03-01', 3200.00),
('C', '2024-04-01', 3300.00),
('C', '2024-05-01', 3400.00),
('C', '2024-06-01', 3500.00);

/* Calculate each store running total, growth ratio compare to previous month.
Return store name, sales amount, running total, growth ratio.
*/
-- growth ratio = cr sale - last_sale/last m sale * 100
-- Solution
WITH running_sum AS (SELECT *,
		lag(sales_amount) OVER(PARTITION BY store_name ORDER BY sale_date) AS last_sales_amount,
		sum(sales_amount) OVER(PARTITION BY store_name ORDER BY sale_date) AS running_total
FROM sales)
SELECT store_name, sale_date AS current_sales_amount, sales_amount, 
			running_total,
			COALESCE(ROUND(100*(sales_amount-last_sales_amount)/last_sales_amount,2),0) AS growth_ratio
FROM running_sum;