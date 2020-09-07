SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM = 1;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <= 5;

PPT 120
SELECT ROWNUM RN, empno, ename
FROM emp
WHERE ROWNUM <= 10;

PPT 121         ************************************************
SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn BETWEEN 11 AND 14;

SELECT *     ************************************************
FROM (SELECT ROWNUM rn, rn.*
      FROM   
         (SELECT empno, ename
          FROM emp
          ORDER BY ename)rn)
WHERE rn BETWEEN 11 AND 14;

SELECT *
FROM
    (SELECT ROWNUM rn, empno, ename
     FROM
        (SELECT empno, ename
         FROM emp
         ORDER BY ename ASC))
WHERE rn >10 AND rn <= 20;

 dual 테이블
SELECT *
FROM dual;

 LENGT사용
SELECT empno, ename, LENGTH(ename),LENGTH(
FROM emp;

LOWER사용
 1방법.()
SELECT ename, LOWER(ename)
FROM emp
WHERE LOWER(ename)= 'smith';

 2방법.(별로 좋지 않음 왜? 컬럼을 가공하지마라! )
SELECT ename, LOWER(ename)
FROM emp
WHERE ename = UPPER('smith');


3방법. (제일 간편하고 좋은 방법)
SELECT ename, LOWER(ename)
FROM emp
WHERE ename = 'SMITH';

믄자열 관련함수
SELECT CONCAT('HELLO', ', WORLD') concat,
       SUBSTR('HELLO, WORLD', 1, 5) substr,
       SUBSTR('HELLO, WORLD',5) substr2,
       LENGTH('HELLO, WORLD') length,
       INSTR('HELLO, WORLD', 'O') instr,
       INSTR('HELLO, WORLD', 'O',  5 + 1 ) instr2, 
       INSTR('HELLO, WORLD', 'O',   INSTR('HELLO, WORLD', 'O') + 1 ) instr3, 
       LPAD('HELLO, WORLD', 15, '*' ) lpad,
       LPAD('HELLO, WORLD', 15) lpad2,
       RPAD('HELLO, WORLD', 15, '*') rpad,
       REPLACE('HELLO, WORLD', 'HELLO', 'HELL') replace,
       TRIM('  HELLO, WORLD   ') trim, 
       TRIM('H' FROM 'HELLO, WORLD') trim2
FROM dual;

숫자함수
 --(ROUND, TRUNC, MOD함수)
 
SELECT ROUND(105.54 , 1) round, -- 소수점 둘째자리에서 반올림
       ROUND(105.55, 1) round2, -- 소수점 둘째자리에서 반올림
       ROUND(105.55, 0) round3, -- 소수점 첫째자리에서 반올림
       ROUND(105.55, -1) round4 -- 정수 첫째자리에서 반올림
FROM dual;

SELECT TRUNC(105.54 , 1) trunc, -- 소수점 둘째자리에서 절삭
       TRUNC(105.55, 1) trunc2, -- 소수점 둘째자리에서 절삭
       TRUNC(105.55, 0) trunc3, -- 소수점 첫째자리에서 절삭
       TRUNC(105.55, -1) trunc4 -- 정수 첫째자리에서 절삭
FROM dual;

MOD --나머지를 구하는 함수
    --피제수 - 나눔을 당하는 수 , 제수 - 나누는 수 
    --a/b = c (a: 피제수, b: 제수)
    
SELECT MOD(10,3) --10을 3으로 나누었을 때 의 나머지
FROM dual;

몫 구하기
SELECT ROUND(10/3,  0)   -- 또는 TRUNC(10/3, 0);
FROM dual;
   
날짜 관련함수 (문자열 ㅡ> 날짜타입 TO_DATE), 
            (SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수함수, 함수의 인자가 없다)

SELECT SYSDATE
FROM dual;

날짜타입 +- 정수(일자) : 날짜에서 정수만큼 더한(뺀) 날짜
emp hiredate +5, -5

SELECT SYSDATE + 1/24 , SYSDATE + 1/24/60
FROM dual;

SELECT TO_DATE('20191231','YYYYMMDD') lastday,
       TO_DATE('20191231','YYYYMMDD')-5 LASTDAY_BEFORES,
       SYSDATE NOW,
       SYSDATE - 3 NOW_BEFORE3
FROM dual;
