SELECT FLAVOR
FROM (
    SELECT FLAVOR
    FROM (
        SELECT *
        FROM FIRST_HALF 
            UNION ALL
        SELECT *
        FROM JULY
    )
    GROUP BY FLAVOR
    ORDER BY sum(TOTAL_ORDER) DESC
)
WHERE ROWNUM <= 3
;
--����) åID  , å����, �ܰ�,�Ǹż���,����,�Ǹűݾ�
--SELECT a.b_id,a.title,b.price,c.p_su,,d.g_name(p_su*price)"�Ǹűݾ�"
--FROM book a, danga b, panmai c , gogaek d
--WHERE a.b_id = b.b_id
--AND   a.b_id = c.b_id
--AND  c.g_id = d.g_id;
//
SELECT b_id,title,price,p_su,g_name,(p_su*price)"�Ǹűݾ�"
FROM book NATURAL JOIN danga NATURAL JOIN panmai NATURAL JOIN gogaek ;

--����) ���ǵ� å���� ���� �� �� ���� �ǸŵǾ����� ��ȸ 
-- åID ,  å����, �ܰ� , ���ǸűǼ�
SELECT a.b_id,a.title,b.price,sum(p_su)
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id
AND   a.b_id = c.b_id
group by a.b_id,a.title,b.price;

SELECT b_id,title,price,sum(p_su) "�ǸűǼ�"
FROM book NATURAL JOIN danga NATURAL JOIN panmai 
group by b_id,title,price;

SELECT distinct(a.b_id),a.title,b.price
,(SELECT sum(p_su) FROM panmai WHERE b_id = a.b_id) "�ǸűǼ�"
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id
AND   a.b_id = c.b_id;

-- ����) �Ǹŵ� �� �ִ� åID ����
SELECT b.b_id,title,price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id IN ( SELECT DISTINCT(b_id) FROM panmai );
-- ����) �Ǹŵ� �� ���� åID ���� 
SELECT b.b_id,title,price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id NOT IN ( SELECT DISTINCT(b_id) FROM panmai );
--�Ǹŵ� ���� ���� å�� 0���� �����ؼ� ���
SELECT distinct(a.b_id),a.title,b.price
,nvl((SELECT sum(p_su) FROM panmai WHERE b_id = a.b_id),0) "�ǸűǼ�"
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id(+)
AND   a.b_id = c.b_id(+);
--
SELECT distinct(a.b_id),a.title,b.price
,nvl((SELECT sum(p_su) FROM panmai WHERE b_id = a.b_id),0) "�ǸűǼ�"
FROM book a LEFT JOIN danga b ON a.b_id = b.b_id
LEFT JOIN panmai c ON  a.b_id = c.b_id;
-- ���� �ǸűǼ��� ���� å�� ���� ���� ��� 
-- TOT_N ��� BETWEEN ���Ұ�
SELECT *
FROM(
SELECT a.b_id,a.title,b.price,sum(p_su) "�ǸűǼ�"
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id
AND   a.b_id = c.b_id
group by a.b_id,a.title,b.price
order by �ǸűǼ� desc
) t
WHERE ROWNUM = 1;
--WHERE ROWNUM <= 3;
-- RANK ��� BETWEEN ��밡�� 
WITH t AS(
 SELECT a.b_id,a.title,b.price,sum(p_su) "�ǸűǼ�"
 ,RANK() OVER(ORDER BY sum(p_su) desc) rank
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id
AND   a.b_id = c.b_id
group by a.b_id,a.title,b.price
)
SELECT * 
FROM t
WHERE rank = 1;
--WHERE rank <= 3;
--���� �⵵�� ���� �Ǹ� ��Ȳ 
--�Ǹų⵵,�Ǹſ�,�Ǹűݾ�(p_su*price)
SELECT to_char(p_date,'YYYY') �Ǹų⵵
      ,to_char(p_date,'MM') �Ǹſ�
      ,sum(p_su*price) �Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id
group by (to_char(p_date,'YYYY'),to_char(p_date,'MM'))
order by 1,2;
--���� �⵵��  �Ǹ� ��Ȳ 
--�Ǹų⵵,�Ǹűݾ�(p_su*price)
SELECT to_char(p_date,'YYYY') �Ǹų⵵      
      ,sum(p_su*price) �Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id
