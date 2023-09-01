SELECT *
FROM emp;

SELECT *
FROM salgrade;

SELECT deptno,ename,sal,
    CASE
    WHEN sal BETWEEN 700 AND 1200 THEN 1
    WHEN sal BETWEEN 1201 AND 1400 THEN 2
    WHEN sal BETWEEN 1401 AND 2000 THEN 3
    WHEN sal BETWEEN 2001 AND 3000 THEN 4
    WHEN sal BETWEEN 3001 AND 9999 THEN 5
    END grade
FROM emp;

SELECT deptno,ename,sal,losal||'-'||hisal,grade
FROM emp a, salgrade b
WHERE sal BETWEEN b.losal AND b.hisal;


SELECT b.deptno
      ,nvl(LISTAGG(ename, ',') WITHIN GROUP(ORDER BY ename),'��� ����') name
FROM emp a,dept b
WHERE a.deptno(+) = b.deptno
group by b.deptno
order by 1;

---- Grouping SETS
SELECT deptno , COUNT(*)
FROM emp
group by deptno

SELECT job , COUNT(*)
FROM emp
group by job;

SELECT deptno,job
       ,COUNT(*)
FROM emp
group by GROUPING SETS((deptno,job))
order by 1;

-- emp �޿� ���� ���� �޴� ��� ���� ��ȸ
SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay
FROM emp
WHERE (sal+nvl(comm,0)) = ALL(SELECT MAX(sal+nvl(comm,0)) FROM emp);
--WHERE (sal+nvl(comm,0)) >= ALL(SELECT (sal+nvl(comm,0)) FROM emp);

-- RANK ���� �Լ�
-- TOP-N ���...
--1) ORDER BY ���ĵ� �ζ��κ�
--2) ROWNUM �ǻ��÷� - �ึ�� ������� ��ȣ�� �ο��ϴ� �÷�
--3) WHERE ������ > < >= <=

-- �ǻ�(pseudo) �÷�
SELECT rowid
       ,deptno,empno,ename,(sal+nvl(comm,0)) pay
       ,rownum
FROM emp;

SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay       
FROM emp
order by pay desc;

SELECT * 
FROM(
SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay       
FROM emp
order by pay desc
) e
WHERE rownum <=3;

-- ���� �Լ�
-- RANK 
-- DENSE_RANK
-- PERCENT_RNAK
-- FIRST(), LAST()
-- ROW_NUMBER
SELECT *
FROM(
SELECT deptno,ename, (sal+nvl(comm,0)) pay
      ,ROW_NUMBER() OVER(order by (sal+nvl(comm,0)) desc ) �޿�����
FROM emp
) e
WHERE �޿����� BETWEEN 3 AND 5;
WHERE �޿�����  <= 3;
WHERE �޿�����  = 1;

-- ���� emp �ְ�޿� ��� ���� 
SELECT b.deptno,b.dname,ename, (sal+nvl(comm,0)) pay,grade
FROM emp a , dept b , salgrade c
WHERE a.deptno = b.deptno
AND (sal+nvl(comm,0)) = (SELECT max(sal+nvl(comm,0)) FROM emp)
AND a.sal BETWEEN c.losal AND c.hisal;
-- ���� emp �� �μ��� �ְ�޿� ��� ���� 
SELECT b.deptno,b.dname,ename, (sal+nvl(comm,0)) pay,grade
 ,ROW_NUMBER() OVER(order by (sal+nvl(comm,0)) desc ) �޿�����
