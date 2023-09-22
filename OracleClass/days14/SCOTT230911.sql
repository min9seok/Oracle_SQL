-- 1)익명프로시저 선언 : %TYPE 형 변수
DECLARE
 vdeptno NUMBER(2);
 vdname dept.dname%TYPE;
 vempno emp.empno%TYPE;
 vename emp.ename%TYPE;
 vpay NUMBER;
BEGIN
-- 묵시적 커서 
SELECT d.deptno, dname,empno,ename,sal+nvl(comm,0) pay
 INTO vdeptno,vdname,vempno,vename,vpay
 FROM dept d JOIN emp e ON d.deptno = e.deptno
 WHERE empno = 7369;
 DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vdname 
 || ', ' || vempno || ', ' || vename || ', ' || vpay);
--EXECUTE
END;
-- 2)익명프로시저 선언 : %ROWTYPE 형 변수
DECLARE
 vdrow dept%ROWTYPE;
 verow emp%ROWTYPE;
 vpay NUMBER;
BEGIN
SELECT d.deptno, dname,empno,ename,sal+nvl(comm,0) pay
 INTO vdrow.deptno,vdrow.dname,verow.empno,verow.ename,vpay
 FROM dept d JOIN emp e ON d.deptno = e.deptno
 WHERE empno = 7369;
 DBMS_OUTPUT.PUT_LINE(vdrow.deptno || ', ' || vdrow.dname 
 || ', ' || verow.empno || ', ' || verow.ename || ', ' || vpay);
--EXECUTE
END;
-- 3)익명프로시저 선언 : RECORD 형 변수 
DECLARE
 -- 사용자 정의 구조체 타입 선언 
 TYPE EmpDeptType IS RECORD
 (deptno NUMBER(2),
  dname  dept.dname%TYPE,
  empno  emp.empno%TYPE,
  ename  emp.ename%TYPE,
  pay NUMBER);
 vderow EmpDeptType;
BEGIN
SELECT d.deptno, dname,empno,ename,sal+nvl(comm,0) pay
 INTO vderow.deptno,vderow.dname,vderow.empno,vderow.ename,vderow.pay
 FROM dept d JOIN emp e ON d.deptno = e.deptno
 WHERE empno = 7369;
 DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname 
 || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
--EXECUTE
END;
-- 4)익명프로시저 선언 : RECORD 형 변수  
--ORA-01422: exact fetch returns more than requested number of rows
-- 커서(CURSOR)를 사용해서 fatch 처리 
DECLARE
 -- 사용자 정의 구조체 타입 선언 
 TYPE EmpDeptType IS RECORD
 (deptno NUMBER(2),
  dname  dept.dname%TYPE,
  empno  emp.empno%TYPE,
  ename  emp.ename%TYPE,
  pay NUMBER);
 vderow EmpDeptType;
BEGIN
SELECT d.deptno, dname,empno,ename,sal+nvl(comm,0) pay
 INTO vderow.deptno,vderow.dname,vderow.empno,vderow.ename,vderow.pay
 FROM dept d JOIN emp e ON d.deptno = e.deptno;
 -- 조건절 삭제
 DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname 
 || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
--EXECUTE
END;
-----------------------------------------------------------------------------
-- CURSOR 커서 
1. PL/SQL 블럭 내에서 실행되는 SELECT 문
2. 여러 레코드로 구성된 작업영역에서 SQL문을 실행하고 그 결과를 저장하기 위해 사용 
3. 2가지 종류
  묵시적(implicit cursor) == 암시적 == 자동 == 하나의 결과 
  명시적(explicit cursor)
  CURSOR 선언 : SELECT 문 작성 
  OPEN : 선언된 SELECT 문 실행
  FETCH : 실행된 하나의 결과물을 읽어온다.
          여러개의 결과 시 반복문 사용 
          %NOTFOUND 커서의 속성 : 커서 행 없는지 유무
          %FOUND      ''       : 커서 행 있는지 유무
          %ISPEN      ''       : 현재 커서 상태 OPEN 인지 반환
          %ROWCOUNT   ''       : 커서에 읽힌 행의 수 
  CLOSE : SELECT 문 종료 
