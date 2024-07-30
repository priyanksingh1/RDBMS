show databases;
use bank;
create database bank;

-- Deposit Table
CREATE TABLE bank.Deposit (
    ACTNO VARCHAR(5),
    CNAME VARCHAR(18),
    BNAME VARCHAR(18),
    AMOUNT NUMERIC(8,2),
    ADATE DATE
);

-- Borrow Table
CREATE TABLE bank.Borrow (
    LOANNO VARCHAR(5),
    CNAME VARCHAR(18),
    BNAME VARCHAR(18),
    AMOUNT NUMERIC(8,2)
);

-- Customer Table
CREATE TABLE bank.Customer (
    CNAME VARCHAR(18),
    CITY VARCHAR(18)
);

-- Branch Table
CREATE TABLE bank.Branch (
    BNAME VARCHAR(18),
    CITY VARCHAR(18)
);

-- Insert data into Deposit table
INSERT INTO bank.deposit (ACTNO, CNAME, BNAME, AMOUNT, ADATE) VALUES
('100', 'ANIL', 'VRCE', 1000, '1995-03-01'),
('101', 'SUNIL', 'AJNI', 5000, '1998-01-04'),
('102', 'MEHUL', 'KAROLBAGH', 3500, '1995-11-17'),
('104', 'MADHURI', 'CHANDNI', 1200, '1995-12-17'),
('105', 'PRAMOD', 'MGROAD', 3000, '1996-03-27'),
('106', 'SANDIP', 'ANDHERI', 2000, '1996-03-31'),
('107', 'SHIVANI', 'VIRAR', 1000, '1995-09-05'),
('108', 'KRANTI', 'NEHRUPLACE', 5000, '1995-07-02'),
('109', 'NAREN', 'POWAI', 7000, '1995-10-10');

-- Insert data into Customer table
INSERT INTO bank.customer (CNAME, CITY) VALUES
('ANIL', 'CALCUTTA'),
('SUNIL', 'DELHI'),
('MEHUL', 'BARODA'),
('MANDAR', 'PATNA'),
('MADHURI', 'NAGPUR'),
('PRAMOD', 'NAGPUR'),
('SANDIP', 'SURAT'),
('SHIVANI', 'BOMBAY'),
('KRANTI', 'BOMBAY'),
('NAREN', 'BOMBAY');

-- Insert data into Branch table
INSERT INTO bank.branch (BNAME, CITY) VALUES
('VRCE', 'NAGPUR'),
('AJNI', 'NAGPUR'),
('KAROLBAGH', 'DELHI'),
('CHANDNI', 'DELHI'),
('DHARAMPTEH', 'NAGPUR'),
('MGROAD', 'BANGALORE'),
('ANDHERI', 'BOMBAY'),
('VIRAR', 'BOMBAY'),
('NEHRUPLACE', 'DELHI'),
('POWAI', 'BOMBAY');

-- Insert data into Borrow table
INSERT INTO bank.borrow (LOANNO, CNAME, BNAME, AMOUNT) VALUES
('201', 'ANIL', 'VRCE', 1000),
('206', 'MEHUL', 'AJNI', 5000),
('311', 'SUNIL', 'DHARAMPETH', 3000),
('321', 'MADHURI', 'ANDHERI', 2000),
('375', 'PRAMOD', 'VIRAR', 8000),
('481', 'KRANTI', 'NEHRUPLACE', 3000);

-- Operations on the tables:
-- describing tables
desc bank.borrow;
desc bank.branch;
desc bank.customer;
desc bank.deposit;

-- display table's data
select * from bank.borrow;
select * from bank.branch;
select * from bank.customer;
select * from bank.deposit;

-- deleting the table
drop table bank.borrow;
drop table bank.branch;
drop table bank.customer;
drop table bank.deposit;

-- deleting the data inside a table
truncate table bank.borrow;
truncate table bank.branch;
truncate table bank.customer;
truncate table bank.deposit;


