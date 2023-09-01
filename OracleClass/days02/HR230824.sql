-- 상태: 실패 - 테스트 실패  : ORA-28000 계정 락 
-- HR 계정이 소유하고 있는 샘플테이블 조회
SELECT * FROM user_tables;
--REGIONS
--COUNTRIES
--LOCATIONS
--DEPARTMENTS
--JOBS
--EMPLOYEES
--JOB_HISTORY

-- HR 계정이 소유하고 있는 테이블 조회
SELECT * 
FROM all_tables
WHERE OWNER = 'HR';
-- 사원 정보를 저장하고 있는 테이블
SELECT *
FROM employees;
-- first_name , last_name 출력 후 풀네임을 name 으로 출력
SELECT first_name, last_name ,first_name||' '||last_name as name
FROM employees;

SELECT first_name, last_name ,CONCAT(CONCAT(first_name,' '),last_name) as name
FROM employees;

SELECT * FROM REGIONS;

--  테이블 파악해서 각 팀장 -- 제출 
