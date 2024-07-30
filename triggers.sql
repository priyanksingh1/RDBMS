use temp;
CREATE TABLE emp (
    emp_no INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(255) NOT NULL,
    emp_income DECIMAL(10, 2) NOT NULL,
    income_tax DECIMAL(10, 2) DEFAULT 0
);
drop table emp;

DELIMITER //
CREATE TRIGGER calculate_income_tax_trigger
BEFORE INSERT ON emp
FOR EACH ROW
BEGIN
    DECLARE tax_rate DECIMAL(5, 2);
    IF NEW.emp_income >= 50000 AND NEW.emp_income < 100000 THEN
        SET tax_rate = 0.10;
    ELSEIF NEW.emp_income >= 100000 AND NEW.emp_income < 200000 THEN
        SET tax_rate = 0.15;
    ELSEIF NEW.emp_income >= 200000 AND NEW.emp_income < 300000 THEN
        SET tax_rate = 0.20;
    ELSE 
		SET tax_rate = 0;
    END IF;
		SET NEW.income_tax = NEW.emp_income * tax_rate;
END;
//
DELIMITER ;
INSERT INTO emp (emp_name, emp_income) VALUES ('John Doe', 80000);

SELECT * FROM emp;
CREATE TABLE employee (
    empno INT PRIMARY KEY,
    empname VARCHAR(255),
    DOJ DATE
);

INSERT INTO employee VALUES
(1, 'hardik', '2020-01-15'),
(2, 'viram', '2018-05-20'),
(3, 'jay', '2019-08-10'),
(4, 'yash', '2017-03-25'),
(5, 'mayur', '2022-02-08');

DELIMITER //

CREATE PROCEDURE experience(IN employee_no INT, OUT experience_years INT)
BEGIN
    SELECT datediff(CURDATE(),DOJ)/365 INTO experience_years
    FROM employee
    WHERE empno = employee_no;
END //

DELIMITER ;
CALL experience(3, @experience_years);

SELECT @experience_years AS YearsOfExperience;