-- 5)익명프로시저 선언 : CURSOR LOOP 사용
DECLARE
 TYPE EmpDeptType IS RECORD
 (deptno NUMBER(2),
  dname  dept.dname%TYPE,
  empno  emp.empno%TYPE,
  ename  emp.ename%TYPE,
  pay NUMBER);
 vderow EmpDeptType;
 CURSOR edcursor IS 
 SELECT d.deptno, dname,empno,ename,sal+nvl(comm,0) pay 
 FROM dept d JOIN emp e ON d.deptno = e.deptno;
BEGIN
 OPEN edcursor;
 IF edcursor%ISOPEN THEN
 DBMS_OUTPUT.PUT_LINE('OPEN');
 ELSE 
 DBMS_OUTPUT.PUT_LINE('CLOSE');
 END IF;
  
 LOOP
 FETCH edcursor INTO vderow;
 DBMS_OUTPUT.PUT_LINE(edcursor%ROWCOUNT);
 DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname 
 || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
 EXIT WHEN edcursor%NOTFOUND;
 END LOOP;
 CLOSE edcursor;
--EXECUTE
END;
-- 6)익명프로시저 선언 : CURSOR  FOR 사용
DECLARE
 TYPE EmpDeptType IS RECORD
 (deptno NUMBER(2),
  dname  dept.dname%TYPE,
  empno  emp.empno%TYPE,
  ename  emp.ename%TYPE,
  pay NUMBER);
 vderow EmpDeptType;
 CURSOR edcursor IS 
 SELECT d.deptno, dname,empno,ename,sal+nvl(comm,0) pay 
 FROM dept d JOIN emp e ON d.deptno = e.deptno;
BEGIN
-- FOR 반복변수 IN [REVERSE] 시작값.. 종료값
 FOR vderow IN edcursor
 LOOP
 DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname 
 || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay); 
 END LOOP; 
--EXECUTE
END;
-- 6-2)익명프로시저 선언 : CURSOR  FOR 사용
DECLARE
BEGIN
 FOR vderow IN (
 SELECT d.deptno, dname,empno,ename,sal+nvl(comm,0) pay 
 FROM dept d JOIN emp e ON d.deptno = e.deptno)
 LOOP
 DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname 
 || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay); 
 END LOOP; 
--EXECUTE
END;
---------------------------------------------------------------------
-- 저장 프로시저 ( STORED PROCEDURE )
--1) PL/SQL의 가장 대표적인 구조 
--2) 데이터베이스 객체 저장
--3) 형식
CREATE OR REPLACE PROCEDURE up_프로시저명
(
 -- 매개변수(arguement, parmter),인자 p 접두사 
)
IS
-- 선언 블럭 : 번수 선언  v 접두사
BEGIN
-- 실행 블럭
EXCEPTION
-- 예외 처리 블럭
END;
-- 4) 저장 프로시저를 실행하는 3가지 방법
   (1) EXECUTE[UTE]
   (2) 익명 프로시저 안에서 실행
   (3) 또 다른 저장 프로시저 안에서 실행
-- 실습)
CREATE TABLE tbl_emp
AS
SELECT * FROM emp;
-- 1) 개발자가 자주 실행하는 업무 -> 저장 프로시저
-- 가정) 사원번호를 입력받아서 해당 사원을 삭제하는 업무

DELETE FROM tbl_emp
WHERE empno = 7369;
commit;
--
CREATE OR REPLACE PROCEDURE up_delEmp
-- 저장 프로시저의 파라미터 선언 시 자료형의 크기 X
--    ''                         콤마 연산자 
(
--pempno NUMBER
--pempno 파라미터모드 emp.empno%TYPE
--      IN,OUT,INOUT
pempno IN emp.empno%TYPE
)
IS
BEGIN
 DELETE FROM tbl_emp
