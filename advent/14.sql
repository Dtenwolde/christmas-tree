-- List comprehensions
--
-- Python's list comprehension, in SQL: every element of a list changed, and only
-- those kept that pass the IF.

SELECT name, wishes,
       big_letters: [upper(w) FOR w IN wishes IF length(w) <= 6]
FROM children;
