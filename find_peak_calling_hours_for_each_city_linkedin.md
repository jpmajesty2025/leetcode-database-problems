# 📊 SQL Case Study: Finding Peak Calling Hours by City

How do you find the busiest operational hours across different regions—especially when there are ties? 🤔

Here’s a breakdown of a classic SQL analytics problem: **Finding Peak Calling Hours for Each City** (LeetCode Database).

---

## 🎯 The Problem

Given a table of `Calls` containing timestamps (`call_time`) and `city`, find the hour of the day (0–23) with the highest call volume for each city.

**Key Requirements:**
1. Group timestamps into hourly buckets.
2. If multiple hours share the same peak call count within a city, return **all** tied hours.
3. Order the output by `peak_calling_hour DESC` and `city DESC`.

---

## 💡 The Solution Strategy

A clean and scalable way to solve this in modern SQL is pairing **CTEs (Common Table Expressions)** with **Window Functions**:

1. **Extract the Hour**: Use `EXTRACT(HOUR FROM call_time)` (PostgreSQL) or `HOUR(call_time)` (MySQL).
2. **Aggregate Volume**: `GROUP BY city, hour` to count the total calls per hour.
3. **Rank per Partition**: Apply `RANK() OVER (PARTITION BY city ORDER BY COUNT(*) DESC)` to assign rank 1 to the highest volume hour(s) per city. (Using `RANK()` ensures ties are preserved!).
4. **Filter & Format**: Select all rows where `rk = 1`.

---

## 🐘 PostgreSQL Solution

```sql
WITH HourlyCallCounts AS (
    SELECT 
        city,
        EXTRACT(HOUR FROM call_time)::INT AS peak_calling_hour,
        COUNT(*) AS number_of_calls,
        RANK() OVER (
            PARTITION BY city 
            ORDER BY COUNT(*) DESC
        ) AS rk
    FROM Calls
    GROUP BY city, EXTRACT(HOUR FROM call_time)
)
SELECT 
    city,
    peak_calling_hour,
    number_of_calls
FROM HourlyCallCounts
WHERE rk = 1
ORDER BY peak_calling_hour DESC, city DESC;
```

---

## 🔑 Key Takeaways & Tips

- **`RANK()` vs `ROW_NUMBER()`**: When business logic dictates including ties (like equal peak hours), `RANK()` or `DENSE_RANK()` is essential over `ROW_NUMBER()`.
- **Casting in Postgres**: `EXTRACT()` in PostgreSQL returns numeric/float by default—casting `::INT` keeps output data clean and schema-compliant.
- **Real-World Application**: This exact pattern is widely used in call center staffing, server load capacity planning, and ride-share surge pricing analysis.

---

💬 What’s your preferred pattern for ranking within groups—CTEs or Subqueries? Let's discuss in the comments! 👇

#LearningInPublic #SQL #DataEngineering #PostgreSQL #DataAnalytics #LeetCode #Database #ProblemSolving
