-- Top N: max(x, n) and arg_max
--
-- The three fastest without a window function. max(x, 3) answers with a list, and
-- arg_max(name, x, 3) with the names that belong to it.

SELECT fastest: max(speed, 3),
       who: arg_max(name, speed, 3),
       lightest: arg_min(name, kg)
FROM reindeer;
