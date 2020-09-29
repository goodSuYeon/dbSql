------------------------------------달력만들기 pt------------------------------------------
달력만들기 : 행을 열로 만들기-레포트 쿼리에서 자주 사용하는 형태
주어진 것 : 년월 ( 수업시간에는 '202009' 문자열을 사용 )

SELECT MIN(DECODE(d, 1, day))sun,
       MIN(DECODE(d, 2, day)) mon,MIN(DECODE(d, 3, day)) tue,
       MIN(DECODE(d, 4, day))wed ,MIN(DECODE(d, 5, day)) thu,
       MIN(DECODE(d, 6, day))fri, MIN(DECODE(d, 7, day)) sat 
FROM
    (SELECT TO_DATE(:yyyymm,'yyyymm')+ LEVEL - 1 day,
        TO_CHAR(TO_DATE(:yyyymm,'yyyymm')+ LEVEL - 1 , 'D')d,
        TO_CHAR(TO_DATE(:yyyymm,'yyyymm')+ LEVEL - 1 , 'iw')iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm , 'yyyymm')),'dd'))
GROUP BY DECODE(d,1,iw+1,iw) ORDER BY DECODE(d,1,iw+1,iw);


실습 calendar1 ]
SELECT * FROM sales;

SELECT NVL(MIN(DECODE(a, 1, b)),0) JAN, NVL( MIN(DECODE(a, 2, b)),0)FEB,
       NVL( MIN(DECODE(a, 3, b)),0) MAR, NVL( MIN(DECODE(a, 4, b)),0)APR,
       NVL( MIN(DECODE(a, 5, b)),0) MAY, NVL( MIN(DECODE(a, 6, b)),0)JUN
FROM
    (SELECT TO_CHAR(dt, 'mm')a, SUM(sales)b
    FROM sales 
    GROUP BY TO_CHAR(dt, 'mm'))hh;

----------------------------------------------------------------------------------

SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm AS deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;  


SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm AS deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;  


-- ** PRIOR키워드는 CONNECT BY 바로 다음에 나오지 않아도 된다 **
 --(예시)
  CONNECT BY PRIOR deptcd = p_deptcd;

-- ** 연결 조건이 두개 이상일 때 **
  CONNECT BY PRIOR p = q AND PRIOR a = b;
  
--PPT 76
 --[실습 h_2]
