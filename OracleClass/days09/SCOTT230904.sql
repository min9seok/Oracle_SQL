-- ����Ŭ �ڷ��� 
--1) CHAR �������� CHAR(SIZE BYTE|CHAR)
--CHAR == CHAR(1) == CHAR(1 BYTE) 1BYTE ~ 2000BYTE ��(3),��(1)

--2) NCHAR �������� == N(UNICODE) + CHAR
-- NCHAR(SIZE==����) 1���� ~ 2000BYTE
--== NCHAR == NCHAR(1) : ����  ����Ʈ ��� X

create table test (
       aa char(3)
     , bb char(3 char)
     , cc nchar(3)
     );
--Table TEST��(��) �����Ǿ����ϴ�.     
INSERT INTO test (aa,bb,cc) VALUES('ȫ�浿','ȫ�浿','ȫ�浿');
INSERT INTO test (aa,bb,cc) VALUES('ȫ','ȫ�浿','ȫ�浿');

--�������� : CHAR, NCHAR 2000byte
--�������� : VARCHAR2 ,NVARCHAR2 4000 byte
--3) VARCHAR2
name CHAR(10 CHAR) -- 10�� ����
name VARCHAR2(10 CHAR) -- 10�� ���� 
VARCHAR2(10) == VARCHAR2(10 BYTE)
VARCHAR2 == VARCHAR2(1) == VARCHAR2(1 BYTE) 

--4) NVARCHAR2 == N(UNICODE) + VARCHAR2

--5) LONG ���� ���� �ڷ��� 2GB

--6) NUMBER ���� = ����+�Ǽ�
NUMBER
NUMBER(p) precision ��Ȯ�� == ��ü �ڸ��� 1~38
NUMBER(p,s) scale �Ը� == �Ҽ������� �ڸ��� -84��127 

CREATE TABLE tbl_number (
 kor NUMBER(3)
,eng NUMBER(3)
,mat NUMBER(3)
,tot NUMBER(3)
,avg NUMBER(5,2)
);
-- ORA-00947: not enough values
INSERT INTO tbl_number (kor,eng,mat,tot,avg) values(90.89,85,100);
-- 90.89 �ݿø� �Ǿ 91
INSERT INTO tbl_number (kor,eng,mat) values(90.89,85,100);
-- 3�ڸ� �����̱⿡ - 999 ~ 999 ���� 
INSERT INTO tbl_number (kor,eng,mat) values(90,85,300);
INSERT INTO tbl_number (kor,eng,mat) values(90,85,-999);
--
SELECT * FROM tbl_number;
--
INSERT INTO tbl_number(kor,eng,mat)
values(
 TRUNC(dbms_random.value(0,100))
,TRUNC(dbms_random.value(0,100))
,TRUNC(dbms_random.value(0,100))
);

update tbl_number
set tot = kor+eng+mat , avg = (kor+eng+mat)/3;

SELECT *
FROM tbl_number;
--  �� �л��� ���� ���� 
update tbl_number
--set avg = 999.1234565
SET avg = 99999 --ORA-01438: value larger than specified precision allowed for this column
WHERE avg=92;  -- ����Ű PK

--7) FLOAT(p) == number

--8) DATE ��¥ + �ð� (��) 7BYTE
--    TIMESTAMP             , + ms, ns
�л����� ���̺�
�й� : NUMBER(7)
�̸� : VARCHAR2
��,��,��,�� : NUMBER(3) + �������� 
��� : NUMBER(5,2)
��� : NUMBER(4)
���� : DATE
�ֹε�Ϲ�ȣ : CHAR

--9) TIMESTAMP : DATE Ȯ�� 

--10) 2�� ������(0,1) RAW(SIZE) 2000byte , LONG RAW 2GB
-- �̹�������,�������� > 2�� ������ > DB ����

--11) BLOB Binary + Large Object 4GB , BFILE

--12) CLOB Character + Large Object 4GB , N(UNICODE)+CLOB 

