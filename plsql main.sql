create database pl1;
use pl1;

create table department (
    department_id int auto_increment primary key,
    department_name varchar(255) not null,
    location varchar(255),
    manager_name varchar(255)
);
select * from department;
truncate table department;
drop table department;

insert into department (department_name, location, manager_name) values
    ('finance', 'delhi', 'XYZ'),
    ('IT', 'Mumbai', 'ABC'),
    ('HR', 'banglore', 'PQR'),
    ('marketing', 'kolkata', 'KLM');

-- Q1). Write a PL/SQL block that selects the maximum department number in the department table 
-- and store it in a SQL*PLUS variable. and print the results to screen.
delimiter //
drop procedure if exists MaxDept //
create procedure MaxDept()
begin
    declare max_num int;
    select max(department_id) into max_num from department;
    select concat('Maximum ', max_num, ' department') as Result;
end //
delimiter ;
call MaxDept();

-- Q2). Create a PL/SQL block to insert a new department number into the Departments table. Use
-- maximum dept number fetched from above and adds 10 to it. Use SQL*PLUS substitution
-- variable for department name. Leave the location as null.
delimiter //
drop procedure if exists insert_dept //
create procedure insert_dept()
begin
    declare max_num int;
    select max(department_id) + 10 into max_num from department;

    insert into department (department_id, department_name, location)
    values (max_num, 'sales', null);
    select concat('new department`s id: ', max_num) as Result;
end //
delimiter ;
call insert_dept();

-- Q3). Create a PL/SQL block to update the location for an existing department. Use substitution
-- variable for dept no. and dept location.
delimiter //
drop procedure if exists Update_Location //
create procedure Update_Location(in dep_no int, in new_locat varchar(255))
begin
    update department
    set location = new_locat
    where department_id = dep_no;
    select concat('Location updated ', dep_no) as Result;
end //
delimiter ;
call Update_Location(1, 'ahmedabad');

-- Q4). Create a PL/SQL Block to delete the department created in exercise 2. Print to the screen
-- the number of rows affected.
DELIMITER //
drop procedure if exists Update_Location //
create procedure Delete_Dept()
begin
    declare dept_no int;
    declare rows_affected int;
    select max(department_id) into dept_no from department;
    delete from department
    where department_id = dept_no;
    select row_count() into rows_affected;
    select concat('Number of rows affected: ', rows_affected) as Result;
end //
delimiter ;
call Delete_Dept();
select * from department;

-- Q5). Write a PL/SQL block which accepts employee name, basic and should display Employee name, PF and net salary.
-- HRA=31% of basic salary
-- DA=15% of basic salary
-- Net salary=basic+HRA+DA-PF
-- If the basic is less than 3000 PF is 5% of basic salary.
-- If the basic is between 3000 and 5000 PF is 7% of basic salary.
-- If the basic is between 5000 and 8000 PF is 8% of basic salary.

create table employee (
    employee_id int auto_increment primary key,
    employee_name varchar(255) not null,
    basic_salary decimal(10, 2) not null
);
insert into employee (employee_name, basic_salary) values
    ('emp1', 2500.00),
    ('emp2', 4000.00),
    ('emp3', 6000.00),
    ('emp4', 9000.00);
    
truncate table employee;
select* from employee;
drop table employee;

delimiter //
drop procedure if exists Cal_Salary //
create procedure Cal_Salary()
begin
    create temporary table temp_salary (
        emp_name varchar(255),
        pf decimal(10, 2),
        net_salary decimal(10, 2)
    );
    insert into temp_salary
    select
        employee_name as emp_name,
        case
            when basic_salary < 3000 then 0.05 * basic_salary
            when basic_salary between 3000 and 5000 then 0.07 * basic_salary
            when basic_salary between 5000 and 8000 then 0.08 * basic_salary
            ELSE 0.12 * basic_salary
        end as pf,
        basic_salary + 0.31 * basic_salary + 0.15 * basic_salary - (
            case
                when basic_salary < 3000 then 0.05 * basic_salary
                when basic_salary between 3000 and 5000 then 0.07 * basic_salary
                when basic_salary between 5000 and 8000 then 0.08 * basic_salary
                ELSE 0.12 * basic_salary
            end
        ) as net_salary
    from employee;
    select * from temp_salary;
    drop temporary table if exists temp_salary;
