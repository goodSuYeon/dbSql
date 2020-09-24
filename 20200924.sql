-- FIRST : 조건에 만족하는 "첫번째 구문"의 INSERT만 실행  

INSERT FIRST
    WHEN eno >= 9500 THEN
        INTO emp_test VALUES (eno, enm)
    WHEN eno >= 9000 THEN
        INTO emp_test2 VALUES (eno, enm)
SELECT 9000 eno, 'brown' enm FROM dual
UNION ALL
SELECT 9500, 'sally' FROM dual;

SELECT *
FROM emp_test;

--merge구문을 사용하지 않고 개발하려면 적어도 2개의 sql을 실행해야함
1. SELECT 'X'
   FROM emp_test
   WHERE empno = 9000;
2-1. 1번에서 조회된 데이터가 없을 경우 INSERT INTO emp_test VALUES(9000,'brown');
2-2. 2번에서 조회된 데이터가 있을 경우 UPDATE emp_test SET ename = 'brown' WHERE empno = 9000;

/*
 - MERGE INTO 변경/신규할입력할 테이블
         USING 테이블 | 뷰 | 인라인뷰
         ON (INTO절과 USING절에 기술한 테이블의 연결조건)
   WHEN MATCHED THEN 
         UPDATE SET 컬럼 = 값, ...;
   WHEN NOT MATCHED THEN
          INSERT [(컬럼1, 컬럼2,...)] VALUES (값1, 값2...);
*/

MERGE INTO emp_test
    USING (SELECT 9000 eno, 'brown' enm
           FROM dual) a
    ON (emp_test.empno = a.eno)
WHEN MATCHED THEN 
    UPDATE SET ename = a.enm
WHEN NOT MATCHED THEN
    INSERT VALUES (a.eno, a.enm);

select * from emp;

SELECT *
FROM emp_test,
    (SELECT 9000 eno, 'brown' enm
     FROM dual) a
WHERE emp_test_empno = a.eno;

INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7499);

-- emp테이블을 이용하여 emp테이블에 존재하고 emp_test에는 없는 사원에 대해서는 
-- emp_test 테이블에 신규로 입력해보자.   
  -- (emp. emp_test 양쪽에 존재하는 사원은 이름에 이름 || '_M' 표시)
MERGE INTO emp_test 
    USING emp 
    ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp_test.ename || '_M'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno , emp.ename);

SELECT * FROM emp_test;

--PPT 17
-- 실습GROUP_AD1
SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno
UNION ALL
SELECT NULL,SUM(sal)
FROM emp
ORDER BY deptno;

--위의 쿼리를 레포트 그룹 함수를 적용하면
SELECT deptno, SUM(sal)
FROM emp
GROUP BY ROLLUP(deptno);

GROUP BY ROLLUP(deptno)

-- 오른쪽 컬럼을 하나씩 제거하며 group by를 한다.
GROUP BY deptno
GROUP BY ==> 전체

GROUP BY ROLLUP(deptno, job)
GROUP BY deptno, job
UNION ALL
GROUP BY deptno
UNION ALL
GROUP BY ==> 전체

SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

-- 위의 ROLLUP을 해석하면 ↓ -- 
SELECT job , deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, deptno
UNION ALL
SELECT job , deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job
UNION ALL
SELECT job , deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp;

-- GROUPING(col) 함수 : rollup, cube절을  사용한 SQL에섬나 사용이 가능한 함수 
 /*                      인자 col은 GROUP BY절에 기술된 컬럼만 사용 가능
                       1,0을 반환
                       1 : 해당 컬럼이 소계 계산에 사용 된 경우
                       0 : 해당 컬럼이 소계 게산에 사용 되지 않은 경우
*/
                       
SELECT job, deptno,
       GROUPING(job), GROUPING(deptno),
       SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY rollup(job, deptno);

--PPT 25
-- 실습GROUP_AD2

--또는 CASE END 사용해서.
SELECT CASE
            WHEN GROUPING(job) = 1 THEN '총계'
            ELSE job
       END job, deptno,
       GROUPING(job), GROUPING(deptno),
       SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY rollup(job, deptno);

--또는 DECODE함수 사용해서.
SELECT DECODE(GROUPING(job),1,'총계',job) job ,deptno,
       GROUPING(job), GROUPING(deptno),
       SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY rollup(job, deptno);

 --NVL사용은 안하는게 좋음.
   --> 이유는? null값이 아닌 실제 데이터의 null인지 GROUP BY에 의해 null이 표현 된것인지는
   -- GROUPING 함수를 통해서만 알 수 있다.
   
   
--PPT 26
-- 실습GROUP_AD2-1
SELECT DECODE(GROUPING(job),1,'총',job) job,
       DECODE(GROUPING(job),1,'계', DECODE(GROUPING(deptno),1,'소계',deptno)) deptno,
 --또는 DECODE(GROUPING(job)+GROUPING(deptno), 2 , '계', 1, '소계' deptno) 
       SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY rollup(job, deptno);


--PPT 27
-- 실습GROUP_AD3
SELECT deptno, job, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY rollup(deptno,job)
ORDER BY deptno;

--PPT 28
-- 실습GROUP_AD4
SELECT d.dname , job , SUM(sal + NVL(comm,0))sal
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY rollup(d.dname, job)
ORDER BY dname;

-- PPT 29
-- 실습GROUP_AD5 (OUTER JOIN이라 NVL함수 사용함)
SELECT NVL(d.dname,'총합'), 
       job , SUM(sal + NVL(comm,0)) sal
FROM emp e , dept d
WHERE e.deptno = d.deptno
GROUP BY rollup(d.dname, job);

--GROUPING SETS
-- : 개발자가 필요로 하는 서브그룹을 직접 나열하는 형태로 사용 할 수 있다.
 -- GROUP BY GROUPING SETS (col1, col2)
  --> GROUP BY col1
  --> GROUP BY col2
-- 예시 GROUP BY GROUPING SETS ((col1, col2), col1)

SELECT job, deptno, SUM(NVL(sal + comm, 01)) sal
FROM emp
GROUP BY GROUPING SETS (job, deptno);





