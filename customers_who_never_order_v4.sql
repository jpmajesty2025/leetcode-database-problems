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

-- The EXCEPT Set-Based Method
-- NULL-safe: EXCEPT (like all set operators) treats NULL as comparable to itself for the
-- purposes of duplicate elimination, so a NULL customerId row simply won't match any
-- Customers.id and won't poison the result the way NOT IN does.
-- Performance: a solid middle ground. Requires both sides to have identical column
-- shape (here just id/name vs id), so we select just the id first and join back to get the
-- name. Its plan appends both inputs, sorts for duplicates, then keeps non-matches -- correct
-- and much faster than NOT IN's per-row rescan, but still slower than the LEFT JOIN/NOT EXISTS
-- anti-join plans (roughly 3x slower in benchmarks on large tables), since it must sort/hash
-- the full combined set rather than probing a single hash table.
-- Source: https://www.crunchydata.com/blog/rise-of-the-anti-join
SELECT name AS Customers
FROM Customers
WHERE id IN (
    SELECT id FROM Customers
    EXCEPT
    SELECT customerId FROM Orders
);
