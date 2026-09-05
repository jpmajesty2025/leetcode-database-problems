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

-- The Oracle / SQL Server / Snowflake Method (LISTAGG / STRING_AGG with WITHIN GROUP)
-- ANSI SQL standard-aligned syntax for string aggregation across analytical databases.

-- Option A: Oracle / Snowflake (LISTAGG)
-- ⚠️ Oracle Pitfall: Throws ORA-01489 error if string exceeds 4000 bytes (fixed in 19c+ with ON OVERFLOW TRUNCATE).
SELECT 
    state, 
    LISTAGG(city, ', ') WITHIN GROUP (ORDER BY city) AS cities
FROM cities
GROUP BY state
ORDER BY state;

-- Option B: T-SQL / SQL Server 2017+ (STRING_AGG with WITHIN GROUP)
-- ⚠️ SQL Server Note: Prior to 2017, required the infamous FOR XML PATH('') hack!
-- SELECT 
--     state, 
--     STRING_AGG(city, ', ') WITHIN GROUP (ORDER BY city) AS cities
-- FROM cities
-- GROUP BY state
-- ORDER BY state;
