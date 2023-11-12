-- 사용자 주소 정보 테이블
DROP TABLE IF EXISTS mst_user_location;
CREATE TABLE mst_user_location (
    user_id   varchar(255)
  , pref_name varchar(255)
  , city_name varchar(255)
);

INSERT INTO mst_user_location
VALUES
    ('U001', '서울특별시', '강서구')
  , ('U002', '경기도수원시', '장안구'  )
  , ('U003', '제주특별자치도', '서귀포시')
;

-- 문자열 연결하기
SELECT
	user_id
	, CONCAT(pref_name, city_name) AS pref_city
FROM mst_user_location
;

-- 4분기 매출 테이블
DROP TABLE IF EXISTS quarterly_sales;
CREATE TABLE quarterly_sales (
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales
VALUES
    (2015, 82000, 83000, 78000, 83000)
  , (2016, 85000, 85000, 80000, 81000)
  , (2017, 92000, 81000, NULL , NULL )
;

-- 분기별 매출 증감 판정하기
SELECT
	year
	,q1
	,q2
	,CASE
		WHEN q1 < q2 THEN ' + '
		WHEN q1 = q2 THEN ''
		ELSE '-'
	END AS judge_q1_q2
-- Q1과 Q2의 매출액의 차이 계산하기
	, q2 - q1 AS diff_q2_q1
-- Q1과 Q2의 매출 변화를 1, 0, -1 로 표현하기
	, SIGN(q2 - q1) AS sign_q2_q1
FROM quarterly_sales
ORDER BY year
;

-- 연간 최대/최소 4분기 매출 찾기
SELECT
	year
	-- Q1~Q4의 최대 매출 구하기
	, greatest(q1, q2, q3, q4) AS greatest_sales
	-- Q1~Q4 최소 매출 구하기
	, least(q1, q2, q3, q4) AS least_sales
FROM quarterly_sales
ORDER BY year
;

-- 평균 4분기 매출 구하기
SELECT
	year
	, (q1 + q2 + q3 + q4) / 4 AS average
	FROM quarterly_sales
ORDER BY year
;

-- COALESCE를 사용하여 NULL을 0으로 변환하고 평균값을 구하는 쿼리
SELECT
	year
	,(COALESCE(q1, 0) + COALESCE(q2, 0) + COALESCE(q3, 0) + COALESCE(q4, 0)) / 4
	AS average
FROM quarterly_sales
ORDER BY year
;

-- NULL이 아닌 컬럼만을 사용해서 평균값을 구하는 쿼리
SELECT
	year
	,(COALESCE(q1, 0) + COALESCE(q2, 0) + COALESCE(q3, 0) + COALESCE(q4, 0))
	/ (SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0))
	+ SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0)))
	AS average
FROM quarterly_sales
ORDER BY year
;

-- 광고 통계 정보 테이블
DROP TABLE IF EXISTS advertising_stats;
CREATE TABLE advertising_stats (
    dt          varchar(255)
  , ad_id       varchar(255)
  , impressions integer
  , clicks      integer
);

INSERT INTO advertising_stats
VALUES
    ('2017-04-01', '001', 100000,  3000)
  , ('2017-04-01', '002', 120000,  1200)
  , ('2017-04-01', '003', 500000, 10000)
  , ('2017-04-02', '001',      0,     0)
  , ('2017-04-02', '002', 130000,  1400)
  , ('2017-04-02', '003', 620000, 15000)
;

-- 일별 광고의 CTR 구하기(클릭 / 노출 수)
SELECT 
	dt, 
	ad_id
	, CAST(clicks AS double precision) / impressions AS ctr
	, Round(100.0 * clicks / impressions,2) AS ctr_as_percent 
FROM advertising_stats
WHERE dt = '2017-04-01'
ORDER BY dt, ad_id
;

-- 값이 0으로 나뉘어져서 오류 생기는 것 방지하기
SELECT 
	dt
	, ad_id
-- CASE 식으로 분모가 0일 경우를 분기해서, 0으로 나누지 않게 만드는 방법
	, CASE
		WHEN impressions > 0 THEN Round(100.0 * clicks / impressions,2)
	END AS ctr_as_percent_by_case
	, Round(100.0 * clicks / NULLIF(impressions, 0),2) AS ctr_as_percent_by_null
FROM advertising_stats
ORDER BY dt, ad_id
;

-- 등록 시간과 생일을 포함하는 사용자 마스터 테이블
DROP TABLE IF EXISTS mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id        varchar(255)
  , register_stamp varchar(255)
  , birth_date     varchar(255)
);

INSERT INTO mst_users_with_dates
VALUES
    ('U001', '2016-02-28 10:00:00', '2000-02-29')
  , ('U002', '2016-02-29 10:00:00', '2000-02-29')
  , ('U003', '2016-03-01 10:00:00', '2000-02-29')
;
-- 사용자의 생년월일로 나이 계산하기(postgresql에서만 age 함수 제공)
SELECT
	user_id
	, CURRENT_DATE AS today
	, register_stamp::date AS register_date
	, birth_date::date AS birth_date
	, EXTRACT(YEAR FROM age(birth_date::date)) AS current_age
	, EXTRACT(YEAR FROM age(register_stamp::date, birth_date::date)) AS register_age 
FROM mst_users_with_dates
;