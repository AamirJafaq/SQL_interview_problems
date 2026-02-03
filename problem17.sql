-- Advanced Walmart Sales Analysis Question

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Laptop', 'Electronics', 999.99),
(2, 'Smartphone', 'Electronics', 799.99),
(3, 'Headphones', 'Electronics', 199.99),
(4, 'Refrigerator', 'Appliances', 1499.99),
(5, 'Microwave', 'Appliances', 299.99),
(6, 'T-shirt', 'Clothing', 19.99),
(7, 'Jeans', 'Clothing', 49.99),
(8, 'Blender', 'Appliances', 99.99),
(9, 'Coffee Maker', 'Appliances', 79.99),
(10, 'Shoes', 'Clothing', 89.99);

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    sale_date DATE,
    quantity INT,
    amount DECIMAL(10, 2),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO sales (sale_id, product_id, customer_id, sale_date, quantity, amount) VALUES
(1, 1, 101, '2023-01-15', 1, 999.99),
(2, 2, 102, '2023-02-16', 2, 1599.98),
(3, 3, 103, '2023-03-17', 3, 599.97),
(4, 4, 104, '2023-04-18', 1, 1499.99),
(5, 5, 105, '2023-05-19', 2, 599.98),
(6, 6, 101, '2023-06-20', 5, 99.95),
(7, 7, 102, '2023-07-21', 3, 149.97),
(8, 8, 103, '2023-08-22', 1, 99.99),
(9, 9, 104, '2023-09-23', 2, 159.98),
(10, 10, 105, '2023-10-24', 1, 89.99),
(11, 1, 101, '2023-11-24', 1, 999.99),
(12, 2, 102, '2023-11-25', 2, 1599.98),
(13, 3, 103, '2023-11-26', 3, 599.97),
(14, 4, 104, '2023-11-27', 1, 1499.99),
(15, 5, 105, '2023-11-28', 2, 599.98);


/* Write a query to find the top 3 products with the  highest sales volume (total quantity sold) 
for each quarter of the year 2023.
*/
-- Solution
WITH ranking AS 
(SELECT EXTRACT(QUARTER FROM s.sale_date) AS quarter, s.product_id, p.product_name, sum(s.quantity) AS total_quantity, 
	DENSE_RANK() OVER(PARTITION BY EXTRACT(QUARTER FROM s.sale_date) ORDER BY sum(s.quantity) DESC) AS rank
FROM sales AS s
LEFT JOIN products AS p ON p.product_id=s.product_id
WHERE EXTRACT(YEAR FROM s.sale_date)=2023
GROUP BY EXTRACT(QUARTER FROM s.sale_date), s.product_id, p.product_name)
SELECT quarter, product_id, product_name, total_quantity 
FROM ranking 
WHERE rank <=3
ORDER BY 1, total_quantity DESC;

