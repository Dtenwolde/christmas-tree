-- Reusable column aliases
--
-- An alias can be used at once, in the next expression of the same SELECT.

SELECT gift,
       grams: (kg * 1000)::INT,
       stamps: ceil(grams / 500)::INT,
       postage: stamps * 1.15
FROM presents;
