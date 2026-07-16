# B5-1. SQL로 만드는 나만의 데이터베이스

SQLite로 만든 편의점 상품 구매 데이터베이스입니다. 과제의 기본 요구사항만 구현했으며, 백엔드 프레임워크와 보너스 과제는 사용하지 않았습니다.

## 파일 구성

| 파일 | 내용 |
|---|---|
| `schema.sql` | 4개 테이블과 PK, FK, 제약조건 생성 |
| `seed.sql` | 편의점 카테고리, 상품, 고객, 구매 데이터 입력 |
| `queries.sql` | 과제 분류에 맞춘 핵심 쿼리 15개 |
| `results/query_results.txt` | 15개 쿼리와 실행 결과 |
| `results/screenshots/` | Q01~Q15의 실제 SQLite 대화형 실행 화면 15장 |
| `results/setup_verification.txt` | 테이블별 행 수와 FK 동작 확인 결과 |
| `convenience_store.db` | 위 SQL을 실행해서 만든 SQLite 데이터베이스 |

## 데이터 모델

| 테이블 | 역할 | 최종 행 수 |
|---|---|---:|
| `category` | 상품의 분류 | 10 |
| `customer` | 상품을 구매하는 고객 | 10 |
| `product` | 카테고리에 속한 편의점 상품 | 22 |
| `purchase` | 고객의 상품 구매 기록 | 10 |

`purchase` 한 행은 한 고객이 한 상품을 수량만큼 구매한 기록입니다. 여러 상품을 구매하면 상품별로 행을 나눕니다. 단일 매장 실습으로 범위를 제한해 별도 매장 테이블은 만들지 않았습니다.

관계는 다음과 같습니다.

- `category` 1:N `product`: 한 카테고리에는 여러 상품이 속할 수 있습니다.
- `customer` 1:N `purchase`: 한 고객은 여러 구매 기록을 남길 수 있습니다.
- `product` 1:N `purchase`: 한 상품은 여러 번 구매될 수 있습니다.

각 테이블의 `id`는 행을 구분하는 `INTEGER` PK입니다. 이름과 전화번호, 날짜·시간은 `TEXT`로 저장했습니다. 날짜·시간은 `YYYY-MM-DD HH:MM` 형식이므로 문자열 상태에서도 시간순 정렬이 가능합니다. 가격, 재고, 수량은 계산과 비교에 알맞은 `INTEGER`를 사용했습니다.

상품명, 카테고리명, 고객 전화번호에는 `UNIQUE`를 적용했습니다. 필수 값에는 `NOT NULL`을 적용했고 가격·재고·수량에는 `CHECK`를 적용했습니다. 세 FK는 실제 부모 행만 참조하도록 SQLite 외래 키 검사를 켰습니다.

`purchase.product_id`에는 `idx_purchase_product_id` 인덱스를 적용했습니다. 상품별 구매 기록을 조회하거나 `product`와 `purchase`를 JOIN할 때 이 값을 반복해서 찾기 때문입니다.

## 실행 방법

Ubuntu 24.04 Multipass VM의 SQLite CLI에서 검증했습니다. 프로젝트 디렉터리에서 다음 순서로 실행합니다.

```bash
sqlite3 convenience_store.db < schema.sql
sqlite3 convenience_store.db < seed.sql
sqlite3 -echo -header -column -nullvalue NULL convenience_store.db < queries.sql > results/query_results.txt
```

다시 실행할 때도 같은 순서를 사용합니다. `schema.sql`이 기존 테이블을 지우고 새로 만들기 때문입니다. SQLite의 외래 키 검사는 연결할 때마다 켜야 하므로 세 SQL 파일 모두 `PRAGMA foreign_keys = ON`으로 시작합니다.

## 핵심 쿼리 구성

