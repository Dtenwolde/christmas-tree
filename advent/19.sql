-- ASOF JOIN
--
-- Joins every row to the last row before it in time. How deep was the snow when
-- the sleigh landed? The snow was measured every three hours, the sleigh did not
-- wait for that.

SELECT town, arrived, measured, cm
FROM route
ASOF JOIN snowfall ON arrived >= measured
ORDER BY arrived;