end //
delimiter ;
call Cal_Salary();

-- Q6). Write a PL/SQL block to find the salary grade of the specified employee.
-- If grade is 1 display ‘the employee is junior engineer’
-- If grade is 2 display ‘the employee is engineer’
-- If grade is 3 display ‘the employee is lead engineer’
-- If grade is 4 display ‘the employee is Manager’
-- If grade is 5 display ‘the employee is Project manager’
-- (Use case expression)

create table employees (
    employee_id int auto_increment primary key,
    salary_grade int
);
insert into employees (salary_grade) values
    (1),
    (2),
    (3),
    (4),
    (5);
    
delimiter //
drop procedure if exists sal_grade //
create procedure sal_grade(in emp_id int)
begin
    declare v_grade int;
    select salary_grade into v_grade
    from employees
    where employee_id = emp_id;
    case v_grade
        when 1 then select 'The employee is Junior Engineer' as Result;
        when 2 then select 'The employee is Engineer' as Result;
        when 3 then select 'The employee is Lead Engineer' as Result;
        when 4 then select 'The employee is Manager' as Result;
        when 5 then select 'The employee is Project Manager' as Result;
        else select 'Invalid salary grade' as Result;
    end case;
end //
delimiter ;
call sal_grade(1);

-- Q7). Wrtie a PL/SQL block to award an employee with the bonus.
-- Bonus is 15% of commission drawn by the employee.
-- If the employee does not earn any commission then display a message that ‘employee does
-- not earn any commission’. Otherwise add bonus to the salary of the employee. The block
-- should accept an input for the employee number.

create table emp1 (
    employee_id int auto_increment primary key,
    commission decimal(10, 2),
    salary decimal(10, 2)
);
insert into emp1 (commission, salary) values
    (1000.00, 50000.00),
    (500.00, 60000.00),
    (NULL, 70000.00), 
    (2000.00, 80000.00);
    
delimiter //
drop procedure if exists awardbonus //
create procedure awardbonus(in emp_id int)
begin
    declare commission1 decimal(10, 2);
    declare bonus1 decimal(10, 2);
    select commission into commission1
    from emp1
    where employee_id = emp_id;
    if commission1 is null then
        select 'Employee does not earn any commission' as Result;
    else set bonus1 = 0.15 * commission1;
        update emp1
        set salary = salary + bonus1
        where employee_id = emp_id;
        select concat('Bonus awarded to employee ', emp_id, ': ', bonus1) as Result;
    end if;
end //
delimiter ;
call AwardBonus(1);

-- Q8). Write a PL/SQL block which displays the department name, total no of employees in the
-- department, avg salary of the employees in the department for all the departments from
-- department 10 to department 40 in the Dept table.If no employees are working in
-- the department ,then display a message that no employees are working in that department.

create table emp2 (
    employee_id int auto_increment primary key,
    department_id int,
    salary decimal(10, 2));
select * from emp2;
truncate table emp2;

insert into emp2 (department_id, salary) values
    (10, 50000.00),
    (10, 55000.00),
    (10, 48000.00),
    (20, 60000.00),
    (20, 50000.00),
    (40, 55000.00),
    (40, 60000.00),
    (40, 62000.00),
    (40, 58000.00),
    (40, 59000.00);

delimiter //
drop procedure if exists dept_info //
create procedure dept_info()
begin
    declare dept_no int;
    declare total_employees int;
    declare avg_salary decimal(10, 2);
    set dept_no = 10;
    while dept_no <= 40 do
        select count(*) into total_employees , avg(salary) into avg_salary
        from emp2
        where department_id = dept_no;
        if total_employees > 0 then select concat('Department ', dept_no, ': ', total_employees, ' employees, Avg Salary: ', avg_salary) as Result;
        else select concat('No employees are working in Department ', dept_no) as Result;
        end if;
        set dept_no = dept_no + 10;
    end while;
end //
delimiter ;
call Dept_Info();

Output:
+-----------------------------------------------+
| Result                                        |
+-----------------------------------------------+
| Department 10: 3 employees, Avg Salary: 51000.00 |
| Department 20: 2 employees, Avg Salary: 55000.00 |
| Department 30: No employees are working in Department 30 |
| Department 40: 5 employees, Avg Salary: 58800.00 |
+-----------------------------------------------+

