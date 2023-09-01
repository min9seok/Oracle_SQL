--GREATEST LEAST VSIZE RPAD / LPAD INSTR UPPER LOWER INITCAP CONCAT SUBSTR LENGTH
--ABS MOD REMAINDER ROUND TRUNC CEIL FLOOR NULLIF INTERSECT MINUS REGEXP_LIKE
--ASCII CHR icmnx

-- 각 사원 총급여 
-- 각 사원 수
-- 각 사원 평균급여
--SELECT sum(sal+nvl(comm,0)) sumpay --27125 
--      ,count(sal+nvl(comm,0)) cnt --12
--      ,avg(sal+nvl(comm,0)) avg-- 2260.4166
--      ,max(sal+nvl(comm,0)) max
--      ,min(sal+nvl(comm,0)) min
--      ,STDDEV(sal+nvl(comm,0)) STDDEV_pay--표준편차 : 분산의 제곱근(루트)
--      ,variance(sal+nvl(comm,0)) variance_pay --분산 : 각사원 (pay - avg_pay)^2의 평균
--FROM emp

--4) LNNVL()
--a=1 FALSE TRUE 
--a=2 TRUE FALSE 
--a IS NULL FALSE TRUE 
--b=1 UNKNOWN TRUE 
--b IS NULL TRUE FALSE 
--a=b UNKNOWN TRUE 


SELECT *
FROM emp e
WHERE sal+NVL(comm,0) = (SELECT max(sal+nvl(comm,0)) FROM emp WHERE e.deptno = deptno);

-- 각 부서별 최고 급여액
SELECT distinct(deptno)
      ,max(sal+nvl(comm,0)) pay
FROM emp
group by deptno
order by 1;

    SELECT  SUBSTR('031)1234-5678'
            ,INSTR('031)1234-5678',')')+1
            ,INSTR('031)1234-5678','-')- INSTR('031)1234-5678',')')-1) a        
    FROM dual;
    
    SELECT deptno,ename
       ,sal+nvl(comm,0) pay       
       ,rpad(round(sal+nvl(comm,0),-2)/100,round(sal+nvl(comm,0),-2)/100+2,'#') bar_length
FROM emp
where deptno = 30
order by 4 desc;
--TRUNC(number) 숫자값을 특정 위치에서 절삭하여 리턴한다. 
--FLOOR 숫자값을 소숫점 첫째자리에서 절삭하여 정수값을 리턴한다.     
SELECT TRUNC( SYSDATE, 'YEAR' ) a -- 년을 절삭
      , TRUNC( SYSDATE, 'MONTH' ) b  -- 월을 절삭
      , TRUNC( SYSDATE,'DAY'  ) c -- 시간 절삭
      , TRUNC( SYSDATE  ) d -- 시간 절삭
    FROM dual;
    
    SELECT ename,sal,comm 
      ,sal+nvl(comm,0) pay
      ,ROUND((SELECT avg(sal+nvl(comm,0)) FROM emp),5)avg_pay
      ,(SELECT SUM(sal+nvl(comm,0)) FROM emp) sum
--      ,SUM(sal+nvl(comm,0))
FROM emp
WHERE sal+nvl(comm,0) >= ROUND((SELECT avg(sal+nvl(comm,0)) FROM emp),5);

SELECT ename
      ,sal+nvl(comm,0) pay
      ,(SELECT max(sal+nvl(comm,0)) FROM emp) max_pay
      ,sal+nvl(comm,0)/(SELECT max(sal+nvl(comm,0)) FROM emp)  as "퍼센트"    
FROM emp;

SELECT t.*
       ,t.pay/t.max_pay*100||'%' as "퍼센트"
       ,RPAD(round(t.pay/t.max_pay*100/10),round(t.pay/t.max_pay*100/10)+1,'*') as "별갯수"
FROM(
SELECT ename
      ,sal+nvl(comm,0) pay
      ,(SELECT max(sal+nvl(comm,0)) FROM emp) max_pay      
      FROM emp
) t;

-- 문제 emp 에 pay순으로 등수 매기기 
SELECT t.*
       ,(SELECT count(*)+1
        FROM emp
        WHERE sal+nvl(comm,0)>t.pay ) as pay_RANK
FROM(
SELECT ename
       ,sal+nvl(comm,0) pay
FROM emp 
) t
order by 3;

--날짜 함수
--WW  년중 몇번째 주 
--W  월중 몇번째 주 
--IW 1년중 몇째주 
SELECT SYSDATE -- 현재날짜,시간정보 반환 함수
      ,to_char(sysdate,'YYYY/MM/DD AM HH24:mi:SS(DAY)')a
      ,to_char(sysdate,'DS TS')b      
      ,to_char(sysdate,'WW')c
      ,to_char(sysdate,'W')c
      ,to_char(sysdate,'IW')c
FROM dual;

--ROUNDSELECT SYSDATE
      ,TO_CHAR(SYSDATE,'DL TS')a
      ,ROUND(sysdate)a
      ,ROUND(sysdate,'MONTH')a
FROM dual;

SELECT SYSDATE
      ,TO_CHAR(SYSDATE,'DL TS')a
      ,ROUND(sysdate)a
      ,ROUND(sysdate,'DD')a
      ,ROUND(sysdate,'MONTH')a
      ,ROUND(sysdate,'YEAR')a
