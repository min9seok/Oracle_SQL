-- 제약조건
-- data integrity(데이터 무결성)
-- 개체 무결성 = 유일성+최소성 = 값은 중복X 무조건 하나 NOT NULL
-- 참조 무결성 = 부모(참조키 RK) <-> 자식(외래키 KF) 부모 자식 값 일치 OR null
-- 도메인 무결성 = 데이터 타입, 길이, 기본 키, 유일성, null 허용, 허용 값의 범위 

-- 제약조건 설정 방법
1) 컬럼 레벨 IN-LINE 테이블 생성시 컬럼명 바로 뒤에 기술하여 생성
CREATE TABLE sample(
 id varchar2(20) 제약조건
)
2) 테이블 레벨 OUT-OF-LINE 마지막 제약조건에 ,(컴마)로 구분한 뒤 제약조건을 기술
CREATE TABLE sample(
 id varchar2(20) 
 , CONSTRAINT 제약조건
)
-- 제약조건을 설정하는 시점
1) 테이블 생성 - CREATE TABLE
2) 테이블 수정 - ALTER TABLE

-- 제약조건의 종류
1) PRIMARY KEY(PK) 해당 컬럼 값은 반드시 존재해야 하며, 유일해야 함
                   (NOT NULL과 UNIQUE 제약조건을 결합한 형태) 
2) FOREIGN KEY(FK) 해당 컬럼 값은 참조되는 테이블의 컬럼 값 중의 하나와 일치하거나 
                   NULL을 가짐 
3) UNIQUE KEY(UK) 테이블내에서 해당 컬럼 값은 항상 유일해야 함 
4) NOT NULL(NN) 컬럼은 NULL 값을 포함할 수 없다. --컬럼 레벨로만 지정가능 
5) CHECK(CK) 해당 컬럼에 저장 가능한 데이터 값의 범위나 조건 지정 
;
-- 실습 tbl_constraint
--1)컬럼 레벨
CREATE TABLE tbl_constraint1(
  --empno number(4) NOT NULL PRIMARY KEY -- 이름 시스템 자동생성
    empno number(4) NOT NULL CONSTRAINT PK_tblconstraint1_empno PRIMARY KEY
   ,ename varchar2(20) 
   ,deptno number(2) CONSTRAINT FK_tblconstraint1_deptno 
                     REFERENCES dept(deptno)-- dept(deptno) 외래키 
   ,kor NUMBER(3) CONSTRAINT CK_tblconstraint1_kor CHECK(kor betwwen 0 and 100 )   
   ,email varchar2(250) CONSTRAINT UK_tblconstraint1_email UNIQUE
   ,city varchar2(20) CONSTRAINT CK_tblconstraint1_city 
                       CHECK(city in ('서울','부산','대구','대전') )   
);
-- 제약조건 PK제거
ALTER TABLE 테이블명 
DROP [CONSTRAINT constraint명 | PRIMARY KEY | UNIQUE(컬럼명)]
[CASCADE];
--ㄱ. 제약조건 이름으로 제거
ALTER TABLE tbl_constraint1
DROP CONSTRAINT SYS_C007115;
--
ALTER TABLE tbl_constraint1
DROP CONSTRAINT PK_tblconstraint1_empno;
--ㄴ. PK 제약조건몰라도 제거 가능 
ALTER TABLE tbl_constraint1
DROP PRIMARY KEY;
--2)테이블 레벨
CREATE TABLE tbl_constraint2(
    empno number(4) NOT NULL
   ,ename varchar2(20) 
   ,deptno number(2)
   ,kor    number(3)
   ,email varchar2(250)
   ,city varchar2(20)
    ,CONSTRAINT PK_tblconstraint2_empno primary key(empno)
    ,CONSTRAINT FK_tblconstraint2_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    ,CONSTRAINT CK_tblconstraint2_kor CHECK(kor betwwen 0 and 100 )   
    ,CONSTRAINT UK_tblconstraint2_email UNIQUE(email)
    ,CONSTRAINT CK_tblconstraint2_city 
                       CHECK(city in ('서울','부산','대구','대전') )   
);
SELECT *
FROM user_constraints
WHERE table_name = 'TBL_CONSTRAINT3';
--3) 테이블 생성 후 PK 제약조건 설정
CREATE TABLE tbl_constraint3(
    empno number(4) 
   ,ename varchar2(20) 
   ,deptno number(2)
);
-- 테이블 수정
ALTER TABLE tbl_constraint3
ADD CONSTRAINT PK_tblconstraint3_empno Primary key (empno);
ALTER TABLE tbl_constraint3
ADD CONSTRAINT FK_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);
------------------- 제약조건 비/활성화
ALTER TABLE 테이블명
ENABLE CONSTRAINT 제약조건명;

ALTER TABLE 테이블명
DISABLE CONSTRAINT 제약조건명;
--
DROP TALBE 테이블명 CASCADE CONSTRAINTS; 테이블과 그 테이블을 참조하는 FK를 동시에 삭제
DROP TALBE 테이블명; DELETE
DROP TALBE 테이블명 PURGE; Shift+DELETE
--ALTER TABLE 테이블명
--ADD (컬럼....)
--ADD (제약조건...) 확인필요
-------------------- FOREIGN KEY (FK)
【컬럼레벨의 형식】
        컬럼명 데이터타입 CONSTRAINT constraint명
	REFERENCES 참조테이블명 (참조컬럼명) 
             [ON DELETE CASCADE | ON DELETE SET NULL]
