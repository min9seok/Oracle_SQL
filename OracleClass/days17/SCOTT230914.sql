-- 동적 쿼리 --
--동적 SQL
--동적 ? 동적 배열
--int [] m;
--int size = scanner.nextInt();
--m = new int[size];

-- 실행 시점에 SQL 미 결정 상태
1. 동적 SQL 사용하는 3가지 상황
 1) 컴파일 시에 SQL문장이 확정되지 않은 경우 ( 가장 많이 사용 되는 경우)
 WHERE 조건절..
 2) PL/SQL 블럭 안에서 DDL 문을 사용하는 경우 
 CREATE,ALTER,DROP
 예) 여러 개 게시판 생성
   저장할 컬럼  (날짜,내용,제목)
   체크한 컬럼으로 동적으로 게시판 생성.
 3) PL/SQL 블럭 안에서
 ALTER SYSTEM,SESSION 명령어를 사용할 때
2. PL/SQL 동적 쿼리를 사용하는 방법
 1) NDS(Native Pynamic SQL) 원시 동적 쿼리
  EXEC[UTE] IMMEDIATE 문
  형식)
  EXEC[UTE] IMMEDIATE 동적쿼리문
  [INTO 변수명, 변수명...]
  [USING IN/OUT/IN OUT 파라미터 ...]
 2) DBMS_SQL 패키지 X
 
3. 예제
 1) 익명 프로시저 
DECLARE
 vsql varchar2(2000);
 vdeptno emp.deptno%type;
 vempno emp.empno%type;
 vename emp.ename%type;
 vjob emp.job%type;
BEGIN
 vsql := 'SELECT deptno,empno,ename,job';
 vsql :=vsql||' FROM emp';
 vsql :=vsql||' WHERE empno=7369';
 
EXECUTE IMMEDIATE vsql
 INTO vdeptno,vempno,vename,vjob; 
 DBMS_OUTPUT.PUT_LINE(vdeptno||', '||vempno||', '||vename||', '||vjob);
--EXCEPTION
END;

-- 저장 프로시저
CREATE OR REPLACE PROCEDURE up_ndsemp
(pempno emp.empno%type)
IS
 vsql varchar2(2000);
 vdeptno emp.deptno%type;
 vempno emp.empno%type;
 vename emp.ename%type;
 vjob emp.job%type;
BEGIN
 vsql := 'SELECT deptno,empno,ename,job';
 vsql :=vsql||' FROM emp';
 vsql :=vsql||' WHERE empno=:pempno';
 
EXECUTE IMMEDIATE vsql
 INTO vdeptno,vempno,vename,vjob
 USING IN pempno; 
 DBMS_OUTPUT.PUT_LINE(vdeptno||', '||vempno||', '||vename||', '||vjob);
--EXCEPTION
END;

exec up_ndsemp(7369);

-- 문제) dept 테이블에 새로운 부서 추가하는 동적쿼리 사용 저장프로시저
create or replace procedure up_ndsinsdept
(pdname dept.dname%type := NULL
,ploc dept.loc%type DEFAULT NULL)
is
 vsql varchar2(2000);
begin
 vsql := 'INSERT into dept (deptno,dname,loc)';
 vsql := vsql || ' values(seq_dept.nextval,:pdname,:ploc)';
 
 EXECUTE IMMEDIATE vsql
 using pdname, ploc;
 DBMS_OUTPUT.PUT_LINE('성공');
 commit;
--exception
end;

exec up_ndsinsdept('QC','SEOUL');
SELECT *
FROM dept;

-- 사용자가 원하는 형태의 게시판을 생성( DDL 문) 동적쿼리
DECLARE
 vtablename VARCHAR2(100);
 vsql varchar2(2000);
begin
 vtablename := 'tbl_board';
 vsql := 'CREATE table ' || vtablename;
 vsql := vsql||'(id NUMBER PRIMARY KEY ';
 vsql := vsql||' ,name varchar2(20) ) ' ;
 
 DBMS_OUTPUT.PUT_LINE(vsql); 
 
 EXECUTE IMMEDIATE vsql;

end;
desc tbl_board;

-- OPEN - FOR 문 : SELECT 여러 개의 행 + 반복처리
   OPEN   커서
   FOR    커서 반복 처리
   --동적 sql을 실행 > 결과물(여러 개의 행) + 커서 처리
--
create or replace procedure up_ndsselemp
(pdeptno emp.deptno%type)
is
 vsql varchar2(2000);
 vcur sys_refcursor; -- 9i REF CURSOR
 vrow emp%ROWTYPE;
begin
 vsql := 'SELECT * ';
 vsql := vsql||'FROM emp ';
 vsql := vsql||'WHERE deptno = :pdeptno ';
 
 OPEN vcur FOR vsql using pdeptno;
 loop
 fetch vcur into vrow;
 exit when vcur%notfound;
 DBMS_OUTPUT.PUT_LINE(vrow.deptno||', '||vrow.empno||', '||vrow.ename||', '||vrow.job);
 end loop;
 close vcur;
end;

exec up_ndsselemp(30);

-- 동적 쿼리 검색 예제
-- [부서번호,부서명, 지역명] 검색조건  입력
create or replace procedure up_ndssearchemp
(psearchcondition number -- 1 부서번호,2사원명,3직업
,psearchword varchar2
)
is
 vsql varchar2(2000);
 vcur sys_refcursor; -- 9i REF CURSOR
 vrow emp%ROWTYPE;
begin
 vsql := 'SELECT * ';
 vsql := vsql||'FROM emp '; 
 IF psearchcondition =1 THEN
 vsql := vsql||'WHERE deptno = :psearchword ';
 ELSIF psearchcondition =2  THEN
 vsql := vsql||'WHERE REGEXP_LIKE(ename,:psearchword,''i'')';
 ELSIF psearchcondition =3 THEN
 vsql := vsql||'WHERE REGEXP_LIKE(job,:psearchword,''i'')';
 END IF;
 OPEN vcur FOR vsql using psearchword;
 loop
 fetch vcur into vrow;
 exit when vcur%notfound;
 DBMS_OUTPUT.PUT_LINE(vrow.deptno||', '||vrow.empno||', '||vrow.ename||', '||vrow.job);
 end loop;
 close vcur;
exception
when NO_DATA_FOUND then
 raise_application_error(-20000,'없어');
when others then
 raise_application_error(-20000,'에러');
end;

exec UP_NDSSEARCHEMP(1,20);
exec UP_NDSSEARCHEMP(2,'L');
exec UP_NDSSEARCHEMP(3,'c');

grant connect, resource, dba to goodchoice;


