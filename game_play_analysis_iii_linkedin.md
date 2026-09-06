# ⚡ 3 Ways to Compute Cumulative Running Totals in SQL (And Why It Matters Under the Hood) 🚀

Calculating a running total per entity is one of the most common requirements in data engineering—from financial ledgers and billing balances to gaming progression.

Let’s analyze **LeetCode 534: Game Play Analysis III** (calculating cumulative games played per player by date) across **3 distinct SQL paradigms** (see the code graphic for side-by-side implementations 📸):

---

### 🏆 1. Window Functions (`SUM() OVER`) — The Gold Standard
In modern engines (PostgreSQL, Snowflake, BigQuery), `SUM() OVER (PARTITION BY ... ORDER BY ...)` is the definitive approach.

**Under the Hood:**
- **Streaming Execution:** The engine sorts by `(player_id, event_date)` (or leverages an index scan) and maintains a running accumulator in a single $O(N)$ pass.
- **`ROWS` vs `RANGE` (The Postgres Nuance):** The ANSI SQL default is `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`. In PostgreSQL, `RANGE` forces the engine to evaluate whether subsequent rows share the same value (peer checking). Specifying `ROWS` skips peer validation and streams directly, saving substantial CPU cycles on large datasets.

---

### 🔄 2. Theta Self-Join (`GROUP BY`) — The Relational Classic
Before ANSI SQL-99 window functions, running totals required joining the table to itself on `a2.event_date <= a1.event_date`.

**Under the Hood:**
- **Cartesian Expansion:** For a player with $K$ login days, this generates $\frac{K(K+1)}{2}$ intermediate rows before aggregating.
- **Workload Impact:** If players have 1,000+ login records, the join explodes to ~500,000 rows per user. This creates severe memory pressure, spills to disk (`work_mem`), and overburdens hash/sort aggregators.
- **When to Use:** Primarily when targeting legacy database engines that lack window function support.

---

### 🎯 3. Correlated Subquery — The Targeted Point-Lookup
Calculates the running sum per row via an inner scalar subquery.

**Under the Hood:**
- **Nested Loop Evaluation:** Evaluates a SubPlan for every outer row. For full-table batch exports, this introduces high per-row dispatch overhead.
- **Index Synergy:** With a covering composite index `(player_id, event_date, games_played)`, each subquery becomes a tight index range scan.
- **When to Favor It:** In transactional APIs or paginated UI views where you only retrieve a single player's recent dates (e.g. `WHERE player_id = 42 LIMIT 10`), avoiding the need to sort and partition the entire dataset.

---

## 📊 Summary Architecture Matrix

| Strategy | Algorithmic Complexity | Memory Footprint | Best Production Use Case |
| :--- | :--- | :--- | :--- |
| **Window (`ROWS`)** | $O(N \log N)$ or $O(N)$ (indexed) | $O(1)$ stream buffer | Full-table batch reports & OLAP |
| **Theta Self-Join** | $O(N \times K)$ rows generated | High (spills on deep history) | Legacy RDBMS compatibility |
| **Correlated Subquery** | $O(N \log K)$ with index | Low | Single-entity / paginated lookups |

---

💡 **Key Takeaway:** For bulk analytics, always default to `SUM() OVER (PARTITION BY ... ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`.

💬 What’s the largest partition size you’ve run window aggregates on? Any performance bottlenecks you’ve hit in production? Let’s discuss below! 👇

#SQL #PostgreSQL #DataEngineering #DatabaseOptimization #DataAnalytics #LeetCode #SoftwareEngineering