group by to_char(p_date,'YYYY')
order by 1;
--  ����  OUTER JOIN PARTITION BY
SELECT to_char(p_date,'YYYY') �Ǹų⵵
      ,to_char(p_date,'MM') �Ǹſ�
      ,sum(p_su*price) �Ǹűݾ�
FROM panmai p LEFT JOIN danga d ON p.b_id = d.b_id
group by (to_char(p_date,'YYYY'),to_char(p_date,'MM'))
order by 1,2;
--����) ������(��) �Ǹ���Ȳ ��ȸ
SELECT to_char(p_date,'YYYY') �Ǹų⵵      
       ,g.g_id ����ID
       ,g_name ������
      ,sum(p_su*price) �Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON p.g_id = g.g_id
group by to_char(p_date,'YYYY'),g.g_id,g_name
order by 1;
--����) ���� ������ �Ǹ���Ȳ 
--�����ڵ� ������ �Ǹűݾ��� ����(�Ҽ��� �Ѥ��ݿø�)
SELECT g.g_id �����ڵ� ,g_name ������
       ,sum(p_su*price) �Ǹűݾ���
       ,round(sum(p_su*price)/4/100)||'%' ����
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON p.g_id = g.g_id
WHERE to_char(p_date,'YYYY') = to_char(SYSDATE,'YYYY')
group by g.g_id,g_name
order by 1;
-- ����) å�� �� �Ǹűݾ��� 15000�� �̻� �ȸ� å�� ���� ��ȸ
--åID ���� �ܰ� ���ǸűǼ� ���Ǹűݾ�
SELECT b.b_id,title
,sum(p_su) ���ǸűǼ�
,sum(p_su*price) ���Ǹűݾ�
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
group by b.b_id,title
having sum(p_su*price) >=15000
order by 1;
-- ����) å�� �� �ǸűǼ� 10�� �̻� �ȸ� å�� ���� ��ȸ (Having)
--åID ���� �ܰ� ���ǸűǼ� ���Ǹűݾ�
SELECT b.b_id,title
,sum(p_su) ���ǸűǼ�
,sum(p_su*price) ���Ǹűݾ�
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
group by b.b_id,title
HAVING sum(p_su) >=10
order by 1;
------- �� (View) 
--FROM ���̺� �Ǵ� ��
--user_tables, user_xx ��� �� 
--1) �������̺� : �Ѱ� �̻��� �⺻ ���̺��̳� �ٸ� �並 �̿��Ͽ� ����
--2) ��ü ������ �߿��� �Ϻθ� ������ �� �ֵ��� �����ϱ� ���� ���
--3) ������ ��ųʸ� ���̺� �信 ���� ���Ǹ� �����ϰ� ��ũ�� ���� ������ �Ҵ���� �ʴ´�.

-- ���� Ȯ��
SELECT *
FROM user_sys_Privs;

-- �� ����
--CREATE TABLE
--CREATE USER
--CREATE TABLESPACE
-- �ܼ��� , ���պ�(O) ������ DML
CREATE OR REPLACE VIEW panView 
AS
--(
SELECT b.b_id,title,price,g.g_id,g_name,p_date,p_su
   ,(p_su*price) amt
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id
order by p_date desc --�並 �����ϴ� subquery���� ORDER BY���� ������ �� ����
--)
;
-- View PANVIEW��(��) �����Ǿ����ϴ�.
-- ���� , ���ȼ� ����

SELECT *
FROM panView;
-- �並 �̿��� ���Ǹűݾ� ��ȸ
SELECT sum(amt)
FROM panView;
-- �� �ҽ� Ȯ�� :DB��ü, ���� ���� 
SELECT text
FROM user_views;
--�� ���� CREATE OR REPLACE VIEW ����
--�� ����
DROP VIEW panView;
--View PANVIEW��(��) �����Ǿ����ϴ�.

