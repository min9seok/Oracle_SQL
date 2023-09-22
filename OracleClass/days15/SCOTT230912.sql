--1) Ʈ���� A�۾� ���� (�ڵ�)> B�۾� ����
2)��ġ �ʴ� ����ڰ� ������ �ʴ� �۾� X
3)��) �ٹ��ð�(9~18) ��,�ָ����� I,U,D �۾� X 
4)
trigger�� � �۾���, �Ǵ� �۾� �� trigger�� ������ ������ �����Ű�� PL/SQL ���̴�.
trigger�� ���̺� �̸� ������ � �̺�Ʈ�� �߻��� �� Ȱ���ϵ����� ��ü�� �ǹ��Ѵ�.    
5)�����
BEFORE  ������ �����ϱ� ���� Ʈ���Ÿ� ����  
AFTER  ������ ������ �Ŀ� Ʈ���Ÿ� ���� 
FOR EACH ROW  �� Ʈ�������� �˸�  �� ���� ó�� 
REFERENCING  ����޴� ���� ���� ���� 
:OLD  ���� �� ���� �� 
:NEW  ���� �� ���� �� 
��)
CREATE OR REPLACE TRIGGER test_trigger
BEFORE 
INSERT OR UPDATE OR DELETE ON tbl_emp
BEGIN
 IF TO_CHAR(SYSDATE,'DY') IN ('ȭ','��') THEN
  dbms_output.put_line('�ָ����� �����͸� ������ �� �����ϴ�...');
 END IF;
END;
DELETE FROM tbl_emp
WHERE empno = 7844;
INSERT INTO tbl_emp (empno)values(9999);
DROP trigger test_trigger;
--
CREATE TABLE EXAM1 (
   id NUMBER PRIMARY KEY
    ,name VARCHAR2(20)
);

CREATE TABLE exam2 (
   memo VARCHAR2(100)
    ,ilja DATE DEFAULT SYSDATE
);
��) exam1 �� i,u,d ����� �ڵ����� exam2 �� �α� ����ϴ� Ʈ����

CREATE OR REPLACE TRIGGER ut_exam1
AFTER 
INSERT OR UPDATE OR DELETE ON exam1
--for each row ��Ʈ���� when Ʈ���� ����
BEGIN
IF INSERTING THEN
 INSERT INTO exam2 (memo) VALUES('�߰�');
ELSIF UPDATING THEN
 INSERT INTO exam2 (memo) values('����');
ELSIF DELETING THEN
 INSERT INTO exam2 (memo) values('����');
END IF;
END;
insert into exam1 (id,name) values(1,'aaa');
insert into exam1 (id,name) values(2,'bbb');
insert into exam1 (id,name) values(3,'ccc');
UPDATE exam1 set name = 'xxx' where id =3;
DELETE FROM exam1;
SELECT * from exam1;
SELECT * from exam2;
--
CREATE OR REPLACE TRIGGER ut_Exam2
   BEFORE INSERT OR DELETE OR UPDATE ON EXAM1
BEGIN   
   IF TO_CHAR(SYSDATE, 'DAY') IN ('�����', '�Ͽ���') OR
       TO_CHAR(SYSDATE, 'hh24')<12 OR
       TO_CHAR(SYSDATE, 'hh24')>=18 THEN
       raise_application_error(-20000, '������ �ٹ��ð��� �ƴϱ⿡ �ڷ� �Է�(����, ����)�� �ȵǴ� �ð��Դϴ�!');
    END IF;
END;
drop trigger ut_exam1;
drop trigger ut_exam2;
drop table exam1;
drop table exam2;
--�� Ʈ���� �ۼ��� ���� ���̺� �ۼ�
CREATE TABLE test1 (
   hak VARCHAR2(10) PRIMARY KEY
    ,name VARCHAR2(20)
    ,kor NUMBER(3)
    ,eng NUMBER(3)
    ,mat NUMBER(3)
);

CREATE TABLE test2 (
   hak VARCHAR2(10) PRIMARY KEY
    ,tot NUMBER(3)
    ,ave NUMBER(4,1)
    ,CONSTRAINT fk_test2_hak FOREIGN KEY(hak) REFERENCES TEST1(hak)
);
-- test1 �� �� �л��� �й�,�̸�,��,��,�� INSERT �ϸ� trigger�� test2�� ��,�� insert
CREATE or replace trigger uf_instest1
AFTER INSERT OR UPDATE  on test1
 for each row
DECLARE
 vtot NUMBER(3);
 vave number(5,2);
begin
 vtot := :new.kor+:new.eng+:new.mat;
 vave := vtot/3;
 IF INSERTING THEN
 INSERT INTO test2(hak,tot,ave)values(:new.hak,vtot,vave);
 ELSIF UPDATING THEN
 UPDATE test2 set tot= vtot, ave=vave where hak=:OLD.hak;
 END IF;
END;
INSERT INTO TEST1(hak, NAME, kor, eng, mat) VALUES ('1', 'a', 100, 70, 80);
INSERT INTO TEST1(hak, NAME, kor, eng, mat) VALUES ('2', 'b', 80, 80, 80);
UPDATE TEST1 SET kor=20, eng=20, mat=20 WHERE hak=1;
DELETE FROM test1 where hak=1;
SELECT * FROM test1;
SELECT * FROM test2;
--
CREATE or replace trigger uf_deltest1
BEFORE DELETE on test1
 for each row
begin
  DELETE FROM test2 WHERE hak = :old.hak;
