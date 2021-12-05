WITH RECURSIVE _generate_series(x) AS (
-- SQLite missing generate_series() function so adding it using recursive query
	VALUES(0)
	UNION
	SELECT x+1 FROM vectors, _generate_series
	WHERE x < len 
),
-- CALCULATIONS
dt AS (
    -- SQLite does not have function regexp_match() So using SUBSTR() and INSTR()
    -- to get coordinates
	SELECT SUBSTR(value, 0, INSTR(value, ' -> ')) AS c1, 
		   SUBSTR(value, INSTR(value, ' -> ') + 4, LENGTH(value)) AS c2
	FROM aoc_data_05
),
coordinates AS (
	SELECT c1, c2,  CAST(SUBSTR(c1, 0, INSTR(c1, ',')) AS INT) AS x1,
		   CAST(SUBSTR(c1, INSTR(c1, ',') + 1, LENGTH(c1)) AS INT) AS y1,
		   CAST(SUBSTR(c2, 0, INSTR(c2, ',')) AS INT) AS x2,
		   CAST(SUBSTR(c2, INSTR(c2, ',') + 1, LENGTH(c2)) AS INT) AS y2
	FROM dt
),
vectors AS (
    SELECT x1, y1, SIGN(x2-x1) AS dx, SIGN(y2-y1) AS dy,
		   MAX(ABS(x1-x2), ABS(y1-y2)) AS len
	FROM coordinates
),
points AS (
	SELECT x1 + i * dx AS x, y1 + i * dy AS y, dx * dy != 0 AS diagonal 
	FROM vectors, (SELECT x as i FROM _generate_series)
	WHERE i <= len
), 
movement_lines_no_diag AS (
    SELECT x, y 
	FROM points 
	WHERE NOT diagonal
	GROUP BY x, y HAVING COUNT(*) > 1
),
movement_lines_diag AS (
    SELECT x, y 
	FROM points 
	GROUP BY x, y HAVING COUNT(*) > 1
)
SELECT (SELECT COUNT(*) FROM movement_lines_no_diag) AS ans1, 
	   (SELECT COUNT(*) FROM movement_lines_diag) AS ans2;
