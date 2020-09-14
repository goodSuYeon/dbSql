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
            

--고객테이블
SELECT *
FROM customer;

--제품테이블
 --PID : 제품번호 , PNM : 제품이름
SELECT *
FROM product;

--고객애음주기 
 -- CID : 고객id , PID : 제품id , DAY  : 1-7(일-토) , CNT : 수량count
SELECT *
FROM cycle;

--PPT 224
[join4]
--ORACLE 방식
SELECT customer.cid, cnm, cycle.pid, cycle.day, cycle.cnt
FROM customer , cycle 
WHERE customer.cid = cycle.cid
AND customer.cnm IN('brown','sally');

--PPT 225
[join5]
EXPLAIN PLAN FOR
SELECT cu.*, p.*, cy.day, cy.cnt  -- cu.*  ㅡ> cu.cid, cu.cnm
FROM customer cu, cycle cy, product p
WHERE cu.cid = cy.cid 
AND p.pid = cy.pid
AND cu.cnm IN('brown', 'sally');

 --실행계획 보기
SELECT *
FROM TABLE(dbms_xplan.display);
-----------------------------------------
SELECT 
FROM 
(SELECT customer.*, cycle.pid, cycle.day, cycle.cnt
 FROM customer, cycle
 WHERE customer.cid = cycle.cid
 AND customer.cnm IN('brown','sally'))a
 
 SQL : 실행에 대한 순서가 없다.
       조인할 테이블에 대해서 FROM 절에 기술한 순으로 테이블을 읽지 않음.
       FROM customer, cycle, product --> 오라클에서는 product 테이블부터 읽을 수도 있다.
       

사번(사원번호), 사원의이름, 관리자 사번, 관리자 이름
   --KING의 경우 mgr 컬럼의 값이 NULL이기 때문에 조인에 실패함 ㅡ> 13건만 조회됨
--ORACLE 방식   
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp e, emp m
WHERE e.mgr = m.empno;    --사원의 매니저쪽 정보 읽기


--ANSI 방식
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);  --LEFT OUTER JOIN의 경우 14건 모두 조회됨.

SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp m RIGHT OUTER JOIN emp e ON(e.mgr = m.empno);  --RIGHT OUTER JOIN의 경우도 결과 동일함.

--ORACLE 방식 : 데이터가 없는 쪽의 컬럼에 (+)기호를 붙인다.
               ANSI-SQL 기준 테이블 반대편 테이블의 컬럼에 (+)을 붙인다.
               WHERE절 연결 조건에 적용
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp e , emp m 
WHERE e.mgr = m.empno(+);


--문제. 사원의 부서가 10번인 사람들만 조회되도록 부서 번호 조건을 추가하기
SELECT e.empno, e.ename, e.mgr, m.ename 
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND e.deptno = 10);

--조건을 WHERE절에 기술한 경우
    --> OUTER JOIN이 아닌 INNER 조인 결과가 나온다.
SELECT e.empno, e.ename,e.deptno, e.mgr, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;

SELECT e.empno, e.ename,e.deptno, e.mgr, m.ename, m.deptno
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.deptno = 10;

--컬럼 갯수가 틀려 UNION(합집합:중복제거) 할 수 없다.
SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
UNION              --합집합
SELECT e.ename, m.ename        --> e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
MINUS              --차집합
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);


SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
UNION
SELECT e.ename, m.ename        --> e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)
INTERSECT          --교집합
SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno);

PPT 248
[outerjoin1]
--ORACLE 방식
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod b, prod p
WHERE b.buy_prod(+) = p.prod_id
  AND b.buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD');
--ANSI 방식
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p 
ON(b.buy_prod = p.prod_id AND b.buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'));


--PPT 226
[join6]

