-- �𵨸� --
������̺�
�� ������ ���
�� �������� ���

(1) ���� Ÿ�� : ��ü�� �ϳ��� ���̺�� ����

����Ӽ�(Į��)

(2) ���� Ÿ�� : ������,�������� .. ���� Ÿ���� ������ŭ

�������� - �ʿ�����(����)>JDBC>JSP

--�ڵ� �Ϸù�ȣ ����
-- dept ���̺��� deptno �� �������� �����ؼ� ���
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
-- ������ ��� ��ȸ
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
-- ������     ���      Ȯ���        SQL
-- ��� ������ �� ���
-- ����)
[DECLARE]
 1) ���� ��
BEGIN
 2) ���� ��
[EXCEPTION]
 3) ���� ó�� ��
END
--PL/SQL �� 6���� ���� 
1) �͸� ���ν���
2) ���� ���ν��� ***
3) ���� �Լ�
4) ��Ű��
5) Ʈ����
--6) ��ü X
desc insa;
--��) �͸� ���ν��� �ۼ�
���� ���� �Ҵ��ϴ� ���
1) :=
2) SELECT, FETCH �� : INTO��
DECLARE
-- �Ϲݺ��� v , �Ű����� p
-- ���� �� : ���� ����
-- vname VARCHAR2(20);
-- vpay NUMBER(10);
 vname INSA.name%TYPE := '�͸�'; --Ÿ���� ����
 vpay NUMBER(10) := 0;
 vpi CONSTANT NUMBER := 3.141592;
 vmessage VARCHAR2(100);
BEGIN
 SELECT name, basicpay +sudang
 INTO vname,vpay
 FROM insa
 WHERE num =1001;
-- DBMS_OUTPUT.PUT_LINE('�����=' || vname);
-- DBMS_OUTPUT.PUT_LINE('�޿���=' || vpay);
vmessage := vname || ', ' || vpay;
DBMS_OUTPUT.PUT_LINE('��� : ' || vmessage);
--EXCEPTION
END;
-- ���� 30�� �μ��� �������� ���ͼ�
-- 10�� �μ��� ���������� ����  ( �͸����ν��� �ۼ�)
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
-- ���� 10�� �μ��� �߿� �ְ�sal�� �޴� ����� ���� ��ȸ
--1) TOP-N
SELECT *
FROM(
SELECT *
FROM emp
WHERE deptno=10
ORDER BY sal desc
)
WHERE rownum=1;
-- 2) RANK �Լ� 
SELECT *
FROM(
SELECT e.*
 ,RANK() OVER(ORDER BY sal desc) sal_rank
FROM emp e
WHERE deptno = 10
)
WHERE sal_rank = 1;
-- 3) ��������
SELECT *
FROM emp
WHERE deptno = 10 AND sal = (
SELECT max(sal)
FROM emp
WHERE deptno=10
);
-- 4) �͸� ���ν��� ����ؼ� ó��.
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
DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || vempno);
DBMS_OUTPUT.PUT_LINE('����� : ' || vename);
DBMS_OUTPUT.PUT_LINE('�Ի����� : ' || vhiredate);
--EXCEPTION
END;
-- 4-2) �͸� ���ν��� ����ؼ� ó��.
DECLARE
 vmax_sal_10 emp.sal%type; -- Ÿ���� ���� ����
 vrow emp%ROWTYPE; -- ���ڵ��� ���� ����
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
DBMS_OUTPUT.PUT_LINE('�����ȣ : ' || vrow.empno);
DBMS_OUTPUT.PUT_LINE('����� : ' || vrow.ename);
DBMS_OUTPUT.PUT_LINE('�Ի����� : ' || vrow.hiredate);
--EXCEPTION
END;
-- PL/SQL���� �������� ���ڵ带 �����ͼ� ó���ϱ� ���ؼ���  
-- �ݵ�� Ŀ��(cursor)�� ����ؾ� �Ѵ�.
-- ORA-01422: exact fetch returns more than requested number of rows
DECLARE
 vname INSA.name%TYPE := '�͸�';
 vpay NUMBER(10) := 0;
 vpi CONSTANT NUMBER := 3.141592;
 vmessage VARCHAR2(100);
