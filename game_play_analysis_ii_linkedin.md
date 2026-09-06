# 🥊 The "Top-1 Per Group" SQL Showdown: 4 Paradigms Tested 🚀

Retrieving the first or latest record per entity (the classic "Top-1 per group" pattern) appears everywhere—first login device, latest account status, most recent transaction.

Let’s analyze **LeetCode 512: Game Play Analysis II** (finding the device used during each player's very first login) to break down **4 distinct approaches** (see the ray.so graphic for side-by-side SQL 📸):

---

### ❌ 1. The Original Antipattern: Correlated Subquery in `WHERE`
Filtering by `event_date = (SELECT MIN(event_date) FROM ... WHERE a1.player_id = a2.player_id)`.

**Why it hurts in production:**
- **$O(N \times K)$ Nested Loop Evaluation:** The database executes a `SubPlan` lookup for *every single row* in the outer table.
- **Wasted CPU on Dead Rows:** If a user has 500 login events, 499 of them execute a subquery only to evaluate to `FALSE`.

---

### 🐘 2. The PostgreSQL Speed King: `DISTINCT ON`
`SELECT DISTINCT ON (player_id) ... ORDER BY player_id, event_date ASC`.

**Under the Hood:**
- **Zero Joins & Zero Subqueries:** Evaluates grouping and ordering in a single streaming scan.
- **Skip-Scan Superpower:** With a composite index on `(player_id, event_date ASC)`, Postgres reads the first entry for a player and immediately skips ahead to the next `player_id` block.
- **Trade-Off:** PostgreSQL-exclusive syntax; not portable to Snowflake, MySQL, or BigQuery.

---

### 🏆 3. The Enterprise Standard: Window Functions (`ROW_NUMBER`)
Ranking rows with `ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date ASC)` in a CTE, then filtering `WHERE rn = 1`.

**Under the Hood:**
- **ANSI Standard & Universal:** Runs identically across Postgres, BigQuery, Snowflake, Redshift, and MySQL 8+.
- **Single Pass / Window Aggregation:** Partitions and assigns row numbers in one pass ($O(N \log N)$ sort, or $O(N)$ with an index).
- **Flexibility:** Effortlessly adapts from "Top-1" to "Top-N" (e.g. `rn <= 3` or `DENSE_RANK()` for ties).

---

### 🔄 4. The Set-Based Relational Classic: CTE + `INNER JOIN`
Finding `MIN(event_date)` in a `GROUP BY` CTE, then joining back on `(player_id, event_date)`.

**Under the Hood:**
- **Shrink-Then-Join:** Reduces the dataset to exactly 1 row per user before performing the join.
- **Index Friendly:** Hash Join or Indexed Nested Loop Join back to the base table.
- **Trade-Off:** Requires two distinct table scans (one for aggregation, one for joining).

---

## 📊 Summary Architecture Matrix

| Strategy | Performance in PostgreSQL | Portability Across Engines | Multi-Row Flexibility |
| :--- | :--- | :--- | :--- |
| **1. Correlated Subquery** | 🐢 Slowest ($O(N)$ lookups) | Universal | Poor |
| **2. `DISTINCT ON`** | ⚡ Fastest (Skip Scan) | Postgres Only | Top-1 Only |
| **3. `ROW_NUMBER()`** | 🚀 Very Fast (Streaming) | Universal (ANSI SQL) | Top-N & Ties |
| **4. CTE + `INNER JOIN`** | 🏎️ Fast (Set-Based) | Universal (ANSI SQL) | Top-1 Only |

---

💡 **Rule of Thumb:** 
- In **PostgreSQL**: Reach for `DISTINCT ON` for raw single-table speed on Top-1 queries.
- In **Cross-Engine / Analytics Stacks**: Standardize on `ROW_NUMBER() OVER (...)`.

💬 Which pattern is your team's default for Top-1 queries? Have you benchmarked `DISTINCT ON` vs `ROW_NUMBER()` on your datasets? Let's discuss below! 👇

#SQL #PostgreSQL #DataEngineering #DatabaseOptimization #DataAnalytics #LeetCode #SoftwareEngineering
