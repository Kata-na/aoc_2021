-- PART 1 & PART 2
WITH d AS (
	SELECT depth > LAG(depth) OVER(ORDER BY id) wind_lag1,
		   depth > LAG(depth, 3) OVER(ORDER BY id) wind_lag3
	FROM aoc_data_01
)
SELECT sum(wind_lag1) as ans_1, sum(wind_lag3) as ans_2 
FROM d