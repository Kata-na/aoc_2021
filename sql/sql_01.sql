-- PART 1
WITH d AS (
	SELECT depth > LAG(depth) OVER(ORDER BY id) comp
	FROM aoc_data_01
)
SELECT sum(comp) as ans 
FROM d;

-- PART 2
WITH d AS (
	SELECT depth > LAG(depth, 3) OVER(ORDER BY id) comp
	FROM aoc_data_01
)
SELECT sum(comp) as ans 
FROM d