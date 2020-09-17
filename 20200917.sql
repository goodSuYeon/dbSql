--DML (INSSERT, UPDATE, DELETE)

DESC emp;
--INSERT
INSERT INTO emp (empno, ename) VALUES(9999,'brown');
SELECT empno, ename
FROM emp;

--empno컬럼의 설정이 NOT NULL이기 때문에 empno컬럼에 NULL값이 들어갈 수 없어서 에러발생
INSERT INTO emp (ename) VALUES('sally');

INSERT INTO dept VALUES (98,'대덕', '대전');

-- 테이블에 정의된 모든 컬럼에 대해 값을 기술해야함(3개중 2개만 기술해서 에러발생)
INSERT INTO dept VALUES (97,'DDIT');

-- SELECT 결과(여러행일 수도 있다)를 테이블에 입력가능
INSERT INTO emp(empno, ename)
SELECT 9997, 'cony'  FROM dual
UNION ALL
SELECT 9996, 'moon'  FROM dual;

--날짜 컬럼 값 입력하기
INSERT INTO emp VALUES (9996, 'james', 'CLERK', NULL, SYSDATE, 3000, NULL,  NULL);
INSERT INTO emp VALUES (9996, 'james', 'CLERK', NULL, TO_DATE('2020/09/01','YYYY/MM/DD'), 3000, NULL,  NULL);

SELECT * FROM emp;
DESC emp;

--UPDATE
--dept테이블의 deptno컬럼값 99번인 데이터를 DNAME컬럼을 DDIT, LOC컬럼은 영민으로 수정
UPDATE dept SET dname = 'DDIT', loc = '영민' WHERE deptno = 99;
UPDATE dept SET dname = 'DDIT', loc = '영민'    --이렇게 작성 할 경우 다 수정됨 
ROLLBACK;
2. 서브쿼리를 이용한 데이터 변경(**추후 MERGE 구문을 배우면 더 효율적으로 작성할 수 있다.)
--테스트 데이터 입력
INSERT INTO emp(empno, ename, job) VALUES(9000 ,'brown', NULL);
SELECT deptno, job
FROM emp
WHERE ename = 'SMITH';

UPDATE emp SET deptno = (SELECT deptno 
                         FROM emp
                         WHERE ename = 'SMITH')
                 ,job = (SELECT deptno 
                         FROM emp
                         WHERE ename = 'SMITH')
WHERE empno = 9000;

--DELETE
  --DELETE [FROM] 테이블명 [WHERE...]
emp테이블에서 9000번 사번의 데이터(행)을 완전히 삭제
DELETE emp
WHERE empno = 9000;


