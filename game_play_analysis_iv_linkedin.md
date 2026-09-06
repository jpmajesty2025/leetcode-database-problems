# 📊 Calculating Day-1 Retention in SQL: Self-Join vs. Window Functions 🎮

Day-1 retention is one of the most critical product and growth metrics. But how do you write it cleanly and performantly in SQL?

Let's look at **LeetCode 550: Game Play Analysis IV**, where we need to find the fraction of players who returned exactly the day after their very first login.

Here are the two top architectural patterns to solve it, their pros/cons, and when to pick which! 👇

---

## 🎯 The Core Logic

1. Find each player's **first login date**.
2. Check if there exists an activity record on `first_login_date + 1 day`.
3. Compute: `(Players retained on Day 1) / (Total distinct players)`.

---

## 🛠️ Approach A: Aggregation + LEFT JOIN

Find the initial login per player in a CTE, then `LEFT JOIN` back to the activity log on `day + 1`.

```sql
WITH FirstLogin AS (
    SELECT 
        player_id,
        MIN(event_date) AS first_login_date
    FROM Activity
    GROUP BY player_id
)
SELECT 
    ROUND(
        COUNT(a.player_id)::NUMERIC / COUNT(f.player_id), 
        2
    ) AS fraction
FROM FirstLogin f
LEFT JOIN Activity a 
    ON f.player_id = a.player_id 
   AND a.event_date = f.first_login_date + INTERVAL '1 day';
```

### ✅ Pros:
- **Intuitive & Readable**: Easy to reason about—one table represents cohort size, joined with next-day activity.
- **No `COUNT(DISTINCT)` overhead**: Since `FirstLogin` already has 1 row per player, plain `COUNT(a.player_id) / COUNT(f.player_id)` works seamlessly without expensive deduplication hashing.
- **Index Friendly**: If `(player_id, event_date)` is indexed (e.g., as primary key), the `LEFT JOIN` uses direct point lookups (`O(log N)`).

### ❌ Cons:
- Involves two passes over the `Activity` table (one for `GROUP BY` and one for the `JOIN`).

---

## ⚡ Approach B: Window Functions (No Joins)

Calculate `MIN(event_date)` as a window function across the dataset, then do conditional aggregation.

```sql
WITH ActivityWithFirstLogin AS (
    SELECT 
        player_id,
        event_date,
        MIN(event_date) OVER (PARTITION BY player_id) AS first_login_date
    FROM Activity
)
SELECT 
    ROUND(
        COUNT(DISTINCT CASE 
            WHEN event_date = first_login_date + INTERVAL '1 day' 
            THEN player_id 
        END)::NUMERIC / COUNT(DISTINCT player_id),
        2
    ) AS fraction
FROM ActivityWithFirstLogin;
```

### ✅ Pros:
- **Zero Joins**: Avoids table join overhead entirely.
- **Single Pass / Streaming**: The database scans the table once while computing the window frame.

### ❌ Cons:
- **`COUNT(DISTINCT)` Cost**: Since the CTE keeps all original activity rows, we must perform `COUNT(DISTINCT player_id)` in the numerator and denominator, which requires sorting or hash sets.
- **Memory Consumption**: For players with thousands of login events, window partition buffers can consume significant memory before the final aggregation.

---

## ⚖️ When to Use Which?

| Scenario | Preferred Pattern | Why |
| :--- | :--- | :--- |
| **Indexed Relational OLTP (PostgreSQL, MySQL)** | **Approach A (LEFT JOIN)** | B-Tree index on `(player_id, event_date)` makes the join extremely fast; avoids costly `COUNT(DISTINCT)`. |
| **Massive User History (Long retention windows)** | **Approach A (LEFT JOIN)** | Aggregating `MIN()` first shrinks rows down to 1 per user before joining. |
| **Distributed OLAP / Data Lakes (Snowflake, BigQuery, ClickHouse)** | **Approach B (Window Functions)** | Shuffled joins can be expensive across cluster nodes; distributed engines excel at partitioned window scans. |

---

💬 What’s your default pattern for cohort retention queries in production? Do you lean towards window functions or CTE joins?

#SQL #DataEngineering #PostgreSQL #MySQL #DataAnalytics #DataScience #LeetCode #DatabaseOptimization
