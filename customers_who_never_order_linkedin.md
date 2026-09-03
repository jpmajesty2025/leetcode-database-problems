Three ways to find "customers who never ordered" — and only two of them are safe 🚨

Another classic SQL pattern (LeetCode #183): find rows in one table with no matching row in another. It sounds trivial, but the most common way people write it has a hidden landmine that only goes off when your data has NULLs.

𝟭. The NOT IN Subquery Method
Select customers whose id isn't in the set of customerIds from Orders.
✅ Pros: The most concise, most "obvious" way to write it — reads almost like English.
⚠️ Cons: Not NULL-safe. If the subquery (SELECT customerId FROM Orders) ever returns even one NULL, the NOT IN comparison becomes UNKNOWN for every single row, and the query silently returns zero rows — no error, just a wrong empty result. It works perfectly on clean data and then quietly breaks the day someone inserts an order with a NULL customerId.

𝟮. The LEFT JOIN + IS NULL Method (Anti-Join)
Join Customers to Orders, then keep only the rows where the join found nothing.
✅ Pros: NULL-safe by construction — unmatched rows simply get NULL on the Orders side, and checking a non-nullable primary key (o.id IS NULL) is a reliable way to detect "no match." Query planners are very good at optimizing this into an efficient anti-join.
⚠️ Cons: Slightly more verbose than option 1, and the intent ("find missing matches") is implicit in the WHERE clause rather than stated directly.

𝟯. The NOT EXISTS Method
For each customer, check whether a correlated subquery finds any matching order.
✅ Pros: NULL-safe, same as the LEFT JOIN approach — NOT EXISTS only cares about row existence, so NULLs in the foreign key column can never poison it. Arguably the most explicit and self-documenting of the three: it reads exactly as "a customer for which no order exists." Most engines optimize this into an efficient semi-join/anti-join plan, often on par with or faster than the LEFT JOIN version, especially with an index on the joined column.
⚠️ Cons: Slightly less common in everyday reporting SQL than a LEFT JOIN, so it can look a touch less familiar at first glance — though any experienced SQL reader will recognize it instantly.

💡 The takeaway: NOT IN is the pattern most people reach for first, but it's the one to be most careful with. Whenever the "excluded" column could ever contain a NULL, prefer LEFT JOIN + IS NULL or NOT EXISTS — they express the same "no matching row" logic without the silent-failure risk.

Which of these do you default to, and has NOT IN ever bitten you in production?

#SQL #DataEngineering #LeetCode #TechInterview #Postgres #MySQL #DataAnalytics #BackendDevelopment #DatabaseDesign #QueryOptimization
