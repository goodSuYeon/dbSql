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

--PPT 251
[outerjoin5]
SELECT p.pid, p.pnm, :cid cid, NVL(cy.day,0) day, NVL(cy.cnt,0) cnt
FROM cycle cy, product p
WHERE cy.pid(+) = p.pid
AND cy.cid(+) = 1;

--PPT 252
[outerjoin5]
SELECT cy.pid, p.pnm, cu.cid, cu.cnm, cy.day, cy.cnt
FROM cycle cy, product p, customer cu
WHERE cy.pid = p.pid

--------------------------------------------------------------------------
2020/09/15 수업

-- emp테이블의 행 건수(4) * demp 테이블의 행 건수(4) = 총 56건
SELECT * FROM emp, dept;

JOIN 하다가 WHERE절을 기술하지 않으면 CROSS JOIN

--PPT 258
SELECT cid, cnm, pid, pnm                    -- 또는 * 이거 가능.
FROM customer, product;



[서브쿼리(subquery)]
 : 쿼리 안에서 실행되는 쿼리
1. 서브쿼리 분류 : 서브쿼리가 사용되는 위치에 따른 분류
   (1)- SELECT : 스칼라 서브쿼리(SCALAR SUBQUERY)
   (2)- FROM   : 인라인 뷰(INLINE-VIEW)
   (3)- WHERE  : 서브쿼리 (SUB QUERY)
2. 서브쿼리 분류 : 서브쿼리가 반환하는 행, 컬럼의 개수에 따른 분류
   (1)- 단일행, 단일 컬럼
   (2)- 단일행, 복수 컬럼
   (3)- 복수행, 단일 컬럼
   (4)- 복수행, 복수 컬럼
3. 서브쿼리 분류 : 메인쿼리의 컬럼을 서브쿼리에서 사용여부에 따른 분류
   (1)- 상호 연관 서브쿼리 (CO-RELATED SUB QUERY)
     : 메인 쿼리의 컬럼을 서브 쿼리에서 사용하는 경우 
   (2)- 비상호 연관 서브쿼리 (NON-CORELATED SUB QUERY)
     : 메인 쿼리의 컬럼을 서브 쿼리에서 사용하지 않는 경우
     

SMITH가 속한 부서에 속한 사원들은 누가 있을까?
1.  SMITH가 속한 부서번호 구하기
2. 1번에서 구한 부서에 속해 있는 사원들 구하기

1. SELECT deptno
   FROM emp
   WHERE ename = 'SMITH';
2. SELECT *
   FROM emp
   WHERE deptno = 20;

위의 1,2쿼리를 한번에 사용해서 출력할 수 있는 것이 서브쿼리 !!!!!!!!!!!!  


--서브쿼리가 한개의 행 복수컬럼을 조회하고, 단일컬럼과 = 비교하는경우 ㅡㅡ> 에러
SELECT * 
FROM emp
WHERE deptno = (SELECT deptno, ename
                FROM emp
                WHERE ename = 'SMITH');       -- 단일행 단일컬럼

서브쿼리를 사용할 때 주의점
1. 연산자
2. 서브쿼리의 리턴 형태


--서브쿼리가 여러개의 행, 단일컬럼을 조회하는 경우 ㅡㅡ> 에러
 1. 사용되는 위치: WHERE - 서브쿼리
 2. 조회되는 행, 컬럼의 개수: 복수행, 단일컬럼
 3. 메인쿼리의 컬럼을 서브쿼리에서 사용 유무: 비상호연관 서브쿼리
SELECT * 
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'
                   OR ename = 'ALLEN'); 
                   
-- **** 서브쿼리, IN연산자를 통해서 많이 사용한다 ****
SELECT * 
FROM emp
WHERE deptno IN (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH'
                   OR ename = 'ALLEN');
                   
--PPT 265
[실습 sub1]
SELECT COUNT(*) 
FROM emp
WHERE sal >  (SELECT AVG(sal)
              FROM emp);
              
--PPT 268
[실습 sub3]
SELECT *
FROM emp
WHERE deptno IN (SELECT deptno 
                 FROM emp 
                 WHERE ename = 'SMITH'
                 OR ename = 'WARD');          --서브쿼리의 행 연산자가 여러개라 IN
                 
                 
----복수행연산자: IN (중요), ANY , ALL (중요빈도는 낮음)연산자----        
SAL 컬럼의 값이 800이나, 1250보다 작은 사원
 => SAL 컬럼의 값이 1250보다 작은 사원
SELECT *
FROM emp
WHERE sal < ANY (SELECT sal
                  FROM emp 
                  WHERE ename IN ('SMITH','WARD'));

SAL 컬럼의 값이 800보다 크면서 1250보다 큰 사원
 => SAL 컬럼의 값이 1250보다 큰 사원
SELECT *
FROM emp
WHERE sal > ALL (SELECT sal
                  FROM emp 
                  WHERE ename IN ('SMITH','WARD'));

관리자가 아닌 사원의 정보를 조회 --> 데이터가 나오지 않음.
SELECT *
FROM emp
WHERE empno NOT IN(SELECT mgr
                    FROM emp);
                    
pair wise 개념 : 순서쌍, 두가지 조건을 동시에 만족시키는 데이터를 조회할 때 사용
                AND논리연산자와 결과값이 다를 수 있다. 
서브쿼리 : 복수행, 복수컬럼
SELECT *
FROM emp
WHERE (mgr, deptno) IN(SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499,7782));
                        
SCALAR SUBQUERY : SELECT 절이 기술된 서브쿼리
                  하나의 컬럼
   ** 스칼라 서브 쿼리는 하나의 행, 하나의 컬럼을 조회하는 쿼리이어야 한다. **
SELECT dummy,(SELECT SYSDATE
              FROM dual)     --이게 '하나'의 컬럼. SCALAR SUBQUERY
FROM dual;

스칼라 서브쿼리가 복수의 행(4개), 단일 컬럼을 조회 --> 에러임.
SELECT empno, ename, deptno, (SELECT dname FROM dept)
FROM emp

emp 테이블과 스칼라 서브 쿼리를 이용하여 부서명 가져오기
기존: emp테이블과 dept테이블을 조인하여 컬럼을 확장

--deptno = deptno 에러발생임.
SELECT empno, ename, deptno,(SELECT dname FROM dept WHERE deptno = deptno)
FROM emp;

--deptno = emp.deptno 정상작동.
SELECT empno, ename, deptno,(SELECT dname FROM dept WHERE deptno = emp.deptno)
FROM emp;

상호연관 서브쿼리: 메인 쿼리의 컬럼을 서브쿼리에서 사용한 서브쿼리 
        - 서브쿼리만 단독으로 실행한느 것이 불가능 하다.
        - 메인쿼리와 서브쿼리의 실행 순서가 정해져 있다.
        - 메인쿼리가 항상 먼저 실행된다.
        
비상호연관 서브쿼리: 메인 쿼리의 컬럼을 서브쿼리에서 사용하지 않은 서브쿼리
        - 서브쿼리만 단독으로 실행하는 것이 가능하다.
        - 메인쿼리와 서브쿼리의 실행순서가 정해져 있지 않다.
          메인 -> 서브, 서브 -> 메인 둘다 가능
SELECT *
FROM dept
WHERE deptno IN(SELECT empno
                FROM emp);
