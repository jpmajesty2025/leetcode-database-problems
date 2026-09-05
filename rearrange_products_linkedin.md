Three ways to "Unpivot" data in SQL — from quick LeetCode hacks to single-pass production queries 🔄

Unpivoting wide columns into normalized rows (e.g. converting `store1`, `store2`, `store3` columns into `(store, price)` pairs in LeetCode #1795) is one of the most common data wrangling tasks in analytics and ETL pipelines.

Depending on your database engine and data scale, there are three distinct ways to solve it:

𝟭. The UNION ALL Method (The Universal Pattern)
Query each column separately with a WHERE clause filtering out NULLs, then stack the results using UNION ALL.
✅ Pros: Universally supported across every SQL dialect (SQLite, MySQL, Postgres, BigQuery, etc.). Extremely simple to write and understand.
⚠️ Cons: Performs N separate table scans (one scan per unpivoted column). With 3 stores on a toy dataset, it's trivial; with 30 columns on a 10M-row fact table, scanning the base table 30 times creates massive I/O bottlenecks.

𝟮. The CROSS JOIN LATERAL / VALUES Method (The Single-Pass Powerhouse)
Scan the base table once, then expand each row into a virtual set of key-value tuples using a LATERAL join or inline VALUES list.
✅ Pros: True single table scan ($O(N)$). The database reads the table once and streams out unpivoted rows in-memory. Highly performant and scalable for large datasets in Postgres, DuckDB, Trino, and modern MySQL.
⚠️ Cons: Requires dialect support for LATERAL joins or row constructors; slightly higher learning curve for junior developers.

𝟯. The Native UNPIVOT Operator (The Declarative Standard)
Use the built-in relational UNPIVOT operator to rotate columns directly in the FROM clause.
✅ Pros: The most concise and declarative syntax. Built-in relational engine optimizations, and automatically strips out NULLs by default without extra WHERE predicates.
⚠️ Cons: Dialect-specific — standard in Oracle, SQL Server (T-SQL), Snowflake, and BigQuery, but not natively supported in standard SQLite or open-source Postgres (where LATERAL is used instead).

💡 The takeaway:
- For quick interview questions or cross-dialect scripts: UNION ALL gets the job done instantly.
- For high-volume production ETL: Avoid N-pass table scans — reach for CROSS JOIN LATERAL or native UNPIVOT for single-pass efficiency.

Which unpivot pattern do you use most in your daily data stack?

#SQL #DataEngineering #ETL #DatabaseDesign #AnalyticsEngineering #PostgreSQL #Snowflake #BigQuery #QueryOptimization #LeetCode
