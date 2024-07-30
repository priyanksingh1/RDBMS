create database t1;
use t1;
-- Q1. Create a cursor for the emp table. Produce the output in following format: 

-- {empname} employee working in department {deptno} earns Rs. {salary}.
-- EMP(empno, empname, salary, deptno);

create table emp (
   empno   int primary key,
   empname varchar(50),
   salary  int,
   deptno  int
);
insert into emp values (1, 'xyz', 50000, 10);
insert into emp values (2, 'abc', 60000, 20);
insert into emp values (3, 'pqr', 55000, 10);
insert into emp values (4, 'aaa', 70000, 30);
insert into emp values (5, 'bbb', 48000, 20);

INSERT INTO EMP VALUES (6, 'ccc', 75000, 10);
INSERT INTO EMP VALUES (7, 'ddd', 62000, 20);
INSERT INTO EMP VALUES (8, 'eee', 58000, 30);
INSERT INTO EMP VALUES (9, 'fff', 69000, 10);
INSERT INTO EMP VALUES (10, 'ggg', 72000, 20);
INSERT INTO EMP VALUES (11, 'hhh', 67000, 30);
INSERT INTO EMP VALUES (12, 'iii', 71000, 10);
INSERT INTO EMP VALUES (13, 'jjj', 68000, 20);
INSERT INTO EMP VALUES (14, 'kkk', 80000, 30);
INSERT INTO EMP VALUES (15, 'lll', 59000, 10);

delimiter //
create procedure emp_info()
begin
   declare done boolean default false;
   declare emp_name varchar(50);
   declare emp_deptno int;
   declare emp_salary int;
      declare emp_cursor cursor for
      select empname, deptno, salary
      from emp;
      declare continue handler for not found set done = true;
      open emp_cursor;
      read_loop: loop
      fetch emp_cursor into emp_name, emp_deptno, emp_salary;
            if done then
         leave read_loop;
      end if;
            select concat(emp_name, ' employee working in department ', emp_deptno, ' earns Rs. ', emp_salary) as employeeinfo;
   end loop;
      close emp_cursor;
end //
delimiter ;
call emp_info();


-- Q2. 2) Create a cursor for updating the salary of emp working in deptno 10 by 20%.
-- If any rows are affected than display the no of rows affected. Use implicit cursor.

delimiter //
create procedure update_sal()
begin
   declare emp_no int;
   declare emp_salary int;
   declare done boolean default false;
      declare emp_cursor cursor for
      select empno, salary
      from emp
      where deptno = 10;
      declare continue handler for not found set done = true;
      open emp_cursor;
      read_loop: loop
      fetch emp_cursor into emp_no, emp_salary;
            if done then
         leave read_loop;
      end if;
            update emp set salary = salary * 1.2 where empno = emp_no;
   end loop;
      close emp_cursor;
      select concat('Number of rows affected: ', row_count()) as result;
end //
delimiter ;
call update_sal();

-- Q3. 
delimiter //
create procedure update_salary()
begin
   declare emp_no int;
   declare emp_salary int;
   declare done boolean default false;  -- Declare done variable
      declare emp_cursor cursor for
      select empno, salary
      from emp
      where deptno = 10;
      declare continue handler for not found set done = true;
      open emp_cursor;
      read_loop: loop
      fetch emp_cursor into emp_no, emp_salary;
            if done then
         leave read_loop;
      end if;
            update emp set salary = salary * 1.2 where empno = emp_no;
   end loop;
      close emp_cursor;
      select 'Salary updated for employees in department 10 by 20%' as result;
end //
delimiter ;
call update_salary();
select * from emp;


DELIMITER //
CREATE PROCEDURE top_emp()
BEGIN
   DECLARE emp_name VARCHAR(50);
   DECLARE emp_deptno INT;
   DECLARE emp_salary INT;
   DECLARE done BOOLEAN DEFAULT FALSE;
      DECLARE emp_cursor CURSOR FOR
      SELECT empname, deptno, salary
      FROM EMP
      ORDER BY salary DESC
      LIMIT 10;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
      OPEN emp_cursor;
      read_loop: LOOP
      FETCH emp_cursor INTO emp_name, emp_deptno, emp_salary;
            IF done THEN
         LEAVE read_loop;
      END IF;
            SELECT CONCAT(emp_name, ' in department ', emp_deptno, ' has salary Rs. ', emp_salary) AS EmployeeInfo;
   END LOOP;
      CLOSE emp_cursor;
END //
DELIMITER ;
CALL top_emp();

