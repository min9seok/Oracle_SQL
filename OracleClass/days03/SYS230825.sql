--����Ŭ ����� Ȯ��
SELECT *
FROM DICTIONARY
--Ű����(�����) ���̺�
SELECT *
FROM V$RESERVED_WORDS
where keyword ='DATE';

SELECT *
FROM emp;

SELECT *
FROM SCOTT.emp;

SELECT *
FROM dba_tables
WHERE OWNER = 'SCOTT';

-- 1) SYS DBA ���� - PUBLIC SYNONYM
-- 2) CREATE PUBLIC SYNONYM arirnag
--  	FOR scott.emp;

SELECT *
FROM arirnag;

-- [PUBLIC] SYNONYM ����
DROP PUBLIC SYNONYM arirnag;

SELECT *
FROM all_synonyms;
FROM user_SYNONYMS;

