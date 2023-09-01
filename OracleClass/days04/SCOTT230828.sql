SELECT num,name
       ,decode(tel,null,'X',tel,'O') tel
       ,nvl2(tel,'O','X') tel
       ,nvl(replace(tel,substr(tel,1),'O'),'X') tel
FROM insa
WHERE buseo = '���ߺ�';
    
    
SELECT SYSDATE
       ,to_char(sysdate,'CC') ����
       ,to_char(sysdate,'SCC') ����
FROM dual;

SELECT '05/01/10'
      ,to_char(to_date('05/01/10','RR/MM/DD'),'YYYY') rr
      ,to_char(to_date('05/01/10','YY/MM/DD'),'YYYY') yy
      
      ,to_char(to_date('01/01/10','RR/MM/DD'),'YYYY') rr
      ,to_char(to_date('01/01/10','YY/MM/DD'),'YYYY') yy
FROM dual;

SELECT *
FROM dept;

SELECT ename
      ,replace(ename,upper('m'),'*')name
FROM emp
--WHERE ename like '%M%'
where ename like upper('%m%');

-- ���� emp ���̺��� ename 'la' ��ҹ��� ���� ���� �մ� ��� ��ȸ
SELECT ename
FROM emp
where regexp_like(ename,'la','i');
--i  ��ҹ��� ���� ���� 
--c ��ҹ��� ���� ���� 
--n period(.)�� ����� 
--m source string�� ���� ���� ���(multiple lines) 
--x whitespace character(���鹮��) ���� 

--����ǥ������ ����� �� �ִ� �Լ�
-- ������ �Լ�
SELECT COUNT(*)
FROM emp;
-- ������ �Լ�( signle row function)
SELECT LOWER(ename)
FROM emp;
--
SELECT *
FROM test
WHERE regexp_like(name,'^[�ѹ�]');
WHERE regexp_like(name,'����$');

-- insa ���̺��� ���ڻ����
WHERE ssn LIKE '7%' AND MOD(substr(ssn,-7,1)),2) == 1;
WHERE REGEXP_LIKE(ssn,'^7.(6)[13579]') 
WHERE REGEXP_LIKE(ssn,'^7\d(5)-[13579]') 

-- insa �� ��,�� ��ȸ 
SELECT *
FROM insa
WHERE name LIKE '��%'
OR name LIKE '��%';

SELECT *
FROM insa
WHERE REGEXP_LIKE(name,'^[����]');
-- insa �� ��,�� ���� ��ȸ 
SELECT *
FROM insa
--WHERE not(name LIKE '��%' OR name LIKE '��%');
WHERE name not LIKE '��%'
AND name not LIKE '��%';

SELECT *
FROM insa
WHERE not REGEXP_LIKE(name,'^[����]');

SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay
--      ,max((sal+nvl(comm,0))) 
FROM emp
--group by deptno,empno,ename
order by pay desc;
-- ALL SQL ������ ���
with temp AS(
SELECT deptno,empno,ename,(sal+nvl(comm,0)) pay
FROM emp
)
SELECT *
FROM temp
WHERE pay >= ALL (SELECT pay FROM temp);

SELECT 
     max(sal+nvl(comm,0)) maxpay
    ,min(sal+nvl(comm,0)) minpay
FROM emp;
--
SELECT deptno, ename, sal+nvl(comm,0) pay
FROM emp
--WHERE sal+nvl(comm,0) = (SELECT max(sal+nvl(comm,0)) FROM emp  );
--WHERE sal+nvl(comm,0) = (SELECT min(sal+nvl(comm,0)) FROM emp  );
WHERE sal+nvl(comm,0) = 5000;

-- ���� ������(SET OPERATOR)
-- 1) �� ���̺��� Į���� ����
-- 2) ���� �Ǵ� �÷� Ÿ�� ����
-- 3) �÷��̸� ��� X
-- 4) ��� ����� ù ���� select �÷����� ���� 
-- ������ : union , all
-- ������ : INTERSECT
-- ������ : MINUS 

SELECT empno,ename,hiredate
FROM emp
union 
SELECT num,name,ibsadate 
FROM insa;

--union �� all�� ������  �ߺ����X,�ߺ����
--INTERSECT
--(2) insa ��õ ��ȸ
SELECT name,city,buseo
FROM insa
WHERE city = '��õ'
--(1) insa ���ߺ� ��ȸ
MINUS 
SELECT name,city,buseo
FROM insa
WHERE buseo = '���ߺ�';

-- ���� insa ���� O ���� X
SELECT name,ssn
       ,decode(mod(substr(ssn,-7,1),2),1,'����',0,'����') gender
--        ,NULLIF(mod(substr(ssn,-7,1),2),1) gender
        , nvl2(NULLIF(mod(substr(ssn,-7,1),2),1),'X','O')gender
FROM insa;
-- ���� ������(SET OPERATOR)
SELECT name,ssn,'O'gender
FROM insa
WHERE mod(substr(ssn,-7,1),2) = 1
union
SELECT name,ssn,'X'gender
FROM insa
WHERE mod(substr(ssn,-7,1),2) = 0;

