-- 오라클 자료형 
--1) CHAR 고정길이 CHAR(SIZE BYTE|CHAR)
--CHAR == CHAR(1) == CHAR(1 BYTE) 1BYTE ~ 2000BYTE 한(3),영(1)

--2) NCHAR 고정길이 == N(UNICODE) + CHAR
-- NCHAR(SIZE==문자) 1문자 ~ 2000BYTE
--== NCHAR == NCHAR(1) : 문자  바이트 사용 X

create table test (
       aa char(3)
     , bb char(3 char)
     , cc nchar(3)
     );
--Table TEST이(가) 생성되었습니다.     
INSERT INTO test (aa,bb,cc) VALUES('홍길동','홍길동','홍길동');
INSERT INTO test (aa,bb,cc) VALUES('홍','홍길동','홍길동');

--고정길이 : CHAR, NCHAR 2000byte
--가변길이 : VARCHAR2 ,NVARCHAR2 4000 byte
--3) VARCHAR2
name CHAR(10 CHAR) -- 10자 고정
name VARCHAR2(10 CHAR) -- 10자 까지 
VARCHAR2(10) == VARCHAR2(10 BYTE)
VARCHAR2 == VARCHAR2(1) == VARCHAR2(1 BYTE) 

--4) NVARCHAR2 == N(UNICODE) + VARCHAR2

--5) LONG 가변 문자 자료형 2GB

--6) NUMBER 숫자 = 정수+실수
NUMBER
NUMBER(p) precision 정확도 == 전체 자릿수 1~38
NUMBER(p,s) scale 규모 == 소숫점이하 자릿수 -84∼127 

CREATE TABLE tbl_number (
 kor NUMBER(3)
,eng NUMBER(3)
,mat NUMBER(3)
,tot NUMBER(3)
,avg NUMBER(5,2)
);
-- ORA-00947: not enough values
INSERT INTO tbl_number (kor,eng,mat,tot,avg) values(90.89,85,100);
-- 90.89 반올림 되어서 91
INSERT INTO tbl_number (kor,eng,mat) values(90.89,85,100);
-- 3자리 숫자이기에 - 999 ~ 999 까지 
INSERT INTO tbl_number (kor,eng,mat) values(90,85,300);
INSERT INTO tbl_number (kor,eng,mat) values(90,85,-999);
--
SELECT * FROM tbl_number;
--
INSERT INTO tbl_number(kor,eng,mat)
values(
 TRUNC(dbms_random.value(0,100))
,TRUNC(dbms_random.value(0,100))
,TRUNC(dbms_random.value(0,100))
);

update tbl_number
set tot = kor+eng+mat , avg = (kor+eng+mat)/3;

SELECT *
FROM tbl_number;
--  한 학생의 성적 수정 
update tbl_number
--set avg = 999.1234565
SET avg = 99999 --ORA-01438: value larger than specified precision allowed for this column
WHERE avg=92;  -- 고유키 PK

--7) FLOAT(p) == number

--8) DATE 날짜 + 시간 (초) 7BYTE
--    TIMESTAMP             , + ms, ns
학생정보 테이블
학번 : NUMBER(7)
이름 : VARCHAR2
국,영,수,총 : NUMBER(3) + 제약조건 
평균 : NUMBER(5,2)
등수 : NUMBER(4)
생일 : DATE
주민등록번호 : CHAR

--9) TIMESTAMP : DATE 확장 

--10) 2진 데이터(0,1) RAW(SIZE) 2000byte , LONG RAW 2GB
-- 이미지파일,실행파일 > 2진 데이터 > DB 저장

--11) BLOB Binary + Large Object 4GB , BFILE

--12) CLOB Character + Large Object 4GB , N(UNICODE)+CLOB 

--COUNT OVER() 질의한 행의 누적된 결과값을 반환
SELECT buseo,name , basicpay
--count(*) OVER(ORDER BY basicpay)
,count(*) OVER(PARTITION BY buseo ORDER BY basicpay)
FROM insa;
--SUM OVER()  
SELECT buseo,name , basicpay
--,SUM(basicpay) OVER(ORDER BY basicpay) sum
,SUM(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay)sum
FROM insa;

