-- ����: ���� - �׽�Ʈ ����  : ORA-28000 ���� �� 
-- HR ������ �����ϰ� �ִ� �������̺� ��ȸ
SELECT * FROM user_tables;
--REGIONS
--COUNTRIES
--LOCATIONS
--DEPARTMENTS
--JOBS
--EMPLOYEES
--JOB_HISTORY

-- HR ������ �����ϰ� �ִ� ���̺� ��ȸ
SELECT * 
FROM all_tables
WHERE OWNER = 'HR';
-- ��� ������ �����ϰ� �ִ� ���̺�
SELECT *
FROM employees;
-- first_name , last_name ��� �� Ǯ������ name ���� ���
SELECT first_name, last_name ,first_name||' '||last_name as name
FROM employees;

SELECT first_name, last_name ,CONCAT(CONCAT(first_name,' '),last_name) as name
FROM employees;

SELECT * FROM REGIONS;

--  ���̺� �ľ��ؼ� �� ���� -- ���� 
