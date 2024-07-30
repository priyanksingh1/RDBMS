create database gen;
use gen;

-- GENERAL PL/SQL BLOCKS:

-- Q1. WAP to input two numbers and find out what is the output of all arithmetic operations.
-- (Addition, Subtraction, Multiplication, Division etc.)
DELIMITER //
CREATE PROCEDURE arithmetic_op( IN num1 DECIMAL(10,2), IN num2 DECIMAL(10,2))
BEGIN
    SELECT num1 + num2 AS AdditionResult;
    SELECT num1 - num2 AS SubtractionResult;
    SELECT num1 * num2 AS MultiplicationResult;
    IF num2 <> 0 THEN
        SELECT num1 / num2 AS DivisionResult;
    ELSE
        SELECT 'Cannot divide by zero' AS DivisionResult;
    END IF;
    SELECT num1 % num2 AS ModulusResult;
END //
DELIMITER ;
CALL arithmetic_op(10, 5);

DELIMITER //
CREATE PROCEDURE CalculateResult(
    IN student_rollno INT,
    IN subject1_marks INT,
    IN subject2_marks INT,
    IN subject3_marks INT
)
BEGIN
    DECLARE total_marks INT;
    DECLARE percentage DECIMAL(5,2);
    DECLARE result VARCHAR(10);
    DECLARE grade CHAR(1);
    SET total_marks = subject1_marks + subject2_marks + subject3_marks;
    SET percentage = (total_marks / 300) * 100;
    IF percentage >= 40 THEN
        SET result = 'Pass';
    ELSE
        SET result = 'Fail';
    END IF;
    IF percentage >= 90 THEN
        SET grade = 'A';
    ELSEIF percentage >= 80 THEN
        SET grade = 'B';
    ELSEIF percentage >= 70 THEN
        SET grade = 'C';
    ELSEIF percentage >= 60 THEN
        SET grade = 'D';
    ELSE
        SET grade = 'F';
    END IF;
    SELECT 
        student_rollno AS RollNumber,
        total_marks AS TotalMarks,
        percentage AS Percentage,
        result AS Result,
        grade AS Grade;
END //
DELIMITER ;
CALL CalculateResult(101, 85, 75, 90);


DELIMITER //
CREATE PROCEDURE odd10()
BEGIN
    DECLARE counter INT DEFAULT 1;
    DECLARE odd_number INT;
    CREATE TEMPORARY TABLE IF NOT EXISTS OddNumbersTable (
        OddNumber INT
    );
    FOR counter IN 1..10 DO
        SET odd_number = 2 * counter - 1;
        INSERT INTO OddNumbersTable (OddNumber) VALUES (odd_number);
    END FOR;
    SELECT * FROM OddNumbersTable;
    DROP TEMPORARY TABLE IF EXISTS OddNumbersTable;
END //
DELIMITER ;
call odd10();

DELIMITER //
CREATE PROCEDURE prime()
BEGIN
    DECLARE num INT DEFAULT 2;
    DECLARE is_prime BOOLEAN;
    CREATE TEMPORARY TABLE IF NOT EXISTS PrimeNumbersTable (
        PrimeNumber INT
    );
    WHILE num <= 10 DO
        SET is_prime = TRUE;
        DECLARE divisor INT DEFAULT 2;
        WHILE divisor <= SQRT(num) DO
            IF num % divisor = 0 THEN
                SET is_prime = FALSE;
                LEAVE;
            END IF;
            SET divisor = divisor + 1;
        END WHILE;
        IF is_prime THEN
            INSERT INTO PrimeNumbersTable (PrimeNumber) VALUES (num);
        END IF;
        SET num = num + 1;
    END WHILE;
    SELECT * FROM PrimeNumbersTable;
    DROP TEMPORARY TABLE IF EXISTS PrimeNumbersTable;
END //
DELIMITER ;
call prime();


DELIMITER //

CREATE PROCEDURE PrintPrimeNumbersUpTo10()
BEGIN
    DECLARE num INT DEFAULT 2;
    DECLARE is_prime BOOLEAN;

    -- Using a WHILE loop to iterate through numbers up to 10
    WHILE num <= 10 DO
        -- Assume the number is prime initially
        SET is_prime = TRUE;
        DECLARE divisor INT DEFAULT 2;
        WHILE divisor <= SQRT(num) DO
            IF num % divisor = 0 THEN
                SET is_prime = FALSE;
                LEAVE;
            END IF;

            SET divisor = divisor + 1;
        END WHILE;

        -- If the number is prime, print it
        IF is_prime THEN
            SELECT num AS PrimeNumber;
        END IF;

        -- Move to the next number
        SET num = num + 1;
    END WHILE;
END //
DELIMITER ;
call PrintPrimeNumbersUpTo10();

DELIMITER //
CREATE PROCEDURE FindMaxMin( IN num1 INT, IN num2 INT, IN num3 INT)
BEGIN
    DECLARE max_num INT;
    DECLARE min_num INT;
    SET max_num = GREATEST(num1, num2, num3);
    SET min_num = LEAST(num1, num2, num3);
    SELECT 
        num1 AS Number1,
        num2 AS Number2,
        num3 AS Number3,
        max_num AS MaximumNumber,
        min_num AS MinimumNumber;
END //
DELIMITER ;
CALL FindMaxMin(25, 10, 18);

CREATE TABLE emp6 (
    empno INT PRIMARY KEY,
    empname VARCHAR(255),
    salary DECIMAL(10, 2)
);
INSERT INTO emp6 VALUES
    (101, 'abc', 50000.00),
    (102, 'pqr', 60000.00),
    (103, 'xyz', 75000.00),
    (104, 'klm', 55000.00),
    (105, 'aaa', 70000.00);

delimiter //
drop procedure if exists get_emp //
create procedure get_emp(in p_empno int)
begin
    declare emp_name varchar(255);
    declare emp_salary decimal(10, 2);
    select empname, salary into emp_name, emp_salary
    from emp6
    where empno = p_empno;
    if emp_name is not null then
        select 'Employee Name: ', emp_name, ' Salary: ', emp_salary as employeedetails;
    else
        select 'Error: Employee with empno ', p_empno, ' does not exist.' as errormessage;
    end if;
end //
delimiter ;
call get_emp(103);

DELIMITER //
drop procedure if exists InsertCustomer //
CREATE PROCEDURE InsertCustomer(
    IN p_cust_id INT,
    IN p_cust_name VARCHAR(255),
    IN p_address VARCHAR(255),
    IN p_city VARCHAR(255) )
BEGIN
    INSERT INTO Customer (cust_id, cust_name, address, city)
    VALUES (p_cust_id, p_cust_name, p_address, p_city);
    SELECT 'Record inserted successfully.' AS Result;
END //
DELIMITER ;
CREATE TABLE Customer (
    cust_id INT PRIMARY KEY,
    cust_name VARCHAR(255),
    address VARCHAR(255),
    city VARCHAR(255)
);
CALL InsertCustomer(1, 'raj', 'karol baag', 'DELHI');
select * from customer;



