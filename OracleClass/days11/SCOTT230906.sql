SELECT FLAVOR
FROM (
    SELECT FLAVOR
    FROM (
        SELECT *
        FROM FIRST_HALF 
            UNION ALL
        SELECT *
        FROM JULY
    )
    GROUP BY FLAVOR
    ORDER BY sum(TOTAL_ORDER) DESC
)
WHERE ROWNUM <= 3
;
--문제) 책ID  , 책제목, 단가,판매수량,서점,판매금액
--SELECT a.b_id,a.title,b.price,c.p_su,,d.g_name(p_su*price)"판매금액"
--FROM book a, danga b, panmai c , gogaek d
--WHERE a.b_id = b.b_id
--AND   a.b_id = c.b_id
--AND  c.g_id = d.g_id;
//
SELECT b_id,title,price,p_su,g_name,(p_su*price)"판매금액"
FROM book NATURAL JOIN danga NATURAL JOIN panmai NATURAL JOIN gogaek ;

--문제) 출판된 책들이 각각 총 몇 권이 판매되었는지 조회 
-- 책ID ,  책제목, 단가 , 총판매권수
SELECT a.b_id,a.title,b.price,sum(p_su)
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id
AND   a.b_id = c.b_id
group by a.b_id,a.title,b.price;

SELECT b_id,title,price,sum(p_su) "판매권수"
FROM book NATURAL JOIN danga NATURAL JOIN panmai 
group by b_id,title,price;

SELECT distinct(a.b_id),a.title,b.price
,(SELECT sum(p_su) FROM panmai WHERE b_id = a.b_id) "판매권수"
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id
AND   a.b_id = c.b_id;

-- 문제) 판매된 적 있는 책ID 제목
SELECT b.b_id,title,price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id IN ( SELECT DISTINCT(b_id) FROM panmai );
-- 문제) 판매된 적 없는 책ID 제목 
SELECT b.b_id,title,price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id NOT IN ( SELECT DISTINCT(b_id) FROM panmai );
--판매된 적이 없는 책도 0으로 포함해서 출력
SELECT distinct(a.b_id),a.title,b.price
,nvl((SELECT sum(p_su) FROM panmai WHERE b_id = a.b_id),0) "판매권수"
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id(+)
AND   a.b_id = c.b_id(+);
--
SELECT distinct(a.b_id),a.title,b.price
,nvl((SELECT sum(p_su) FROM panmai WHERE b_id = a.b_id),0) "판매권수"
FROM book a LEFT JOIN danga b ON a.b_id = b.b_id
LEFT JOIN panmai c ON  a.b_id = c.b_id;
-- 가장 판매권수가 많은 책에 대한 정보 출력 
-- TOT_N 방식 BETWEEN 사용불가
SELECT *
FROM(
SELECT a.b_id,a.title,b.price,sum(p_su) "판매권수"
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id
AND   a.b_id = c.b_id
group by a.b_id,a.title,b.price
order by 판매권수 desc
) t
WHERE ROWNUM = 1;
--WHERE ROWNUM <= 3;
-- RANK 방식 BETWEEN 사용가능 
WITH t AS(
 SELECT a.b_id,a.title,b.price,sum(p_su) "판매권수"
 ,RANK() OVER(ORDER BY sum(p_su) desc) rank
FROM book a, danga b, panmai c
WHERE a.b_id = b.b_id
AND   a.b_id = c.b_id
group by a.b_id,a.title,b.price
)
SELECT * 
FROM t
WHERE rank = 1;
--WHERE rank <= 3;
--문제 년도별 월별 판매 현황 
--판매년도,판매월,판매금액(p_su*price)
SELECT to_char(p_date,'YYYY') 판매년도
      ,to_char(p_date,'MM') 판매월
      ,sum(p_su*price) 판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id
group by (to_char(p_date,'YYYY'),to_char(p_date,'MM'))
order by 1,2;
--문제 년도별  판매 현황 
--판매년도,판매금액(p_su*price)
SELECT to_char(p_date,'YYYY') 판매년도      
      ,sum(p_su*price) 판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id
