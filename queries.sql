-- SQLite는 연결할 때마다 외래 키 기능을 켜야 한다. (SQLite 전용 설정)
PRAGMA foreign_keys = ON;

-- Q01. 가격이 2,000원 이상인 상품을 비싼 순서로 최대 5개 확인한다. (기본 조회)
SELECT id, name, price, stock
FROM product
WHERE price >= 2000
ORDER BY price DESC, name ASC
LIMIT 5;

-- Q02. 재고가 10개 이하인 상품을 재고가 적은 순서로 최대 5개 확인한다. (기본 조회)
SELECT id, name, stock
FROM product
WHERE stock <= 10
ORDER BY stock ASC, name ASC
LIMIT 5;

-- Q03. 2026년 3월 이후 가입한 고객을 가입일순으로 최대 5명 확인한다. (기본 조회)
SELECT id, name, phone, joined_at
FROM customer
WHERE joined_at >= '2026-03-01'
ORDER BY joined_at ASC
LIMIT 5;

-- Q04. 2026년 7월 5일 이후 구매 기록을 최신순으로 최대 5건 확인한다. (기본 조회)
SELECT id, customer_id, product_id, quantity, purchased_at
FROM purchase
WHERE purchased_at >= '2026-07-05'
ORDER BY purchased_at DESC
LIMIT 5;

-- Q05. 상품과 카테고리를 INNER JOIN하여 앞의 상품 10개 분류를 확인한다. (조인)
SELECT product.id, product.name AS product_name, category.name AS category_name
FROM product
INNER JOIN category ON product.category_id = category.id
ORDER BY product.id
LIMIT 10;

-- Q06. 구매 기록과 고객을 INNER JOIN하여 구매자를 확인한다. (조인)
SELECT purchase.id, customer.name AS customer_name, purchase.quantity, purchase.purchased_at
FROM purchase
INNER JOIN customer ON purchase.customer_id = customer.id
ORDER BY purchase.id;

-- Q07. 카테고리를 LEFT JOIN하여 상품이 없는 분류를 확인한다. (조인)
SELECT category.id, category.name AS category_name, product.name AS product_name
FROM category
LEFT JOIN product ON category.id = product.category_id
WHERE product.id IS NULL
ORDER BY category.id;

-- Q08. 구매자, 상품, 수량과 결제 금액을 INNER JOIN으로 함께 확인한다. (조인)
SELECT purchase.id, customer.name AS customer_name, product.name AS product_name,
       purchase.quantity, product.price * purchase.quantity AS amount
FROM purchase
INNER JOIN customer ON purchase.customer_id = customer.id
INNER JOIN product ON purchase.product_id = product.id
ORDER BY purchase.id;

-- Q09. 카테고리별 상품 수를 COUNT로 집계하고 빈 카테고리도 확인한다. (집계)
SELECT category.id, category.name AS category_name, COUNT(product.id) AS product_count
FROM category
LEFT JOIN product ON category.id = product.category_id
GROUP BY category.id, category.name
ORDER BY category.id;

-- Q10. 카테고리별 상품 평균 가격을 AVG로 집계한다. (집계)
SELECT category.id, category.name AS category_name, AVG(product.price) AS average_price
FROM category
LEFT JOIN product ON category.id = product.category_id
GROUP BY category.id, category.name
ORDER BY category.id;

-- Q11. 고객별 구매 금액 합계를 SUM으로 집계한다. (집계)
SELECT customer.id, customer.name AS customer_name,
       SUM(product.price * purchase.quantity) AS total_amount
FROM customer
INNER JOIN purchase ON customer.id = purchase.customer_id
INNER JOIN product ON purchase.product_id = product.id
GROUP BY customer.id, customer.name
ORDER BY total_amount DESC, customer.id;

-- Q12. 서브쿼리로 구매 기록이 한 번도 없는 고객을 찾는다. (서브쿼리)
SELECT id, name, phone
FROM customer
WHERE id NOT IN (
    SELECT customer_id
    FROM purchase
)
ORDER BY id;

-- Q13. 판매된 코카콜라 2개의 재고를 차감하고 변경된 수량을 확인한다. (수정)
UPDATE product
SET stock = stock - 2
WHERE id = 1;

-- Q13 실행 결과 확인용 SELECT이며 핵심 쿼리 수에는 포함하지 않는다.
SELECT id, name, stock
FROM product
WHERE id = 1;

-- Q14. 실습용 11번 구매 기록을 삭제하고 구매가 10행 남았는지 확인한다. (삭제)
DELETE FROM purchase
WHERE id = 11;

-- Q14 실행 결과 확인용 SELECT이며 핵심 쿼리 수에는 포함하지 않는다.
SELECT COUNT(*) AS remaining_purchase_count
FROM purchase;

-- Q15. 상품별 구매 조회와 JOIN에서 자주 찾는 product_id에 인덱스를 만든다. (인덱스)
CREATE INDEX idx_purchase_product_id ON purchase(product_id);

-- Q15 실행 결과 확인용이다. sqlite_master는 SQLite 전용 시스템 테이블이다.
SELECT name AS index_name, tbl_name AS table_name
FROM sqlite_master
WHERE type = 'index'
  AND name = 'idx_purchase_product_id';
