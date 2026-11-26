-- count() and FILTER
--
-- An aggregate can look at only some of the rows of its group: FILTER (WHERE ...).
-- And count() needs no star.

SELECT elf,
       made: count(),
       wrapped: count() FILTER (WHERE wrapped),
       to_wrap: count() FILTER (WHERE NOT wrapped)
FROM presents
GROUP BY ALL
ORDER BY ALL;
