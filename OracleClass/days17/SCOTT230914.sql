-- ���� ���� --
--���� SQL
--���� ? ���� �迭
--int [] m;
--int size = scanner.nextInt();
--m = new int[size];

-- ���� ������ SQL �� ���� ����
1. ���� SQL ����ϴ� 3���� ��Ȳ
 1) ������ �ÿ� SQL������ Ȯ������ ���� ��� ( ���� ���� ��� �Ǵ� ���)
 WHERE ������..
 2) PL/SQL �� �ȿ��� DDL ���� ����ϴ� ��� 
 CREATE,ALTER,DROP
 ��) ���� �� �Խ��� ����
   ������ �÷�  (��¥,����,����)
   üũ�� �÷����� �������� �Խ��� ����.
 3) PL/SQL �� �ȿ���
 ALTER SYSTEM,SESSION ��ɾ ����� ��
2. PL/SQL ���� ������ ����ϴ� ���
 1) NDS(Native Pynamic SQL) ���� ���� ����
  EXEC[UTE] IMMEDIATE ��
  ����)
  EXEC[UTE] IMMEDIATE ����������
  [INTO ������, ������...]
  [USING IN/OUT/IN OUT �Ķ���� ...]
 2) DBMS_SQL ��Ű�� X
 
3. ����
 1) �͸� ���ν��� 
DECLARE
 vsql varchar2(2000);
 vdeptno emp.deptno%type;
 vempno emp.empno%type;
 vename emp.ename%type;
 vjob emp.job%type;
BEGIN
 vsql := 'SELECT deptno,empno,ename,job';
 vsql :=vsql||' FROM emp';
 vsql :=vsql||' WHERE empno=7369';
 
EXECUTE IMMEDIATE vsql
 INTO vdeptno,vempno,vename,vjob; 
 DBMS_OUTPUT.PUT_LINE(vdeptno||', '||vempno||', '||vename||', '||vjob);
--EXCEPTION
END;

-- ���� ���ν���
CREATE OR REPLACE PROCEDURE up_ndsemp
(pempno emp.empno%type)
IS
 vsql varchar2(2000);
 vdeptno emp.deptno%type;
 vempno emp.empno%type;
 vename emp.ename%type;
 vjob emp.job%type;
BEGIN
 vsql := 'SELECT deptno,empno,ename,job';
 vsql :=vsql||' FROM emp';
 vsql :=vsql||' WHERE empno=:pempno';
 
EXECUTE IMMEDIATE vsql
 INTO vdeptno,vempno,vename,vjob
 USING IN pempno; 
 DBMS_OUTPUT.PUT_LINE(vdeptno||', '||vempno||', '||vename||', '||vjob);
--EXCEPTION
END;

exec up_ndsemp(7369);

-- ����) dept ���̺� ���ο� �μ� �߰��ϴ� �������� ��� �������ν���
create or replace procedure up_ndsinsdept
(pdname dept.dname%type := NULL
,ploc dept.loc%type DEFAULT NULL)
is
 vsql varchar2(2000);
begin
 vsql := 'INSERT into dept (deptno,dname,loc)';
 vsql := vsql || ' values(seq_dept.nextval,:pdname,:ploc)';
 
 EXECUTE IMMEDIATE vsql
 using pdname, ploc;
 DBMS_OUTPUT.PUT_LINE('����');
 commit;
--exception
end;

exec up_ndsinsdept('QC','SEOUL');
SELECT *
FROM dept;

-- ����ڰ� ���ϴ� ������ �Խ����� ����( DDL ��) ��������
DECLARE
 vtablename VARCHAR2(100);
 vsql varchar2(2000);
begin
 vtablename := 'tbl_board';
 vsql := 'CREATE table ' || vtablename;
 vsql := vsql||'(id NUMBER PRIMARY KEY ';
 vsql := vsql||' ,name varchar2(20) ) ' ;
 
 DBMS_OUTPUT.PUT_LINE(vsql); 
 
 EXECUTE IMMEDIATE vsql;

end;
desc tbl_board;

-- OPEN - FOR �� : SELECT ���� ���� �� + �ݺ�ó��
   OPEN   Ŀ��
   FOR    Ŀ�� �ݺ� ó��
   --���� sql�� ���� > �����(���� ���� ��) + Ŀ�� ó��
--
create or replace procedure up_ndsselemp
(pdeptno emp.deptno%type)
is
 vsql varchar2(2000);
 vcur sys_refcursor; -- 9i REF CURSOR
 vrow emp%ROWTYPE;
begin
 vsql := 'SELECT * ';
 vsql := vsql||'FROM emp ';
 vsql := vsql||'WHERE deptno = :pdeptno ';
 
 OPEN vcur FOR vsql using pdeptno;
 loop
 fetch vcur into vrow;
 exit when vcur%notfound;
 DBMS_OUTPUT.PUT_LINE(vrow.deptno||', '||vrow.empno||', '||vrow.ename||', '||vrow.job);
 end loop;
 close vcur;
end;

exec up_ndsselemp(30);

-- ���� ���� �˻� ����
-- [�μ���ȣ,�μ���, ������] �˻�����  �Է�
create or replace procedure up_ndssearchemp
(psearchcondition number -- 1 �μ���ȣ,2�����,3����
,psearchword varchar2
)
is
 vsql varchar2(2000);
 vcur sys_refcursor; -- 9i REF CURSOR
 vrow emp%ROWTYPE;
begin
 vsql := 'SELECT * ';
 vsql := vsql||'FROM emp '; 
 IF psearchcondition =1 THEN
 vsql := vsql||'WHERE deptno = :psearchword ';
 ELSIF psearchcondition =2  THEN
 vsql := vsql||'WHERE REGEXP_LIKE(ename,:psearchword,''i'')';
 ELSIF psearchcondition =3 THEN
 vsql := vsql||'WHERE REGEXP_LIKE(job,:psearchword,''i'')';
 END IF;
 OPEN vcur FOR vsql using psearchword;
 loop
 fetch vcur into vrow;
 exit when vcur%notfound;
 DBMS_OUTPUT.PUT_LINE(vrow.deptno||', '||vrow.empno||', '||vrow.ename||', '||vrow.job);
 end loop;
 close vcur;
exception
when NO_DATA_FOUND then
 raise_application_error(-20000,'����');
when others then
 raise_application_error(-20000,'����');
end;

exec UP_NDSSEARCHEMP(1,20);
exec UP_NDSSEARCHEMP(2,'L');
exec UP_NDSSEARCHEMP(3,'c');

grant connect, resource, dba to goodchoice;


