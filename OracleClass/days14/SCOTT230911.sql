-- 1)�͸����ν��� ���� : %TYPE �� ����
DECLARE
 vdeptno NUMBER(2);
 vdname dept.dname%TYPE;
 vempno emp.empno%TYPE;
 vename emp.ename%TYPE;
 vpay NUMBER;
BEGIN
-- ������ Ŀ�� 
SELECT d.deptno, dname,empno,ename,sal+nvl(comm,0) pay
 INTO vdeptno,vdname,vempno,vename,vpay
 FROM dept d JOIN emp e ON d.deptno = e.deptno
 WHERE empno = 7369;
 DBMS_OUTPUT.PUT_LINE(vdeptno || ', ' || vdname 
 || ', ' || vempno || ', ' || vename || ', ' || vpay);
--EXECUTE
END;
-- 2)�͸����ν��� ���� : %ROWTYPE �� ����
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
-- 3)�͸����ν��� ���� : RECORD �� ���� 
DECLARE
 -- ����� ���� ����ü Ÿ�� ���� 
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
-- 4)�͸����ν��� ���� : RECORD �� ����  
--ORA-01422: exact fetch returns more than requested number of rows
-- Ŀ��(CURSOR)�� ����ؼ� fatch ó�� 
DECLARE
 -- ����� ���� ����ü Ÿ�� ���� 
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
 -- ������ ����
 DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname 
 || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay);
--EXECUTE
END;
-----------------------------------------------------------------------------
-- CURSOR Ŀ�� 
1. PL/SQL �� ������ ����Ǵ� SELECT ��
2. ���� ���ڵ�� ������ �۾��������� SQL���� �����ϰ� �� ����� �����ϱ� ���� ��� 
3. 2���� ����
  ������(implicit cursor) == �Ͻ��� == �ڵ� == �ϳ��� ��� 
  �����(explicit cursor)
  CURSOR ���� : SELECT �� �ۼ� 
  OPEN : ����� SELECT �� ����
  FETCH : ����� �ϳ��� ������� �о�´�.
          �������� ��� �� �ݺ��� ��� 
          %NOTFOUND Ŀ���� �Ӽ� : Ŀ�� �� ������ ����
          %FOUND      ''       : Ŀ�� �� �ִ��� ����
          %ISPEN      ''       : ���� Ŀ�� ���� OPEN ���� ��ȯ
          %ROWCOUNT   ''       : Ŀ���� ���� ���� �� 
  CLOSE : SELECT �� ���� 
-- 5)�͸����ν��� ���� : CURSOR LOOP ���
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
-- 6)�͸����ν��� ���� : CURSOR  FOR ���
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
-- FOR �ݺ����� IN [REVERSE] ���۰�.. ���ᰪ
 FOR vderow IN edcursor
 LOOP
 DBMS_OUTPUT.PUT_LINE(vderow.deptno || ', ' || vderow.dname 
 || ', ' || vderow.empno || ', ' || vderow.ename || ', ' || vderow.pay); 
 END LOOP; 
--EXECUTE
END;
-- 6-2)�͸����ν��� ���� : CURSOR  FOR ���
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
-- ���� ���ν��� ( STORED PROCEDURE )
--1) PL/SQL�� ���� ��ǥ���� ���� 
--2) �����ͺ��̽� ��ü ����
--3) ����
CREATE OR REPLACE PROCEDURE up_���ν�����
(
 -- �Ű�����(arguement, parmter),���� p ���λ� 
)
IS
-- ���� �� : ���� ����  v ���λ�
BEGIN
-- ���� ��
EXCEPTION
-- ���� ó�� ��
END;
-- 4) ���� ���ν����� �����ϴ� 3���� ���
   (1) EXECUTE[UTE]
   (2) �͸� ���ν��� �ȿ��� ����
   (3) �� �ٸ� ���� ���ν��� �ȿ��� ����
-- �ǽ�)
CREATE TABLE tbl_emp
AS
SELECT * FROM emp;
-- 1) �����ڰ� ���� �����ϴ� ���� -> ���� ���ν���
-- ����) �����ȣ�� �Է¹޾Ƽ� �ش� ����� �����ϴ� ����

