-- SCOTT --
SELECT (
FROM tabs;

--SQL 수행 과정 이해
-- Optimizer 검색
-- DQL문 : SELECT

-- 모든 사용자 계정 조회 
SELECT * FROM all_users;
-- HR 계정 (샘플 계정)
-- 접속시 ORA-28000 계정 락 상태 

-- HR 계정의 상태 확인
SELECT * FROM dba_users;

-- DQL : SELECT 
-- 1) 데이터 가져오는 데 사용하는 SQL문
-- 2) 대상 : 테이블 , 뷰 
-- 3) 사용자가 소유한 테이블, 뷰 
-- 4) SELECT 권한 

SELECT * FROM emp; -- scott.sql 스크립트 파일 

--【형식】
--    [subquery_factoring_clause] subquery [for_update_clause];

--【subquery 형식】
--   {query_block ?
--    subquery {UNION [ALL] ? INTERSECT ? MINUS }... ? (subquery)} 
--   [order_by_clause] 

--【query_block 형식】
--   SELECT [hint] [DISTINCT ? UNIQUE ? ALL] select_list
--   FROM {table_reference ? join_clause ? (join_clause)},...
--     [where_clause] 
--     [hierarchical_query_clause] 
--     [group_by_clause]
--     [HAVING condition]
--     [model_clause]

--【subquery factoring_clause형식】
--   WITH {query AS (subquery),...}

--SELECT 문의 prototype은 이곳에 있다.


--SQL 문은 절(clause)이라 하는 몇 개의 섹션으로 나뉘어지며, SELECT 문에서 사용되는 절은 다음과 같다. 

--? WITH 
--? SELECT 
--? FROM 
--? WHERE 
--? GROUP BY 
--? HAVING 
--? ORDER BY 

-- SELECT 문 절 순서 , 처리 순서 
--1. [? WITH] 
--6.  ? SELECT 
--2. ? FROM 
--3. [? WHERE] 
---- 계층 절 [hierarchical_query_clause] 
--4. [? GROUP BY] 
--5. [? HAVING] 
--7. [? ORDER BY] 

-- scott 사용자가 소유한 테이블 정보 조회
SELECT * -- 조회할 목록 
FROM user_tables; -- 뷰(view) (데이터 사전)
-- emp (사원) 테이블의 사원 정보를 조회
SELECT empno,ename,hiredate
FROM emp;

-- emp 테이블의 구조 확인 
DESCRIBE emp;
DESC emp;

-- dept 테이블의 구조 확인
-- dept 테이블의 모든 컬럼을 조회
DESC dept;
SELECT * FROM dept;

-- emp 테이블의 job(일, 임무,업무)을 조회
-- 각 사원들의 job을 조회 
SELECT job FROM emp;
SELECT DISTINCT job FROM emp; -- 중복제거
-- emp 테이블의 job의 갯수 파악
SELECT count(DISTINCT(job)) as job FROM emp;
-- emp 데이블에서 각 사원을 사원명 입사일자 조회
SELECT empno,to_char(hiredate,'yyyy-mm-dd') as hiredate from emp;

-- ORA-00942: table or view does not exist
-- emp 테이블 : 객체 를 소유한 소유자X , SELECT 권한 X
SELECT * FROM emp; -- scott.sql 스크립트 파일 

-- 문제 emp 테이블에서 사원의 부서번호 사원명 급여(sal + comn) 
-- null 처리 함수 nvl,nvl2,nullif,coalesce 
SELECT deptno as 부서번호 ,ename as 사원명,
--sal,comm,
--nvl(sal+comm,sal) as pay
--nvl(sal+comm,sal) "pay"
--nvl(sal+comm,sal) "my pay"
nvl(sal+comm,sal) my_pay,
(sal + nvl(comm,0))*12 as anm_s
FROM emp
order by 1;

SELECT deptno as 부서번호 ,ename as 사원명,sal,comm,SUM(sal + nvl(comm,0)) as 급여 FROM emp
group by deptno,ename,comm,sal
order by 1;

-- emp 테이블에서 모든 사원정보를 조회 
SELECT *
FROM emp;

-- emp 테이블에서 deptno 30 부서원만 조회 (deptno,ename,job,hiredate,pay)
SELECT deptno,ename,job,hiredate
,sal+nvl(comm,0) as pay
FROM emp
WHERE deptno = 30;

-- 문제 emp 테이블에서 20.30 부서원 정보 조회
--SELECT deptno, * 구문 오류
SELECT deptno, emp.*
FROM emp
WHERE deptno in(20,30)
--WHERE deptno = 30 OR deptno=20
--WHERE deptno=10 AND job='CLERK' 대소문자 구분 
order by 1;

select * from insa;
--문제1) 서울 사람의 이름(name), 출신도(city), 부서명(buseo), 직위(jikwi) 출력 
SELECT name,city,buseo,jikwi
FROM insa
where city ='서울'
order by 3,1 desc;
--문제2) 출신도가 서울 사람이면서 기본급이 150만원 이상인 사람 출력 (name, city, basicpay, ssn) 
SELECT name,city,basicpay,ssn
FROM insa
where city ='서울'
and basicpay >= '1500000'
order by 3;
--문제3) 출신도가 서울 사람이거나 부서가 개발부인 자료 출력 (name, city, buseo) 
SELECT name,city,buseo
FROM insa
where city ='서울'
or BUSEO = '개발부';
--문제4) 출신도가 서울, 경기인 사람만 출력 (name, city, buseo) 
SELECT name,city,buseo
FROM insa
where city in('서울','경기');
--문제5) 급여(basicpay + sudang)가 250만원 이상인 사람. 단 필드명은 한글로 출력. (name, basicpay, sudang, basicpay+sudang) + 급여 내림차순 정렬 
SELECT name, basicpay, sudang
      ,(basicpay+sudang) as 급여
FROM insa
where (basicpay+sudang) >= '2500000'
order by 4 desc;

-- 직속상사가 없는 사원의 정보를 조회 
-- mgr에 null을 boss 로 
SELECT empno,ename,job,NVL(to_char(mgr),'BOSS') as mgr,hiredate 
FROM emp
WHERE mgr IS NULL;
--WHERE mgr IS NOT NULL;