-- 각 지역별 평균과 급여액의 차이 
SELECT city,name,basicpay
,AVG(basicpay) OVER(PARTITION BY city order by city) avg
, basicpay - AVG(basicpay) OVER(PARTITION BY city order by city) cha
FROM insa;

-- 테이블 생성 수정 삭제
-- 테이블 레코드(행,row) 추가 수정 삭제 

--1) 테이블 = 데이터 저장소 
--2) DB 모델링 > 테이블 생성
게시판 테이블 생성
1) 테이블명 : tbl_board
2)     컬럼명       자료형       크기           널허용
   번호 seq         숫자(정수)   NUMBER(38)    NOT NULL
   작성자 writer     문자        VARCHAR2(20)  NOT NULL
   비밀번호 passwd   문자        VARCHAR2(10)  NOT NULL
   제목 title        문자        VARCHAR2(100)
   내용 content      문자        CLOB
   작성일 regdate    날짜        DATE           DEFAULT SYSDATE
   등등
3) 게시글을 구분하는 PK : 번호
4) 필수 입력 사항 :   NOT NULL 제약조건
5) 작성일은 현재 시스템 날짜로 자동 입력

    CREATE [GLOBAL TEMPORARY] TABLE [schema.] table
      ( 
        열이름  데이터타입 [DEFAULT 표현식] [제약조건] 
       [,열이름  데이터타입 [DEFAULT 표현식] [제약조건] ] 
       [,...]  
      ); 
--게시판 테이블 생성
    CREATE TABLE tbl_board
      ( 
        seq  NUMBER(38) NOT NULL PRIMARY KEY
        ,writer VARCHAR2(20)  NOT NULL
        ,passwd VARCHAR2(10)  NOT NULL
        ,title VARCHAR2(100)  NOT NULL
        ,content CLOB
        ,regdate DATE DEFAULT SYSDATE       
      );    
? alter table ... add 컬럼 //새로운 컬럼 추가
? alter table ... modify 컬럼  //컬럼 수정
? alter table ... drop[constraint] 제약조건  //제약조건 삭제
? alter table ... drop column 컬럼       //컬럼 삭제 
SELECT *
FROM tbl_board;
--
INSERT INTO tbl_board (seq,writer,passwd,title,content,regdate)
values(1,'admin','1234','test-1','test-1',SYSDATE);
--
INSERT INTO tbl_board (seq,writer,passwd,title,content)
values(2,'hong','1234','test-2','test-2');
--
INSERT INTO tbl_board
values(3,'mmmm','1234','test-3','test-3',SYSDATE);
-- tbl_board 테이블 제약조건 확인
SELECT *
FROM user_constraints
WHERE table_name like '%BOARD%';
-- 조회수 칼럼 추가      
--readed NUMBER
ALTER TABLE tbl_board
ADD  readed NUMBER DEFAULT 0;
--1) 게시글 작성 (INSERT 문)
INSERT INTO tbl_board(writer,seq,title,passwd)
values ('mmm',
(SELECT nvl(MAX(seq),0)+1 FROM tbl_board),
'test-4','1111');
--2) content 가 null 인 경우 > '냉무' 게시글 수정 
UPDATE tbl_board
SET content ='냉무'
WHERE content is null;
--3) 특정 작성자의 게시글 삭제 
DELETE FROM tbl_board
WHERE writer ='mmm';
--4) 컬럼의 자료형의 크기 수정
desc tbl_board;
-- WRITER  NOT NULL VARCHAR2(20)  > 40
ALTER TABLE tbl_board
modify writer VARCHAR2(40)  ;
--5) TITLE 컬럼명 수정 >subject
alter table tbl_board
rename COLUMN title TO subject;
SELECT *
FROM tbl_board;
--6) bigo 컬럼 추가 (기타 사항) > 삭제
ALTER TABLE tbl_board
ADD bigo VARCHAR2(100);
ALTER TABLE tbl_board
DROP COLUMN bigo;
--7) 테이블명 수정
RENAME 테이블명1 TO 테이블명2 
---------------------------------------------------------------
-- 서브쿼리 이용 테이블 생성 
ㄱ. 이미 기존 테이블 존재 + 레코드 존재
ㄴ. 서브쿼리 사용해서 테이블 생성
ㄷ. 테이블 생성 + 데이터 복사 + 제약조건 X
ㄹ. ;
CREATE TABLE tbl_emp(empno, ename, job, hiredate, mgr,pay ,deptno)
AS
SELECT empno, ename, job, hiredate, mgr,sal+nvl(comm,0) pay ,deptno
FROM emp;
desc emp;
desc tbl_emp;
SELECT *
FROM tbl_emp;
--제약조건 확인
SELECT *
FROM user_constraints;

