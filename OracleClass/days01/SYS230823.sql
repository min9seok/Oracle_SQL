--��� ����� ������ ��ȸ�ϴ� DQL
SELECT *
FROM dba_users;
-- 1) ������ ����
SHOW USER;
-- 2) scott ������ tiger ��й�ȣ ���ο� ����� ���� ����

CREATE USER ������ IDENTIFIED BY ��й�ȣ; 
CREATE USER scott IDENTIFIED BY tiger; 

-- CREATE SESSION �ý��� ���� �ο�
-- 1) SYS ���� ����
SHOW USER; 
-- USER��(��) "SYS"�Դϴ�.
-- 2) ���� �ο�
GRANT CREATE SESSION TO scott;
GRANT CONNECT,RESOURCE TO scott;
-- 3) ���� ȸ��
REVOKE CREATE SESSION FROM scott;

-- �̸� ���ǵ� �Ѱ� �ü�������� ��
-- 1) ����Ŭ ��ġ �� �̸� ���ǵ� ���� ��ȸ
SELECT * FROM DBA_ROLES;
  
-- scott ���� ����
--DROP USER scott CASCADE; 
DROP USER scott;