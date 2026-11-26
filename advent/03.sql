-- SELECT * REPLACE
--
-- Every column, one of them changed: REPLACE puts an expression in its place, under
-- the same name. Here the speed in miles per hour.

SELECT * REPLACE ((speed / 1.609)::INT AS speed)
FROM reindeer;
