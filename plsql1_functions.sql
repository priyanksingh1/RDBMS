create database class;
use class;

-- Q1.  WAF which accepts the name from user and returns the length of that name.

delimiter //
create function get_length(input_name varchar(255)) returns int
begin
    declare name1 int;    
    set name1 = length(input_name);
    return name1;
end //
delimiter ;
select get_length('Priyank')as 'length is ';

-- Q2.  WAF which accepts one number and return TRUE if no is prime and return FALSE if no is not prime.

delimiter //
create function IsPrime(num int) returns boolean
begin
    declare i int default 2;
    if num < 2 then
        return false;
    end if;
    while i <= num / 2 do
        if num % i = 0 then
            return false;
        end if;
        set i = i + 1;
    end while;
    return true;
end //
delimiter ;
select IsPrime(17) AS Is_Prime;

-- Q3 Write a function which accept the department no and returns maximum salary of that
-- department. Handle the error if deptno does not exist or select statement return more
-- than one row. EMP(Empno, deptno, salary).
create table EMP (
    Empno int primary key,
    Deptno int,
    Salary decimal(10, 2)
);

insert into EMP (Empno, Deptno, Salary) values
(1, 10, 5000),
(2, 10, 6000),
(3, 20, 7000),
(4, 20, 8000),
(5, 30, 9000);

delimiter //
create function maxSal(deptNoParam int) returns decimal(10, 2)
begin
    declare maxSalary decimal(10, 2);
    select max(Salary) into maxSalary
    from EMP
    where Deptno = deptNoParam;
    if maxSalary is null then
        signal sqlstate '45000'
        set message_text = 'Department does not exist';
    end if;
    return maxSalary;
end //
delimiter ;
SELECT maxSal(20) AS MaxSalary; 

-- Q4.  Write a function to display whether the inputed employee no is exists or not.


delimiter //
create function empexists(empNo int) returns boolean
begin
    declare employeeExists boolean;
    select COUNT(*) into employeeExists
    from EMP
    where Empno = empNo;
    return employeeExists;
end //
delimiter ;
SELECT EmpExists(15) AS 'EmployeeExists';

-- Q5. WAF which accepts one no and returns that no+100. Use INOUT mode.
delimiter //
create function IncrementNo(inputNumber int) returns int
begin
    declare result int;
    set result = inputNumber + 100;
    return result;
end //
delimiter ;
SELECT IncrementNo(400) AS Result; 

-- Q6. WAF which accepts the empno. If salary<10000 than give raise by 30%.
-- If salary<20000 and salary>=10000 than give raise by 20%. If salary>20000 than
-- give raise by 10%. Handle the error if any.

delimiter //
create function CalculateRaise(empNo int) returns decimal(10, 2)
begin
    declare currentSalary decimal(10, 2);
    declare raisePercentage decimal(5, 2);
    select Salary into currentSalary
    from EMP
    where Empno = empNo;
    if currentSalary is null then
        signal sqlstate '45000'
        set message_text = 'Employee does not exist';
    end if;
    if currentSalary < 10000 then
        set raisePercentage = 0.30;
    ELSEIF currentSalary >= 10000 AND currentSalary < 20000 THEN
        set raisePercentage = 0.20;
    ELSE
        set raisePercentage = 0.10;
    end IF;
    return currentSalary + (currentSalary * raisePercentage);
end //
delimiter ;
Select CalculateRaise(4);
select * from EMP;

-- Q7. WAF which accepts the empno and returns the experience in years. Handle the error if empno does not exist. EMP(Empno, Empname, DOJ);
delimiter //
create function expe(empNo int) returns int
begin
    declare experience int;
    select DOJ into experience
    from EMP
    where Empno = empNo;
    if experience is null then
        signal sqlstate '45000'
        set message_text = 'Employee does not exist';
    else
        set experience = datediff(curdate(), experience) / 365;
    end IF;
    return experience;
end //
delimiter ;
select expe(4);

-- Procedure
CREATE TABLE EMP1 (
    Empno INT PRIMARY KEY,
    Empname VARCHAR(255) NOT NULL
);
INSERT INTO EMP1 (Empno, Empname) VALUES
    (1, 'priyank '),
    (2,'sahil'),
    (3, 'mayur'),
    (4, 'prince'),
    (5, 'zeel');
DELIMITER //
drop procedure if exists GetEmpName //
CREATE PROCEDURE GetEmpName(IN emp_number INT)
BEGIN
    DECLARE emp_name VARCHAR(255);
    SELECT Empname INTO emp_name
    FROM EMP1
    WHERE Empno = emp_number;
    IF emp_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee number does not exist';
    ELSE
        SELECT emp_name AS EmpName;
    END IF;