WHERE empno = pempno;
commit;
--EXCEPTION
--예외처리
END;
--Procedure UP_DELEMP이(가) 컴파일되었습니다.
--(1)EXECUTE 문
EXEC UP_DELEMP(pempno=>7369);
EXEC UP_DELEMP(7934);
SELECT *
FROM tbl_emp;
(2) 익명 프로시저 안에서 저장 프로시저 실행.
--DECLARE
BEGIN
 UP_DELEMP(7902);
--EXCEPTION
END;
(3) 또 다른 저장 프로시저 안에서 저장 프로시저 실행.
CREATE OR REPLACE PROCEDURE up_delemp_test
IS
BEGIN
 UP_DELEMP(7900);
END;
EXEC up_delemp_test;

-- 문제 
-- 1) dept 복사 tbl_dept 생성 
CREATE TABLE tbl_dept
AS
SELECT * FROM dept;
-- 2) 부서명,지역명을 입력받아서 새로운 부서를 추가하는 저장 프로시저 생성 up_insertdept
CREATE OR REPLACE PROCEDURE up_insertdept
(pdname  VARCHAR2,
 ploc  VARCHAR2)
IS
 vdeptno tbl_dept.deptno%TYPE;
BEGIN
 SELECT MAX(deptno) INTO vdeptno
 FROM tbl_dept;
 vdeptno := vdeptno +10;
 INSERT INTO tbl_dept
 (deptno,dname,loc)VALUES(vdeptno,pdname,ploc);
END;
-- 3) 실행 테스트 
exec up_insertdept('QC','SEOIL');
exec up_insertdept(pdname=>'QC',ploc=>'SEOIL');
exec up_insertdept(ploc=>'SEOIL',pdname=>'QC');
SELECT * FROM tbl_dept;
--
CREATE SEQUENCE seq_tbldept
INCREMENT BY 10
START WITH 50
MAXVALUE 90
NOCYCLE 
NOCACHE;
--
CREATE OR REPLACE PROCEDURE up_insertdept
(pdname  VARCHAR2 := NULL,
 ploc  VARCHAR2 DEFAULT NULL)
IS
BEGIN 
 INSERT INTO tbl_dept
 VALUES(seq_tbldept.NEXTVAL,pdname,ploc);
END;
-- 부서명O , 지역명 X
exec up_insertdept('QC2');
exec up_insertdept('QC2',NULL);
exec up_insertdept(pdname=>'QC4');
-- 부서명X , 지역명 O
exec up_insertdept(NULL,'POHANG');
exec up_insertdept(ploc=>'POHANG');
SELECT * FROM tbl_Dept;
-- 문제 tbl_dept 수정 : up_updatedept
-- 1) 수정할 부서번호 
-- 2) 부서명만 수정
-- 3) 지역명만 수정
-- 4) 부서명,지역명 수정
CREATE OR REPLACE PROCEDURE up_updatedept
(pdeptno NUMBER,
 pdname  VARCHAR2 := NULL,
 ploc  VARCHAR2 DEFAULT NULL)
IS
BEGIN 
IF ploc = NULL THEN
 UPDATE tbl_dept
 SET dname = pdname
 WHERE deptno = pdeptno;
 ELSIF pdname = NULL THEN
 UPDATE tbl_dept
 SET loc = ploc
 WHERE deptno = pdeptno;
 ELSE
 UPDATE tbl_dept
 SET dname = pdname,
     loc   = ploc
 WHERE deptno = pdeptno;
 END IF;
 COMMIT;
