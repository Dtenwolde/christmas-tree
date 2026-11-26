-- SELECT * EXCLUDE
--
-- Every column but a few: EXCLUDE takes them out of the star.

SELECT * EXCLUDE (joined, nose)
FROM reindeer;
