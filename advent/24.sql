-- A Christmas tree
--
-- How the tree on this page began: range for its rows, repeat for its shape. The
-- whole scene is the same idea with more patience, in one query: tree.sql.

SELECT tree: repeat(' ', 9 - i) || repeat('*', 2 * i + 1)
FROM range(10) AS t(i)
UNION ALL
SELECT repeat(' ', 8) || '|||';
