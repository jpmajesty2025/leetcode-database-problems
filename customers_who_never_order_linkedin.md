Your "NOT IN" query has a hidden timebomb 💣 (and it's not just about NULLs)

Classic SQL pattern (LeetCode #183): find customers with no matching order. The "obvious" way to write it — NOT IN — has TWO separate ways to fail, and I only realized the second one after reading a great Crunchy Data writeup on anti-joins.

𝟭. The NOT IN Subquery Method
SELECT customers whose id isn't in the set of customerIds from Orders.
⚠️ Failure #1 — correctness: NOT IN is not NULL-safe. If Orders.customerId ever contains a single NULL, the comparison becomes UNKNOWN for every row, and the query silently returns zero rows. No error. Just a wrong, empty answer. And a foreign key alone does NOT guarantee non-nullability — you need an explicit NOT NULL constraint on top of it, or this can happen in production.
⚠️ Failure #2 — performance: even when it's correct, it can be catastrophic on large tables. Crunchy Data benchmarked this on two 1M-row tables and the query never finished. Why? The planner materializes the ENTIRE subquery result into memory and rescans it once per row of the outer table — effectively a nested loop over a million-row set, repeated a million times.

𝟮. The EXCEPT Set-Based Method
Use SQL's set-operator EXCEPT to express "everything in Customers except everything referenced in Orders."
✅ NULL-safe, and in the same benchmark it ran in ~2.3 seconds — light-years better than NOT IN, and correct regardless of nullability.
⚠️ Still not the fastest option: the plan appends both inputs, sorts them for duplicates, then filters — a real "big hammer" that touches and sorts the full combined dataset rather than probing a single hash lookup.

💡 The takeaway: if you've ever reached for NOT IN as a quick "find missing rows" pattern, it's worth a second look — not just for the NULL edge case, but because the query plan itself can be the difference between milliseconds and minutes at scale. EXCEPT is a safer fallback, but as I'll cover in a follow-up post, there's an even faster pattern still.

Have you ever had a NOT IN query quietly return the wrong (empty) result, or blow past its expected runtime?

#SQL #DataEngineering #LeetCode #TechInterview #Postgres #MySQL #DataAnalytics #QueryOptimization #DatabaseDesign #BackendDevelopment
