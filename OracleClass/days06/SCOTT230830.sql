--���� 1
SELECT distinct(BUSEO)
,(SELECT COUNT(*) FROM insa WHERE buseo = m.buseo) cnt
FROM insa m;
--���� insa ���ڻ��,���ڻ�� �� ��ȸ
--(1) �� Ǯ��
SELECT distinct((SELECT COUNT(*) FROM insa WHERE substr(ssn,-7,1) = substr(m.ssn,-7,1))) cnt
      ,decode(substr(ssn,-7,1),1,'����','����') gender
FROM insa m;
--(2) group by
SELECT decode(substr(ssn,-7,1),1,'����','����') gender
       ,count(*)
FROM insa
group by substr(ssn,-7,1),1;

SELECT COUNT(*) "��ü"
      ,COUNT(decode(MOD(substr(ssn,-7,1),2),1,'����')) "����"
      ,COUNT(decode(MOD(substr(ssn,-7,1),2),0,'����')) "����"
FROM insa;

SELECT decode(substr(ssn,-7,1),1,'����') gender
FROM insa;

SELECT count(*)
    ,count(mgr)
FROM emp;

SELECT decode(MOD(substr(ssn,-7,1),2),1,'O')
FROM insa;

SELECT deptno,count(*)
FROM emp
GROUP BY deptno
union
SELECT null,count(*)
FROM emp
order by 1;
-- ���� dept�� ���缭 �μ� �ο� ��ȸ
SELECT  b.deptno
        ,(SELECT COUNT(*) FROM emp WHERE deptno = b.deptno) "�ο�"
FROM dept b
group by b.deptno;
--
SELECT COUNT(*)
       ,COUNT(decode(deptno,10,'O')) a
       ,COUNT(decode(deptno,20,'O')) b
       ,COUNT(decode(deptno,30,'O')) c
       ,COUNT(decode(deptno,40,'O')) d
FROM emp;

--�Ǻ�(pivot)��� �����ڷḦ ���η� 
--COUNT(*) 10 20 30 40
---------------------------
--12 3 3 6 0

--���� 2
SELECT BUSEO,basicpay+sudang pay      
FROM insa m
WHERE basicpay+sudang = 
(SELECT max(basicpay+sudang)FROM insa WHERE m.buseo=buseo);

SELECT num,name,ssn
      ,replace(ssn,substr(ssn,3,4),to_char(sysdate,'mmdd'))
FROM insa
WHERE num in (1001,1002);

SELECT
     distinct((SELECT COUNT(*) FROM insa WHERE substr(ssn,3,4) < 0830)) "������ �����"
     ,(SELECT COUNT(*) FROM insa WHERE substr(ssn,3,4) > 0830) "������ �����"
     ,(SELECT COUNT(*) FROM insa WHERE substr(ssn,3,4) = 0830) "���� ���� �����"
FROM insa;        

WITH temp AS(
SELECT num,name,ssn
,sign(to_char(sysdate,'mmdd') - substr(ssn,3,4)) s
FROM insa
)
SELECT COUNT(DECODE(s,-1,'O')) " ���� �� �����"
       ,COUNT(DECODE(s,1,'O')) " ���� �� �����"
       ,COUNT(DECODE(s,0,'O')) " ���� ���� ����� "
       ,COUNT(*) "��ü �����"
FROM temp;

     SELECT round((sysdate-to_date('1997/06/22')),2) �ϼ�
      ,round(MONTHS_BETWEEN(sysdate,'1997/06/22'),2) ����
      ,round(MONTHS_BETWEEN(sysdate,'1997/06/22')/12,2) ���
FROM dual;

SELECT SYSDATE
      ,TO_CHAR(SYSDATE,'W')
      FROM dual;

SELECT TO_CHAR(TO_DATE('2022.1.1'),'IW') a
      ,TO_CHAR(TO_DATE('2022.1.1'),'WW') a
      ,TO_CHAR(TO_DATE('2022.1.2'),'IW') a
      ,TO_CHAR(TO_DATE('2022.1.2'),'WW') a
      ,TO_CHAR(TO_DATE('2022.1.3'),'IW') a
      ,TO_CHAR(TO_DATE('2022.1.3'),'WW') a
      ,TO_CHAR(TO_DATE('2022.1.8'),'IW') a
      ,TO_CHAR(TO_DATE('2022.1.8'),'WW') a
FROM dual;

