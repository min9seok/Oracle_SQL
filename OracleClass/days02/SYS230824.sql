--
show user;

SElect * from all_users;

SELECT * FROM tables;

SELECT * 
FROM v$sga;

select tablespace_name, file_name from dba_data_files;

-- DB에 설정된 블록 사이즈 조회   8192
show parameter db_block_size;
-- 오라클에 존재하는 테이블 스페이스 이름 조회
select name from v$tablespace;

-- 데이터베이스의 익스텐트를 구성하는 설정에 대한 정보
select owner, segment_name, extent_id, bytes, blocks
from dba_extents;
-- dba 는 관리자만 사용할 수 있다.
SELECT * FROM dba_users;
-- 관리자(SYS) 가 HR 게정 잠금 해제
ALTER USER HR ACCOUNT UNLOCK;
ALTER USER HR IDENTIFIED BY lion;

ALTER USER HR IDENTIFIED BY lion ACCOUNT UNLOCK;
