SELECT num,name
       ,decode(tel,null,'X',tel,'O') tel
       ,nvl2(tel,'O','X') tel
       ,nvl(replace(tel,substr(tel,1),'O'),'X') tel
FROM insa
WHERE buseo = '개발부';
    
    
SELECT SYSDATE
       ,to_char(sysdate,'CC') 세기
       ,to_char(sysdate,'SCC') 세기
FROM dual;

SELECT '05/01/10'
      ,to_char(to_date('05/01/10','RR/MM/DD'),'YYYY') rr
      ,to_char(to_date('05/01/10','YY/MM/DD'),'YYYY') yy
      
      ,to_char(to_date('01/01/10','RR/MM/DD'),'YYYY') rr
      ,to_char(to_date('01/01/10','YY/MM/DD'),'YYYY') yy
FROM dual;

SELECT *
FROM dept;

SELECT ename
      ,replace(ename,upper('m'),'*')name
FROM emp
--WHERE ename like '%M%'
where ename like upper('%m%');

-- 문제 emp 테이블에서 ename 'la' 대소문자 구분 없이 잇는 사원 조회
SELECT ename
FROM emp
where regexp_like(ename,'la','i');
--i  대소문자 구분 없음 
--c 대소문자 구분 있음 
--n period(.)를 허용함 
--m source string이 여러 줄인 경우(multiple lines) 
--x whitespace character(공백문자) 무시 

--정규표현식을 사용할 수 있는 함수
-- 복수행 함수
SELECT COUNT(*)
FROM emp;
-- 단일행 함수( signle row function)
SELECT LOWER(ename)
FROM emp;
--
SELECT *
FROM test
WHERE regexp_like(name,'^[한백]');
WHERE regexp_like(name,'강산$');

-- insa 테이블에서 남자사원만
WHERE ssn LIKE '7%' AND MOD(substr(ssn,-7,1)),2) == 1;
WHERE REGEXP_LIKE(ssn,'^7.(6)[13579]') 
WHERE REGEXP_LIKE(ssn,'^7\d(5)-[13579]') 

-- insa 성 김,이 조회 
SELECT *
FROM insa
WHERE name LIKE '김%'
OR name LIKE '이%';

SELECT *
FROM insa
WHERE REGEXP_LIKE(name,'^[김이]');
-- insa 성 김,이 제외 조회 
SELECT *
FROM insa
--WHERE not(name LIKE '김%' OR name LIKE '이%');
WHERE name not LIKE '김%'
AND name not LIKE '이%';

SELECT *
FROM insa
WHERE not REGEXP_LIKE(name,'^[김이]');

SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay
--      ,max((sal+nvl(comm,0))) 
FROM emp
--group by deptno,empno,ename
order by pay desc;
-- ALL SQL 연산자 사용
with temp AS(
SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay
FROM emp
)
SELECT *
FROM temp
WHERE pay >= ALL (SELECT pay FROM temp);

SELECT 
     max(sal+nvl(comm,0)) maxpay
    ,min(sal+nvl(comm,0)) minpay
FROM emp;
--
SELECT deptno, ename, sal+nvl(comm,0) pay
FROM emp
--WHERE sal+nvl(comm,0) = (SELECT max(sal+nvl(comm,0)) FROM emp  );
--WHERE sal+nvl(comm,0) = (SELECT min(sal+nvl(comm,0)) FROM emp  );
WHERE sal+nvl(comm,0) = 5000;

-- 집합 연산자(SET OPERATOR)
-- 1) 두 테이블의 칼럼수 동일
-- 2) 대응 되는 컬럼 타입 동일
-- 3) 컬럼이름 상관 X
-- 4) 결과 출력은 첫 번쨰 select 컬럼으로 나옴 
-- 합집합 : union , all
-- 교집합 : INTERSECT
-- 차집합 : MINUS 

SELECT empno,ename,hiredate
FROM emp
union 
SELECT num,name,ibsadate 
FROM insa;

--union 과 all의 차이점  중복허용X,중복허용
--INTERSECT
--(2) insa 인천 조회
SELECT name,city,buseo
FROM insa
WHERE city = '인천'
--(1) insa 개발부 조회
MINUS 
SELECT name,city,buseo
FROM insa
WHERE buseo = '개발부';

-- 문제 insa 남자 O 여자 X
SELECT name,ssn
       ,decode(mod(substr(ssn,-7,1),2),1,'남자',0,'여자') gender
--        ,NULLIF(mod(substr(ssn,-7,1),2),1) gender
        , nvl2(NULLIF(mod(substr(ssn,-7,1),2),1),'X','O')gender
FROM insa;
-- 집합 연산자(SET OPERATOR)
SELECT name,ssn,'O'gender
FROM insa
WHERE mod(substr(ssn,-7,1),2) = 1
union
SELECT name,ssn,'X'gender
FROM insa
WHERE mod(substr(ssn,-7,1),2) = 0;