DELETE FROM tbl_emp
WHERE empno = 7369;
commit;
--
CREATE OR REPLACE PROCEDURE up_delEmp
-- ���� ���ν����� �Ķ���� ���� �� �ڷ����� ũ�� X
--    ''                         �޸� ������ 
(
--pempno NUMBER
--pempno �Ķ���͸�� emp.empno%TYPE
--      IN,OUT,INOUT
pempno IN emp.empno%TYPE
)
IS
BEGIN
 DELETE FROM tbl_emp
WHERE empno = pempno;
commit;
--EXCEPTION
--����ó��
END;
--Procedure UP_DELEMP��(��) �����ϵǾ����ϴ�.
--(1)EXECUTE ��
EXEC UP_DELEMP(pempno=>7369);
EXEC UP_DELEMP(7934);
SELECT *
FROM tbl_emp;
(2) �͸� ���ν��� �ȿ��� ���� ���ν��� ����.
--DECLARE
BEGIN
 UP_DELEMP(7902);
--EXCEPTION
END;
(3) �� �ٸ� ���� ���ν��� �ȿ��� ���� ���ν��� ����.
CREATE OR REPLACE PROCEDURE up_delemp_test
IS
BEGIN
 UP_DELEMP(7900);
END;
EXEC up_delemp_test;

-- ���� 
-- 1) dept ���� tbl_dept ���� 
CREATE TABLE tbl_dept
AS
SELECT * FROM dept;
-- 2) �μ���,�������� �Է¹޾Ƽ� ���ο� �μ��� �߰��ϴ� ���� ���ν��� ���� up_insertdept
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
-- 3) ���� �׽�Ʈ 
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
-- �μ���O , ������ X
exec up_insertdept('QC2');
exec up_insertdept('QC2',NULL);
exec up_insertdept(pdname=>'QC4');
-- �μ���X , ������ O
exec up_insertdept(NULL,'POHANG');
exec up_insertdept(ploc=>'POHANG');
SELECT * FROM tbl_Dept;
-- ���� tbl_dept ���� : up_updatedept
-- 1) ������ �μ���ȣ 
-- 2) �μ��� ����
-- 3) ������ ����
-- 4) �μ���,������ ����
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
-- ����� Ǯ��
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
-- �����Ǯ�� 2 
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
EXEC up_updatedept(100); -- ����ó���� ���⿡ �����ڷᵵ �����޴� ���´�.
SELECT * FROM tbl_dept;

-- ���� tbl_emp �μ���ȣ�� �Է¹޾Ƽ� �ش� �μ������� ������ ����ϴ� �������ν���
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
-- ����� Ǯ��
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
-------- Ŀ�� �Ķ���� �̿���------------------
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
-------- Ŀ�� FOR ------------------
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
-- ��¿� (OUT) �Ű������� ���� ���ν������� ���
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
-- ��¿� �Ű����� �׽�Ʈ ( �͸� ���ν��� )
DECLARE
 vrrn insa.ssn%TYPE;
 vname insa.name%TYPE;
BEGIN
up_insarrn(1001,vname,vrrn);
DBMS_OUTPUT.PUT_LINE(vname||', '||vrrn);
--EXCEPTION
END;
-- ����¿� INOUT �Ű������� ����ϴ� ���� ���ν���
-- �ֹε�Ϲ�ȣ 14�ڸ��� �Է¿� �Ű����� > ��6�ڸ��� ��� 
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
------- ����
--1) ���� ���ν��� ���� ����
--2) ���� �Լ�( STORED FUNCTION)
------ ����
--3) Ʈ����, ����ó��, ��Ű��
--4) ��������
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
--Table TBL_SCORE��(��) �����Ǿ����ϴ�.
-- ��ȣ,�̸�,��,��,�� > �Ķ���� 
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
 -- �� ����� �߰� �ɶ����� ��� �л� ����� �ٽ� �ű�
 UPDATE tbl_score a
 set rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot>a.tot);
 commit;
