select employee_id, first_name, last_name,
     manager_id, department_id
from employees
where department_id NOT IN -- ANTI JOIN
                        (select department_id 
                        from departments
                        where location_id = 1700);
-- SEMI JOIN : EXISTS
select * 
from departments d
where EXISTS
    (select * 
    from employees e
      where d.department_id = e.department_id
      and e.salary > 2500);
--
 select last_name "employee"
      , CONNECT_BY_ISCYCLE "Cycle",
    LEVEL
    , SYS_CONNECT_BY_PATH(last_name, '/') "Path"
    from employees
    where LEVEL <=3 and department_id = 80
    START WITH last_name ='King'
    CONNECT BY NOCYCLE PRIOR employee_id = manager_id and LEVEL <= 4
    ORDER BY "employee", "Cycle", LEVEL, "Path";
