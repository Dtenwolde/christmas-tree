-- A calendar from generate_series
--
-- A table of days out of nothing: generate_series counts in intervals too. This is
-- the calendar you are opening.

SELECT day: d::DATE,
       weekday: dayname(d),
       sleeps_left: DATE '2026-12-25' - d::DATE
FROM generate_series(DATE '2026-12-01', DATE '2026-12-24', INTERVAL 1 DAY) AS t(d);