END;
EXEC up_updatedept(50,'X','Y');
EXEC up_updatedept(pdeptno=>50,pdname=>'QC5');
EXEC up_updatedept(pdeptno=>50,ploc=>'SEOUL2');
EXEC up_updatedept(50,'SM','PO');
SELECT * FROM tbl_dept;
-- 강사님 풀이
CREATE OR REPLACE PROCEDURE up_updatedept
(pdeptno dept.deptno%TYPE,
 pdname  dept.dname%TYPE := NULL,
 ploc    dept.loc%TYPE DEFAULT NULL)
IS
 vdname dept.dname%TYPE;
 vloc   dept.loc%TYPE; 
BEGIN 
 SELECT dname,loc INTO vdname,vloc
 FROM tbl_dept
 WHERE dept = pdeptno;
IF pdname iS NULL AND ploc IS NULL THEN
  UPDATE tbl_dept
 SET loc = vloc,
     dname = vdname
 WHERE deptno = pdeptno; 
ELSIF pdname iS NULL THEN
 UPDATE tbl_dept
 SET loc = ploc,
     dname = vdname
 WHERE deptno = pdeptno;
ELSIF ploc IS NULL THEN
 UPDATE tbl_dept
 SET loc = vloc,
     dname = pdname
 WHERE deptno = pdeptno;
 ELSE
 UPDATE tbl_dept
 SET dname = pdname,
     loc   = ploc
 WHERE deptno = pdeptno;
 END IF;
 COMMIT;
END;
-- 강사님풀이 2 
CREATE OR REPLACE PROCEDURE up_updatedept
(pdeptno dept.deptno%TYPE,
 pdname  dept.dname%TYPE := NULL,
 ploc    dept.loc%TYPE DEFAULT NULL)
IS
BEGIN 
  UPDATE tbl_dept
 SET dname = NVL(pdname,dname),
     loc = CASE 
           WHEN ploc IS NULL THEN loc
           ELSE ploc
           END     
 WHERE deptno = pdeptno; 
 COMMIT;
END;
EXEC up_updatedept(50);
EXEC up_updatedept(50,'X','Y');
EXEC up_updatedept(pdeptno=>50,pdname=>'QC5');
EXEC up_updatedept(pdeptno=>50,ploc=>'SEOUL2');
EXEC up_updatedept(50,'SM','PO');
EXEC up_updatedept(100); -- 예외처리가 없기에 없는자료도 성공햇다 나온다.
SELECT * FROM tbl_dept;

-- 문제 tbl_emp 부서번호를 입력받아서 해당 부서원들의 정보를 출력하는 저장프로시저
-- up_selectemp
CREATE OR REPLACE PROCEDURE up_selectemp
(pdeptno tbl_emp.deptno%TYPE)
IS
 TYPE EmpType IS RECORD
 (empno  tbl_emp.empno%TYPE,
  ename  tbl_emp.ename%TYPE,
  job tbl_emp.job%TYPE,
  mgr tbl_emp.mgr%TYPE,
  hiredate tbl_emp.hiredate%TYPE,
  sal tbl_emp.sal%TYPE,
  comm tbl_emp.comm%TYPE,
  deptno tbl_emp.deptno%TYPE);
 verow EmpType;
 CURSOR empcursor IS
 SELECT empno,ename,job,mgr,hiredate,sal,comm,deptno
 FROM tbl_emp WHERE deptno = pdeptno;
BEGIN 
OPEN empcursor;
LOOP
FETCH empcursor INTO verow;
EXIT WHEN empcursor%NOTFOUND;
DBMS_OUTPUT.PUT_LINE(verow.deptno||', '||verow.empno || ', ' || verow.ename 
 || ', ' || verow.job || ', ' || verow.mgr || ', ' || verow.hiredate
 || ', ' || verow.sal || ', ' || verow.comm
 );
END LOOP;
--EXCEPTION
CLOSE empcursor;
END;
exec up_selectemp(30);
-- 강사님 풀이
CREATE OR REPLACE PROCEDURE up_selectemp
(pdeptno tbl_emp.deptno%TYPE := NULL)
IS
 vdeptno tbl_emp.deptno%TYPE;
 vename tbl_emp.ename%TYPE;
 vhiredate tbl_emp.hiredate%TYPE;
 CURSOR curemp IS ( SELECT deptno, ename, hiredate FROM tbl_emp
 WHERE deptno = nvl(pdeptno,10));
