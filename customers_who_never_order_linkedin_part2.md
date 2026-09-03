The fastest way to find "rows in A not in B" — and why it's also the safest 🚀

Follow-up to my last post on the classic "find customers who never ordered" SQL pattern (LeetCode #183). We covered why NOT IN can silently return wrong results (NULL-poisoning) and why it can be brutally slow on large tables. Today: the two patterns that solve both problems at once.

𝟭. The LEFT JOIN + IS NULL Method (Anti-Join)
Join Customers to Orders, then keep only rows where the join found no match.
✅ NULL-safe by construction — unmatched rows simply get NULL for every Orders column, so checking a non-nullable primary key (o.id IS NULL) reliably detects "no match," regardless of NULLs elsewhere.
✅ Fast: in the Crunchy Data benchmark on two 1M-row tables, this ran in ~850ms — about 3x faster than the EXCEPT approach — because the planner recognizes the pattern and compiles it into a genuine Hash Anti Join, probing a single hash table instead of repeatedly rescanning data.

𝟮. The NOT EXISTS Method
For each customer, check whether a correlated subquery finds any matching order.
✅ Also NULL-safe — it only cares whether a matching row exists, so NULLs in the foreign key column can't poison it.
✅ Tied for fastest in the same benchmark (~850ms), and arguably the most self-documenting of all the patterns: it reads exactly as "a customer for which no order exists." Most engines (Postgres included) compile it into the same efficient anti-join plan as LEFT JOIN + IS NULL.

💡 The takeaway: LEFT JOIN + IS NULL and NOT EXISTS aren't just "safer" alternatives to NOT IN — in real benchmarks they're the fastest correct options, full stop. If your query optimizer recognizes the anti-join shape, it can skip materializing and rescanning entirely and go straight to a hash-based lookup. Next time you reach for NOT IN, consider reaching for one of these instead — same intent, better guarantees, better performance.

Which one do you reach for by default — LEFT JOIN or NOT EXISTS?

#SQL #DataEngineering #LeetCode #TechInterview #Postgres #MySQL #DataAnalytics #QueryOptimization #DatabaseDesign #BackendDevelopment
