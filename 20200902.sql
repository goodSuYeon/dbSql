실습 select1
SELECT *
FROM lprod;

SELECT buyer_id, buyer_name
FROM buyer;

SELECT *
FROM cart;

SELECT mem_id, mem_pass, mem_name
FROM member;

연산
SELECT ename, sal, sal+10
FROM emp;

데이터 타입 확인
DESC emp;

hiredate에서 365일 미래/과거의 일자
SELECT ename, hiredate, hiredate+365 after_lyear, hiredate-365 before_layer
FROM emp;

SELECT ename, hiredate, hiredate+365 AS after_lyear, hiredate-365 AS before_layer
FROM emp;

SELECT ename "emp name"
FROM emp;

emp테이블 컬럼명 정리
1. empno : 사원번호 
2. ename : 사원이름
3. job : 담당업무
4. mgr : 매니저 사번번호
5. hiredate : 입사일자
6. sal : 급여
7. comm : 성과금
8. deptno : 부서번호

SELECT *
FROM dept;

emp테이블에서 NULL값을 확인해보기
SELECT ename, sal, comm, sal+comm AS total_sal
FROM emp;

SELECT userid, usernm, reg_dt, reg_dt + 5
FROM users;

SELECT userid, usernm
FROM users
WHERE userid = 'brown';

SELECT *
FROM lprod
WHERE lprod_gu > 'p301';

실습 select2
SELECT prod_id id, prod_name name
FROM prod;

SELECT lprod_gu "gu", lprod_nm AS nm
FROM lprod;

SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;

10이라는 숫자를 그대로 쓰게되면 컬럼명과 데이터값이 다 10
SELECT empno, 10
FROM emp; 

SELECT empno, 'Hello, World'
FROM emp;

SELECT empno e, 'Hello, World' h--, "Hello, World"
FROM emp;

문자열 결합 (결합 시 중간에 공백넣어주기)
1.방법
SELECT ename || ' ' || job 
FROM emp;
2.방법
SELECT CONCAT(ename,job)
FROM emp;
3.방법(결합 세번)
SELECT CONCAT(ename, CONCAT(' ',job))
FROM emp;

문자열 결합 이용 
1방법.  
SELECT CONCAT('SELECT * FROM ', CONCAT(table_name,';'))
FROM user_tables;
2방법.
SELECT 'SELECT * FROM ' || table_name || ';'
FROM user_tables;

접속한 사용자가 소유한 테이블 목록 조회
SELECT table_name
FROM user_tables;

PPT 73쪽
SELECT ename,hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01');