SELECT LEVEL lv , deptcd, LPAD('',(LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY p_deptcd = PRIOR deptcd;
             
-- 계층쿼리 - 상향식
 -- 디자인팀(dept0_00_0)부터 시작하여 자신의 상위부서로 연결하는 쿼리
SELECT LEVEL lv, deptcd, LPAD(' ',(LEVEL-1)*3) || deptnm AS deptnm, p_deptcd 
FROM dept_h
START WITH deptcd = 'dept0_00_0'     --dept0_00_0 에서 시작함
CONNECT BY PRIOR p_deptcd = deptcd;  

--S_ID  :자식노드 (EX.사번)
--PS_ID :부모노드 (EX.매니저사번)
SELECT *
FROM h_sum;

--PPT81
 --[실습 h_4]
SELECT LPAD(' ', (LEVEL-1) *3 ) || s_id AS s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;


--가지치기
SELECT 쿼리 처음 배울때 ,설명해준 SQL 구문 실행순서
FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY
SELECT 쿼리에 START WITH, CONNECT BY 절이 있을 경우
FROM -> START WITH, CONNECT BY -> WHERE...

--하향식 쿼리로 데이터 조회
  /* 현재 읽은행의 deptcd값이 앞으로 읽을 행이 p_deptcd컬럼과 같고,
     앞으로 읽을 행의 dept_cd컬럼값이 'dept0_01'이 아닐 때 연결하겠다. */
SELECT deptcd, LPAD(' ',(LEVEL-1)*3) || deptnm AS deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd     --지금 읽을 부서코드가 상위 부서코드(p_deptcd)랑 같을 때
AND deptcd != 'dept0_01';   

--> 설명: XX회사 밑에는 디자인부,정보기획부, 정보시스템부 3개의 부서가 있는데
--       그 중에서 정보기획부를 제외한 2개의 부서에 대해서만 연결하겠다.

--위에꺼랑 순서만 바꿈 deptcd != 'dept0_01' 이 문장을 WHERE에 씀
--1.계층 탐색을 전부 완료한 후 
--2.WHERE절에 해당하는 행만 데이터를 제외한다.
SELECT deptcd, LPAD(' ',(LEVEL-1)*3) || deptnm AS deptnm
FROM dept_h
WHERE deptcd != 'dept0_01' 
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd; 

--계층쿼리 특수함수 (1)(CONNECT_BY_ROOT(컬럼): 최상위 행의 컬럼 값을 조회함)
--               (2)(SYS_CONNECT_BY_PATH(컬럼,구분자): 계층 순회 경로를 표현함)
SELECT deptcd,LPAD(' ', (LEVEL-1)*3) || deptnm AS deptnm,
       CONNECT_BY_ROOT(deptnm) cbr,
       LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'),'-') scbp,
       CONNECT_BY_ISLEAF cbi
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT LEVEL,dummy, LTRIM(SYS_CONNECT_BY_PATH(dummy,'-'),'-') scbp
FROM dual
CONNECT BY LEVEL <= 10;



-- [실습. 게시글 계층형쿼리]
SELECT * FROM board_test;

--[실습h6]
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY parent_seq = PRIOR seq;

--[실습h]
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title AS title
FROM board_test
START WITH parent_seq IS NULL        
CONNECT BY parent_seq = PRIOR seq
ORDER BY seq DESC;

--[실습h8]
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title AS title, CONNECT_BY_ROOT(Seq)seq
FROM board_test
START WITH parent_seq IS NULL        
CONNECT BY parent_seq = PRIOR seq
ORDER SIBLINGS BY seq DESC;

--[실습h8]
CONNECT_BY_ROOT를 활용해 범위
SELECT *
FROM 
(SELECT seq, LPAD(' ', (LEVEL-1)*3) || title AS title, CONNECT_BY_ROOT(Seq) gn
FROM board_test
START WITH parent_seq IS NULL        
CONNECT BY parent_seq = PRIOR seq)
ORDER BY gn DESC, seq DESC;

ALTER TABLE board_test ADD (gn NUMBER);
UPDATE board_test SET gn = 1 WHERE seq IN(1,9);
update board_test SET gn = 2 WHERE seq IN(2,3);
update board_test SET gn = 4 WHERE seq NOT IN(1,2,3,9);
COMMIT;

SELECT seq, LPAD(' ', (LEVEL-1)*3) || title AS title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC , seq ASC;

--부서별 급여 랭크구하기
SELECT ename , sal , deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

--분석함수를 사용하지 않고도 위와 동일한 결과를 만들어 내는 것이 가능함
-- ** 분석함수가 모든 DBMS에서 제공을 하지는 않기 때문 **
SELECT *
FROM
(SELECT ename, sal, deptno, ROWNUM RN
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC))a,

(SELECT deptno, lv, ROWNUM rn
FROM
(SELECT a.deptno, b.lv
FROM
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) a,

(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp)) b
WHERE a.cnt >= b.lv
ORDER BY a.deptno, b.lv))b
WHERE a.rn = b.rn;

--분석함수 / window 함수 문법
-- SELECT 윈도우함수이름([인자]) OVER 
--  ([PARTITION BY columns] [ORDER BY columns][WINDOWING])

--순위 관련 분석함수
 --(RANK, DENSE_RANK, ROW_NUMBER)
SELECT ename, sal, deptno
      ,RANK() over (PARTITION BY deptno ORDER BY sal DESC) sal_rank
      ,DENSE_RANK() over (PARTITION BY deptno ORDER BY sal DESC) sal_rank
      ,ROW_NUMBER() over (PARTITION BY deptno ORDER BY sal DESC) sal_rank
FROM emp;

SELECT empno, ename, sal, deptno 
       ,RANK() over (ORDER BY sal DESC) sal_rank
       ,DENSE_RANK() over (ORDER BY sal DESC) sal_dense_rank
       ,ROW_NUMBER() over (ORDER BY sal DESC) sal_row_number
FROM emp;

--분석함수 - 집계함수
-- SUM(col), MIN(col), MAX(col), COUNT(col|*), AVG(col)

--사원번호, 사원이름, 소속부서번호, 소속된 부서의 사원수
SELECT empno, ename, deptno, COUNT(*) over (PARTITION BY deptno) cnt
FROM emp;

--실습 ana2
SELECT empno, ename, sal, deptno, ROUND(AVG(sal) over (PARTITION BY deptno),2) avg_sal
FROM emp;

--실습 ana3
SELECT empno, ename, sal, deptno, MAX(sal) over (PARTITION BY deptno) max_sal
FROM emp;

--분석함수를 사용하지 않은 실습ana3
SELECT ROWNUM rn, empno, ename, sal, deptno
FROM
(SELECT empno, ename , sal, deptno, MAX(sal)
FROM emp
ORDER BY deptno, sal DESC))

--실습 ana4
SELECT empno, ename, sal, deptno, MIN(sal) over (PARTITION BY deptno) min_sal
FROM emp;

SELECT TRANSACTION ISOLATION LEVEL
SERIALIZABLE;

ISOLATION LEVEL (고립화레벨)
 : 후행 트랜잭션이 선행트랜잭션에 어떻게 영향을 미치는지를 정의한 단계