CREATE TABLE EMP5 (
   empno   INT PRIMARY KEY,
   empname VARCHAR(50),
   salary  INT,
   deptno  INT,
   city    VARCHAR(50)
);
INSERT INTO EMP5 VALUES (1, 'aaa', 50000, 10, 'ajmer');
INSERT INTO EMP5 VALUES (2, 'bbb', 60000, 20, 'agra');
INSERT INTO EMP5 VALUES (3, 'ccc', 55000, 10, 'ahmedabad');
INSERT INTO EMP5 VALUES (4, 'ddd', 70000, 30, 'amreli');
INSERT INTO EMP5 VALUES (5, 'eee', 48000, 20, 'ahmednagar');

DELIMITER //
CREATE PROCEDURE Emp_City(IN cityName VARCHAR(50))
BEGIN
   DECLARE emp_no INT;
   DECLARE emp_name VARCHAR(50);
   DECLARE emp_salary INT;
   DECLARE emp_deptno INT;
   DECLARE done BOOLEAN DEFAULT FALSE;
      DECLARE emp_cursor CURSOR FOR
      SELECT empno, empname, salary, deptno
      FROM EMP5
      WHERE city = cityName;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
      OPEN emp_cursor;
      read_loop: LOOP
      FETCH emp_cursor INTO emp_no, emp_name, emp_salary, emp_deptno;
            IF done THEN
         LEAVE read_loop;
      END IF;
            SELECT CONCAT('Employee ', emp_name, ' (EmpNo: ', emp_no, ') in department ', emp_deptno, ' has salary Rs. ', emp_salary) AS EmployeeInfo;
   END LOOP;
      CLOSE emp_cursor;
      IF NOT done THEN
      SELECT 'No employees found in the specified city.' AS Result;
   END IF;
END //
DELIMITER ;
CALL Emp_City('agra');


DELIMITER //
CREATE PROCEDURE Sum_Sal()
BEGIN
   DECLARE dept_no INT;
   DECLARE total_salary INT;
      DECLARE dept_cursor CURSOR FOR
      SELECT deptno, SUM(salary) AS total_salary
      FROM EMP
      GROUP BY deptno;
      OPEN dept_cursor;
      read_loop: LOOP
      FETCH dept_cursor INTO dept_no, total_salary;
            IF (dept_no IS NULL) THEN
         LEAVE read_loop;
      END IF;
            SELECT CONCAT('Department ', dept_no, ' total salary is Rs. ', total_salary) AS DepartmentTotal;
   END LOOP;
      CLOSE dept_cursor;
END //
DELIMITER ;
CALL Sum_Sal();


CREATE SEQUENCE boy_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE Boy_Table (
   Rno INT PRIMARY KEY,
   Name VARCHAR(50),
   Std INT,
   B_date DATE
);
CREATE SEQUENCE girl_seq START WITH 1 INCREMENT BY 1;
CREATE TABLE Girl_Table (
   Rno INT PRIMARY KEY,
   Name VARCHAR(50),
   Std INT,
   B_date DATE
);

CREATE TABLE Student (
   Rno INT PRIMARY KEY,
   Name VARCHAR(50),
   Std INT,
   B_date DATE,
   Sex CHAR(1)
);

INSERT INTO Student VALUES (1, 'aaa', 10, '2000-01-25', 'M');
INSERT INTO Student VALUES (2, 'bbb', 10, '2001-02-20', 'F');
INSERT INTO Student VALUES (3, 'ccc', 11, '2002-03-15', 'M');
INSERT INTO Student VALUES (4, 'ddd', 11, '2003-04-10', 'f');

DELIMITER //
CREATE PROCEDURE PopulateBoyGirlTables()
BEGIN
   DECLARE student_id INT;
   DECLARE student_name VARCHAR(50);
   DECLARE student_std INT;
   DECLARE student_b_date DATE;
   DECLARE student_sex CHAR(1);
   DECLARE done BOOLEAN DEFAULT FALSE;
   DECLARE student_cursor CURSOR FOR
      SELECT Rno, Name, Std, B_date, Sex
      FROM Student;
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
   OPEN student_cursor;
   read_loop: LOOP
      FETCH student_cursor INTO student_id, student_name, student_std, student_b_date, student_sex;
            IF done THEN
         LEAVE read_loop;
      END IF;
            IF student_sex = 'M' THEN
         INSERT INTO Boy_Table (Rno, Name, Std, B_date) VALUES (LAST_INSERT_ID(), student_name, student_std, student_b_date);
      ELSE
         INSERT INTO Girl_Table (Rno, Name, Std, B_date) VALUES (LAST_INSERT_ID(), student_name, student_std, student_b_date);
      END IF;
   END LOOP;
   CLOSE student_cursor;
END //
DELIMITER ;
CALL PopulateBoyGirlTables();
SELECT * FROM Boy_Table;
SELECT * FROM Girl_Table;

