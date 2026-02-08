DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (name, salary) VALUES
('Alice', 60000.00),
('Bob', 75000.00),
('Charlie', 50000.00),
('David', 50000.00),
('Eva', 95000.00),
('Frank', 80000.00),
('Grace', 80000.00),
('Hank', 90000.00),
('Hank', 75000.00);

SELECT * FROM employees;    

/* Write SQL query to fetch nth highest salary!
*/
WITH ranking AS (
SELECT id, name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rank
FROM employees)
SELECT id, name, salary, rank
FROM ranking
WHERE rank= 'n'; -- Here replace 'n' with a number to get required highest salary.


