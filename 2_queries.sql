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
-- 目的：国ごとの平均と比較し、コストパフォーマンスに優れた旅行を抽出する
WITH country_stats AS (
    SELECT
        des.country_id,
        AVG(tl.rating) AS avg_rating,
        AVG(tl.actual_cost) AS avg_cost
    FROM
        trip_logs tl
    JOIN
        destinations des ON tl.destination_id = des.destination_id
    GROUP BY
        des.country_id
)
SELECT
    u.user_name AS 'ユーザー名',
    c.country_name AS '国名',
    d.destination_name AS '場所',
    tl.rating AS '評価',
    tl.actual_cost AS '実費',
    cs.avg_rating AS '国別平均評価',
    cs.avg_cost AS '国別平均費用'
FROM
    trip_logs tl
-- 3つのテーブルをJOINで連結していく
JOIN
    destinations d ON tl.destination_id = d.destination_id
JOIN
    countries c ON d.country_id = c.country_id
JOIN
    users u ON tl.user_id = u.user_id
JOIN
    country_stats cs ON d.country_id = cs.country_id
WHERE
    -- 条件：評価が国別平均以上、かつ、費用が国別平均以下
    tl.rating >= cs.avg_rating AND tl.actual_cost <= cs.avg_cost
;