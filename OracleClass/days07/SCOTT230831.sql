SELECT *
FROM emp;

SELECT *
FROM salgrade;

SELECT deptno,ename,sal,
    CASE
    WHEN sal BETWEEN 700 AND 1200 THEN 1
    WHEN sal BETWEEN 1201 AND 1400 THEN 2
    WHEN sal BETWEEN 1401 AND 2000 THEN 3
    WHEN sal BETWEEN 2001 AND 3000 THEN 4
    WHEN sal BETWEEN 3001 AND 9999 THEN 5
    END grade
FROM emp;

SELECT deptno,ename,sal,losal||'-'||hisal,grade
FROM emp a, salgrade b
WHERE sal BETWEEN b.losal AND b.hisal;


SELECT b.deptno
      ,nvl(LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename),'사원 없음') name
FROM emp a,dept b
WHERE a.deptno(+) = b.deptno
group by b.deptno
order by 1;

---- Grouping SETS
SELECT deptno , COUNT(*)
FROM emp
group by deptno

SELECT job , COUNT(*)
FROM emp
group by job;

SELECT deptno,job
       ,COUNT(*)
FROM emp
group by GROUPING SETS((deptno,job))
order by 1;

-- emp 급여 가장 많이 받는 사원 정보 조회
SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay
FROM emp
WHERE (sal+nvl(comm,0)) = ALL(SELECT MAX(sal+nvl(comm,0)) FROM emp);
--WHERE (sal+nvl(comm,0)) >= ALL(SELECT (sal+nvl(comm,0)) FROM emp);

-- RANK 순위 함수
-- TOP-N 방식...
--1) ORDER BY 정렬된 인라인뷰
--2) ROWNUM 의사컬럼 - 행마다 순서대로 번호를 부여하는 컬럼
--3) WHERE 조건절 > < >= <=

-- 의사(pseudo) 컬럼
SELECT rowid
       ,deptno,empno,ename,(sal+nvl(comm,0)) pay
       ,rownum
FROM emp;

SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay       
FROM emp
order by pay desc;

SELECT * 
FROM(
SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay       
FROM emp
order by pay desc
) e
WHERE rownum <=3;

-- 순위 함수
-- RANK 
-- DENSE_RANK
-- PERCENT_RNAK
-- FIRST(), LAST()
-- ROW_NUMBER
SELECT *
FROM(
SELECT deptno,ename, (sal+nvl(comm,0)) pay
      ,ROW_NUMBER() OVER(order by (sal+nvl(comm,0)) desc ) 급여순위
FROM emp
) e
WHERE 급여순위 BETWEEN 3 AND 5;
WHERE 급여순위  <= 3;
WHERE 급여순위  = 1;

-- 문제 emp 최고급여 사원 정보 
SELECT b.deptno,b.dname,ename, (sal+nvl(comm,0)) pay,grade
FROM emp a , dept b , salgrade c
WHERE a.deptno = b.deptno
AND (sal+nvl(comm,0)) = (SELECT max(sal+nvl(comm,0)) FROM emp)
AND a.sal BETWEEN c.losal AND c.hisal;
-- 문제 emp 각 부서별 최고급여 사원 정보 
SELECT b.deptno,b.dname,ename, (sal+nvl(comm,0)) pay,grade
 ,ROW_NUMBER() OVER(order by (sal+nvl(comm,0)) desc ) 급여순위
