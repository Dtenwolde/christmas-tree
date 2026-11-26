-- The tables that the Advent calendar's examples query. The page loads them; in a shell:
--
--   duckdb -cmd ".read advent/north-pole.sql"          then try FROM reindeer;
--   duckdb -c ".read advent/north-pole.sql" -f advent/04.sql

-- The team. (Eight joined with the poem of 1823, the ninth with the story of 1939.)
CREATE OR REPLACE TABLE reindeer AS
    FROM (VALUES
        ('Dasher',  1823, 82, 118, 'black'),
        ('Dancer',  1823, 76, 104, 'black'),
        ('Prancer', 1823, 79, 111, 'black'),
        ('Vixen',   1823, 85,  98, 'black'),
        ('Comet',   1823, 90, 125, 'black'),
        ('Cupid',   1823, 74, 101, 'pink'),
        ('Donner',  1823, 80, 132, 'black'),
        ('Blitzen', 1823, 88, 127, 'black'),
        ('Rudolph', 1939, 84,  93, 'red')
    ) AS t(name, joined, speed, kg, nose);          -- speed in km/h

-- Who asked for what.
CREATE OR REPLACE TABLE children AS
    FROM (VALUES
        ('Ada',    9, 'Oslo',      ['telescope', 'chemistry set', 'rubber duck']),
        ('Bram',   7, 'Amsterdam', ['sled', 'ice skates']),
        ('Chidi',  5, 'Lagos',     ['rubber duck', 'train set', 'kite']),
        ('Dora',   8, 'Lisbon',    ['storybook', 'atlas', 'rubber duck']),
        ('Emil',   6, 'Reykjavik', ['kite', 'sled']),
        ('Freya', 10, 'Toronto',   ['microscope', 'puzzle', 'telescope'])
    ) AS t(name, age, town, wishes);

-- What the workshop made.
CREATE OR REPLACE TABLE presents AS
    FROM (VALUES
        ('Ada',   'telescope',     'science', 3.2, true,  'Bushy'),
        ('Ada',   'chemistry set', 'science', 1.8, false, 'Pepper'),
        ('Bram',  'sled',          'outdoor', 4.5, true,  'Alabaster'),
        ('Bram',  'ice skates',    'outdoor', 1.9, true,  'Bushy'),
        ('Chidi', 'rubber duck',   'toy',     0.1, true,  'Pepper'),
        ('Chidi', 'train set',     'toy',     2.7, false, 'Alabaster'),
        ('Dora',  'storybook',     'book',    0.6, true,  'Pepper'),
        ('Dora',  'atlas',         'book',    2.1, true,  'Bushy'),
        ('Emil',  'kite',          'outdoor', 0.4, false, 'Alabaster'),
        ('Emil',  'sled',          'outdoor', 4.5, true,  'Pepper'),
        ('Freya', 'microscope',    'science', 2.4, true,  'Bushy'),
        ('Freya', 'puzzle',        'toy',     0.8, false, 'Alabaster')
    ) AS t(child, gift, kind, kg, wrapped, elf);

-- The night itself: where the sleigh landed and when, and the snow depth as it was measured.
CREATE OR REPLACE TABLE route AS
    FROM (VALUES
        ('Oslo',      TIMESTAMP '2026-12-24 21:40'),
        ('Amsterdam', TIMESTAMP '2026-12-24 22:55'),
        ('Lisbon',    TIMESTAMP '2026-12-25 00:20'),
        ('Lagos',     TIMESTAMP '2026-12-25 01:45'),
        ('Reykjavik', TIMESTAMP '2026-12-25 03:30'),
        ('Toronto',   TIMESTAMP '2026-12-25 05:10')
    ) AS t(town, arrived);

CREATE OR REPLACE TABLE snowfall AS
    FROM (VALUES
        (TIMESTAMP '2026-12-24 18:00',  4),
        (TIMESTAMP '2026-12-24 21:00',  9),
        (TIMESTAMP '2026-12-25 00:00', 15),
        (TIMESTAMP '2026-12-25 03:00', 22),
        (TIMESTAMP '2026-12-25 06:00', 26)
    ) AS t(measured, cm);
