---Use AdventureWorks Database to complete the following questions.
/** ESther KOFFI
I
09/30/2025
LAB : JOINTS

**/

---First lab
-- Create Table 1: Stg_Emp (new and current employees)
Drop table if exists Stg_Emp
CREATE TABLE Stg_Emp ( EmpID INT,EmpName VARCHAR(50));

INSERT INTO Stg_Emp (EmpID, EmpName) 

select 1, 'John Doe'
union
select 2, 'Jane Doe'
union select 3, 'Sally Mae'

-- Create Table 2: Emp_List (some current and all former employees)
Drop table if exists Emp_List
CREATE TABLE  Emp_List(EmpID INT ,EmpName VARCHAR(50);

INSERT INTO Emp_List (EmpID, EmpName) 
select
1, 'John Doe' union select 2, 'Jane Doe') union
select
5, 'Peggy Sue'

-- 1. New Employees (in Stg_Emp but not in Emp_List)
SELECT b.EmpID, b.EmpName
FROM Stg_Emp b
LEFT JOIN Emp_List a
ON b.EmpID = a.EmpID
WHERE a.EmpID IS NULL;

-- 2. Former Employees (in Emp_List but not in Stg_Emp)
SELECT a.EmpID, a.EmpName
FROM Emp_List a
LEFT JOIN Stg_Emp b ON a.EmpID = b.EmpID
WHERE b.EmpID IS NULL;


---1. How many Sales Orders (Headers) used Vista credit cards in October 2002

SELECT COUNT(a.SalesOrderID) 
FROM Sales.SalesOrderHeader a
JOIN Sales.CreditCard b
ON a.CreditCardID = b.CreditCardID
WHERE b.CardType = 'Vista'
  AND datepart(MM, a.OrderDate)=10
  AND datepart(YY, a.OrderDate)=2012;


-- Q2: Store the result in a variable
DECLARE @VQ1 INT;
SELECT @VQ1 = COUNT (a.SalesOrderID) 
FROM Sales.SalesOrderHeader a
JOIN Sales.CreditCard b
ON a.CreditCardID = b.CreditCardID
WHERE b.CardType = 'Vista'
  AND datepart(MM, a.OrderDate)=10
  AND datepart(YY, a.OrderDate)=2012;


 
  go

-- Create a UDF that accepts start date and end date. The function will return the number of Sales Orders (Using Vista credit cards) that took place between the start date and end date entered by the user.

drop function  if exists dbo.F1
Go
CREATE FUNCTION dbo.F1( @StartDate DATE, @EndDate DATE)
RETURNS INT
AS
BEGIN
  DECLARE @NUM INT;
 SELECT @NUM = COUNT(b.CreditCardID)
    FROM Sales.SalesOrderHeader a
    JOIN Sales.CreditCard b 
	ON a.CreditCardID = b.CreditCardID
    WHERE b.CardType = 'Vista'

	return @NUM
	END;
	go


---4. Using the SalesOrderHeader table - Find out how much Revenue (TotalDue) was brought in by the North American Territory Group from 2002 through 2004
SELECT SUM(a.TotalDue) 
FROM Sales.SalesOrderHeader a
JOIN Sales.SalesTerritory b 
ON  a.TerritoryID = b.TerritoryID
WHERE b.[Group] = 'North America'
  AND YEAR(a.OrderDate) BETWEEN 2002 AND 2004;



---5. What is the Sales Tax Rate, StateProvinceCode and CountryRegionCode for Texas?
SELECT tr.TaxRate,sp.StateProvinceCode, sp.CountryRegionCode
FROM Sales.SalesTaxRate tr
JOIN Person.StateProvince sp 
ON tr.StateProvinceID = sp.StateProvinceID
WHERE sp.Name = 'Texas';
---6. Store the information from Q5 in a variable.

declare @Q6  TABLE (TaxRate DECIMAL(8,2), StateProvinceCode CHAR(2), CountryRegionCode CHar(2));
INSERT INTO @q6 (TaxRate, StateProvinceCode, CountryRegionCode)
SELECT 
    tr.TaxRate,
    sp.StateProvinceCode,
    sp.CountryRegionCode
FROM Sales.SalesTaxRate tr
JOIN Person.StateProvince sp
ON tr.StateProvinceID = sp.StateProvinceID
WHERE sp.Name = 'Texas';

---7-Create a UDF that accepts the State Province and returns the associated Sales Tax Rate, StateProvinceCode and CountryRegionCode.

drop function if exists Q7
go
CREATE FUNCTION Q7 (@StateName VARCHAR(50))
RETURNs TABLE
AS
RETURN( SELECT  a.TaxRate, b.StateProvinceCode, b.CountryRegionCode
from Person.StateProvince b
join Sales.SalesTaxRate a
on a.StateProvinceID = b.StateProvinceID
where b.Name= @StateName)
go




---
--8. Show a list of Product Colors. For each Color show how many SalesDetails there are and the Total SalesAmount (UnitPrice * OrderQty). Only show Colors with a Total SalesAmount more than $50,000 and eliminate the products that do not have a color.
select  a.Color, count (b.SalesOrderDetailID) , sum (b.UnitPrice*b.OrderQty) as total
from Production.Product a
left join  Sales.SalesOrderDetail b
on a.ProductID =b.ProductID
WHERE b.ProductID is not null
Group by a.color
having sum (b.UnitPrice*b.OrderQty)<50000 
ORDER BY TOTAL DESC



--9. Create a join using 4 tables in AdventureWorks database. Explain what the join is doing and post it to the Google Group.
SELECT 
    a.SalesOrderID,
    a.OrderDate,
    a.TotalDue,
    c.CustomerID,
    c.AccountNumber,
    b.ProductID,
    b.OrderQty,
    b.UnitPrice,
    d.Name AS TerritoryName,
    d.CountryRegionCode
FROM Sales.SalesOrderHeader AS a
JOIN Sales.SalesOrderDetail AS b
    ON a.SalesOrderID = b.SalesOrderID
JOIN Sales.Customer AS c
    ON a.CustomerID = c.CustomerID
JOIN Sales.SalesTerritory  d
    ON a.TerritoryID = d.TerritoryID;

