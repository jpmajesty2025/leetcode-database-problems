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
-- The Window Function Method (Best for Complex Data or Interviews)
-- If you are asked this in a coding interview or need to find the second highest salary per department, 
-- you should use the DENSE_RANK() window function. It assigns ranks to the rows, ensuring duplicate 
-- salaries receive the exact same rank.

SELECT MAX(salary) AS SecondHighestSalary
FROM (
    SELECT salary, 
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk 
    FROM Employee
) ranked_salaries 
WHERE rnk = 2;
