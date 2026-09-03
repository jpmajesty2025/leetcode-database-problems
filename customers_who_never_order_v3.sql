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

-- The NOT EXISTS Method (NULL-Safe & Explicit Intent)
-- Like the LEFT JOIN approach, this is NULL-safe: NOT EXISTS evaluates the correlated
-- subquery per-row and only cares about whether a matching row exists, so NULLs in
-- Orders.customerId can never poison the result (unlike NOT IN). Reads very explicitly
-- as "customer for which no order exists," and most engines optimize it into an
-- efficient anti-join/semi-join plan (e.g. Postgres Hash Anti Join), tying LEFT JOIN + IS NULL
-- as the fastest of the four approaches on large tables.
-- Source: https://www.crunchydata.com/blog/rise-of-the-anti-join
SELECT name AS Customers
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customerId = c.id
);
