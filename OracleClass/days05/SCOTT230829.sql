--GREATEST LEAST VSIZE RPAD / LPAD INSTR UPPER LOWER INITCAP CONCAT SUBSTR LENGTH
--ABS MOD REMAINDER ROUND TRUNC CEIL FLOOR NULLIF INTERSECT MINUS REGEXP_LIKE
--ASCII CHR icmnx

-- �� ��� �ѱ޿� 
-- �� ��� ��
-- �� ��� ��ձ޿�
--SELECT sum(sal+nvl(comm,0)) sumpay --27125 
--      ,count(sal+nvl(comm,0)) cnt --12
--      ,avg(sal+nvl(comm,0)) avg-- 2260.4166
--      ,max(sal+nvl(comm,0)) max
--      ,min(sal+nvl(comm,0)) min
--      ,STDDEV(sal+nvl(comm,0)) STDDEV_pay--ǥ������ : �л��� ������(��Ʈ)
--      ,variance(sal+nvl(comm,0)) variance_pay --�л� : ����� (pay - avg_pay)^2�� ���
--FROM emp

--4) LNNVL()
--a=1 FALSE TRUE 
--a=2 TRUE FALSE 
--a IS NULL FALSE TRUE 
--b=1 UNKNOWN TRUE 
--b IS NULL TRUE FALSE 
--a=b UNKNOWN TRUE 


SELECT *
FROM emp e
WHERE sal+NVL(comm,0) = (SELECT max(sal+nvl(comm,0)) FROM emp WHERE e.deptno = deptno);

-- �� �μ��� �ְ� �޿���
SELECT distinct(deptno)
      ,max(sal+nvl(comm,0)) pay
FROM emp
group by deptno
order by 1;

    SELECT  SUBSTR('031)1234-5678'
            ,INSTR('031)1234-5678',')')+1
            ,INSTR('031)1234-5678','-')- INSTR('031)1234-5678',')')-1) a        
    FROM dual;
    
    SELECT deptno,ename
       ,sal+nvl(comm,0) pay       
       ,rpad(round(sal+nvl(comm,0),-2)/100,round(sal+nvl(comm,0),-2)/100+2,'#') bar_length
FROM emp
where deptno = 30
order by 4 desc;
--TRUNC(number) ���ڰ��� Ư�� ��ġ���� �����Ͽ� �����Ѵ�. 
--FLOOR ���ڰ��� �Ҽ��� ù°�ڸ����� �����Ͽ� �������� �����Ѵ�.     
SELECT TRUNC( SYSDATE, 'YEAR' ) a -- ���� ����
      , TRUNC( SYSDATE, 'MONTH' ) b  -- ���� ����
      , TRUNC( SYSDATE,'DAY'  ) c -- �ð� ����
      , TRUNC( SYSDATE  ) d -- �ð� ����
    FROM dual;
    
    SELECT ename,sal,comm 
      ,sal+nvl(comm,0) pay
      ,ROUND((SELECT avg(sal+nvl(comm,0)) FROM emp),5)avg_pay
      ,(SELECT SUM(sal+nvl(comm,0)) FROM emp) sum
--      ,SUM(sal+nvl(comm,0))
FROM emp
WHERE sal+nvl(comm,0) >= ROUND((SELECT avg(sal+nvl(comm,0)) FROM emp),5);

SELECT ename
      ,sal+nvl(comm,0) pay
      ,(SELECT max(sal+nvl(comm,0)) FROM emp) max_pay
      ,sal+nvl(comm,0)/(SELECT max(sal+nvl(comm,0)) FROM emp)  as "�ۼ�Ʈ"    
FROM emp;

SELECT t.*
       ,t.pay/t.max_pay*100||'%' as "�ۼ�Ʈ"
       ,RPAD(round(t.pay/t.max_pay*100/10),round(t.pay/t.max_pay*100/10)+1,'*') as "������"
FROM(
SELECT ename
      ,sal+nvl(comm,0) pay
      ,(SELECT max(sal+nvl(comm,0)) FROM emp) max_pay      
      FROM emp
) t;

-- ���� emp �� pay������ ��� �ű�� 
SELECT t.*
       ,(SELECT count(*)+1
        FROM emp
        WHERE sal+nvl(comm,0)>t.pay ) as pay_RANK
FROM(
SELECT ename
       ,sal+nvl(comm,0) pay
FROM emp 
) t
order by 3;

--��¥ �Լ�
--WW  ���� ���° �� 
--W  ���� ���° �� 
--IW 1���� ��°�� 
SELECT SYSDATE -- ���糯¥,�ð����� ��ȯ �Լ�
      ,to_char(sysdate,'YYYY/MM/DD AM HH24:mi:SS(DAY)')a
      ,to_char(sysdate,'DS TS')b      
      ,to_char(sysdate,'WW')c
      ,to_char(sysdate,'W')c
      ,to_char(sysdate,'IW')c
FROM dual;

--ROUNDSELECT SYSDATE
      ,TO_CHAR(SYSDATE,'DL TS')a
      ,ROUND(sysdate)a
      ,ROUND(sysdate,'MONTH')a
FROM dual;

SELECT SYSDATE
      ,TO_CHAR(SYSDATE,'DL TS')a
      ,ROUND(sysdate)a
      ,ROUND(sysdate,'DD')a
      ,ROUND(sysdate,'MONTH')a
      ,ROUND(sysdate,'YEAR')a
FROM dual;
--TRUNC ( date [,fmt] )
SELECT SYSDATE
      ,TO_CHAR(SYSDATE,'DL TS')a
      ,TRUNC(sysdate)a
      ,TRUNC(sysdate,'DD')a
      ,TRUNC(sysdate,'MONTH')a
      ,TRUNC(sysdate,'YEAR')a
