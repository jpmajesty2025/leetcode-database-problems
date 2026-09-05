/*
Table: cities

+-------------+---------+
| Column Name | Type    | 
+-------------+---------+
| state       | varchar |
| city        | varchar |
+-------------+---------+
(state, city) is the primary key (combination of columns with unique values) for this table.
Each row of this table contains the state name and the city name within that state.
Write a solution to find all the cities in each state and combine them into a single comma-separated string.

Return the result table ordered by state and city in ascending order.

The result format is in the following example.

 

Example:

Input:

cities table:

+-------------+---------------+
| state       | city          |
+-------------+---------------+
| California  | Los Angeles   |
| California  | San Francisco |
| California  | San Diego     |
| Texas       | Houston       |
| Texas       | Austin        |
| Texas       | Dallas        |
| New York    | New York City |
| New York    | Buffalo       |
| New York    | Rochester     |
+-------------+---------------+
Output:

+-------------+---------------------------------------+
| state       | cities                                |
+-------------+---------------------------------------+
| California  | Los Angeles, San Diego, San Francisco |
| New York    | Buffalo, New York City, Rochester     |
| Texas       | Austin, Dallas, Houston               |
+-------------+---------------------------------------+
Explanation:

California: All cities ("Los Angeles", "San Diego", "San Francisco") are listed in a comma-separated string.
New York: All cities ("Buffalo", "New York City", "Rochester") are listed in a comma-separated string.
Texas: All cities ("Austin", "Dallas", "Houston") are listed in a comma-separated string.
Note: The output table is ordered by the state name in ascending order.
*/

-- The MySQL / MariaDB Method (GROUP_CONCAT)
-- Concatenates city names per state with custom separator and ordering.
-- ⚠️ Production Pitfall: Output is subject to the `group_concat_max_len` system variable
-- (defaults to 1024 characters in older versions/MariaDB), which silently truncates long strings!
SELECT 
    state, 
    GROUP_CONCAT(city ORDER BY city SEPARATOR ', ') AS cities
FROM cities
GROUP BY state
ORDER BY state;