-- 서브쿼리 테이블 생성 + 데이터 X
CREATE TABLE tbl_emp
AS
SELECT *
FROM emp
WHERE 1=0;

-- 문제 deptno,dname,empno,ename,hiredate,pay,grade 가진 tbl_empgrade 테이블
CREATE TABLE tbl_empgrade
(deptno,dname,empno,ename,hiredate,pay,grade)
AS
SELECT b.deptno,dname,empno,ename,hiredate,sal+nvl(comm,0) pay, grade
FROM emp a , dept b , salgrade c
WHERE a.deptno = b.deptno
AND sal between losal AND hisal;
-------------------------------
--INSERT 문
INSERT INTO 테이블명 [(컬럼명,,,)] VALUES(컬럼값,,,)
DML - COMMIT(완료),rollback(취소);
-- Mutil + table insert 문
1) Unconditional insert all 문은 조건과 상관없이 기술되어진 여러 개의 테이블에 데이터를 입력한다.
? 서브쿼리로부터 한번에 하나의 행을 반환받아 각각 insert 절을 수행한다.
? into 절과 values 절에 기술한 컬럼의 개수와 데이터 타입은 동일해야 한다.
【형식】
	INSERT ALL | FIRST
	  [INTO 테이블1 VALUES (컬럼1,컬럼2,...)]
	  [INTO 테이블2 VALUES (컬럼1,컬럼2,...)]
	  .......
	Subquery;

여기서 
 ALL : 서브쿼리의 결과 집합을 해당하는 insert 절에 모두 입력
 FIRST : 서브쿼리의 결과 집합을 해당하는 첫 번째 insert 절에 입력
 subquery : 입력 데이터 집합을 정의하기 위한 서브쿼리는 한 번에 하나의 행을 반환하여 각 insert 절 수행
-- 예)
CREATE TABLE dept_10 as(SELECT * FROM dept WHERE 1=0);
CREATE TABLE dept_20 as(SELECT * FROM dept WHERE 1=0);
CREATE TABLE dept_30 as(SELECT * FROM dept WHERE 1=0);
CREATE TABLE dept_40 as(SELECT * FROM dept WHERE 1=0);
INSERT ALL
INTO dept_10 values(deptno,dname,loc)
INTO dept_20 values(deptno,dname,loc)
INTO dept_30 values(deptno,dname,loc)
INTO dept_40 values(deptno,dname,loc)
SELECT * FROM dept;

