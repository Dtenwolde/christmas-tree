-- Slicing
--
-- Square brackets cut strings, and lists the same way: [1:3] is the first three,
-- [-1] the last one, [-3:] the last three.

SELECT name,
       name[1:3]     AS first_three,
       name[-1]      AS last_letter,
       name[-3:]     AS last_three,
       wishes[1:2]   AS two_wishes
FROM children;
