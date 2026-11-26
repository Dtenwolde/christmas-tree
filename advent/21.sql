-- UNION BY NAME
--
-- Stacks two results by the names of their columns, not by their position. A column
-- that one side does not have is NULL there.

SELECT name, speed, nose FROM reindeer WHERE nose <> 'black'
UNION ALL BY NAME
SELECT 'Olive' AS name, 'the other reindeer' AS known_as, 61 AS speed;