--����) �⵵,��,���ڵ�,����,�Ǹűݾ���(�⵵�� ��) �⵵,�� ��������  �� ����
CREATE or REPLACE VIEW gogaekView
AS
SELECT TO_CHAR(p_date,'YYYY') �Ǹų⵵
      ,TO_CHAR(p_date,'MM') �Ǹſ�
      ,g.g_id
      ,g_name
--      ,p_su,price
      ,sum(p_su*price) ���Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id            
              JOIN gogaek g ON p.g_id = g.g_id
GROUP BY TO_CHAR(p_date,'YYYY'),TO_CHAR(p_date,'MM'),g.g_id,g_name
order by 1,2;
;
SELECT TO_CHAR(p_date,'YYYY') �Ǹų⵵
      ,TO_CHAR(p_date,'MM') �Ǹſ�
      ,g.g_id
      ,g_name
--      ,p_su,price
      ,sum(p_su*price) ���Ǹűݾ�
FROM panmai p JOIN danga d ON p.b_id = d.b_id            
              JOIN gogaek g ON p.g_id = g.g_id
GROUP BY TO_CHAR(p_date,'YYYY'),TO_CHAR(p_date,'MM'),g.g_id,g_name
order by 1,2;
--
SELECT *
FROM gogaekView;
--
SELECT *
FROM tab
WHERE tabtype = 'VIEW';
-- ��(View) : DML �۾� ���� 
--  �� ���ú�
--  �� ���պ� 
CREATE TABLE testa (
aid NUMBER PRIMARY KEY
,name varchar2(20) NOT NULL
,tel varchar2(20) NOT NULL
,memo varchar2(10) 
);
CREATE TABLE testb(
bid NUMBER PRIMARY KEY
,aid NUMBER CONSTRAINT fk_testb_aid REFERENCES testa(aid)
ON DELETE CASCADE
,score NUMBER(3)
);
INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');

INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

COMMIT;
--
SELECT * FROM testa;
SELECT * FROM testb;
-- �ܼ��� ���� + DML �۾�
DESC testa;
CREATE OR REPLACE VIEW aView
AS
SELECT aid, name, memo
FROM testa;
--View AVIEW��(��) �����Ǿ����ϴ�.
-- �ܼ��並 ����ؼ� INSERT 
INSERT INTO aView(aid,name,memo) VALUES(5,'f','5');
--ORA-01400: cannot insert NULL into ("SCOTT"."TESTA"."TEL")
--INSERT INTO testa(aid,name,memo) VALUES(5,'f','5');

-- �� ����
CREATE OR REPLACE VIEW aView
AS
SELECT aid, name, tel
FROM testa;
--View AVIEW��(��) �����Ǿ����ϴ�.
INSERT INTO aView(aid,name,tel) VALUES(5,'f','5');
-- 1 �� ��(��) ���ԵǾ����ϴ�.
COMMIT;
DELETE FROM aView
WHERE aid =5;
-- 1 �� ��(��) �����Ǿ����ϴ�.
DROP VIEW aView;
--���պ� ����
CREATE OR REPLACE VIEW abView
AS
SELECT a.aid,name,tel,bid,score
FROM testa a JOIN testb b ON a.aid = b.aid
;
--View ABVIEW��(��) �����Ǿ����ϴ�.
INSERT INTO abView (aid,name,tel,bid,score)
VALUES(10,'x',55,20,70);
-- ���� : ���ÿ� �� ���̺��� ������ ���� INSERT �� �� ����
--ORA-01779: cannot modify a column which maps to a non key-preserved table

-- ���պ� ���� : �� ���̺��� ���븸 ���� ����
UPDATE abView
SET score =99
WHERE bid = 1;
-- ���� : �����̺��� ���� ���� X 
DELETE abView
WHERE aid = 1;

