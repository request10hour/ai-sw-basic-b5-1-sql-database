# B5-1. SQL로 만드는 나만의 데이터베이스

SQLite로 만든 작은 영화 평점 데이터베이스입니다. 과제의 기본 요구사항만 구현했으며, 백엔드 프레임워크와 보너스 과제는 사용하지 않았습니다.

## 파일 구성

| 파일 | 내용 |
|---|---|
| `schema.sql` | 4개 테이블과 PK, FK, 제약조건 생성 |
| `seed.sql` | 각 테이블에 10행 이상의 샘플 데이터 입력 |
| `queries.sql` | 과제 분류에 맞춘 핵심 쿼리 15개 |
| `results/query_results.txt` | 15개 쿼리와 실행 결과 |
| `results/screenshots/` | Q01~Q15의 실제 GUI 터미널 실행 화면 15장 |
| `results/setup_verification.txt` | 테이블별 행 수와 FK 구성 확인 결과 |
| `movie_rating.db` | 위 SQL을 실행해서 만든 SQLite 데이터베이스 |

## 데이터 모델

| 테이블 | 역할 | 최종 행 수 |
|---|---|---:|
| `genre` | 영화 장르 | 10 |
| `member` | 리뷰를 작성하는 회원 | 10 |
| `movie` | 장르에 속하는 영화 | 10 |
| `review` | 회원이 영화에 남긴 평점과 감상 | 10 |

관계는 다음과 같습니다.

- `genre` 1:N `movie`: 한 장르에는 여러 영화가 속할 수 있습니다.
- `member` 1:N `review`: 한 회원은 여러 리뷰를 작성할 수 있습니다.
- `movie` 1:N `review`: 한 영화에는 여러 리뷰가 달릴 수 있습니다.

각 테이블의 `id`는 행을 구분하는 `INTEGER` PK입니다. 이름, 이메일, 제목, 날짜는 `TEXT`로 저장했습니다. 날짜는 `YYYY-MM-DD` 형식이라 문자열 상태에서도 날짜순 정렬이 가능합니다. 개봉 연도, 상영 시간, 평점은 계산과 비교가 쉬운 `INTEGER`를 사용했습니다.

`review.movie_id`에는 `idx_review_movie_id` 인덱스를 적용했습니다. 영화별 리뷰를 조회하거나 `movie`와 `review`를 JOIN할 때 이 값을 반복해서 찾기 때문입니다.

## 실행 방법

Ubuntu 24.04 Multipass VM의 SQLite CLI에서 검증했습니다. 프로젝트 디렉터리에서 다음 순서로 실행합니다.

```bash
sqlite3 movie_rating.db < schema.sql
sqlite3 movie_rating.db < seed.sql
sqlite3 -echo -header -column movie_rating.db < queries.sql > results/query_results.txt
```

다시 실행할 때도 같은 순서를 사용합니다. `schema.sql`이 기존 테이블을 지우고 새로 만들기 때문입니다. SQLite의 외래 키 검사는 연결할 때마다 켜야 하므로 세 SQL 파일 모두 `PRAGMA foreign_keys = ON`으로 시작합니다.

## 핵심 쿼리 구성

| 번호 | 분류 | 내용 |
|---|---|---|
| Q01~Q04 | 기본 조회 4개 | 모든 쿼리에 `WHERE`, `ORDER BY`, `LIMIT` 포함 |
| Q05~Q08 | 조인 4개 | `INNER JOIN` 3개, `LEFT JOIN` 1개 |
| Q09~Q11 | 집계 3개 | `COUNT`, `AVG`, `SUM`과 `GROUP BY` 사용 |
| Q12 | 서브쿼리 1개 | 리뷰를 작성하지 않은 회원 조회 |
| Q13~Q14 | 수정·삭제 2개 | `UPDATE` 1개, `DELETE` 1개 |
| Q15 | 인덱스 1개 | `review.movie_id` 인덱스 생성 |

`review`는 처음에 11행을 입력합니다. Q14에서 한 행을 삭제한 뒤에도 과제 기준인 10행이 남습니다. Q13~Q15 뒤의 짧은 `SELECT`는 실행 결과를 보여주기 위한 확인문이며, 15개 핵심 쿼리 수에는 포함하지 않습니다.

### GUI 실행 결과

각 이미지는 Multipass VM `ai-sw-b5-1`의 실제 셸 프롬프트에서 `sqlite3` 명령을 입력하고 SQL과 실행 결과가 출력된 장면을 한 화면에 보여줍니다. 전체 텍스트 결과는 [`query_results.txt`](results/query_results.txt)에서도 확인할 수 있습니다.

화면의 `q01.sql`~`q15.sql`과 `q01.db`~`q15.db`는 각 쿼리를 독립적으로 캡처하기 위해 제출 파일을 바탕으로 VM 안에서 만든 임시 파일이며, 저장소의 실제 제출 SQL은 `queries.sql`입니다.

| [Q01](results/screenshots/q01.png) | [Q02](results/screenshots/q02.png) | [Q03](results/screenshots/q03.png) | [Q04](results/screenshots/q04.png) | [Q05](results/screenshots/q05.png) |
|---|---|---|---|---|
| [Q06](results/screenshots/q06.png) | [Q07](results/screenshots/q07.png) | [Q08](results/screenshots/q08.png) | [Q09](results/screenshots/q09.png) | [Q10](results/screenshots/q10.png) |
| [Q11](results/screenshots/q11.png) | [Q12](results/screenshots/q12.png) | [Q13](results/screenshots/q13.png) | [Q14](results/screenshots/q14.png) | [Q15](results/screenshots/q15.png) |

## 동료평가 설명 포인트

- 엑셀은 한 표에서 데이터를 직접 관리하기 쉽지만, 이 DB는 장르·회원·영화·리뷰를 나누고 PK/FK 규칙으로 관계와 무결성을 관리합니다. 장르명이나 회원 정보를 리뷰마다 반복 저장하지 않아 중복도 줄어듭니다.
- PK는 각 행을 유일하게 식별하고, FK는 다른 테이블의 실제 PK만 참조하게 합니다. 예를 들어 한 `movie`의 PK를 여러 `review.movie_id`가 참조하므로 영화와 리뷰는 1:N 관계입니다.
- Q05와 Q06의 `INNER JOIN`은 양쪽에 연결된 행만 보여줍니다. Q07의 `LEFT JOIN`은 영화가 없는 판타지·뮤지컬 장르도 `NULL`과 함께 보여줍니다.
- Q09~Q11은 같은 ID를 `GROUP BY`로 묶고 각 그룹에 `COUNT`, `AVG`, `SUM`을 적용합니다.
- 가장 단계가 많은 Q12는 먼저 안쪽 쿼리로 리뷰 작성 회원 ID를 구하고, 바깥 쿼리에서 그 목록에 없는 회원을 찾습니다.
- 구현할 때는 DELETE 후 최소 행 수를 지키는 부분을 주의했습니다. 리뷰를 11행 준비하고 Q14에서 1행만 삭제해 최종 10행을 유지했습니다.
