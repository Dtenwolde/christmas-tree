-- NEAREST joins
--
-- New in DuckDB 2.0. Joins every row to its closest rows, by a distance or a
-- similarity of your choosing. Letters to the North Pole are not always spelled
-- the way the catalogue is.

SELECT asked, gift
FROM (VALUES ('telescoop'), ('ruber duk'), ('ice sckates'), ('stroybook')) AS letter(asked)
JOIN (SELECT DISTINCT gift FROM presents) AS catalogue
     NEAREST 1 BY SIMILARITY jaro_winkler_similarity(asked, gift);
