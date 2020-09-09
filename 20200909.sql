날짜 관련된 함수
TO_CHAR 날짜 ㅡ> 문자
TO_DATE 문자 ㅡ> 날짜

날짜 ㅡ> 문자 ㅡ> 날짜
문자 ㅡ> 날짜 ㅡ> 문자

SYSDATE(날짜)를 이용하여 현재 월의 1일자 날짜로 변경하기
NULL관련함수
1.  NVL(expr1, expr2)
     if(expr1 == null)
        System.out.println(expr2);
     else
        System.out.println(expr1);
        
2.NVL2(expr1, expr2, expr3)
  if(expr1 != null)    expr1이 null이 아니면 expr2 출력 , 
       System.out.println(expr2);
   else                expr1이 null이면 expr3 출력
       System.out.println(expr3);

3. NULLIF(expr1, expr2)
    if(expr1 == expr2)
        System.out.println(NULL);
    else
       System.out.println(expr1);
  
4.coalesce(expr1, expr2, expr3 ...)
    if(expr1 != null)
       System.out.println(expr1);
   else
       coalesce(expr3);

coalesce(null,null,5,4)
   => coalesce(null, 5, 4)
     => coalesce(5,4)
        => System.out.println(5);
        
함수의 인자 개수가 정해지지 않고 유동적으로 변경이 가능한 인자
comm컬럼이 NULL일 때 0으로 변경하여 sal컬럼과 합계를 구한다
SELECT empno, ename, sal, comm,
       sal + NVL(comm, 0) nvl_sum,
       sal + NVL2(comm, comm, 0) nvl2_sum,
       NVL2(comm, sal+comm, sal) nv12_sum2,
       NULLIF(sal, sal) nullif,
       NULLIF(sal, 5000) nullif_fal,
       sal + COALESCE(comm,0)coalesce_sum,
       COALESCE(sal + comm, sal) coalesce_sum2
       FROM emp;                                
       
SELECT empno, ename, 
       NVL(mgr,9999)mgr_n,
       NVL2(mgr,mgr,9999)mgr_n_1,
       COALESCE(mgr, 9999)mgr_n_2
FROM emp;

SELECT  userid, usernm,reg_dt,
        NVL(reg_dt, sysdate) n_reg_dt
FROM users
WHERE userid IN('cony','sally','james','moon'); -- 긍정형

<조건절>

CASE
  WHEN 조건 THEN 반환할 문장
  WHEN 조건2 THEN 반환할 문장
AND

emp테이블에서 job컬럼의 값이 
     'SALESMAN'이면 sal값에 5%를 인상한 급여 반환   sal * 1.05
     'MANAGER'이면 sal값에 10%를 인상한 급여 반환   sal * 1.10
     'PRESIDENT'이면 sal값에 20%를 인상한 급여 반환   al * 1.20
      그 밖의 직군('CLERK','ANALYST')은 sal 값 그대로 반환
    
SELECT ename, job, sal,       --CASE절을 이용 새롭게 계산한 sal_b
      CASE 
           WHEN job = 'SALESMAN' THEN sal * 1.05
           WHEN job = 'MANAGER' THEN sal * 1.10
           WHEN job = 'PRESIDENT' THEN sal * 1.20
           ELSE sal
      END sal_b 
FROM emp;

가변인자: 
DECODE(col|expr1,
               search1, return1,
               search2, return2,
               search3, return3,
               [default])
첫번째 컬럼(col|expr1)이 두번째 컬럼(search2)과 같으면 세번째 컬럼(return1)을 리턴
첫번째 컬럼이 네번째 컬럼(search2)과 같으면 다섯번째 컬럼(return2)을 리턴
첫번째 컬럼이 여섯번째 컬럼(search2)과 같으면 일곱번째 컬럼(return1)을 리턴
일치하는 값이 없을 때는 default 리턴

SELECT ename, job, sal,       --CASE절을 이용 새롭게 계산한 sal_b
      CASE 
           WHEN job = 'SALESMAN' THEN sal * 1.05
           WHEN job = 'MANAGER' THEN sal * 1.10
           WHEN job = 'PRESIDENT' THEN sal * 1.20
           ELSE sal
      END sal_b,
      DECODE(job, 'SALESMAN', sal * 1.05,    -- 위에 식을 decode함수로 적용한 것
                  'MANAGER', sal * 1.10,
                  'PRESIDENT', sal * 1.20,
                  sal) sal_decode
FROM emp;

SELECT empno, ename, 
    CASE 
        WHEN deptno = '10' THEN 'ACCOUNTING'
        WHEN deptno = '20' THEN 'RESEARCH'
        WHEN deptno = '30' THEN 'SALES'
        WHEN deptno = '40' THEN 'OPERATIONS'
        ELSE 'DDIT'
    END dname,
    DECODE(deptno, '10' , 'ACCOUNTING', '20' , 'RESEARCH', '30' , 'SALES', '40', 'PRESIDENT', 'DDIT') dname_dcode
FROM emp;

PPT 178
 조건문 ,sysdate사용, TO_CHAR문자를 날짜로 , MOD나머지 구하기
SELECT empno, ename, hiredate,
     CASE
       WHEN MOD(TO_CHAR(hiredate, 'yy'),2) = MOD(TO_CHAR(sysdate, 'yy'),2) THEN '건강검진 대상자'  -- 나머지가 같은지 비교 (짝,홀)
       ELSE '건강검진 비대상자'
     END contact_to_doctom
FROM emp;

SELECT userid, usernm, reg_dt,
    CASE 
      WHEN MOD(TO_CHAR(sysdate,'yy'),2) = MOD(TO_CHAR(reg_dt, 'yy'),2) THEN '건강검진 대상자'  
      ELSE '건강검진 비대상자' 
    END contacttodoctor,
    DECODE(MOD(TO_CHAR(reg_dt, 'yy'),2),
        MOD(TO_CHAR(sysdate,'yy'), 2), '건강검진 대상자',
            '건강검진 비대상자') contacttodoctor2
FROM users;