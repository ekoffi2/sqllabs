/** ESTHER KOFFI
SECTION 110
09/29/2025**/



-----*Query 1 - Must use the LIKE and BETWEEN operators.

drop table if exists #EMPinfo
select LoginID,JobTitle,GENDER,OrganizationLevel,VacationHours
into #Empinfo
from HumanResources.Employee
where JobTitle like '%Engineer%'  and
(OrganizationLevel between 3 and 4)


select *
from #Empinfo



/** CTE IS COMMON TABLE EXPRESSION
CTE IS COMMON TABLE EXPRESSION**/

;With CTE_Empinfo
as
(select LoginID,JobTitle,GENDER,OrganizationLevel,VacationHours
from HumanResources.Employee
where JobTitle like '%Engineer%'  and
(OrganizationLevel between 3 and 4)
)
  

select* from CTE_Empinfo
where JobTitle like '%Engineer%'  and
(OrganizationLevel between 3 and 4)



/** variables*/

declare  @Empinfo table (LoginID NVARCHAR(30),JobTitle VARCHAR(50),GENDER CHAR(1),OrganizationLevel INT,VacationHours INT)
insert INTO  @Empinfo
select LoginID,JobTitle,GENDER,OrganizationLevel,VacationHours
from HumanResources.Employee
where JobTitle like '%Engineer%'  and
(OrganizationLevel between 3 and 4)

select * from @Empinfo


/**Query 2 – Must use the IN and NOT IN operators.**/

--temp table

drop table if exists #2empinfo
select LoginID,JobTitle,GENDER,OrganizationLevel,VacationHours
into #2empinfo
from HumanResources.Employee
where VacationHours not in  (3,16) and
(OrganizationLevel in (2,4))

select * from #2empinfo


---CTE


;WITH CTE_2empinfo
AS
(
select LoginID,JobTitle,GENDER,OrganizationLevel,VacationHours

from HumanResources.Employee
where VacationHours not in  (3,16) and
(OrganizationLevel in (2,4))
)

SELECT * FROM CTE_2empinfo


---TABLE VARIABLE


DECLARE @2empinfo Table (LoginID NVARCHAR(30),JobTitle VARCHAR(50),GENDER CHAR(1),OrganizationLevel INT,VacationHours INT)
insert INTO  @2empinfo
 select LoginID,JobTitle,GENDER,OrganizationLevel,VacationHours

from HumanResources.Employee
where VacationHours not in  (3,16) and
(OrganizationLevel in (2,4))

select *  from @2empinfo


/** Query 3 – Must use a GROUP BY Statement and 2 aggregates (Temp table should be built using SELECT INTO Statement.**/



drop table if exists #SALESTempsS
SELECT SalesOrderID ,COUNT( SalesOrderID) AS NUMBER_TOTAL, SUM(UnitPrice) AS TOTAL_PRICE
 INTO #SALESTempsS
 FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID

SELECT *FROM  #SALESTempsS
ORDER BY SalesOrderID


----CTE

;WITH CTE_SALES
AS(

SELECT SalesOrderID ,COUNT( SalesOrderID) AS NUMBER_TOTAL, SUM(UnitPrice) AS TOTAL_PRICE
 
 FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID

)

SELECT * FROM  CTE_SALES
ORDER BY SalesOrderID



----VARIABLE

DECLARE @SALES TABLE(SalesOrderID INT, NUMBER_TOTAL INT, TOTAL_PRICE MONEY) INSERT INTO @SALES (SalesOrderID , NUMBER_TOTAL , TOTAL_PRICE )
SELECT SalesOrderID ,COUNT( SalesOrderID) AS NUMBER_TOTAL, SUM(UnitPrice) AS TOTAL_PRICE
 FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID

SELECT * FROM  @SALES
ORDER BY SalesOrderID


/**  Must use the UNION operator.**/
----TEMP
Drop table if exists #SALES2
select SalesOrderDetailID, ProductID, OrderQty
INTO #SALES2
from Sales.SalesOrderDetail
WHERE OrderQty=1

UNION
select SalesOrderDetailID, ProductID, OrderQty
from Sales.SalesOrderDetail
WHERE OrderQty=2

SELECT * FROM #SALES2

---CTE

;WITH CTE_SALES2
AS(

select SalesOrderDetailID, ProductID, OrderQty

from Sales.SalesOrderDetail
WHERE OrderQty=1

UNION
select SalesOrderDetailID, ProductID, OrderQty
from Sales.SalesOrderDetail
WHERE OrderQty=2)

SELECT * FROM CTE_SALES2



---VARIABLE
DECLARE @SALES2 TABLE (SalesOrderDetailID INT, ProductID INT, OrderQty INT)
INSERT INTO @SALES2
select SalesOrderDetailID, ProductID, OrderQty

from Sales.SalesOrderDetail
WHERE OrderQty=1

UNION
select SalesOrderDetailID, ProductID, OrderQty
from Sales.SalesOrderDetail
WHERE OrderQty=2

 SELECT * FROM @SALES2



/**Query 5 – Must be built using at least one column that is a Primary Key with an Identity Column.**/


---TEMP

DROP TABLE IF EXISTS #SALES3
CREATE TABLE #SALES3 ( SalesOrderDetailID INT PRIMARY KEY, ProductID INT IDENTITY (2,180) , OrderQty INT)
 
 INSERT INTO #SALES3 ( SalesOrderDetailID , OrderQty)
   SELECT SalesOrderDetailID , OrderQty
 FROM SALES.SalesOrderDetail;

 