-- Q9). Write a PL/SQL block which accepts employee number and finds the average salary of the
-- employees working in the department where that employee works. If his salary is more than 
-- the average salary of his department, then display message that ‘employee’s salary is more 
-- than average salary’ else display ‘employee’s salary is less than average salary’
delimiter //
drop procedure if exists compare //
create procedure compare(in emp0_id int)
begin
    declare emp_sal decimal(10, 2);
    declare dept_avg decimal(10, 2);
    select salary into employee_salary
    from emp2
    where employee_id = emp0_id;
    select avg(salary) into dept_avg
    from emp2
    where department_id = (select department_id from employees where employee_id = emp0_id);
    if emp_sal > dept_avg then
        select concat('employee’s salary is more than average salary') as result;
    else select concat('employee’s salary is less than average salary') as result;
    end if;
end //
delimiter ;
call compare(2); 

Output:
+-----------------------------------------------------+
| Result                                              |
+-----------------------------------------------------+
| employee’s salary is more than average salary 	  |
+-----------------------------------------------------+

-- Q10). Create a procedure that deletes rows from the emp table. It should accept 1 parameter, job;
-- only delete the employee’s with that job. Display how many employees were deleted.
create table emp3 (
    empid int auto_increment primary key,
    emp_name varchar(50),
    job varchar(50),
    salary decimal(10, 2)
);
select * from emp3;
truncate table emp3;
drop table emp3;
insert into emp3 (emp_name, job, salary) values
    ('ram', 'manager', 70000.00),
    ('raj', 'engineer', 60000.00),
    ('raman', 'manager', 80000.00),
    ('ramesh', 'analyst', 55000.00),
    ('rajesh', 'engineer', 65000.00);

delimiter //
drop procedure if exists delete_emp //
create procedure delete_emp(in job1 varchar(50))
begin
    declare deleted_count int;
    delete from emp3 where job = job1;
    select row_count() into deleted_count;
    select concat('Deleted ', deleted_count, ' employees with job ', job1) as Result;
end //
delimiter ;
call delete_emp('engineer'); 

-- Q11). Change the above procedure so that it returns the number of employees removed via an OUT parameter.
delimiter //
drop procedure if exists delete_emp1 //
create procedure delete_emp1(
    in job2 varchar(50),
    out delete_count int )
begin
    create temporary table temp_emp as
    select * from emp3 where job = job2;
    delete from emp3 where job = job2;
    select row_count() into delete_count;
end //
delimiter ;
declare deletedCount int;
call delete_emp1('engineer', deletedCount); 
select deletedCount as Result;
select * from temp_emp;

 Result
   2   

 employee_id  employee_name    job     salary  
      2         raj      engineer   60000.00
      5       rajesh     engineer   65000.00

-- Q12). Convert the above program to a function. Instead of using an OUT parameter for the
-- number of employees deleted, use the functions return value and display how many employees were deleted.
delimiter //
create function delete_emp(job1 VARCHAR(50)) RETURNS INT
begin
    declare delete_Count int;
    create temporary table temp_del as
    select * from emp3 where job = job1;
    delete from emp3 where job = job1;
    select row_count() into deletedCount;
    return deletedCount;
end //
delimiter ;
select delete_emp('engineer') as result; 
select * from temp_del;

-- Q13). Create a table having the following structure Accounts(Account_id, branch_name, amount_balance)
create table accounts (
    account_id int primary key,
    branch_name varchar(50),
    amount_balance decimal(10, 2)
);
insert into accounts (account_id, branch_name, amount_balance) values
    (1, 'north', 1000.00),
    (2, 'south', 500.00),
    (3, 'east', 2000.00),
    (4, 'west', 1500.00);
truncate table accounts;
-- a. Write a PL/SQL procedure to perform withdraw operation that only permits a withdrawal if there
-- sufficient funds in the account. The procedure should take Account_id and withdrawal amount as input.
delimiter //
drop procedure if exists withdraw_money //
create procedure withdraw_money( in acc_id int, in withdrawal_amount decimal(10, 2))
begin
    declare cur_bal decimal(10, 2);
    if not exists (select 1 from accounts where account_id = acc_id) then
        signal sqlstate '45000' set message_text = 'account does not exist';
    end if;
    select amount_balance into cur_bal
    from accounts
    where account_id = acc_id;
    if cur_bal < withdrawal_amount then
        signal sqlstate '45000' set message_text = 'insufficient amount for withdrawal';
    else
        update accounts set amount_balance = amount_balance - withdrawal_amount 
        where account_id = acc_id;
    end if;
