-- Prefix aliases
--
-- New in DuckDB 2.0. The name first and the expression after it: "name: expression"
-- instead of "expression AS name". Tables can be named the same way.

SELECT who: name,
       mph: (speed / 1.609)::INT,
       pounds: (kg * 2.205)::INT
FROM team: reindeer;
