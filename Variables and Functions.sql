---Esther koffi
--SECTION 108
---09/25/2025



/**1. Create the following table
**/

DROP TABLE IF EXISTS FLIGHTS
CREATE TABLE FLIGHTS (FlightID INT PRIMARY KEY IDENTITY (100,1) ,FlightDateTime DATE NULL,
FlightDepartureCity VARCHAR(50) NULL,FlightDestinationCity VARCHAR(50) null,Ontime int null)



---2Run the following script to Insert Data into the table.

INSERT INTO dbo.FLIGHTS(FlightDateTime,FlightDepartureCity,FlightDestinationCity, Ontime)

SELECT '1/1/2012','Dallas-Texas','L.A.',1 UNION

SELECT '1/2/2012','Austin-Texas','New York',1 UNION

SELECT '1/3/2012','Houston-Texas','New Jersy',0 UNION

SELECT '1/4/2012','San Antonio-Texas','Mesquite',1 UNION

SELECT '1/5/2012','Lewisville-Texas','Albany',0 UNION

SELECT '1/6/2012','Orlando-Florida','Atlanta',1 UNION

SELECT '1/7/2012','Chicago-Illinois','Oklahoma City',1 UNION

SELECT '1/8/2012','New Orleans-Louisiana','Memphis',0 UNION

SELECT '1/9/2012','Miami-Florida','Charlotte',1 UNION

SELECT '1/10/2012','Sacramento-California','San Francisco',1


--Create and set a Variable equal to the number of Flights that were late.

DECLARE @NUMBERFLIGHTLATE INT;
SELECT @NUMBERFLIGHTLATE= COUNT(*) from FLIGHTS
WHERE Ontime = 0;
SELECT @NUMBERFLIGHTLATE AS NUMBER_FLIGHT_LATE

--4. Multiply that amount by the amount lost per late flight ($1,029) and store the amount in another variable.

DECLARE @AMOUNTLOST MONEY;
SET @AMOUNTLOST = @NUMBERFLIGHTLATE * 1029;
SELECT @AMOUNTLOST AS AMOUNTLOST