detpno number(2) CONSTRAINT FK_EMP_DEPTNO REFERENCES dept(deptno) 
                 ON DELETE CASCADE 
--부모 테이블의 행이 삭제될 때 이를 참조한 자식 테이블의 행을 동시에 삭제할 수 있다.
                ON DELETE SET NULL 
--부모 테이블의 값이 삭제되면 자식 테이블의 값을 NULL 값으로 변경시킨다.

--실습 
--ON DELETE CASCADE 
--ON DELETE SET NULL 
SELECT *
FROM user_constraints
WHERE table_name IN( 'TBL_EMP','TBL_DEPT');
ALTER TABLE tbl_dept
ADD CONSTRAINT PK_tbl_dept_deptno Primary key (deptno);
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tbl_emp_empno Primary key (empno);
ALTER TABLE tbl_emp
DROP CONSTRAINT PK_tbl_emp_deptno;
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tbl_emp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno)
                                     ON DELETE CASCADE;
                                     ON DELETE SET NULL;
--
SELECT * FROM tbl_emp;
SELECT * FROM tbl_dept;
delete FROM tbl_dept
WHERE deptno =30;
--------------------------------------------------
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title      VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;
-- 단가테이블( 책의 가격 )
  CREATE TABLE danga(
      b_id  VARCHAR2(10)  NOT NULL  -- PK , FK (식별관계 ***)
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA이(가) 생성되었습니다.
book  - b_id(PK), title, c_name
danga - b_id(PK,FK), price 

INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT;

SELECT *
FROM danga;
-- 책을 지은 저자테이블
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);
--Table AU_BOOK이(가) 생성되었습니다.

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;
-- 고객테이블(서점)          
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);          
--Table GOGAEK이(가) 생성되었습니다.
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);
--Table PANMAI이(가) 생성되었습니다.
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   
-- JOIN 종류
--1) EQUI JOIN 
-- WHERE 조건절에 조인조건 = 사용
--            부.PK = 자.FK
-- 오라클에서는 natural join 과 동일 
-- USING 절을 사용 ...

-- 책ID,책제목,출판사(c_name),단가 출력
1) 객체명.컬럼명
SELECT  book.b_id , book.title, book.c_name , danga.price
FROM book, danga
WHERE book.b_id = danga.b_id;
2) 별칭.컬럼명
SELECT  a.b_id , title, c_name ,price
FROM book a, danga b
WHERE a.b_id = b.b_id;
3) JOIN-ON 구문
SELECT  a.b_id , title, c_name ,price
FROM book a JOIN danga b ON a.b_id = b.b_id;
4) USING 절 사용 - 객체명.컬럼명 또는 별칭명.컬럼명 X
SELECT b_id,title,c_name,price
FROM book JOIN danga USING(b_id);
5) 
SELECT b_id,title,c_name,price
FROM book NATURAL JOIN danga ;

-- 문제 책ID,책제목,판매수량,단가,서점명,판매금액
1) ,,
SELECT a.b_id,title,p_su,price,g_name,(p_su*price) "판매금액"
FROM BOOK a,gogaek b, panmai c , danga d
WHERE a.b_id = c.b_id
AND a.b_id = d.b_id
AND b.g_id = c.g_id;
2) JOIN-ON
SELECT a.b_id,title,p_su,price,g_name,(p_su*price) "판매금액"
FROM BOOK a JOIN panmai c ON a.b_id = c.b_id
            JOIN danga d ON a.b_id = d.b_id
            JOIN gogaek b ON b.g_id = c.g_id;
3) USING
SELECT b_id,title,p_su,price,g_name,(p_su*price) "판매금액"
FROM BOOK a JOIN panmai USING(b_id)  
            JOIN danga  USING(b_id)
            JOIN gogaek USING(g_id);
-- NON EQUI JOIN
 -- WHERE 절에 BETWEEN ... AND ... 연산자를 사용한다.
 SELECT deptno,ename,sal,grade
 FROM emp e , salgrade s
 WHERE sal between losal AND hisal;
 
 SELECT *
FROM salgrade;
SELECT *
FROM emp;
-- INNER JOIN : , 둘 이상의 테이블에서 조인 조건을 만족하는 행만 반환한다.
SELECT d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;
-- LEFT OUTER JOIN
SELECT d.deptno,ename,sal
FROM emp e, dept d
WHERE e.deptno = d.deptno(+);
-- RIGHT OUTER JOIN
SELECT d.deptno,ename,sal
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno;
--
SELECT d.deptno,ename,sal
FROM emp e FULL JOIN dept d ON e.deptno = d.deptno;
--
--SELF JOIN : 같은 테이블을 조인
-- deptno/empno/ename 직속상사의 부서번호/사원번호/사원명

SELECT e1.deptno,e1.empno,e1.ename,e1.mgr
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno;
-- CROSS JOIN
SELECT d.deptno,dname,empno,ename
FROM emp e, dept d;





















