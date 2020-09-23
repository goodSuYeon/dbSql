--PPT 113
-- INDEX [실습 idx4]
(1) emp , empno(=)                                   -(1,2) 
(2) emp, deptno(=) , empno(LIKE : empno || ' %')     -(1,2) 
    dept, deptno(=)
(3) dept, deptno(=)                                  -(3,5)
(4) emp , deptno(=) , sal(BETWEEN)                   -(4)
(5) dept, deptno(=) , loc(=)                         -(3,5)
    emp , deptno(=)

(1,2) CREATE UNIQUE INDEX idx_emp_u_001 ON emp(empno,deptno);
(4)   CREATE INDEX idx_emp_n_001 ON emp(deptno, sal);
(3,5) CREATE UNIQUE INDEX idx_dept_u_002 ON dept(deptno, loc);
