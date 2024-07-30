Q1
-----------------------------
create database t2;
use t2;
CREATE TABLE EMP (
    empno INT PRIMARY KEY,
    empname VARCHAR(255),
    salary DECIMAL(10, 2),
    deptno INT
);
delimiter //

create procedure details()
begin
	declare done int default 0;
    declare emp_name varchar(20);
    declare dept_no int;
    declare salary decimal(10,2);

    declare  emp_cursor cursor for select empno, empname, salary, deptno from emp;
    declare continue handler for not found set done = 1;
    
    open emp_cursor ;
    
    fetch emp_cursor into emp_name,dept_no,salary;
    
    e1: loop
    if done = 1 then
    leave e1;
     end if;
     select concat(emp_name,'employee working in departmenmt',dept_no,'earn rs.',salary) As  
    
     fetch emp_cursor into emp_name,dept_no,salary;
   end loop;
   close emp_cursor;
    delimiter ;
---------------------------------
Q2
-------------------------
  CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  salary DECIMAL(10, 2),
  department_id INT
);
INSERT INTO employees (employee_id, salary, department_id) VALUES
(11, 50000.00, 1),
(12, 60000.00, 2),
(13, 70000.00, 3),
(14,80000.00, 4),
(15, 90000.00, 5);

delimiter //
    
DECLARE emp_id INT;
DECLARE emp_salary DECIMAL(10, 2);

DECLARE emp_cursor CURSOR FOR
  SELECT employee_id, salary
  FROM employees
  WHERE department_id = 1;

DECLARE CONTINUE HANDLER FOR NOT FOUND
  SET done = TRUE;

SET done = FALSE;

OPEN emp_cursor;

emp_loop: LOOP

  FETCH emp_cursor INTO emp_id, emp_salary;

  IF done THEN
    LEAVE emp_loop;
  END IF;

  UPDATE employees
  SET salary = salary * 1.2
  WHERE employee_id = emp_id;

END LOOP emp_loop;

CLOSE emp_cursor;

SELECT ROW_COUNT() AS rows_affected;

 delimiter ;   
------------------------------------
Q3
_-_______________________________

DELIMITER //
CREATE PROCEDURE mca1()
BEGIN
  DECLARE emp_id INT;
  DECLARE emp_salary DECIMAL(10, 2);
  DECLARE done BOOLEAN DEFAULT FALSE;

  DECLARE emp_cursor CURSOR FOR
    SELECT empno, salary,department_id 
    FROM EMP
    WHERE deptno = 10;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET done = TRUE;

  OPEN emp_cursor;

  emp_loop: LOOP
    FETCH emp_cursor INTO emp_id, emp_salary;

    IF done THEN
      LEAVE emp_loop;
    END IF;

    UPDATE EMP
    SET salary = salary * 1.2
    WHERE empno = emp_id;

  END LOOP emp_loop;

  CLOSE emp_cursor;

  SELECT ROW_COUNT() AS rows_affected;
END //
DELIMITER ;

select * from employees;
CALL mca1();
--------------------------------------
Q4
________________________________
CREATE TABLE EMP (
  empno INT PRIMARY KEY,
  empname VARCHAR(50),
  salary DECIMAL(10, 2),
  deptno INT
);
drop table emp;

INSERT INTO EMP (empno, empname, salary, deptno) VALUES
(1, 'hardik ', 75000.00, 10),
(2, 'yash ', 80000.00, 20),
(3, 'viram ', 70000.00, 10),
(4, 'jay ', 90000.00, 30);

DELIMITER //

