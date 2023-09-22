--1) 트리거 A작업 실행 (자동)> B작업 실행
2)원치 않는 사용자가 원하지 않는 작업 X
3)예) 근무시간(9~18) 외,주말에는 I,U,D 작업 X 
4)
trigger란 어떤 작업전, 또는 작업 후 trigger에 정의한 로직을 실행시키는 PL/SQL 블럭이다.
trigger란 테이블에 미리 지정한 어떤 이벤트가 발생할 때 활동하도록한 객체를 의미한다.    
5)예약어
BEFORE  구문을 실행하기 전에 트리거를 시작  
AFTER  구문을 실행한 후에 트리거를 시작 
FOR EACH ROW  행 트리거임을 알림  행 마다 처리 
REFERENCING  영향받는 행의 값을 참조 
:OLD  참조 전 열의 값 
:NEW  참조 후 열의 값 
예)
CREATE OR REPLACE TRIGGER test_trigger
BEFORE 
INSERT OR UPDATE OR DELETE ON tbl_emp
BEGIN
 IF TO_CHAR(SYSDATE,'DY') IN ('화','수') THEN
  dbms_output.put_line('주말에는 데이터를 변경할 수 없습니다...');
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
예) exam1 에 i,u,d 수행시 자동으로 exam2 에 로그 기록하는 트리거

CREATE OR REPLACE TRIGGER ut_exam1
AFTER 
INSERT OR UPDATE OR DELETE ON exam1
--for each row 행트리거 when 트리거 조건
BEGIN
IF INSERTING THEN
 INSERT INTO exam2 (memo) VALUES('추가');
ELSIF UPDATING THEN
 INSERT INTO exam2 (memo) values('수정');
ELSIF DELETING THEN
 INSERT INTO exam2 (memo) values('삭제');
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
   IF TO_CHAR(SYSDATE, 'DAY') IN ('토요일', '일요일') OR
       TO_CHAR(SYSDATE, 'hh24')<12 OR
       TO_CHAR(SYSDATE, 'hh24')>=18 THEN
       raise_application_error(-20000, '지금은 근무시간이 아니기에 자료 입력(수정, 삭제)이 안되는 시간입니다!');
    END IF;
END;
drop trigger ut_exam1;
drop trigger ut_exam2;
drop table exam1;
drop table exam2;
--행 트리거 작성을 위한 테이블 작성
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
-- test1 에 한 학생의 학번,이름,국,영,수 INSERT 하면 trigger로 test2에 총,평 insert
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
-----------------------------------트리거 실습 예제
-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드        VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명           VARCHAR2(30)  NOT NULL
  ,제조사        VARCHAR2(30)  NOT NULL
  ,소비자가격  NUMBER
  ,재고수량     NUMBER DEFAULT 0
);

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호      NUMBER PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES 상품(상품코드)
  ,입고일자     DATE
  ,입고수량      NUMBER
  ,입고단가      NUMBER
);

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      NUMBER  PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES 상품(상품코드)
  ,판매일자      DATE
  ,판매수량      NUMBER
  ,판매단가      NUMBER
);

-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
-- 입고테이블 입력시 상품테이블 제고수량 갱신 트리거 필요 
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER
INSERT ON 입고
FOR EACH ROW
begin
update 상품 set 재고수량=재고수량+:NEW.입고수량 where 상품코드=:NEW.상품코드;
end;
--
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2004-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2004-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2004-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2004-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2004-10-16', 25, 700000);
COMMIT;
delete from 입고 where 입고번호 =5;
SELECT * FROM 상품;

SELECT * FROM 입고;
-- 문제 
update 입고
set 입고수량 = 20
where 입고번호 =5;
-- ut_upipgo
create or replace trigger ut_upipgo
after update on 입고
for each row
begin
update 상품 set 재고수량=재고수량+:NEW.입고수량-:OLD.입고수량 where 상품코드=:NEW.상품코드;
end;
-- 입고 테이블 입고 취소 삭제 상품테이블 재고수량 수정
create or replace trigger ut_delipgo
after delete on 입고
for each row
begin
update 상품 set 재고수량=재고수량-:OLD.입고수량 where 상품코드=:OLD.상품코드;
end;
delete 입고
where 입고번호=5;
--
1) 어떤상품 판매시 판매된 상품의 재고수량 수정 ut_inspan
create or replace trigger ut_inspan
--after insert on 판매
before insert on 판매 -- 강사님 풀이
FOR EACH ROW
DECLARE -- 강사님 풀이
qty NUMBER; -- 현재상품 제고수량 강사님풀이
BEGIN
--강사님풀이
 SELECT 재고수량 INTO qty
 FROM 상품
 WHERE 상품코드 = :NEW.상품코드; 
 IF qty >= :NEW.판매수량 THEN
 update 상품 set 재고수량 = 재고수량-:NEW.판매수량 where 상품코드=:NEW.상품코드;
 ELSE
 RAISE_APPLICATION_ERROR(-20000,'재고수량 부족으로 판매 오류');
 END IF;
--update 상품 set 재고수량 = 재고수량-:NEW.판매수량 where 상품코드=:NEW.판매번호;
END;
--
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (1, 'AAAAAA', '2004-11-10', 5, 1000000);
SELECT * FROM 상품;               
SELECT * FROM 판매;
2) AAAAAA 5 판매 insert > 10 수정 , 상품테이블 재고수량 수정
CREATE or replace trigger ut_uppan
before update on 판매
FOR EACH ROW
DECLARE
qty NUMBER;
begin
SELECT 재고수량 INTO qty
 FROM 상품
 WHERE 상품코드 = :NEW.상품코드; 
 IF (qty + :OLD.판매수량) >= :NEW.판매수량 THEN
 update 상품 set 재고수량 = (재고수량 + :OLD.판매수량)-:NEW.판매수량 
 where 상품코드=:NEW.상품코드;
 ELSE
 RAISE_APPLICATION_ERROR(-20000,'재고수량 부족으로 판매 오류');
 END IF;
end;
--
update 판매 set 판매수량 =10 where 판매번호 =1;
SELECT * FROM 상품;               
SELECT * FROM 판매;
3)판매 1이 판매취소 DELETE 상품테이블 재고수량= +판매수량
create or replace trigger ut_delpan
AFTER
DELETE ON 판매
FOR EACH ROW
BEGIN
 UPDATE 상품 set 재고수량=재고수량+:old.판매수량 where 상품코드=:OLD.상품코드;
END;

SELECT *
FROM user_triggers;