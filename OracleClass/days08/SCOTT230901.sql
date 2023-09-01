--14. emp 테이블에서 사원수가 가장작은 부서명과 사원수, 가장 많은 부서명과 사원수 출력
select deptno, count(*)
from emp
group by deptno
order by 1;
------------------
SELECT buseo,b.city,count(*)
FROM insa a PARTITION BY (buseo) RIGHT OUTER JOIN (SELECT distinct(city)FROM insa) b
ON a.city = b.city
group by buseo,b.city
order by 1,2;




-- 문제 emp job 사원수 조회 
SELECT deptno , b.job , count(empno)cnt
FROM emp a PARTITION BY (deptno) RIGHT OUTER JOIN (SELECT job FROM emp) b
ON a.job = b.job
group by deptno,b.job
order by 1,2