BEGIN 
OPEN curemp;
LOOP
FETCH curemp INTO vdeptno,vename,vhiredate;
DBMS_OUTPUT.PUT_LINE(vdeptno||', '||vename||', '||vhiredate);
EXIT WHEN curemp%NOTFOUND;
END LOOP;
--EXCEPTION
CLOSE curemp;
END;
-------- 커서 파라미터 이용방법------------------
CREATE OR REPLACE PROCEDURE up_selectemp
(pdeptno tbl_emp.deptno%TYPE := 10)
IS
 vdeptno tbl_emp.deptno%TYPE;
 vename tbl_emp.ename%TYPE;
 vhiredate tbl_emp.hiredate%TYPE;
 CURSOR curemp(cpdeptno tbl_emp.deptno%TYPE) IS 
 ( SELECT deptno, ename, hiredate FROM tbl_emp
 WHERE deptno = cpdeptno);
BEGIN 
OPEN curemp(pdeptno);
LOOP
FETCH curemp INTO vdeptno,vename,vhiredate;
DBMS_OUTPUT.PUT_LINE(vdeptno||', '||vename||', '||vhiredate);
EXIT WHEN curemp%NOTFOUND;
END LOOP;
--EXCEPTION
CLOSE curemp;
END;
-------- 커서 FOR ------------------
CREATE OR REPLACE PROCEDURE up_selectemp
(pdeptno tbl_emp.deptno%TYPE := 10)
IS
BEGIN 
FOR erow IN (SELECT deptno, ename, hiredate FROM tbl_emp
       WHERE deptno = pdeptno)
LOOP
DBMS_OUTPUT.PUT_LINE(erow.deptno||', '||erow.ename||', '||erow.hiredate);
END LOOP;
--EXCEPTION
END;
-- 출력용 (OUT) 매개변수만 저장 프로시저에서 사용
SELECT num,ssn
FROM insa;
-- IN num
-- OUT rrn 770830-1022432 > 770830-1******
CREATE OR REPLACE PROCEDURE up_insarrn
(pnum IN insa.num%TYPE
,pname OUT insa.name%TYPE
,prrn OUT VARCHAR2)
IS
vrrn insa.ssn%TYPE;
vname insa.name%TYPE;
BEGIN
SELECT ssn,name INTO vrrn ,vname
FROM insa
WHERE num = pnum;
prrn := SUBSTR(vrrn,1,8)||'******';
pname := vname;
--EXCEPTION
END;
-- 출력용 매개변수 테스트 ( 익명 프로시저 )
DECLARE
 vrrn insa.ssn%TYPE;
 vname insa.name%TYPE;
BEGIN
up_insarrn(1001,vname,vrrn);
DBMS_OUTPUT.PUT_LINE(vname||', '||vrrn);
--EXCEPTION
END;
-- 입출력용 INOUT 매개변수를 사용하는 저장 프로시저
-- 주민등록번호 14자리를 입력용 매개변수 > 앞6자리만 출력 
CREATE OR REPLACE PROCEDURE up_rrn
(prrn IN OUT VARCHAR2
)
IS
BEGIN
 prrn := SUBSTR(prrn,1,6);
--EXCEPTION
END;
DECLARE
 vrrn VARCHAR2(14) := '770830-1234567';
BEGIN
 UP_RRN(vrrn);
 DBMS_OUTPUT.PUT_LINE(vrrn);
