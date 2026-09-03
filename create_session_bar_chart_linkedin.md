Why an "Easy" SQL problem reveals the gap between interview tricks and production engineering 📊

LeetCode #1435 ("Create a Session Bar Chart") asks you to categorize session durations into 4 custom bins — including returning a count of 0 for empty bins.

At first glance, standard GROUP BY with a CASE expression seems intuitive. But there’s a catch: standard GROUP BY completely drops bins that have 0 occurrences in the data.

Here are two distinct ways to tackle this:

𝟭. The 4x UNION ALL Method (The LeetCode "Easy" Trick)
Run 4 separate SELECT COUNT(*) queries — one per bin — and stitch them together with UNION ALL.
✅ Pros: Uses only elementary SQL syntax (SELECT, WHERE, UNION ALL). Because scalar COUNT(*) without GROUP BY always returns exactly one row (evaluating to 0 on empty matches), it solves the zero-count requirement automatically with zero join boilerplate.
⚠️ Cons: Anti-pattern at scale. It scans the table 4 separate times and requires copy-pasting query blocks for every new bin. If business requirements change from 4 bins to 50 bins, the query quickly becomes an unmaintainable wall of code.

𝟮. The CTE + LEFT JOIN Method (The Data Warehousing Pattern)
Generate a dimension table of bins in a CTE, then LEFT JOIN the fact table against interval bounds.
✅ Pros: Professional, maintainable architecture. Decouples bin definitions from aggregation logic. Adding new bins or fetching bounds dynamically from a configuration table requires zero changes to the query logic.
⚠️ Cons: Requires CTEs, non-equi join conditions (>= min AND < max), and careful handling of COUNT(column) instead of COUNT(*) to avoid counting empty joined rows as 1.

💡 The takeaway:
The 4x UNION ALL approach is a clever shorthand for speed in a timed 20-minute coding screen. But in real-world analytics and data modeling, building a scaffold/dimension dataset and LEFT JOINing is the standard, production-grade pattern for histogram generation.

Which pattern do you prefer to see in interviews — the quick pragmatic hack or the scalable architectural pattern?

#SQL #DataEngineering #DataAnalytics #LeetCode #TechInterview #DatabaseDesign #AnalyticsEngineering #PostgreSQL #MySQL #CleanCode