---CTE
;WITH CTE_SALES3
AS( select  * from #SALES3)
select * from CTE_SALES3



---variable

declare @SALES3 TABLE (SalesOrderDetailID INT , ProductID INT , OrderQty INT)


INSERT INTO @SALES3
SELECT SalesOrderDetailID , ProductID, OrderQty
FROM #SALES3

SELECT* FROM @SALES3



/** Query 6 – Must be built using a WHERE clause and ORDER BY clause.**/

DROP TABLE IF EXISTS  #sales4

SELECT top 1 OrderQty ,  ProductID ,SalesOrderID
into #sales4
FROM SALES.SalesOrderDetail
WHERE OrderQty = 2
ORDER BY  OrderQty;



select * from #sales4

--- cte

;with CTE_SALES4
AS
( SELECT top 1 OrderQty ,  ProductID ,SalesOrderID
FROM SALES.SalesOrderDetail
WHERE OrderQty = 2
ORDER BY  OrderQty
)


SELECT *  FROM CTE_SALES4


----VARIABLE

DECLARE @SALES4 TABLE (OrderQty INT ,  ProductID INT ,SalesOrderID INT)
 INSERT into @SALES4
 SELECT top 1 OrderQty ,  ProductID ,SalesOrderID
FROM SALES.SalesOrderDetail
WHERE OrderQty = 2
ORDER BY  OrderQty;

SELECT * FROM @SALES4 



/**Query 7 – Must be built using a GROUP BY clause and HAVING Clause.**/

---TEMP

DROP TABLE IF EXISTS  #SALES7
SELECT  SalesOrderID, SUM(UNITPrice) TOTAL,SUM (OrderQty) TOTAL_ORDER
INTO #SALES7
from SALES.SalesOrderDetail
GROUP BY SalesOrderID
HAVING  SUM (UNITPrice)>5000  ;


SELECT * from #SALES7


------CTE 

;WITH CTE_SALES7
AS 
(SELECT  SalesOrderID, SUM(UNITPrice) TOTAL,SUM (OrderQty) TOTAL_ORDER
from SALES.SalesOrderDetail
GROUP BY SalesOrderID
HAVING  SUM (UNITPrice)>5000)

SELECT * from  CTE_SALES7


----VARIABLES

DECLARE @SALES7 table (SalesOrderID INT, UNITPrice INT, OrderQty int)
insert into @SALES7
SELECT * from #SALES7

select * from @sales7


/**Query 8 – Must be built using WHERE / GROUP BY / HAVING / ORDER BY clauses**/


---TEMP
DROP TABLE IF EXISTS #SALES9
SELECT   TOP 3 SalesOrderID, SUM(UNITPrice) TOTAL,SUM (OrderQty) TOTAL_ORDER
INTO #SALES9
from SALES.SalesOrderDetail
GROUP BY SalesOrderID
HAVING  SUM (UNITPrice)>5000  
ORDER BY SalesOrderID;

SELECT * FROM   #SALES9

----CTE

;with CTE_SALES9
AS(
SELECT   TOP 3 SalesOrderID, SUM(UNITPrice) TOTAL,SUM (OrderQty) TOTAL_ORDER
from SALES.SalesOrderDetail
GROUP BY SalesOrderID
HAVING  SUM (UNITPrice)>5000  
ORDER BY SalesOrderID)


SELECT * FROM  CTE_SALES9



----VARIABLE

DECLARE @SALES9 TABLE (SalesOrderID INT, UNITPrice INT ,OrderQty INT) 
INSERT INTO  @SALES
SELECT   TOP 3 SalesOrderID, SUM(UNITPrice) TOTAL,SUM (OrderQty) TOTAL_ORDER
from SALES.SalesOrderDetail
GROUP BY SalesOrderID
HAVING  SUM (UNITPrice)>5000  
ORDER BY SalesOrderID

SELECT * FROM  @SALES9




---- TEMP
DROP TABLE IF EXISTS #TABLE10
SELECT RIGHT (LoginID, LEN(LoginID)-CHARINDEX('\', LOGINID)) AS USERLOGINID,
MaritalStatus, VacationHours
INTO
#TABLE10
FROM HumanResources. Employee
SELECT *
FROM #TABLE10




---CTE

;WITH CTE_TABLE10
AS(SELECT RIGHT (LoginID, LEN(LoginID)-CHARINDEX('\', LOGINID)) AS USERLOGINID,
MaritalStatus, VacationHours

FROM HumanResources. Employee)

SELECT * FROM CTE_TABLE10


----VARIABLE

DECLARE @TABLE10 TABLE( USERLOGINID NVARCHAR(30), MARITALSTATUS CHAR(1), VACATIONHOURS INT)
INSERT INTO @TABLE10
SELECT RIGHT (LoginID, LEN(LoginID)-CHARINDEX('\', LOGINID)) AS USERLOGINID,
MaritalStatus, VacationHours

FROM HumanResources. Employee


SELECT * FROM @TABLE10


/**Query 10 – Must be built using 3 other System Functions.**/


--- TEMP
DROP  TABLE IF EXISTS #TABLE11
SELECT DATEDIFF(MM, HireDate, GETDATE()) AS JOB_TENURE, DATEPART(MM,HIREDATE) AS HIREMONTH
INTO #TABLE11
FROM HumanResources. Employee

---CTE

; WITH CTE_TABLE11
AS
(
SELECT DATEDIFF(MM, HireDate, GETDATE()) AS JOB_TENURE, DATEPART(MM,HIREDATE) AS HIREMONTH
FROM HumanResources. Employee

)
SELECT * FROM  CTE_TABLE11


---VARIABLE

DECLARE @TABLE11 TABLE ( JOB_TENURE INT, HIREMONTH INT)
INSERT INTO @TABLE11
SELECT DATEDIFF(MM, HireDate, GETDATE()) AS JOB_TENURE, DATEPART(MM,HIREDATE) AS HIREMONTH
FROM HumanResources. Employee

SELECT * FROM @TABLE11