SELECT empno,ename,hiredate
      ,to_char(hiredate)
FROM emp
where substr(hiredate,1,2) = 81;

select to_char(sysdate,'HH'), to_char(sysdate,'HH12'), 
         to_char(sysdate,'HH24') from dual;

-- SUBSTR ����
SELECT Substr('abcdesfg', 3,2)  -- 'cd'
      ,Substr('abcdesfg', 3) -- 'cdefg'
      ,Substr('abcdesfg', -3,2) -- 'sf'
FROM dual;

-- ���� insa ���� �̸� �ֹε�Ϲ�ȣ ��ȸ �ֹι�ȣ 111111-2******,�⵵ �� �� ���� ���� ��ȸ

SELECT name,ssn
      ,SUBSTR(ssn,1,8) || '******' s
      ,CONCAT(SUBSTR(ssn,1,8),'******') c      
      ,REPLACE(ssn,SUBSTR(ssn,9),'******') r
      ,SUBSTR(ssn,1,2) year
      ,SUBSTR(ssn,3,2) month
--      ,SUBSTR(ssn,5,2) as "DATE" -- ����� ��� �� 
      ,SUBSTR(ssn,5,2) day
      ,SUBSTR(ssn,8,1) gender
      ,SUBSTR(ssn,-1) regx
FROM insa;
-- 771212-1022432 ����⵵ 1�̸� 1900 3�̸� 2000

SELECT empno,ename,job
        ,nvl(to_char(mgr),'CEO') mgr
        ,hiredate,sal,comm,deptno
FROM emp;

SELECT 'ABcD'
,UPPER('abcd')
,lower('ABcD')
,INITCAP('ABcD')
FROM dual;

TO_CHAR

SELECT name
       , basicpay+sudang pay
       , to_char(basicpay+sudang)pay 
       , to_char(basicpay+sudang,'9,999')pay 
       , to_char(basicpay+sudang,'L99,999,999')pay 
       , ibsadate
FROM insa;

-- ����Ŭ �ڷ��� 
-- ����Ŭ ������
-- 1) ��������� + - * / ������ ������ X �Լ� : MOD()
SELECT 1+2 -- 3
      , 1-2 -- -1
      , 1*2 -- 2
      , 1/2 d -- 0.5
--      , 2/0 -- ORA-01476: divisor is equal to zero
--      , 3.14/0
--      , 1%2 -- ������ ORA-00911: invalid character
      , MOD(1,2) 
FROM dual;

--2) ���� ���ڿ�
DROP TABLE ���̺�� CASCADE; -- DDL ���� �ڵ����� ���� ����,PL/SQL

SELECT ' DROP TALBE ' || table_name || ' CARCATE; '
FROM user_tables;
 DROP TALBE DEPT CARCATE; 
 DROP TALBE EMP CARCATE; 
 DROP TALBE BONUS CARCATE; 
 DROP TALBE SALGRADE CARCATE; 
 DROP TALBE INSA CARCATE; 
 
--3) ����� ���� ������ 
CREATE OPERATOR ������ �����ڸ� ������ �� ���� 

--4) ������ ���� ������  
PRIOR, CONNECT_BY_ROOT�� ������ ���� �������� 

--5) �� ������ = != <> ^= > < <= >=
 SQL������
 ANY, SOME -- ���������� ������ �ϳ��� �����ϸ� ���
 ALL -- ���������� ������ ���� �����ؾ� ��� 

SELECT deptno
FROM dept;

SELECT *
FROM emp
WHERE deptno > ANY( SELECT deptno FROM dept );
WHERE deptno <= ANY( SELECT deptno FROM dept );
WHERE deptno <= ALL( SELECT deptno FROM dept );
WHERE deptno �񱳿����� ALL ( �������� );
where deptno <= 20;

--6) �� ������ AND OR NOT
--7) SQL ������
 (NOT) IN  
 (NOT)BETWEEN a AND b  
 is (NOT) null  
 ANY,SOME,ALL
 EXISTS ��� �������� 
 (NOT) LIKE -- wildcard(%,_) ESCAPE �ɼ��� ��� ���� ���� ��ġ �˻� 
 REGEXP_LIKE - �Լ�
 ex) emp ���̺� R �� �����ϴ� ��� , insa ����� �� ��� 
 
 SELECT *
 FROM insa
 where ssn like '81%'
-- ���� insa ���̺� ���ڻ�� ��ȸ
SELECT *
FROM insa
where substr(ssn,8,1) = 1;
-- ���� �̸� �ι�° ���� �� ��ȸ
SELECT *
FROM insa
WHERE name like '_��%'

-- ���ο� �÷�(�μ�)�� �߰� 
INSERT INTO ���̺�� (�÷���) VALUES(��...);
INSERT INTO dept (deptno,dname,loc) VALUES('50','�ѱ�_����','SEOUL');
INSERT INTO dept (deptno,dname,loc) VALUES('60','��100%��','SEOUL');

-- �˻�: �μ���(dname)�� '_��' �˻�
SELECT *
FROM dept
WHERE dname like '%\_��%' ESCAPE '\' ;

-- ����) �μ��� % �μ� �˻� 
SELECT *
FROM dept
WHERE dname like '%\%%' ESCAPE '\' ;

UPDATE ���̺�� 
set �÷��� = ��
WHERE ������ 
UPDATE dept
set loc = 'KOREA'
WHERE loc = 'SEOUL'


-- ����Ŭ �Լ�


-- dual? PUBLIC SYSNONYM
-- SCOTT ����ڰ� ������ ���̺� ���� ��ȸ
-- dba_XXX, all_XXX, user_XXX ������ DB������,DB��ü,DB������  
SELECT *
FROM user_tables; -- DB�����ڰ� ������ ���̺�
FROM dba_tables; -- ORA-00942: table or view does not exist DB�����ڰ� ����� �� �ִ� ���̺�
FROM all_tables; -- DB������ + ������ �ο����� ���̺�

-- 3) SCOTT ����
-- 4) �ó�Կ� ������ �ο�

GRANT SELECT ON emp TO HR;

SELECT *
FROM arirnag

