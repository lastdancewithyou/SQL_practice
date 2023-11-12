-- 코드값을 레이블로 변경하기
DROP TABLE IF EXISTS mst_users;
CREATE TABLE mst_users(
    user_id         varchar(255)
  , register_date   varchar(255)
  , register_device integer
);

INSERT INTO mst_users
VALUES
    ('U001', '2016-08-26', 1)
  , ('U002', '2016-08-26', 2)
  , ('U003', '2016-08-27', 3)
;

SELECT 
	user_id, 
	CASE
    WHEN register_device = 1 THEN '데스크톱'
	WHEN register_device = 2 THEN '스마트폰'
	WHEN register_device = 3 THEN '애플리케이션'
	ELSE ''
	END AS device_name
FROM mst_users
;

-- URL(레퍼러 도메인)에서 요소 추출하기
DROP TABLE IF EXISTS access_log;
CREATE TABLE access_log (
    stamp    varchar(255)
  , referrer text
  , url      text
);

INSERT INTO access_log 
VALUES
    ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001')
  , ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref'          )
  , ('2016-08-26 12:02:01', 'https://www.other.com/'                               , 'http://www.example.com/book/detail?id=002' )
;

-- 정규표현식을 활용함
SELECT
	stamp
	, substring(referrer from 'https?://([^/]*)') AS referrer_host
FROM access_log
;

-- URL 경로와 GET 매개변수에 있는 특정 키 값을 추출
SELECT
	stamp
	, url
	, substring(url from '//[^/]+([^?#]+)') AS path
	, substring(url from 'id=([^&]*)') AS id
FROM access_log
;

-- URL 경로를 슬래시로 잘라 배열로 분할하기
DROP TABLE IF EXISTS access_log ;
CREATE TABLE access_log (
    stamp    varchar(255)
  , referrer text
  , url      text
);

INSERT INTO access_log 
VALUES
    ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001')
  , ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref'          )
  , ('2016-08-26 12:02:01', 'https://www.other.com/'                               , 'http://www.example.com/book/detail?id=002' )
;

SELECT
	stamp
	, url
	, split_part(substring(url from '//[^/]+([^?#]+)'), '/', 2) AS pathl
	, split_part(substring(url from '//[^/]+([^?#]+)'), '/', 3) AS path2
FROM access_log
;

-- 지정한 값의 날짜/시각 데이터 추출하기(문자열을 날짜 자료형, 타임스탬프 자료형으로 변환)
DROP TABLE IF EXISTS purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id varchar(255)
  , amount      integer
  , coupon      integer
);

INSERT INTO purchase_log_with_coupon
VALUES
    ('10001', 3280, NULL)
  , ('10002', 4650,  500)
  , ('10003', 3870, NULL)
;

SELECT
	CAST('2016-01-30' AS date) AS dt
	, CAST('2016-01-30 12:00:00' AS timestamp) AS stamp
;