group by to_char(p_date,'YYYY')
order by 1;
--  제시  OUTER JOIN PARTITION BY
SELECT to_char(p_date,'YYYY') 판매년도
      ,to_char(p_date,'MM') 판매월
      ,sum(p_su*price) 판매금액
FROM panmai p LEFT JOIN danga d ON p.b_id = d.b_id
group by (to_char(p_date,'YYYY'),to_char(p_date,'MM'))
order by 1,2;
--문제) 서점별(고객) 판매현황 조회
SELECT to_char(p_date,'YYYY') 판매년도      
       ,g.g_id 서점ID
       ,g_name 서점명
      ,sum(p_su*price) 판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON p.g_id = g.g_id
group by to_char(p_date,'YYYY'),g.g_id,g_name
order by 1;
--문제) 올해 서점별 판매현황 
--서점코드 서점명 판매금액합 비율(소수점 둘쨰반올림)
SELECT g.g_id 서점코드 ,g_name 서점명
       ,sum(p_su*price) 판매금액합
       ,round(sum(p_su*price)/4/100)||'%' 비율
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON p.g_id = g.g_id
WHERE to_char(p_date,'YYYY') = to_char(SYSDATE,'YYYY')
group by g.g_id,g_name
order by 1;
-- 문제) 책의 총 판매금액이 15000원 이상 팔린 책의 정보 조회
--책ID 제목 단가 총판매권수 총판매금액
SELECT b.b_id,title
,sum(p_su) 총판매권수
,sum(p_su*price) 총판매금액
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
group by b.b_id,title
having sum(p_su*price) >=15000
order by 1;
-- 문제) 책의 총 판매권수 10권 이상 팔린 책의 정보 조회 (Having)
--책ID 제목 단가 총판매권수 총판매금액
SELECT b.b_id,title
,sum(p_su) 총판매권수
,sum(p_su*price) 총판매금액
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
group by b.b_id,title
HAVING sum(p_su) >=10
order by 1;
------- 뷰 (View) 
--FROM 테이블 또는 뷰
--user_tables, user_xx 등등 뷰 
--1) 가상테이블 : 한개 이상의 기본 테이블이나 다른 뷰를 이용하여 생성
--2) 전체 데이터 중에서 일부만 접근할 수 있도록 제한하기 위한 기법
--3) 데이터 딕셔너리 테이블에 뷰에 대한 정의만 저장하고 디스크에 저장 공간이 할당되지 않는다.

-- 권한 확인
SELECT *
FROM user_sys_Privs;

-- 뷰 생성
--CREATE TABLE
--CREATE USER
--CREATE TABLESPACE
-- 단순뷴 , 복합뷰(O) 제한적 DML
CREATE OR REPLACE VIEW panView 
AS
--(
SELECT b.b_id,title,price,g.g_id,g_name,p_date,p_su
   ,(p_su*price) amt
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id
order by p_date desc --뷰를 정의하는 subquery에는 ORDER BY절을 포함할 수 없다
--)
;
-- View PANVIEW이(가) 생성되었습니다.
-- 편리성 , 보안성 장점

SELECT *
FROM panView;
-- 뷰를 이용한 총판매금액 조회
SELECT sum(amt)
FROM panView;
-- 뷰 소스 확인 :DB객체, 쿼리 저장 
SELECT text
FROM user_views;
--뷰 수정 CREATE OR REPLACE VIEW 실행
--뷰 삭제
DROP VIEW panView;
--View PANVIEW이(가) 삭제되었습니다.

--문제) 년도,월,고객코드,고객명,판매금액합(년도별 월) 년도,월 오름차순  뷰 생성
CREATE or REPLACE VIEW gogaekView
AS
SELECT TO_CHAR(p_date,'YYYY') 판매년도
      ,TO_CHAR(p_date,'MM') 판매월
      ,g.g_id
      ,g_name
--      ,p_su,price
      ,sum(p_su*price) 총판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id            
              JOIN gogaek g ON p.g_id = g.g_id
