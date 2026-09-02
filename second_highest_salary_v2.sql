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
-- The LIMIT and OFFSET Method (Best for MySQL & PostgreSQL)
select ifnull(
  (select distinct salary
   from Employee
   order by salary desc
   limit 1 offset 1),
  null
) as SecondHighestSalary;