END;
-----------------------------------Ʈ���� �ǽ� ����
-- ��ǰ ���̺� �ۼ�
CREATE TABLE ��ǰ (
   ��ǰ�ڵ�        VARCHAR2(6) NOT NULL PRIMARY KEY
  ,��ǰ��           VARCHAR2(30)  NOT NULL
  ,������        VARCHAR2(30)  NOT NULL
  ,�Һ��ڰ���  NUMBER
  ,������     NUMBER DEFAULT 0
);

-- �԰� ���̺� �ۼ�
CREATE TABLE �԰� (
   �԰��ȣ      NUMBER PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�԰�����     DATE
  ,�԰����      NUMBER
  ,�԰�ܰ�      NUMBER
);

-- �Ǹ� ���̺� �ۼ�
CREATE TABLE �Ǹ� (
   �ǸŹ�ȣ      NUMBER  PRIMARY KEY
  ,��ǰ�ڵ�      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�Ǹ�����      DATE
  ,�Ǹż���      NUMBER
  ,�ǸŴܰ�      NUMBER
);

-- ��ǰ ���̺� �ڷ� �߰�
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('AAAAAA', '��ī', '���', 100000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('BBBBBB', '��ǻ��', '����', 1500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('CCCCCC', '�����', '���', 600000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('DDDDDD', '�ڵ���', '�ٿ�', 500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
         ('EEEEEE', '������', '���', 200000);
-- �԰����̺� �Է½� ��ǰ���̺� ������� ���� Ʈ���� �ʿ� 
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER
INSERT ON �԰�
FOR EACH ROW
begin
update ��ǰ set ������=������+:NEW.�԰���� where ��ǰ�ڵ�=:NEW.��ǰ�ڵ�;
end;
--
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (1, 'AAAAAA', '2004-10-10', 5,   50000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (2, 'BBBBBB', '2004-10-10', 15, 700000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (3, 'AAAAAA', '2004-10-11', 15, 52000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (4, 'CCCCCC', '2004-10-14', 15,  250000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (5, 'BBBBBB', '2004-10-16', 25, 700000);
COMMIT;
delete from �԰� where �԰��ȣ =5;
SELECT * FROM ��ǰ;

SELECT * FROM �԰�;
-- ���� 
update �԰�
set �԰���� = 20
where �԰��ȣ =5;
-- ut_upipgo
create or replace trigger ut_upipgo
after update on �԰�
for each row
begin
update ��ǰ set ������=������+:NEW.�԰����-:OLD.�԰���� where ��ǰ�ڵ�=:NEW.��ǰ�ڵ�;
end;
-- �԰� ���̺� �԰� ��� ���� ��ǰ���̺� ������ ����
create or replace trigger ut_delipgo
after delete on �԰�
for each row
begin
update ��ǰ set ������=������-:OLD.�԰���� where ��ǰ�ڵ�=:OLD.��ǰ�ڵ�;
end;
delete �԰�
where �԰��ȣ=5;
--
1) ���ǰ �ǸŽ� �Ǹŵ� ��ǰ�� ������ ���� ut_inspan
create or replace trigger ut_inspan
--after insert on �Ǹ�
before insert on �Ǹ� -- ����� Ǯ��
FOR EACH ROW
DECLARE -- ����� Ǯ��
qty NUMBER; -- �����ǰ ������� �����Ǯ��
BEGIN
--�����Ǯ��
 SELECT ������ INTO qty
 FROM ��ǰ
 WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�; 
 IF qty >= :NEW.�Ǹż��� THEN
 update ��ǰ set ������ = ������-:NEW.�Ǹż��� where ��ǰ�ڵ�=:NEW.��ǰ�ڵ�;
 ELSE
 RAISE_APPLICATION_ERROR(-20000,'������ �������� �Ǹ� ����');
 END IF;
--update ��ǰ set ������ = ������-:NEW.�Ǹż��� where ��ǰ�ڵ�=:NEW.�ǸŹ�ȣ;
END;
--
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
               (1, 'AAAAAA', '2004-11-10', 5, 1000000);
SELECT * FROM ��ǰ;               
SELECT * FROM �Ǹ�;
2) AAAAAA 5 �Ǹ� insert > 10 ���� , ��ǰ���̺� ������ ����
CREATE or replace trigger ut_uppan
before update on �Ǹ�
FOR EACH ROW
DECLARE
qty NUMBER;
begin
SELECT ������ INTO qty
 FROM ��ǰ
 WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�; 
 IF (qty + :OLD.�Ǹż���) >= :NEW.�Ǹż��� THEN
 update ��ǰ set ������ = (������ + :OLD.�Ǹż���)-:NEW.�Ǹż��� 
 where ��ǰ�ڵ�=:NEW.��ǰ�ڵ�;
 ELSE
 RAISE_APPLICATION_ERROR(-20000,'������ �������� �Ǹ� ����');
 END IF;
end;
--
update �Ǹ� set �Ǹż��� =10 where �ǸŹ�ȣ =1;
SELECT * FROM ��ǰ;               
SELECT * FROM �Ǹ�;
3)�Ǹ� 1�� �Ǹ���� DELETE ��ǰ���̺� ������= +�Ǹż���
create or replace trigger ut_delpan
AFTER
DELETE ON �Ǹ�
FOR EACH ROW
BEGIN
 UPDATE ��ǰ set ������=������+:old.�Ǹż��� where ��ǰ�ڵ�=:OLD.��ǰ�ڵ�;
END;

SELECT *
FROM user_triggers;