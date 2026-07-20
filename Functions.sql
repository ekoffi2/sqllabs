/**Esther koffi
section 107
09/25/2025
**/



--1. Create 2 statement using each of the following functions.



--a. LEN


select LEN('Esther')
select LEN('EPHARIM')
--b. LEFT

select LEFT('Esther',2)
select LEFT('Esther',3)


--c. RIGHT
select RIGHT('Esther',2)
select RIGHT('Esther',3)


---d. SUBSTRING

SELECT SUBSTRING ('EPHRAIM',2,3)
SELECT SUBSTRING ('ESTHER',3,2)

---e. CHARINDEX

Select charindex('I','EPHRAIM')
Select charindex('M','EPHRAIM')
 
--f. LTRIM

SELECT LTRIM(  'ESTHER')
SELECT LTRIM(   'EPHTRAIM')

---g. RTRIM

SELECT LTRIM('ESTHER'  )
SELECT LTRIM('EPHTRAIM'  )

--h. DATEDIFF

SELECT DATEDIFF (YY,'05/22/01','05/02/25')
SELECT DATEDIFF(yy,'08/22/1974',Getdate())

--i. DATEPART

select DATEPART(YY,getdate())
select DATEPART(MM,'09/12/2022')

--j. DATEADD

select DATEADD(YY,5,getdate())
select DAteADD(MM,7,'09/12/2022')

--k. CAST AND CONVERT

SELECT CAST(45/7 AS INT)
SELECT CAST('ESTHER' AS CHAR(2))

 SELECT CONVERT( INT, 98/5)
 SELECT CONVERT(INT ,22/3)



-- l. ISDATE

SELECT ISDATE ('ESTHER')
SELECT ISDATE(GETDATE())
SELECT ISDATE('04/02/2024')

--m. ISNULL
SELECT ISNULL(NULL,'ZERO')
SELECT ISNULL('YL', 7)

---n. ISNUMERIC
SELECT ISNUMERIC('ESTHER')
SELECT ISNUMERIC(2023)



---6. I want to add 2 months to today’s date?

SELECT DATEADD (MM,2, GETDATE());

---7. I have two dates (3/25/2007 and 4/1/2009) how can I get the number of months between the 

SELECT DATEDIFF(MM,'3/25/2007','4/1/2009')






IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Loan]') AND type in (N'U'))
DROP TABLE [dbo].[Loan]

CREATE TABLE [dbo].[Loan](
	[LoanNumber] [int] IDENTITY(1000,1) NOT NULL,
	[CustomerFname] [varchar](50) NULL,
	[CustomerLname] [varchar](50) NULL,
	[PropertyAddress] [varchar](150) NULL,
	[City] [varchar](150) NULL,
	[State] [varchar](50) NULL,
	[BankruptcyAttorneyName] [varchar](50) NULL,
	[UPB] MONEY NULL,
	[LoanDate] [Datetime] NULL
 CONSTRAINT [PK_Loan] PRIMARY KEY CLUSTERED 
(
	[LoanNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

TRUNCATE TABLE dbo.Loan

INSERT INTO [dbo].[Loan]
           ([CustomerFname]
           ,[CustomerLname]
           ,[PropertyAddress]
           ,[City]
           ,[State]
           ,[BankruptcyAttorneyName]
		   ,[UPB]
		   ,[LoanDate])
SELECT	'Mr. Anand','Dasari','1212 Main St.','Plano','TX','Jerry',85000,'1/1/2012' UNION
SELECT	'Mr. John','Nasari','1215 Joseph St.','Garland','TX','Jerry',95000,'4/2/2012' UNION
SELECT	'Dr. Ali','Muwwakkil','2375 True True St.','Atlanta','GA','Diesel',115000,'5/3/2008' UNION
SELECT	'Mr. John','Brown','11532 Chain St.','SanFrancisco','CA','Mora',350000,'6/13/2004' UNION
SELECT	'Dr. Kishan','Johnson','4625 Miller Rd.','Atlanta','GA','Diesel',225000,'8/9/2002' UNION
SELECT	'Mr. John','Jackson','972 Flower Rd.','Dallas','TX','Jerry',150000,'3/1/2012' UNION
SELECT	'Sr. Ralph','Jenkins','1518 Mission Ridge St.','SanFrancisco','CA','Mora',650000,'12/15/2011' UNION
SELECT	'Dr. John','Howard','102 Washington','Dallas','TX','Jerry',450000,'4/5/2010' UNION
SELECT	'Mrs. Marsha','Tamrie','1301 Solana','SanFrancisco','CA','Mora',750000,'7/1/2000' UNION
SELECT	'Mrs. Alexis','Gibson','1111 Phillips Rd.','Atlanta','GA','Diesel',99000,'6/1/2012' 
        
SELECT * FROM [dbo].[Loan] 



/**-8. Write a SQL query to retrieve loan number, state, city, UPB and todays date for loans in
the state of TX that have a UPB greater than $100,000 or loans that are in the state of CA or FL that have a UPB greater than or equal to $500,000
**/

SELECT LoanNumber, State, city, UPB, GETDATE()
from Loan
where (State = 'TX'
AND UPB >100000 )
OR
(STATE IN ('CA', 'FL') AND UPB >= 500000 );


---9. Write a SQL query to retrieve loan number, customer first name, customer last name, propertyAddress, and bankruptcy attorney name. I want all the records that have the same attorney name to be together, then the customer last name in order from Z-A (ex.Customer last name of Wyatt comes before customer last name of Anderson)

Select LoanNUMBER, CustomerFname,CustomerLname, PropertyAdDress, BankruptcyAttorneyName
FROM Loan
ORDER BY BankruptcyAttorneyName,
 CustomerLname DESC;

--10. Write a sql query tLo retrieve the loan number, state and city, customer first name for loans that are in the states of CA,TX,FL,NV,NM but exclude the following cities (Dallas, SanFrancisco, Oakland) and only return loans where customer first name begins with John.

SELECT LoanNumber, State, city, UPB, CustomerFname
FROM Loan 
Where State in ('CA','TX','FL','NV','NM')
And City not in ('Dallas', 'SanFrancisco', 'Oakland') 
and CustomerFname like '%John'

--11. Find out how many days old each Loan is?

SELECT LOANNUMBER, DATEDIFF(YY,LOANDATE,GETDATE()) AS LOANAGE
FROM LOAN

--12. Find the State with the highest Avg UPB.
 
 SELECT TOP 1 STATE,AVG(UPB) 
 FROM Loan
 GROUP BY State	
 ORDER BY AVG(UPB) desc
 

--13. Each Loan has a length of 30 years. Retrieve the LoanNumber, Attorney Name and the anticipated Finish Date of the Loan.

SELECT LoanNumber, BankruptcyAttorneyName, DATEADD(YY,30,LoanDate) AS anticipated_FinishDate
FROM Loan

--14. The Title of the Customer is Located in the CustomerFname Column. Separate the title into its own column and also retrieve CustomerFname, CustomerLname, City, State and LoanDate of Loans that are more than 1 yr old.

SELECT CustomerFname, CustomerLname, City, State,  left (CustomerFname, CHARINDEX('.',CustomerFname)) as Title
from Loan






--Find another function not used above. Explain what it does. Create a Statement using the new function and post it to the discussions. Take a screenshot of the posted article, paste it to a Word Doc and submit it with this assignment