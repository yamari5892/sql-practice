-- 1_schema.sql

-- ===== countriesテーブル =====
CREATE TABLE countries (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    country_name VARCHAR(255) NOT NULL,
    region VARCHAR(255),
    hemisphere ENUM('North', 'South', 'Both') NOT NULL
);

INSERT INTO countries (country_name, region, hemisphere) VALUES
('日本', 'アジア', 'North'),
('フランス', 'ヨーロッパ', 'North'),
('ブラジル', '南米', 'South'),
('オーストラリア', 'オセアニア', 'South'),
('エジプト', 'アフリカ', 'North');

-- ===== usersテーブル =====
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (user_name, email) VALUES
('山田 太郎', 'taro.yamada@example.com'),
('鈴木 花子', 'hanako.suzuki@example.com'),
('佐藤 次郎', 'jiro.sato@example.com');

-- ===== destinationsテーブル =====
CREATE TABLE destinations (
    destination_id INT PRIMARY KEY AUTO_INCREMENT,
    destination_name VARCHAR(255) NOT NULL,
    country_id INT NOT NULL,
    city VARCHAR(255) NOT NULL,
    category ENUM('観光地', 'レストラン', '世界遺産', 'その他') NOT NULL,
    status ENUM('行きたい', '計画中', '訪問済み') NOT NULL,
    estimated_cost INT,
    FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

INSERT INTO destinations (destination_name, country_id, city, category, status, estimated_cost) VALUES
('清水寺', 1, '京都市', '観光地', '訪問済み', 10000),
('ルーヴル美術館', 2, 'パリ', '観光地', '行きたい', 150000),
('モン・サン・ミシェル', 2, 'モン・サン・ミシェル', '世界遺産', '計画中', 200000),
('オペラハウス', 4, 'シドニー', '世界遺産', '行きたい', 250000),
('イグアスの滝', 3, 'フォス・ド・イグアス', '世界遺産', '行きたい', 300000);

-- ===== trip_logsテーブル =====
CREATE TABLE trip_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    destination_id INT NOT NULL,
    trip_date DATE,
    actual_cost INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (destination_id) REFERENCES destinations(destination_id)
);

INSERT INTO trip_logs (user_id, destination_id, trip_date, actual_cost, rating, notes) VALUES
(1, 1, '2024-04-15', 12000, 5, '桜が満開で最高だった。'),
(2, 2, '2023-09-20', 160000, 4, 'モナ・リザは思ったより小さかったけど、他の展示も素晴らしかった。'),
(1, 4, '2025-01-10', 280000, 5, '建物のデザインがユニーク。内部のツアーも楽しめた。'),
(3, 5, '2024-08-05', 320000, 5, '想像を絶する水量と迫力。ブラジル側から見て正解。');