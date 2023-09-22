--13.  emp 테이블에서 30번인 부서의 최고, 최저 SAL을 출력하는 쿼리 작성.
SELECT max(sal),min(sal)
FROM emp
WHERE deptno =30;
--13-2. emp 테이블에서 30번인 부서의 최고, 최저 SAL를 받는 사원의 정보 출력하는 쿼리 작성.
SELECT deptno,empno,ename,job,mgr,hiredate,sal
FROM emp a
WHERE deptno =30
AND sal IN( (SELECT max(sal) FROM emp WHERE deptno=30)
          ,(SELECT min(sal) FROM emp WHERE deptno=30));
-----------------------------
WITH temp AS(
SELECT max(sal) maxsal,min(sal) minsal
FROM emp
WHERE deptno =30
)
SELECT empno , ename, hiredate ,sal
FROM temp t , emp e
WHERE e.deptno=30
AND e.sal IN (t.maxsal,t.minsal);

--14. emp 테이블에서 사원수가 가장작은 부서명과 사원수, 가장 많은 부서명과 사원수 출력
select b.deptno
       ,count(ename) cnt       
       ,RANK() OVER(order by count(empno) desc) cnt_rank
from emp a , dept b
WHERE a.deptno(+) = b.deptno
group by b.deptno
having count(empno) = max(empno)
order by 1;
------------------
SELECT *
FROM(
SELECT b.deptno , count(empno) cnt
       ,RANK() OVER(order by count(empno) desc) cnt_rank
FROM emp a,dept b
WHERE a.deptno(+) = b.deptno
group by b.deptno
order by 1
) t
WHERE cnt_rank in (1,(SELECT COUNT(*) FROM dept));
-----------------------(1)
WITH temp AS(
SELECT d.deptno , dname , count(empno) cnt
FROM emp e , dept d
WHERE e.deptno(+) = d.deptno
group by d.deptno, dname
)
SELECT *
FROM temp
WHERE cnt IN ( (SELECT max(cnt) FROM temp)
              ,(SELECT min(cnt) FROM temp));
-------------------------(2)
WITH a AS(
SELECT d.deptno , dname , count(empno) cnt
FROM emp e , dept d
WHERE e.deptno(+) = d.deptno
group by d.deptno, dname
), b AS(
SELECT MIN(cnt) mincnt , max(cnt) maxcnt
FROM a
)
SELECT a.deptno , a.cnt
FROM a,b
WHERE a.cnt in( b.maxcnt,b.mincnt)
order by 1;
------------------------(3) 분석함수 FIRST , LAST
-- 집계함수와 사용되며 주어진 그룹에 대해 내부적 순위를 매겨 결과 산출
--테이블에 있는 행에 대해 특정 그룹별로 집계갑을 산출할 떄 사용하는 함수
WITH a AS(
SELECT d.deptno , dname , count(empno) cnt
FROM emp e , dept d
WHERE e.deptno(+) = d.deptno
group by d.deptno, dname
)
SELECT 
   MIN(deptno) KEEP(DENSE_RANK FIRST ORDER BY cnt ) deptno
  ,MIN(cnt)
  ,MAX(deptno) KEEP(DENSE_RANK LAST ORDER BY cnt  ) deptno
  ,MAX(cnt)
FROM a;
---------------------- 
--ROW_NUMBER()
--RANK()
--DENSE_RANK()
--CUME_DIST() : 주어진 그룹에 대한 상대적인 누적 분포도 값(비율 0< 값 <=1)을 반환  
--부서별 급여에 따른 누적 분포도 값
SELECT deptno,ename,sal
      ,CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_dist      
FROM emp;
-- PERCENT_RANK() : 해당 그룹 내 백분위 순위(0<= 값 <=1) 
--그룹 안에서 해당 로우 값보다 작은 값의 비율
SELECT deptno,ename,sal
      ,PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal ) PERCENT
FROM emp;
-- 비교
SELECT deptno,ename,sal
      ,CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_dist      
      -- 누적결과 값(1,(1+1),4,5,6) / 총 값 (6)
      ,PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal ) PERCENT
      -- 이전값(중복은 하나의컬럼)(1,(중복2),3,4,5) / 총값(5)
FROM emp
WHERE deptno = 30;
-- NTILE(expr 3) : 파티션별로 expr에 명시된 만큼 분할한 결과를 반환  분할수(버킷 bucket)
SELECT deptno,ename,sal
   ,NTILE(4) OVER (ORDER BY sal) NTILE
FROM emp;

SELECT buseo,name,basicpay
   ,NTILE(2) OVER (PARTITION BY buseo ORDER BY basicpay) NTILE
--   ,NTILE(2) OVER (ORDER BY basicpay) NTILE
FROM insa;
--- WIDTH_BUCKET(expr,min_value,max_value,num_buckets)
--NTILE() 와 유사한 함수 차이점 :(컬럼, 최소, 최대값 설정 가능,N)
SELECT deptno,ename,sal
     ,NTILE(4) OVER(ORDER BY sal) ntiles
     ,WIDTH_BUCKET(sal, 0, 5000, 4) widthbucker
FROM emp;
--LAG(expr,offset,default_value) 
-- 주어진 그룹과 순서에 따라 다른 행(앞)에 있는 값을 참조
--LEAD(expr,offset,default_value)
-- 주어진 그룹과 순서에 따라 다른 행(뒤)에 있는 값을 참조
SELECT ename,hiredate,sal
  ,LAG(sal,1,0) OVER (ORDER BY hiredate) lag_sal
  ,LAG(sal,2,-1) OVER (ORDER BY hiredate) lag_sal
  ,LEAD(sal,1,-1) OVER (ORDER BY hiredate) lead_sal
FROM emp
WHERE deptno=30;
----
SELECT '***ADMIN***'
     ,replace('***ADMIN***','*','') replace
     ,replace('***AD**MIN***','*','') replace
     ,TRIM('*' FROM '***AD*MIN***') trim
     ,TRIM(' ' FROM '    ADMIN    ') trim
     
FROM dual;
--- 오라클 자료형
CHAR[(size[BYTE ? CHAR])]
CHAR
CHAR(10)
CHAR(10 byte)
CHAR(10 char)
char varchar number float long date timestamp ;




INSERT INTO test values('a','bb','cc');
insert into test values('b','욜','우리아');


SELECT *
FROM test;
