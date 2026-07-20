/**a)Retrieve all records from Employee table**/
SELECT*
FROM employee
/**b)Retrieve all records from Emp table**/
Select *
from emp
/**c)Retrieve all records from dept table**/
select *
from dept
/**d)Retrieve all columns from the emp table where first name = Ali**/
select * from emp where empname='Ali'
/**e)Retrieve empname and Salary from the Employee table where Salary is greater than $30,000**/
select * from employee where salary>30000
/**f Find the deptname of deptid 1**/
Select deptname from dept where deptid=1
/*g)*Select all empid’s from Employee table where mgrid = 5**/
select empid from employee where mgrid =5
/*h-)*Select all empid’s from Phone table where employee does not have a phone number**/
SELECT  * empid from phone where phnumber is NULL
/*e)*Retrieve empname and Salary from the Employee table where Salary is greater than $30,000**/
select * from employee where salary>30000


/**create dept2 **/
Create table dept2
(deptid int, depname varchar(50));