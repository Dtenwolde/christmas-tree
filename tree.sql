-- A Christmas scene, drawn by DuckDB: a tree with lights that twinkle, ornaments (two of
-- them ducks) and presents, falling snow, a snowman who waves, a cabin with a smoking
-- chimney, a sleigh that crosses the sky, and a countdown to Christmas.
--
-- It is an Advent calendar too: in November there is a bare tree in the snow, from
-- 1 December every day adds one thing (the `calendar` below), and the star goes on top on
-- the 24th. From then until the next November everything is there.
--
-- The picture is a function of the time: asked again a moment later, the query answers
-- with the next frame. Ask ten times a second and it moves.
--
--   one frame:   duckdb -list -noheader -f tree.sql
--                (in the shell: .mode list, .headers off, .read tree.sql)
--   animated:    ./tree.sh, or index.html in a browser
--
-- Variables, all optional:
--   rows, cols   the size to draw into; the tree is as big as fits (23 x 79 without them)
--   t            the moment to draw, in seconds, instead of the clock's
--   color        false for plain ASCII, which also fits a result box
--   now          a timestamp to pretend it is, for the calendar and the countdown
--                ('2026-12-07 09:00' shows the scene of 7 December)

WITH
opts AS (
    SELECT coalesce(getvariable('rows'), 23)::INT                                   AS rows,
           coalesce(getvariable('cols'), 79)::INT                                   AS cols,
           coalesce(getvariable('t')::DOUBLE, epoch_ms(now()) % 86400000 / 1000.0)  AS t,
           coalesce(getvariable('color'), true)::BOOL                               AS color,
           coalesce(getvariable('now')::TIMESTAMP, localtimestamp)                  AS now,
           -- how many days of the calendar are open: none in November, all after the 24th
           CASE month(now) WHEN 12 THEN least(day(now), 24) WHEN 11 THEN 0 ELSE 24 END AS advent),
