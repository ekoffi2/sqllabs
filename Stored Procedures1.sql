/** ESther KOFFi

10/21/2025
LAB : 112

**/
     --1----
IF OBJECT_ID('TableA','U') IS NOT NULL DROP TABLE TableA;
IF OBJECT_ID('TableB','U') IS NOT NULL DROP TABLE TableB;
GO
CREATE TABLE TableA (Field1 INT);
CREATE TABLE TableB (Field1 INT);
INSERT INTO TableA VALUES (1),(2),(3),(4),(5),(6);
INSERT INTO TableB VALUES (2),(5),(7),(6),(3),(9);
GO

IF OBJECT_ID('sp_CommonValues','P') IS NOT NULL DROP PROCEDURE sp_CommonValues;
GO
CREATE PROCEDURE sp_CommonValues AS
BEGIN
    SELECT a.Field1
    FROM TableA a
    INNER JOIN TableB b ON a.Field1 = b.Field1;
END;
GO


--2--

IF OBJECT_ID('sp_OnlyInA','P') IS NOT NULL DROP PROCEDURE sp_OnlyInA;
GO
CREATE PROCEDURE sp_OnlyInA AS
BEGIN
    SELECT a.Field1
    FROM TableA a
    WHERE a.Field1 NOT IN (SELECT Field1 FROM TableB);
END;
GO


--3--

IF OBJECT_ID('sp_OnlyInB','P') IS NOT NULL DROP PROCEDURE sp_OnlyInB;
GO
CREATE PROCEDURE sp_OnlyInB AS
BEGIN
    SELECT b.Field1
    FROM TableB b
    WHERE b.Field1 NOT IN (SELECT Field1 FROM TableA);
END;
GO


--4--

IF OBJECT_ID('sp_SalesOrderSummary','P') IS NOT NULL DROP PROCEDURE sp_SalesOrderSummary;
GO
CREATE PROCEDURE sp_SalesOrderSummary
    @SalesOrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        soh.SalesOrderID,
        soh.OrderDate,
        COUNT(sod.ProductID) AS ItemCount
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
    WHERE soh.SalesOrderID = @SalesOrderID
    GROUP BY soh.SalesOrderID, soh.OrderDate;
END;
GO


--5--
IF OBJECT_ID('sp_SalesOrderShipping','P') IS NOT NULL DROP PROCEDURE sp_SalesOrderShipping;
GO
CREATE PROCEDURE sp_SalesOrderShipping
    @SalesOrderID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        soh.SalesOrderID,
        soh.OrderDate,
        soh.ShipDate,
        a.City,
        sp.Name AS StateProvince
    FROM Sales.SalesOrderHeader AS soh
    JOIN Person.Address AS a ON soh.ShipToAddressID = a.AddressID
    JOIN Person.StateProvince AS sp ON a.StateProvinceID = sp.StateProvinceID
    WHERE soh.SalesOrderID = @SalesOrderID;
END;
GO


--6--
IF OBJECT_ID('sp_TerritoryAnalysis','P') IS NOT NULL DROP PROCEDURE sp_TerritoryAnalysis;
GO
CREATE PROCEDURE sp_TerritoryAnalysis
    @TerritoryName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        st.[Group] AS TerritoryGroup,
        st.CountryRegionCode,
        COUNT(DISTINCT soh.SalesOrderID) AS SalesHeaderCount2001,
        COUNT(sod.SalesOrderDetailID) AS SalesDetailCount2001
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
    JOIN Sales.SalesTerritory AS st
        ON soh.TerritoryID = st.TerritoryID
    WHERE st.Name = @TerritoryName
      AND YEAR(soh.OrderDate) = 2001
    GROUP BY st.[Group], st.CountryRegionCode;
END;
GO


--7--

IF OBJECT_ID('sp_ProductPriceHistory','P') IS NOT NULL DROP PROCEDURE sp_ProductPriceHistory;
GO
CREATE PROCEDURE sp_ProductPriceHistory
    @ProductName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        p.Name AS ProductName,
        MIN(sod.UnitPrice) AS LowestPrice,
        MAX(sod.UnitPrice) AS HighestPrice,
        MAX(sod.UnitPrice) - MIN(sod.UnitPrice) AS PriceDifference,
        COUNT(sod.SalesOrderDetailID) AS DetailCount,
        SUM(sod.LineTotal) AS TotalLineAmount
    FROM Sales.SalesOrderDetail AS sod
    JOIN Production.Product AS p ON sod.ProductID = p.ProductID
    WHERE p.Name = @ProductName
    GROUP BY p.Name;
END;
GO


--8--

IF OBJECT_ID('sp_SalesSummaryByYear','P') IS NOT NULL DROP PROCEDURE sp_SalesSummaryByYear;
GO
CREATE PROCEDURE sp_SalesSummaryByYear
    @OrderYear INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        @OrderYear AS OrderYear,
        COUNT(DISTINCT soh.SalesOrderID) AS HeaderCount,
        COUNT(sod.SalesOrderDetailID) AS DetailCount
    FROM Sales.SalesOrderHeader AS soh
    JOIN Sales.SalesOrderDetail AS sod
        ON soh.SalesOrderID = sod.SalesOrderID
    WHERE YEAR(soh.OrderDate) = @OrderYear;
END;
GO

