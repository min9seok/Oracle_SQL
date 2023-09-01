--문제 1
SELECT distinct(BUSEO)
,(SELECT COUNT(*) FROM insa WHERE buseo = m.buseo) cnt
FROM insa m;
--문제 insa 남자사원,여자사원 수 조회
--(1) 내 풀이
SELECT distinct((SELECT COUNT(*) FROM insa WHERE substr(ssn,-7,1) = substr(m.ssn,-7,1))) cnt
      ,decode(substr(ssn,-7,1),1,'남자','여자') gender
FROM insa m;
--(2) group by
SELECT decode(substr(ssn,-7,1),1,'남자','여자') gender
       ,count(*)
FROM insa
group by substr(ssn,-7,1),1;

SELECT COUNT(*) "전체"
      ,COUNT(decode(MOD(substr(ssn,-7,1),2),1,'남자')) "남자"
      ,COUNT(decode(MOD(substr(ssn,-7,1),2),0,'여자')) "여자"
FROM insa;

SELECT decode(substr(ssn,-7,1),1,'남자') gender
FROM insa;

SELECT count(*)
    ,count(mgr)
FROM emp;

SELECT decode(MOD(substr(ssn,-7,1),2),1,'O')
FROM insa;

SELECT deptno,count(*)
FROM emp
GROUP BY deptno
union
SELECT null,count(*)
FROM emp
order by 1;
-- 문제 dept에 맞춰서 부서 인원 조회
SELECT  b.deptno
        ,(SELECT COUNT(*) FROM emp WHERE deptno = b.deptno) "인원"
FROM dept b
group by b.deptno;
--
SELECT COUNT(*)
       ,COUNT(decode(deptno,10,'O')) a
       ,COUNT(decode(deptno,20,'O')) b
       ,COUNT(decode(deptno,30,'O')) c
       ,COUNT(decode(deptno,40,'O')) d
FROM emp;

--피봇(pivot)기능 세로자료를 가로로 
--COUNT(*) 10 20 30 40
---------------------------
--12 3 3 6 0

--문제 2
SELECT BUSEO,basicpay+sudang pay      
FROM insa m
WHERE basicpay+sudang = 
(SELECT max(basicpay+sudang)FROM insa WHERE m.buseo=buseo);

SELECT num,name,ssn
      ,replace(ssn,substr(ssn,3,4),to_char(sysdate,'mmdd'))
FROM insa
WHERE num in (1001,1002);

SELECT
     distinct((SELECT COUNT(*) FROM insa WHERE substr(ssn,3,4) < 0830)) "생일전 사원수"
     ,(SELECT COUNT(*) FROM insa WHERE substr(ssn,3,4) > 0830) "생일후 사원수"
     ,(SELECT COUNT(*) FROM insa WHERE substr(ssn,3,4) = 0830) "오늘 생일 사원수"
FROM insa;        

WITH temp AS(
SELECT num,name,ssn
,sign(to_char(sysdate,'mmdd') - substr(ssn,3,4)) s
FROM insa
)
SELECT COUNT(DECODE(s,-1,'O')) " 생일 전 사원수"
       ,COUNT(DECODE(s,1,'O')) " 생일 후 사원수"
       ,COUNT(DECODE(s,0,'O')) " 오늘 생일 사원수 "
       ,COUNT(*) "전체 사원수"
FROM temp;

     SELECT round((sysdate-to_date('1997/06/22')),2) 일수
      ,round(MONTHS_BETWEEN(sysdate,'1997/06/22'),2) 개월
      ,round(MONTHS_BETWEEN(sysdate,'1997/06/22')/12,2) 년수
FROM dual;

SELECT SYSDATE
      ,TO_CHAR(SYSDATE,'W')
      FROM dual;

SELECT TO_CHAR(TO_DATE('2022.1.1'),'IW') a
      ,TO_CHAR(TO_DATE('2022.1.1'),'WW') a
      ,TO_CHAR(TO_DATE('2022.1.2'),'IW') a
      ,TO_CHAR(TO_DATE('2022.1.2'),'WW') a
      ,TO_CHAR(TO_DATE('2022.1.3'),'IW') a
      ,TO_CHAR(TO_DATE('2022.1.3'),'WW') a
      ,TO_CHAR(TO_DATE('2022.1.8'),'IW') a
      ,TO_CHAR(TO_DATE('2022.1.8'),'WW') a
FROM dual;

