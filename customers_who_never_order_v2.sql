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

-- The LEFT JOIN + IS NULL Method (Anti-Join)
-- NULL-safe by construction: unmatched Customers rows get NULL for all Orders columns,
-- so filtering on o.id IS NULL (a non-nullable primary key) reliably finds customers with
-- no matching order, regardless of NULLs in Orders.customerId. Most query planners optimize
-- this into an efficient anti-join execution plan (e.g. Postgres executes this as a Hash Anti
-- Join), making it one of the fastest of the four approaches on large tables.
-- Source: https://www.crunchydata.com/blog/rise-of-the-anti-join
select c.name as Customers
from Customers c
left join Orders o
on c.id = o.customerId
where o.id is null