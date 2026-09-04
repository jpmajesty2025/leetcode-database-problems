Single-pass scan vs index seeks: Which SQL pattern actually scales? ⚖️

When calculating the difference between two department peaks (like the max Engineering vs Marketing salary in LeetCode #2853), the query seems simple. But how you write the SQL fundamentally changes how the database engine executes it.

Here is a breakdown of two popular implementations and the indexing tradeoffs behind them:

𝟭. The Conditional Aggregation Method (Single Pass)
Filter for both departments and compute both maxes inside a single SELECT using MAX(CASE WHEN ...).
✅ Pros: Performs a single pass over the table. If you have an unindexed table or a clustered scan, the engine touches the dataset only once to aggregate both numbers simultaneously.
⚠️ Cons: Without a targeted index, it must scan every row matching the WHERE condition and evaluate conditional branches for each row.

𝟮. The Scalar Subquery Method (Targeted Lookups)
Write two independent scalar subqueries — one for Engineering, one for Marketing — and subtract them inside ABS().
✅ Pros: Unbeatable when supported by an index on (department, salary DESC). Instead of scanning rows, the engine performs two direct O(log N) B-Tree seeks directly to the max salary leaf for each department. Execution time is virtually instant regardless of table size (100 rows or 100M rows).
⚠️ Cons: If the table is NOT properly indexed, the database may execute two separate full table scans instead of one.

💡 The takeaway:
There is no universally "faster" SQL query without understanding the underlying physical schema:
- No index on department/salary? → Conditional Aggregation (Single-pass scan wins).
- Composite index on (department, salary)? → Scalar Subqueries (Index seeks win by a landslide).

Designing high-performance SQL isn't just about syntax — it's about aligning your query structure with the indexing strategy.

Which approach do you write by default when computing cross-category metrics?

#SQL #DataEngineering #DatabaseDesign #QueryOptimization #PostgreSQL #MySQL #PerformanceTuning #BackendDevelopment #LeetCode #TechInterview
