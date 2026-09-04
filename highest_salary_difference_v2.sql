/*
Table: Salaries

+-------------+---------+ 
| Column Name | Type    | 
+-------------+---------+ 
| emp_name    | varchar | 
| department  | varchar | 
| salary      | int     |
+-------------+---------+
(emp_name, department) is the primary key (combination of unique values) for this table.
Each row of this table contains emp_name, department and salary. There will be at least one entry for the engineering 
and marketing departments.
Write a solution to calculate the difference between the highest salaries in the marketing and engineering department. 
Output the absolute difference in salaries.

Return the result table.

The result format is in the following example.

 

Example 1:

Input: 
Salaries table:
+----------+-------------+--------+
| emp_name | department  | salary |
+----------+-------------+--------+
| Kathy    | Engineering | 50000  |
| Roy      | Marketing   | 30000  |
| Charles  | Engineering | 45000  |
| Jack     | Engineering | 85000  | 
| Benjamin | Marketing   | 34000  |
| Anthony  | Marketing   | 42000  |
| Edward   | Engineering | 102000 |
| Terry    | Engineering | 44000  |
| Evelyn   | Marketing   | 53000  |
| Arthur   | Engineering | 32000  |
+----------+-------------+--------+
Output: 
+-------------------+
| salary_difference | 
+-------------------+
| 49000             | 
+-------------------+
Explanation: 
- The Engineering and Marketing departments have the highest salaries of 102,000 and 53,000, respectively. 
Resulting in an absolute difference of 49,000.
*/

-- The Scalar Subquery Method (Index Seek Optimal)
-- Evaluates two independent scalar subqueries to fetch the MAX salary for each department.
-- With a composite index on (department, salary DESC), the query engine executes two direct O(log N)
-- index seeks/scans rather than scanning or aggregating across the rest of the table.
SELECT ABS(
    (SELECT MAX(salary) FROM Salaries WHERE department = 'Engineering') -
    (SELECT MAX(salary) FROM Salaries WHERE department = 'Marketing')
) AS salary_difference;