end //
delimiter ;
call withdraw_money(1, 500.00);
select * from accounts;

-- b. Write a procedure to deposit money into someone's account. The procedure should accept account_id and deposit amount.

delimiter //
drop procedure if exists deposit_money //
create procedure deposit_money(
    in acc_id int,
    in deposit_amount decimal(10, 2))
begin
    if not exists (select 1 from accounts where account_id = acc_id) then
        signal sqlstate '45000' set message_text = 'account does not exist';
    else
        update accounts set amount_balance = amount_balance + deposit_amount
        where Account_id = acc_id;
    end if;
end //
delimiter ;
call deposit_money(2, 1000.00);
select * from accounts; 

-- c. Write a procedure to transfer money from one person's account to another. The
-- procedure should table two account_id’s one for giver and one for receiver and the amount to be transferred.
delimiter //
drop procedure if exists transfer_money //
create procedure transfer_money(
    in giver_acc int,
    in receiver_acc int,
    in transfer_amount decimal(10, 2))
begin
    declare giver_bal decimal(10, 2);
    if not exists (select 1 from accounts where account_id = giver_acc) then
        signal sqlstate '45000' set message_text = 'giver account does not exist';
    end if; 
    select amount_balance into giver_bal from accounts where account_id = giver_acc;
    if giver_bal < transfer_amount then
        signal sqlstate '45000' set message_text = 'insufficient funds for transfer';
    else
        update accounts set amount_balance = amount_balance - transfer_amount
        where account_id = giver_acc;
        update accounts set amount_balance = amount_balance + transfer_amount
        where Account_id = receiver_acc;
    end if;
end //
delimiter ;
CALL transfer_money(3, 4, 300.00);
select * from accounts; 


-- Q14). 14. Write a PL/SQL block to accept an employee number. and use a record variable to store the
-- record of that employee. and insert it into retired_employee table.
-- Retired_employee table has the following structure
-- Retired_employee (empno, ename, hiredate, leaveDate, salary, mgr_id, deptno).
-- Set the leavedate to the current date.
create table Retd_employee (
    empno int primary key,
    ename varchar(50),
    hiredate date,
    leaveDate date,
    salary decimal(10, 2),
    mgr_id int,
    deptno int
);
select * from Retd_employee; 
truncate table Retd_employee;

create table emp14 (
    empno int primary key,
    ename varchar(50),
    hiredate date,
    salary decimal(10, 2),
    mgr_id int,
    deptno int
);
select * from emp14; 
truncate table emp14;

insert into emp14 (empno, ename, hiredate, salary, mgr_id, deptno) values
    (1, 'abc', '2023-01-01', 50000.00, null, 10),
    (2, 'xyz', '2023-02-01', 60000.00, 1, 20),
    (3, 'pqr', '2023-03-01', 70000.00, 1, 10);
delimiter //
drop procedure if exists retd_emp //
create procedure retd_emp(in p_empno int)
begin
    declare n_ename varchar(50);
    declare n_hiredate date;
    declare n_salary decimal(10, 2);
    declare n_mgr_id int;
    declare n_deptno int;

    select ename, hiredate, salary, mgr_id, deptno
    into n_ename, n_hiredate, n_salary, n_mgr_id, n_deptno
    from emp14
    where empno = p_empno;
    
    insert into Retd_employee (empno, ename, hiredate, leavedate, salary, mgr_id, deptno)
    values (p_empno, n_ename, n_hiredate, current_date, n_salary, n_mgr_id, n_deptno);

    select 'record inserted successfully.' as message;
end //
delimiter ;
call retd_emp(2);
select * from Retd_employee;


-- Q15). 15. Write a PL/SQL Block to create a PL/SQL table which can store grade and on of employees
-- with that grade. Get the information about the grade and number of employees with that
-- grade and store it in the PL/SQL table. Then retrieve the information from the PL/SQL table
-- and display it on the screen in the following way.
-- No of employees with the grade 1 are 3
-- No of employees with the grade 2 are 2
-- No of employees with the grade 3 are 1
-- No of employees with the grade 4 are 2
-- No of employees with the grade 5 are 5
create table emp15 (
    emp_id int primary key,
    emp_name varchar(50),
    grade int
);
insert into emp15 (emp_id, emp_name, grade) values
    (1, 'emp1', 1),
    (2, 'emp2', 1),
    (3, 'emp3', 1),
    (4, 'emp4', 2),
    (5, 'emp5', 2),
    (6, 'emp6', 3),
    (7, 'emp7', 4),
    (8, 'emp8', 4),
    (9, 'emp9', 5),
    (10, 'emp10', 5),
	(11, 'emp11', 5),
    (12, 'emp12', 5),
    (13, 'emp13', 5);
