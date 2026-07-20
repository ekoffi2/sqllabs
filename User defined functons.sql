/**
ESTHER KOFFI
SECTION 109
09/26/25



Use the HumanResources.Employee Table in the Adventureworks Database


---1. Create a UDF that accepts EmployeeID (2012: BusinessEntityID) and returns UserLoginID. The UserLoginID is the last part of the LogID column. It’s only the part that comes after the/  **/
DROP FUNCTION IF EXISTS dbo.LogId
GO

CREATE FUNCTION LogId(@BusinessEntityID INT) 
RETURNS VARCHAR(50)
AS
BEGIN
DECLARE @LOGINID VARCHAR(50)

SELECT @LOGINID = SUBSTRING (LoginID,CHARINDEX('\',LoginID)+1,LEN(LoginID) )
FROM HumanResources.Employee

RETURN @LOGINID
END
 
GO








--2. Create a UDF that accepts EmployeeID (2012: BusinessEntityID) and returns their age.
DROP FUNCTION IF EXISTS dbo.AGEEMPID
GO

CREATE FUNCTION AGEEMPID ( @BusinessEntityID INT)
RETURNS INT
AS
BEGIN
DECLARE @AGE INT 
DECLARE @BIRTHDATE DATE 
SELEct @BIRTHDATE = BirthDate FROM HumanResources.Employee
SELECT @Age = DATEDIFF(yy,@BIRTHDATE,GETDATE())

RETURN @Age
END
GO



--

--3. Create a UDF that accepts the Gender and returns the avg VacationHours
DROP FUNCTION IF EXISTS dbo.AVG_VACATION_HOURS
GO

CREATE FUNCTION AVG_VACATION_HOURS( @GENDER CHAR(1) )  
RETURNS INT
AS
BEGIN
DECLARE @avg_VacationHours INT 
SELECT @avg_VacationHours = AVG (VacationHours)
FROM HumanResources.Employee
RETURN @avg_VacationHours 
END
GO




--4. Create a UDF tfhat accepts ManagerID (2012: JobTitle) and returns all of that Managers (2012: JobTitle) Employe

DROP FUNCTION IF EXISTS dbo.Manager_Info
GO

CREATE FUNCTION Manager_Info(@JobTitle varchar(50))
RETURNS TABLE
AS
RETURN( SELECT  LoginID, Gender,HireDate
FROM HumanResources.Employee
WHERE @JobTitle = JobTitle)

