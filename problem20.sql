DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS orders;


CREATE TABLE restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES Restaurants(id),
    order_time TIMESTAMP,
    dispatch_time TIMESTAMP
);

INSERT INTO restaurants (name, location) VALUES
('Restaurant A', 'Delhi'),
('Restaurant B', 'Delhi'),
('Restaurant C', 'Delhi'),
('Restaurant D', 'Delhi'),
('Restaurant E', 'Delhi');

INSERT INTO orders (restaurant_id, order_time, dispatch_time) VALUES
(1, '2024-07-23 12:00:00', '2024-07-23 12:14:00'),
(1, '2024-07-23 12:30:00', '2024-07-23 12:48:00'),
(1, '2024-07-23 13:00:00', '2024-07-23 13:16:00'),
(2, '2024-07-23 13:30:00', '2024-07-23 13:50:00'),
(2, '2024-07-23 14:00:00', '2024-07-23 14:14:00'),
(3, '2024-07-23 14:30:00', '2024-07-23 14:49:00'),
(3, '2024-07-23 15:00:00', '2024-07-23 15:16:00'),
(3, '2024-07-23 15:30:00', '2024-07-23 15:40:00'),
(4, '2024-07-23 16:00:00', '2024-07-23 16:10:00'),
(4, '2024-07-23 16:30:00', '2024-07-23 16:50:00'),
(5, '2024-07-23 17:00:00', '2024-07-23 17:25:00'),
(5, '2024-07-23 17:30:00', '2024-07-23 17:55:00'),
(5, '2024-07-23 18:00:00', '2024-07-23 18:19:00'),
(1, '2024-07-23 18:30:00', '2024-07-23 18:44:00'),
(2, '2024-07-23 19:00:00', '2024-07-23 19:13:00');


/* You are given two tables: Restaurants and Orders. After receiving an order,  each restaurant has 15 
minutes to dispatch it. Dispatch times are categorized as follows:
on_time_dispatch: Dispatched within 15 minutes of order received.
late_dispatch: Dispatched between 15 and 20 minutes after order received.
super_late_dispatch: Dispatched after 20 minutes.
Task: Write an SQL query to count the number of dispatched orders in each category for each restaurant.
*/
WITH categories AS 
(SELECT *, CASE 
			WHEN EXTRACT(EPOCH FROM dispatch_time-order_time)/60 <=15 THEN 'on_time_dispatch' 
			WHEN EXTRACT(EPOCH FROM dispatch_time-order_time)/60 >15 AND 
				EXTRACT(EPOCH FROM dispatch_time-order_time)/60 <=20 THEN 'late_dispatch'
			ELSE 'super_late_dispatch' END AS category
FROM orders)
SELECT restaurant_id, category, count(category) AS total_dispatch_orders
FROM categories
GROUP BY 1, 2
ORDER BY 1;


--or
WITH categories AS 
(SELECT o.*, r.name, CASE 
			WHEN EXTRACT(EPOCH FROM dispatch_time-order_time)/60 <=15 THEN 'on_time_dispatch' 
			WHEN EXTRACT(EPOCH FROM dispatch_time-order_time)/60 >15 AND 
				EXTRACT(EPOCH FROM dispatch_time-order_time)/60 <=20 THEN 'late_dispatch'
			ELSE 'super_late_dispatch' END AS category
FROM orders AS o
LEFT JOIN restaurants AS r ON o.restaurant_id=r.id)
SELECT restaurant_id, name,
		sum(CASE WHEN category='on_time_dispatch' THEN 1 ELSE 0 END) AS on_time_dispatch,
		sum(CASE WHEN category='late_dispatch' THEN 1 ELSE 0 END) AS late_dispatch,
		sum(CASE WHEN category='super_late_dispatch' THEN 1 ELSE 0 END) AS super_late_dispatch
FROM categories
GROUP BY 1, 2;


