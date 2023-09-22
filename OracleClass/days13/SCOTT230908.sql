-- 모델링 --
사원테이블
ㄴ 정규직 사원
ㄴ 비정규직 사원

(1) 슈퍼 타입 : 전체를 하나의 테이블로 관리

공통속성(칼럼)

(2) 서브 타입 : 정규직,비정규직 .. 서브 타입의 갯수만큼

설문조사 - 필요쿼리(정리)>JDBC>JSP

--자동 일련번호 생성
-- dept 테이블의 deptno 를 시퀀스를 생성해서 사용
;
SELECT MAX(deptno)+10
FROM dept;

--
CREATE USER
CREATE TABLE
CREATE VIEW

DROP SEQUENCE seq_deptno;
CREATE SEQUENCE seq_deptno
	 INCREMENT BY 10
	 START WITH 50	 
	 MAXVALUE 90
	 NOCYCLE
	 NOCACHE ;
-- 시퀀스 목록 조회
SELECT *
FROM user_sequences;
--FROM seq;
INSERT INTO dept values(seq_deptno.NEXTVAL,'QC',null);
SELECT * FROM dept;

SELECT seq_deptno.CURRVAL
FROM dual;
CREATE SEQUENCE seq_test;
--ORA-08002: sequence SEQ_TEST.CURRVAL is not yet defined in this session
SELECT seq_test.CURRVAL
FROM dual;

--- PL/SQL ---
--Procedural Language extensions to SQL
-- 절차적     언어      확장된        SQL
-- 블록 구조로 된 언어
-- 형식)
[DECLARE]
 1) 선언 블럭
BEGIN
 2) 실행 블럭
[EXCEPTION]
 3) 예외 처리 블럭
END
--PL/SQL 의 6가지 종류 
1) 익명 프로시저
2) 저장 프로시저 ***
3) 저장 함수
4) 패키지
5) 트리거
--6) 객체 X
desc insa;
--예) 익명 프로시저 작성
변수 값을 할당하는 방법
1) :=
2) SELECT, FETCH 등 : INTO문
DECLARE
-- 일반변수 v , 매개변수 p
-- 선언 블럭 : 변수 선언
-- vname VARCHAR2(20);
-- vpay NUMBER(10);
 vname INSA.name%TYPE := '익명'; --타입형 변수
 vpay NUMBER(10) := 0;
 vpi CONSTANT NUMBER := 3.141592;
 vmessage VARCHAR2(100);
BEGIN
 SELECT name, basicpay +sudang
 INTO vname,vpay
 FROM insa
 WHERE num =1001;
-- DBMS_OUTPUT.PUT_LINE('사원명=' || vname);
-- DBMS_OUTPUT.PUT_LINE('급여명=' || vpay);
vmessage := vname || ', ' || vpay;
DBMS_OUTPUT.PUT_LINE('결과 : ' || vmessage);
--EXCEPTION
END;
-- 문제 30번 부서의 지역명을 얻어와서
-- 10번 부서의 지역명으로 설정  ( 익명프로시저 작성)
SELECT *
FROM dept;
10	ACCOUNTING	NEW YORK
20	RESEARCH	DALLAS
30	SALES	CHICAGO
40	OPERATIONS	BOSTON
DECLARE
 vloc dept.loc%type;
BEGIN
SELECT loc INTO vloc
FROM dept
WHERE deptno=30;
UPDATE dept
SET loc = vloc
WHERE deptno=10;
--COMMIT;
--EXCEPTION
 --ROLLBACK;
END;
SELECT * FROM dept;
-- 문제 10번 부서원 중에 최고sal을 받는 사원의 정보 조회
--1) TOP-N
SELECT *
FROM(
SELECT *
FROM emp
WHERE deptno=10
ORDER BY sal desc
)
WHERE rownum=1;
-- 2) RANK 함수 
SELECT *
FROM(
SELECT e.*
 ,RANK() OVER(ORDER BY sal desc) sal_rank
FROM emp e
WHERE deptno = 10
)
WHERE sal_rank = 1;
-- 3) 서브쿼리
SELECT *
FROM emp
WHERE deptno = 10 AND sal = (
SELECT max(sal)
FROM emp
WHERE deptno=10
);
-- 4) 익명 프로시저 사용해서 처리.
DECLARE
vmax_sal_10 emp.sal%type;
vempno emp.empno%type;
vename emp.ename%type;
vjob emp.job%type;
vhiredate emp.hiredate%type;
vsal emp.sal%type;
vdeptno emp.deptno%type;
BEGIN
SELECT max(sal) INTO vmax_sal_10
FROM emp
WHERE deptno=10;

