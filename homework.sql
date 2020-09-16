--PPT 226
[실습 join6]
SELECT cu.cid, cu.cnm, cy.pid, p.pnm, SUM(cy.cnt)cnt
FROM customer cu, cycle cy, product p
WHERE cu.cid = cy.cid AND p.pid = cy.pid
GROUP BY cu.cid, cu.cnm, cy.pid, p.pnm
ORDER BY pid;

--PPT 227
[실습 join7]
SELECT p.pid, p.pnm, SUM(c.cnt)cnt
FROM cycle c, product p
WHERE c.pid = p.pid
GROUP BY p.pid, p.pnm
ORDER BY pid;

 ---hr 계정생성 사용---        
  alter user hr identified by java;
  alter user hr account unlock;

--PPT 229
[실습 join8]
SELECT r.region_id, r.region_name, c.country_name 
FROM countries c, regions r
WHERE c.region_id = r.region_id AND region_name = 'Europe' ;

--PPT 230
[실습 join9]
SELECT  r.region_id, r.region_name, c.country_name, l.city
FROM countries c, regions r, locations l
WHERE r.region_id = c.region_id AND c.country_id = l.country_id 
AND region_name = 'Europe' ;

--PPT 231
[실습 join10]
SELECT  r.region_id, r.region_name, c.country_name, l.city , d.department_name
FROM countries c, regions r, locations l , departments d
WHERE r.region_id = c.region_id AND c.country_id = l.country_id  AND l.location_id = d.location_id
AND region_name = 'Europe' ;

--PPT 232
[실습 join11]
SELECT  r.region_id,  r.region_name,  c.country_name,  l.city ,  d.department_name,  CONCAT(e.first_name, e.last_name) name
FROM countries c, regions r, locations l , departments d,  employees e
WHERE r.region_id = c.region_id AND c.country_id = l.country_id  
     AND l.location_id = d.location_id  AND l.location_id = d.location_id 
     AND d.department_id = e.department_id 
AND region_name = 'Europe' ;

--PPT 233
[실습 join12]
SELECT e.employee_id,  CONCAT(e.first_name, e.last_name) name,  j.job_id, j.job_title
FROM employees e , jobs j
WHERE e.job_id = j.job_id;

--PPT 234
[실습 join13]
SELECT e.employee_id mgr_id, CONCAT(e.first_name, e.last_name) mgr_name, m.employee_id, CONCAT(m.first_name, m.last_name) name, j.job_id, j.job_title
FROM employees e, jobs j, employees m
WHERE m.job_id = j.job_id AND e.employee_id = m.manager_id;

--PPT 252
[실습 outerjoin5]
SELECT p.pid, p.pnm, :cid cid, cu.cnm, NVL(cy.day,0) day, NVL(cy.cnt,0) cnt
FROM cycle cy, product p, customer cu
WHERE cy.pid(+) = p.pid 
AND cy.cid(+) = 1 AND cu.cid = 1;   --고객ID를 강제로 1 지정

