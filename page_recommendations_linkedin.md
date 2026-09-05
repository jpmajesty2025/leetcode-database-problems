Building a Social Recommendation Engine in SQL: 3 ways to query collaborative filtering 🎯

Collaborative filtering - "recommend pages your friends like that you haven't liked yet" - combines two classic SQL challenges: undirected social graph traversal and relational set exclusion.

The visual comparison in the attached image breaks down three distinct implementations. Here is how they stack up on readability, indexing, and execution plans:

𝟭. The CTE + NOT IN Subquery Method (Modular & Intuitive)
First, gather the target user's friends with a UNION CTE, join to the Likes table to gather candidate pages, and exclude already-liked pages with a NOT IN subquery.
✅ Pros: Clean, step-by-step modular pipeline. Because `page_id` is part of a composite primary key (guaranteed NOT NULL), the classic NOT IN NULL-poisoning risk is completely eliminated here.
⚠️ Cons: Requires maintaining a multi-step CTE and subquery structure.

𝟮. The CASE Subquery Method (Single Friendship Scan)
Instead of two UNION branches, use a single query on the Friendship table with `WHERE user1_id = 1 OR user2_id = 1` and a `CASE` expression to dynamically return whichever column holds the friend's ID.
✅ Pros: Highly compact — touches the Friendship table in a single scan without CTE boilerplate.
⚠️ Cons: The `OR` predicate in the subquery's WHERE clause can prevent the optimizer from using index seeks effectively on large friendship graphs, leading to a full table scan.

𝟯. The Pure JOIN + Anti-Join Method (Optimizer-Friendly)
Normalizes friends in a CTE, inner joins to Likes for candidate pages, and executes a LEFT JOIN on the target user's likes with `WHERE my_likes.page_id IS NULL`.
✅ Pros: The most relational and engine-friendly pattern. Most modern query planners (Postgres, MySQL, Snowflake) recognize this structure immediately and compile it into an ultra-fast Hash Join + Hash Anti-Join pipeline.
⚠️ Cons: Slightly more verbose join conditions compared to the subquery alternatives.

💡 The takeaway:
- For readability and modularity: CTE + NOT IN is clean and safe when primary keys guarantee non-nullability.
- For maximum query optimizer predictability at scale: Pure JOIN + Anti-Join (LEFT JOIN ... IS NULL) gives the planner the best path to construct hash anti-joins.

Which pattern fits best into your data modeling and reporting pipelines?

#LearningInPublic #SQL #DataEngineering #SocialNetwork #RecommendationSystems #DatabaseDesign #QueryOptimization #PostgreSQL #MySQL #LeetCode #DataAnalytics