END //
DELIMITER ;
CALL GetEmpName(1);

CREATE TABLE STUDENT (
    Stud_ID INT PRIMARY KEY,
    Stud_name VARCHAR(255),
    m1 INT,
    m2 INT,
    m3 INT
);
INSERT INTO STUDENT VALUES
(1, 'priyank', 85, 90, 78),
(2, 'sahil', 92, 88, 95),
(3, 'mayur', 78, 85, 80),
(4, 'harshil', 90, 92, 88);

DELIMITER //
CREATE PROCEDURE studinfo(IN roll_number INT)
BEGIN
    SELECT Stud_name, m1, m2, m3
    FROM STUDENT
    WHERE Stud_ID = roll_number;
END //
DELIMITER ;
CALL studinfo(4);


DELIMITER //
CREATE PROCEDURE CheckCase(IN input_name VARCHAR(255), OUT case_result VARCHAR(10))
BEGIN
    IF BINARY input_name = UPPER(input_name) THEN
        SET case_result = 'UPPER';
    ELSEIF BINARY input_name = LOWER(input_name) THEN
        SET case_result = 'LOWER';
    ELSE
        SET case_result = 'MIXCASE';
    END IF;
END //
DELIMITER ;
SET @case_result = '';
CALL CheckCase('Priyank', @case_result );
SELECT @case_result ;

CREATE TABLE stud (
    Stud_ID INT PRIMARY KEY,
    Stud_name VARCHAR(255),
    percent DECIMAL(5, 2)
);

INSERT INTO stud VALUES
(1, 'priyank', 85.5),
(2, 'urjit', 92.3),
(3, 'hardil', 78.9),
(4, 'kunal', 90.1);

DELIMITER //
CREATE PROCEDURE Highper(OUT highest_percent DECIMAL(5, 2), OUT student_name VARCHAR(255))
BEGIN
    SELECT MAX(percent) INTO highest_percent
    FROM stud;
    SELECT Stud_name INTO student_name
    FROM stud
    WHERE percent = highest_percent
    LIMIT 1;
END //
DELIMITER ;
CALL Highper(@highest_percent, @student_name);
SELECT @highest_percent AS HighestPercent, @student_name AS StudentName;


CREATE TABLE employee (
    empno INT PRIMARY KEY,
    empname VARCHAR(255),
    DOJ DATE
);

INSERT INTO employee VALUES
(1, 'priyank', '2020-01-15'),
(2, 'vivek', '2018-05-20'),
(3, 'ajay', '2019-08-10'),
(4, 'prince', '2017-03-25'),
(5, 'mayur', '2022-02-08');

DELIMITER //
CREATE PROCEDURE experience(IN employee_no INT, OUT experience_years INT)
BEGIN
    SELECT TIMESTAMPDIFF(YEAR, DOJ, CURDATE()) INTO experience_years
    FROM employee
    WHERE empno = employee_no;
END //
DELIMITER ;
CALL experience(1, @experience_years);
SELECT @experience_years AS YearsOfExperience;


CREATE TABLE STUDENT (
    Stud_ID INT PRIMARY KEY,
    Stud_name VARCHAR(255),
    m1 INT,
    m2 INT,
    m3 INT
);

-- Insert sample records
INSERT INTO STUDENT VALUES
(1, 'hardik patel', 85, 90, 78),
(2, 'viram shah', 70, 65, 80),
(3, 'jay kumar', 55, 60, 5
(4, 'yash kuvadiya', 75, 80, 68);

DELIMITER //
CREATE PROCEDURE CalculateResult(IN roll_number INT, OUT result VARCHAR(20), OUT percentage DECIMAL(5, 2))
BEGIN
    DECLARE total_marks INT;
    DECLARE avg_marks DECIMAL(5, 2);
    SELECT m1 + m2 + m3 INTO total_marks
    FROM STUDENT
    WHERE Stud_ID = roll_number;
    SET avg_marks = total_marks / 3.0;
    SET percentage = avg_marks;
    IF avg_marks >= 75 THEN
        SET result = 'First Class';
    ELSEIF avg_marks >= 60 THEN
        SET result = 'Second Class';
    ELSEIF avg_marks >= 45 THEN
        SET result = 'Third Class';
    ELSE
        SET result = 'Fail';
    END IF;
END //
DELIMITER ;
CALL CalculateResult(1, @result, @percentage);
SELECT @result AS Result, @percentage AS Percentage;