GROUP BY TO_CHAR(p_date,'YYYY'),TO_CHAR(p_date,'MM'),g.g_id,g_name
order by 1,2;
;
SELECT TO_CHAR(p_date,'YYYY') 판매년도
      ,TO_CHAR(p_date,'MM') 판매월
      ,g.g_id
      ,g_name
--      ,p_su,price
      ,sum(p_su*price) 총판매금액
FROM panmai p JOIN danga d ON p.b_id = d.b_id            
              JOIN gogaek g ON p.g_id = g.g_id
GROUP BY TO_CHAR(p_date,'YYYY'),TO_CHAR(p_date,'MM'),g.g_id,g_name
order by 1,2;
--
SELECT *
FROM gogaekView;
--
SELECT *
FROM tab
WHERE tabtype = 'VIEW';
-- 뷰(View) : DML 작업 가능 
--  ㄴ 심플뷰
--  ㄴ 복합뷰 
CREATE TABLE testa (
aid NUMBER PRIMARY KEY
,name varchar2(20) NOT NULL
,tel varchar2(20) NOT NULL
,memo varchar2(10) 
);
CREATE TABLE testb(
bid NUMBER PRIMARY KEY
,aid NUMBER CONSTRAINT fk_testb_aid REFERENCES testa(aid)
ON DELETE CASCADE
,score NUMBER(3)
);
INSERT INTO testa (aid, NAME, tel) VALUES (1, 'a', '1');
INSERT INTO testa (aid, name, tel) VALUES (2, 'b', '2');
INSERT INTO testa (aid, name, tel) VALUES (3, 'c', '3');
INSERT INTO testa (aid, name, tel) VALUES (4, 'd', '4');

INSERT INTO testb (bid, aid, score) VALUES (1, 1, 80);
INSERT INTO testb (bid, aid, score) VALUES (2, 2, 70);
INSERT INTO testb (bid, aid, score) VALUES (3, 3, 90);
INSERT INTO testb (bid, aid, score) VALUES (4, 4, 100);

COMMIT;
--
SELECT * FROM testa;
SELECT * FROM testb;
-- 단순뷰 생성 + DML 작업
DESC testa;
CREATE OR REPLACE VIEW aView
AS
SELECT aid, name, memo
FROM testa;
--View AVIEW이(가) 생성되었습니다.
-- 단순뷰를 사용해서 INSERT 
INSERT INTO aView(aid,name,memo) VALUES(5,'f','5');
--ORA-01400: cannot insert NULL into ("SCOTT"."TESTA"."TEL")
--INSERT INTO testa(aid,name,memo) VALUES(5,'f','5');

-- 뷰 수정
CREATE OR REPLACE VIEW aView
AS
SELECT aid, name, tel
FROM testa;
--View AVIEW이(가) 생성되었습니다.
INSERT INTO aView(aid,name,tel) VALUES(5,'f','5');
-- 1 행 이(가) 삽입되었습니다.
COMMIT;
DELETE FROM aView
WHERE aid =5;
-- 1 행 이(가) 삭제되었습니다.
DROP VIEW aView;
--복합뷰 생성
CREATE OR REPLACE VIEW abView
AS
SELECT a.aid,name,tel,bid,score
FROM testa a JOIN testb b ON a.aid = b.aid
;
--View ABVIEW이(가) 생성되었습니다.
INSERT INTO abView (aid,name,tel,bid,score)
VALUES(10,'x',55,20,70);
-- 오류 : 동시에 두 테이블의 내용을 각각 INSERT 할 수 없다
--ORA-01779: cannot modify a column which maps to a non key-preserved table

-- 복합뷰 수정 : 한 테이블의 내용만 수정 가능
UPDATE abView
SET score =99
WHERE bid = 1;
-- 수정 : 두테이블의 내용 수정 X 
DELETE abView
WHERE aid = 1;