dims AS (
    SELECT *,
           greatest(0, rows - h - 8)   AS top,     -- rows of sky above the star
           top + h + 2                 AS base,    -- the first row under the branches
           (cols - 1) // 2             AS cx,      -- the column of the trunk
           least(h + 5, cols - 8 - cx) AS man,     -- the snowman: columns right of the trunk
           cx - h - 18                 AS cabin    -- the cabin: the column of its left wall (negative: no room for it)
    FROM (SELECT *, greatest(14, least(30, rows - 8, cols - 8 - (cols - 1) // 2)) AS h FROM opts)),   -- h: rows of branches

-- What each day adds. The numbers come back below, where the things themselves are.
calendar(day, what) AS (VALUES
    ( 1, 'the first string of lights'),  ( 2, 'red baubles'),                ( 3, 'a first present'),
    ( 4, 'the start of a snowman'),      ( 5, 'a second string of lights'),  ( 6, 'a duck moves into the tree'),
    ( 7, 'golden baubles'),              ( 8, 'the snowman grows'),          ( 9, 'another present'),
    (10, 'a cabin'),                     (11, 'candy canes'),                (12, 'the snowman gets a head, and waves'),
    (13, 'a third string of lights'),    (14, 'a third present'),            (15, 'a light in the cabin'),
    (16, 'a second duck'),               (17, 'pink baubles'),               (18, 'the big present'),
    (19, 'the last string of lights'),   (20, 'smoke from the chimney'),     (21, 'tinsel'),
    (22, 'the moon'),                    (23, 'a sleigh in the sky'),        (24, 'the star')),

-- Everything that is not the tree or the snow: where it is measured from, what it is (for
-- the few that move), the day of the calendar it arrives, rows down, columns right, the
-- text, and its colour.
sprites AS (
    SELECT CASE origin WHEN 'top' THEN top WHEN 'mid' THEN top + h // 2 ELSE base END + dy   AS y,
           CASE origin WHEN 'man' THEN cx + man WHEN 'cabin' THEN cabin ELSE cx END + dx      AS x,
           CASE WHEN part = 'arm' THEN ['\', '-', '/', '-'][1 + floor(t * 5)::INT % 4]        -- the snowman waves
                WHEN part = 'eye' AND (t + dy + 8) % 4 < 0.2 THEN replace(art, '.', '-')      -- the ducks blink
                ELSE art END                                                                  AS art,
           CASE WHEN part = 'star' AND floor(t * 4)::INT % 2 = 1 THEN '1;97'                  -- the star glitters
                WHEN part = 'fire' AND advent < 15 THEN '90'                                  -- nobody home yet
                WHEN part = 'fire' AND hash(floor(t * 8)::INT) % 4 = 0 THEN '33'              -- the fire flickers
                ELSE ink END                                                                  AS ink,
           false                                                                              AS behind
    FROM dims, (VALUES
        ('top',   'star', 24,  0,  -1, '\|/',           '1;93'),          -- the thingy at the top
        ('top',   'star', 24,  1,  -2, '--*--',         '1;93'),
        ('mid',   '',      6,  0,   3, '_',             '1;93'),          -- a duck
        ('mid',   'eye',   6,  1,   0, '__(.)',         '1;93'),
        ('mid',   '',      6,  1,   5, '<',             '38;5;208'),
        ('mid',   '',      6,  2,   0, '\___)',         '1;93'),
        ('base',  '',     16, -4,  -5, '_',             '1;93'),          -- and another, looking the other way
        ('base',  '',     16, -3,  -7, '>',             '38;5;208'),
        ('base',  'eye',  16, -3,  -6, '(.)__',         '1;93'),
        ('base',  '',     16, -2,  -6, '(___/',         '1;93'),
        ('base',  '',      0,  0,  -1, '|||',           '38;5;94'),       -- the trunk
        ('base',  '',      0,  1,  -1, '|||',           '38;5;94'),
        ('base',  '',      0,  2,  -1, '|||',           '38;5;94'),
        ('base',  '',     18,  0,  -9, '__  __',        '1;91'),          -- the presents
        ('base',  '',     18,  1, -10, '|  ||  |',      '1;91'),
        ('base',  '',     18,  2, -10, '|__||__|',      '1;91'),
        ('base',  '',      9,  1,   4, '_  _',          '1;94'),
        ('base',  '',      9,  2,   3, '|_||_|',        '1;94'),
        ('base',  '',     14,  1,  11, '_ _',           '1;95'),
        ('base',  '',     14,  2,  10, '|_|_|',         '1;95'),
        ('base',  '',      3,  1, -15, '_ _',           '1;96'),
        ('base',  '',      3,  2, -16, '|_|_|',         '1;96'),
        ('base',  '',     18,  0,  -7, '\/',            '1;93'),          -- their bows
        ('base',  '',      9,  1,   5, '\/',            '1;93'),
        ('base',  '',     14,  1,  12, '%',             '1;93'),
        ('base',  '',      3,  1, -14, '&',             '1;93'),
        ('man',   '',     12, -1,   1, '_===_',         '1;91'),          -- the snowman
        ('man',   '',     12,  0,   1, '(o.o)',         '1;97'),
        ('man',   '',      8,  1,   1, '( : )',         '1;97'),
        ('man',   '',      4,  2,   1, '(_:_)',         '1;97'),
        ('man',   '',     12,  1,   0, '/',             '38;5;137'),
        ('man',   'arm',  12,  1,   6, '\',             '38;5;137'),
        ('cabin', '',     10, -3,   6, '_',             '38;5;137'),      -- the cabin: snow on its roof, a fire inside
        ('cabin', '',     10, -2,   2, '___|_|___',     '1;97'),
        ('cabin', '',     10, -1,   1, '/         \',   '1;97'),
        ('cabin', '',     10,  0,   0, '/___________\', '1;97'),
        ('cabin', '',     10,  1,   0, '|       __  |', '38;5;137'),
        ('cabin', '',     10,  2,   0, '|______|  |_|', '38;5;137'),
        ('cabin', 'fire', 10,  1,   3, '[]',            '1;93')) AS v(origin, part, day, dy, dx, art, ink)
    WHERE day <= advent AND (origin <> 'cabin' OR cabin >= 0)
    UNION ALL
    -- The sleigh crosses the sky, twelve columns a second, and is then away for a while.
    SELECT top // 3 + dy, floor(t % (cols / 12.0 + 14) * 12)::INT - 24 + dx, art, ink, true
    FROM dims, (VALUES
        (0,  4, '_',      '1;91'),
        (0,  5, 'o',      '1;97'),
        (1,  1, '\_(__)', '1;91'),
        (1,  7, '~-~-~',  '90'),
        (0, 14, 'Y',      '38;5;180'),
        (1, 12, '(_''>',  '38;5;137'),
        (1, 16, '~~',     '90'),
        (0, 20, 'Y',      '38;5;180'),
        (1, 18, '(_''',   '38;5;137'),
        (1, 21, '*',      '1;91')) AS v(dy, dx, art, ink)
    WHERE advent >= 23
    UNION ALL
    -- The moon, in a corner of the sky.
    SELECT 1 + dy, cols - 8 + dx, art, '38;5;229', true
    FROM dims, (VALUES (0, 1, '.-.'), (1, 0, '( ('), (2, 1, '`-''')) AS v(dy, dx, art)
    WHERE advent >= 22
    UNION ALL
    -- Smoke from the chimney: puffs three rows apart that rise, drift and thin out.
    SELECT base - 4 - k, cabin + 6 + round(sin(t * 1.3 + k) * k / 3.0)::INT,
           ['(', ')', '~', '~', '.', '.'][k + 1], '37', true
    FROM dims, range(6) puffs(k)
    WHERE advent >= 20 AND cabin >= 0 AND (k - floor(t * 2.5)::INT) % 3 = 0),

-- The snow: every flake falls at a speed of its own, drifts with the wind and sways, and
-- starts again at the top in another column.
flakes AS (
    SELECT y, x, bool_or(near) AS near
    FROM (SELECT 1.2 + hash(k, 1) % 40 / 10.0                    AS v,       -- rows a second
                 t * v + hash(k, 2) % 1000                       AS fallen,  -- rows, since ever
                 base + 3                                        AS sky,     -- the rows there are to fall through
                 floor(fallen / sky)::BIGINT                     AS lap,
                 fallen - lap * sky                              AS fall,    -- rows, this time down
                 floor(fall)::INT                                AS y,
                 (((hash(k, lap) % cols)::INT + floor(fall * 0.35 + 1.3 * sin(t * 1.5 + k))::INT) % cols + cols) % cols AS x,
                 v > 2.8                                         AS near
          FROM dims, range((dims.base + 3) * dims.cols // 16) snow(k))
    GROUP BY y, x),

cells AS (
    SELECT y, x, h, t, base, advent,
           y - top - 2 AS i,                       -- the row of the tree itself, 0 at its tip
           x - cx      AS sx,                      -- columns right of the trunk
           abs(x - cx) AS d
    FROM dims, range(dims.top + dims.h + 6) ys(y), range(dims.cols) xs(x)),

-- What each cell is. Things in front of the tree come first, then the tree, then what
-- passes behind it, then the snow, which does not fall under the tree. On the tree, lights
-- hang on slanting strings, eight columns apart (four sets of strings, hung on four days);
-- ornaments hang halfway between the strings, on every third place (four kinds, on four
-- days); and tinsel runs between the two.
kinds AS (
    SELECT c.*, s.ink AS sprite_ink, substr(s.art, c.x - s.x + 1, 1) AS sprite_ch,
           CASE WHEN s.art IS NOT NULL AND NOT s.behind         THEN 'sprite'
                WHEN c.y = base + 3                             THEN 'ground'
                WHEN i BETWEEN 0 AND h - 1 AND d = i + 1        THEN 'edge'
                WHEN i BETWEEN 0 AND h - 1 AND d <= i           THEN
                     CASE (sx + 3 * i + 803) % 8
                          WHEN 0 THEN if(advent >= [1, 5, 13, 19][1 + (sx + 3 * i + 803) // 8 % 4], 'light', 'needle')
                          WHEN 4 THEN if(hash(sx, i) % 3 = 0 AND advent >= [7, 2, 11, 17][1 + (hash(sx, i, 2) % 4)::INT], 'ornament', 'needle')
                          WHEN 2 THEN if(advent >= 21, 'tinsel', 'needle')
                          ELSE 'needle' END
                WHEN s.behind AND sprite_ch <> ' '              THEN 'sprite'
                WHEN c.y >= base AND d <= h                     THEN 'air'
                WHEN f.near                                     THEN 'flake'
                WHEN NOT f.near                                 THEN 'speck'
                ELSE 'air' END AS kind
    FROM cells c
    LEFT JOIN flakes f ON f.y = c.y AND f.x = c.x
    LEFT JOIN sprites s ON s.y = c.y AND c.x BETWEEN s.x AND s.x + length(s.art) - 1
    -- where two things are in one cell: what is in front, and of that what is not a gap
    QUALIFY row_number() OVER (PARTITION BY c.y, c.x ORDER BY s.behind, substr(s.art, c.x - s.x + 1, 1) = ' ') = 1),

drawn AS (
    SELECT y, x,
           -- a light: it brightens and fades at a pace of its own, and takes another colour every three seconds
           sin(t * (2 + hash(sx, i, 7) % 30 / 10.0) + hash(sx, i, 8) % 628 / 100.0)   AS glow,
           1 + (hash(sx, i, floor(t / 3 + hash(sx, i) % 100 / 100.0)::INT) % 5)::INT  AS hue,
           CASE kind WHEN 'sprite'   THEN sprite_ch
                     WHEN 'ground'   THEN ['_', '.', '_', '_', '_'][1 + (hash(x, 5) % 5)::INT]
                     WHEN 'edge'     THEN if(sx < 0, '/', '\')
                     WHEN 'light'    THEN 'o'
                     WHEN 'ornament' THEN ['O', '@', 'J', '8'][1 + (hash(sx, i, 2) % 4)::INT]
                     WHEN 'needle'   THEN '^'
                     WHEN 'tinsel'   THEN '~'
                     WHEN 'flake'    THEN '*'
                     WHEN 'speck'    THEN '.'
                     ELSE ' ' END AS ch,
           CASE kind WHEN 'sprite'   THEN sprite_ink
                     WHEN 'ground'   THEN '1;97'
                     WHEN 'light'    THEN CASE WHEN glow > 0.2  THEN '1;' || [91, 93, 94, 95, 96][hue]
                                               WHEN glow > -0.6 THEN [31, 33, 34, 35, 36][hue]::VARCHAR
                                               ELSE '90' END
                     WHEN 'ornament' THEN ['38;5;220', '1;31', '1;97', '38;5;213'][1 + (hash(sx, i, 2) % 4)::INT]
                     WHEN 'tinsel'   THEN if(hash(sx, i, floor(t * 3)::INT) % 4 = 0, '1;97', '37')    -- it glints
                     WHEN 'flake'    THEN '97'
                     WHEN 'speck'    THEN '90'
                     ELSE '32' END AS ink
    FROM kinds),

-- The lines under it: what today added, and the days and hours until the next 25 December,
-- by this computer's clock.
clock AS (
    SELECT today, date_diff('second', now, xmas::TIMESTAMP) AS s
    FROM (SELECT now, today, make_date(year(today) + (today > make_date(year(today), 12, 25))::INT, 12, 25) AS xmas
          FROM (SELECT now, now::DATE AS today FROM opts))),
greeting AS (
    SELECT CASE WHEN month(today) = 12 AND day(today) = 25 THEN 'Merry Christmas!'
                ELSE printf('%d %s %02d:%02d:%02d until Christmas', s // 86400, if(s // 86400 = 1, 'day', 'days'),
                            s % 86400 // 3600, s % 3600 // 60, s % 60) END AS msg
    FROM clock),
today AS (
    SELECT CASE WHEN month(now) = 11 THEN 'Advent begins on 1 December'
                WHEN month(now) = 12 AND day(now) <= 24 THEN (SELECT day(now) || ' December: ' || what FROM calendar WHERE day = advent)
                ELSE '' END AS note
    FROM dims)

SELECT line AS "Merry Christmas!"
FROM (SELECT y, rtrim(string_agg(if(color AND ch <> ' ', chr(27) || '[' || ink || 'm' || ch || chr(27) || '[0m', ch),
                                 '' ORDER BY x)) AS line
      FROM drawn, dims
      GROUP BY y
      UNION ALL
      SELECT base + 4, if(note = '', '', repeat(' ', greatest(0, (cols - length(note)) // 2)) || if(color, chr(27) || '[1;93m' || note || chr(27) || '[0m', note))
      FROM dims, today
      UNION ALL
      SELECT base + 5, repeat(' ', greatest(0, (cols - length(msg)) // 2)) || if(color, chr(27) || '[1;97m' || msg || chr(27) || '[0m', msg)
      FROM dims, greeting)
ORDER BY y;