delimiter //
drop procedure if exists grade_emp //
create procedure grade_emp()
begin
    create temporary table temp_grade (
        grade int,
        employee_count int
    );
    insert into temp_grade
    select grade, count(*) as employee_count
    from emp15
    group by grade;
    select concat('No of employees with the grade ', grade, ' are ', employee_count) as output
    from temp_grade;
    drop temporary table if exists temp_grade;
end //
delimiter ;
call grade_emp();

-- Q16). Write a program that gives all employees in department 10 a 15% pay increase. Display a
-- message displaying how many Employees were awarded the increase.

create table Emp16 (
    emp_id int primary key,
    emp_name varchar(50),
    salary decimal(10, 2),
    deptno int
);
select * from Emp16;
truncate table Emp16;
drop table Emp16;

insert into Emp16 (emp_id, emp_name, salary, deptno) values
    (1, 'emp1', 50000.00, 10),
    (2, 'emp2', 60000.00, 20),
    (3, 'emp3', 70000.00, 10),
    (4, 'emp4', 55000.00, 10),
    (5, 'emp5', 65000.00, 20),
    (6, 'emp6', 75000.00, 10);

delimiter //
drop procedure if exists increase_pay  //  
create procedure increase_pay()
begin
    declare iemp_count int default 0;
    declare n_emp_id int;
    declare n_salary decimal(10, 2);
    declare emp_cursor cursor for
        select emp_id, salary
        from Emp16
        where deptno = 10;
    declare continue handler for not found
        set n_emp_id = null;
    open emp_cursor;
    emp_loop: loop
        fetch emp_cursor into n_emp_id, n_salary;
        if n_emp_id is null then
            leave emp_loop;
        end if;
        update Emp16
        set salary = salary * 1.15
        where emp_id = n_emp_id;
        set iemp_count = iemp_count + 1;
    end loop;
    close emp_cursor;
    select concat(iemp_count, ' employees in department 10 were awarded a 15% pay increase.') as message;
end //
delimiter ;
call increase_pay();

-- Q17). Write a PL/SQL block and use cursor to retrieve the details of the employees with grade
-- 5.and then display employee no,job_id ,max_sal and min_sal and grade for all these employees.
create table emp17 (
    emp_id int primary key,
    job_id varchar(50),
    salary decimal(10, 2),
    grade int
);
select * from Emp17;
truncate table Emp17;
drop table Emp17;

insert into emp17 (emp_id, job_id, salary, grade) values
    (1, 'Manager', 80000.00, 5),
    (2, 'Analyst', 60000.00, 5),
    (3, 'Developer', 70000.00, 5),
    (4, 'Manager', 85000.00, 5),
    (5, 'Analyst', 65000.00, 5);
delimiter //
drop procedure if exists display_g5 //
create procedure display_g5()
begin
    declare v_emp_id int;
    declare v_job_id varchar(50);
    declare v_max_salary decimal(10, 2) default 0;
    declare v_min_salary decimal(10, 2) default 999999999;
    declare v_grade int;
    declare grade5_cursor cursor for
        select emp_id, job_id, salary, grade
        from emp17
        where grade = 5;
    declare continue handler for not found
        set v_emp_id = null;
    open grade5_cursor;
    grade5_loop: loop
        fetch grade5_cursor into v_emp_id, v_job_id, v_max_salary, v_grade;
        if v_emp_id is null then
            leave grade5_loop;
        end if;
        if v_max_salary > v_max_salary then
            set v_max_salary := v_max_salary;
        end if;
        if v_min_salary < v_min_salary then
            set v_min_salary := v_min_salary;
        end if;
        select concat('Employee No: ', v_emp_id, ', Job ID: ', v_job_id, ', Max Salary: ', v_max_salary, ', Min Salary: ', v_min_salary, ', Grade: ', v_grade) as output;
    end loop;
    close grade5_cursor;
