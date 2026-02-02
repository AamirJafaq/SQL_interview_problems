DROP TABLE IF EXISTS employee_salary;
-- Create the table with employee name
CREATE TABLE employee_salary (
    employee_id INTEGER,
    name VARCHAR(255),
    year INTEGER,
    salary INTEGER,
    department VARCHAR(255)
);

-- Insert sample data with employee names
INSERT INTO employee_salary (employee_id, name, year, salary, department) VALUES
(125, 'John Doe', 2021, 50000, 'Sales'),
(125, 'John Doe', 2022, 52000, 'Sales'),
(125, 'John Doe', 2023, 54000, 'Sales'),
(125, 'John Doe', 2024, 56000, 'Sales'),
(102, 'Jane Smith', 2020, 45000, 'Marketing'),
(102, 'Jane Smith', 2021, 47000, 'Marketing'),
(102, 'Jane Smith', 2022, 49000, 'Marketing'),
(102, 'Jane Smith', 2023, 51000, 'Marketing'),
(165, 'Alice Johnson', 2021, 66000, 'Engineering'),
(165, 'Alice Johnson', 2022, 62000, 'Engineering'),
(165, 'Alice Johnson', 2023, 64000, 'Engineering'),
(200, 'Bob Brown', 2021, 55000, 'HR'),
(200, 'Bob Brown', 2022, 57000, 'HR'),
(200, 'Bob Brown', 2023, 58000, 'HR');


/*
-- Identify the employee who received at least 3 year over year increase in salaries!
*/
-- Solution
-- This query will gives the employees name, years, salary and previous salary receiving 3 year over 
-- year increase in salaries.
WITH pre_salaries AS (
SELECT employee_id, TRIM(name) AS name, year, salary,
		lag(salary) OVER(PARTITION BY TRIM(name) ORDER BY year) AS pre_yr_salary
FROM employee_salary), 
total_years_increase AS (
SELECT name, year, salary, pre_yr_salary,
		count(year) OVER (PARTITION BY name) AS total_yrs_increase 
FROM pre_salaries
WHERE salary>pre_yr_salary)
SELECT name, year, salary, pre_yr_salary 
FROM total_years_increase
WHERE total_yrs_increase>=3;

-- This query will gives only employees name receiving 3 year over year increase in salaries.
WITH pre_salaries AS (
SELECT employee_id, TRIM(name) AS name, year, salary,
		lag(salary) OVER(PARTITION BY TRIM(name) ORDER BY year) AS pre_yr_salary
FROM employee_salary)
SELECT name
FROM pre_salaries
WHERE salary>pre_yr_salary
GROUP BY name
HAVING count(name) >=3;

