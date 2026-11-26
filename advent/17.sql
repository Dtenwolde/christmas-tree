-- UNPIVOT
--
-- From wide to long: a row for every measurement. COLUMNS names the columns to
-- stack, here all but the name.

UNPIVOT (SELECT name, speed, kg FROM reindeer)
ON COLUMNS(* EXCLUDE (name))
INTO NAME measure VALUE amount;
