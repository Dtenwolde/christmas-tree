-- Function chaining
--
-- Functions can be called with a dot, one after the other from left to right,
-- instead of from the inside out.

SELECT gift,
       label: gift.upper().replace(' ', '_'),
       words: gift.split(' ').len()
FROM presents
WHERE elf = 'Pepper';
