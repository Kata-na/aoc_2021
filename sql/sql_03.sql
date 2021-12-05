WITH dt AS (
	SELECT
		   substr(value, 1,1)  v1, substr(value, 2,1)   v2,
		   substr(value, 3,1)  v3, substr(value, 4,1)   v4,
		   substr(value, 5,1)  v5, substr(value, 6,1)   v6,
		   substr(value, 7,1)  v7, substr(value, 8,1)   v8,
		   substr(value, 9,1)  v9, substr(value, 10,1)  v10,
		   substr(value, 11,1) v11, substr(value, 12,1) v12
	FROM aoc_data_03
),
ge AS (
	SELECT 
		   CASE WHEN CAST(sum(v1) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 2048 +
		   CASE WHEN CAST(sum(v2) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 1024 +
		   CASE WHEN CAST(sum(v3) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 512 +
		   CASE WHEN CAST(sum(v4) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 256 +
		   CASE WHEN CAST(sum(v5) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 128 +
		   CASE WHEN CAST(sum(v6) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 64 +
		   CASE WHEN CAST(sum(v7) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 32 +
		   CASE WHEN CAST(sum(v8) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 16 +
		   CASE WHEN CAST(sum(v9) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 8 +
		   CASE WHEN CAST(sum(v10) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 4 +
		   CASE WHEN CAST(sum(v11) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 2 +
		   CASE WHEN CAST(sum(v12) AS FLOAT)/ 1000 > 0.5 THEN 1 ELSE 0 END  * 1 AS gamma,
		   
		   CASE WHEN CAST(sum(v1) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 2048 +
		   CASE WHEN CAST(sum(v2) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 1024 +
		   CASE WHEN CAST(sum(v3) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 512 +
		   CASE WHEN CAST(sum(v4) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 256 +
		   CASE WHEN CAST(sum(v5) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 128 +
		   CASE WHEN CAST(sum(v6) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 64 +
		   CASE WHEN CAST(sum(v7) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 32 +
		   CASE WHEN CAST(sum(v8) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 16 +
		   CASE WHEN CAST(sum(v9) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 8 +
		   CASE WHEN CAST(sum(v10) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 4 +
		   CASE WHEN CAST(sum(v11) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 2 +
		   CASE WHEN CAST(sum(v12) AS FLOAT)/ 1000 < 0.5 THEN 1 ELSE 0 END  * 1 AS epsilon
	FROM dt	
)
SELECT gamma * epsilon as ans
FROM ge
