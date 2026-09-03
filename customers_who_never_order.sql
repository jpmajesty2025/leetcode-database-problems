/*
Table: Customers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID and name of a customer.
 

Table: Orders

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
customerId is a foreign key (reference columns) of the ID from the Customers table.
Each row of this table indicates the ID of an order and the ID of the customer who ordered it.
 

Write a solution to find all customers who never order anything.

Return the result table in any order.
*/


-- The NOT IN Subquery Method
-- Simple and readable, but NOT NULL-SAFE: if Orders.customerId ever contains a NULL value,
-- the subquery result set includes NULL, which poisons the NOT IN comparison (makes it UNKNOWN
-- for every row) and silently returns zero rows instead of the correct customer list.
-- Safe here only because customerId is a non-nullable foreign key per the stated schema.
SELECT name AS Customers
FROM Customers
WHERE id NOT IN (SELECT customerId FROM Orders);