SELECT SYSDATE
      ,LAST_DAY(SYSDATE)
      ,TO_CHAR(LAST_DAY(SYSDATE),'DD')
      , ADD_MONTHS(SYSDATE,1)
FROM dual;

SELECT TO_DATE('2022','YYYY') a
      ,TO_DATE('2022.02','YYYY.MM')a
      ,TO_DATE('02','DD')a
FROM dual;

SELECT  sal+nvl(comm,0) pay      
       ,sal+nvl2(comm,comm,0) pay       
       ,sal+COALESCE(comm,0)pay
       ,COALESCE(sal+comm,sal,0) pay
FROM emp;

SELECT name, ssn
	,CASE 
    WHEN mod(substr(ssn,-7,1),2)=1 THEN '����'			      
			  ELSE '����'
	END gender
    ,CASE mod(substr(ssn,-7,1),2)
    WHEN 1 THEN '����'
    ELSE '����'
    END gender
FROM insa;

SELECT num,name ,ssn      
--      ,decode(SIGN(substr(ssn,3,4)-to_char(sysdate,'mmdd')),-1,'���� ��',1,'���� ��','���� ����') c
    ,CASE
    WHEN  to_char(sysdate,'mmdd') > substr(ssn,3,4) THEN '���� ��'
    WHEN  to_char(sysdate,'mmdd') < substr(ssn,3,4) THEN '���� ��'
    WHEN  to_char(sysdate,'mmdd') = substr(ssn,3,4) THEN '���� ����'
    END b
FROM insa;

SELECT to_char(sum(sal+nvl(comm,0)),'L999,999') pay
FROM emp
WHERE sal+nvl(comm,0) >=(
SELECT to_char(avg(sal+nvl(comm,0)),'9999.00')
FROM emp
);

--�����̶� �ϴٰ� �Ѿ 
WITH a AS(
SELECT to_char(avg(sal+nvl(comm,0)),'9999.00') avg_pay
FROM emp
),
b AS(
SELECT empno,ename,sal+nvl(comm,0) pay
FROM emp
)
SELECT *
FROM b,a
WHERE b.pay >= a.avg_pay;
SELECT sum(pay)
FROM(
SELECT empno,ename,sal+nvl(comm,0) pay
FROM emp
WHERE sal+nvl(comm,0) >= ( 
SELECT avg(sal+nvl(comm,0)) FROM emp
)
);

WITH temp AS(
SELECT empno,ename
       ,sal+nvl(comm,0) pay
       ,(SELECT avg(sal+nvl(comm,0))FROM emp ) avg_pay
FROM emp
)
SELECT sum(decode(SIGN(t.pay-t.avg_pay),-1,null,t.pay)) sp
      ,sum(
      CASE
      WHEN SIGN(t.pay-t.avg_pay) >=0   THEN t.pay
      ELSE null
      END 
      ) d
FROM temp t;

SELECT deptno
FROM dept
MINUS
SELECT deptno
FROM emp;

--JOIN
SELECT a.deptno,dname,empno,ename,hiredate
FROM emp a,dept b
WHERE a.deptno = b.deptno;
--
SELECT a.deptno,dname,empno,ename,hiredate
FROM emp a JOIN dept b
ON a.deptno = b.deptno;

--15, 15-2 JOIN�̿��� Ǯ�� 
SELECT a.deptno , count(empno)
FROM dept a LEFT JOIN emp b
ON a.deptno = b.deptno
group by a.deptno
having count(empno) =0
order by 1;

SELECT buseo,jikwi, count(*)
FROM insa
group by buseo,jikwi
order by 1,2;


  SELECT deptno,ename,sal+nvl(comm,0)
       ,decode(deptno
              ,10,15
              ,20,10
              ,30,5
              ,40,20) ||'%'
              as "�λ��"
      ,decode(deptno
              ,10,(sal+nvl(comm,0))*0.15 
              ,20,(sal+nvl(comm,0))*0.10
              ,30,(sal+nvl(comm,0))*0.05
              ,40,(sal+nvl(comm,0))*0.20) 
              as "�λ��"
FROM emp
order by deptno;

  SELECT deptno,ename,sal+nvl(comm,0)
         ,(sal+nvl(comm,0)) * (CASE deptno
         WHEN 10 THEN 0.15
         WHEN 20 THEN 0.10
         WHEN 30 THEN 0.05
         WHEN 40 THEN 0.20
         END) as "�λ��"
FROM emp

