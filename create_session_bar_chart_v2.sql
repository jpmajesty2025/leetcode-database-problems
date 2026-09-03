/*
Table: Sessions

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| session_id          | int     |
| duration            | int     |
+---------------------+---------+
session_id is the column of unique values for this table.
duration is the time in seconds that a user has visited the application.
 

You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>", and "15 or more" and count the number of sessions on it.

Write a solution to report the (bin, total).

Input: 
Sessions table:
+-------------+---------------+
| session_id  | duration      |
+-------------+---------------+
| 1           | 30            |
| 2           | 199           |
| 3           | 299           |
| 4           | 580           |
| 5           | 1000          |
+-------------+---------------+
Output: 
+--------------+--------------+
| bin          | total        |
+--------------+--------------+
| [0-5>        | 3            |
| [5-10>       | 1            |
| [10-15>      | 0            |
| 15 or more   | 1            |
+--------------+--------------+
Explanation: 
For session_id 1, 2, and 3 have a duration greater or equal than 0 minutes and less than 5 minutes.
For session_id 4 has a duration greater or equal than 5 minutes and less than 10 minutes.
There is no session with a duration greater than or equal to 10 minutes and less than 15 minutes.
For session_id 5 has a duration greater than or equal to 15 minutes.
*/

-- The 4x UNION ALL Method (Classic LeetCode "Easy" Solution)
-- Aggregation without GROUP BY guarantees exactly 1 row output (evaluating to 0 if no match),
-- which solves the 0-count bin requirement automatically without requiring joins or CTEs.
SELECT '[0-5>' AS bin, COUNT(*) AS total 
FROM Sessions 
WHERE duration < 300

UNION ALL

SELECT '[5-10>' AS bin, COUNT(*) AS total 
FROM Sessions 
WHERE duration >= 300 AND duration < 600

UNION ALL

SELECT '[10-15>' AS bin, COUNT(*) AS total 
FROM Sessions 
WHERE duration >= 600 AND duration < 900

UNION ALL

SELECT '15 or more' AS bin, COUNT(*) AS total 
FROM Sessions 
WHERE duration >= 900;
