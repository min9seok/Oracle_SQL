--오라클 예약어 확인
SELECT *
FROM DICTIONARY
--키워드(예약어) 테이블
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

-- 1) SYS DBA 접속 - PUBLIC SYNONYM
-- 2) CREATE PUBLIC SYNONYM arirnag
--  	FOR scott.emp;

SELECT *
FROM arirnag;

-- [PUBLIC] SYNONYM 삭제
DROP PUBLIC SYNONYM arirnag;

SELECT *
FROM all_synonyms;
FROM user_SYNONYMS;

