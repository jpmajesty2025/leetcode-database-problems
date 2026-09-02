Three ways to find the "second highest salary" in SQL — and why most of them silently break on edge cases 🔍

This is a classic SQL interview question (LeetCode #176), but the real lesson isn't the query — it's what happens when the "obvious" answer meets an edge case: a table with only one distinct salary, or an empty table. The spec says: return NULL when there's no second highest salary. Here's how three common approaches hold up.

𝟭. 𝗪𝗪 The Subquery Method
Filter for the max salary below the overall max, then take MAX() of what's left.
✅ Pros: Simple, index-friendly (a single index on salary makes this fast), and naturally returns NULL when no qualifying row exists — because MAX() over zero rows evaluates to NULL, not an error and not an empty result set.
⚠️ Cons: Doesn't generalize well if you need the Nth highest salary — you'd end up nesting subqueries.

𝟮. The LIMIT / OFFSET Method
DISTINCT the salaries, sort descending, skip the first one, take the next.
✅ Pros: Reads very naturally — "give me the 2nd row" — and is intuitive for anyone coming from a spreadsheet mindset.
⚠️ Cons: This is the one that bites people. LIMIT 1 OFFSET 1 returns zero rows (not a NULL row) when there's no second distinct salary. That fails the NULL requirement outright. It needs to be wrapped in IFNULL/COALESCE to force a single NULL row when the inner query comes up empty. Also, OFFSET is non-standard across engines (SQL Server needs OFFSET...FETCH, not LIMIT).

𝟯. The Window Function Method (DENSE_RANK)
Rank every row by salary descending, then filter for rank = 2.
✅ Pros: The most powerful and flexible option — same pattern scales to "2nd highest per department," Nth highest, or top-K queries. Correctly handles duplicate salaries by giving them the same rank (unlike ROW_NUMBER, which would skip them).
⚠️ Cons: Same trap as #2 — filtering WHERE rnk = 2 returns zero rows if no rank-2 salary exists. You still need to wrap it in an outer MAX() (or IFNULL) to guarantee a single-row NULL result. It's also the most computationally expensive of the three for very large tables, since it materializes a rank over the entire dataset.

𹴠The takeaway: writing SQL that gets the right answer on your test data is the easy part. Writing SQL that also produces the *correct null/empty-set behavior* the spec demands is where interviews (and production bugs) are actually won or lost.

Which approach do you reach for first, and why?

#SQL #DataEngineering #LeetCode #TechInterview #Postgres #MySQL #DataAnalytics #BackendDevelopment #DatabaseDesign #WindowFunctions
