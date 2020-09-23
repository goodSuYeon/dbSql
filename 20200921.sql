SELECT *
FROM user_tables;

--ORACLE사전 (즉, 딕셔너리 user_constraints) 제약조건 확인
SELECT *
FROM user_constraints
WHERE table_name IN('EMP_TEST', 'DEPT_TEST');
-------------------------------------------------------------------------
--우리가 정의할 명명 규칙
PRIMARY KEY : PK_테이블명
FOREIGN KEY : FK_ 소스테이블명_참조테이블명

--제약조건 생성
1. 부서테이블에 PRIMARY KEY 제약조건 추가
2. 사원테이블에 PRIMARY KEY 제약조건 추가
3. 사원테이블-부서테이블간 FOREIGN KEY 제약조건 추가

--제약조건 삭제
--제약조건 삭제시, 데이터입력과 반대로 자식부터 먼저 삭제해야한다.
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
--아래를 예시로 3->(1 또는 2) 삭제 순으로.

--제약조건 삭제
3. ALTER TABLE emp_test DROP CONSTRAINT FK_emp_tesT_dept_test;
1. ALTER TABLE dept_test DROP CONSTRAINT pk_dept_test;
2. ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

--ALTER 제약조건 생성
1. ALTER TABLE dept_test ADD CONSTRAINT PK_dept_test PRIMARY KEY(deptno);
2. ALTER TABLE emp_test ADD CONSTRAINT PK_emp_test PRIMARY KEY(empno);
3. ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test 
   FOREIGN KEY(deptno) REFERENCES dept_test(deptno);


-- 제약조건 활성화-비활성화 테스트
--테스트 데이터 준비: 부모-자식관계가 있는 테이블에서는 부모 테이블에 데이터를 먼저 입력해야함.
**참고사항**
입력시: 부모(dept) => 자식(emp)
삭제시: 자식(emp) => 부모(dept)
dept_test => emp_test
INSERT INTO dept_test VALUES(10,'ddit');
INSERT INTO emp_test VALUES(9999, 'brown', 10);


INSERT INTO emp_test VALUES(9997, 'sally', 20); 
--위의 경우, 20번 부서 dept_test 테이블에 존재하지 않는 데이터이기 때문에 FK에 의해서 입력이 불가함.
--오류 보고 - ORA-02291: integrity constraint (SU.FK_EMP_TEST_DEPT_TEST) violated - parent key not found

--그래서 FK를 비활성화 한 후 다시 입력하자.                    
ALTER TABLE emp_test DISABLE CONSTRAINT FK_emp_test_dept_tesㄱt;
--그러고 다시 데이터를 넣으면 완료.
INSERT INTO emp_test VALUES(9997, 'sally', 20);     
COMMIT;

dept_test : 10
emp_test : 9999 brown 10, 9998 sally 20 

-- FK 제약조건 재 활성화하기
-- 오류 보고 - ORA-02298: cannot validate (SU.FK_EMP_TEST_DEPT_TEST) - parent keys not found
ALTER TABLE emp_test ENABLE CONSTRAINT FK_emp_test_dept_test;

SELECT *
FROM user_constraints
WHERE table_name IN('EMP_TEST', 'DEPT_TEST');

--테이블주석 정보 확인하는 방법
 --user_table , user_constrints , user_tab_comments 
 SELECT * FROM user_tab_comments;
 
-- 테이블주석 작성하는 방법
COMMENT ON TABLE 테이블명 IS '문장주석';
COMMENT ON TABLE emp IS '사원';

--컬럼주석 확인하기
SELECT *
FROM user_col_comments;
--컬럼주석 확인하기 예시)
SELECT *
FROM user_col_comments
WHERE TABLE_NAME = 'DEPT';

--컬럼주석 작성하는 방법
COMMENT ON COLUMN 테이블명.컬럼명 IS '문장주석';
--컬럼주석 달기 예시)
COMMENT ON COLUMN emp.EMPNO IS '사번';
COMMENT ON COLUMN emp.ENAME IS '사원이름';
COMMENT ON COLUMN emp.JOB IS '담당역할';
COMMENT ON COLUMN emp.MGR IS '매니저사번';
COMMENT ON COLUMN emp.HIREDATE IS '입사일자';
COMMENT ON COLUMN emp.SAL IS '급여';
COMMENT ON COLUMN emp.COMM IS '성과급';
COMMENT ON COLUMN emp.DEPTNO IS '소속부서번호';

--PPT2장 57
--[실습 comments 1]
SELECT user_tab_comments.*, column_name , user_col_comments.comments
FROM user_tab_comments , user_col_comments
WHERE user_tab_comments.table_name = user_col_comments.table_name
AND user_tab_comments.table_name IN('CYCLE', 'CUSTOMER', 'PRODUCT', 'DAILY');

--과제
SELECT *
FROM user_constraints
WHERE table_name IN('EMP', 'DEPT');

SELECT *
FROM dept;   -- dept테이블에 deptno컬럼에 같은 데이터가 존재해서 DELETE함.

ALTER TABLE emp ADD CONSTRAINT PK_emp PRIMARY KEY(empno);
ALTER TABLE dept ADD CONSTRAINT PK_dept PRIMARY KEY(deptno); 
ALTER TABLE emp ADD CONSTRAINT FK_emp_emp FOREIGN KEY(mgr) REFERENCES emp(empno);
ALTER TABLE emp ADD CONSTRAINT FK_emp_dept FOREIGN KEY(deptno) REFERENCES dept(deptno);


--VIEW문법
CREATE OR REPLACE VIEW 뷰이름 AS 
SELECT 쿼리;

--emp테이블에서 sal, comm 컬럼 두개를 제외한 나머지 6개 컬럼으로 v_emp 이름으로 VIEW생성
--오류 보고 - ORA-01031: insufficient privileges 
--systemr계정에서 su계정에게 권한을 부여하고 다시 시도.
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

ROLLBACK;
--View란?
-- : 물리적인 데이터를 갖고 싶지 않고, 논리적인 데이터의 정의 집합니다(SELECT)
-- VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과도 바뀐다.

--emp테이블에서 10번 부서에 속하는 3명을 지웠기 때문에 아래 view의 조회 결과도 11명이 나옴(3명지워짐)
--생성한 뷰 확인하기
SELECT *
FROM v_emp;


-- 계정 권한 생성하기
GRANT CONNECT, RESOURCE TO 계정명;

--su 계정에 있는 v_emp 뷰를 hr계정에게 조회할 수 있도록 권한을 부여한다.
GRANT SELECT ON v_emp TO hr; 