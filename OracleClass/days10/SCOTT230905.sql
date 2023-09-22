-- ��������
-- data integrity(������ ���Ἲ)
-- ��ü ���Ἲ = ���ϼ�+�ּҼ� = ���� �ߺ�X ������ �ϳ� NOT NULL
-- ���� ���Ἲ = �θ�(����Ű RK) <-> �ڽ�(�ܷ�Ű KF) �θ� �ڽ� �� ��ġ OR null
-- ������ ���Ἲ = ������ Ÿ��, ����, �⺻ Ű, ���ϼ�, null ���, ��� ���� ���� 

-- �������� ���� ���
1) �÷� ���� IN-LINE ���̺� ������ �÷��� �ٷ� �ڿ� ����Ͽ� ����
CREATE TABLE sample(
 id varchar2(20) ��������
)
2) ���̺� ���� OUT-OF-LINE ������ �������ǿ� ,(�ĸ�)�� ������ �� ���������� ���
CREATE TABLE sample(
 id varchar2(20) 
 , CONSTRAINT ��������
)
-- ���������� �����ϴ� ����
1) ���̺� ���� - CREATE TABLE
2) ���̺� ���� - ALTER TABLE

-- ���������� ����
1) PRIMARY KEY(PK) �ش� �÷� ���� �ݵ�� �����ؾ� �ϸ�, �����ؾ� ��
                   (NOT NULL�� UNIQUE ���������� ������ ����) 
2) FOREIGN KEY(FK) �ش� �÷� ���� �����Ǵ� ���̺��� �÷� �� ���� �ϳ��� ��ġ�ϰų� 
                   NULL�� ���� 
3) UNIQUE KEY(UK) ���̺����� �ش� �÷� ���� �׻� �����ؾ� �� 
4) NOT NULL(NN) �÷��� NULL ���� ������ �� ����. --�÷� �����θ� �������� 
5) CHECK(CK) �ش� �÷��� ���� ������ ������ ���� ������ ���� ���� 
;
-- �ǽ� tbl_constraint
--1)�÷� ����
CREATE TABLE tbl_constraint1(
  --empno number(4) NOT NULL PRIMARY KEY -- �̸� �ý��� �ڵ�����
    empno number(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
   ,ename varchar2(20) 
   ,deptno number(2) CONSTRAINT FK_tblconstraint1_deptno 
                     REFERENCES dept(deptno)-- dept(deptno) �ܷ�Ű 
   ,kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK(kor betwwen 0 and 100 )   
   ,email varchar2(250) CONSTRAINT UK_tblconstraint1_email UNIQUE
   ,city varchar2(20) CONSTRAINT CK_tblconstraint1_city 
                       CHECK(city in ('����','�λ�','�뱸','����') )   
);
-- �������� PK����
ALTER TABLE ���̺�� 
DROP [CONSTRAINT constraint�� | PRIMARY KEY | UNIQUE(�÷���)]
[CASCADE];
--��. �������� �̸����� ����
ALTER TABLE tbl_constraint1
DROP CONSTRAINT SYS_C007115;
--
ALTER TABLE tbl_constraint1
DROP CONSTRAINT PK_tblconstraint1_empno;
--��. PK �������Ǹ��� ���� ���� 
ALTER TABLE tbl_constraint1
DROP PRIMARY KEY;
--2)���̺� ����
CREATE TABLE tbl_constraint2(
    empno number(4) NOT NULL
   ,ename varchar2(20) 
   ,deptno number(2)
   ,kor    number(3)
   ,email varchar2(250)
   ,city varchar2(20)
    ,CONSTRAINT PK_tblconstraint2_empno primary key(empno)
    ,CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    ,CONSTRAINT CK_tblconstraint2_kor CHECK(kor betwwen 0 and 100 )   
    ,CONSTRAINT UK_tblconstraint2_email UNIQUE(email)
    ,CONSTRAINT CK_tblconstraint2_city 
                       CHECK(city in ('����','�λ�','�뱸','����') )   
);
SELECT *
FROM user_constraints
WHERE table_name = 'TBL_CONSTRAINT3';
--3) ���̺� ���� �� PK �������� ����
CREATE TABLE tbl_constraint3(
    empno number(4) 
   ,ename varchar2(20) 
   ,deptno number(2)
);
-- ���̺� ����
ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tblconstraint3_empno Primary key (empno);
ALTER TABLE tbl_constraint3
ADD CONSTRAINT FK_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);
------------------- �������� ��/Ȱ��ȭ
ALTER TABLE ���̺��
ENABLE CONSTRAINT �������Ǹ�;

ALTER TABLE ���̺��
DISABLE CONSTRAINT �������Ǹ�;
--
DROP TALBE ���̺�� CASCADE CONSTRAINTS; ���̺�� �� ���̺��� �����ϴ� FK�� ���ÿ� ����
DROP TALBE ���̺��; DELETE
DROP TALBE ���̺�� PURGE; Shift+DELETE
--ALTER TABLE ���̺��
--ADD (�÷�....)
--ADD (��������...) Ȯ���ʿ�
-------------------- FOREIGN KEY (FK)
���÷������� ���ġ�
        �÷��� ������Ÿ�� CONSTRAINT constraint��
	REFERENCES �������̺�� (�����÷���) 
             [ON DELETE CASCADE | ON DELETE SET NULL]
