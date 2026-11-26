-- PIVOT
--
-- From long to wide: a column for every kind of present, a row for every elf.

PIVOT presents
ON kind
USING sum(kg)
GROUP BY elf
ORDER BY elf;