--2) conditional insert all  조건이 있는 다중테이블 INSERT문
emp_10,emp_20,emp_30,emp_40 테이블 생성 후 
emp 서브쿼리에서 각 부서별로 각 테이블 insert 
CREATE TABLE emp_10 as(SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_20 as(SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_30 as(SELECT * FROM emp WHERE 1=0);
CREATE TABLE emp_40 as(SELECT * FROM emp WHERE 1=0);
--INSERT ALL
--2-1) conditional first insert
INSERT FIRST
WHEN deptno = 10 THEN
INTO emp_10 values(empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 20 THEN
INTO emp_20 values(empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 30 THEN
INTO emp_30 
ELSE
INTO emp_40 
SELECT * FROM emp;

SELECT * FROM emp_40;

-- ALL / FIRST 차이점 조건 만족마다 insert / 첫번쨰 조건만 insert 
INSERT FIRST
WHEN deptno=10 THEN
INTO emp_10
WHEN job='CLERK' THEN
INTO emp_20
ELSE
INTO emp_40
SELECT * FROM emp;
 
--4) pivoting insert 
create table sales(
     employee_id       number(6),
    week_id            number(2),
    sales_mon          number(8,2),
    sales_tue          number(8,2),
    sales_wed          number(8,2),
    sales_thu          number(8,2),
    sales_fri          number(8,2));

insert into sales values(1101,4,100,150,80,60,120);
insert into sales values(1102,5,300,300,230,120,150);

create table sales_data(
    employee_id        number(6),
    week_id            number(2),
    sales              number(8,2));

 insert all
    into sales_data values(employee_id, week_id, sales_mon)
    into sales_data values(employee_id, week_id, sales_tue)
    into sales_data values(employee_id, week_id, sales_wed)
    into sales_data values(employee_id, week_id, sales_thu)
    into sales_data values(employee_id, week_id, sales_fri)
    select employee_id, week_id, sales_mon, sales_tue, sales_wed,
           sales_thu, sales_fri
    from sales;

 select * from sales;
 select * from sales_data;
--1) emp_10 테이블의 모든 레코드(행) 삭제 + commit,rollback
DELETE FROM emp_10;
SELECT *
FROM emp_10;
--2) emp_20 테이블의 모든 레코드(행) 삭제 + 자동 커밋 
TRUNCATE TABLE emp_20;
SELECT *
FROM emp_20;
--3) 테이블 자체를 삭제
DROP table emp_30;
SELECT *
FROM emp_30;
---------------------------------------------------------
--문제 insa 에서 num,name 컬럼만 tbl_score 생성 (num <= 1005)
CREATE TABLE tbl_score
as
(SELECT num,name FROM insa WHERE num <=1005);
-- 문제 tbl_score 에 kor,eng,mat,tot,avg,grade,rank 추가 
--국,영,수,총점 기본값 0 grade char(1 char)
ALTER TABLE tbl_score
ADD(  
   kor NUMBER(3) DEFAULT 0
,  eng NUMBER(3) DEFAULT 0 
,  mat NUMBER(3) DEFAULT 0 
,  tot NUMBER(3) DEFAULT 0 
,  avg NUMBER(5,2) 
,  grade char(1 char)
,  rank NUMBER(3)
);
-- 문제 1001~1005 의 국영수 점수를 임의의 점수로 수정
update tbl_score
set kor = trunc(dbms_random.value(0,101))
,eng = trunc(dbms_random.value(0,101))
,mat = trunc(dbms_random.value(0,101))
WHERE num between 1001 AND 1005;
--
--update tbl_score
--set kor = (SELECT kor FROM tbl_score WHERE num=1005)
--,eng = (SELECT eng FROM tbl_score WHERE num=1005)
--,mat = (SELECT mat FROM tbl_score WHERE num=1005)
--WHERE num = 1001;
update tbl_score
SET(kor,eng,mat) = (SELECT kor,eng,mat FROM tbl_score WHERE num=1005)
WHERE num = 1001;
-- 총점 평균 수정
update tbl_score
set tot = kor+eng+mat
   ,avg = (kor+eng+mat)/3;
SELECT t.* , TO_CHAR(t.avg,'999.00')
FROM tbl_score t;
-- 등급 90A 80B 70C 60D 59F
update tbl_score
set grade = 
   CASE  
   WHEN avg>=90 THEN 'A'
   WHEN avg>=80 THEN 'B'
   WHEN avg>=70 THEN 'C'
   WHEN avg>=60 THEN 'D'
   ELSE 'F'   
   END 
