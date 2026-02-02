-- Create the student_details table
CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    gender CHAR(1)
);

-- Insert the data into the student_details table
INSERT INTO students (id, name, gender) VALUES
(1, 'Gopal', 'M'),
(2, 'Rohit', 'M'),
(3, 'Amit', 'M'),
(4, 'Suraj', 'M'),
(5, 'Ganesh', 'M'),
(6, 'Neha', 'F'),
(7, 'Isha', 'F'),
(8, 'Geeta', 'F');

/*
Given table student_details, write a query which displays names 
alternately by gender and sorted by ascending order of column id.
*/
-- Solution
WITH subq AS (SELECT id, name, gender, 
		ROW_NUMBER() OVER(PARTITION BY gender ORDER BY id) AS gender_group
FROM students)
SELECT id, name, gender
FROM subq
ORDER BY gender_group, CASE WHEN gender='M' THEN 1 ELSE 2 END; -- Male first in the result

-- What if there is condition that the first gender should be female.
WITH subq AS (SELECT id, name, gender, 
		ROW_NUMBER() OVER(PARTITION BY gender ORDER BY id) AS gender_group
FROM students)
SELECT id, name, gender
FROM subq
ORDER BY gender_group, CASE WHEN gender='F' THEN 1 ELSE 2 END; -- Female first in the result