---------------------------
--1. ����Ŭ �Լ� ����
--2.     ''     ����
--3.     ''     ����
--����
--ROUND(number,n(-n)) ���ڰ��� Ư�� ��ġ���� �ݿø��Ͽ� �����Ѵ�. 
SELECT ROUND(15.193) a
--       ,ROUND(15.193,0)
--        ,ROUND(15.193,-1)
FROM dual;
--TRUNC(number) ���ڰ��� Ư�� ��ġ���� �����Ͽ� �����Ѵ�. 
SELECT TRUNC(15.8193) a
       ,TRUNC(15.8193,1) -- FLOOR(15.8193*10)/10
        ,TRUNC(15.193,-1)
FROM dual;
--CEIL ���ڰ��� �Ҽ��� ù°�ڸ����� �ø��Ͽ� �������� �����Ѵ�. 
SELECT CEIL(15.193) --16
FROM dual;
--FLOOR ���ڰ��� �Ҽ��� ù°�ڸ����� �����Ͽ� �������� �����Ѵ�. 
SELECT FLOOR(15.193) --15
FROM dual;
-- ������ MOD() , REMAINDER()
SELECT MOD(19,4) -- n2-n1*floor(n2/n1)
       ,REMAINDER(19,4) -- n2-n1*round(n2/n1)
FROM dual;
-- ABS() ���밪 , SIGN() ��� 1 ���� -1 0 0 , POWER ���� , SQRT ��Ʈ
SELECT ABS(100),ABS(-100)
       ,SIGN(100),SIGN(-100)
       ,POWER(2,3)
       ,SQRT(2)
FROM dual;
--����
--UPPER ���� �ҹ��ڸ� �빮�ڷ� �ٲپ� �����Ѵ�. 
--LOWER ���� �빮�ڸ� �ҹ��ڷ� �ٲپ� �����Ѵ�. 
--INITCAP ���ڿ��� �� �ܾ��� ù���ڸ� �빮�ڷ� �ٲپ� �����Ѵ�. 
--CONCAT ù��° ���ڿ��� �ι�° ���ڿ��� �����Ͽ� �����Ѵ�. ���� ������(??) ���� 
--SUBSTR ���ڰ� �� Ư�� ��ġ���� Ư�� ���̸�ŭ�� ���ڰ����� �����Ѵ�.

--LENGTH ���ڿ��� ���̸� ���ڰ����� �����Ѵ�. 
SELECT distinct(job)
       ,length(job)
FROM emp;
-- emp ���� ename�� ? ���ڰ� �ִ� ��� ��ȸ 
-- INSTR ? ���ڰ� �ִ� ��ġ �� ��ȸ
SELECT ename
       ,INSTR(ename,'L') job
FROM emp
WHERE regexp_like(ename,'l','i');
WHERE ename like '%M%'

SELECT INSTR('corporate floor','or')  c
      ,INSTR('corporate floor','or',4)  c
      ,INSTR('corporate floor','or',4,2)  c
      ,INSTR('corporate floor','or',-1,2)  c
     FROM dual;
-- RPAD / LPAD (expr1, n [, expr2] )
-- 100 ������ # �߰�
-- 10 ���� �ݿø� # �߰�
SELECT ename
       ,sal+nvl(comm,0) pay
--       ,LPAD(sal+nvl(comm,0),10,'*') pay
--       ,RPAD(sal+nvl(comm,0),10,'*') pay
       ,ROUND(sal+nvl(comm,0),-2) pay
       ,ROUND(sal+nvl(comm,0),-2)/100 pay
       ,RPAD(' ',ROUND(sal+nvl(comm,0),-2)/100+1,'#') pay
FROM emp;
-- LTRIM / RTRIM / TRIM
-- Ư�����ڿ� ��ġ�ϴ� ���ڰ� ���� - �ַ� �������ſ� ���� 
select 'BROWINGyxXxy'
      ,RTRIM('BROWINGyxXxy','xy') "RTRIM example" 
      ,LTRIM('BROWINGyxXxy','xy') "LTRIM example" 
from dual;
SELECT '[' ||'   admin   '||']'a
      ,'[' ||LTRIM('   admin   ')||']'a
      ,'[' ||RTRIM('   admin   ',' ')||']'a
      ,'[' ||TRIM('   admin   ')||']'a
      ,'[' ||LTRIM('xyxyadminxyxy','xy')||']'a
      ,'[' ||RTRIM('xyxyadminxyxy','xy')||']'a      
FROM dual;
-- ASCII , CHR
SELECT ASCII('A'),ASCII('a'),ASCII('0')
      ,CHR(65),CHR(97),CHR(48)
from dual;
-- GREATEST , LEAST ������ ���� ���� ū ���� ������
SELECT GREATEST(3,5,2,4,1)
      ,LEAST(3,5,2,4,1)
      ,GREATEST('MBC','TVC','SBS')
FROM dual;
--replace  a1: �������ڿ� a2: ��ü ���ڿ� a1�߿��� �ٲٱ⸦ ���ϴ� ���ڿ� a3: �ٲٰ��� �ϴ� ���ο� ���ڿ�
--VSIZE ������ ���ڿ��� ũ�⸦ ���ڰ����� �����Ѵ�. BYTE
SELECT VSIZE('a'),VSIZE('��')
FROM dual;
--��¥
--��ȯ
--�Ϲ� , ����ǥ����
--�׷�
---------------------------

