/*
able: Sessions

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| session_id          | int     |
| duration            | int     |
+---------------------+---------+
session_id is the column of unique values for this table.
duration is the time in seconds that a user has visited the application.
 

You want to know how long a user visits your application. You decided to create bins of "[0-5>", "[5-10>", "[10-15>", and "15 minutes or more" and count the number of sessions on it.

Write a solution to report the (bin, total).

nput: 
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

-- The CTE + LEFT JOIN Dimension Table Method (Scalable & Data Warehousing Pattern)
-- Generates all required bins as a reference dataset, then LEFT JOINs Sessions.
-- This ensures bins with 0 occurrences still appear in the final output.
-- Using COUNT(s.session_id) ensures empty bins evaluate to 0 instead of 1.
WITH Bins AS (
    SELECT '[0-5>' AS bin, 0 AS min_sec, 300 AS max_sec, 1 AS ord
    UNION ALL
    SELECT '[5-10>', 300, 600, 2
    UNION ALL
    SELECT '[10-15>', 600, 900, 3
    UNION ALL
    SELECT '15 or more', 900, NULL, 4
)
SELECT 
    b.bin,
    COUNT(s.session_id) AS total
FROM Bins b
LEFT JOIN Sessions s 
    ON s.duration >= b.min_sec 
   AND (s.duration < b.max_sec OR b.max_sec IS NULL)
GROUP BY b.bin, b.ord
ORDER BY b.ord;

