-- SELECT CONCAT('SUYEON', ' GOOD')
-- FROM dual;
-- 
-- SELECT * FROM CART;
-- 
-- SELECT * 
-- FROM CART 
-- WHERE CART_QTY IN(2,3); 

날짜 데이터 : emp.hiredate
            SYSDATE
TO_CHAR(날짜타입, '변경할 문자열 포맷')
TO_DATE('날짜문자열', '첫번째 인자의 날짜 포맷')
현재 설정된 NLS DATE FORMAT : YYYY/MM/DD HH24:MI:SS

SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD-MM-YYYY')
              , TO_CHAR(SYSDATE , 'D') 
              , TO_CHAR(SYSDATE, 'IW')
              , TO_DATE('20200908', 'YYYYMMDD')
FROM dual;

SELECT ename, hiredate, TO_CHAR(hiredate, 'yyyy/mm/dd hh24:mi:ss') h1,
       TO_CHAR(hiredate +1, 'yyyy/mm/dd hh24:mi:ss') h2,
       TO_CHAR(hiredate + 1/24, 'yyyy/mm/dd hh24:mi:ss') h3,
       TO_CHAR(TO_DATE('20200908', 'YYYYMMDD'), 'YYYY/MM/DD') h4  
FROM emp;

SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') dt_dash
       ,TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24-MI-SS') dt_dash_with_time
       ,TO_CHAR(SYSDATE, 'dd-mm-yyyy') dt_dd_mm_yyyy
FROM dual;

날짜 조작 함수
MONTHS_BETWEEN(date1, date2) : 두 날짜 사이의 개월수를 반환

SELECT MONTHS_BETWEEN(TO_DATE('20200908','YYYYMMDD'), TO_DATE('20200808','YYYYMMDD')),
       ADD_MONTHS(SYSDATE, 5),
       NEXT_DAY(SYSDATE, 6),
       LAST_DAY(SYSDATE),
       TO_DATE(CONCAT(TO_CHAR(SYSDATE, 'YYYYMM'),'01'),'YYYYMMDD'),
       TO_DATE('01','MM')
FROM dual;

PPT 154P
SELECT :yyyymm papam, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD') AS dt
FROM dual;

묵시적 형변환 : ORACLE DBMS가 상황에 맞게 알아서 변환해주는 것
SELECT *
FROM emp
WHERE empno = '7369';

***알면 매우 좋음*** 고급개발자/ 일반개발자 를 구분하기 위한 차이점
실행계획: 오라클에서 요청받은 SQL을 처리하기 위한 절차를 수립한 것 
실행계획 보는 방법 (1,2번 순서대로)
1. EXPLAIN PLAN FOR 실행계획을 분석할 SQL;
2. SELECT * FROM TABLE(dbms_xplan.display);

실행계획을 operation을 해석하는 방법 
1) 위에서 아래로
2) 단 자식노드 (들여쓰기가 된 노드) 있을 경우 자식부터 실행하고 본인 노드를 실행
1.
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';
2. 
SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display)

숫자를 문자로 포맷팅하기 
SELECT empno, ename, sal, TO_CHAR(sal, '9,999')
FROM emp;

이건 DB보다는 소프트웨어의 국제화(l18n)
SELECT empno, ename, sal, TO_CHAR(sal, '009,999L')
FROM emp;

NULL특징: NULL이 포함한 연산의 결과는 항상 NULL이다.
그럼 NULL이 있는 컬럼, NULL이 없는 컬럼 어떻게 하나?
NULL과 관련된 함수
1. NVL(컬럼 || 익스프레션, 컬럼 || 익스프레션)
   NVL(expr1, expr2)
   if(expr1 == null)
     System.out.println(expr2);
   else
     System.out.println(expr1);

SELECT empno, comm, NVL(comm, 0)
FROM emp;

SELECT empno, sal, comm, sal+comm
FROM emp;

SELECT empno, sal, comm, sal+comm, sal+ NVL(comm, 0)
FROM emp;