--COUNT OVER() ������ ���� ������ ������� ��ȯ
SELECT buseo,name , basicpay
--count(*) OVER(ORDER BY basicpay)
,count(*) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;
--SUM OVER()  
SELECT buseo,name , basicpay
--,SUM(basicpay) OVER(ORDER BY basicpay) sum
,SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay)sum
FROM insa;

-- �� ������ ��հ� �޿����� ���� 
SELECT city,name,basicpay
,AVG(basicpay) OVER(PARTITION BY city order by city) avg
, basicpay - AVG(basicpay) OVER(PARTITION BY city order by city) cha
FROM insa;

-- ���̺� ���� ���� ����
-- ���̺� ���ڵ�(��,row) �߰� ���� ���� 

--1) ���̺� = ������ ����� 
--2) DB �𵨸� > ���̺� ����
�Խ��� ���̺� ����
1) ���̺�� : tbl_board
2)     �÷���       �ڷ���       ũ��           �����
   ��ȣ seq         ����(����)   NUMBER(38)    NOT NULL
   �ۼ��� writer     ����        VARCHAR2(20)  NOT NULL
   ��й�ȣ passwd   ����        VARCHAR2(10)  NOT NULL
   ���� title        ����        VARCHAR2(100)
   ���� content      ����        CLOB
   �ۼ��� regdate    ��¥        DATE           DEFAULT SYSDATE
   ���
3) �Խñ��� �����ϴ� PK : ��ȣ
4) �ʼ� �Է� ���� :   NOT NULL ��������
5) �ۼ����� ���� �ý��� ��¥�� �ڵ� �Է�

    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
      ( 
        ���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] 
       [,���̸�  ������Ÿ�� [DEFAULT ǥ����] [��������] ] 
       [,...]  
      ); 
--�Խ��� ���̺� ����
    CREATE TABLE tbl_board
      ( 
        seq  NUMBER(38) NOT NULL PRIMARY KEY
        ,writer VARCHAR2(20)  NOT NULL
        ,passwd VARCHAR2(10)  NOT NULL
        ,title VARCHAR2(100)  NOT NULL
        ,content CLOB
        ,regdate DATE DEFAULT SYSDATE       
      );    
? alter table ... add �÷� //���ο� �÷� �߰�
? alter table ... modify �÷�  //�÷� ����
? alter table ... drop[constraint] ��������  //�������� ����
? alter table ... drop column �÷�       //�÷� ���� 
SELECT *
FROM tbl_board;
--
INSERT INTO tbl_board (seq,writer,passwd,title,content,regdate)
values(1,'admin','1234','test-1','test-1',SYSDATE);
--
INSERT INTO tbl_board (seq,writer,passwd,title,content)
values(2,'hong','1234','test-2','test-2');
--
INSERT INTO tbl_board
values(3,'mmmm','1234','test-3','test-3',SYSDATE);
-- tbl_board ���̺� �������� Ȯ��
SELECT *
FROM user_constraints
WHERE table_name like '%BOARD%';
-- ��ȸ�� Į�� �߰�      
--readed NUMBER
ALTER TABLE tbl_board
ADD  readed NUMBER DEFAULT 0;
--1) �Խñ� �ۼ� (INSERT ��)
INSERT INTO tbl_board(writer,seq,title,passwd)
values ('mmm',
(SELECT nvl(MAX(seq),0)+1 FROM tbl_board),
'test-4','1111');
--2) content �� null �� ��� > '�ù�' �Խñ� ���� 
UPDATE tbl_board
SET content ='�ù�'
WHERE content is null;
--3) Ư�� �ۼ����� �Խñ� ���� 
DELETE FROM tbl_board
WHERE writer ='mmm';
--4) �÷��� �ڷ����� ũ�� ����
desc tbl_board;
-- WRITER  NOT NULL VARCHAR2(20)  > 40
ALTER TABLE tbl_board
modify writer VARCHAR2(40)  ;
--5) TITLE �÷��� ���� >subject
alter table tbl_board
rename COLUMN title TO subject;
SELECT *
FROM tbl_board;
--6) bigo �÷� �߰� (��Ÿ ����) > ����
ALTER TABLE tbl_board
ADD bigo VARCHAR2(100);
ALTER TABLE tbl_board
DROP COLUMN bigo;
--7) ���̺�� ����
RENAME ���̺��1 TO ���̺��2 
---------------------------------------------------------------
-- �������� �̿� ���̺� ���� 
��. �̹� ���� ���̺� ���� + ���ڵ� ����
��. �������� ����ؼ� ���̺� ����
��. ���̺� ���� + ������ ���� + �������� X
��. ;
CREATE TABLE tbl_emp(empno, ename, job, hiredate, mgr,pay ,deptno)
AS
SELECT empno, ename, job, hiredate, mgr,sal+nvl(comm,0) pay ,deptno
FROM emp;
desc emp;
desc tbl_emp;
SELECT *
FROM tbl_emp;
--�������� Ȯ��
SELECT *
FROM user_constraints;