-- Part – I
-- 1. Give all the details of customer Anil.
SELECT * FROM Customer C
LEFT JOIN Borrow B ON C.CNAME = B.CNAME
LEFT JOIN Deposit D ON C.CNAME = D.CNAME
WHERE C.CNAME = 'ANIL';
-- 2. Give the name of customer having living city = Bombay and branch city = nagpur
SELECT C.CNAME
FROM Customer C
JOIN Branch B ON C.CITY = B.CITY
WHERE C.CITY = 'BOMBAY' AND B.CITY = 'NAGPUR';

-- 3. Give name of customer having same living city as their branch city.
SELECT C.CNAME
FROM Customer C
JOIN Branch B ON C.CITY = B.CITY;

-- 4. Give the name of customer who are borrowers and depositers and having living city = Nagpur.
SELECT DISTINCT C.CNAME
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Borrow B ON C.CNAME = B.CNAME
WHERE C.CITY = 'NAGPUR';

-- 5. Give the name of customers who are depositors having same branch city of Sunil
SELECT DISTINCT C.CNAME
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch B1 ON C.CITY = B1.CITY
JOIN Customer C1 ON D.CNAME = C1.CNAME
JOIN Branch B2 ON C1.CITY = B2.CITY
WHERE C1.CNAME = 'SUNIL' AND B1.CITY = B2.CITY;

-- 6. Give name of depositors having same living city as Anil and having deposit amount greater than 2000.
SELECT D.CNAME
FROM Deposit D
JOIN Customer C ON D.CNAME = C.CNAME
WHERE C.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'ANIL') AND D.AMOUNT > 2000;

-- 7. Give name of depositors having same branch as branch of Sunil.
SELECT D.CNAME
FROM Deposit D
JOIN Customer C1 ON D.CNAME = C1.CNAME
JOIN Branch B1 ON C1.CITY = B1.CITY
JOIN Customer C2 ON C2.CNAME = 'SUNIL'
JOIN Branch B2 ON C2.CITY = B2.CITY
WHERE B1.BNAME = B2.BNAME;

-- 8. give name of borrowers having loan amount greater than amount of Parmod.
SELECT B.CNAME
FROM Borrow B
WHERE B.AMOUNT > (SELECT AMOUNT FROM Deposit WHERE CNAME = 'PRAMOD');

-- 9. Give name of Customers living in same city where branch of depositor sunil is located.
SELECT C.CNAME
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch B1 ON C.CITY = B1.CITY
JOIN Customer C1 ON C1.CNAME = 'SUNIL'
JOIN Branch B2 ON C1.CITY = B2.CITY
WHERE B1.BNAME = B2.BNAME;

-- 10. Give name of borrowers having deposit amount greater than 1000 and loan amount greater than 2000.
SELECT B.CNAME
FROM Borrow B
JOIN Deposit D ON B.CNAME = D.CNAME
WHERE D.AMOUNT > 1000 AND B.AMOUNT > 2000;

-- 11. Give loan no., loan amount, account no. deposit amount of customers living in city Nagpur.
SELECT B.LOANNO, B.AMOUNT AS LOAN_AMOUNT, D.ACTNO, D.AMOUNT AS DEPOSIT_AMOUNT
FROM Borrow B
JOIN Customer C ON B.CNAME = C.CNAME
JOIN Deposit D ON C.CNAME = D.CNAME
WHERE C.CITY = 'NAGPUR';

-- 12. Give loan no., loan amount, account no., deposit amount of customers having branch located at Bombay.
SELECT B.LOANNO, B.AMOUNT AS LOAN_AMOUNT, D.ACTNO, D.AMOUNT AS DEPOSIT_AMOUNT
FROM Borrow B
JOIN Customer C ON B.CNAME = C.CNAME
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch Br ON C.CITY = Br.CITY
WHERE Br.CITY = 'BOMBAY';

-- 13. Give loan no, loan amount, account no., deposit amount, branch name, branch city and living city of Pramod.
SELECT B.LOANNO, B.AMOUNT AS LOAN_AMOUNT, D.ACTNO, D.AMOUNT AS DEPOSIT_AMOUNT, Br.BNAME AS BRANCH_NAME, Br.CITY AS BRANCH_CITY, C.CITY AS LIVING_CITY
FROM Borrow B
JOIN Customer C ON B.CNAME = C.CNAME
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch Br ON C.CITY = Br.CITY
WHERE C.CNAME = 'PRAMOD';

