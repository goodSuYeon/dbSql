<그룹함수>
 SELECT 행을 묶을 컬럼, 그룹함수 
 FROM 테이블명
 [WHERE]
 GROUP BY 행을 묶을 컬럼; 

SELECT *
FROM emp
ORDER BY deptno;

-- deptno 그룹함수 써서 총 3부분으로 나눠짐 10,20,30
-- 나눈 것 중 급여가 가장 작은 값 MIN(sal)
SELECT deptno, COUNT(*), MIN(sal),MAX(sal),SUM(sal),AVG(sal)  
FROM emp
GROUP BY deptno;

SELECT deptno,ename, COUNT(*), MIN(sal),MAX(sal),SUM(sal),AVG(sal) 
FROM emp
GROUP BY deptno,ename;

--특징1. 
--전체 직원(모든 행을 대상으로.)중에 가장 많은 급여를 받는 사람의 값
  : 전체 행을 대상으로 그룹핑을 할 경우 GROUP BY 절을 기술하지 않는다. 
   한마디로! 전체직원중에 가장 큰 급여 값을 알 수는 있지만, 
           해당 급여를 받는 사람이 누군지는 그룹함수만 이용해서 구할순 없다.
   예시 --> emp테이블에서 가장 큰 급여를 받는 사람의 값이 5000인 것은 알지만,
           해당 사원이 누구인지는 그룹함숨나 사용해서는 누군지 식별할 수 없다   
SELECT deptno ,MAX(sal)
FROM emp
GROUP BY deptno;

-- 이런경우 X
SELECT deptno ,MAX(sal)
FROM emp;

-- NULL값이 아닌 행의 개수를 구할 때는 COUNT함수 사용이 좋음
COUNT 함수 * 인자
* : 행의 개수를 반환
컬럼 | 익스프레션: NULL값이 아닌 행의 개수 

SELECT COUNT(*), COUNT(mgr), COUNT(comm)
FROM emp;

-- SUM함수를 적용한 결과 차이. 두개는 다름.
SELECT SUM(sal + comm) , SUM(sal) + SUM(comm)
FROM emp;

--특징2. 그룹화 관련없는 상수들을 SELECT 절에 기술할 수 있다
SELECT deptno, SYSDATE, 'Test',1, COUNT(*)
FROM emp
GROUP BY deptno;

--특징3. SINGLE ROW 함수의 경우 WHERE 에 기술하는 것이 가능하다.
        ex) SELECT * 
            FROM emp WHERE ename = UPPER('smith');
            
 --특징3.그룹함수의 경우 WHERE에서 사용하는 것이 불가능하다.
        ==> HAVING 절에서 그룹함수 대한 조건을 기술하여 행을 제한 할 수 있다.
 
        ex) SELECT deptno, COUNT(*)     --실행 X
            FROM emp
            WHERE COUNT(*) >= 5
            GROUP BY deptno;
            
        ex) SELECT deptno, COUNT(*)     --실행 가능
            FROM emp
            GROUP BY deptno
            HAVING COUNT(*) >= 5;
            
 SELECT deptno, COUNT(*) --- 실행가능
 FROM emp
 WHERE sal > 1000
 GROUP BY deptno;
 
 -- GROUP BY 함수 사용 무
SELECT MAX(sal) MAX_SAL, MIN(sal) MIN_SAL,
       ROUND(AVG(sal), 2) AVG_SAL ,SUM(sal) SUM_COUNT,
       COUNT(sal) COUNT_SAL, COUNT(mgr) COUNT_MGR, 
       COUNT(*) COUNT_ALL    -- 행의 수가 궁금할 때. 
FROM emp; 
 -- GROUP BY 함수 사용 유
SELECT deptno, MAX(sal) MAX_SAL, MIN(sal) MIN_SAL
             , ROUND(AVG(sal),2) AVG_SAL, SUM(sal) SUM_SAL
             , COUNT(sal) COUNT_SAL , COUNT(mgr) COUNT_MGR
             , COUNT(*) COUNT_ALL
FROM emp
GROUP BY deptno;

PPT 
195p (deptno 대신 부서명이 나올 수 있도록 해라.)
SELECT DECODE(deptno, 10, 'ACCOUNTING', 20 , 'RESEARCH', 30, 'SALES')dname
             , MAX(sal) MAX_SAL, MIN(sal) MIN_SAL
             , ROUND(AVG(sal),2) AVG_SAL, SUM(sal) SUM_SAL
             , COUNT(sal) COUNT_SAL , COUNT(mgr) COUNT_MGR
             , COUNT(*) COUNT_ALL