-- �������� ���̺� ���� + ������ X
CREATE TABLE tbl_emp
AS
SELECT *
FROM emp
WHERE 1=0;

-- ���� deptno,dname,empno,ename,hiredate,pay,grade ���� tbl_empgrade ���̺�
CREATE TABLE tbl_empgrade
(deptno,dname,empno,ename,hiredate,pay,grade)
AS
SELECT b.deptno,dname,empno,ename,hiredate,sal+nvl(comm,0) pay, grade
FROM emp a , dept b , salgrade c
WHERE a.deptno = b.deptno
AND sal between losal AND hisal;
-------------------------------
--INSERT ��
INSERT INTO ���̺�� [(�÷���,,,)] VALUES(�÷���,,,)
DML - COMMIT(�Ϸ�),rollback(���);
-- Mutil + table insert ��
1) Unconditional insert all ���� ���ǰ� ������� ����Ǿ��� ���� ���� ���̺� �����͸� �Է��Ѵ�.
? ���������κ��� �ѹ��� �ϳ��� ���� ��ȯ�޾� ���� insert ���� �����Ѵ�.
? into ���� values ���� ����� �÷��� ������ ������ Ÿ���� �����ؾ� �Ѵ�.
�����ġ�
	INSERT ALL | FIRST
	  [INTO ���̺�1 VALUES (�÷�1,�÷�2,...)]
	  [INTO ���̺�2 VALUES (�÷�1,�÷�2,...)]
	  .......
	Subquery;

���⼭ 
 ALL : ���������� ��� ������ �ش��ϴ� insert ���� ��� �Է�
 FIRST : ���������� ��� ������ �ش��ϴ� ù ��° insert ���� �Է�
 subquery : �Է� ������ ������ �����ϱ� ���� ���������� �� ���� �ϳ��� ���� ��ȯ�Ͽ� �� insert �� ����
-- ��)
CREATE TABLE dept_10 as(SELECT * FROM dept WHERE 1=0);
CREATE TABLE dept_20 as(SELECT * FROM dept WHERE 1=0);
CREATE TABLE dept_30 as(SELECT * FROM dept WHERE 1=0);
CREATE TABLE dept_40 as(SELECT * FROM dept WHERE 1=0);
INSERT ALL
INTO dept_10 values(deptno,dname,loc)
INTO dept_20 values(deptno,dname,loc)
INTO dept_30 values(deptno,dname,loc)
INTO dept_40 values(deptno,dname,loc)
SELECT * FROM dept;