---------------------------
--1. 오라클 함수 정희
--2.     ''     가눙
--3.     ''     종류
--숫자
--ROUND(number,n(-n)) 숫자값을 특정 위치에서 반올림하여 리턴한다. 
SELECT ROUND(15.193) a
--       ,ROUND(15.193,0)
--        ,ROUND(15.193,-1)
FROM dual;
--TRUNC(number) 숫자값을 특정 위치에서 절삭하여 리턴한다. 
SELECT TRUNC(15.8193) a
       ,TRUNC(15.8193,1) -- FLOOR(15.8193*10)/10
        ,TRUNC(15.193,-1)
FROM dual;
--CEIL 숫자값을 소숫점 첫째자리에서 올림하여 정수값을 리턴한다. 
SELECT CEIL(15.193) --16
FROM dual;
--FLOOR 숫자값을 소숫점 첫째자리에서 절삭하여 정수값을 리턴한다. 
SELECT FLOOR(15.193) --15
FROM dual;
-- 나머지 MOD() , REMAINDER()
SELECT MOD(19,4) -- n2-n1*floor(n2/n1)
       ,REMAINDER(19,4) -- n2-n1*round(n2/n1)
FROM dual;
-- ABS() 절대값 , SIGN() 양수 1 음수 -1 0 0 , POWER 제곱 , SQRT 루트
SELECT ABS(100),ABS(-100)
       ,SIGN(100),SIGN(-100)
       ,POWER(2,3)
       ,SQRT(2)
FROM dual;
--문자
--UPPER 영어 소문자를 대문자로 바꾸어 리턴한다. 
--LOWER 영어 대문자를 소문자로 바꾸어 리턴한다. 
--INITCAP 문자열중 각 단어의 첫글자만 대문자로 바꾸어 리턴한다. 
--CONCAT 첫번째 문자열과 두번째 문자열을 연결하여 리턴한다. 연결 연산자(??) 참조 
--SUBSTR 문자값 중 특정 위치부터 특정 길이만큼의 문자값만을 리턴한다.

--LENGTH 문자열의 길이를 숫자값으로 리턴한다. 
SELECT distinct(job)
       ,length(job)
FROM emp;
-- emp 에서 ename에 ? 문자가 있는 사원 조회 
-- INSTR ? 문자가 있는 위치 값 조회
SELECT ename
       ,INSTR(ename,'L') job
FROM emp
WHERE regexp_like(ename,'l','i');
WHERE ename like '%M%'

SELECT INSTR('corporate floor','or')  c
      ,INSTR('corporate floor','or',4)  c
      ,INSTR('corporate floor','or',4,2)  c
      ,INSTR('corporate floor','or',-1,2)  c
     FROM dual;
-- RPAD / LPAD (expr1, n [, expr2] )
-- 100 단위로 # 추가
-- 10 단위 반올림 # 추가
SELECT ename
       ,sal+nvl(comm,0) pay
--       ,LPAD(sal+nvl(comm,0),10,'*') pay
--       ,RPAD(sal+nvl(comm,0),10,'*') pay
       ,ROUND(sal+nvl(comm,0),-2) pay
       ,ROUND(sal+nvl(comm,0),-2)/100 pay
       ,RPAD(' ',ROUND(sal+nvl(comm,0),-2)/100+1,'#') pay
FROM emp;
-- LTRIM / RTRIM / TRIM
-- 특정문자와 일치하는 문자값 제거 - 주로 공백제거에 쓰임 
select 'BROWINGyxXxy'
      ,RTRIM('BROWINGyxXxy','xy') "RTRIM example" 
      ,LTRIM('BROWINGyxXxy','xy') "LTRIM example" 
from dual;
SELECT '[' ||'   admin   '||']'a
      ,'[' ||LTRIM('   admin   ')||']'a
      ,'[' ||RTRIM('   admin   ',' ')||']'a
      ,'[' ||TRIM('   admin   ')||']'a
      ,'[' ||LTRIM('xyxyadminxyxy','xy')||']'a
      ,'[' ||RTRIM('xyxyadminxyxy','xy')||']'a      
FROM dual;
-- ASCII , CHR
SELECT ASCII('A'),ASCII('a'),ASCII('0')
      ,CHR(65),CHR(97),CHR(48)
from dual;
-- GREATEST , LEAST 나열된 값중 가장 큰 값과 작은값
SELECT GREATEST(3,5,2,4,1)
      ,LEAST(3,5,2,4,1)
      ,GREATEST('MBC','TVC','SBS')
FROM dual;
--replace  a1: 전제문자열 a2: 전체 문자열 a1중에서 바꾸기를 원하는 문자열 a3: 바꾸고자 하는 새로운 문자열
--VSIZE 지정된 문자열의 크기를 숫자값으로 리턴한다. BYTE
SELECT VSIZE('a'),VSIZE('한')
FROM dual;
--날짜
--변환
--일반 , 정규표현식
--그룹
---------------------------

