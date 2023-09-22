--13.  emp ���̺��� 30���� �μ��� �ְ�, ���� SAL�� ����ϴ� ���� �ۼ�.
SELECT max(sal),min(sal)
FROM emp
WHERE deptno =30;
--13-2. emp ���̺��� 30���� �μ��� �ְ�, ���� SAL�� �޴� ����� ���� ����ϴ� ���� �ۼ�.
SELECT deptno,empno,ename,job,mgr,hiredate,sal
FROM emp a
WHERE deptno =30
AND sal IN( (SELECT max(sal) FROM emp WHERE deptno=30)
          ,(SELECT min(sal) FROM emp WHERE deptno=30));
-----------------------------
WITH temp AS(
SELECT max(sal) maxsal,min(sal) minsal
FROM emp
WHERE deptno =30
)
SELECT empno , ename, hiredate ,sal
FROM temp t , emp e
WHERE e.deptno=30
AND e.sal IN (t.maxsal,t.minsal);

--14. emp ���̺��� ������� �������� �μ���� �����, ���� ���� �μ���� ����� ���
select b.deptno
       ,count(ename) cnt       
       ,RANK() OVER(order by count(empno) desc) cnt_rank
from emp a , dept b
WHERE a.deptno(+) = b.deptno
group by b.deptno
having count(empno) = max(empno)
order by 1;
------------------
SELECT *
FROM(
SELECT b.deptno , count(empno) cnt
       ,RANK() OVER(order by count(empno) desc) cnt_rank
FROM emp a,dept b
WHERE a.deptno(+) = b.deptno
group by b.deptno
order by 1
) t
WHERE cnt_rank in (1,(SELECT COUNT(*) FROM dept));
-----------------------(1)
WITH temp AS(
SELECT d.deptno , dname , count(empno) cnt
FROM emp e , dept d
WHERE e.deptno(+) = d.deptno
group by d.deptno, dname
)
SELECT *
FROM temp
WHERE cnt IN ( (SELECT max(cnt) FROM temp)
              ,(SELECT min(cnt) FROM temp));
-------------------------(2)
WITH a AS(
SELECT d.deptno , dname , count(empno) cnt
FROM emp e , dept d
WHERE e.deptno(+) = d.deptno
group by d.deptno, dname
), b AS(
SELECT MIN(cnt) mincnt , max(cnt) maxcnt
FROM a
)
SELECT a.deptno , a.cnt
FROM a,b
WHERE a.cnt in( b.maxcnt,b.mincnt)
order by 1;
------------------------(3) �м��Լ� FIRST , LAST
-- �����Լ��� ���Ǹ� �־��� �׷쿡 ���� ������ ������ �Ű� ��� ����
--���̺� �ִ� �࿡ ���� Ư�� �׷캰�� ���谩�� ������ �� ����ϴ� �Լ�
WITH a AS(
SELECT d.deptno , dname , count(empno) cnt
FROM emp e , dept d
WHERE e.deptno(+) = d.deptno
group by d.deptno, dname
)
SELECT 
   MIN(deptno) KEEP(DENSE_RANK FIRST ORDER BY cnt ) deptno
  ,MIN(cnt)
  ,MAX(deptno) KEEP(DENSE_RANK LAST ORDER BY cnt  ) deptno
  ,MAX(cnt)
FROM a;
---------------------- 
--ROW_NUMBER()
--RANK()
--DENSE_RANK()
--CUME_DIST() : �־��� �׷쿡 ���� ������� ���� ������ ��(���� 0< �� <=1)�� ��ȯ  
--�μ��� �޿��� ���� ���� ������ ��
SELECT deptno,ename,sal
      ,CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_dist      
FROM emp;
-- PERCENT_RANK() : �ش� �׷� �� ����� ����(0<= �� <=1) 
--�׷� �ȿ��� �ش� �ο� ������ ���� ���� ����
SELECT deptno,ename,sal
      ,PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal ) PERCENT
FROM emp;
-- ��
SELECT deptno,ename,sal
      ,CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal) dept_dist      
      -- ������� ��(1,(1+1),4,5,6) / �� �� (6)
      ,PERCENT_RANK() OVER(PARTITION BY deptno ORDER BY sal ) PERCENT
      -- ������(�ߺ��� �ϳ����÷�)(1,(�ߺ�2),3,4,5) / �Ѱ�(5)
FROM emp
WHERE deptno = 30;
-- NTILE(expr 3) : ��Ƽ�Ǻ��� expr�� ��õ� ��ŭ ������ ����� ��ȯ  ���Ҽ�(��Ŷ bucket)
SELECT deptno,ename,sal
   ,NTILE(4) OVER (ORDER BY sal) NTILE
FROM emp;

SELECT buseo,name,basicpay
   ,NTILE(2) OVER (PARTITION BY buseo ORDER BY basicpay) NTILE
--   ,NTILE(2) OVER (ORDER BY basicpay) NTILE
FROM insa;
--- WIDTH_BUCKET(expr,min_value,max_value,num_buckets)
--NTILE() �� ������ �Լ� ������ :(�÷�, �ּ�, �ִ밪 ���� ����,N)
SELECT deptno,ename,sal
     ,NTILE(4) OVER(ORDER BY sal) ntiles
     ,WIDTH_BUCKET(sal, 0, 5000, 4) widthbucker
FROM emp;
--LAG(expr,offset,default_value) 
-- �־��� �׷�� ������ ���� �ٸ� ��(��)�� �ִ� ���� ����
--LEAD(expr,offset,default_value)
-- �־��� �׷�� ������ ���� �ٸ� ��(��)�� �ִ� ���� ����
SELECT ename,hiredate,sal
  ,LAG(sal,1,0) OVER (ORDER BY hiredate) lag_sal
  ,LAG(sal,2,-1) OVER (ORDER BY hiredate) lag_sal
  ,LEAD(sal,1,-1) OVER (ORDER BY hiredate) lead_sal
FROM emp
WHERE deptno=30;
----
SELECT '***ADMIN***'
     ,replace('***ADMIN***','*','') replace
     ,replace('***AD**MIN***','*','') replace
     ,TRIM('*' FROM '***AD*MIN***') trim
     ,TRIM(' ' FROM '    ADMIN    ') trim
     
FROM dual;
--- ����Ŭ �ڷ���
CHAR[(size[BYTE ? CHAR])]
CHAR
CHAR(10)
CHAR(10 byte)
CHAR(10 char)
char varchar number float long date timestamp ;




INSERT INTO test values('a','bb','cc');
insert into test values('b','��','�츮��');


SELECT *
FROM test;