--2) conditional insert all  ������ �ִ� �������̺� INSERT��
emp_10,emp_20,emp_30,emp_40 ���̺� ���� �� 
emp ������������ �� �μ����� �� ���̺� insert 
CREATE TABLE emp_10 as(SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_20 as(SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_30 as(SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_40 as(SELECT * FROM emp WHERE 1=0);
--INSERT ALL
--2-1) conditional first insert
INSERT FIRST
WHEN deptno = 10 THEN
INTO emp_10 values(empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 20 THEN
INTO emp_20 values(empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 30 THEN
INTO emp_30 
ELSE
INTO emp_40 
SELECT * FROM emp;

SELECT * FROM emp_40;

-- ALL / FIRST ������ ���� �������� insert / ù���� ���Ǹ� insert 
INSERT FIRST
WHEN deptno=10 THEN
INTO emp_10
WHEN job='CLERK' THEN
INTO emp_20
ELSE
INTO emp_40
SELECT * FROM emp;
 
--4) pivoting insert 
create table sales(
     employee_id       number(6),
    week_id            number(2),
    sales_mon          number(8,2),
    sales_tue          number(8,2),
    sales_wed          number(8,2),
    sales_thu          number(8,2),
    sales_fri          number(8,2));

insert into sales values(1101,4,100,150,80,60,120);
insert into sales values(1102,5,300,300,230,120,150);

create table sales_data(
    employee_id        number(6),
    week_id            number(2),
    sales              number(8,2));

 insert all
    into sales_data values(employee_id, week_id, sales_mon)
    into sales_data values(employee_id, week_id, sales_tue)
    into sales_data values(employee_id, week_id, sales_wed)
    into sales_data values(employee_id, week_id, sales_thu)
    into sales_data values(employee_id, week_id, sales_fri)
    select employee_id, week_id, sales_mon, sales_tue, sales_wed,
           sales_thu, sales_fri
    from sales;

 select * from sales;
 select * from sales_data;
--1) emp_10 ���̺��� ��� ���ڵ�(��) ���� + commit,rollback
DELETE FROM emp_10;
SELECT *
FROM emp_10;
--2) emp_20 ���̺��� ��� ���ڵ�(��) ���� + �ڵ� Ŀ�� 
TRUNCATE TABLE emp_20;
SELECT *
FROM emp_20;
--3) ���̺� ��ü�� ����
DROP table emp_30;
SELECT *
FROM emp_30;
---------------------------------------------------------
--���� insa ���� num,name �÷��� tbl_score ���� (num <= 1005)
CREATE TABLE tbl_score
as
(SELECT num,name FROM insa WHERE num <=1005);
-- ���� tbl_score �� kor,eng,mat,tot,avg,grade,rank �߰� 
--��,��,��,���� �⺻�� 0 grade char(1 char)
ALTER TABLE tbl_score
ADD(  
   kor NUMBER(3) DEFAULT 0
,  eng NUMBER(3) DEFAULT 0 
,  mat NUMBER(3) DEFAULT 0 
,  tot NUMBER(3) DEFAULT 0 
,  avg NUMBER(5,2) 
,  grade char(1 char)
,  rank NUMBER(3)
);
-- ���� 1001~1005 �� ������ ������ ������ ������ ����
update tbl_score
set kor = trunc(dbms_random.value(0,101))
,eng = trunc(dbms_random.value(0,101))
,mat = trunc(dbms_random.value(0,101))
WHERE num between 1001 AND 1005;
--
--update tbl_score
--set kor = (SELECT kor FROM tbl_score WHERE num=1005)
--,eng = (SELECT eng FROM tbl_score WHERE num=1005)
--,mat = (SELECT mat FROM tbl_score WHERE num=1005)
--WHERE num = 1001;
update tbl_score
SET(kor,eng,mat) = (SELECT kor,eng,mat FROM tbl_score WHERE num=1005)
WHERE num = 1001;
-- ���� ��� ����
update tbl_score
set tot = kor+eng+mat
   ,avg = (kor+eng+mat)/3;
SELECT t.* , TO_CHAR(t.avg,'999.00')
FROM tbl_score t;
-- ��� 90A 80B 70C 60D 59F
update tbl_score
set grade = 
   CASE  
   WHEN avg>=90 THEN 'A'
   WHEN avg>=80 THEN 'B'
   WHEN avg>=70 THEN 'C'
   WHEN avg>=60 THEN 'D'
   ELSE 'F'   
   END 
