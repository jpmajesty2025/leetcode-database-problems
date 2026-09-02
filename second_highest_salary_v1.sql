/*
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| salary      | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of an employee and their salary.
 

Write a solution to find the second highest salary of all employees. If there is no second highest salary, return null.

Return the result table in any order.
*/

-- The Subquery Method (Universal & Safest for Duplicates)
SELECT MAX(salary) AS SecondHighestSalary 
FROM Employee 
WHERE salary < (SELECT MAX(salary) FROM Employee);