end //
delimiter ;

call display_g5();



CREATE TABLE department18 (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO department18 (dept_id, dept_name) VALUES
    (1, 'HR'),
    (2, 'Finance'),
    (3, 'IT'),
    (4, 'Marketing'),
    (5, 'Sales');

DELIMITER //
drop PROCEDURE if exists Copy_Dept //
CREATE PROCEDURE Copy_Dept()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_dept_id INT;
    DECLARE v_dept_name VARCHAR(50);
    DECLARE dept_cursor CURSOR FOR
        SELECT dept_id, dept_name FROM department18;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    CREATE TABLE IF NOT EXISTS old_dept (
        dept_id INT PRIMARY KEY,
        dept_name VARCHAR(50)
    );
    OPEN dept_cursor;
    department_loop: LOOP
        FETCH dept_cursor INTO v_dept_id, v_dept_name;
        IF done THEN
            LEAVE department_loop;
        END IF;
        INSERT INTO old_dept (dept_id, dept_name) VALUES (v_dept_id, v_dept_name);
    END LOOP;
    CLOSE dept_cursor;
    SELECT COUNT(*) AS rows_copied FROM old_dept;
END //
DELIMITER ;

CALL Copy_Dept();


-- Q19 
CREATE TABLE department19 (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);
INSERT INTO department19 (dept_id, dept_name) VALUES
    (10, 'HR'),
    (20, 'Finance'),
    (30, 'IT'),
    (40, 'Marketing'),
    (50, 'Sales');
CREATE TABLE employee19 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES department19(dept_id)
);
select * from employee19;
truncate table employee19;
drop table employee19;
INSERT INTO employee19 (emp_id, emp_name, dept_id) VALUES
    (1, 'XYZ', 30),
    (2, 'ABC', 30),
    (3, 'PQR', 20),
    (4, 'DEF', 40),
    (5, 'MNO', 30);
DELIMITER //
drop procedure if exists Emp_Dept30 //
CREATE PROCEDURE Emp_Dept30()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_emp_name VARCHAR(50);
    DECLARE emp_cursor CURSOR FOR
        SELECT emp_name
        FROM employee19
        WHERE dept_id = 30;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN emp_cursor;
    employee_loop: LOOP
        FETCH emp_cursor INTO v_emp_name;
        IF done THEN
            LEAVE employee_loop;
        END IF;
        SELECT v_emp_name AS EmployeeName;
    END LOOP;
    CLOSE emp_cursor;
END //
DELIMITER ;
call Emp_Dept30();


DELIMITER //
drop procedure if exists Select_Dept //
CREATE PROCEDURE Select_Dept()
BEGIN
    DECLARE dept_cursor CURSOR FOR
        SELECT * FROM department19;
    DECLARE v_dept_id INT;
    DECLARE v_dept_name VARCHAR(50);
    OPEN dept_cursor;
    dept_loop: LOOP
        FETCH dept_cursor INTO v_dept_id, v_dept_name;
        IF (v_dept_id IS NULL) THEN
            LEAVE dept_loop;
        END IF;
        SELECT v_dept_id AS dept_id, v_dept_name AS dept_name;
    END LOOP;
    CLOSE dept_cursor;
END //
DELIMITER ;
CALL Select_Dept();



CREATE TABLE emp21 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO emp21 (emp_id, emp_name, salary) VALUES
    (1, 'abc', 60000.00),
    (2, 'def', 75000.00),
    (3, 'ghi', 80000.00),
    (4, 'jkl', 70000.00),
    (5, 'mno', 90000.00),
    (6, 'pqr', 85000.00),
    (7, 'stu', 95000.00),
    (8, 'vwx', 72000.00),
    (9, 'yza', 88000.00),
    (10, 'aaa', 92000.00);

DELIMITER //
drop procedure if exists top_emp //
CREATE PROCEDURE top_emp()
BEGIN
    DECLARE v_emp_id INT;
    DECLARE v_emp_name VARCHAR(50);
    DECLARE v_salary DECIMAL(10, 2);
    DECLARE top_employees_cursor CURSOR FOR
        SELECT emp_id, emp_name, salary
        FROM emp21
        ORDER BY salary DESC
        LIMIT 6;
    OPEN top_employees_cursor;
    top_employees_loop: LOOP
        FETCH top_employees_cursor INTO v_emp_id, v_emp_name, v_salary;
        IF (v_emp_id IS NULL) THEN
            LEAVE top_employees_loop;
        END IF;
        SELECT v_emp_id AS emp_id, v_emp_name AS emp_name, v_salary AS salary;
    END LOOP;
    CLOSE top_employees_cursor;