--EXCEPTION
END;
------- 오후
--1) 저장 프로시저 연습 문제
--2) 저장 함수( STORED FUNCTION)
------ 내일
--3) 트리거, 예외처리, 패키지
--4) 동적쿼리
CREATE TABLE tbl_score(
 num NUMBER(4) PRIMARY KEY
,name VARCHAR2(20)
,kor NUMBER(3)
,eng NUMBER(3)
,mat NUMBER(3)
,tot NUMBER(3)
,avg NUMBER(5,2)
,rank NUMBER(4)
,grade CHAR(1 CHAR)
);
--Table TBL_SCORE이(가) 생성되었습니다.
-- 번호,이름,국,영,수 > 파라미터 
CREATE OR REPLACE PROCEDURE up_insertscore
(pnum NUMBER
,pname VARCHAR2
,pkor NUMBER
,peng NUMBER
,pmat NUMBER
)
IS
 vtot NUMBER(3);
 vavg NUMBER(5,2);
 vrank NUMBER(4);
 vgrade CHAR(1 CHAR);
BEGIN
 vtot := pkor + peng + pmat;
 vavg := vtot/3;
-- vrank := (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > vtot);
 IF vavg >= 90 THEN
 vgrade := 'A';
 ELSIF vavg >= 80 THEN
 vgrade := 'B';
 ELSIF vavg >= 70 THEN
 vgrade := 'C';
 ELSIF vavg >= 60 THEN
 vgrade := 'D';
 ELSE vgrade := 'F';
 END IF;
 INSERT INTO tbl_score
 VALUES(pnum,pname,pkor,peng,pmat,vtot,vavg,vrank,vgrade);
 -- 한 사람이 추가 될때마다 모든 학생 등수를 다시 매김
 UPDATE tbl_score a
 set rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot>a.tot);
 commit;
--EXCEPTION
END;
EXEC up_insertscore(1001,'홍길동',89,44,55);
EXEC up_insertscore(1002,'홍길동2',49,85,45);
EXEC up_insertscore(1003,'홍길동3',59,90,76);
EXEC up_insertscore(1004,'홍길동4',100,90,13);
EXEC up_insertscore(1005,'홍길동5',100,90,56);

SELECT * FROM tbl_score;
----
CREATE OR REPLACE PROCEDURE UP_UDPTBLSCORE
(pnum NUMBER
,pkor NUMBER := NULL
,peng NUMBER := NULL
,pmat NUMBER := NULL)
IS
 vtot NUMBER(3);
 vavg NUMBER(5,2);
 vrank NUMBER(4);
 vgrade CHAR(1 CHAR);
 vkor NUMBER(3);
 veng NUMBER(3);
 vmat NUMBER(3);
BEGIN
 SELECT kor,eng,mat INTO vkor,veng,vmat
 FROM tbl_score
 WHERE num = pnum;
  vtot := NVL(pkor,vkor) + nvl(peng,veng) + nvl(pmat,vmat);
 vavg := vtot/3;
  IF vavg >= 90 THEN
 vgrade := 'A';
 ELSIF vavg >= 80 THEN
 vgrade := 'B';
 ELSIF vavg >= 70 THEN
 vgrade := 'C';
 ELSIF vavg >= 60 THEN
 vgrade := 'D';
 ELSE vgrade := 'F';
 END IF;
UPDATE tbl_score
SET kor = nvl(pkor,kor)
   ,eng = nvl(peng,eng)
   ,mat = nvl(pmat,mat)
   ,tot = vtot
   ,avg = vavg
   ,grade = vgrade
WHERE num = pnum;
 UPDATE tbl_score a
 set rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot>a.tot);
 commit;
--EXCEPTION
END;
-- 한 학생 수정시 총/평/등 수정 및 전체학생 등수 처리 
EXEC UP_UDPTBLSCORE( 1001, 100, 100, 100 );
EXEC UP_UDPTBLSCORE( 1001, pkor =>34 );
EXEC UP_UDPTBLSCORE( 1001, pkor =>34, pmat => 90 );
EXEC UP_UDPTBLSCORE( 1001, peng =>45, pmat => 90 );
SELECT * FROM tbl_score;
-- 문제 EXEC UP_DELETESCORE(1002); 학번으로 삭제 후 모든 학생 등수 다시 매김
CREATE OR REPLACE PROCEDURE UP_DELETESCORE
(pnum NUMBER)
IS
 vtot NUMBER(3);
 vavg NUMBER(5,2);
 vrank NUMBER(4);
