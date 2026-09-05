/*
Problem Variation: Maximum Absolute Salary Difference Across Departments

Table: Salaries

+-------------+---------+ 
| Column Name | Type    | 
+-------------+---------+ 
| emp_name    | varchar | 
| department  | varchar | 
| salary      | int     |
+-------------+---------+
(emp_name, department) is the primary key (combination of unique values) for this table.
Each row of this table contains emp_name, department, and salary. There will be at least one entry 
for the Engineering and Marketing departments.

Task:
Calculate the maximum possible absolute difference in salary between any employee in the Engineering 
department and any employee in the Marketing department.

Mathematically, this equals:
    MAX( |MAX(Eng) - MIN(Mkt)|, |MAX(Mkt) - MIN(Eng)| )
which simplifies to:
    GREATEST( MAX(Eng) - MIN(Mkt), MAX(Mkt) - MIN(Eng) )

Return the result table.
*/

-- The Single-Pass Conditional Aggregation Method (Scan-Optimal)
-- Scans the Salaries table exactly once, computing the min and max for both departments
-- in parallel using CASE expressions, then evaluates the maximum cross-department spread.

/* Note: This is optimal ($O(N)$ single-pass scan) for standard table access, and here is why:
1. Scan-Optimal (Single Table Pass):
- Evaluates MAX(Eng), MIN(Eng), MAX(Mkt), and MIN(Mkt) simultaneously during a single sequential or 
clustered index scan over the rows matching department IN ('Engineering', 'Marketing').
- Avoids creating intermediate CTE materializations, subqueries, or cross joins.
2. Mathematical Simplification:
- Because MAX(A) is by definition $\ge \text{MIN}(B)$ if $A$ has any elements $\ge B$'s minimum, 
the terms MAX(Eng) - MIN(Mkt) and MAX(Mkt) - MIN(Eng) are strictly positive (or 0). Using GREATEST(...) 
directly eliminates the need for redundant ABS() calls.
3. Index Considerations ($O(\log N)$ alternative):
- If a composite B-Tree index on (department, salary) exists, a set of 4 scalar subqueries (SELECT MAX/MIN ...) 
can do 4 direct index seeks. But for general queries and typical table scans, the single-pass conditional 
aggregation is considered the cleanest and most robust production pattern. */

SELECT GREATEST(
    MAX(CASE WHEN department = 'Engineering' THEN salary END) - 
    MIN(CASE WHEN department = 'Marketing' THEN salary END),
    MAX(CASE WHEN department = 'Marketing' THEN salary END) - 
    MIN(CASE WHEN department = 'Engineering' THEN salary END)
) AS max_salary_diff
FROM Salaries 
WHERE department IN ('Engineering', 'Marketing');