-- 14. Give deposit details and Loan details of Customer in same city where Pramod is living.
SELECT D.*, B.*
FROM Deposit D
JOIN Customer C ON D.CNAME = C.CNAME
JOIN Borrow B ON C.CNAME = B.CNAME
WHERE C.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'PRAMOD');

-- 15. Give Name of Depositors having same Branch city as Sunil and having same Living city as Anil.
SELECT D.CNAME
FROM Deposit D
JOIN Customer C1 ON D.CNAME = C1.CNAME
JOIN Branch B1 ON C1.CITY = B1.CITY
JOIN Customer C2 ON C2.CNAME = 'SUNIL'
JOIN Branch B2 ON C2.CITY = B2.CITY
WHERE B1.BNAME = B2.BNAME AND C1.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'ANIL');

-- 16. Give name of depositors having amount greater than 5000 and having same living city as Pramod.
SELECT D.CNAME
FROM Deposit D
JOIN Customer C ON D.CNAME = C.CNAME
WHERE D.AMOUNT > 5000 AND C.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'PRAMOD');

-- 17. Give city of customer having branch city same as Pramod.
SELECT C.CITY
FROM Customer C
JOIN Branch B ON C.CITY = B.CITY
JOIN Customer Pramod ON Pramod.CNAME = 'PRAMOD'
WHERE B.CITY = Pramod.CITY;

-- 18. Give branch city and living city of Pramod
SELECT B.CITY AS BRANCH_CITY, C.CITY AS LIVING_CITY
FROM Branch B
JOIN Customer C ON B.CITY = C.CITY
WHERE C.CNAME = 'PRAMOD';

-- 19. Give branch city of sunil and branch city of Anil.
SELECT B1.CITY AS SUNIL_BRANCH_CITY, B2.CITY AS ANIL_BRANCH_CITY
FROM Customer C1
JOIN Branch B1 ON C1.CITY = B1.CITY
JOIN Customer C2 ON C2.CNAME = 'ANIL'
JOIN Branch B2 ON C2.CITY = B2.CITY
WHERE C1.CNAME = 'SUNIL';

-- 20. Give living city of Ashok and Living city of Ajay.
SELECT C1.CITY AS ASHOK_LIVING_CITY, C2.CITY AS AJAY_LIVING_CITY
FROM Customer C1
JOIN Customer C2 ON C1.CNAME = 'ASHOK' AND C2.CNAME = 'AJAY';


-- Part II
-- 1. List all the customers who are depositors but are not borrowers.
SELECT C.*
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
LEFT JOIN Borrow B ON C.CNAME = B.CNAME
WHERE B.CNAME IS NULL;

-- 2. List all the customers who are depositors and borrowers.
SELECT DISTINCT C.*
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Borrow B ON C.CNAME = B.CNAME;

-- 3. List all the customers with their amount who are borrowers or depositors and living in city Nagpur.
SELECT C.CNAME, D.AMOUNT AS DEPOSIT_AMOUNT, B.AMOUNT AS LOAN_AMOUNT
FROM Customer C
LEFT JOIN Deposit D ON C.CNAME = D.CNAME
LEFT JOIN Borrow B ON C.CNAME = B.CNAME
WHERE C.CITY = 'NAGPUR';

-- 4. List all the depositors having deposit in all the branches were Sunil is having branches.
SELECT C.CNAME, D.AMOUNT, B.BNAME
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch B ON C.CITY = B.CITY
WHERE C.CITY IN (SELECT CITY FROM Branch WHERE BNAME IN (SELECT BNAME FROM Branch WHERE CITY = (SELECT CITY FROM Customer WHERE CNAME = 'SUNIL')));

-- 5. List all the customers living in city Nagpur and having branch city Bombay or delhi.
SELECT C.*
FROM Customer C
JOIN Branch B ON C.CITY = B.CITY
WHERE (C.CITY = 'NAGPUR') AND (B.CITY = 'BOMBAY' OR B.CITY = 'DELHI');

