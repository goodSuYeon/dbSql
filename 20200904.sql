SELECT *
FROM emp
WHERE 10 BETWEEN 10 AND 50;

NULL 인지 알 수 있는 방법 (IS NULL)
SELECT *
FROM emp
WHERE comm IS NULL;

NULL 이 아닌것을 알 수 있는 방법 (IS NOT NULL)
SELECT *
FROM emp
WHERE comm IS NOT NULL;

emp테이블 deptno컬럼에서 10번에 속하지 않는 것을 출력
SELECT *
FROM emp
WHERE deptno NOT IN(10)

사원중에 자신의 상급자가 존재하지 않는 사원들만 조회(모든 컬럼)
SELECT *
FROM emp
WHERE mgr IS NULL;

mgr가 7698사번을 갖으면서 급여가 1000보다 큰 사원들을 조회
SELECT *
FROM emp 
WHERE mgr = 7698
AND sal > 1000;

emp테이블의 사원중에 mgr가 7698, 7839가 아닌 사원들을 조회
1방법.
SELECT *
FROM emp
WHERE mgr != 7698 
AND mgr != 7839;

2방법.
SELECT *
FROM emp 
WHERE mgr NOT IN(7698 , 7839);

SELECT *
FROM emp
WHERE mgr IN(7698, 7839, NULL);
오라클은 아래처럼 해석이 됨
mgr = 7698 OR mgr = 7839 OR mgr = null 

원하는 답을 얻으려면
WHERE mgr IN(7698, 7839)
OR mgr IS NULL;

SELECT *
FROM emp
WHERE mgr NOT IN(7698, 7839, NULL);
오라클은 아래처럼 해석이 됨
mgr != 7698 AND mgr != 7839 AND mgr != NULL

SELECT *
FROM emp 
WHERE job = 'SALESMAN'
AND hiredate >= TO_DATE('19810601', 'YYYYMMDD');

SELECT *
FROM emp
WHERE deptno != 10 
AND hiredate >= TO_DATE('19810601','YYYYMMDD');

SELECT *
FROM emp 
WHERE deptno NOT IN(10)
AND hiredate >= TO_DATE('19810601','YYYYMMDD');

SELECT *
FROM emp
WHERE deptno IN(20,30)
AND hiredate >= TO_DATE('19810601','YYYYMMDD');

실습11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

실습12
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
OR empno LIKE('78%');

실습13
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
OR empno IN(7,8);

실습14
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
OR (empno LIKE('78%') AND hiredate >= TO_DATE('19810601','YYYYMMDD'));

job컬럼으로 오름차순 정렬, 같은 job를 갖는 행끼리는 empno로 내림차순 정렬한다.
SELECT *
FROM emp
ORDER BY job, empno DESC; 

SELECT empno, eanme
FROM emp
ORDER BY 2; ==>ORDER BY name;

SELECT *
FROM dept
ORDER BY dname ASC;

SELECT *
FROM dept 
ORDER BY loc DESC;

ppt 111쪽
1방법.
SELECT *
FROM emp
WHERE comm IS NOT NULL
AND comm NOT IN(0)
ORDER BY comm DESC, empno DESC;
2방법.
SELECT *
FROM emp
WHERE comm != 0
ORDER BY comm DESC, empno DESC;

ppt 112쪽
SELECT *
FROM emp
WHERE mgr IS NOT NULL 
ORDER BY job ASC , empno DESC;

ppt 113쪽
SELECT *
FROM emp
WHERE deptno IN(10,30)
AND sal > 1500
ORDER BY ename DESC;

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

ORDER BY는 SELECT이후에 실행된다
ORDER BY를 결과에 반영하려면 inline view는 () <-이고임 를 사용

SELECT *
FROM (SELECT ROWNUM rn, a.*
    FROM (SELECT empno, ename
          FROM emp
          ORDER BY sal) a)
WHERE rn BETWEEN 6 AND 10;

바인드 값 적용 가능
SELECT *
FROM (SELECT ROWNUM rn, a.*
    FROM (SELECT empno, ename
          FROM emp
          ORDER BY sal) a)
WHERE rn BETWEEN (:page - 1) * :pageSize + 1 AND :page * :pageSize;

SELECT ROWNUM, emp.*
FROM emp;