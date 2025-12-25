-- Twitter SQL Interview Question:
-- Assume you're given a table Twitter tweet data, write a query to obtain a 
-- histogram of tweets posted per user in 2022. Output the tweet count per user as 
-- the bucket and the number of Twitter users who fall into that bucket.
-- In other words, group the users by the number of tweets they posted in 2022 
-- and count the number of users in each group.

--GIVEN
CREATE TABLE tweets (
tweet_id INT,
user_id INT,
msg TEXT,
tweet_date TIMESTAMP
);

SELECT * FROM tweets;

-- SOLUTION
WITH CTE1 AS (SELECT user_id, count(tweet_id) AS tweets_per_user
FROM tweets
WHERE EXTRACT(year FROM tweet_date)=2022
GROUP BY user_id)
SELECT tweets_per_user AS tweet_bucket, count(user_id) AS num_users
FROM CTE1
GROUP BY tweets_per_user;