;
--DECODE(trunc(avg/10),10,'A',9,'A',8,'B',7,'C',6,'D','F')
update tbl_score p
set rank = (
SELECT count(*)+1
FROM tbl_score
where p.avg < avg
);
update tbl_score p
set rank = ( 
SELECT t.r
FROM(
SELECT num,tot,rank() OVER(ORDER BY tot desc) r 
FROM tbl_score
) t
WHERE t.num = p.num
);

SELECT * FROM tbl_score;

-- 문제 모든 학생들의 영어 점수 20점 증가 
update tbl_score
set eng = CASE
WHEN eng >= 80 THEN 100
ELSE eng + 20
END;
-- 국영수 점수가 또 수정되면 
-- 수정된 학생의 총 평 등 전체학생들 등수도 달라진다 .
-- 트리거 Trigger 
-- 문제 여학생들만 국어 점수를 5점씩 증가
update tbl_score 
set kor = CASE
WHEN kor>=95 THEN 100
ELSE kor + 5
END
WHERE num = ANY (
SELECT num 
FROM  insa
WHERE substr(ssn,-7,1) =1
AND num <= 1005
);
--
--(화) : 제약조건 , 조인 , 계층적 쿼리
--(수) : DB 모델링 + 하루 DB 모델링 ( 팀 )
--(목) : 팀 발표, PL/SQL
--(금) : PL/SQL 
--동적쿼리 , 암호화 , 등

-- 병합 (merge)

create table tbl_emp(
    id number primary key, 
    name varchar2(10) not null,
    salary  number,
    bonus number default 100);

desc tbl_emp;

insert into tbl_emp(id,name,salary) values(1001,'jijoe',150);
insert into tbl_emp(id,name,salary) values(1002,'cho',130);
insert into tbl_emp(id,name,salary) values(1003,'kim',140);

SELECT * FROM tbl_emp;
create table tbl_bonus(
id number,
bonus number default 100);

insert into tbl_bonus(id)
      (select e.id from tbl_emp e);

select * from tbl_bonus;

--tbl_emp , tbl_bonus 병합 
MERGE INTO tbl_bonus b 
USING (SELECT id,salary FROM tbl_emp) e
ON (b.id = e.id)
 WHEN MATCHED THEN UPDATE SET b.bonus = b.bonus + e.salary * 0.01
 WHEN NOT MATCHED THEN INSERT(b.id,b.bonus)values(e.id,e.salary*0.01);
--WHERE condition

-- 
SELECT 
      NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 1, TO_CHAR( dates, 'DD')) ), ' ')  일
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 2, TO_CHAR( dates, 'DD')) ), ' ')  월
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 3, TO_CHAR( dates, 'DD')) ), ' ')  화
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 4, TO_CHAR( dates, 'DD')) ), ' ')  수
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 5, TO_CHAR( dates, 'DD')) ), ' ')  목
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 6, TO_CHAR( dates, 'DD')) ), ' ')  금
     , NVL( MIN( DECODE( TO_CHAR( dates, 'D'), 7, TO_CHAR( dates, 'DD')) ), ' ')  토
FROM (
        SELECT TO_DATE(:yyyymm , 'YYYYMM') + LEVEL - 1  dates
        FROM dual
        CONNECT BY LEVEL <= EXTRACT ( DAY FROM LAST_DAY(TO_DATE(:yyyymm , 'YYYYMM') ) )
)  t 
GROUP BY CASE
                -- 1/2/3/4/5/6/7               2022/04/1의 요일
            WHEN TO_CHAR( dates, 'D' ) < TO_CHAR( TO_DATE( :yyyymm,'YYYYMM' ), 'D' ) 
                 THEN TO_CHAR( dates, 'W' ) + 1
            ELSE TO_NUMBER( TO_CHAR( dates, 'W' ) )
        END
ORDER BY CASE
            WHEN TO_CHAR( dates, 'D' ) < TO_CHAR( TO_DATE( :yyyymm,'YYYYMM' ), 'D' ) THEN TO_CHAR( dates, 'W' ) + 1
            ELSE TO_NUMBER( TO_CHAR( dates, 'W' ) )
        END;