END //
DELIMITER ;
CALL top_emp();

CREATE TABLE dept22 (
    deptno INT PRIMARY KEY,
    dname VARCHAR(50)
);
INSERT INTO dept22 (deptno, dname) VALUES
    (10, 'HR'),
    (20, 'Finance'),
    (30, 'IT'),
    (40, 'Marketing'),
    (50, 'Sales');
CREATE TABLE emp22 (
    empno INT PRIMARY KEY,
    ename VARCHAR(50),
    job VARCHAR(50),
    hiredate DATE,
    salary DECIMAL(10, 2),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES dept22(deptno)
);
INSERT INTO emp22 (empno, ename, job, hiredate, salary, deptno) VALUES
    (1, 'abc', 'Manager', '2022-01-01', 80000.00, 10),
    (2, 'xyz', 'Analyst', '2022-02-15', 60000.00, 20),
    (3, 'pqr', 'Developer', '2022-03-20', 70000.00, 30),
    (4, 'aaa', 'Manager', '2022-04-10', 75000.00, 20),
    (5, 'bbb', 'Analyst', '2022-05-05', 65000.00, 30);

DELIMITER //
CREATE PROCEDURE pro22()
BEGIN
    DECLARE v_deptno INT;
    DECLARE v_dname VARCHAR(50);
    DECLARE dept_cursor CURSOR FOR
        SELECT deptno, dname
        FROM dept22;
    DECLARE v_emp_ename VARCHAR(50);
    DECLARE v_emp_job VARCHAR(50);
    DECLARE v_emp_hiredate DATE;
    DECLARE v_emp_salary DECIMAL(10, 2);
    DECLARE emp_cursor CURSOR FOR
        SELECT ename, job, hiredate, salary
        FROM emp22
        WHERE deptno = v_deptno;
    OPEN dept_cursor;
    dept_loop: LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;
        IF (v_deptno IS NULL) THEN
            LEAVE dept_loop;
        END IF;
        SELECT CONCAT('Department: ', v_deptno, ', ', v_dname) AS dept_details;
        OPEN emp_cursor;
        emp_loop: LOOP
            FETCH emp_cursor INTO v_emp_ename, v_emp_job, v_emp_hiredate, v_emp_salary;
            IF (v_emp_ename IS NULL) THEN
                LEAVE emp_loop;
            END IF;
            SELECT CONCAT('Employee: ', v_emp_ename, ', Job: ', v_emp_job, ', Hire Date: ', v_emp_hiredate, ', Salary: ', v_emp_salary) AS emp_details;
        END LOOP;
        CLOSE emp_cursor;
    END LOOP;
    CLOSE dept_cursor;
END //
DELIMITER ;

CREATE TABLE emp23 (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary DECIMAL(10, 2),
    deptno INT
);
INSERT INTO emp23 (emp_id, emp_name, salary, deptno) VALUES
    (1, 'abc', 60000.00, 10),
    (2, 'xyz', 75000.00, 20),
    (3, 'pqr', 80000.00, 30),
    (4, 'lmn', 70000.00, 20),
    (5, 'def', 90000.00, 30);
DELIMITER //
drop procedure if exists Raise_salary //
CREATE PROCEDURE Raise_salary(IN p_deptno INT, IN p_percentage DECIMAL(5,2))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_emp_id INT;
    DECLARE v_salary DECIMAL(10, 2);
    DECLARE emp_cursor CURSOR FOR
        SELECT emp_id, salary
        FROM emp23
        WHERE deptno = p_deptno
        FOR UPDATE;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN emp_cursor;
    employee_loop: LOOP
        FETCH emp_cursor INTO v_emp_id, v_salary;
        IF done THEN
            LEAVE employee_loop;
        END IF;
        UPDATE emp23
        SET salary = salary + (salary * p_percentage / 100)
        WHERE emp_id = v_emp_id;
    END LOOP;
    CLOSE emp_cursor;
END //
DELIMITER ;
CALL Raise_salary(30, 10);
select * from emp23;