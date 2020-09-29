비상호 연관 서브쿼리
--전체직원의 급여 평균보다 높은 급여를 받는 사원들 조회
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
              FROM emp);
              
상호 연관 서브쿼리             
-- 본인이 속한 부서의 급여 평균보다 높은 급여를 받는 사람들을 조회
SELECT * 
FROM emp e
WHERE sal > (SELECT AVG(sal)
              FROM emp b
              WHERE deptno = e.deptno);

PPT 281
[실습 sub4]
INSERT INTO dept VALUES (99, 'ddit', 'deajeon');  --테스트용 테이터 추가
SELECT *
FROM dept 
WHERE deptno NOT IN(SELECT deptno
                    FROM emp ); 

PPT 282
[실습 sub5]                    
SELECT * 
FROM product  
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);
                  
PPT 283
[실습 sub6]
--데이터를 보면 
--cid가 1번인 고객은 pid가 100,400
--cid가 2번인 고객은 pid가 100,200
       
SELECT * 
FROM cycle 
WHERE cid = 1
AND pid IN(SELECT pid
           FROM cycle 
           WHERE cid = 2);             
             
PPT 284           ------과제
[실습 sub7]      
SELECT cu.cid, cu.cnm, p.pid, p.pnm, cy.day, cy.cnt
FROM customer cu, cycle cy, product p
WHERE cu.cid = 1 
AND cy.cid IN (SELECT 
              FROM customer
              WHERE c.cid = 2
             );
             
SELECT * FROM product;
 SELECT * FROM cycle; 
 SELECT * FROM customer;
 
EXISTS 연산자
: 조건을 만족하는 서브 쿼리의 행이 존재하면 TRUE
 EXISTS연산자는 'X' 로 표현.
 EXISTS연산자는 보통 상호연관쿼리로 쓰인다.
 서브쿼리의 결과가 있는지/없는지 체크한다.(TRUE/ FALSE)
 
SELECT * 
FROM emp e
WHERE EXISTS (SELECT *
              FROM emp m
              WHERE e.mgr = m.empno);     --KING(mgr이 NULL을 제외한 13명의 데이터만 조회됨
              
 SELECT * 
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);                
 
PPT 286        
[실습 sub8]                  
SELECT a.*
FROM emp a, emp b
WHERE a.mgr = b.empno;

SELECT *
FROM emp c
WHERE EXISTS (SELECT 'X'
              FROM emp d
              WHERE d.empno = c.mgr);
 
PPT 287        
[실습 sub9]    
SELECT *
FROM product p 
WHERE EXISTS (SELECT 'X'
              FROM cycle c
              WHERE p.pid = c.pid        --주의!!!!
              AND c.cid = 1 );
              
PPT 288   
[실습 sub10]
SELECT *
FROM product p
WHERE NOT EXISTS (SELECT 'X'
                  FROM cycle c
                  WHERE p.pid = c.pid      
                  AND c.cid = 1 );
                  
--연산집함 (UNION, UNION ALL, INTERSECT, MINUS)

--위아래 집합이 동일하기 때문에 합집합을 하더라도 행이 추가되지는 않는다.
SELECT empno, ename
FROM emp
WHERE deptno = 10
UNION
SELECT empno, ename
FROM emp
WHERE deptno = 10;

--위아래 집합에서 7369 사번은 중복되므로 한번만 나오게 된다.(전체행은 3건)
SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7566)
UNION 
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7782);

--UNION ALL 연산자는 중복제거 단계가 없다. 총 데이터 4개의 행
SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7566)
UNION ALL
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7782);

-- 두 집합의 공통된 부분은 7369행뿐이다. 총 데이터 1개의 행
SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7566)
INTERSECT 
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7782);

--위 집합에서 아래집합의 행을 제거하고 남은 행. 총 1개(7566)
SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7566)
MINUS 
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7782);


집합연산자 특징
1. 컬럼명은 첫번째 집합의 컬럼명을 따라간다.(Alias를 부여하게 된다면.)
2. order by 절은 가장 마지막 집합에 적용한다. (order by절을 마지막집합에 쓰지 않고 하려면 INLINE-VIEW 사용)

SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7566)
UNION ALL 
SELECT empno, ename
FROM emp
WHERE empno IN(7369,7782);