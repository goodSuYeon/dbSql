테이블을 생성하는 문법
CREATE TABLE [오라클사용자].테이블명(
  컬럼명 컬럼의 데이터 타입 , 
  컬럼명2 컬럼의 데이터 타입..... 
)
 
-- 테이블 생성해보기
-- 테이블명 ranger, 컬럼 ranger_no NUMBER , rnager_nm VARCHAR2(50), reg_dt DATE
CREATE TABLE su.ranger(
 ranger_no NUMBER, rger_no VARCHAR2(50), reg_dt DATE 
 );
 
 -- 신규테이블에 데이터 입력하기
 -- ranger_no = 1, ranger_nm = 'brown', reg_dt = 현재날짜, 시간
 
 INSERT INTO ranger VALUES (1,'brown',sysdate);
 
 -- 테이블 삭제하기
 DROP TABLE ranger;
 
 -- 제약조건주기
 --제약조건 생성하는 방법3가지
  --(1) 테이블 생성시 컬럼 레벨로 제약조건 생성 
CREATE TABLE 테이블명 (
    컬럼1이름 컬럼1타입 [컬럼제약조건],
 )
 -- 테이블 dept_test 생성, deptno NUMBER(2), dname VARCHAR2(14), loc VARCHAR2(13) , 제약조건은 deptno컬럼을 p.k로
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY, 
    dname VARCHAR2(14),
    loc VARCHAR2(13)
)

--PRTMARY KEY 제약에 의해 deptno 컬럼에는 NULL 값이 들어갈 수 없다.
INSERT INTO dept_test VALUES (NULL, 'ddit', 'daejeon');       ---오류 발생

-- 90번 부서는 존재하지 않고  NULL값이 아니므로 정상적으로 등록
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');  

-- 90번 부서가 이미 존재하는 상태였기 때문에 PRIMARY KEY제약에 의해 정상적으로 입력 불가능
Unique constraint (SU.SYS_C007083) violated                       -- 이런 오류보고(알기 좀 어려움) 
                                                                  -- 데이터에 SYS_C007083 이렇게 써있는건 들어갈 데이터가 없으니 임의로 써있는거.
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');  

비교 ---

dept 테이블에는 deptno 컬럼에 PRIMARY KEY 제약이 없는 상태 
그렇기 때문에 deptno컬럼의 값이 중복이 가능함
INSERT INTO dept VALUES (90, 'ddit', 'daejeon');  
INSERT INTO dept VALUES (90, 'ddit', 'daejeon');  
SELECT *
FROM dept
WHERE deptno = 90;

-- 제약조건 생성시 이름을 부여할 수 있음
-- 장점: ORA-00001: unique constraint (SU.PK_DEPT_TEST) violated    -- 오류보고 개선
DROP TABLE dept_test;

 CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY, 
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');  
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');  

--제약조건을 생성하는 방법 3가지
-- 1방법. 테이블 생성시 테이블 레벨로 제약조건 생성
    --CREATE TABLE 테이블명 (컬럼1 컬럼1의 데이터타입, 
    --                     컬럼2 컬럼2의 데이터타입,
    --                     [TABLE LEVEL 제약조건]);
DROP TABLE dept_test;

 CREATE TABLE dept_test (
    deptno NUMBER(2), 
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno, dname)
);

INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');  
INSERT INTO dept_test VALUES (90, 'ddit2', 'daejeon');    -- deptno가 같아도 dname이 같지 않기 때문에 데이터가 정상적으로 넣어짐.
INSERT INTO dept_test VALUES (80, 'ddit', 'daejeon');     -- dname이 같아도 deptno이 같지 않기 때문에 데이터가 정상적으로 넣어짐.
SELECT * FROM dept_test;

DROP TABLE dept_test;

 CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT PK_dept_test PRIMARY KEY, 
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon'); 
INSERT INTO dept_test VALUES (91, NULL, '대전');          -- ORA-01400 오류보고

