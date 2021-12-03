--PART 1
WITH d AS (
	SELECT move_dir, 
		   CASE WHEN move_dir = 'up' THEN -sum(move_size) ELSE sum(move_size) END s
	FROM aoc_data_02
	GROUP BY move_dir
)
SELECT (up + down) * s AS ans
FROM d
CROSS JOIN (SELECT s as up FROM d WHERE move_dir = 'up')
CROSS JOIN (SELECT s as down FROM d WHERE move_dir = 'down')
WHERE move_dir == 'forward';

--PART 1 & 2
WITH d AS (
	SELECT id,
		CASE WHEN move_dir = 'forward' THEN move_size ELSE 0 END AS horizon_move,
		SUM(CASE WHEN move_dir = 'down' THEN move_size
				 WHEN move_dir = 'up' THEN -move_size
				 ELSE 0
			END) OVER (ORDER BY id) AS aim
	FROM aoc_data_02
)
SELECT SUM(horizon_move) * depth AS ans_1,
	   SUM(horizon_move) * SUM(horizon_move*aim) AS ans_2
FROM d
CROSS JOIN (SELECT aim AS depth FROM d ORDER BY id DESC LIMIT 1);