FROM emp
GROUP BY deptno;

ppt 
196p
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm, COUNT(hiredate) cnt
FROM emp
GROUP BY  TO_CHAR(hiredate, 'yyyymm');

ppt 
197p -- 실습grp5
SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyy, COUNT(hiredate) cnt
FROM emp
GROUP BY  TO_CHAR(hiredate, 'yyyy');

ppt 
198p -- 실습grp6
SELECT count(count(deptno)) cnt
FROM dept
GROUP BY deptno;

ppt 
199p -- 실습grp7
SELECT count(count(deptno)) cnt
FROM emp
GROUP BY deptno;

NATURAL JOIN : 조인하고자 하는 테이블의 컬럼명이 같은 컬럼끼리 연결
                컬럼의 값이 같은 행들끼리 연결
                SELECT 컬럼
                FROM 테이블명 NATURAL JOIN 테이블명;

조인 컬럼에 테이블 한정자를 붙이면 NATURAL JOIN 에서는 에러로 취급한다. 
emp.deptno --불가능 
deptno    --가능
emp.empno --가능
SELECT empno, deptno, dname
FROM emp NATURAL JOIN dept;

NATURAL JOIN을 ORACLE 문법으로
1. FROM 절에 조인할 테이블을 나열한다.
2. WHERE 절에 테이블 조인 조건을 기술한다.

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 인라인뷰 별칭처럼, 테이블 별칭을 부여하하는게 가능
-- 컬럼과 다르게 AS키워드는 붙이지 않는다.
SELECT *
FROM emp e, dept d
WHERE e.deptno = d.deptno;

ANSI_SQ;L : JOIN WITH USING
    조인하려는 테이블간 같은 일므의 컬럼이 2개 이상일 때,
    하나의 컬럼만으로 조인을 하고 싶을때 사용.
    SELECT *
    FROM emp JOIN dept USING(deptno);
OFACLE 문법
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

ANSI-SQL : JOIN WITH ON -- 조인 조건을 개발자가 직접 기술

           NATURAL JOIN, JOIN WITH USING 절에 JOIN WITH ON절을 통해서 표현가능
ANSI 방법 ------------
SELECT *
FROM emp JOIN dept ON(emp.deptno = dept.deptno)  -- 내가 직접 기술 
WHERE emp.deptno IN(20,30);

ORACLE 방법 --------------
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno IN(20,30);

논리적인 형태에 따른 조인 구분
1. SELF JOIN : 조인하는 테이블이 서로 같은 경우  
     SELECT e.empno, e.ename, e.mgr, m.ename    --오른쪽(m 테이블)은 해당 직원정보 참조
     FROM emp e JOIN emp m ON( e.mgr = m.empno);
     
위의 ANSI -> ORACLE로 작성하는 경우 ------
   SELECT e.empno, e.ename, e.mgr, m.ename  
   FROM emp e , emp m 
   WHERE e.mgr = m.empno;

KING의 경우 mgr 컬럼의 값이 NULL 이기 때문에 e.mgr = m.empno 조건을 충족 시키지 못함
그래서 조인이 실패해서 14건중 13건에 데이터만 조회된다.

2. NONEQUI JOIN : 조인조건이 = 이 아닌 경우
     SELECT *
     FROM emp, dept
     WHERE emp.empno = 7369
     AND emp.deptno != dept.deptno;
     
emp테이블의 sal를 이용해서 등급을 구하기

SELECT * FROM salgrade;
SELECT sal FROM emp;

ORACLE문법-----
SELECT empno, ename, sal, grade
FROM emp , salgrade
WHERE emp.sal >= salgrade.losal     -- sal >= losal  이렇게도 가능.
AND emp.sal <= salgrade.hisal;

SELECT empno, ename, sal, grade
FROM emp , salgrade
WHERE sal BETWEEN losal AND hisal;  -- BETWEEN AND 가능. 

ANSI문법-----
SELECT empno, ename, sal, grade
FROM emp JOIN salgrade
ON (sal >= losal AND sal <= hisal); 

PPT
216P - join0_1

PPT
217P - join0_2

PPT
218P - join0_3

PPT
219P - join0_4