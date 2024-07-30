-- 1. Print the absolute value of –15.35
select abs(-15.35) as abs_val;

-- 2. Calculate 3.25 raised to 2.25
select power(3.25, 2.25) as power;

-- 3. Display the rounded value of 3.1417 up to 3 decimal places.
select round(3.1417, 3) as rounded_val;

-- 4. Display the truncated value of 3.1417 up to 3 decimal places.
select truncate(3.1417, 3) as trunc_val;

-- 5. Find the square root of 17 and –13 if possible.
-- Note: sqrt() function returns NULL for negative values
select sqrt(17) as positive, sqrt(-13) as Negative;

-- 6. Print the value of e to the 5th power
select power(exp(1), 5) as power_val;

-- 7. Print the ceil value and floor value of 15.72
select ceil(15.72) as ceil_val, floor(15.72) as floor_val;

-- 8. Find the value of 13 mod 5
select mod(13, 5) as mod_result;

-- 9. Add 275 months to a specific date of birth and display it.
-- Note: The actual date of birth and the date addition may vary based on your specific case
select date_add('2003-04-20', interval 275 month) as new_date;

-- 10. Find the value sin of 100, and log 100 to the base 10
select sin(100) as sin_result, log10(100) as log_result;

create database temp;
use temp;

-- -> Create a database of books :- (no, title, author, publication, price, edition)
create table books
(
no int auto_increment primary key,
title varchar(25),
author varchar(25),
publication varchar(25),
price float(6,2),
edition int
);

insert into books values("","c++ prog","Bjarne","Addision",699.99,1);
insert into books values("","java prog","kathy Sierra","Oracle Press",1499,2);
insert into books values("","Networking","james Kurose","Pearson",499.99,1);
insert into books values("","Database","C.J. Date","PHI",1200,2);
insert into books values("","Math","Charles Seife","Kingsley Publishers",999,1);


create table temp.stud_marks(
no varchar(5),
fname varchar(25),
lname varchar(25),
m1 int,
m2 int,
m3 int,
dob date );

select no as rollno, lname , fname
from stud_marks
where fname like 's%';

truncate table stud_marks;
insert into stud_marks values ('1','priyank','singh',95, 80, 88,'2003-04-09'),
			('2','krunal','parmar',52,56,94, '2001-05-02'),
			('3','rajiv','kumar',50,60,70,'2000-04-08'),
			('4','Jay','Kumawat',50,62,20,'2002-05-03'),
			('5','Shivam','Mistry',1,2,20,'2001-04-28'),
			('6','rm','ptt',1,39,55,'2001-04-28'),
			('7', 'Maya', 'Rathod', 80, 85, 90, '1999-01-01'),
			('8', 'Nikhil', 'Sharma', 75, 90, 85, '1999-02-02'),
			('9', 'rawat', 'kar',20,15,20, '1998-03-03'),
			('10','ayush','padhiyar',29,88,49,'2000-04-09');
insert into stud_marks values ('14','sachin','pqr',40,50,40,'2002-06-13');

select * from stud_marks where m1 >= 40 and m2 >= 40 and m3 >= 40 and (m1 + m2 + m3) / 3 < 60;
select *
from stud_marks
where (m1 + m2 + m3) between 50 and 60;
-- 13
select *
from stud_marks
where fname not like 's%';

update stud_marks set m1 = 40 where (m2 + m3) >= 100;


select * from stud_marks where m1 in (50, 60, 70) or m2 in (50, 60, 70) or m3 in (50, 60, 70);
select * from stud_marks where month(dob) = 1;
select * from stud_marks where day(dob) % 2 = 0;
select fname, lname, TIMESTAMPDIFF(month, dob, CURRENT_DATE()) as age_in_months from stud_marks;
select * from stud_marks where month(dob) between 1 and 3;
SELECT DATE_ADD(CURRENT_DATE(), INTERVAL 15 day);
select * from stud_marks
where lower(fname) not like '%a%' and
      lower(fname) not like '%e%' and
      lower(fname) not like '%i%' and
      lower(fname) not like '%o%' and
      lower(fname) not like '%u%';

select count(*) from stud_marks where fname like 's%';
select count(*) from stud_marks where fname like '%kar';
select concat(left(fname, 3), right(lname, 3)) as formatted_name from stud_marks;
select * from stud_marks where m1 is null or m2 is null or m3 is null;
select * from stud_marks where fname is not null and lname is not null;
select * from stud_marks where soundex(fname) = soundex('sachin');
select abs(checksum(newid())) % 100 as random_number;
SELECT CONCAT(fname, ' was born on ', DAYNAME(dob), '.') AS output FROM stud_marks;
-- Generate a random number using date and time
SELECT ABS(CHECKSUM(CONVERT(VARBINARY, GETDATE()))) % 100 AS random_number;