SELECT * FROM testa;
SELECT * FROM testb;
-- DELETE CASCADE 옵션에 의해 참조당하는 테이블에도 삭제
-- 점수가 90점 이상인 뷰 생성
CREATE OR REPLACE VIEW bView
AS
SELECT bid,aid,score
FROM testb
WHERE score >= 90;
--View BVIEW이(가) 생성되었습니다.
-- bid 가 3인 행의 score = 70점으로 수정
UPDATE bView -- score >=90
set score = 70
WHERE bid =3;
--
SELECT *
FROM bView;
rollback;
-- 점수가 90점 이상인 뷰 생성
CREATE OR REPLACE VIEW bView
AS
SELECT bid,aid,score
FROM testb
WHERE score >= 90
WITH CHECK OPTION CONSTRAINT CK_bView
;
-- View BVIEW이(가) 생성되었습니다.
UPDATE bView
SET score = 70
WHERE bid = 3;
--ORA-01402: view WITH CHECK OPTION where-clause violation
--
DROP VIEW aView;
DROP VIEW bView;
DROP VIEW abView;
DROP VIEW GOGAEKVIEW;
SELECT *
FROM tab
WHERE tabtype = 'VIEW';
-- MATERIALIZED VIEW (물리적 뷰)
-- 실제 데이터를 가지고 있는 뷰 

-- 계층적 질의
--ORA-01788: CONNECT BY clause required in this query block
SELECT LEVEL
FROM dual
CONNECT BY  LEVEL <= 31; -- 조건절 

LEVEL -> CONNECT BY -> LEVEL 도움말 검색 -> [ 계층적 질의 ]

-- 2차원 평면적인 테이블 < -- 계층적 구조 표현( 저장, 조회 )
-- 실무 조직도, 족보 계층적 구조
-- 1) 테이블 : 부모-자식 컬럼 추가
-- 2) SELECT : START WUTH, CONNECT BY 구문 사용하면 계층적 질의

--7898 의 직속 
SELECT empno,ename,sal,LEVEL
FROM emp
WHERE mgr = 7698
START WITH mgr is null
CONNECT BY PRIOR empno = mgr; -- PRIOR 자식 = 부모 top-down 출력형
--
create table tbl_test(
    deptno number(3) not null primary key,
    dname varchar2(30) not null,
    college number(3),
    loc varchar2(10));
--
INSERT INTO tbl_test VALUES        ( 101,  '컴퓨터공학과', 100,  '1호관');
INSERT INTO tbl_test VALUES        (102,  '멀티미디어학과', 100,  '2호관');
INSERT INTO tbl_test VALUES        (201,  '전자공학과 ',   200,  '3호관');
INSERT INTO tbl_test VALUES        (202,  '기계공학과',    200,  '4호관');
INSERT INTO tbl_test VALUES        (100,  '정보미디어학부', 10 , null );
INSERT INTO tbl_test VALUES        (200,  '메카트로닉스학부',10 , null);
INSERT INTO tbl_test VALUES        (10,  '공과대학',null , null);
COMMIT;
SELECT * FROM tbl_test;
--
SELECT deptno,dname,college,level
FROM tbl_test
START WITH deptno=10
CONNECT BY PRIOR deptno = college;
--
SELECT LPAD('ㄴ',(LEVEL-1)*3)|| dname
FROM tbl_test
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;
--
-- 계층구조에서 가지 제거 방법 WHERE 사용
 SELECT deptno,college,dname,loc,LEVEL
    FROM tbl_test
    WHERE dname != '정보미디어학부' -- 자식 노드는 남고 본인만 제거 
    START WITH college IS NULL
    CONNECT BY PRIOR deptno=college;
-- CONNECT BY 사용
SELECT deptno,college,dname,loc,LEVEL
    FROM tbl_test    
    START WITH college IS NULL
    CONNECT BY PRIOR deptno=college
    AND dname != '정보미디어학부'; -- 본인포함 자식노드까지 제거 
------------------
1. START WITH 최상위조건 : 계층형 구조에서 최상위 계층의 행을 식별하는 조건
2. CONNECT BY 조건 : 계층형 구조가 어떤 식으로 연결되는지를 기술하는 구문.
   PRIOR : 계층형 쿼리에서만 사용할 수 있는 연산자, '앞서의, 직전의'