SELECT SYSDATE
      ,LAST_DAY(SYSDATE)
      ,TO_CHAR(LAST_DAY(SYSDATE),'DD')
      , ADD_MONTHS(SYSDATE,1)
FROM dual;

SELECT TO_DATE('2022','YYYY') a
      ,TO_DATE('2022.02','YYYY.MM')a
      ,TO_DATE('02','DD')a
FROM dual;

SELECT  sal+nvl(comm,0) pay      
       ,sal+nvl2(comm,comm,0) pay       
       ,sal+COALESCE(comm,0)pay
       ,COALESCE(sal+comm,sal,0) pay
FROM emp;

SELECT name, ssn
	,CASE 
    WHEN mod(substr(ssn,-7,1),2)=1 THEN '남자'			      
			  ELSE '여자'
	END gender
    ,CASE mod(substr(ssn,-7,1),2)
    WHEN 1 THEN '남자'
    ELSE '여자'
    END gender
FROM insa;

SELECT num,name ,ssn      
--      ,decode(SIGN(substr(ssn,3,4)-to_char(sysdate,'mmdd')),-1,'생일 후',1,'생일 전','오늘 생일') c
    ,CASE
    WHEN  to_char(sysdate,'mmdd') > substr(ssn,3,4) THEN '생일 후'
    WHEN  to_char(sysdate,'mmdd') < substr(ssn,3,4) THEN '생일 전'
    WHEN  to_char(sysdate,'mmdd') = substr(ssn,3,4) THEN '오늘 생일'
    END b
FROM insa;

SELECT to_char(sum(sal+nvl(comm,0)),'L999,999') pay
FROM emp
WHERE sal+nvl(comm,0) >=(
SELECT to_char(avg(sal+nvl(comm,0)),'9999.00')
FROM emp
);

--조인이라 하다가 넘어감 
WITH a AS(
SELECT to_char(avg(sal+nvl(comm,0)),'9999.00') avg_pay
FROM emp
),
b AS(
SELECT empno,ename,sal+nvl(comm,0) pay
FROM emp
)
SELECT *
FROM b,a
WHERE b.pay >= a.avg_pay;
SELECT sum(pay)
FROM(
SELECT empno,ename,sal+nvl(comm,0) pay
FROM emp
WHERE sal+nvl(comm,0) >= ( 
SELECT avg(sal+nvl(comm,0)) FROM emp
)
);

WITH temp AS(
SELECT empno,ename
       ,sal+nvl(comm,0) pay
       ,(SELECT avg(sal+nvl(comm,0))FROM emp ) avg_pay
FROM emp
)
SELECT sum(decode(SIGN(t.pay-t.avg_pay),-1,null,t.pay)) sp
      ,sum(
      CASE
      WHEN SIGN(t.pay-t.avg_pay) >=0   THEN t.pay
      ELSE null
      END 
      ) d
FROM temp t;

SELECT deptno
FROM dept
MINUS
SELECT deptno
FROM emp;

--JOIN
SELECT a.deptno,dname,empno,ename,hiredate
FROM emp a,dept b
WHERE a.deptno = b.deptno;
--
SELECT a.deptno,dname,empno,ename,hiredate
FROM emp a JOIN dept b
ON a.deptno = b.deptno;

--15, 15-2 JOIN이용한 풀이 
SELECT a.deptno , count(empno)
FROM dept a LEFT JOIN emp b
ON a.deptno = b.deptno
group by a.deptno
having count(empno) =0
order by 1;

SELECT buseo,jikwi, count(*)
FROM insa
group by buseo,jikwi
order by 1,2;


  SELECT deptno,ename,sal+nvl(comm,0)
       ,decode(deptno
              ,10,15
              ,20,10
              ,30,5
              ,40,20) ||'%'
              as "인상률"
      ,decode(deptno
              ,10,(sal+nvl(comm,0))*0.15 
              ,20,(sal+nvl(comm,0))*0.10
              ,30,(sal+nvl(comm,0))*0.05
              ,40,(sal+nvl(comm,0))*0.20) 
              as "인상액"
FROM emp
order by deptno;

  SELECT deptno,ename,sal+nvl(comm,0)
         ,(sal+nvl(comm,0)) * (CASE deptno
         WHEN 10 THEN 0.15
         WHEN 20 THEN 0.10
         WHEN 30 THEN 0.05
         WHEN 40 THEN 0.20
         END) as "인상액"
FROM emp