SELECT * FROM testa;
SELECT * FROM testb;
-- DELETE CASCADE �ɼǿ� ���� �������ϴ� ���̺��� ����
-- ������ 90�� �̻��� �� ����
CREATE OR REPLACE VIEW bView
AS
SELECT bid,aid,score
FROM testb
WHERE score >= 90;
--View BVIEW��(��) �����Ǿ����ϴ�.
-- bid �� 3�� ���� score = 70������ ����
UPDATE bView -- score >=90
set score = 70
WHERE bid =3;
--
SELECT *
FROM bView;
rollback;
-- ������ 90�� �̻��� �� ����
CREATE OR REPLACE VIEW bView
AS
SELECT bid,aid,score
FROM testb
WHERE score >= 90
WITH CHECK OPTION CONSTRAINT CK_bView
;
-- View BVIEW��(��) �����Ǿ����ϴ�.
UPDATE bView
SET score = 70
WHERE bid = 3;
--ORA-01402: view WITH CHECK OPTION where-clause violation
--
DROP VIEW aView;
DROP VIEW bView;
DROP VIEW abView;
DROP VIEW GOGAEKVIEW;
SELECT *
FROM tab
WHERE tabtype = 'VIEW';
-- MATERIALIZED VIEW (������ ��)
-- ���� �����͸� ������ �ִ� �� 

-- ������ ����
--ORA-01788: CONNECT BY clause required in this query block
SELECT LEVEL
FROM dual
CONNECT BY  LEVEL <= 31; -- ������ 

LEVEL -> CONNECT BY -> LEVEL ���� �˻� -> [ ������ ���� ]

-- 2���� ������� ���̺� < -- ������ ���� ǥ��( ����, ��ȸ )
-- �ǹ� ������, ���� ������ ����
-- 1) ���̺� : �θ�-�ڽ� �÷� �߰�
-- 2) SELECT : START WUTH, CONNECT BY ���� ����ϸ� ������ ����

--7898 �� ���� 
SELECT empno,ename,sal,LEVEL
FROM emp
WHERE mgr = 7698
START WITH mgr is null
CONNECT BY PRIOR empno = mgr; -- PRIOR �ڽ� = �θ� top-down �����
--
create table tbl_test(
    deptno number(3) not null primary key,
    dname varchar2(30) not null,
    college number(3),
    loc varchar2(10));
--
INSERT INTO tbl_test VALUES        ( 101,  '��ǻ�Ͱ��а�', 100,  '1ȣ��');
INSERT INTO tbl_test VALUES        (102,  '��Ƽ�̵���а�', 100,  '2ȣ��');
INSERT INTO tbl_test VALUES        (201,  '���ڰ��а� ',   200,  '3ȣ��');
INSERT INTO tbl_test VALUES        (202,  '�����а�',    200,  '4ȣ��');
INSERT INTO tbl_test VALUES        (100,  '�����̵���к�', 10 , null );
INSERT INTO tbl_test VALUES        (200,  '��īƮ�δн��к�',10 , null);
INSERT INTO tbl_test VALUES        (10,  '��������',null , null);
COMMIT;
SELECT * FROM tbl_test;
--
SELECT deptno,dname,college,level
FROM tbl_test
START WITH deptno=10
CONNECT BY PRIOR deptno = college;
--
SELECT LPAD('��',(LEVEL-1)*3)|| dname
FROM tbl_test
START WITH dname = '��������'
CONNECT BY PRIOR deptno = college;
--
-- ������������ ���� ���� ��� WHERE ���
 SELECT deptno,college,dname,loc,LEVEL
    FROM tbl_test
    WHERE dname != '�����̵���к�' -- �ڽ� ���� ���� ���θ� ���� 
    START WITH college IS NULL
    CONNECT BY PRIOR deptno=college;
-- CONNECT BY ���
SELECT deptno,college,dname,loc,LEVEL
    FROM tbl_test    
    START WITH college IS NULL
    CONNECT BY PRIOR deptno=college
    AND dname != '�����̵���к�'; -- �������� �ڽĳ����� ���� 
------------------
1. START WITH �ֻ������� : ������ �������� �ֻ��� ������ ���� �ĺ��ϴ� ����
2. CONNECT BY ���� : ������ ������ � ������ ����Ǵ����� ����ϴ� ����.
   PRIOR : ������ ���������� ����� �� �ִ� ������, '�ռ���, ������'
