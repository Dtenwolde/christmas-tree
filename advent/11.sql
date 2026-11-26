-- QUALIFY
--
-- A WHERE for window functions. The heaviest present of every kind, without a
-- subquery.

SELECT kind, gift, kg
FROM presents
QUALIFY row_number() OVER (PARTITION BY kind ORDER BY kg DESC) = 1
ORDER BY kg DESC;
