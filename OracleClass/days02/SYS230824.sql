--
show user;

SElect * from all_users;

SELECT * FROM tables;

SELECT * 
FROM v$sga;

select tablespace_name, file_name from dba_data_files;

-- DB�� ������ ��� ������ ��ȸ   8192
show parameter db_block_size;
-- ����Ŭ�� �����ϴ� ���̺� �����̽� �̸� ��ȸ
select name from v$tablespace;

-- �����ͺ��̽��� �ͽ���Ʈ�� �����ϴ� ������ ���� ����
select owner, segment_name, extent_id, bytes, blocks
from dba_extents;
-- dba �� �����ڸ� ����� �� �ִ�.
SELECT * FROM dba_users;
-- ������(SYS) �� HR ���� ��� ����
ALTER USER HR ACCOUNT UNLOCK;
ALTER USER HR IDENTIFIED BY lion;

ALTER USER HR IDENTIFIED BY lion ACCOUNT UNLOCK;
