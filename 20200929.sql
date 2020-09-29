-- 분석함수 LAG, LEAD
 --사원번호, 사원이름, 입사일자, 급여, 급여순위가 자신보다 "한단계 낮은" 사람의 급여를 구하기
 ---(단, 급여가 같을 경우 입사일자가 빠른 사람이 높은 우선순위)
SELECT empno, ename, hiredate, sal , LEAD(sal) over (ORDER BY sal DESC, hiredate ASC)
FROM emp;

--실습 ana5
SELECT empno , ename, hiredate, sal, LAG(sal) over (ORDER BY sal DESC, hiredate ASC)
FROM emp; 

--실습 ana6
SELECT empno, ename, hiredate, job, sal,
       LAG(sal) over (PARTITION BY job ORDER BY sal DESC, hiredate ASC) lag_sal
FROM emp;

--이전/이후 n행 값 가져오기 
 --LAG(colum, 건너띌행수 - default 1)
SELECT empno, ename, hiredate, job, sal,
       LAG(sal,2,0) over (ORDER BY sal DESC, hiredate ASC) lag_sal
FROM emp;

--WINDOWING함수 
 -- 현재행 이전의 모든 행부터 ~ 현재행까지 
 -- 이말은 즉, ** 행들을 정렬(ORDER BY)할 수 있는 기준이 있어야한다 **
 
--1방법. ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 사용한 것
SELECT empno, ename, sal 
     , SUM(sal) over (ORDER BY sal, hiredate ASC 
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp
ORDER BY sal, hiredate ASC;

--2방법. ROWS UNBOUNDED PRECEDING 를 사용한 것
SELECT empno, ename, sal 
     , SUM(sal) over (ORDER BY sal, hiredate ASC ROWS UNBOUNDED PRECEDING) c_sum
FROM emp
ORDER BY sal, hiredate ASC;

-- 선행하는 이전 첫번째 행부터 후행하는 이후 첫번째행까지 조회하기
  --( 선행 - 현재행 - 후행 ) 총 3개의 행에 대한 급여 합을 구하기
SELECT empno, ename, sal
      ,SUM(sal) over (ORDER BY sal, hiredate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)c_sum
FROM emp;

--실습 ana7
SELECT empno, ename, deptno, sal
     ,SUM(sal) over (PARTITION BY deptno ORDER BY sal,empno ROWS UNBOUNDED PRECEDING) c_sum
FROM emp;

--ROWS ,  RANGE , NO WINDOWING 차이
SELECT empno, ename, deptno, sal
     ,SUM(sal) over (ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_sum
     ,SUM(sal) over (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum
     ,SUM(sal) over (ORDER BY sal) c_sum

FROM emp;


SELECT /* SQL_TEST */ * FROM emp;
Select /* SQL_TEST */ * FROM emp;
Select /* SQL_TEST */ *   FROM emp;

--10번 부서에 속하는 사원 정보를 조회하기
  --> 특정 부서에 속하는 사원 정보를 조회하기
 Select /* SQL_TEST */ * FROM emp WHERE deptno = 10;
 Select /* SQL_TEST */ * FROM emp WHERE deptno = 20;
 
 --바인드 변수로 하였을 때는 실행계획에 1번만 작성됨
Select /* SQL_TEST */ * FROM emp WHERE deptno = :deptno;



SELECT TRANSACTION ISOLATION LEVEL
SERIALIZABLE;

-- ISOLATION LEVEL (고립화레벨)
-- :후행 트랜잭션이 선행트랜잭션에 어떻게 영향을 미치는지를 정의한 단계