SELECT empno,ename,job,hiredate,sal,deptno
  INTO vempno,vename,vjob,vhiredate,vsal,vdeptno
FROM emp
WHERE deptno = 10 AND sal = vmax_sal_10;
DBMS_OUTPUT.PUT_LINE('사원번호 : ' || vempno);
DBMS_OUTPUT.PUT_LINE('사원명 : ' || vename);
DBMS_OUTPUT.PUT_LINE('입사일자 : ' || vhiredate);
--EXCEPTION
END;
-- 4-2) 익명 프로시저 사용해서 처리.
DECLARE
 vmax_sal_10 emp.sal%type; -- 타입형 변수 선언
 vrow emp%ROWTYPE; -- 레코드형 변수 선언
BEGIN
SELECT max(sal) INTO vmax_sal_10
FROM emp
WHERE deptno=10;

SELECT empno,ename,job,hiredate,sal,deptno
  INTO vrow.empno,
  vrow.ename,vrow.job,
  vrow.hiredate,vrow.sal,vrow.deptno
FROM emp
WHERE deptno = 10 AND sal = vmax_sal_10;
DBMS_OUTPUT.PUT_LINE('사원번호 : ' || vrow.empno);
DBMS_OUTPUT.PUT_LINE('사원명 : ' || vrow.ename);
DBMS_OUTPUT.PUT_LINE('입사일자 : ' || vrow.hiredate);
--EXCEPTION
END;
-- PL/SQL에서 여러개의 레코드를 가져와서 처리하기 위해서는  
-- 반드시 커서(cursor)을 사용해야 한다.
-- ORA-01422: exact fetch returns more than requested number of rows
DECLARE
 vname INSA.name%TYPE := '익명';
 vpay NUMBER(10) := 0;
 vpi CONSTANT NUMBER := 3.141592;
 vmessage VARCHAR2(100);
BEGIN
 SELECT name, basicpay +sudang
 INTO vname,vpay
 FROM insa;
vmessage := vname || ', ' || vpay;
DBMS_OUTPUT.PUT_LINE('결과 : ' || vmessage);
--EXCEPTION
END;

-- 자바)
if(조건식){
}

if(조건식){
}ELSE{
}

if(조건식){
}ELSE IF(조건식){
}ELSE IF(조건식){
}ELSE IF(조건식){
}ELSE{
}
--PL/SQL
IF (조건식) THEN
END IF;

IF (조건식) THEN
ELSE
END IF;

IF (조건식) THEN
ELSIF(조건식) THEN
ELSIF(조건식) THEN
ELSIF(조건식) THEN
ELSE
END IF;

-- 문제) 변수를 하나 선언해서 정수를 입력받아 짝수,홀수 출력
--ORA-06502: PL/SQL: numeric or value error: character string buffer too small
DECLARE
 vnum NUMBER(4) := 0;
 vresult VARCHAR2(6) := '홀수';
BEGIN
 vnum := :bindNumber;
 IF mod(vnum,2)=0 THEN vresult := '짝수';
-- ELSE vresult := '홀수';
 END IF;
 DBMS_OUTPUT.PUT_LINE( vnum || ' ' || vresult );
--EXCEPTION
END;

-- 문제 국어점수 입력받아서 수-가 출력
DECLARE
 vkor NUMBER(3) := 0;
 vgrade VARCHAR2(3) := '가';
BEGIN
 vkor := :bindNumber;
 IF (vkor BETWEEN 0 AND 100) THEN 
 IF vkor >= 90 THEN vgrade := '수';
 ELSIF vkor >= 80 THEN vgrade := '우';
 ELSIF vkor >= 70 THEN vgrade := '미';
 ELSIF vkor >= 60 THEN  vgrade := '양';
 END IF;
 END IF;
 DBMS_OUTPUT.PUT_LINE( vkor || ' ' || vgrade );
--EXCEPTION
END;
--
DECLARE
 vkor NUMBER(3) := 0;
 vgrade VARCHAR2(3) := '가';
BEGIN
 vkor := :bindNumber;
 IF (vkor BETWEEN 0 AND 100) THEN 
 CASE TRUNC( vkor/10 )
 WHEN 10 THEN vgrade := '수';
 WHEN 9 THEN vgrade := '수';
 WHEN 8 THEN vgrade := '우';
 WHEN 7 THEN vgrade := '미';
 WHEN 6 THEN vgrade := '양';
 END CASE;
 END IF;
 DBMS_OUTPUT.PUT_LINE( vkor || ' ' || vgrade );