-- 6. List all the depositors living in city Nagpur.
SELECT C.*
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
WHERE C.CITY = 'NAGPUR';

-- 7. List all the depositors living in city nagpur and having branch city Bombay.
SELECT C.*
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch B ON C.CITY = B.CITY
WHERE C.CITY = 'NAGPUR' AND B.CITY = 'BOMBAY';

-- 8. List the branch cities of anil and sunil.
SELECT C1.CNAME AS ANIL, C2.CNAME AS SUNIL, B1.CITY AS ANIL_BRANCH_CITY, B2.CITY AS SUNIL_BRANCH_CITY
FROM Customer C1
JOIN Branch B1 ON C1.CITY = B1.CITY
JOIN Customer C2 ON C2.CNAME = 'SUNIL'
JOIN Branch B2 ON C2.CITY = B2.CITY
WHERE C1.CNAME = 'ANIL';

-- 9. list the customers having deposit greater than 1000 and loan less than 10000.
SELECT C.*, D.AMOUNT AS DEPOSIT_AMOUNT, B.AMOUNT AS LOAN_AMOUNT
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
LEFT JOIN Borrow B ON C.CNAME = B.CNAME
WHERE D.AMOUNT > 1000 AND (B.AMOUNT < 10000 OR B.AMOUNT IS NULL);

-- 10. List the borrowers having branch city same as sunil.
SELECT B.*
FROM Borrow B
JOIN Customer C ON B.CNAME = C.CNAME
JOIN Branch SunilBranch ON C.CITY = SunilBranch.CITY
JOIN Customer Sunil ON Sunil.CNAME = 'SUNIL'
JOIN Branch SunilBranch2 ON Sunil.CITY = SunilBranch2.CITY
WHERE SunilBranch.BNAME = SunilBranch2.BNAME;

-- 11. List the cities of depositors having branch VRCE.
SELECT DISTINCT C.CITY
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
WHERE D.BNAME = 'VRCE';

-- 12. List the depositors having same living city as sunil, and same branch city as anil.
SELECT DISTINCT D.CNAME
FROM Deposit D
JOIN Customer C1 ON D.CNAME = C1.CNAME
JOIN Customer C2 ON C1.CITY = C2.CITY
JOIN Branch B1 ON C1.CITY = B1.CITY
JOIN Customer A ON A.CNAME = 'ANIL' AND B1.CITY = A.CITY
WHERE C2.CNAME = 'SUNIL';

-- 13. List the depositors having amount less than 1000 and living in same city as anil.
SELECT C.CNAME, D.AMOUNT
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
WHERE D.AMOUNT < 1000 AND C.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'ANIL');

-- 14. List all the customers who are depositors and borrowers and living in same city as anil.
SELECT C.CNAME
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Borrow B ON C.CNAME = B.CNAME
WHERE C.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'ANIL');

-- 15. List all the cities where branches of Anil and Sunil are located.
SELECT DISTINCT B.CITY
FROM Customer C
JOIN Branch B ON C.CITY = B.CITY
WHERE C.CNAME IN ('ANIL', 'SUNIL');

-- 16. List all the customer name, amount of depositor living in city where anil or sunil is living.
SELECT C.CNAME, D.AMOUNT
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
WHERE C.CITY IN (SELECT CITY FROM Customer WHERE CNAME IN ('ANIL', 'SUNIL'));

-- 17. List amount of depositors living in city where anil is living.
SELECT D.AMOUNT
FROM Deposit D
JOIN Customer C ON D.CNAME = C.CNAME
WHERE C.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'ANIL');

-- 18. List the cities which are branch city of anil or living city of sunil.
SELECT DISTINCT CITY
FROM Customer
WHERE CITY IN (
    SELECT CITY 
    FROM Branch 
    WHERE BNAME IN ( SELECT BNAME FROM Branch 
		WHERE CITY = ( SELECT CITY FROM Customer 
            WHERE CNAME = 'ANIL'))
) OR CITY = (SELECT CITY FROM Customer WHERE CNAME = 'SUNIL');