FROM emp a , dept b , salgrade c
WHERE a.deptno = b.deptno
AND (sal+nvl(comm,0)) = (SELECT max(sal+nvl(comm,0)) FROM emp WHERE deptno = a.deptno)
AND a.sal BETWEEN c.losal AND c.hisal;
-------emp 최고급여 사원 정보 
SELECT *
FROM(
SELECT b.deptno,b.dname,ename, (sal+nvl(comm,0)) pay,grade
,ROW_NUMBER() OVER(order by (sal+nvl(comm,0)) desc ) 급여순위
FROM emp a , dept b, salgrade c
WHERE a.deptno = b.deptno
AND a.sal BETWEEN c.losal AND c.hisal
) e
WHERE 급여순위  = 1;
-----------------emp 각 부서별 최고급여 사원 정보 
SELECT *
FROM(
SELECT b.deptno,dname, ename, sal+nvl(comm,0) pay,grade
 ,ROW_NUMBER() OVER (PARTITION BY b.deptno order by (sal+nvl(comm,0)) desc) 급여순위
FROM emp a , dept b, salgrade c
WHERE a.deptno = b.deptno
AND a.sal BETWEEN c.losal AND c.hisal
)
WHERE 급여순위  = 1;
------ 순위함수
-- TOP_N 분석
-- ROW_NUMBEWR() OVER()

-- RANK() DENSE_RANK() 중복순위 계산 O/X

SELECT empno,ename,sal
     ,ROW_NUMBER() OVER (ORDER BY sal desc) rn_rank
     ,rank() OVER (ORDER BY sal desc) r_rank
     ,DENSE_RANK() OVER (ORDER BY sal desc) dr_rank
FROM emp;

SELECT empno,ename,sal
     ,ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal desc) rn_rank
     ,rank() OVER (PARTITION BY deptno ORDER BY sal desc) r_rank
     ,DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal desc) dr_rank
FROM emp;

-- emp 각 사원 급여를 부서 순위, 사원전체 순위 
SELECT deptno,empno,ename,(sal+nvl(comm,0))pay
     ,rank() OVER (PARTITION BY deptno ORDER BY (sal+nvl(comm,0)) desc) r_rank
     ,rank() OVER (ORDER BY (sal+nvl(comm,0)) desc) r_rank
FROM emp;

-- insa 사원수 출력 
남자사원수 :31
여자사원수 :29
전체 :60
-----------------내 풀이
SELECT distinct(decode(mod(substr(ssn,-7,1),2)
       ,1,'남자사원수'
       ,0,'여자사원수'
       )) a
       ,decode(mod(substr(ssn,-7,1),2)
       ,1,(SELECT COUNT(*) FROM insa WHERE mod(substr(ssn,-7,1),2)=1)
       ,0,(SELECT COUNT(*) FROM insa WHERE mod(substr(ssn,-7,1),2)=0)
       ) b
FROM insa
union
SELECT '전체',count(*) cnt
FROM insa;
----------------------(1)
SELECT '남자사원수',count(*) cnt
FROM insa
WHERE mod(substr(ssn,-7,1),2)=1
union
SELECT '여자사원수',count(*) cnt
FROM insa
WHERE mod(substr(ssn,-7,1),2)=0
union
SELECT '전체',count(*) cnt
FROM insa;
----------------------(2)
SELECT decode(mod(substr(ssn,-7,1),2)
      ,1,'남자사원수'
      ,'여자사원수') gender
      ,count(*) cnt
FROM insa
group by mod(substr(ssn,-7,1),2)
union
SELECT '전체',count(*) cnt
FROM insa;
----------------------(3) ROLLUP,CUBE 분석 함수 GROUP BY 사용 
SELECT decode(mod(substr(ssn,-7,1),2)
      ,1,'남자사원수'
      ,0,'여자사원수'
      ,'전체') gender
      ,count(*) cnt
FROM insa
group by CUBE(mod(substr(ssn,-7,1),2));
group by ROLLUP(mod(substr(ssn,-7,1),2));
---
SELECT buseo,jikwi, SUM(basicpay) sum_pay
FROM insa
GROUP BY CUBE(buseo,jikwi)
order by 1;

-- 문제 emp 가장 빨리 입사한 사원과 가장 늦게 입사한 사원의 차이 일수
SELECT max(hiredate) a,min(hiredate) b
      ,max(hiredate)-min(hiredate) c