SELECT empno
   ,LPAD(' ',4*(LEVEL-1))||ename ename
   ,LEVEL
   ,SYS_CONNECT_BY_PATH(ename,'/') 전체경로
   ,CONNECT_BY_ROOT ename
   ,CONNECT_BY_ISLEAF 자식-- 0, 1(마지막 노드) 
   FROM emp 
   START WITH mgr IS NULL
   CONNECT BY PRIOR empno = mgr; -- top-down 방식   
--
3. ORDER SIBLINGS BY : 부서명으로 정렬됨과 동시에 계층형 구조까지 보존
4. CONNECT_BY_ROOT : 계층형 ㅋ쿸커리에서 최상위 로우를 반환하는 연산자.
5. CONNECT_BY_ISLEAF : CONNECT BY 조건에 정의된 관계에 따라 
   해당 행이 최하위 자식행이면 1, 그렇지 안으면 0 을 반환하는 의사컬럼
6. SYS_CONNECT_BY_PATH(column, char)  : 루트 노드에서 시작해서 자신의 행까지 
   연결된 경로 정보를 반환하는 함수.
7. CONNECT_BY_ISCYCLE : 오라클의 계층형 쿼리는 루프(반복) 알고리즘을 사용한다. 
  그래서, 부모-자식 관계 잘못 정의하면 무한루프를 타고 오류 발생한다.   
  이때는 루프가 발생하는 원인을 찾아 잘못된 데이터를 수정해야 하는 데, 
  이를 위해서는 
    먼저  CONNECT BY절에 NOCYCLE 추가
    SELECT 절에 CONNECT_BY_ISCYCLE 의사 컬럼을 사용해 찾을 수 있다. 
  즉, 현재 로우가 자식을 갖고 있는 데 동시에 그 자식 로우가 부모로우 이면 1,
     그렇지 않으면 0 반환.

-- 1) 7566 JONES의 mgr을 7839에서 7369로  수정
UPDATE emp
SET mgr = 7369
WHERE empno = 7566;
-- 2)
SELECT  deptno, empno, LPAD(' ', 3*(LEVEL-1)) ||  ename
, LEVEL
, SYS_CONNECT_BY_PATH(ename, '/')
FROM emp   
START WITH  mgr IS NULL
CONNECT BY PRIOR  empno =  mgr   ;
-- 3)
ROLLBACK;
-- 4)
SELECT  deptno, empno, LPAD(' ', 3*(LEVEL-1)) ||  ename
, LEVEL
, SYS_CONNECT_BY_PATH(ename, '/')
, CONNECT_BY_ISCYCLE IsLoop
FROM emp   
START WITH  mgr IS NULL
CONNECT BY NOCYCLE PRIOR  empno =  mgr   ;
--------------------------------------------------------------------
-- 데이터 베이스 모델링 --
1. DB 모델링 정의 + 쿼리작성 (SQL , PL/SQL)
 - 현실 세계의 업무적인 프로세스를 물리적으로 DB화 시키는 과정
 예) 고객 - 주문/결재/취소 - 상품
   1) 현실세계 업무프로세스( 업무요구분석서)
   2) 개념적 모델링 (ERD)
   3) 논리적 모델링 ( 정규화 )
   4) 물리적 모델링 ( 역정규화 )
   5) 테스팅
2. DB 모델링 단계
   1) 업무 분석
     ㄱ. 관련 업무에 대한 기본 지식과 상식 필요 
     예) 국민은행 사이트 + 앱
         용어, 지식 X
     ㄴ. 신입 사원에서 업무 처리관련 모든 프로세스 분석
     ㄷ. 담당자 인터뷰
     ㄹ. 모든 문서(서류, 장표, 보고서) 파악해서 데이터로 관리되어지는 항목
         정확하게 파악 필요
     ㅁ. 백그라운드 프로세스 파악, 다양한 업무의 다양한 경우의 수를 파악
     ㅂ. 사용자의 요구 분석서 작성
   2)
   3)