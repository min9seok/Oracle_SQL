create or replace PROCEDURE up_POINT_Count
    (
        p_user_id member.user_id%TYPE
    )
IS
    v_point_cnt NUMBER(10);
    v_exp_cnt NUMBER(10);
BEGIN
    SELECT NVL(user_points, 0) INTO v_point_cnt
    FROM member
    WHERE user_id = p_user_id;
    DBMS_OUTPUT.PUT_LINE('내포인트');
    DBMS_OUTPUT.PUT_LINE(v_point_cnt||'P');

   SELECT sum(balance) INTO v_exp_cnt
   FROM point_history 
   WHERE user_id = p_user_id AND end_date BETWEEN SYSDATE AND SYSDATE+30;
    DBMS_OUTPUT.PUT_LINE('30일 내' ||v_exp_cnt|| 'P가 소멸될 예정이에요');
END;