BEGIN
 DELETE FROM tbl_score
 WHERE num = pnum;
 UPDATE tbl_score a
 set rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot>a.tot);
 commit;
END;
EXEC UP_DELETESCORE(1002);
SELECT * FROM tbl_score;
-- 문제 EXEC UP_SELECTSCORE; -- 모든 학생 정보 출력 (DBMS_OUTPUT.PUT_LINE)
CREATE OR REPLACE PROCEDURE UP_SELECTSCORE
IS
 vnum NUMBER(4);
 vname VARCHAR2(20);
 vkor NUMBER(3);
 veng NUMBER(3);
 vmat NUMBER(3);
 vtot NUMBER(3);
 vavg NUMBER(5,2);
 vrank NUMBER(4);
 vgrade CHAR(1 CHAR); 
 CURSOR curscore IS ( 
 SELECT num,name,kor,eng,mat,tot,avg,rank,grade 
 FROM tbl_score);
BEGIN 
OPEN curscore;
LOOP
FETCH curscore INTO vnum,vname,vkor,veng,vmat,vtot,vavg,vrank,vgrade;
DBMS_OUTPUT.PUT_LINE(vnum||', '||vname||', '||vkor||', '||veng
||', '||vmat||', '||vtot||', '||vavg||', '||vrank||', '||vgrade
);
EXIT WHEN curscore%NOTFOUND;
END LOOP;
--EXCEPTION
CLOSE curscore;
END;

DECLARE
vnum NUMBER(4);
 vname VARCHAR2(20);
 vkor NUMBER(3);
 veng NUMBER(3);
 vmat NUMBER(3);
 vtot NUMBER(3);
 vavg NUMBER(5,2);
 vrank NUMBER(4);
 vgrade CHAR(1 CHAR); 
BEGIN
UP_SELECTSCORE;
DBMS_OUTPUT.PUT_LINE(vnum||', '||vname||', '||vkor||', '||veng
||', '||vmat||', '||vtot||', '||vavg||', '||vrank||', '||vgrade
);
--EXCEPTION
END;
-----------------------------------------------------
CREATE OR REPLACE FUNCTION UF_SELECTSCORE
()
RETURN 리턴자료형;
IS
BEGIN
RETURN 리턴값;
--EXCEPTION
END;
SELECT num,name,ssn
,DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'남자','여자') 성별
,scott.uf_gender(ssn)
,uf_age(ssn)
FROM insa;
-- 저장 함수 stored function 
CREATE or replace function uf_gender
(prrn VARCHAR2)
RETURN VARCHAR2
IS
 vgender VARCHAR2(6);
BEGIN
IF MOD(SUBSTR(prrn,-7,1),2) = 1 THEN vgender:='남자';
ELSE vgender:='여자';
END IF;
RETURN vgender;
--EXCEPTION
END;
CREATE or replace function uf_age
(prrn VARCHAR2)
RETURN VARCHAR2
IS
 vage VARCHAR2(6);
 vsys VARCHAR2(20);
