-- Facebook SQL Interview Question
-- Assume you're given two tables containing data about Facebook Pages and their respective 
-- likes (as in "Like a Facebook Page").
-- Write a query to return the IDs of the Facebook pages that have zero likes. The output should 
-- be sorted in ascending order based on the page IDs.

--GIVEN
CREATE TABLE pages (
page_id INT,
page_name VARCHAR(100) 
);

CREATE TABLE page_likes (
user_id INT,
page_id INT, 
liked_date TIMESTAMP
);

-- SOLUTION
WITH all_pages AS (SELECT p.page_id, pl.liked_date
FROM page_likes pl
FULL JOIN pages p ON p.page_id=pl.page_id)
SELECT page_id
FROM all_pages
WHERE liked_date IS NULL
ORDER BY page_id ASC;
-- pages with id 32728 and 20701 got zero likes.