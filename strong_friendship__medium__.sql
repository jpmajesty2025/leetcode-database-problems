/*
Table: Friendship

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user1_id    | int     |
| user2_id    | int     |
+-------------+---------+
(user1_id, user2_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the users user1_id and user2_id are friends.
 

Write a solution to find all the strong friendships in the Friendship table.

A strong friendship is defined as a friendship where both users have at least three common friends.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Friendship table:
+----------+----------+
| user1_id | user2_id |
+----------+----------+
| 1        | 2        |
| 1        | 3        |
| 2        | 3        |
| 1        | 4        |
| 2        | 4        |
| 1        | 5        |
| 2        | 5        |
| 1        | 7        |
| 3        | 7        |
| 1        | 6        |
| 3        | 6        |
| 2        | 6        |
+----------+----------+
Output: 
+----------+----------+---------------+
| user1_id | user2_id | common_friend |
+----------+----------+---------------+
| 1        | 2        | 4             |
| 1        | 3        | 3             |
+----------+----------+---------------+
Explanation: 
Users 1 and 2 have 4 common friends (3, 4, 5, and 6).
Users 1 and 3 have 3 common friends (2, 6, and 7).
We did not include the friendship of users 2 and 3 because they only have two common friends (1 and 6).
*/

-- The Bidirectional CTE + Self-Join Method (Clean & Index-Friendly)
-- Step 1: Normalize undirected graph into bidirectional edges (u1 -> u2 and u2 -> u1).
-- Step 2: For each existing friendship (user1_id, user2_id), join all friends of user1
--         with all friends of user2 to find mutual friends (a1.u2 = a2.u2).
-- Step 3: Filter for friendships having at least 3 common friends.
WITH AllFriends AS (
    SELECT user1_id AS u1, user2_id AS u2 FROM Friendship
    UNION ALL
    SELECT user2_id AS u1, user1_id AS u2 FROM Friendship
)
SELECT 
    f.user1_id,
    f.user2_id,
    COUNT(a1.u2) AS common_friend
FROM Friendship f
JOIN AllFriends a1 
    ON f.user1_id = a1.u1
JOIN AllFriends a2 
    ON f.user2_id = a2.u1 
   AND a1.u2 = a2.u2 --this ensures that we only count mutual friends
GROUP BY f.user1_id, f.user2_id
HAVING COUNT(a1.u2) >= 3;