| 번호 | 분류 | 내용 |
|---|---|---|
| Q01~Q04 | 기본 조회 4개 | 모든 쿼리에 `WHERE`, `ORDER BY`, `LIMIT` 포함 |
| Q05~Q08 | 조인 4개 | `INNER JOIN` 3개, `LEFT JOIN` 1개 |
| Q09~Q11 | 집계 3개 | `COUNT`, `AVG`, `SUM`과 `GROUP BY` 사용 |
| Q12 | 서브쿼리 1개 | 구매 기록이 없는 고객 조회 |
| Q13~Q14 | 수정·삭제 2개 | `UPDATE` 1개, `DELETE` 1개 |
| Q15 | 인덱스 1개 | `purchase.product_id` 인덱스 생성 |

`purchase`는 처음에 11행을 입력합니다. Q14에서 실습용 한 행을 삭제한 뒤에도 과제 기준인 10행이 남습니다. Q13~Q15 뒤의 짧은 `SELECT`는 실행 결과를 보여주기 위한 확인문이며, 15개 핵심 쿼리 수에는 포함하지 않습니다.

### SQLite 대화형 실행 결과

각 이미지는 Multipass VM `ai-sw-b5-1`에서 SQLite 대화형 모드를 연 뒤 `sqlite>` 프롬프트에 해당 SQL을 한 줄씩 입력한 실제 터미널 화면입니다. 여러 줄 쿼리의 `...>` 프롬프트, 실행 결과, 다음 입력을 기다리는 마지막 `sqlite>` 프롬프트까지 한 화면에서 확인할 수 있습니다. 전체 텍스트 결과는 [`query_results.txt`](results/query_results.txt)에도 정리했습니다.

캡처에는 `schema.sql`과 `seed.sql`로 새로 준비한 독립 DB `q01.db`~`q15.db`를 사용합니다. 따라서 Q13~Q15의 변경이 다른 화면에 영향을 주지 않습니다. 이 DB들은 캡처용 임시 파일이며, 실제 제출 파일은 `convenience_store.db`와 `queries.sql`입니다.

| [Q01](results/screenshots/q01.png) | [Q02](results/screenshots/q02.png) | [Q03](results/screenshots/q03.png) | [Q04](results/screenshots/q04.png) | [Q05](results/screenshots/q05.png) |
|---|---|---|---|---|
| [Q06](results/screenshots/q06.png) | [Q07](results/screenshots/q07.png) | [Q08](results/screenshots/q08.png) | [Q09](results/screenshots/q09.png) | [Q10](results/screenshots/q10.png) |
| [Q11](results/screenshots/q11.png) | [Q12](results/screenshots/q12.png) | [Q13](results/screenshots/q13.png) | [Q14](results/screenshots/q14.png) | [Q15](results/screenshots/q15.png) |

## 동료평가 설명 포인트

- 엑셀 한 표에 카테고리·상품·고객·구매 정보를 반복해서 적는 대신 네 테이블로 나누고 PK/FK로 연결했습니다. 상품 가격이나 고객 전화번호를 구매 행마다 반복하지 않아 중복과 수정 실수를 줄입니다.
- PK는 각 행을 유일하게 식별하고, FK는 다른 테이블의 실제 PK만 참조하게 합니다. 예를 들어 한 `product`의 PK를 여러 `purchase.product_id`가 참조하므로 상품과 구매는 1:N 관계입니다.
- Q05와 Q06의 `INNER JOIN`은 양쪽에 연결된 행만 보여줍니다. Q07의 `LEFT JOIN`은 상품이 없는 빵류·캔디류·주류·신선식품도 `NULL`과 함께 보여줍니다.
- Q09~Q11은 같은 기준 값을 `GROUP BY`로 묶고 각 그룹에 `COUNT`, `AVG`, `SUM`을 적용합니다.
- 가장 단계가 많은 Q12는 먼저 안쪽 쿼리로 구매한 고객 ID를 구하고, 바깥 쿼리에서 그 목록에 없는 고객을 찾습니다.
- 구현할 때는 DELETE 후 최소 행 수를 지키는 부분을 주의했습니다. 구매를 11행 준비하고 Q14에서 1행만 삭제해 최종 10행을 유지했습니다.
