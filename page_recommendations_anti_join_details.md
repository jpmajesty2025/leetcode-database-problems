# 🔍 Deep Dive: The Anti-Join Pattern (`LEFT JOIN ... WHERE right.col IS NULL`)

An **Anti-Join** is a fundamental relational pattern used to answer:
> *"Give me all rows in Table A that have **NO match** in Table B."*

This document breaks down how the anti-join operates in `page_recommendations_v3__medium__.sql` (LeetCode: Page Recommendations).

---

## 🎯 The Goal

Recommend pages liked by friends of `user_id = 1`, **excluding** pages that `user_id = 1` has already liked.

---

## 🧩 Step-by-Step Execution Trace

### Step 1: Find Friends of User 1 (`User1Friends` CTE)

User 1 can appear as `user1_id` or `user2_id`:
```
Friendship rows with User 1:
- (1, 2) -> Friend is 2
- (1, 3) -> Friend is 3
- (1, 4) -> Friend is 4
- (6, 1) -> Friend is 6
```
**`User1Friends` list:** `[2, 3, 4, 6]`

---

### Step 2: Retrieve Candidate Pages (`Likes JOIN User1Friends`)

Join the `Likes` table with `User1Friends` to see all pages friends have liked:

| `l.user_id` (Friend) | `l.page_id` (Candidate Page) |
| :--- | :--- |
| `2` | **23** |
| `3` | **24** |
| `4` | **56** |
| `6` | **33** |
| `2` | **77** |
| `3` | **77** |
| `6` | **88** |

*(Notice page **88** is in this list because friend `6` likes it).*

---

### Step 3: What Does User 1 Already Like?

From the `Likes` table for `user_id = 1`:
- User 1 likes **only page 88**: `(user_id: 1, page_id: 88)`.

---

### Step 4: The `LEFT JOIN` Mechanism

```sql
LEFT JOIN Likes my_likes 
    ON my_likes.user_id = 1 
   AND my_likes.page_id = l.page_id
```

A `LEFT JOIN` keeps **every row** from the left table (`l`). 
- If a match is found in `my_likes` (`user_id = 1` AND same `page_id`), it populates `my_likes.*` columns.
- If **no match** is found, the database fills all `my_likes.*` columns with **`NULL`**.

#### The Intermediate Joined Table:

| `l.page_id` (Friend's Page) | `my_likes.user_id` | `my_likes.page_id` | Match Status |
| :--- | :--- | :--- | :--- |
| **23** | `NULL` | `NULL` | ❌ No match (User 1 does not like 23) |
| **24** | `NULL` | `NULL` | ❌ No match (User 1 does not like 24) |
| **56** | `NULL` | `NULL` | ❌ No match (User 1 does not like 56) |
| **33** | `NULL` | `NULL` | ❌ No match (User 1 does not like 33) |
| **77** | `NULL` | `NULL` | ❌ No match (User 1 does not like 77) |
| **77** | `NULL` | `NULL` | ❌ No match (User 1 does not like 77) |
| **88** | `1` | `88` | ✅ **Match found!** (User 1 already likes 88) |

---

### Step 5: The Filtering Clause (`WHERE my_likes.page_id IS NULL`)

```sql
WHERE my_likes.page_id IS NULL
```

The `WHERE` clause filters out the matches (which would have been kept in an `INNER JOIN`) and **only retains the unmatched NULL leftovers**:

- **Kept:** Pages `23`, `24`, `56`, `33`, `77` (where `my_likes.page_id IS NULL`).
- **Discarded:** Page `88` (where `my_likes.page_id` is `88`, NOT NULL).

After applying `DISTINCT` to deduplicate page `77`, the final result is:
`[23, 24, 56, 33, 77]`

---

## 💡 Why Prefer Anti-Joins over `NOT IN`?

1. **NULL Safety:** If a subquery used in `WHERE col NOT IN (SELECT ...)` contains even a single `NULL`, the entire condition evaluates to `UNKNOWN` and returns zero rows. Anti-joins (`LEFT JOIN ... WHERE ... IS NULL` or `NOT EXISTS`) are immune to this pitfall.
2. **Planner Optimization:** Relational query planners (like PostgreSQL) can transform `LEFT JOIN ... WHERE ... IS NULL` directly into a high-performance **Hash Anti-Join** or **Merge Anti-Join**, which stops looking on the right side as soon as a single match is encountered.
