
DROP TABLE IF EXISTS users;
create table users
(
	user_id INT,
	user_name VARCHAR(20),
	credit_limit INT
);

DROP TABLE IF EXISTS transactions;
create table transactions
(
	trans_id INT,
	paid_by INT,
	paid_to INT,
	amount INT,
	trans_date DATE
);

INSERT INTO users(user_id,user_name,credit_limit) VALUES
(1,'Peter',100),
(2,'Roger',200),
(3,'Jack',10000),
(4,'John',800);

INSERT INTO transactions(trans_id,paid_by,paid_to,amount,trans_date) VALUES
(1,1,3,400,'01-01-2024'),
(2,3,2,500,'02-01-2024'),
(3,2,1,200,'02-01-2024');


/* Write a query to find users whose transactions has breached their credit limit.
*/
WITH total_amount AS 
(SELECT u.user_name, t.paid_by, u.credit_limit, sum(t.amount) AS total_transaction_amount
FROM transactions AS t
LEFT JOIN users AS u ON u.user_id=t.paid_by
GROUP BY 1, 2, 3)
SELECT paid_by AS user_id, user_name, credit_limit, total_transaction_amount
FROM total_amount
WHERE credit_limit< total_transaction_amount;

--or
SELECT
    u.user_id,
    u.user_name,
    SUM(t.amount) AS total_spent   
FROM users u
JOIN transactions t
  ON t.paid_by = u.user_id
GROUP BY u.user_id, u.user_name
HAVING SUM(t.amount) > u.credit_limit;