-- ���� ����  SQL Ȱ�� PART1 179P���� --

SELECT * FROM lprod;
SELECT buyer_id, buyer_name FROM buyer;
SELECT * FROM cart;
SELECT mem_id, mem_pass, mem_name FROM member;

SELECT prod_id id, prod_name name
FROM prod;

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

SELECT buyer_id ���̾���̵�, buyer_name �̸�
FROM buyer;

--PPT 67 (���ڿ����� CONCAT)
SELECT table_name, CONCAT('SELECT * FROM', CONCAT(table_name,' ;')) query
FROM user_tables;

--PPT 82 (���ڿ� BETWEEN AND)
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD');

--PPT 83 (������ >=, > , < , <=)
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD')
AND hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');

--PPT 85 (IN ������)
SELECT userid  ���̵�, usernm �̸�, alias ����
FROM users
WHERE userid IN('brown', 'cony', 'sally');

--PPT 87 (LIKE ������)
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE('��%');

--PPT 88 (LIKE ������)
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE('%��%');

--PPT 90 (NULL�� �ƴ� ������ ���)
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

--PPT 101 (AND / OR / NOT)                                                  -----------------���� !
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

--PPT 110 (ORDER BY ��������/ ��������)
SELECT *
FROM dept
ORDER BY deptno ASC;

--PPT 111 (ORDER BY ��������/ ��������)
SELECT * 
FROM dept
ORDER BY loc DESC;

--PPT 112 (ORDER BY ��������/ ��������)
SELECT *
FROM emp
WHERE mgr IS NOT NULL 
ORDER BY job ASC, empno DESC;

--PPT 113 (ORDER BY ��������/ ��������)
SELECT *
FROM emp
WHERE deptno IN(10,30) AND sal > 1500
ORDER BY ename DESC;

--PPT 120 (ROWNUM - ����������: tool���� �������ִ� ���ǹ�ȣ�� �÷����� ���´�.)
SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM  <= 10;
  
--PPT 121 (ROWNUM - ����������: tool���� �������ִ� ���ǹ�ȣ�� �÷����� ���´�.)
                                     -- ( inline view�� ORDER BY ��� �ÿ� ����.)
SELECT * 
FROM (SELECT ROWNUM rn, empno, ename
                       FROM emp)
WHERE rn BETWEEN 11 AND 14;

--PPT 122 (ROWNUM - ����������: tool���� �������ִ� ���ǹ�ȣ�� �÷����� ���´�.)
SELECT *                                                                                          -----------------���� !
FROM (SELECT ROWNUM rn, rn.*
      FROM   
         (SELECT empno, ename
          FROM emp
          ORDER BY ename)rn)
WHERE rn BETWEEN 11 AND 14;

--PPT 122 (ROWNUM - ����������: tool���� �������ִ� ���ǹ�ȣ�� �÷����� ���´�.)
SELECT *                                                                                          -----------------���� !
FROM (SELECT ROWNUM rn, empno, ename
              FROM
             (SELECT empno, ename
             FROM emp
             ORDER BY ename ASC)rn)
WHERE rn >10 AND rn <= 20;


[��ҹ��� �Լ���]   
LOWER �ҹ��ڷ�  UPPER  �빮�ڷ�         INITCAP  ù���ڸ� �빮�ڷ� 
[���� ���� �Լ���]
ROUND �ݿø�      MOD �������� ������   TRUNC ����
        --ROUND(n,m)
          m�� ���: �Ҽ����� �������� ���� m��° �ڸ����� ������
          m�� ����:                             ���� m��°���� �ݿø�
    
        --TRUNC(n,m)
          m�� ���: �Ҽ����� �������� ���� m��° �ڸ����� ������
          m�� ����:                             ���� m��°����' ����'�� �Ͼ
          
SELECT  ROUND(10/3,  2)      --- ��� 3.33
FROM dual;