FROM emp a , dept b , salgrade c
WHERE a.deptno = b.deptno
AND (sal+nvl(comm,0)) = (SELECT max(sal+nvl(comm,0)) FROM emp WHERE deptno = a.deptno)
AND a.sal BETWEEN c.losal AND c.hisal;
-------emp �ְ�޿� ��� ���� 
SELECT *
FROM(
SELECT b.deptno,b.dname,ename, (sal+nvl(comm,0)) pay,grade
,ROW_NUMBER() OVER(order by (sal+nvl(comm,0)) desc ) �޿�����
FROM emp a , dept b, salgrade c
WHERE a.deptno = b.deptno
AND a.sal BETWEEN c.losal AND c.hisal
) e
WHERE �޿�����  = 1;
-----------------emp �� �μ��� �ְ�޿� ��� ���� 
SELECT *
FROM(
SELECT b.deptno,dname, ename, sal+nvl(comm,0) pay,grade
 ,ROW_NUMBER() OVER (PARTITION BY b.deptno order by (sal+nvl(comm,0)) desc) �޿�����
FROM emp a , dept b, salgrade c
WHERE a.deptno = b.deptno
AND a.sal BETWEEN c.losal AND c.hisal
)
WHERE �޿�����  = 1;
------ �����Լ�
-- TOP_N �м�
-- ROW_NUMBEWR() OVER()

-- RANK() DENSE_RANK() �ߺ����� ��� O/X

SELECT empno,ename,sal
     ,ROW_NUMBER() OVER (ORDER BY sal desc) rn_rank
     ,rank() OVER (ORDER BY sal desc) r_rank
     ,DENSE_RANK() OVER (ORDER BY sal desc) dr_rank
FROM emp;

SELECT empno,ename,sal
     ,ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal desc) rn_rank
     ,rank() OVER (PARTITION BY deptno ORDER BY sal desc) r_rank
     ,DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal desc) dr_rank
FROM emp;

-- emp �� ��� �޿��� �μ� ����, �����ü ���� 
SELECT deptno,empno,ename,(sal+nvl(comm,0))pay
     ,rank() OVER (PARTITION BY deptno ORDER BY (sal+nvl(comm,0)) desc) r_rank
     ,rank() OVER (ORDER BY (sal+nvl(comm,0)) desc) r_rank
FROM emp;

-- insa ����� ��� 
���ڻ���� :31
���ڻ���� :29
��ü :60
-----------------�� Ǯ��
SELECT distinct(decode(mod(substr(ssn,-7,1),2)
       ,1,'���ڻ����'
       ,0,'���ڻ����'
       )) a
       ,decode(mod(substr(ssn,-7,1),2)
       ,1,(SELECT COUNT(*) FROM insa WHERE mod(substr(ssn,-7,1),2)=1)
       ,0,(SELECT COUNT(*) FROM insa WHERE mod(substr(ssn,-7,1),2)=0)
       ) b
FROM insa
union
SELECT '��ü',count(*) cnt
FROM insa;
----------------------(1)
SELECT '���ڻ����',count(*) cnt
FROM insa
WHERE mod(substr(ssn,-7,1),2)=1
union
SELECT '���ڻ����',count(*) cnt
FROM insa
WHERE mod(substr(ssn,-7,1),2)=0
union
SELECT '��ü',count(*) cnt
FROM insa;
----------------------(2)
SELECT decode(mod(substr(ssn,-7,1),2)
      ,1,'���ڻ����'
      ,'���ڻ����') gender
      ,count(*) cnt
FROM insa
group by mod(substr(ssn,-7,1),2)
union
SELECT '��ü',count(*) cnt
FROM insa;
----------------------(3) ROLLUP,CUBE �м� �Լ� GROUP BY ��� 
SELECT decode(mod(substr(ssn,-7,1),2)
      ,1,'���ڻ����'
      ,0,'���ڻ����'
      ,'��ü') gender
      ,count(*) cnt
FROM insa
group by CUBE(mod(substr(ssn,-7,1),2));
group by ROLLUP(mod(substr(ssn,-7,1),2));
---
SELECT buseo,jikwi, SUM(basicpay) sum_pay
FROM insa
GROUP BY CUBE(buseo,jikwi)
order by 1;

-- ���� emp ���� ���� �Ի��� ����� ���� �ʰ� �Ի��� ����� ���� �ϼ�
SELECT max(hiredate) a,min(hiredate) b
      ,max(hiredate)-min(hiredate) c
