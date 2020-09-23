--emp테이블과 dept테이블을 deptno가 같은 조건으로 조인한 결과를 v_emp_dept이름으로 view생성한다
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.*, dept.dname, dept.loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--생성한 뷰 확인하기
SELECT *
FROM v_emp_dept;

--생성한 뷰 삭제하기
DROP VIEW v_emp_dept;

CREATE VIEW v_emp_cnt AS
SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno;

SELECT * FROM v_emp_cnt;

--Simple VIEW 업데이트 예시
UPDATE v_emp SET JOB = 'RANGER'
WHERE empno = 7369;


CREATE SEQUENCE SEQ_emp;

--시퀀스 객체명.nextval : 시퀀스 객체에서 마지막으로 사용한 다음 값을 반환함
--시퀀스 객체명.currval : nextval 함수를 실행하고 나서 사용할 수 있음
--                     nextval 함수를 통해 얻어진 값을 반환
SELECT seq_emp.nextval
FROM dual;

SELECT seq_emp.curtval
FROM dual;

INSERT INTO emp (empno, ename, hiredate) VALUES (seq_emp.nextval , 'brown' , sysdate);

SELECT * FROM emp;


SELECT ROWID, emp.* 
FROM emp;

SELECT ROWID, emp.*
FROM emp
WHERE rowid = 'AAAE5dAAFAAAACMAAL';

SELECT *
FROM user_constraints
WHERE table_name = 'EMP';

시나리오0
테이블만 있는경우(제약조건, INDEX가 없는 경우)
SELECT *
FROM emp
WHERE empno = 7782;
 --> 테이블에는 순서가 없기 때문에 emp테이블의 14건의 테이블을 모두 뒤져보고 
 --  empno값이 7782인 한 건에 대해서만 사용자에게 반환을 한다.

시나리오1
(제약조건, UNIQUE INDEX가 있는 경우 : PK)
 --> emp테이블의 empno컬럼에 PK_EMP 유니크 인덱스가 생성된 경우
  -- 우리는 인덱스를 직접 생성하지 않았고 PRIMARY KEY제약조건에 의해 자동으로 생성됨
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;
SELECT * FROM TABLE(dbms_xplan.display);

시나리오2
 --> emp테이블의 empno컬럼에 PRIMARY KEY 제약조건이 걸려 있는 경우
  -- 테이블을 접근하는 로직이 빠짐. (즉, 인덱스를 읽은거임)
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;
SELECT * FROM TABLE(dbms_xplan.display);

시나리오3
 --> emp테이블의 empno컬럼에 non-unique인덱스가 있는 경우
ALTER TABLE emp DROP CONSTRAINT FK_emp_emp;
ALTER TABLE emp DROP CONSTRAINT PK_emp;

--인덱스 생성
 -->우리의 인덱스 명명규칙 : IDX_테이블명_U
 --                      IDX_테이블명_N_02

CREATE INDEX IDX_emp_N_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT * FROM TABLE(dbms_xplan.display);

시나리오4
 --> emp테이블의 job컬럼으로 non-unique 인덱스를 생성한 경우
CREATE INDEX idx_emp_n_02 ON emp (job);
  --현재 emp테이블에는 인덱스가 2개 존재함
  -- idx_emp_n_01 : empno
  -- idx_emp_n_02 : job
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT * FROM TABLE(dbms_xplan.display);

시나리오5
 --> emp테이블는 현재 인덱스가 2개 존재함
  -- idx_emp_n_01 : empno
  -- idx_emp_n_02 : job
 EXPLAIN PLAN FOR
 SELECT *
 FROM emp
 WHERE job = 'MANAGER'
    AND ename LIKE 'C%';
  
  SELECT * FROM TABLE(dbms_xplan.display);
  
  
시나리오6 
 --> emp테이블는 현재 인덱스가 3개 존재함 _복합인덱스
 CREATE INDEX idx_emp_n_03 ON emp (job, ename);
  -- idx_emp_n_01 : empno
  -- idx_emp_n_02 : job
  -- idx_emp_n_03 : job , ename
EXPLAIN PLAN FOR
SELECT job, ename, ROWID
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT * FROM TABLE(dbms_xplan.display);

시나리오7
 --> emp테이블는 현재 인덱스가 3개 존재함 _복합인덱스
DROP INDEX idx_emp_n_03;   --3번인덱스 삭제하고
 CREATE INDEX idx_emp_n_04 ON emp (ename, job);   --4번인덱스 생성
  -- idx_emp_n_01 : empno
  -- idx_emp_n_02 : job
  -- idx_emp_n_04 : ename, job
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT * FROM TABLE(dbms_xplan.display);

시나리오8
 --> emp테이블의 empno컬럼에 UNIQUE인덱스 생성하기
DROP INDEX idx_emp_n_01;   --우선 1번인덱스 삭제하고
  -- PK_emp : empno         emp테이블에는 현재 인덱스가 3개 존재함
  -- idx_emp_n_02 : job
  -- idx_emp_n_04 : ename, job
COMMIT;

 --> dept테이블의 deptno컬럼에 UNIQUE인덱스 생성하기
 CREATE INDEX idx_emp_n_04 ON emp (ename, job);   --4번인덱스 생성
  -- PK_dept : deptno         dept테이블에는 현재 인덱스가 1개 존재함
EXPLAIN PLAN FOR
SELECT ename , dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

SELECT * FROM user_constraints WHERE table_name IN('EMP' ,'DEPT');

ALTER TABLE emp DROP CONSTRAINT FK_emp_DEPT;
ALTER TABLE DEPT DROP CONSTRAINT PK_DEPT;

ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY(empno);
ALTER TABLE dept ADD CONSTRAINT PK_dept PRIMARY KEY(deptno); 
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY(deptno) REFERENCES dept(deptno);