[���ڿ� ���� �Լ���]
-- CONCAT ����          ���ڿ� ����
SELECT CONCAT('HELLO', CONCAT(' ' , CONCAT(ename,';')))
FROM emp;
-- SUBSTR ����           ���ڿ� �ڸ��� �� ����  ù°����-�ټ�°����.
SELECT SUBSTR('HELLO, WORLD' , 1 , 5)
FROM dual;  
-- LENGTH ����          ���ڿ� �ѱ���
SELECT LENGTH('HELLO,WORLD')
FROM dual;
SELECT ename, LENGTH(ename)
FROM emp;
-- INSTR                         ù��°�� �����ϴ� �ε��� 
SELECT INSTR('HELLO,WORLD','L'), INSTR('HELLO,WORLD', 'O' , 6) 
FROM dual;
-- LPAD                          ���ʿ� ������ ���̸�ŭ ä�� ����
SELECT LPAD('HELLO,WORLD', 13, '^')
FROM dual;
-- RPAD                          ���ʿ� ������ ���̸�ŭ ä�� ����
SELECT RPAD('HELLO,WORLD', 13, '^')
FROM dual;
-- REPLACE                   ���ڿ� ġȯ HELLO -> hello �� / ����->����.
SELECT REPLACE('HELLO, WORLD','HELLO', 'hello') , REPLACE('HELLO,  WORLD', '  ', '')
FROM dual;
-- TRIM                          ���ڿ� �յڷ� ���� ����
SELECT TRIM('  HELLO, WORLD         ')
FROM dual;
    
--PPT 141 (SYSDATE)
SELECT TO_DATE('2019/12/31', 'YYYY/MM/DD') lastday,
                 TO_DATE('2019/12/31', 'YYYY/MM/DD') - 5 lastday_before5,
                 SYSDATE now,                                                                                                  -----------------���� !
                 SYSDATE - 3  lastday_before3                                                                         -----------------���� !
FROM dual;

SELECT TO_CHAR(hiredate +1, 'YYYYMMDD')
FROM emp;

--PPT 145 (SYSDATE)
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') dt_dash ,
                TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') dt_dash_with_time,
                TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

--PPT ��¥ ���� �Լ�
SELECT MONTHS_BETWEEN(TO_DATE('20200908','YYYYMMDD'), TO_DATE('20200808','YYYYMMDD')),
       ADD_MONTHS(SYSDATE, 5),
       NEXT_DAY(SYSDATE, 6),
       LAST_DAY(SYSDATE),
       TO_DATE(CONCAT(TO_CHAR(SYSDATE, 'YYYYMM'),'01'),'YYYYMMDD'),         --FIRST DAY�� ����
       TO_DATE('01','MM')
FROM dual;
--PPT ��¥ ���� �Լ�
SELECT NEXT_DAY(TO_DATE('20190101', 'YYYYMMDD'), '�����') dt_day
FROM dual;

--PPT 154 (��¥ ���� �Լ�)   
SELECT :yyyymm param , TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD') dt                                         -----------------���� !
FROM dual;

-- �����ȹ ����
SELECT * FROM TABLE(dbms_xplan.display);

SELECT empno, ename, sal, TO_NUMBER(SYSDATE,'YYYY/MM/DD')
FROM emp;

--PPT 171 (NVL,NVL2,COALESCE)   
SELECT empno, ename, MGR, NVL(MGR, 9999) mgr_n , NVL2(MGR,MGR,9999) mgr_n2, COALESCE(MGR,9999) mgr_n3    -----------------���� !
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
      WHEN MOD(TO_CHAR(hiredate,'YY'),2) = MOD(TO_CHAR(SYSDATE, 'YY'),2) THEN '�ǰ����� ������'
      ELSE '�ǰ����� �����'
    END contact_to_doctor
FROM emp;

--PPT 179 (CASE WHEN~THEN ELSE  END)
SELECT userid, usernm, reg_dt,
    CASE
      WHEN MOD(TO_CHAR(reg_dt,'yy'),2) = MOD(TO_CHAR(sysdate,'yy'),2) THEN '�ǰ����� �����'
      WHEN reg_dt IS NULL THEN '�ǰ����� �����'
      ELSE '�ǰ����� ������'
    END contacttodoctor
FROM users;

SELECT userid, usernm, reg_dt,
    CASE 
      WHEN MOD(TO_CHAR(sysdate,'yy'),2) = MOD(TO_CHAR(reg_dt, 'yy'),2) THEN '�ǰ����� �����'  
      ELSE '�ǰ����� ������' 
    END contacttodoctor,
    DECODE(MOD(TO_CHAR(reg_dt, 'yy'),2),
        MOD(TO_CHAR(sysdate,'yy'), 2), '�ǰ����� �����',
            '�ǰ����� ������') contacttodoctor2
FROM users;