detpno number(2) CONSTRAINT FK_EMP_DEPTNO REFERENCES dept(deptno) 
                 ON DELETE CASCADE 
--�θ� ���̺��� ���� ������ �� �̸� ������ �ڽ� ���̺��� ���� ���ÿ� ������ �� �ִ�.
                ON DELETE SET NULL 
--�θ� ���̺��� ���� �����Ǹ� �ڽ� ���̺��� ���� NULL ������ �����Ų��.

--�ǽ� 
--ON DELETE CASCADE 
--ON DELETE SET NULL 
SELECT *
FROM user_constraints
WHERE table_name IN( 'TBL_EMP','TBL_DEPT');
ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tbl_dept_deptno Primary key (deptno);
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tbl_emp_empno Primary key (empno);
ALTER TABLE tbl_emp
DROP CONSTRAINT PK_tbl_emp_deptno;
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tbl_emp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno)
                                     ON DELETE CASCADE;
                                     ON DELETE SET NULL;
--
SELECT * FROM tbl_emp;
SELECT * FROM tbl_dept;
delete FROM tbl_dept
WHERE deptno =30;
--------------------------------------------------
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- åID
      ,title      VARCHAR2(100) NOT NULL  -- å ����
      ,c_name  VARCHAR2(100)    NOT NULL     -- c �̸�
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK��(��) �����Ǿ����ϴ�.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

COMMIT;

SELECT *
FROM book;
-- �ܰ����̺�( å�� ���� )
  CREATE TABLE danga(
      b_id  VARCHAR2(10)  NOT NULL  -- PK , FK (�ĺ����� ***)
      ,price  NUMBER(7) NOT NULL    -- å ����
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA��(��) �����Ǿ����ϴ�.
book  - b_id(PK), title, c_name
danga - b_id(PK,FK), price 

INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT;

SELECT *
FROM danga;
-- å�� ���� �������̺�
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);
--Table AU_BOOK��(��) �����Ǿ����ϴ�.

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * 
FROM au_book;
-- �����̺�(����)          
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);          
--Table GOGAEK��(��) �����Ǿ����ϴ�.
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);
--Table PANMAI��(��) �����Ǿ����ϴ�.
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   
-- JOIN ����
--1) EQUI JOIN 
-- WHERE �������� �������� = ���
--            ��.PK = ��.FK
-- ����Ŭ������ natural join �� ���� 
-- USING ���� ��� ...

-- åID,å����,���ǻ�(c_name),�ܰ� ���
1) ��ü��.�÷���
SELECT  book.b_id , book.title, book.c_name , danga.price
FROM book, danga
WHERE book.b_id = danga.b_id;
2) ��Ī.�÷���
SELECT  a.b_id , title, c_name ,price
FROM book a, danga b
WHERE a.b_id = b.b_id;
3) JOIN-ON ����
SELECT  a.b_id , title, c_name ,price
FROM book a JOIN danga b ON a.b_id = b.b_id;
4) USING �� ��� - ��ü��.�÷��� �Ǵ� ��Ī��.�÷��� X
SELECT b_id,title,c_name,price
FROM book JOIN danga USING(b_id);
5) 
SELECT b_id,title,c_name,price
FROM book NATURAL JOIN danga ;

-- ���� åID,å����,�Ǹż���,�ܰ�,������,�Ǹűݾ�
1) ,,
SELECT a.b_id,title,p_su,price,g_name,(p_su*price) "�Ǹűݾ�"
FROM BOOK a,gogaek b, panmai c , danga d
WHERE a.b_id = c.b_id
AND a.b_id = d.b_id
AND b.g_id = c.g_id;
2) JOIN-ON
SELECT a.b_id,title,p_su,price,g_name,(p_su*price) "�Ǹűݾ�"
FROM BOOK a JOIN panmai c ON a.b_id = c.b_id
            JOIN danga d ON a.b_id = d.b_id
            JOIN gogaek b ON b.g_id = c.g_id;
3) USING
SELECT b_id,title,p_su,price,g_name,(p_su*price) "�Ǹűݾ�"
FROM BOOK a JOIN panmai USING(b_id)  
            JOIN danga  USING(b_id)
            JOIN gogaek USING(g_id);
-- NON EQUI JOIN
 -- WHERE ���� BETWEEN ... AND ... �����ڸ� ����Ѵ�.
 SELECT deptno,ename,sal,grade
 FROM emp e , salgrade s
 WHERE sal between losal AND hisal;
 
 SELECT *
FROM salgrade;
SELECT *
FROM emp;
-- INNER JOIN : , �� �̻��� ���̺��� ���� ������ �����ϴ� �ุ ��ȯ�Ѵ�.
SELECT d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;
-- LEFT OUTER JOIN
SELECT d.deptno,ename,sal
FROM emp e, dept d
WHERE e.deptno = d.deptno(+);
-- RIGHT OUTER JOIN
SELECT d.deptno,ename,sal
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno;
--
SELECT d.deptno,ename,sal
FROM emp e FULL JOIN dept d ON e.deptno = d.deptno;
--
--SELF JOIN : ���� ���̺��� ����
-- deptno/empno/ename ���ӻ���� �μ���ȣ/�����ȣ/�����

SELECT e1.deptno,e1.empno,e1.ename,e1.mgr
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno;
-- CROSS JOIN
SELECT d.deptno,dname,empno,ename
FROM emp e, dept d;





















