-- SWITCH
--
-- New in DuckDB 2.0. A CASE that is a lookup: the value, a map from values to
-- results, and what to answer when the value is not in the map.

SELECT name, nose,
       job: SWITCH(nose, MAP {'red': 'lights the way', 'pink': 'carries the cards'}, 'pulls')
FROM reindeer;
