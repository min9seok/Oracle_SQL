1.PL/SQL�� ��Ű���� 
- ����Ǵ� Ÿ��, ���α׷� ��ü, �������α׷�(procedure, function)�� �������� ���� ���� ��

2.��Ű���� 
- specification�� 
   body �κ����� �Ǿ� ������, 
   
3. ����Ŭ���� �⺻������ �����ϴ� ��Ű���� ������, ������ �̸� �̿��ϸ� ���ϴ�

4. specification �κ� : type, constant, variable, exception, cursor, subprogram�� ����ȴ�. 

5. body �κ��� cursor, subprogram ������ �����Ѵ�.
6. ȣ���� �� '��Ű��_�̸�.���ν���_�̸�' ������ ������ �̿��ؾ� �Ѵ�. 

--��)
1. �� �κ�
CREATE OR REPLACE PACKAGE employee_pkg as 
      procedure print_ename(p_empno number); 
      procedure print_sal(p_empno number); 
    end employee_pkg; 
--Package EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.

CREATE OR REPLACE PACKAGE BODY employee_pkg as 
   
      procedure print_ename(p_empno number) is 
        l_ename emp.ename%type; 
      begin 
        select ename 
          into l_ename 
          from emp 
          where empno = p_empno; 
       dbms_output.put_line(l_ename); 
     exception 
       when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end print_ename; 
  
   procedure print_sal(p_empno number) is 
     l_sal emp.sal%type; 
   begin 
     select sal 
       into l_sal 
       from emp 
       where empno = p_empno; 
     dbms_output.put_line(l_sal); 
   exception 
     when NO_DATA_FOUND then 
       dbms_output.put_line('Invalid employee number'); 
   end print_sal; 
  
   end employee_pkg; 
--Package Body EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.



