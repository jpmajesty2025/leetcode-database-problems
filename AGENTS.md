# Project Agent Guidelines & Conventions

## 🐘 SQL Dialect Standard: PostgreSQL
All SQL queries across this repository must be written strictly for **PostgreSQL** unless explicitly requested otherwise.

### Key PostgreSQL Dialect Rules to Follow:
1. **Date / Time Arithmetic:**
   - Use `date_column + INTERVAL '1 day'` or `date_column + 1` instead of MySQL's `DATE_ADD(...)` / `DATEDIFF(...)`.
   - Use `EXTRACT(FIELD FROM col)` (e.g. `EXTRACT(HOUR FROM call_time)::INT`) or `DATE_PART('field', col)` instead of `HOUR(...)`, `YEAR(...)`, `MONTH(...)`.
2. **Division and Rounding:**
   - Integer division truncates in PostgreSQL (`int / int = int`). Always cast the numerator or denominator with `::NUMERIC` / `::FLOAT` or multiply by `1.0` before dividing: e.g. `ROUND(COUNT(a)::NUMERIC / COUNT(b), 2)`.
   - `ROUND(val::NUMERIC, s)` requires `numeric` input in PostgreSQL.
3. **String Concatenation & Functions:**
   - Use standard `||` or `CONCAT(...)`.
   - Use `SUBSTRING(...)` or `LEFT(...)` / `RIGHT(...)`.
4. **Window Functions & Ranking:**
   - Utilize standard PostgreSQL window functions (`RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, `LEAD()`, `LAG()`).
5. **Code Style & Formatting:**
   - Uppercase SQL keywords (`SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`, `WITH`, `JOIN`, `ON`).
   - Clean indentation and readable CTE aliases.
   - Include the problem description comment header in problem `.sql` files.