BEGIN
 SELECT name, basicpay +sudang
 INTO vname,vpay
 FROM insa;
vmessage := vname || ', ' || vpay;
DBMS_OUTPUT.PUT_LINE('��� : ' || vmessage);
--EXCEPTION
END;

-- �ڹ�)
if(���ǽ�){
}

if(���ǽ�){
}ELSE{
}

if(���ǽ�){
}ELSE IF(���ǽ�){
}ELSE IF(���ǽ�){
}ELSE IF(���ǽ�){
}ELSE{
}
--PL/SQL
IF (���ǽ�) THEN
END IF;

IF (���ǽ�) THEN
ELSE
END IF;

IF (���ǽ�) THEN
ELSIF(���ǽ�) THEN
ELSIF(���ǽ�) THEN
ELSIF(���ǽ�) THEN
ELSE
END IF;

-- ����) ������ �ϳ� �����ؼ� ������ �Է¹޾� ¦��,Ȧ�� ���
--ORA-06502: PL/SQL: numeric or value error: character string buffer too small
DECLARE
 vnum NUMBER(4) := 0;
 vresult VARCHAR2(6) := 'Ȧ��';
BEGIN
 vnum := :bindNumber;
 IF mod(vnum,2)=0 THEN vresult := '¦��';
-- ELSE vresult := 'Ȧ��';
 END IF;
 DBMS_OUTPUT.PUT_LINE( vnum || ' ' || vresult );
--EXCEPTION
END;

-- ���� �������� �Է¹޾Ƽ� ��-�� ���
DECLARE
 vkor NUMBER(3) := 0;
 vgrade VARCHAR2(3) := '��';
BEGIN
 vkor := :bindNumber;
 IF (vkor BETWEEN 0 AND 100) THEN 
 IF vkor >= 90 THEN vgrade := '��';
 ELSIF vkor >= 80 THEN vgrade := '��';
 ELSIF vkor >= 70 THEN vgrade := '��';
 ELSIF vkor >= 60 THEN  vgrade := '��';
 END IF;
 END IF;
 DBMS_OUTPUT.PUT_LINE( vkor || ' ' || vgrade );
--EXCEPTION
END;
--
DECLARE
 vkor NUMBER(3) := 0;
 vgrade VARCHAR2(3) := '��';
BEGIN
 vkor := :bindNumber;
 IF (vkor BETWEEN 0 AND 100) THEN 
 CASE TRUNC( vkor/10 )
 WHEN 10 THEN vgrade := '��';
 WHEN 9 THEN vgrade := '��';
 WHEN 8 THEN vgrade := '��';
 WHEN 7 THEN vgrade := '��';
 WHEN 6 THEN vgrade := '��';
 END CASE;
 END IF;
 DBMS_OUTPUT.PUT_LINE( vkor || ' ' || vgrade );
--EXCEPTION
END;

--LOOP...END LOOP;(�ܼ� �ݺ�) ��
JAVA
While(true){
  //���ѷ���
  if(����) break;
}
Oracle
LOOP 
--
--
EXIT WHEN ����
END LOOP;
�� 1~10=55
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
-- WHILE...LOOP(������ �ݺ�) ��
JAVA
while(���ǽ�){
}
Oracle
WHile(���ǽ�)
LOOP
--
END LOOP;
�� 1~10 =55
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
-- FOR...LOOP(������ �ݺ�) ��
JAVA 
for(int i=1 �ʱ��; i<=10 ���ǽ�; i++ ������){}
Oracle
FOR �ݺ�����(i) IN [REVERSE] ���۰�.. ����
LOOP
 -- �ݺ�ó������
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

--GOTO��--
--DECLARE
BEGIN
GOTO first_proc;
<<second_proc>>
DBMS_OUTPUT.PUT_LINE('>  2 ó�� ');
GOTO third_proc;
<<first_proc>>
DBMS_OUTPUT.PUT_LINE('>  1 ó�� ');
GOTO second_proc;
<<third_proc>>
DBMS_OUTPUT.PUT_LINE('>  3 ó�� ');
--EXCEPTION
END;

-- ������(2~9) ���
1) While LOOP ~ end loop ��� *2
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
-- ����� Ǯ��
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
2) for LOOP ~ END LOOP ��� *2
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