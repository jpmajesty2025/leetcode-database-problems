# 🌲 Understanding B-Trees and $O(\log N)$ Index Seeks in Relational Databases

A deep-dive on how B-Tree indexes work under the hood and why creating an index on `(department, salary DESC)` turns full table scans into sub-millisecond point lookups.

---

## 1. What is a B-Tree?

A **B-Tree (Balanced Tree)** is a self-balancing, multi-way search tree optimized for block-based storage (disk and memory buffers).

```
                      [ Root Node ]
                     /      |      \
              [ Branch ] [ Branch ] [ Branch ]
              /   |   \   /   |   \   /   |   \
            [Leaf] [Leaf] [Leaf] [Leaf] [Leaf]... (Data Pointers)
```

### Key Properties:
1. **High Fan-Out (Multi-Way Branching):** Unlike a binary search tree (where each node has only 2 children), each B-Tree node typically holds **hundreds** of keys and child pointers (often 100 to 500+).
2. **Balanced Height:** Every path from the root node down to the leaf level is guaranteed to have the exact same depth (height $H$).
3. **Sorted Leaves:** All values at the bottom (leaf nodes) are kept in strict sorted order and linked together as a doubly-linked list.

Because the fan-out is so wide, even a table with **100 million rows** produces a B-Tree that is only **3 to 4 levels deep**.

---

## 2. What Happens When You Create `INDEX ON (department, salary DESC)`?

When you create this composite index:
1. The database constructs a separate B-Tree data structure storing `(department, salary, row_pointer)`.
2. It sorts entries using **lexicographical (dictionary) ordering**:
   - **First** by `department ASC` (alphabetical order).
   - **Second** by `salary DESC` (highest to lowest) *within each specific department*.

### Conceptual View of the Sorted Leaf Level:

```
['Engineering', 180000] ──► (Pointer to Heap Row A)  <-- TOP 1 (MAX) for Engineering
['Engineering', 150000] ──► (Pointer to Heap Row B)
['Engineering', 120000] ──► (Pointer to Heap Row C)
['Marketing',   140000] ──► (Pointer to Heap Row D)  <-- TOP 1 (MAX) for Marketing
['Marketing',   110000] ──► (Pointer to Heap Row E)
['Sales',       160000] ──► (Pointer to Heap Row F)  <-- TOP 1 (MAX) for Sales
['Sales',        90000] ──► (Pointer to Heap Row G)
```

---

## 3. How the Engine Performs an $O(\log N)$ Index Seek

Suppose the query evaluates:
```sql
SELECT MAX(salary) FROM Employee WHERE department = 'Marketing';
-- or
SELECT salary FROM Employee WHERE department = 'Marketing' ORDER BY salary DESC LIMIT 1;
```

Instead of scanning all $N$ rows in the table ($O(N)$), the database engine executes an **Index Seek**:

```
[Level 1 - Root]:     Compares 'Marketing' -> Chooses middle branch
       │
[Level 2 - Branch]:   Compares 'Marketing' -> Chooses leaf pointer
       │
[Level 3 - Leaf]:     Lands directly on the FIRST entry where department = 'Marketing':
                      -> ['Marketing', 140000]
```

### Execution Steps:
1. **Root-to-Leaf Traversal ($O(\log N)$):** 
   - The engine does binary searches inside each node to traverse from Root $\rightarrow$ Branch $\rightarrow$ Leaf. 
   - On a 10-million row table, this requires only **3 to 4 page reads / memory comparisons**.
2. **Instant Value Retrieval ($O(1)$):**
   - Because the index is ordered by `salary DESC`, the **very first entry** for `'Marketing'` in the leaf node is guaranteed to be the **maximum salary**.
   - The engine reads that single 8-byte value (`140000`) and **immediately stops execution** (it does not scan the rest of Marketing's employees).
3. **Index-Only Scan:**
   - Both `department` and `salary` live directly inside the index pages. The engine doesn't even need to visit the main table data on disk (the heap).

---

## 4. Comparison Summary: Full Scan vs. B-Tree Seek

| Operation | Without Index (Full Scan) | With `(department, salary DESC)` B-Tree |
| :--- | :--- | :--- |
| **Row Inspections** | $N$ rows (e.g. 10,000,000) | **1 row** (at target leaf position) |
| **Tree Traversal** | None (Scans whole disk table) | **$\approx 3\text{--}4$ tree hops** ($\log_{\text{fanout}} N$) |
| **Time Complexity** | $O(N)$ | $O(\log N)$ |
| **Disk/Memory I/O** | Megabytes / Gigabytes of pages | 3 or 4 $8\text{KB}$ buffer hits |

This is why composite B-Tree indexes turn subqueries from sluggish full-table scans into sub-millisecond point lookups.
