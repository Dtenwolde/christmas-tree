-- COLUMNS()
--
-- One expression for many columns. COLUMNS picks them, here by a regular expression,
-- and the expression around it is repeated for each. In the alias, \0 is the
-- column's name.

SELECT min(COLUMNS('speed|kg')) AS 'least_\0',
       max(COLUMNS('speed|kg')) AS 'most_\0'
FROM reindeer;
