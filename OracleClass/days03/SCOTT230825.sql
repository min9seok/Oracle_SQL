SELECT empno,ename,hiredate
      ,to_char(hiredate)
FROM emp
where substr(hiredate,1,2) = 81;

select to_char(sysdate,'HH'), to_char(sysdate,'HH12'), 
         to_char(sysdate,'HH24') from dual;

-- SUBSTR 설명
SELECT Substr('abcdesfg', 3,2)  -- 'cd'
      ,Substr('abcdesfg', 3) -- 'cdefg'
      ,Substr('abcdesfg', -3,2) -- 'sf'
FROM dual;

-- 문제 insa 에서 이름 주민등록번호 조회 주민번호 111111-2******,년도 월 일 성별 검증 조회

SELECT name,ssn
      ,SUBSTR(ssn,1,8) || '******' s
      ,CONCAT(SUBSTR(ssn,1,8),'******') c      
      ,REPLACE(ssn,SUBSTR(ssn,9),'******') r
      ,SUBSTR(ssn,1,2) year
      ,SUBSTR(ssn,3,2) month
--      ,SUBSTR(ssn,5,2) as "DATE" -- 예약어 사용 시 
      ,SUBSTR(ssn,5,2) day
      ,SUBSTR(ssn,8,1) gender
      ,SUBSTR(ssn,-1) regx
FROM insa;
-- 771212-1022432 출생년도 1이면 1900 3이면 2000

SELECT empno,ename,job
        ,nvl(to_char(mgr),'CEO') mgr
        ,hiredate,sal,comm,deptno
FROM emp;

SELECT 'ABcD'
,UPPER('abcd')
,lower('ABcD')
,INITCAP('ABcD')
FROM dual;

TO_CHAR

SELECT name
       , basicpay+sudang pay
       , to_char(basicpay+sudang)pay 
       , to_char(basicpay+sudang,'9,999')pay 
       , to_char(basicpay+sudang,'L99,999,999')pay 
       , ibsadate
FROM insa;

-- 오라클 자료형 
-- 오라클 연산자
-- 1) 산술연산자 + - * / 나머지 연산자 X 함수 : MOD()
SELECT 1+2 -- 3
      , 1-2 -- -1
      , 1*2 -- 2
      , 1/2 d -- 0.5
--      , 2/0 -- ORA-01476: divisor is equal to zero
--      , 3.14/0
--      , 1%2 -- 나머지 ORA-00911: invalid character
      , MOD(1,2) 
FROM dual;

--2) 연결 문자열
DROP TABLE 테이블명 CASCADE; -- DDL 구성 자동으로 성성 실행,PL/SQL

SELECT ' DROP TALBE ' || table_name || ' CARCATE; '
FROM user_tables;
 DROP TALBE DEPT CARCATE; 
 DROP TALBE EMP CARCATE; 
 DROP TALBE BONUS CARCATE; 
 DROP TALBE SALGRADE CARCATE; 
 DROP TALBE INSA CARCATE; 
 
--3) 사용자 정의 연산자 
CREATE OPERATOR 문으로 연산자를 생성할 수 있음 

--4) 계층적 질의 연산자  
PRIOR, CONNECT_BY_ROOT가 계층적 질의 연산자임 

--5) 비교 연산자 = != <> ^= > < <= >=
 SQL연산자
 ANY, SOME -- 서브쿼리에 내용이 하나라도 만족하면 출력
 ALL -- 서비쿼리에 내용이 전부 만족해야 출력 

SELECT deptno
FROM dept;

SELECT *
FROM emp
WHERE deptno > ANY( SELECT deptno FROM dept );
WHERE deptno <= ANY( SELECT deptno FROM dept );
WHERE deptno <= ALL( SELECT deptno FROM dept );
WHERE deptno 비교연산자 ALL ( 서브쿼리 );
where deptno <= 20;

--6) 논리 연산자 AND OR NOT
--7) SQL 연산자
 (NOT) IN  
 (NOT)BETWEEN a AND b  
 is (NOT) null  
 ANY,SOME,ALL
 EXISTS 상관 서브쿼리 
 (NOT) LIKE -- wildcard(%,_) ESCAPE 옵션을 사용 문자 패턴 일치 검색 
 REGEXP_LIKE - 함수
 ex) emp 테이블 R 로 시작하는 사원 , insa 사원명 이 사원 
 
 SELECT *
 FROM insa
 where ssn like '81%'
-- 문제 insa 테이블 남자사원 조회
SELECT *
FROM insa
where substr(ssn,8,1) = 1;
-- 문제 이름 두번째 글자 순 조회
SELECT *
FROM insa
WHERE name like '_순%'

-- 새로운 컬럼(부서)를 추가 
INSERT INTO 테이블명 (컬럼명) VALUES(값...);
INSERT INTO dept (deptno,dname,loc) VALUES('50','한글_나라','SEOUL');
INSERT INTO dept (deptno,dname,loc) VALUES('60','한100%나','SEOUL');

-- 검색: 부서명(dname)에 '_나' 검색
SELECT *
FROM dept
WHERE dname like '%\_나%' ESCAPE '\' ;

-- 문제) 부서명에 % 부서 검색 
SELECT *
FROM dept
WHERE dname like '%\%%' ESCAPE '\' ;

UPDATE 테이블명 
set 컬럼명 = 값
WHERE 조건절 
UPDATE dept
set loc = 'KOREA'
WHERE loc = 'SEOUL'


-- 오라클 함수


-- dual? PUBLIC SYSNONYM
-- SCOTT 사용자가 소유한 테이블 정보 조회
-- dba_XXX, all_XXX, user_XXX 차이점 DB관리자,DB전체,DB접속자  
SELECT *
FROM user_tables; -- DB접속자가 소유한 테이블
FROM dba_tables; -- ORA-00942: table or view does not exist DB관리자가 사용할 수 있는 테이블
FROM all_tables; -- DB접속자 + 사용권한 부여받은 테이블

-- 3) SCOTT 접속
-- 4) 시노님에 권한을 부여

GRANT SELECT ON emp TO HR;

SELECT *
FROM arirnag

