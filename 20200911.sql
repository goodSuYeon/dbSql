SELECT *
FROM prod;

SELECT *
FROM lprod;

실습 join1 ]
ORACLE 문법 사용)
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p , lprod l
WHERE p.prod_lgu = l.lprod_gu;

JOIN ON 사용)
SELECT l.lprod_gu, l.lprod_nm, p.prod_id, p.prod_name
FROM prod p JOIN lprod l ON (p.prod_lgu = lprod_gu);


SELECT *
FROM prod;

SELECT *
FROM buyer;

실습 join2 ]
ORACLE 문법)
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod p , buyer b
WHERE p.prod_buyer = b.buyer_id;
JOIN ON 사용)
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod p JOIN buyer b ON (p.prod_buyer = b.buyer_id);


SELECT *
FROM cart;

실습 join3 ]
ORACLE 문법)
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member m , cart c , prod p
WHERE m.mem_id = c.cart_member
    AND p.prod_id = c.cart_prod;
    
ANSI-SQL 문법)
테이블 JOIN 테이블 ON()
      JOIN 테이블 ON()

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member m JOIN cart c ON (mem_id = cart_member) 
                JOIN prod p ON (cart_prod = prod_id);
                