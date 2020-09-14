-- 시험 연습  SQL 활용 PART1 179P까지 --

SELECT * FROM lprod;
SELECT buyer_id, buyer_name FROM buyer;
SELECT * FROM cart;
SELECT mem_id, mem_pass, mem_name FROM member;

SELECT prod_id id, prod_name name
FROM prod;

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

SELECT buyer_id 바이어아이디, buyer_name 이름
FROM buyer;

--PPT 67 (문자열결합 CONCAT)
SELECT table_name, CONCAT('SELECT * FROM', CONCAT(table_name,' ;')) query
FROM user_tables;

--PPT 82 (문자열 BETWEEN AND)
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD');

--PPT 83 (조건절 >=, > , < , <=)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD')
AND hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');

--PPT 85 (IN 연산자)
SELECT userid  아이디, usernm 이름, alias 별명
FROM users
WHERE userid IN('brown', 'cony', 'sally');

--PPT 87 (LIKE 연산자)
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE('신%');

--PPT 88 (LIKE 연산자)
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE('%이%');

--PPT 90 (NULL이 아닌 데이터 출력)
SELECT *
FROM emp
WHERE comm IS NOT NULL;

--PPT 95 (AND / OR / NOT)
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--PPT 96 (AND / OR / NOT)
SELECT *
FROM emp
WHERE deptno != 10
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--PPT 97 (AND / OR / NOT)
SELECT  *
FROM emp
WHERE deptno NOT IN(10)
AND hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--PPT 98 (AND / OR / NOT)
SELECT  *
FROM emp
WHERE deptno IN(20,30) 
AND  hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--PPT 99 (AND / OR / NOT)
SELECT *
FROM emp
WHERE job = 'SALESMAN' 
OR hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

--PPT 100 (AND / OR / NOT)
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR empno LIKE('78%');

--PPT 101 (AND / OR / NOT)                                                  -----------------주의 !
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR       (empno BETWEEN 7800 AND 7899
 OR       empno BETWEEN 780 AND 789
 OR       empno BETWEEN 78 AND 78);
 