-- 19. List the customer who are borrowers or depositors and having living city nagpur and branch city same as sunil.
SELECT DISTINCT C.CNAME
FROM Customer C
LEFT JOIN Borrow B ON C.CNAME = B.CNAME
LEFT JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch B1 ON C.CITY = B1.CITY
JOIN Branch B2 ON B1.BNAME = B2.BNAME
WHERE (B.CITY = 'NAGPUR' OR D.CITY = 'NAGPUR') AND B2.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'SUNIL');

-- 20. List the customer who are borrowers and depositors and having same branch citgy as anil.
SELECT DISTINCT C.CNAME
FROM Customer C
JOIN Borrow B ON C.CNAME = B.CNAME
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch B1 ON C.CITY = B1.CITY
JOIN Branch B2 ON B1.BNAME = B2.BNAME
WHERE B2.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'ANIL');

-- Part – III
-- 1. List total deposit of customers living in city Nagpur.
SELECT C.CITY, SUM(D.AMOUNT) AS TOTAL_DEPOSIT
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
WHERE C.CITY = 'NAGPUR'
GROUP BY C.CITY;

-- 2. List total deposit of customers having branch city delhi.
SELECT B.CITY, SUM(D.AMOUNT) AS TOTAL_DEPOSIT
FROM Branch B
JOIN Deposit D ON B.BNAME = D.BNAME
WHERE B.CITY = 'DELHI'
GROUP BY B.CITY;

-- 3. List total deposit of customers living in same city where sunil is living.
SELECT C.CITY, SUM(D.AMOUNT) AS TOTAL_DEPOSIT
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
WHERE C.CITY = (SELECT CITY FROM Customer WHERE CNAME = 'SUNIL')
GROUP BY C.CITY;

-- 4. Give city name and citywise deposit. (group by city)
SELECT C.CITY, SUM(D.AMOUNT) AS TOTAL_DEPOSIT
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
GROUP BY C.CITY;

-- 5. Give citywise name and branchwise deposit.
SELECT C.CITY, C.CNAME, B.BNAME, SUM(D.AMOUNT) AS TOTAL_DEPOSIT
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch B ON C.CITY = B.CITY
GROUP BY C.CITY, C.CNAME, B.BNAME;

-- 6. Give the branchwise deposit of customer after account date 1-jan-96.
SELECT B.BNAME, SUM(D.AMOUNT) AS TOTAL_DEPOSIT
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Branch B ON C.CITY = B.CITY
WHERE D.ADATE > '1996-01-01'
GROUP BY B.BNAME;

-- 7. Give branchwise loan of customer living in Nagpur.
SELECT B.BNAME, SUM(Bo.AMOUNT) AS TOTAL_LOAN
FROM Customer C
JOIN Borrow Bo ON C.CNAME = Bo.CNAME
JOIN Branch B ON C.CITY = B.CITY
WHERE C.CITY = 'NAGPUR'
GROUP BY B.BNAME;

-- 8. Give living citywise loan of borrowers.
SELECT C.CITY, SUM(Bo.AMOUNT) AS TOTAL_LOAN
FROM Customer C
JOIN Borrow Bo ON C.CNAME = Bo.CNAME
GROUP BY C.CITY;

-- 9. Give Number of customers who are depositors and borrowers.
SELECT COUNT(DISTINCT C.CNAME) AS NUM_CUSTOMERS
FROM Customer C
JOIN Deposit D ON C.CNAME = D.CNAME
JOIN Borrow Bo ON C.CNAME = Bo.CNAME;

-- 10. Count total number of branch cities.
SELECT COUNT(DISTINCT CITY) AS NUM_BRANCH_CITIES
FROM Branch;


-- Part – IV (Create a copy of all the tables and then perform delete...)
-- 1. Delete depositors of branches having number of customers between 1 and 3.
DELETE FROM Deposit
WHERE CNAME IN (
    SELECT C.CNAME
    FROM Customer C
    JOIN Branch B ON C.CITY = B.CITY
    GROUP BY B.BNAME
    HAVING COUNT(C.CNAME) BETWEEN 1 AND 3
);