--EXCEPTION
END;

--LOOP...END LOOP;(단순 반복) 문
JAVA
While(true){
  //무한루프
  if(조건) break;
}
Oracle
LOOP 
--
--
EXIT WHEN 조건
END LOOP;
예 1~10=55
DECLARE
 vi NUMBER := 1;
 vsum NUMBER := 0;
BEGIN
 LOOP
 IF vi=10 THEN DBMS_OUTPUT.PUT(vi);
 ELSE  DBMS_OUTPUT.PUT(vi || '+');
 END IF;
 vsum := vsum + vi;
 EXIT WHEN vi = 10;
  vi := vi+1;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('=' || vsum );
--EXCEPTION
END;
-- WHILE...LOOP(제한적 반복) 문
JAVA
while(조건식){
}
Oracle
WHile(조건식)
LOOP
--
END LOOP;
예 1~10 =55
DECLARE
 vi NUMBER := 1;
 vsum NUMBER := 0;
BEGIN
 WHILE vi <= 10
 LOOP 
 IF vi=10 THEN DBMS_OUTPUT.PUT(vi);
 ELSE DBMS_OUTPUT.PUT(vi || '+');
 END IF;
 vsum := vsum + vi;
  vi := vi+1;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('=' || vsum );
--EXCEPTION
END;
-- FOR...LOOP(제한적 반복) 문
JAVA 
for(int i=1 초기식; i<=10 조건식; i++ 증감식){}
Oracle
FOR 반복변수(i) IN [REVERSE] 시작값.. 끝값
LOOP
 -- 반복처리구문
 END LOOP;

DECLARE
 vi NUMBER := 1;
 vsum NUMBER := 0;
BEGIN
FOR vi IN 1..10
LOOP
 DBMS_OUTPUT.PUT(vi || '+');
 vsum := vsum+vi;
END LOOP;
DBMS_OUTPUT.PUT_LINE('=' || vsum );
--EXCEPTION
END;
--
DECLARE
-- vi NUMBER := 1;
 vsum NUMBER := 0;
BEGIN
FOR vi IN REVERSE 1..10
LOOP
 DBMS_OUTPUT.PUT(vi || '+');
 vsum := vsum+vi;
END LOOP;
DBMS_OUTPUT.PUT_LINE('=' || vsum );
--EXCEPTION
END;

--GOTO문--
--DECLARE
BEGIN
GOTO first_proc;
<<second_proc>>
DBMS_OUTPUT.PUT_LINE('>  2 처리 ');
GOTO third_proc;
<<first_proc>>
DBMS_OUTPUT.PUT_LINE('>  1 처리 ');
GOTO second_proc;
<<third_proc>>
DBMS_OUTPUT.PUT_LINE('>  3 처리 ');
--EXCEPTION
END;

-- 구구단(2~9) 출력
1) While LOOP ~ end loop 사용 *2
DECLARE
 vdan NUMBER := 2;
 vi NUMBER := 1;
 vsum NUMBER := 0;
BEGIN
while vdan <=9
LOOP
WHILE vi <=9
LOOP
 DBMS_OUTPUT.PUT(' '||vdan||'*'|| vi);
 vsum := vdan * vi;
 DBMS_OUTPUT.PUT_LINE('='||vsum); 
 vi := vi+1;
END LOOP;
 vdan := vdan+1;  
 vi := 1;
END LOOP;
--EXCEPTION
END;
-- 강사님 풀이
DECLARE
  vdan NUMBER(2):=2 ;
  vi NUMBER(2) := 1 ;
BEGIN
   WHILE vdan <= 9
   LOOP
     vi := 1; 
     WHILE vi <= 9
     LOOP
        DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' ' ) );
        vi := vi + 1;
     END LOOP;  
     DBMS_OUTPUT.PUT_LINE('');
     vdan := vdan + 1;
   END LOOP; 
--EXCEPTION
END;
2) for LOOP ~ END LOOP 사용 *2
BEGIN
FOR vdan IN 2..9
LOOP
FOR vi IN 1..9
LOOP
DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' || RPAD( vdan*vi, 4, ' ' ) );
END LOOP;
DBMS_OUTPUT.PUT_LINE('');
END LOOP;
--EXCEPTION
END;