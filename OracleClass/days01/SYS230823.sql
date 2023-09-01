--모든 사용자 계정을 조회하는 DQL
SELECT *
FROM dba_users;
-- 1) 관리자 접속
SHOW USER;
-- 2) scott 계정명 tiger 비밀번호 새로운 사용자 계정 생성

CREATE USER 계점명 IDENTIFIED BY 비밀번호; 
CREATE USER scott IDENTIFIED BY tiger; 

-- CREATE SESSION 시스템 권한 부여
-- 1) SYS 계정 접속
SHOW USER; 
-- USER이(가) "SYS"입니다.
-- 2) 권한 부여
GRANT CREATE SESSION TO scott;
GRANT CONNECT,RESOURCE TO scott;
-- 3) 권한 회수
REVOKE CREATE SESSION FROM scott;

-- 미리 정의된 롤과 운영체제에서의 롤
-- 1) 오라클 설치 후 미리 정의된 롤을 조회
SELECT * FROM DBA_ROLES;
  
-- scott 계정 삭제
--DROP USER scott CASCADE; 
DROP USER scott;