CREATE PROCEDURE getEmployee()
BEGIN
  DECLARE emp_name VARCHAR(50);
  DECLARE emp_department VARCHAR(50);
  DECLARE emp_salary DECIMAL(10, 2);
  DECLARE done BOOLEAN DEFAULT FALSE;

  DECLARE emp_cursor CURSOR FOR
    SELECT empname, deptno, salary
    FROM EMP
    ORDER BY salary DESC;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET done = TRUE;

  OPEN emp_cursor;

  emp_loop: LOOP
    FETCH emp_cursor INTO emp_name, emp_department, emp_salary;

    IF done THEN
      LEAVE emp_loop;
    END IF;

    SELECT CONCAT('Employee Name: ', emp_name) AS emp_name,
           CONCAT('Department: ', emp_department) AS emp_department,
           CONCAT('Salary: $', emp_salary) AS emp_salary;

  END LOOP emp_loop;

  CLOSE emp_cursor;
END //

DELIMITER ;
call getEmployee();
-------------------------------
Q5
---------------------------



CREATE TABLE EMP (
  empno INT PRIMARY KEY,
  empname VARCHAR(50),
  salary DECIMAL(10, 2),
  city VARCHAR(50)
);
drop table emp;

INSERT INTO EMP (empno, empname, salary, city) VALUES
(1, 'hardik', 75000.00, 'New York'),
(2, 'yash ', 80000.00, 'Los Angeles'),
(3, 'biraj ', 70000.00, 'Chicago'),
(4, 'viram ', 90000.00, 'New York');

    
DELIMITER //

CREATE PROCEDURE getemp_city(IN cityName VARCHAR(50))
BEGIN
  DECLARE emp_id INT;
  DECLARE emp_name VARCHAR(50);
  DECLARE emp_salary DECIMAL(10, 2);
  DECLARE emp_city VARCHAR(50);
  DECLARE done BOOLEAN DEFAULT FALSE;


  DECLARE emp_cursor CURSOR FOR
    SELECT empno, empname, salary, city
    FROM EMP
    WHERE city = cityName;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET done = TRUE;

  OPEN emp_cursor;

  emp_loop: LOOP
    FETCH emp_cursor INTO emp_id, emp_name, emp_salary, emp_city;

    IF done THEN
      LEAVE emp_loop;
    END IF;

    SELECT CONCAT('Employee ID: ', emp_id) AS emp_id,
           CONCAT('Employee Name: ', emp_name) AS emp_name,
           CONCAT('Salary: $', emp_salary) AS emp_salary,
           CONCAT('City: ', emp_city) AS emp_city;

  END LOOP emp_loop;

  CLOSE emp_cursor;
END //

DELIMITER ;
call getemp_city('Chicago');
----------------------------
Q6
---------------------------
CREATE TABLE EMP (
  empno INT PRIMARY KEY,
  empname VARCHAR(50),
  salary DECIMAL(10, 2),
  deptno INT
);
drop table emp;

INSERT INTO EMP (empno, empname, salary, deptno) VALUES
(1, 'hardik', 75000.00, 10),
(2, 'Smit', 80000.00, 20),
(3, 'rohit ', 70000.00, 10),
(4, 'rahil', 90000.00, 30);

SELECT * FROM EMP;
DELIMITER //

CREATE PROCEDURE CalculateDepartmentSalarySum()
BEGIN
  DECLARE dept_id INT;
  DECLARE dept_salary_sum DECIMAL(15, 2);
  DECLARE done BOOLEAN DEFAULT FALSE;

  DECLARE dept_cursor CURSOR FOR
    SELECT deptno, SUM(salary) AS total_salary
    FROM EMP
    GROUP BY deptno;

  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET done = TRUE;

  OPEN dept_cursor;
  dept_loop: LOOP
  
    FETCH dept_cursor INTO dept_id, dept_salary_sum;

    IF done THEN
      LEAVE dept_loop;
    END IF;

    SELECT CONCAT('Department ID: ', dept_id) AS dept_id,
           CONCAT('Total Salary: $', dept_salary_sum) AS total_salary;

  END LOOP dept_loop;

  CLOSE dept_cursor;
END //

DELIMITER ;
CALL CalculateDepartmentSalarySum();