FROM emp
order by 1;
--ROW_NUMBER
WITH a AS(
SELECT hiredate
FROM(
SELECT hiredate
   ,ROW_NUMBER() OVER (ORDER BY hiredate desc) h_rank
FROM emp
) e
WHERE h_rank = 1
),
b AS(
SELECT hiredate
FROM(
SELECT hiredate
   ,ROW_NUMBER() OVER (ORDER BY hiredate asc) h_rank
FROM emp
) e
WHERE h_rank = 1
)
SELECT a.hiredate-b.hiredate
FROM a , b;
--- ���� insa �� ����� �����̸� ����ؼ� ���
-- 1) ssn �ֹε�Ϲ�ȣ
WITH a AS(
SELECT name as"�̸�",ssn as"�ֹε�Ϲ�ȣ"
     ,CASE 
     WHEN substr(ssn,-7,1) in(1,2,5,6) THEN to_char(substr(ssn,1,2),'0099')+1900
     WHEN substr(ssn,-7,1) in(3,4,7,8) THEN to_char(substr(ssn,1,2),'0099')+2000
     ELSE to_char(substr(ssn,1,2),'0099')+1800
     END "����"
     ,TO_CHAR(SYSDATE,'YYYY') as "���س⵵"
     ,SIGN(to_char(sysdate,'mmdd')-substr(ssn,3,4)) as "���Ͽ���"
FROM insa
)
SELECT �̸�,�ֹε�Ϲ�ȣ,����,���س⵵
       ,CASE ���Ͽ���
       WHEN 1  THEN to_char(SYSDATE,'YYYY')-����-1 
       WHEN -1  THEN to_char(SYSDATE,'YYYY')-���� 
       ELSE to_char(SYSDATE,'YYYY')-���� 
       END "����"       
FROM a;
------
SELECT DBMS_RANDOM.RANDOM
      ,DBMS_RANDOM.value as "a" --  0.0 <= �Ǽ�  <1.0
      ,DBMS_RANDOM.value(0,100) as "a" --  0 <= �Ǽ� < 100
      ,DBMS_RANDOM.string('U',5) as "a" --  UPPER 5
      ,DBMS_RANDOM.string('L',5) as "a" --  LOWER 5
      ,DBMS_RANDOM.string('A',5) as "a" --  ���ĺ� 5
      ,DBMS_RANDOM.string('X',5) as "a" --  UPPER+���� 5
      ,DBMS_RANDOM.string('P',5) as "a" --  ���ĺ�+����+Ư�� 5
FROM dual;
SELECT trunc(DBMS_RANDOM.value(0,101)) scroe
      ,trunc(DBMS_RANDOM.value(0,45))+1 lotto
      ,trunc(DBMS_RANDOM.value(150,201)) v
FROM dual;
-- �ǹ�(pivot) ó��
SELECT count(*)
      ,COUNT(DECODE(job,'CLERK','O')) CLERK
      ,COUNT(DECODE(job,'SALESMAN','O')) SALESMAN
      ,COUNT(DECODE(job,'PRESIDENT','O')) PRESIDENT
      ,COUNT(DECODE(job,'MANAGER','O')) MANAGER
      ,COUNT(DECODE(job,'ANALYST','O')) ANALYST
FROM emp;
-- �ǹ�(pivot)
--SELECT * 
--  FROM (�ǹ� ��� ������)
-- PIVOT (�׷��Լ�(�����÷�) FOR �ǹ��÷� IN(�ǹ��÷� �� AS ��Ī...))
SELECT *
FROM(
SELECT job 
FROM emp
)
pivot( 
count(*) 
for job in('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST' ));

SELECT * 
  FROM (SELECT 
         job , 
         TO_CHAR(hiredate, 'FMMM') || '��' hire_month
         FROM emp
       )
   PIVOT(
         count(*)
          FOR hire_month IN ('1��', '2��')
        );

-- emp �� �μ��� �� job ���� �ο��� ���� ���
SELECT *
FROM (
SELECT b.deptno , a.job
FROM emp a ,dept b
WHERE a.deptno(+) = b.deptno
)
PIVOT(
count(*)
for job in('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST' ))
order by 1;


-- ���� ��������
-- ����Ŭ �ڷ���
-- DDL + DML 
-- CONSTRAINT ��������
-- ���� 
-- DB �𵨸� 
-- �Ϸ� �� ������Ʈ
-- PL/SQL