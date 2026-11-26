-- Just an expression
--
-- New in the DuckDB 2.0 shell. A statement can be nothing but an expression, without
-- a SELECT: the shell is a calculator. (This box does the same.) How many sleeps
-- from the first of December?

DATE '2026-12-25' - DATE '2026-12-01'
