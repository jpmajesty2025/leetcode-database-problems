Solving Graph & Triangle Problems in SQL without blowing up your query planner 🕸️

Finding "mutual friends" or calculating social network density (like LeetCode #1949: "Strong Friendship") is a classic graph problem.

The task: given an undirected friendship table, find all pairs of friends who share at least 3 common friends (finding 3-cliques / triangles in a social graph).

Here is why naive SQL solutions break down on graph problems, and the mental model that keeps queries clean and performant:

🛑 The "OR-Join" Anti-Pattern
Because friendship is undirected, the table usually stores only one row per relationship where user1_id < user2_id.
A common instinct is to join the table to itself using massive OR conditions (`ON f1.user1 = f2.user1 OR f1.user1 = f2.user2...`).
Why this hurts:
- OR join predicates destroy index usability (the planner falls back to Cartesian scans).
- Combinatorial edge cases: it is exceedingly easy to accidentally double-count or miss mutual friends depending on which column ID is smaller.

✅ The Solution: Normalize into Bidirectional Edges First
Instead of wrestling with asymmetric pairs, solve it in three clean steps:

𝟭. Bidirectional View (CTE)
Double the edges using `UNION ALL` (`u1 → u2` and `u2 → u1`). This creates a normalized adjacency list where every user's friends are in a single lookup column.

𝟮. Triangle Join
Iterate over the original `Friendship` table pairs `(user1, user2)`. Join `AllFriends` on `user1` and again on `user2`, matching where `a1.u2 = a2.u2` (the mutual friend).

𝟯. Aggregate & Filter
`COUNT(mutual_friend)` grouped by the original pair, filtering with `HAVING COUNT(...) >= 3`.

💡 So what did we learn?
When querying undirected graphs in relational SQL, **never write complex OR joins across symmetric columns**. Instead,  normalize the graph into bidirectional edges in a CTE or staging table first. You turn complex combinatorial joins into clean, indexable equi-joins ($O(N)$ hash/merge joins).

How do you typically model and query undirected graph networks in your data warehouse?

#LearningInPublic #SQL #DataEngineering #GraphAlgorithms #SocialNetwork #DatabaseDesign #QueryOptimization #PostgreSQL #DataAnalytics #LeetCode #TechInterview