BEGIN
IF substr(prrn,-7,1) in(1,2,5,6) THEN vsys := to_char(substr(prrn,1,2),'0099')+1900;
ELSIF substr(prrn,-7,1) in(3,4,7,8) THEN vsys := to_char(substr(prrn,1,2),'0099')+2000 ;
END IF;
CASE SIGN(to_char(sysdate,'mmdd')-substr(prrn,3,4))
WHEN -1 THEN vage := to_char(SYSDATE,'YYYY') - vsys-1;
ELSE vage := to_char(SYSDATE,'YYYY') - vsys;
END CASE;
RETURN vage;
--EXCEPTION
END;
-- 강사님 풀이
CREATE OR REPLACE FUNCTION UF_AGE
   ( 
       prrn VARCHAR2
       , ca NUMBER
   )
   RETURN NUMBER
   IS
     ㄱ NUMBER(4); -- 올해 년도 2023
     ㄴ NUMBER(4); -- 생일 년도
     ㄷ NUMBER(1); -- 생일 지남 여부 -1 0 1 
     vcounting_age NUMBER(3);
     vamerican_age NUMBER(3);
   BEGIN     
      ㄱ := TO_CHAR( SYSDATE, 'YYYY' ); 
      ㄴ := SUBSTR( prrn, 0, 2 ) + CASE
                                    WHEN SUBSTR( prrn, -7, 1 ) IN (1,2,5,6) THEN 1900
                                    WHEN SUBSTR( prrn, -7, 1 ) IN (3,4,7,8) THEN 2000
                                    WHEN SUBSTR( prrn, -7, 1 ) IN (9,0) THEN 1800
                                   END;
      ㄷ := SIGN( TO_CHAR( SYSDATE, 'MMDD' ) - SUBSTR( prrn, 3, 4 ) );
      
      vcounting_age :=  ㄱ - ㄴ + 1 ;
      -- 오류(95,36): PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
      -- vamerican_age := ㄱ - ㄴ + DECODE( ㄷ, -1, -1, 0 ) ;  -- PL/SQL에서는 사용할 수 없다.
      vamerican_age := ㄱ - ㄴ + CASE  ㄷ
                                     WHEN -1 THEN -1  
                                     ELSE 0
                                 END;  
      
      IF ca = 1 THEN
         RETURN vcounting_age;
      ELSE
         RETURN vamerican_age;
      END IF;   
   -- EXCEPTION
   END;
-- 문제 주민등록번호로 부터 생년월일 (1998.01.20(화) ) 반환하는 함수 생성 후 테스트
-- uf_birth
CREATE OR REPLACE FUNCTION uf_birth
(prrn VARCHAR2)
RETURN VARCHAR2
IS
 vbirth VARCHAR2(20); 
 vcentry NUMBER(2); --세기
BEGIN
 vbirth := SUBSTR(prrn,1,6);
 vcentry := CASE
 WHEN SUBSTR(prrn,-7,1) IN (1,2,5,6) THEN 19
 WHEN SUBSTR(prrn,-7,1) IN (3,4,7,8) THEN 20
 ELSE 18
 END;
 vbirth := vcentry || vbirth;
 vbirth := TO_CHAR(TO_DATE(vbirth,'YYYYMMDD'),'YYYY.MM.DD(DY)');
RETURN vbirth;
--EXCEPTION
END;
SELECT num,name,ssn,uf_birth(ssn)
FROM insa;
--
CREATE OR REPLACE PROCEDURE up_selectinsa
(pinsacursor IN SYS_REFCURSOR
)
IS
 vname insa.name%TYPE;
 vcity insa.city%TYPE;
 vbasicpay insa.basicpay%TYPE;
BEGIN
LOOP
FETCH pinsacursor INTO vname,vcity,vbasicpay;
EXIT WHEN pinsacursor%notfound;
DBMS_OUTPUT.PUT_LINE(vname||', '||vcity||', '||vbasicpay);
END LOOP;
--EXCEPTION
END;
-- 위 up_selectinsa 테스트 위해 다른 프로시저 안에서 커서 생성 후 파라미터 넘겨 테스트
CREATE OR REPLACE PROCEDURE up_selectinsa_test
IS
 vinsacursor SYS_REFCURSOR;
BEGIN
 -- OPEN 커서 FOR 문
 OPEN vinsacursor FOR
 SELECT name,city,basicpay
 FROM insa;
 up_selectinsa(vinsacursor);
 CLOSE vinsacursor;
END;
exec up_selectinsa_test;