FROM emp
order by 1;
--ROW_NUMBER
WITH a AS(
SELECT hiredate
FROM(
SELECT hiredate
   ,ROW_NUMBER() OVER (ORDER BY hiredate desc) h_rank
FROM emp
) e
WHERE h_rank = 1
),
b AS(
SELECT hiredate
FROM(
SELECT hiredate
   ,ROW_NUMBER() OVER (ORDER BY hiredate asc) h_rank
FROM emp
) e
WHERE h_rank = 1
)
SELECT a.hiredate-b.hiredate
FROM a , b;
--- 문제 insa 각 사원의 만나이를 계산해서 출력
-- 1) ssn 주민등록번호
WITH a AS(
SELECT name as"이름",ssn as"주민등록번호"
     ,CASE 
     WHEN substr(ssn,-7,1) in(1,2,5,6) THEN to_char(substr(ssn,1,2),'0099')+1900
     WHEN substr(ssn,-7,1) in(3,4,7,8) THEN to_char(substr(ssn,1,2),'0099')+2000
     ELSE to_char(substr(ssn,1,2),'0099')+1800
     END "생년"
     ,TO_CHAR(SYSDATE,'YYYY') as "올해년도"
     ,SIGN(to_char(sysdate,'mmdd')-substr(ssn,3,4)) as "생일여부"
FROM insa
)
SELECT 이름,주민등록번호,생년,올해년도
       ,CASE 생일여부
       WHEN 1  THEN to_char(SYSDATE,'YYYY')-생년-1 
       WHEN -1  THEN to_char(SYSDATE,'YYYY')-생년 
       ELSE to_char(SYSDATE,'YYYY')-생년 
       END "나이"       
FROM a;
------
SELECT DBMS_RANDOM.RANDOM
      ,DBMS_RANDOM.value as "a" --  0.0 <= 실수  <1.0
      ,DBMS_RANDOM.value(0,100) as "a" --  0 <= 실수 < 100
      ,DBMS_RANDOM.string('U',5) as "a" --  UPPER 5
      ,DBMS_RANDOM.string('L',5) as "a" --  LOWER 5
      ,DBMS_RANDOM.string('A',5) as "a" --  알파벳 5
      ,DBMS_RANDOM.string('X',5) as "a" --  UPPER+숫자 5
      ,DBMS_RANDOM.string('P',5) as "a" --  알파벳+숫자+특문 5
FROM dual;
SELECT trunc(DBMS_RANDOM.value(0,101)) scroe
      ,trunc(DBMS_RANDOM.value(0,45))+1 lotto
      ,trunc(DBMS_RANDOM.value(150,201)) v
FROM dual;
-- 피벗(pivot) 처럼
SELECT count(*)
      ,COUNT(DECODE(job,'CLERK','O')) CLERK
      ,COUNT(DECODE(job,'SALESMAN','O')) SALESMAN
      ,COUNT(DECODE(job,'PRESIDENT','O')) PRESIDENT
      ,COUNT(DECODE(job,'MANAGER','O')) MANAGER
      ,COUNT(DECODE(job,'ANALYST','O')) ANALYST
FROM emp;
-- 피벗(pivot)
--SELECT * 
--  FROM (피벗 대상 쿼리문)
-- PIVOT (그룹함수(집계컬럼) FOR 피벗컬럼 IN(피벗컬럼 값 AS 별칭...))
SELECT *
FROM(
SELECT job 
FROM emp
)
pivot( 
count(*) 
for job in('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST' ));

SELECT * 
  FROM (SELECT 
         job , 
         TO_CHAR(hiredate, 'FMMM') || '월' hire_month
         FROM emp
       )
   PIVOT(
         count(*)
          FOR hire_month IN ('1월', '2월')
        );

-- emp 각 부서별 각 job 별로 인원수 가로 출력
SELECT *
FROM (
SELECT b.deptno , a.job
FROM emp a ,dept b
WHERE a.deptno(+) = b.deptno
)
PIVOT(
count(*)
for job in('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST' ))
order by 1;


-- 내일 복습문제
-- 오라클 자료형
-- DDL + DML 
-- CONSTRAINT 제약조건
-- 조인 
-- DB 모델링 
-- 하루 팀 프로젝트
-- PL/SQL