FROM dual;  
-- MONTHS_BETWEEN ��¥���� ������ ����
--��¥ + ���� ��¥ ��¥�� �ϼ��� ���Ͽ� ��¥ ��� 
--��¥ - ���� ��¥ ��¥�� �ϼ��� ���Ͽ� ��¥ ��� 
--��¥ + ����/24 ��¥ ��¥�� �ð��� ���Ͽ� ��¥ ��� 
--��¥ - ��¥ �ϼ� ��¥�� ��¥�� ���Ͽ� �ϼ� ��� 
-- emp �� ������� �ٹ��ϼ�, �ٹ�������, �ٹ���� ��ȸ
SELECT ename,hiredate,sysdate
      ,round(sysdate-hiredate) �ٹ��ϼ� -- ��¥ - ��¥ = �ϼ� 
      ,round(MONTHS_BETWEEN(sysdate,hiredate),1) �ٹ�������
      ,round(MONTHS_BETWEEN(sysdate,hiredate)/12,1) �ٹ����
      ,to_char(sysdate,'YYYY')-to_char(hiredate,'YYYY') �ٹ����
FROM emp;
-- 1�ð� �� ���� ����
SELECT sysdate
      ,to_char(sysdate,'TS')
      ,sysdate +1
      ,to_char(sysdate +1/24,'TS')
FROM dual;

-- ADD_MONTHS(date, month) ��¥ d�� n ������ ���� ���ڸ� ��ȯ�Ѵ�.
SELECT sysdate
      ,ADD_MONTHS(sysdate,3)
      ,ADD_MONTHS(sysdate,-1)
FROM dual;
    
--LAST_DAY ( date ) Ư�� ��¥�� ���� ���� ���� ������ ��¥�� �����ϴ� �Լ� ��¥ 
SELECT sysdate
      ,last_DAY(sysdate) a
      -- �̹��� ������ ��¥ ����, ���ϱ���.. ��ȸ
      ,to_char(last_DAY(sysdate),'DAY')b
      ,to_char(last_DAY(sysdate),'DD')b
      -- �̹��� 1�� ����
      ,to_char(TRUNC(sysdate,'month'),'DAY') c
      ,to_char(last_day(ADD_MONTHS(sysdate,-1))+1,'DAY') d
FROM dual;
-- NEXT_DAY(date,char) ��õ� ������ ���ƿ��� ���� �ֱ��� ��¥�� �����ϴ� �Լ� 
SELECT SYSDATE
      ,TO_CHAR(SYSDATE,'DAY')a
      ,NEXT_DAY(SYSDATE,'��')b
      ,NEXT_DAY(SYSDATE,'ȭ')
FROM dual;
--CURRENT_DATE ������ ��¥�� �ð��� ��� 
SELECT CURRENT_DATE
FROM dual;

-- ���� 23,7,13 (��) ������ ���� 100�� 
SELECT to_char(SYSDATE,'YYYY.MM.DD(DY)')a    
    , to_char(to_date('23.7.13')+100,'YY.MM.DD(DY)')b
    , to_date('23.7.13(��)','YY.MM.DD(DY)')+100 c
    ,to_char(ADD_MONTHS(TRUNC(SYSDATE,'month')-1,-1)+13+100,'YYYY.MM.DD(DY)') d
FROM dual;

--��ȯ �Լ�
--TO_NUMBER ���� Ÿ���� ���� Ÿ������ ��ȯ 
--TO_CHAR(number) ����, ��¥ Ÿ���� ���� Ÿ������ ��ȯ, TO_CHAR(character),TO_CHAR(datetime) 
--TO_DATE ����, ���� Ÿ���� ��¥ Ÿ������ ��ȯ 
--CONVERT ���ڿ��� �� ������ ��� ���Ŀ��� �ٸ� ���� ��� �������� ��ȯ�Ͽ� ���� 
--HEXTORAW 16���� ���ڿ��� 2������ ���ڿ��� ��ȯ 

--DECODE ���� ���� ������ �־� ���ǿ� ���� ��� �ش� ���� �����ϴ� �Լ�
--�� ������ '='�� �����ϴ�
--from ���� ���� ��𿡼��� ����� �� �ִ�.
--PL/SQL ������ ����鿩 ����ϱ� ���Ͽ� ������� ����Ŭ �Լ��̴�.
-- if = decode(x,11,c)
-- if,else = decode(x,11,c,d)
-- if,else if,else = decode(x,11,c,12,d,e)

-- ex) insa �ֹι�ȣ ���� ���� ���
SELECT name,ssn    
    ,decode(mod(substr(ssn,-7,1),2),1,'����','����')gender
FROM insa;

--���� emp 10���μ��� �޿� 15%�λ� 20�� 30%�λ� �׿� �μ� 5%�λ�
SELECT deptno,ename
       ,sal+nvl(comm,0)pay
       ,decode(deptno
       ,10,(sal+nvl(comm,0))*0.15
       ,20,(sal+nvl(comm,0))*0.30
       ,(sal+nvl(comm,0))*0.05 ) as "�λ��"
       ,decode(deptno
       ,10,sal+nvl(comm,0)+(sal+nvl(comm,0))*0.15
       ,20,sal+nvl(comm,0)+(sal+nvl(comm,0))*0.30
       ,sal+nvl(comm,0)+(sal+nvl(comm,0))*0.05)       
       as"�λ�� �޿�"       
FROM emp
order by 1;

-- �Լ�(����, TOP-N ���)
-- ����Ŭ �ڷ���
-- ���̺� ����~ ����, ����
-- ��������
-- ����

--WW ���� ���Ϻ��� ������  
--IW ��ȭ��������� ���� ������ 