;
--DECODE(trunc(avg/10),10,'A',9,'A',8,'B',7,'C',6,'D','F')
update tbl_score p
set rank = (
SELECT count(*)+1
FROM tbl_score
where p.avg < avg
);
update tbl_score p
set rank = ( 
SELECT t.r
FROM(
SELECT num,tot,rank() OVER(ORDER BY tot desc) r 
FROM tbl_score
) t
WHERE t.num = p.num
);

SELECT * FROM tbl_score;

-- ���� ��� �л����� ���� ���� 20�� ���� 
update tbl_score
set eng = CASE
WHEN eng >= 80 THEN 100
ELSE eng + 20
END;
-- ������ ������ �� �����Ǹ� 
-- ������ �л��� �� �� �� ��ü�л��� ����� �޶����� .
-- Ʈ���� Trigger 
-- ���� ���л��鸸 ���� ������ 5���� ����
update tbl_score 
set kor = CASE
WHEN kor>=95 THEN 100
ELSE kor + 5
END
WHERE num = ANY (
SELECT num 
FROM  insa
WHERE substr(ssn,-7,1) =1
AND num <= 1005
);
--
--(ȭ) : �������� , ���� , ������ ����
--(��) : DB �𵨸� + �Ϸ� DB �𵨸� ( �� )
--(��) : �� ��ǥ, PL/SQL
--(��) : PL/SQL 
--�������� , ��ȣȭ , ��

-- ���� (merge)

create table tbl_emp(
    id number primary key, 
    name varchar2(10) not null,
    salary  number,
    bonus number default 100);

desc tbl_emp;

insert into tbl_emp(id,name,salary) values(1001,'jijoe',150);
insert into tbl_emp(id,name,salary) values(1002,'cho',130);
insert into tbl_emp(id,name,salary) values(1003,'kim',140);

SELECT * FROM tbl_emp;
create table tbl_bonus(
id number,
bonus number default 100);

insert into tbl_bonus(id)
      (select e.id from tbl_emp e);

select * from tbl_bonus;

--tbl_emp , tbl_bonus ���� 
MERGE INTO tbl_bonus b 
USING (SELECT id,salary FROM tbl_emp) e
ON (b.id = e.id)
 WHEN MATCHED THEN UPDATE SET b.bonus = b.bonus + e.salary * 0.01
 WHEN NOT MATCHED THEN INSERT(b.id,b.bonus)values(e.id,e.salary*0.01);
--WHERE condition

-- 
SELECT 
      NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 1, TO_CHAR( dates, 'DD')) ), ' ')  ��
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 2, TO_CHAR( dates, 'DD')) ), ' ')  ��
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 3, TO_CHAR( dates, 'DD')) ), ' ')  ȭ
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 4, TO_CHAR( dates, 'DD')) ), ' ')  ��
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 5, TO_CHAR( dates, 'DD')) ), ' ')  ��
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 6, TO_CHAR( dates, 'DD')) ), ' ')  ��
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 7, TO_CHAR( dates, 'DD')) ), ' ')  ��
FROM (
        SELECT TO_DATE(:yyyymm , 'YYYYMM') + LEVEL - 1  dates
        FROM dual
        CONNECT BY LEVEL <= EXTRACT ( DAY FROM LAST_DAY(TO_DATE(:yyyymm , 'YYYYMM') ) )
)  t 
GROUP BY CASE
                -- 1/2/3/4/5/6/7               2022/04/1�� ����
            WHEN TO_CHAR( dates, 'D' ) < TO_CHAR( TO_DATE( :yyyymm,'YYYYMM' ), 'D' ) 
                 THEN TO_CHAR( dates, 'W' ) + 1
            ELSE TO_NUMBER( TO_CHAR( dates, 'W' ) )
        END
ORDER BY CASE
            WHEN TO_CHAR( dates, 'D' ) < TO_CHAR( TO_DATE( :yyyymm,'YYYYMM' ), 'D' ) THEN TO_CHAR( dates, 'W' ) + 1
            ELSE TO_NUMBER( TO_CHAR( dates, 'W' ) )
        END;



