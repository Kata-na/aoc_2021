-- SQLite does not support many functions and does not allow window function to be used
-- in side recursuion, therefore solution works only for part1 . It takes too long for part 2
-- If window f-tion would be available inside recursive func query could be optimized

CREATE TABLE aoc_data_06_fish_count_day_0 AS
WITH RECURSIVE _generate_series(x) AS (
	VALUES(1)
	UNION 
	SELECT x + 2 FROM inp, _generate_series
	WHERE x < len - 1 -- removing 1 due to newline
),
inp AS (
	SELECT LENGTH(value) len
	FROM aoc_data_06
),
days AS (
	SELECT 0 i UNION SELECT 1 i  UNION SELECT 2 i  UNION SELECT 3 i
		UNION SELECT 4 i  UNION SELECT 5 i  UNION SELECT 6 i UNION SELECT 7 i
		UNION SELECT 8 i
),
clean_data AS (
	SELECT CAST(SUBSTR(value, x, 1) AS INTEGER) fishes_state
	FROM aoc_data_06, _generate_series
)
SELECT 0 day, i as fishes_state, count(fishes_state) fish_count
FROM days
LEFT JOIN  clean_data on fishes_state = i
GROUP BY 1, 2;


WITH RECURSIVE fish_spawn AS (
	SELECT DISTINCt *
	FROM aoc_data_06_fish_count_day_0
	
	UNION ALL
	SELECT DISTINCT new_day_fish_spawn.day + 1 AS day,
		   CASE WHEN  new_day_fish_spawn.fishes_state in (0)THEN 6
				ELSE  new_day_fish_spawn.fishes_state - 1 END AS fish_state,
		   new_day_fish_spawn.fish_count
	FROM fish_spawn AS new_day_fish_spawn
	WHERE new_day_fish_spawn.day <= 150 
	
	UNION ALL
	SELECT DISTINCT new_day_fish_spawn.day + 1 AS day,
		   CASE WHEN  new_day_fish_spawn.fishes_state in (0) THEN 8
				ELSE NULL END AS fish_state,
		   new_day_fish_spawn.fish_count
	FROM fish_spawn AS new_day_fish_spawn
	WHERE new_day_fish_spawn.day <= 80  AND fish_state = 8

)
SELECT SUM(fish_count) ans
FROM fish_spawn
WHERE day = 80;