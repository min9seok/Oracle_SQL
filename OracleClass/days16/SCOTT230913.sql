-- ���� ó�� --
--1) �̸� ���ǵ� ���� ó�� ���
SELECT ename,sal
FROm emp
where sal = 1250; -- 2��
WhERE sal = 6000; -- X
where sal = 800;  -- 1��

create or replace procedure up_emplist
(psal emp.sal%type)
IS
vename emp.ename%type;
vsal emp.sal%type;
BEGIN
SELECT ename,sal into vename,vsal
FROm emp
where sal = psal;
DBMS_output.put_line(vename||'. '||vsal);
EXCEPTION
when no_data_found then
 raise_application_error(-20000,'> ������ ����');
when TOO_MANY_ROWS then
 raise_application_error(-20001,'> �ϳ��� ��ȸ�ض�');
when others then
 raise_application_error(-20002,'> �ٸ� ���� �߻�');
END;

exec UP_EMPLIST(800);
exec UP_EMPLIST(6000); --ORA-01403: no data found
--ORA-01422: exact fetch returns more than requested number of rows
exec UP_EMPLIST(1250); 

--2) �̸� ���ǵ��� ���� ���� ó�� ���
select *
FROM dept;
--ORA-00001: unique constraint (SCOTT.PK_DEPT) violated
insert into dept values(50,'QC','seoul');
--ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found
insert into emp(empno,ename,deptno)
values(9999,'admin',90);
--
create or replace procedure up_insemp
( pempno emp.empno%type
, pename emp.ename%type
, pdeptno emp.deptno%type)
IS
NO_FK_FOUND exception;
pragma exception_init(NO_FK_FOUND,-02291);
BEGIN
insert into emp(empno,ename,deptno)
values(pempno,pename,pdeptno);
commit;
EXCEPTION
when DUP_VAL_ON_INDEX then
 raise_application_error(-20000,'> PK �������� Ȯ��');
when NO_FK_FOUND then
 raise_application_error(-20001,'> FK �������� Ȯ��');
when others then
 raise_application_error(-20002,'> �ٸ� ���� �߻�');
END;
exec up_insemp(9999,'admin',90);

--3) ����ڰ� �����ϴ� ���� ó�� ��� 
create or replace procedure up_empexception
(psal emp.sal%type)
is
vempcount number;
no_emp_exception exception;
begin
SELECT COUNT(ename) into vempcount
from emp
where sal between psal-100 and psal+100;
IF vempcount= 0 THEN
 raise no_emp_exception;
ELSE
DBMS_OUTPUT.PUT_LINE('> ����� : ' || vempcount);
END IF;
exception
when no_emp_exception then
raise_application_error(-20000,'> 0�����');
end;
exec up_empexception(900);
exec up_empexception(6000);