--UNIQUE 제약조건
   -- U_테이블명_컬럼명
 DROP TABLE dept_test;  
 CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT U_dept_test_dname UNIQUE (dname)
);

INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');  
INSERT INTO dept_test VALUES (90, NULL, 'daejeon');  
INSERT INTO dept_test VALUES (90, NULL, 'daejeon');  
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');     -- ORA-00001 오류보고

-- dept_test(부모)테이블 emp(자식)테이블 생성,
 DROP TABLE dept_test;  
 CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);
INSERT INTO dept_test VALUES (90, 'ddit', 'daejeon');

2. emp_test (empno, ename, deptno)
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno)
);

참조 무결성 제약조건: emp_test 테이블의 deptno컬럼의 값은 dept_test 테이블의 deptno 컬럼에
                  존재하는 값만 입력이 가능하다.
        
-- 현재는 dept_test 테이블에는 90번 부서만 존재, 
-- 그렇기 때문에 emp_test 에는 90번 이외의 값이 들어갈 수가 없다.
INSERT INTO dept_test VALUES (9000, 'brown', 90);
INSERT INTO emp_test VALUES (9001, 'sally', 10);

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno) 
    REFERENCES dept_test (deptno)
);

INSERT INTO emp_test VALUES (9000, 'brown', 90);  
INSERT INTO emp_test VALUES (9001, 'sally', 10);  

dept_test: 90번 부서가 존재
emp_test : 90번 부서를 참조하는 9000번 brown이 존재

만약 dept_test테이블에서 10번 부서를 삭제하게 된다면??
dept_test : 데이터가 미존재
emp_test : 90번 부서를 참조하는 9000번 brown이 존재


-- 90번 부서에 속한 9000번 사원의 deptno 컬럼의 값이 NULL로 설정되는 결과를 얻음
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno) 
    REFERENCES dept_test (deptno)ON DELETE SET NULL
);
INSERT INTO emp_test VALUES (9000, 'brown', 90);
DELETE dept_test
WHERE deptno = 90;

SELECT * FROM emp_test;



-- 참조 무결성 생성시 
 --3번. OPTION - ON DELETE CASCADE
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2),
    CONSTRAINT FK_emp_test_dept_test FOREIGN KEY(deptno) 
    REFERENCES dept_test (deptno)ON DELETE CASCADE
);
INSERT INTO dept_test VALUES (9000, 'ddit', 'daejeon');
INSERT INTO emp_test VALUES (9000, 'brown', 90);

DELETE dept_test
WHERE deptno = 90;

SELECT * FROM emp_test;

**참고사항**
입력시: 부모(dept) => 자식(emp)
삭제시: 자식(emp) => 부모(dept)

DROP TABLE dept_test;
--체크제약조건 : 컬럼의 값을 확인하여 입력을 허용한다
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(14),
    sal NUMBER(7) CHECK( sal > 0),
    gender VARCHAR2(1) CHECK (gender IN('M' , 'F'))
);

INSERT INTO emp_test VALUES (9000, 'brown', -5, 'M');   --sal체크 0보다 작아서 오류
INSERT INTO emp_test VALUES (9000, 'brown', 100, 'T');  --성별체크 성별이 맞지않아 오류
INSERT INTO emp_test VALUES (9000, 'brown', 100, 'M');  --체크통과 

DROP TABLE dpt_test;
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(14),
    sal NUMBER(7) CONSTRAINT c_sal CHECK ( sal > 0),
    gender VARCHAR2(1) CONSTRAINT c_gender CHECK (gender IN('M' , 'F'))
);

INSERT INTO emp_test VALUES (9000, 'brown', -5, 'M');   --sal체크 0보다 작아서 오류
INSERT INTO emp_test VALUES (9000, 'brown', 100, 'T');  --성별체크 성별이 맞지않아 오류
INSERT INTO emp_test VALUES (9000, 'brown', 100, 'M');  --체크통과 