--PPT 105 (AND / OR / NOT)
SELECT *
FROM emp
WHERE job  = 'SALESMAN' 
OR (empno LIKE('78%') AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'));

--PPT 110 (ORDER BY 오름차순/ 내림차순)
SELECT *
FROM dept
ORDER BY deptno ASC;

--PPT 111 (ORDER BY 오름차순/ 내림차순)
SELECT * 
FROM dept
ORDER BY loc DESC;

--PPT 112 (ORDER BY 오름차순/ 내림차순)
SELECT *
FROM emp
WHERE mgr IS NOT NULL 
ORDER BY job ASC, empno DESC;

--PPT 113 (ORDER BY 오름차순/ 내림차순)
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename DESC;

--PPT 120 (ROWNUM - 데이터정렬: tool에서 제공해주는 행의번호를 컬럼으로 갖는다.)
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM  <= 10;
  
--PPT 121 (ROWNUM - 데이터정렬: tool에서 제공해주는 행의번호를 컬럼으로 갖는다.)
                                     -- ( inline view는 ORDER BY 사용 시에 쓰임.)
SELECT * 
FROM (SELECT ROWNUM rn, empno, ename
                       FROM emp)
WHERE rn BETWEEN 11 AND 14;

--PPT 122 (ROWNUM - 데이터정렬: tool에서 제공해주는 행의번호를 컬럼으로 갖는다.)
SELECT *                                                                                          -----------------주의 !
FROM (SELECT ROWNUM rn, rn.*
      FROM   
         (SELECT empno, ename
          FROM emp
          ORDER BY ename)rn)
WHERE rn BETWEEN 11 AND 14;

--PPT 122 (ROWNUM - 데이터정렬: tool에서 제공해주는 행의번호를 컬럼으로 갖는다.)
SELECT *                                                                                          -----------------주의 !
FROM (SELECT ROWNUM rn, empno, ename
              FROM
             (SELECT empno, ename
             FROM emp
             ORDER BY ename ASC)rn)
WHERE rn >10 AND rn <= 20;


[대소문자 함수들]   
LOWER 소문자로  UPPER  대문자로         INITCAP  첫글자만 대문자로 
[숫자 조작 함수들]
ROUND 반올림      MOD 나눗셈의 나머지   TRUNC 내림
        --ROUND(n,m)
          m이 양수: 소수점을 기준으로 우측 m번째 자리까지 보여줌
          m이 음수:                             왼쪽 m번째에서 반올림
    
        --TRUNC(n,m)
          m이 양수: 소수점을 기준으로 우측 m번째 자리까지 보여줌
          m이 음수:                             왼쪽 m번째에서' 절사'가 일어남
          
SELECT  ROUND(10/3,  2)      --- 결과 3.33
FROM dual;

[문자열 조작 함수들]
-- CONCAT 사용법          문자열 결합
SELECT CONCAT('HELLO', CONCAT(' ' , CONCAT(ename,';')))
FROM emp;
-- SUBSTR 사용법           문자열 자르기 및 추출  첫째부터-다섯째까지.
SELECT SUBSTR('HELLO, WORLD' , 1 , 5)
FROM dual;  
-- LENGTH 사용법          문자열 총길이
SELECT LENGTH('HELLO,WORLD')
FROM dual;
SELECT ename, LENGTH(ename)
FROM emp;
-- INSTR                         첫번째로 등장하는 인덱스 
SELECT INSTR('HELLO,WORLD','L'), INSTR('HELLO,WORLD', 'O' , 6) 
FROM dual;
-- LPAD                          앞쪽에 부족한 길이만큼 채울 문자
SELECT LPAD('HELLO,WORLD', 13, '^')
FROM dual;
-- RPAD                          뒤쪽에 부족한 길이만큼 채울 문자
SELECT RPAD('HELLO,WORLD', 13, '^')
FROM dual;
-- REPLACE                   문자열 치환 HELLO -> hello 로 / 공백->없앰.
SELECT REPLACE('HELLO, WORLD','HELLO', 'hello') , REPLACE('HELLO,  WORLD', '  ', '')
FROM dual;
-- TRIM                          문자열 앞뒤로 공백 제거
SELECT TRIM('  HELLO, WORLD         ')
FROM dual;
    
--PPT 141 (SYSDATE)
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
                 TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 lastday_before5,
                 SYSDATE now,                                                                                                  -----------------주의 !
                 SYSDATE - 3  lastday_before3                                                                         -----------------주의 !
FROM dual;

SELECT TO_CHAR(hiredate +1, 'YYYYMMDD')
FROM emp;

--PPT 145 (SYSDATE)
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') dt_dash ,
                TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') dt_dash_with_time,
                TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

--PPT 날짜 조작 함수
SELECT MONTHS_BETWEEN(TO_DATE('20200908','YYYYMMDD'), TO_DATE('20200808','YYYYMMDD')),
       ADD_MONTHS(SYSDATE, 5),
       NEXT_DAY(SYSDATE, 6),
       LAST_DAY(SYSDATE),
       TO_DATE(CONCAT(TO_CHAR(SYSDATE, 'YYYYMM'),'01'),'YYYYMMDD'),         --FIRST DAY로 만듬
       TO_DATE('01','MM')
FROM dual;
--PPT 날짜 조작 함수
SELECT NEXT_DAY(TO_DATE('20190101', 'YYYYMMDD'), '토요일') dt_day
FROM dual;

--PPT 154 (날짜 조작 함수)   
SELECT :yyyymm param , TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD') dt                                         -----------------주의 !
FROM dual;

-- 실행계획 보기
SELECT * FROM TABLE(dbms_xplan.display);

SELECT empno, ename, sal, TO_NUMBER(SYSDATE,'YYYY/MM/DD')
FROM emp;

--PPT 171 (NVL,NVL2,COALESCE)   
SELECT empno, ename, MGR, NVL(MGR, 9999) mgr_n , NVL2(MGR,MGR,9999) mgr_n2, COALESCE(MGR,9999) mgr_n3    -----------------주의 !
FROM emp

--PPT 172 (NVL,NVL2,COALESCE)   
SELECT userid, usernm, reg_dt, NVL(reg_dt, sysdate)
FROM users
WHERE userid IN('cony','sally','james','moon');

--PPT 177 (CASE WHEN~THEN ELSE  END)
SELECT empno, ename,
                CASE
                    WHEN deptno = '10' THEN 'ACCOUNTING'
                    WHEN deptno = '20' THEN 'RESEARCH'
                    WHEN deptno = '30' THEN 'SALES'
                    WHEN deptno = '40' THEN 'OPERATIONS'
                    ELSE 'DDIT'
                END dname
FROM emp;

--PPT 178 (CASE WHEN~THEN ELSE  END)
SELECT empno, ename, hiredate, 
    CASE
      WHEN MOD(TO_CHAR(hiredate,'YY'),2) = MOD(TO_CHAR(SYSDATE, 'YY'),2) THEN '건강검진 비대상자'
      ELSE '건강검진 대상자'
    END contact_to_doctor
FROM emp;

--PPT 179 (CASE WHEN~THEN ELSE  END)
SELECT userid, usernm, reg_dt,
    CASE
      WHEN MOD(TO_CHAR(reg_dt,'yy'),2) = MOD(TO_CHAR(sysdate,'yy'),2) THEN '건강검진 대상자'
      WHEN reg_dt IS NULL THEN '건강검진 대상자'
      ELSE '건강검진 비대상자'
    END contacttodoctor
FROM users;

SELECT userid, usernm, reg_dt,
    CASE 
      WHEN MOD(TO_CHAR(sysdate,'yy'),2) = MOD(TO_CHAR(reg_dt, 'yy'),2) THEN '건강검진 대상자'  
      ELSE '건강검진 비대상자' 
    END contacttodoctor,
    DECODE(MOD(TO_CHAR(reg_dt, 'yy'),2),
        MOD(TO_CHAR(sysdate,'yy'), 2), '건강검진 대상자',
            '건강검진 비대상자') contacttodoctor2
FROM users;