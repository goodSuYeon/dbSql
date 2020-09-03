users테이블에는 총 5명의 사용자가 등록되어 있는데 그 중 useridrk 'brown'인 행만 조회한다.
SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown';


대문자 'BROWN'으로 검색하게 되면 데이터가 나오지 않음 
SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'BROWN'; 

WHERE절에 기술된 조건을 참(TRUE)으로 만족하는 행들만 조회가 된다
(WHERE 1 = 3; 하면 거짓이기 떄문에 데이터가 나오지 않음)
SELECT userid, usernm, alias, reg_dt
FROM users
WHERE 1 = 1;   

SELECT *
FROM emp
WHERE 30 >= deptno;

날짜비교(1982년 1월1일 이후에 입사한 사람들만 조회(이름, 입사일자))
SELECT ename,hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01', 'yyyy/mm/dd');

조건에 맞는 데이터 검색하기
1방법. 논리연산자(AND 사용)
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000;

2방법.(BETWEEN ~ AND 사용) 가독성을 위해 이방법을 추구.
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

PPT 82쪽
SELECT ename,hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD') AND TO_DATE('19830101', 'YYYYMMDD');

PPT 83쪽
SELECT ename,hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD')
AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');

IN연산자 - 특정값이 포함되어 있는지 여부를 확인 
SELECT *
FROM emp
WHERE deptno IN(10, 20);
또는
SELECT *
FROM emp
WHERE deptno = 10
OR deptno = 20;


SELECT userid AS 아이디 , usernm AS 이름, alias AS 별명
FROM users
WHERE userid IN('brown', 'cony', 'sally');
또는 
SELECT userid 아이디 , usernm 이름, alias 별명
FROM users
WHERE userid = 'brown'
 OR  userid =  'cony'
 OR  userid = 'sally';

SELECT *
FROM emp
WHERE ename LIKE 'S%';

SELECT *
FROM emp
WHERE ename LIKE 'S____'; 

SELECT *
FROM emp
WHERE ename LIKE 'W___';

SELECT mem_id, mem_name 
FROM member
WHERE mem_name LIKE '신%';

SELECT mem_id, mem_name 
FROM member
WHERE mem_name LIKE '%이%';