---5. Take the total amount lost (#4) and subtract it from Total profit ($45,000) and store that number in a variable.
DECLARE @BENEFIT MONEY;
SET @BENEFIT = 45000 -@AMOUNTLOST
SELECT @BENEFIT AS BENEFIT


---6. Find out the Earliest FlightDate and add 10 years to it and store it in a variable.

DECLARE @EARLIESTD DATE;
SELECT @EARLIESTD = DATEADD(YY,10,(SELECT TOP 1(FlightDateTime) FROM FLIGHTS))
SELECT @EARLIESTD AS_Earliest_FlightDate

---7. Find out the day of the week for the Latest FlightDate and store it in a variable.

DECLARE @LATESTDAY VARCHAR(50);
SELECT @LATESTDAY = DATENAME(WEEKDAY,(SELECT MAX (FlightDateTime) FROM FLIGHTS))

SELECT @LATESTDAY AS Latest_flight_date

---8. Create a table variable with Departure City and State in 2 different columns along with Flight Destination City and Ontime.

DECLARE @FLIGHTINFO TABLE (DepatureCity VARCHAR(50), DepatureState VARCHAR(50),
FlightDestinationCity VARCHAR(50),  FlightDestinationState VARCHAR(50), ONTIME BIT );
SELECT * FROM @FLIGHTINFO

---9. Create a Table Variable storing all info from the dbo.Flights table of flights that were on time.

DECLARE @2NDTABLE TABLE(FlightID INT,FlightDateTime DATE, FlightDepartureCity VARCHAR(50), FlightDestinationCity  VARCHAR(50), Ontime INT)
INSERT INTO  @2NDTABLE
SELECT *
FROM FLIGHTS
WHERE Ontime=1;
SELECT * FROM @2NDTABLE

---10. Create a Table Variable storing all info from the dbo.Flights table of non Texas Flights.
DECLARE @3TABLE TABLE(FlightID INT,FlightDateTime DATE, FlightDepartureCity VARCHAR(50), FlightDestinationCity  VARCHAR(50), Ontime INT)
INSERT INTO  @3TABLE
SELECT *
FROM FLIGHTS
WHERE FlightDepartureCity NOT LIKE'%TEXAS%';
SELECT * FROM @3TABLE

---Run the following Script
DROP TABLE IF EXISTS HospitalStaff
CREATE TABLE [dbo].[HospitalStaff](

[EmpID] [int] IDENTITY(1000,1) NOT NULL,

[NameJob] [varchar](50) NULL,

[HireDate] [datetime] NULL,

[Location] [varchar](150) NULL,

CONSTRAINT [PK_HospitalStaff] PRIMARY KEY CLUSTERED

(

[EmpID] ASC

)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

) ON [PRIMARY]


INSERT INTO [dbo].[HospitalStaff] ([NameJob],[HireDate],[Location])

SELECT 'Dr. Johnson_Doctor' ,'1/1/2012', 'Dallas-Texas' UNION

SELECT 'Nurse Jackie_Nurse' ,'10/15/2011', 'Mesquite-Texas' UNION

SELECT 'Anne_Nurse Assistant' ,'11/1/2010', 'Denton-Texas' UNION

SELECT 'Dr. Jackson_Doctor' ,'4/2/2008', 'Irving-Texas' UNION

SELECT 'Jamie_Nurse' ,'2/15/2005', 'San Francisco-California' UNION

SELECT 'Aesha_Nurse Assistant' ,'6/30/2003', 'Oakland-California' UNION

SELECT 'Dr. Ali_Doctor' ,'7/4/1999', 'L.A.-California' UNION

SELECT 'Evelyn_Nurse' ,'1/7/2007', 'Fresno-California' UNION

SELECT 'James Worthy_Nurse Assistant' ,'1/1/2012', 'Orlando-Florida' UNION

SELECT 'Anand_Doctor' ,'3/1/2012', 'Miami-Florida'



SELECT *

FROM dbo.HospitalStaff



--11. Create a Variable to store how many employees have been employed with the company for more than 3 years.
DECLARE @NUMBEREMPL INT
SELECT @NUMBEREMPL = COUNT (EmpID)
FROM HospitalStaff
WHERE HireDate <=DATEADD(YY,-3,GETDATE())
SELECT @NUMBEREMPL



---12. Create and populate a Variable to store the number of all employees from Texas
DECLARE @TEXASEMP INT
SELECT @TEXASEMP= COUNT(EmpID)
from HospitalStaff
where Location  like'%Texas%'
SELECT @TEXASEMP AS NUMERTEXASEMP

---13. Create and populate a Variable to store the number of Doctor’s from Texas

DECLARE @TEXASDOCT INT
SELECT @TEXASDOCT= COUNT(EmpID)
from HospitalStaff
where NameJob like'%Doctor%'
and Location like '%Texas%'
SELECT @TEXASDOCT AS NUMERTEXASDOC

--14. Create a table variable using data in the dbo.HospitalStaff table with the following 4 columns




--a. Name – Located in the NameJob Column : Everything before the _

--b. Job – Located in the NameJob Column : Everything after the _

--c. HireDate
--d. City – Located in the Location Column: Everything before the –

--e. State – Located in the Location Column: Everyting after the –

DECLARE @NEW TABLE (Names varchar(50),job varchar(50),HireDate Date, City varchar(50),  State  varchar(50))
INSERT INTO  @NEW(Names,job,HireDate,City,State)
Select LEFT (NameJob,CHARINDEX('_',NameJob)-1) as Names, SUBSTRING(NameJob,CHARINDEX('_',NameJob)+1,LEN (NameJob)) AS Job,
HireDate, LEFT (Location,CHARINDEX('-',Location)-1) as City,SUBSTRING (Location,CHARINDEX('-',Location)+1,LEN(Location)) as State

from HospitalStaff ;
Select * FROM @NEW

/**15. Create a Table Variable using data in the dbo.HospitalStaff table with the following 4 columns

a. NameJob

b. DateYear – The Year of the HireDate

c. DateMonth – The Month of the HireDate

d. DateDay – The Day of the HireDate**/

declare @varT table(NameJob varchar(50), DateYear INT, DateMonth INT, DateDay INT) 
INsert into @varT(NameJob,DateYear,DateMonth,DateDay)
SElect NameJob, datepart(yy, HireDate) AS year_hire_date,datepart(MM, HireDate) AS Month_hire_date,datepart(DD, HireDate) AS date_hire_date
from HospitalStaff;
Select * FROM @varT