-- 2. Delete branches having average deposit less than 5000.
DELETE FROM Branch
WHERE BNAME IN (
    SELECT B.BNAME
    FROM Branch B
    JOIN Deposit D ON B.BNAME = D.BNAME
    GROUP BY B.BNAME
    HAVING AVG(D.AMOUNT) < 5000
);

-- 3. delete branches having maximum loan more than 5000.
DELETE FROM Branch
WHERE BNAME IN (
    SELECT B.BNAME
    FROM Branch B
    JOIN Borrow Bo ON B.BNAME = Bo.BNAME
    GROUP BY B.BNAME
    HAVING MAX(Bo.AMOUNT) > 5000
);

-- 4. delete branches having deposit from nagpur.
DELETE FROM Branch
WHERE CITY = 'NAGPUR' AND BNAME IN (
    SELECT DISTINCT B.BNAME
    FROM Branch B
    JOIN Deposit D ON B.BNAME = D.BNAME
    WHERE B.CITY = 'NAGPUR'
);

-- 5. delete deposit of anil and sunil if both are having branch virar.
DELETE FROM Deposit
WHERE CNAME IN ('ANIL', 'SUNIL') AND BNAME = 'VIRAR' AND BNAME IN (
    SELECT B.BNAME
    FROM Branch B
    JOIN Deposit D ON B.BNAME = D.BNAME
    WHERE CNAME IN ('ANIL', 'SUNIL') AND B.BNAME = 'VIRAR'
);

-- 6. delete deposit of anil and sunil if both are having living city nagpur.
DELETE FROM Deposit
WHERE CNAME IN ('ANIL', 'SUNIL') AND CNAME IN (
    SELECT C.CNAME
    FROM Customer C
    WHERE C.CITY = 'NAGPUR'
);

-- 7. delete deposit of anil and sunil if both are having same living city.
DELETE FROM Deposit
WHERE CNAME IN ('ANIL', 'SUNIL') AND CNAME IN (
    SELECT C.CNAME
    FROM Customer C
    GROUP BY C.CITY
    HAVING COUNT(C.CITY) > 1
);

-- 8. delete deposit of anil and sunil if they are having less deposit than vijay.
DELETE FROM Deposit
WHERE CNAME IN ('ANIL', 'SUNIL') AND AMOUNT < (
    SELECT MIN(D.AMOUNT)
    FROM Deposit D
    WHERE D.CNAME = 'VIJAY'
);

-- 9. delete deposit of ajay if vijay is not depositor.
DELETE FROM Deposit
WHERE CNAME = 'AJAY' AND CNAME NOT IN (
    SELECT C.CNAME
    FROM Deposit D
    WHERE D.CNAME = 'VIJAY'
);

-- 10. delete depositors if branch is virar and name is ajay.
DELETE FROM Deposit
WHERE CNAME = 'AJAY' AND BNAME IN (
    SELECT B.BNAME
    FROM Branch B
    WHERE B.CITY = 'VIRAR'
);

-- 11. delete depositors of VRCE branch and living in city Bombay.
DELETE FROM Deposit
WHERE BNAME = 'VRCE' AND CNAME IN (
    SELECT C.CNAME
    FROM Customer C
    WHERE C.CITY = 'BOMBAY'
);

-- 12. delete borrower of branches having average loan less than 1000.
DELETE FROM Borrow
WHERE BNAME IN (
    SELECT B.BNAME
    FROM Branch B
    JOIN Borrow Bo ON B.BNAME = Bo.BNAME
    GROUP BY B.BNAME
    HAVING AVG(Bo.AMOUNT) < 1000
);

-- 13. delete borrower of branches having minimum number of customers.
DELETE FROM Borrow
WHERE BNAME IN (
    SELECT B.BNAME
    FROM Branch B
    JOIN Customer C ON B.CITY = C.CITY
    GROUP BY B.BNAME
    HAVING COUNT(C.CNAME) = (
        SELECT MIN(CustomerCount)
        FROM (
            SELECT COUNT(C.CNAME) AS CustomerCount
            FROM Branch B
            JOIN Customer C ON B.CITY = C.CITY
            GROUP BY B.BNAME
        ) AS Subquery
    )
);

