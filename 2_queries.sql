-- 2_queries.sql

-- 目的：登録されている全ての国を表示する
SELECT * FROM countries;

-- 目的：南半球の国だけを絞り込んで表示する
SELECT * FROM countries WHERE hemisphere = 'South';

-- 目的：地域ごとに国がいくつあるか集計する
SELECT region, COUNT(*) AS country_count
FROM countries
GROUP BY region;

-- 目的：サブクエリを使い、「山田 太郎」の旅行記録を全て表示する
SELECT *
FROM trip_logs
WHERE user_id = (SELECT user_id FROM users WHERE user_name = '山田 太郎');

-- 目的：ウィンドウ関数を使い、国別で予算が高い順にランキングを付ける
SELECT
    des.destination_name,
    con.country_name,
    des.estimated_cost,
    RANK() OVER (PARTITION BY con.country_name ORDER BY des.estimated_cost DESC) AS cost_rank
FROM
    destinations des
JOIN
    countries con ON con.country_id = des.country_id;