-- SQLite는 연결할 때마다 외래 키 기능을 켜야 한다. (SQLite 전용 설정)
PRAGMA foreign_keys = ON;

-- Q01. 평점 4점 이상인 최근 리뷰를 최대 5개 확인한다. (기본 조회)
SELECT id, movie_id, rating, comment, created_at
FROM review
WHERE rating >= 4
ORDER BY created_at DESC
LIMIT 5;

-- Q02. 2022년 이후에 개봉한 영화를 최신순으로 최대 5개 확인한다. (기본 조회)
SELECT id, title, release_year
FROM movie
WHERE release_year >= 2022
ORDER BY release_year DESC, title ASC
LIMIT 5;

-- Q03. 상영 시간이 100분 이상인 영화 중 가장 긴 3편을 확인한다. (기본 조회)
SELECT id, title, running_time
FROM movie
WHERE running_time >= 100
ORDER BY running_time DESC, title ASC
LIMIT 3;

-- Q04. 2025년 2월 이후 가입한 회원을 가입일순으로 최대 5명 확인한다. (기본 조회)
SELECT id, name, email, joined_at
FROM member
WHERE joined_at >= '2025-02-01'
ORDER BY joined_at ASC
LIMIT 5;

-- Q05. 영화와 장르를 INNER JOIN하여 각 영화의 장르를 확인한다. (조인)
SELECT movie.id, movie.title, genre.name AS genre_name
FROM movie
INNER JOIN genre ON movie.genre_id = genre.id
ORDER BY movie.id;

-- Q06. 리뷰와 회원을 INNER JOIN하여 리뷰 작성자를 확인한다. (조인)
SELECT review.id, member.name AS member_name, review.rating, review.comment
FROM review
INNER JOIN member ON review.member_id = member.id
ORDER BY review.id;

-- Q07. 모든 장르를 LEFT JOIN하여 등록된 영화가 없는 장르도 확인한다. (조인)
SELECT genre.id, genre.name AS genre_name, movie.title
FROM genre
LEFT JOIN movie ON genre.id = movie.genre_id
ORDER BY genre.id, movie.id;

-- Q08. 5점 리뷰의 작성자와 영화 정보를 INNER JOIN으로 함께 확인한다. (조인)
SELECT review.id, member.name AS member_name, movie.title, review.rating
FROM review
INNER JOIN member ON review.member_id = member.id
INNER JOIN movie ON review.movie_id = movie.id
WHERE review.rating = 5
ORDER BY review.id;

-- Q09. 영화별 리뷰 개수를 COUNT로 집계한다. (집계)
SELECT movie_id, COUNT(*) AS review_count
FROM review
GROUP BY movie_id
ORDER BY movie_id;

-- Q10. 영화별 평균 평점을 AVG로 집계한다. (집계)
SELECT movie_id, AVG(rating) AS average_rating
FROM review
GROUP BY movie_id
ORDER BY average_rating DESC, movie_id;

-- Q11. 회원별로 작성한 리뷰 평점의 합계를 SUM으로 집계한다. (집계)
SELECT member_id, SUM(rating) AS total_rating
FROM review
GROUP BY member_id
ORDER BY total_rating DESC, member_id;

-- Q12. 서브쿼리로 리뷰를 한 번도 작성하지 않은 회원을 찾는다. (서브쿼리)
SELECT id, name, email
FROM member
WHERE id NOT IN (
    SELECT member_id
    FROM review
)
ORDER BY id;

-- Q13. 5번 리뷰의 감상 내용을 수정하고 변경된 행을 확인한다. (수정)
UPDATE review
SET comment = '배경 음악과 영상이 기억에 남습니다.'
WHERE id = 5;

-- Q13 실행 결과 확인용 SELECT이며 핵심 쿼리 수에는 포함하지 않는다.
SELECT id, comment
FROM review
WHERE id = 5;

-- Q14. 실습용 11번 리뷰를 삭제하고 리뷰가 10행 남았는지 확인한다. (삭제)
DELETE FROM review
WHERE id = 11;

-- Q14 실행 결과 확인용 SELECT이며 핵심 쿼리 수에는 포함하지 않는다.
SELECT COUNT(*) AS remaining_review_count
FROM review;

-- Q15. 영화별 리뷰 조회와 JOIN에서 자주 찾는 movie_id에 인덱스를 만든다. (인덱스)
CREATE INDEX idx_review_movie_id ON review(movie_id);

-- Q15 실행 결과 확인용이다. sqlite_master는 SQLite 전용 시스템 테이블이다.
SELECT name AS index_name, tbl_name AS table_name
FROM sqlite_master
WHERE type = 'index'
  AND name = 'idx_review_movie_id';
