-- GROUP BY ALL, ORDER BY ALL
--
-- Group by every column that is not aggregated, and sort by every column from left
-- to right, without naming any of them a second time.

SELECT kind, wrapped, count(*) AS presents, sum(kg) AS kg
FROM presents
GROUP BY ALL
ORDER BY ALL;
