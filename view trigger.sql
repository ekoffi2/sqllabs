/** ESther KOFFi

10/21/2025
LAB : 113

**/
     --1----



-- Creating and Managing View and Triggers Lab

-- Q1 CREATE the following tables – Dept_triggers, Emp_triggers, EmpHistory
CREATE TABLE Dept_triggers (
    DeptID INT IDENTITY(1000,1) PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Emp_triggers (
    EmpID INT IDENTITY(1000,1) PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT
);

CREATE TABLE EmpHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    EmpID INT,
    EmpName VARCHAR(50),
    DeptID INT,
    IsActive BIT,
    ModifiedDate DATETIME DEFAULT GETDATE()
);

-- Q2 Build a trigger on the emp table after insert that adds a record into the emp_History table and marks IsActive column to 1
CREATE TRIGGER trg_AfterInsert_Emp
ON Emp_triggers
AFTER INSERT
AS
BEGIN
    INSERT INTO EmpHistory (EmpID, EmpName, DeptID, IsActive)
    SELECT EmpID, EmpName, DeptID, 1
    FROM inserted;
END;

-- Q3 Build a trigger on the emp table after an update of the empname or deptid column - It updates the subsequent empname and/or deptid in the emp_history table
CREATE TRIGGER trg_AfterUpdate_Emp
ON Emp_triggers
AFTER UPDATE
AS
BEGIN
    UPDATE eh
    SET eh.EmpName = i.EmpName,
        eh.DeptID = i.DeptID,
        eh.ModifiedDate = GETDATE()
    FROM EmpHistory eh
    INNER JOIN inserted i ON eh.EmpID = i.EmpID
    WHERE UPDATE(EmpName) OR UPDATE(DeptID);
END;

-- Q4 Build a trigger on the emp table after delete that marks the isactive status = 0 in the emp_History table
CREATE TRIGGER trg_AfterDelete_Emp
ON Emp_triggers
AFTER DELETE
AS
BEGIN
    UPDATE eh
    SET IsActive = 0,
        ModifiedDate = GETDATE()
    FROM EmpHistory eh
    INNER JOIN deleted d ON eh.EmpID = d.EmpID;
END;

-- Q5 Run this script – Results should show 10 records in the emp history table all with an active status of 0
INSERT INTO dbo.Emp_triggers (EmpName, DeptID) VALUES
('Ali',1000),
('Buba',1000),
('Cat',1001),
('Doggy',1001),
('Elephant',1002),
('Fish',1002),
('George',1003),
('Mike',1003),
('Anand',1004),
('Kishan',1004);

DELETE FROM dbo.Emp_triggers;

SELECT * FROM EmpHistory;

-- Q6 Create 5 views – Each view will use 3 tables and have 9 columns with 3 coming from each table

-- Q6.1 Create a view using 3 Human Resources Tables and utilize the WHERE clause
CREATE VIEW vw_HR_View AS
SELECT e.BusinessEntityID, e.JobTitle, e.BirthDate,
       d.Name AS DepartmentName, d.GroupName, d.ModifiedDate AS DeptModified,
       sh.ShiftID, sh.Name AS ShiftName, sh.StartTime
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID
WHERE e.Gender = 'M';

-- Q6.2 Create a view using 3 Person Tables and utilize 3 system functions
CREATE VIEW vw_Person_View AS
SELECT p.BusinessEntityID, UPPER(p.FirstName) AS FirstName,
       LEN(p.LastName) AS LastNameLength,
       a.City, a.PostalCode, GETDATE() AS CurrentDate,
       e.EmailAddress, LOWER(e.EmailAddress) AS LowerEmail, LEFT(e.EmailAddress,5) AS ShortEmail
FROM Person.Person p
JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN Person.EmailAddress e ON p.BusinessEntityID = e.BusinessEntityID;

-- Q6.3 Create a view using 3 Production Tables and utilize the Group By Statement
CREATE VIEW vw_Production_View AS
SELECT p.ProductSubcategoryID, COUNT(p.ProductID) AS ProductCount, AVG(p.ListPrice) AS AvgPrice,
       s.Name AS SubcategoryName, c.Name AS CategoryName, MAX(p.StandardCost) AS MaxCost,
       MIN(p.StandardCost) AS MinCost, SUM(p.ListPrice) AS TotalListPrice, GETDATE() AS CreatedDate
FROM Production.Product p
JOIN Production.ProductSubcategory s ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN Production.ProductCategory c ON s.ProductCategoryID = c.ProductCategoryID
GROUP BY p.ProductSubcategoryID, s.Name, c.Name;

-- Q6.4 Create a view using 3 Purchasing Tables and utilize the HAVING clause
CREATE VIEW vw_Purchasing_View AS
SELECT v.VendorID, v.Name, COUNT(p.ProductID) AS ProductCount,
       SUM(p.StandardPrice) AS TotalPrice, AVG(p.StandardPrice) AS AvgPrice,
       MIN(p.StandardPrice) AS MinPrice, MAX(p.StandardPrice) AS MaxPrice,
       po.PurchaseOrderID, po.OrderDate
FROM Purchasing.ProductVendor p
JOIN Purchasing.Vendor v ON p.BusinessEntityID = v.BusinessEntityID
JOIN Purchasing.PurchaseOrderHeader po ON v.BusinessEntityID = po.VendorID
GROUP BY v.VendorID, v.Name, po.PurchaseOrderID, po.OrderDate
HAVING COUNT(p.ProductID) > 5;

-- Q6.5 Create a view using 3 Sales Tables and utilize the CASE Statement
CREATE VIEW vw_Sales_View AS
SELECT s.SalesOrderID, s.OrderDate, s.CustomerID,
       c.PersonID, c.StoreID, c.TerritoryID,
       CASE 
           WHEN s.TotalDue > 5000 THEN 'High Value'
           WHEN s.TotalDue BETWEEN 1000 AND 5000 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS OrderCategory,
       s.TotalDue, s.SubTotal, s.TaxAmt
FROM Sales.SalesOrderHeader s
JOIN Sales.Customer c ON s.CustomerID = c.CustomerID
JOIN Sales.SalesTerritory t ON c.TerritoryID = t.TerritoryID;