DROP TABLE dpt_test;
DROP TABLE emp_test;
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(14),
    sal NUMBER(7),
    gender VARCHAR2(1),
    CONSTRAINT c_sal CHECK (sal > 0),
    CONSTRAINT c_gender CHECK (gender IN('M' , 'F'))
);d

INSERT INTO emp_test VALUES (9000, 'brown', -5, 'M');   --sal체크 0보다 작아서 오류
INSERT INTO emp_test VALUES (9000, 'brown', 100, 'T');  --성별체크 성별이 맞지않아 오류
INSERT INTO emp_test VALUES (9000, 'brown', 100, 'M');  --체크통과 


COMMIT , ROLLBACK;

--SELECT 결과를 이용하여 테이블 생성하기
CREATE TABLE AS ==> CTAS 씨타스!
 1. NOT NULL을 제외한 나머지 제약조건을 복사하진 않는다.
 2. 용도 -> 개발시 테스트 데이터를 만들어 놓고 실험을 해보고 싶을 때 사용함
           , 또한 개발자 수준의 데이터 백업
CREATE TABLE 테이블명 [(컬럼, 컬럼2)] AS 
SELECT 쿼리;

DROP TABLE dept_test;
DROP TABLE emp_test;

CREATE TABLE dept_test AS 
SELECT *
FROM dept;

SELECT * 
FROM dept_test;

DROP TABLE dept_test;
DROP TABLE emp_test;

CREATE TABLE dept_test(dno, dnm, location) AS 
SELECT *
FROM dept;

SELECT * 
FROM dept_test;

-- 데이터 없이 테이블 구조만 복사하고 싶을 때
DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 != 1;
 
SELECT *
FROM dept_test;

DROP TABLE emp_test;
DROP TABLE dept_test;

--테이블 변경 할 때
  -- ALTER TABLE 테이블명 .....
--1. 컬럼추가
CREATE TABLE emp_test (
    empno NUMBER(4),
    ename VARCHAR2(14)
);

DESC emp_test;

--emp_test 테이블에 hp컬럼을 VARCHAR(15)로 추가
ALTER TABLE emp_test ADD ( hp VARCHAR(15));
DESC emp_test;
--2. 컬럼변경 (사이즈, 타입변경)
-- hp컬럼의 문자열 사이즈를 30으로 변경
ALTER TABLE emp_test MODIFY ( hp VARCHAR(15));
DESC emp_test;    -- **데이터 타입을 바꾸는 것은 데이터가 없을 때는 상관없지만
                  -- 데이터가 있을 경우는 사이즈를 늘리것을 제외하고는 불가능하다**
                  
--2. 컬럼명 변경 (데이터가 있던,없던 컬럼명 변경은 자유로움)
ALTER TABLE emp_test RENAME COLUMN hp TO phone;

DESC emp_test;

--3. 테이블이 이미 생성된 시점에서 제약조건을 추가
  -- ALTER TABLE 테이블명 CONSTRAINT 제약조건명 제약조건타입
  -- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
  
CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14)
);  
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR(10),
    deptno NUMBER(2)
);

-- ALTER 실습
-- 1조건) dept_test 테이블의 deptno컬럼에 PRIMARY KEY 제약조건 추가하기
ALTER TABLE dept_test ADD CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno);

-- 2조건) emp_test 테이블의 empno컬럼에 PRIMARY KEY 제약조건 추가하기
ALTER TABLE emp_test ADD CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno);

-- 3조건) emp_test테이블의 deptno컬럼이 dept_test컬럼의 deptno컬럼을 참조하는
         FOREIGN KEY 제약조건을 추가하기
ALTER TABLE emp_test ADD CONSTRAINT FK_emp_test_dept_test 
FOREIGN KEY (deptno) REFERENCES dept_test (deptno);