--EXCEPTION
END;
EXEC up_insertscore(1001,'ȫ�浿',89,44,55);
EXEC up_insertscore(1002,'ȫ�浿2',49,85,45);
EXEC up_insertscore(1003,'ȫ�浿3',59,90,76);
EXEC up_insertscore(1004,'ȫ�浿4',100,90,13);
EXEC up_insertscore(1005,'ȫ�浿5',100,90,56);

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
-- �� �л� ������ ��/��/�� ���� �� ��ü�л� ��� ó�� 
EXEC UP_UDPTBLSCORE( 1001, 100, 100, 100 );
EXEC UP_UDPTBLSCORE( 1001, pkor =>34 );
EXEC UP_UDPTBLSCORE( 1001, pkor =>34, pmat => 90 );
EXEC UP_UDPTBLSCORE( 1001, peng =>45, pmat => 90 );
SELECT * FROM tbl_score;
-- ���� EXEC UP_DELETESCORE(1002); �й����� ���� �� ��� �л� ��� �ٽ� �ű�
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
-- ���� EXEC UP_SELECTSCORE; -- ��� �л� ���� ��� (DBMS_OUTPUT.PUT_LINE)
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
RETURN �����ڷ���;
IS
BEGIN
RETURN ���ϰ�;
--EXCEPTION
END;
SELECT num,name,ssn
,DECODE(MOD(SUBSTR(ssn,-7,1),2),1,'����','����') ����
,scott.uf_gender(ssn)
,uf_age(ssn)
FROM insa;
-- ���� �Լ� stored function 
CREATE or replace function uf_gender
(prrn VARCHAR2)
RETURN VARCHAR2
IS
 vgender VARCHAR2(6);
BEGIN
IF MOD(SUBSTR(prrn,-7,1),2) = 1 THEN vgender:='����';
ELSE vgender:='����';
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
-- ����� Ǯ��
CREATE OR REPLACE FUNCTION UF_AGE
   ( 
       prrn VARCHAR2
       , ca NUMBER
   )
   RETURN NUMBER
   IS
     �� NUMBER(4); -- ���� �⵵ 2023
     �� NUMBER(4); -- ���� �⵵
     �� NUMBER(1); -- ���� ���� ���� -1 0 1 
     vcounting_age NUMBER(3);
     vamerican_age NUMBER(3);
   BEGIN     
      �� := TO_CHAR( SYSDATE, 'YYYY' ); 
      �� := SUBSTR( prrn, 0, 2 ) + CASE
                                    WHEN SUBSTR( prrn, -7, 1 ) IN (1,2,5,6) THEN 1900
                                    WHEN SUBSTR( prrn, -7, 1 ) IN (3,4,7,8) THEN 2000
                                    WHEN SUBSTR( prrn, -7, 1 ) IN (9,0) THEN 1800
                                   END;
      �� := SIGN( TO_CHAR( SYSDATE, 'MMDD' ) - SUBSTR( prrn, 3, 4 ) );
      
      vcounting_age :=  �� - �� + 1 ;
      -- ����(95,36): PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
      -- vamerican_age := �� - �� + DECODE( ��, -1, -1, 0 ) ;  -- PL/SQL������ ����� �� ����.
      vamerican_age := �� - �� + CASE  ��
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
-- ���� �ֹε�Ϲ�ȣ�� ���� ������� (1998.01.20(ȭ) ) ��ȯ�ϴ� �Լ� ���� �� �׽�Ʈ
-- uf_birth
CREATE OR REPLACE FUNCTION uf_birth
(prrn VARCHAR2)
RETURN VARCHAR2
IS
 vbirth VARCHAR2(20); 
 vcentry NUMBER(2); --����
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
-- �� up_selectinsa �׽�Ʈ ���� �ٸ� ���ν��� �ȿ��� Ŀ�� ���� �� �Ķ���� �Ѱ� �׽�Ʈ
CREATE OR REPLACE PROCEDURE up_selectinsa_test
IS
 vinsacursor SYS_REFCURSOR;
BEGIN
 -- OPEN Ŀ�� FOR ��
 OPEN vinsacursor FOR
 SELECT name,city,basicpay
 FROM insa;
 up_selectinsa(vinsacursor);
 CLOSE vinsacursor;
END;
exec up_selectinsa_test;