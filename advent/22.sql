-- Variables and $name
--
-- New in DuckDB 2.0. SET VARIABLE keeps a value for the queries after it, and $name
-- now reads it back (before: getvariable('name')). It is how this page tells the
-- tree the size of your window: on the page, try SELECT $rows, $cols.

SET VARIABLE heavy = 2;

SELECT child, gift, kg
FROM presents
WHERE kg > $heavy
ORDER BY kg DESC;