SELECT empno
   ,LPAD(' ',4*(LEVEL-1))||ename ename
   ,LEVEL
   ,SYS_CONNECT_BY_PATH(ename,'/') ��ü���
   ,CONNECT_BY_ROOT ename
   ,CONNECT_BY_ISLEAF �ڽ�-- 0, 1(������ ���) 
   FROM emp 
   START WITH mgr IS NULL
   CONNECT BY PRIOR empno = mgr; -- top-down ���   
--
3. ORDER SIBLINGS BY : �μ������� ���ĵʰ� ���ÿ� ������ �������� ����
4. CONNECT_BY_ROOT : ������ ���kĿ������ �ֻ��� �ο츦 ��ȯ�ϴ� ������.
5. CONNECT_BY_ISLEAF : CONNECT BY ���ǿ� ���ǵ� ���迡 ���� 
   �ش� ���� ������ �ڽ����̸� 1, �׷��� ������ 0 �� ��ȯ�ϴ� �ǻ��÷�
6. SYS_CONNECT_BY_PATH(column, char)  : ��Ʈ ��忡�� �����ؼ� �ڽ��� ����� 
   ����� ��� ������ ��ȯ�ϴ� �Լ�.
7. CONNECT_BY_ISCYCLE : ����Ŭ�� ������ ������ ����(�ݺ�) �˰����� ����Ѵ�. 
  �׷���, �θ�-�ڽ� ���� �߸� �����ϸ� ���ѷ����� Ÿ�� ���� �߻��Ѵ�.   
  �̶��� ������ �߻��ϴ� ������ ã�� �߸��� �����͸� �����ؾ� �ϴ� ��, 
  �̸� ���ؼ��� 
    ����  CONNECT BY���� NOCYCLE �߰�
    SELECT ���� CONNECT_BY_ISCYCLE �ǻ� �÷��� ����� ã�� �� �ִ�. 
  ��, ���� �ο찡 �ڽ��� ���� �ִ� �� ���ÿ� �� �ڽ� �ο찡 �θ�ο� �̸� 1,
     �׷��� ������ 0 ��ȯ.

-- 1) 7566 JONES�� mgr�� 7839���� 7369��  ����
UPDATE emp
SET mgr = 7369
WHERE empno = 7566;
-- 2)
SELECT  deptno, empno, LPAD(' ', 3*(LEVEL-1)) ||  ename
, LEVEL
, SYS_CONNECT_BY_PATH(ename, '/')
FROM emp   
START WITH  mgr IS NULL
CONNECT BY PRIOR  empno =  mgr   ;
-- 3)
ROLLBACK;
-- 4)
SELECT  deptno, empno, LPAD(' ', 3*(LEVEL-1)) ||  ename
, LEVEL
, SYS_CONNECT_BY_PATH(ename, '/')
, CONNECT_BY_ISCYCLE IsLoop
FROM emp   
START WITH  mgr IS NULL
CONNECT BY NOCYCLE PRIOR  empno =  mgr   ;
--------------------------------------------------------------------
-- ������ ���̽� �𵨸� --
1. DB �𵨸� ���� + �����ۼ� (SQL , PL/SQL)
 - ���� ������ �������� ���μ����� ���������� DBȭ ��Ű�� ����
 ��) �� - �ֹ�/����/��� - ��ǰ
   1) ���Ǽ��� �������μ���( �����䱸�м���)
   2) ������ �𵨸� (ERD)
   3) ���� �𵨸� ( ����ȭ )
   4) ������ �𵨸� ( ������ȭ )
   5) �׽���
2. DB �𵨸� �ܰ�
   1) ���� �м�
     ��. ���� ������ ���� �⺻ ���İ� ��� �ʿ� 
     ��) �������� ����Ʈ + ��
         ���, ���� X
     ��. ���� ������� ���� ó������ ��� ���μ��� �м�
     ��. ����� ���ͺ�
     ��. ��� ����(����, ��ǥ, ����) �ľ��ؼ� �����ͷ� �����Ǿ����� �׸�
         ��Ȯ�ϰ� �ľ� �ʿ�
     ��. ��׶��� ���μ��� �ľ�, �پ��� ������ �پ��� ����� ���� �ľ�
     ��. ������� �䱸 �м��� �ۼ�
   2)
   3)