-- SCOTT --
SELECT (
FROM tabs;

--SQL ���� ���� ����
-- Optimizer �˻�
-- DQL�� : SELECT

-- ��� ����� ���� ��ȸ 
SELECT * FROM all_users;
-- HR ���� (���� ����)
-- ���ӽ� ORA-28000 ���� �� ���� 

-- HR ������ ���� Ȯ��
SELECT * FROM dba_users;

-- DQL : SELECT 
-- 1) ������ �������� �� ����ϴ� SQL��
-- 2) ��� : ���̺� , �� 
-- 3) ����ڰ� ������ ���̺�, �� 
-- 4) SELECT ���� 

SELECT * FROM emp; -- scott.sql ��ũ��Ʈ ���� 

--�����ġ�
--    [subquery_factoring_clause] subquery [for_update_clause];

--��subquery ���ġ�
--   {query_block ?
--    subquery {UNION [ALL] ? INTERSECT ? MINUS }... ? (subquery)} 
--   [order_by_clause] 

--��query_block ���ġ�
--   SELECT [hint] [DISTINCT ? UNIQUE ? ALL] select_list
--   FROM {table_reference ? join_clause ? (join_clause)},...
--     [where_clause] 
--     [hierarchical_query_clause] 
--     [group_by_clause]
--     [HAVING condition]
--     [model_clause]

--��subquery factoring_clause���ġ�
--   WITH {query AS (subquery),...}

--SELECT ���� prototype�� �̰��� �ִ�.


--SQL ���� ��(clause)�̶� �ϴ� �� ���� �������� ����������, SELECT ������ ���Ǵ� ���� ������ ����. 

--? WITH 
--? SELECT 
--? FROM 
--? WHERE 
--? GROUP BY 
--? HAVING 
--? ORDER BY 

-- SELECT �� �� ���� , ó�� ���� 
--1. [? WITH] 
--6.  ? SELECT 
--2. ? FROM 
--3. [? WHERE] 
---- ���� �� [hierarchical_query_clause] 
--4. [? GROUP BY] 
--5. [? HAVING] 
--7. [? ORDER BY] 

-- scott ����ڰ� ������ ���̺� ���� ��ȸ
SELECT * -- ��ȸ�� ��� 
FROM user_tables; -- ��(view) (������ ����)
-- emp (���) ���̺��� ��� ������ ��ȸ
SELECT empno,ename,hiredate
FROM emp;

-- emp ���̺��� ���� Ȯ�� 
DESCRIBE emp;
DESC emp;

-- dept ���̺��� ���� Ȯ��
-- dept ���̺��� ��� �÷��� ��ȸ
DESC dept;
SELECT * FROM dept;

-- emp ���̺��� job(��, �ӹ�,����)�� ��ȸ
-- �� ������� job�� ��ȸ 
SELECT job FROM emp;
SELECT DISTINCT job FROM emp; -- �ߺ�����
-- emp ���̺��� job�� ���� �ľ�
SELECT count(DISTINCT(job)) as job FROM emp;
-- emp ���̺��� �� ����� ����� �Ի����� ��ȸ
SELECT empno,to_char(hiredate,'yyyy-mm-dd') as hiredate from emp;

-- ORA-00942: table or view does not exist
-- emp ���̺� : ��ü �� ������ ������X , SELECT ���� X
SELECT * FROM emp; -- scott.sql ��ũ��Ʈ ���� 

-- ���� emp ���̺��� ����� �μ���ȣ ����� �޿�(sal + comn) 
-- null ó�� �Լ� nvl,nvl2,nullif,coalesce 
SELECT deptno as �μ���ȣ ,ename as �����,
--sal,comm,
--nvl(sal+comm,sal) as pay
--nvl(sal+comm,sal) "pay"
--nvl(sal+comm,sal) "my pay"
nvl(sal+comm,sal) my_pay,
(sal + nvl(comm,0))*12 as anm_s
FROM emp
order by 1;

SELECT deptno as �μ���ȣ ,ename as �����,sal,comm,SUM(sal + nvl(comm,0)) as �޿� FROM emp
group by deptno,ename,comm,sal
order by 1;

-- emp ���̺��� ��� ��������� ��ȸ 
SELECT *
FROM emp;

-- emp ���̺��� deptno 30 �μ����� ��ȸ (deptno,ename,job,hiredate,pay)
SELECT deptno,ename,job,hiredate
,sal+nvl(comm,0) as pay
FROM emp
WHERE deptno = 30;

-- ���� emp ���̺��� 20.30 �μ��� ���� ��ȸ
--SELECT deptno, * ���� ����
SELECT deptno, emp.*
FROM emp
WHERE deptno in(20,30)
--WHERE deptno = 30 OR deptno=20
--WHERE deptno=10 AND job='CLERK' ��ҹ��� ���� 
order by 1;

select * from insa;
--����1) ���� ����� �̸�(name), ��ŵ�(city), �μ���(buseo), ����(jikwi) ��� 
SELECT name,city,buseo,jikwi
FROM insa
where city ='����'
order by 3,1 desc;
--����2) ��ŵ��� ���� ����̸鼭 �⺻���� 150���� �̻��� ��� ��� (name, city, basicpay, ssn) 
SELECT name,city,basicpay,ssn
FROM insa
where city ='����'
and basicpay >= '1500000'
order by 3;
--����3) ��ŵ��� ���� ����̰ų� �μ��� ���ߺ��� �ڷ� ��� (name, city, buseo) 
SELECT name,city,buseo
FROM insa
where city ='����'
or BUSEO = '���ߺ�';
--����4) ��ŵ��� ����, ����� ����� ��� (name, city, buseo) 
SELECT name,city,buseo
FROM insa
where city in('����','���');
--����5) �޿�(basicpay + sudang)�� 250���� �̻��� ���. �� �ʵ���� �ѱ۷� ���. (name, basicpay, sudang, basicpay+sudang) + �޿� �������� ���� 
SELECT name, basicpay, sudang
      ,(basicpay+sudang) as �޿�
FROM insa
where (basicpay+sudang) >= '2500000'
order by 4 desc;

-- ���ӻ�簡 ���� ����� ������ ��ȸ 
-- mgr�� null�� boss �� 
SELECT empno,ename,job,NVL(to_char(mgr),'BOSS') as mgr,hiredate 
FROM emp
WHERE mgr IS NULL;
--WHERE mgr IS NOT NULL;




