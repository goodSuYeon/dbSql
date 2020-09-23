-- 인덱스 생성 방법
-- 1.자동생성
 ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
 --emp컬럼을 선두컬럼으로 하는 인덱스가 없을경우, pk_emp이름으로 UNIQUE인덱스를 자동생성
 UNIQUE : 컬럼의 중복된 값이 없음을 보장하는 제약조건
 PRIMARY KEY = UNIQUE + NOT NULL
 
 --DBMS입장에서는 신규 데이터가 입력 및 기존 데이터가 수정될 때 UNIQUE제약에 문제가 없는지 확인
  --> 무결성을 지키기 위해서.
  
-->우리의 인덱스 명명규칙 : idx_테이블명_u_01 unique
--                      idx_테이블명_n_02 non-unique

--PPT 110
-- INDEX [실습 idx1]
CREATE TABLE dept_test2 AS 
SELECT *
FROM dept
WHERE 1 = 1;

CREATE UNIQUE INDEX idx_dept_test2_u_01
ON dept_test2 (deptno);

CREATE INDEX inx_dept_test2_n_02
ON dept_test2 (dname);

CREATE INDEX idx_dept_test2_n_03  
ON dept_test2 (deptno,dname);

--PPT 111
-- INDEX [실습 idx2]
DROP INDEX idx_dept_test2_u_01;
DROP INDEX inx_dept_test2_n_02; 
DROP INDEX idx_dept_test2_n_03;

--PPT 112
-- INDEX [팀 실습 idx3]
SELECT *
FROM emp
WHERE empno = :empno;

1. emp테이블의 empno컬럼을 기준으로 UNIQUE인덱스를 생성 (중복X)
   CREATE UNIQUE INDEX idx_emp_u_001 ON emp(empno);
2. emp테이블의 ename컬럼을 기준으로 NON-UNIQUE인덱스를 생성 (중복O)
   CREATE INDEX idx_emp_n_001 ON emp(ename);
3. 
4. emp테이블의 empno, sal컬럼을 기준으로 NON-UNIQUE인덱스를 생성
   CREATE INDEX idx_emp_n_002 ON emp(deptno, sal);

--PPT 112
-- INDEX [쌤이랑 실습 idx3]
1) empno(=)                                                        -(1)
2) ename(=)                                                        -(2) 
3) deptno(=) , empno(LIKE : empno || ' %')                         -(1)
4) deptno(=) , sal(BETWEEN)                                        -(3)
5) deptno(=) , mgr컬럼이 있을 경우 테이블 access 불필요                  -(3)
   empno(=)                                                        -(1)
6) deptno, hiredate 컬럼으로 구성된 인덱스가 있을 경우 테이블 access 불필요 -(3)

(1) CREATE UNIQUE INDEX idx_emp_u_001 ON emp(empno,deptno);
(2) CREATE INDEX idx_emp_n_001 ON emp(ename);
(3) CREATE INDEX idx_emp_n_003 ON emp (deptno, sal, mgr, hiredate);

--PPT 113 과제
-- INDEX [실습 idx4]
-- 테이블  
(1) emp , empno(=)
(2) emp , deptno(=) , sal(BETWEEN)
(3) deptno(=) , 


--synonym : 동의어
 -- CREATE [PUBLIC] SYNONYM  동의어_이름 FOR  오라클객체; 
 -- 오라클 객체에 별칭을 생성한 객체
 -- 오라클 객체에 짧은 이름으로 지어줄 수 있다

--emp 테이블에 'e' 라는 이름으로 synonym을 생성한다
CREATE SYNONYM e FOR emp;
SELECT * FROM e;

--dictionary의 종류는 dictionary view를 통해 조회 가능
SELECT * FROM DICTIONARY;
 --dictionary는 크게 4가지로 구분 가능하다
/* 
USER_ : 해당 사용자가 소유한 객체만 조회하기
ALL_ : 해당 사용자가 소유한 객체 + 다른 사용자로부터 권한을 부여받은 객체 조회하기
DBA_ : 시스템 관리자마 볼 수 있으며, 모든 사용자의 객체를 조회하기
V$ : 시스템 성능과 관련된 특수 VIEW
*/
SELECT * FROM dba_tables;

DROP TABLE emp_test;
DROP TABLE emp_test2;

-- multiple insert 
 -- 우선 테이블 2개 생성함.
CREATE TABLE emp_test AS 
SELECT empno, ename
FROM emp 
WHERE 1=2;

CREATE TABLE emp_test2 AS 
SELECT empno, ename
FROM emp 
WHERE 1=2;

 -- 두 테이블에 두건의 행을 삽입함.
INSERT ALL INTO emp_test
           INTO emp_test2
SELECT 9999, 'brown' FROM dual 
UNION ALL
SELECT 9998, 'sally' FROM dual;

 -- 두 테이블에 두건의 행이 삽입 되었음.
SELECT *
FROM emp_test;
SELECT *
FROM emp_test2;

--uncondition insert 실행시 테이블마다 데이터를 입력할 컬럼을 조작하는 것이 가능하다
 -- 위에서 INSERT INTO emp_test VALUES(...)  -> 테이블의 모든 컬럼에 대해 입력 가능
 --       INSERT INTO emp_test(empno) VALUES (9999) -> 특정 컬럼을 지정하여 입력 가능

-- Unconditional insert 예시
 -- 동일한 값을 "여러 테이블" 에 입력하기 (일부 컬럼만 입력 가능)
INSERT ALL
    INTO emp_test(empno) VALUES(eno)
    INTO emp_test2(empno, ename) VALUES(eno , enm)
SELECT 9999 AS eno, 'brown' AS enm FROM dual 
UNION ALL
SELECT 9998, 'sally' FROM dual;

-- conditional insert 예시
 -- 동일한 값을 "조건에 따라" 테이블에 입력하기
 -- 우리가 배웠던 CASE WHEN THEN 조건 처럼.
INSERT ALL
     WHEN eno >= 9500 THEN 
       INTO emp_test VALUES (eno, enm)
       INTO emp_test2 VALUES (eno, enm) 
     WHEN eno >= 9900 THEN
       INTO emp_test2 VALUES (eno, enm)
SELECT 9500 AS eno, 'brown' AS enm FROM dual 
UNION ALL
SELECT 9998, 'sally' FROM dual;

SELECT * FROM emp_test2;