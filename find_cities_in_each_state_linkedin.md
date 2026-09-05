String Aggregation in SQL: One simple goal, 4 completely different dialects (and 2 dangerous production pitfalls) 🧵

Concatenating grouped rows into a sorted, comma-separated string (LeetCode #3198: "Find Cities in Each State") is a routine reporting task.

Yet string aggregation remains one of the most notoriously fragmented features in modern SQL.

The visual comparison in the image attached shows how PostgreSQL, MySQL, SQL Server, and Oracle/Snowflake solve this exact problem. But behind the syntax differences lie two real production gotchas:

𝟭. The PostgreSQL / DuckDB Pattern (`STRING_AGG`)
Simple inline sorting syntax: `STRING_AGG(city, ', ' ORDER BY city)`.
Because Postgres returns a dynamic `TEXT` type (up to 1GB), you almost never have to worry about buffer overflows or silent truncations.

𝟮. The MySQL / MariaDB Pattern (`GROUP_CONCAT`)
Uses `GROUP_CONCAT(city ORDER BY city SEPARATOR ', ')`.
⚠️ The Production Trap: MySQL caps the output buffer with the `group_concat_max_len` server variable (historically defaulting to just 1,024 characters). If your grouped string exceeds this limit, MySQL doesn't throw an error — it **silently truncates the string**, corrupting downstream reports without warning unless you expand the setting.

𝟯. The Oracle & Snowflake Pattern (`LISTAGG`)
Uses the ANSI-like `LISTAGG(city, ', ') WITHIN GROUP (ORDER BY city)`.
⚠️ The Oracle Trap: Prior to Oracle 19c, exceeding the 4,000-byte `VARCHAR2` limit would throw a hard runtime crash (`ORA-01489: result of string concatenation is too long`). In modern Oracle, you must defensively write `ON OVERFLOW TRUNCATE` to handle large rowsets safely.

𝟰. The SQL Server (T-SQL) Evolution
SQL Server 2017+ introduced `STRING_AGG(...) WITHIN GROUP (ORDER BY ...)`. If you maintained legacy SQL Server code before 2017, you probably remember the infamous `FOR XML PATH('')` subquery gymnastics required just to join a few strings together!

💡 The takeaway:
When writing string aggregations across databases:
- Know the syntax quirks (inline `ORDER BY` vs `WITHIN GROUP`).
- Always check your engine’s buffer limit to prevent silent truncation in production.

Which SQL dialect’s string aggregation syntax do you find cleanest?

#SQL #DataEngineering #PostgreSQL #MySQL #Oracle #Snowflake #SQLServer #DataAnalytics #DatabaseDesign #LeetCode
