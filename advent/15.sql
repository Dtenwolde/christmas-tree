-- Grouping by unnest
--
-- New in DuckDB 2.0. A list column can be grouped by its elements: unnest goes
-- straight into the GROUP BY. Which wish is the most popular?

SELECT wish: unnest(wishes),
       children: count(),
       who: list(name)
FROM children
GROUP BY unnest(wishes)
ORDER BY children DESC, wish;