FROM dual;
--TRUNC ( date [,fmt] )
SELECT SYSDATE
      ,TO_CHAR(SYSDATE,'DL TS')a
      ,TRUNC(sysdate)a
      ,TRUNC(sysdate,'DD')a
      ,TRUNC(sysdate,'MONTH')a
      ,TRUNC(sysdate,'YEAR')a
FROM dual;  
-- MONTHS_BETWEEN 날짜간의 개월수 리턴
--날짜 + 숫자 날짜 날짜에 일수를 더하여 날짜 계산 
--날짜 - 숫자 날짜 날짜에 일수를 감하여 날짜 계산 
--날짜 + 숫자/24 날짜 날짜에 시간을 더하여 날짜 계산 
--날짜 - 날짜 일수 날짜에 날짜를 감하여 일수 계산 
-- emp 각 사원들의 근무일수, 근무개월수, 근무년수 조회
SELECT ename,hiredate,sysdate
      ,round(sysdate-hiredate) 근무일수 -- 날짜 - 날짜 = 일수 
      ,round(MONTHS_BETWEEN(sysdate,hiredate),1) 근무개월수
      ,round(MONTHS_BETWEEN(sysdate,hiredate)/12,1) 근무년수
      ,to_char(sysdate,'YYYY')-to_char(hiredate,'YYYY') 근무년수
FROM emp;
-- 1시간 후 수업 종료
SELECT sysdate
      ,to_char(sysdate,'TS')
      ,sysdate +1
      ,to_char(sysdate +1/24,'TS')
FROM dual;

-- ADD_MONTHS(date, month) 날짜 d에 n 개월을 더한 일자를 반환한다.
SELECT sysdate
      ,ADD_MONTHS(sysdate,3)
      ,ADD_MONTHS(sysdate,-1)
FROM dual;
    
--LAST_DAY ( date ) 특정 날짜가 속한 달의 가장 마지막 날짜를 리턴하는 함수 날짜 
SELECT sysdate
      ,last_DAY(sysdate) a
      -- 이번달 마지막 날짜 요일, 몇일까지.. 조회
      ,to_char(last_DAY(sysdate),'DAY')b
      ,to_char(last_DAY(sysdate),'DD')b
      -- 이번달 1일 요일
      ,to_char(TRUNC(sysdate,'month'),'DAY') c
      ,to_char(last_day(ADD_MONTHS(sysdate,-1))+1,'DAY') d
FROM dual;
-- NEXT_DAY(date,char) 명시된 요일이 돌아오는 가장 최근의 날짜를 리턴하는 함수 
SELECT SYSDATE
      ,TO_CHAR(SYSDATE,'DAY')a
      ,NEXT_DAY(SYSDATE,'금')b
      ,NEXT_DAY(SYSDATE,'화')
FROM dual;
--CURRENT_DATE 현재의 날짜와 시간을 출력 
SELECT CURRENT_DATE
FROM dual;

-- 문제 23,7,13 (목) 개강일 부터 100일 
SELECT to_char(SYSDATE,'YYYY.MM.DD(DY)')a    
    , to_char(to_date('23.7.13')+100,'YY.MM.DD(DY)')b
    , to_date('23.7.13(목)','YY.MM.DD(DY)')+100 c
    ,to_char(ADD_MONTHS(TRUNC(SYSDATE,'month')-1,-1)+13+100,'YYYY.MM.DD(DY)') d
FROM dual;

--변환 함수
--TO_NUMBER 문자 타입을 숫자 타입으로 변환 
--TO_CHAR(number) 숫자, 날짜 타입을 문자 타입으로 변환, TO_CHAR(character),TO_CHAR(datetime) 
--TO_DATE 숫자, 문자 타입을 날짜 타입으로 변환 
--CONVERT 문자열을 한 국가의 언어 형식에서 다른 국가 언어 형식으로 변환하여 실행 
--HEXTORAW 16진수 문자열을 2진수로 문자열을 변환 

--DECODE 여러 개의 조건을 주어 조건에 맞을 경우 해당 값을 리턴하는 함수
--비교 연산은 '='만 가능하다
--from 절만 빼고 어디에서나 사용할 수 있다.
--PL/SQL 안으로 끌어들여 사용하기 위하여 만들어진 오라클 함수이다.
-- if = decode(x,11,c)
-- if,else = decode(x,11,c,d)
-- if,else if,else = decode(x,11,c,12,d,e)

-- ex) insa 주민번호 남자 여자 출력
SELECT name,ssn    
    ,decode(mod(substr(ssn,-7,1),2),1,'남자','여자')gender
FROM insa;

--문제 emp 10번부서원 급여 15%인상 20번 30%인상 그외 부서 5%인상
SELECT deptno,ename
       ,sal+nvl(comm,0)pay
       ,decode(deptno
       ,10,(sal+nvl(comm,0))*0.15
       ,20,(sal+nvl(comm,0))*0.30
       ,(sal+nvl(comm,0))*0.05 ) as "인상액"
       ,decode(deptno
       ,10,sal+nvl(comm,0)+(sal+nvl(comm,0))*0.15
       ,20,sal+nvl(comm,0)+(sal+nvl(comm,0))*0.30
       ,sal+nvl(comm,0)+(sal+nvl(comm,0))*0.05)       
       as"인상된 급여"       
FROM emp
order by 1;

-- 함수(순위, TOP-N 등등)
-- 오라클 자료형
-- 테이블 생성~ 수정, 삭제
-- 제약조건
-- 조인

--WW 기준 요일부터 일주일  
--IW 월화수목금토일 고정 일주일 