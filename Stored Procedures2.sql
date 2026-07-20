/** ESther KOFFi

10/21/2025
LAB : 112

**/
----1----
IF OBJECT_ID('proc_TerritorySalesByYear', 'P') IS NOT NULL
    DROP PROCEDURE proc_TerritorySalesByYear;
GO

CREATE PROCEDURE proc_TerritorySalesByYear
    @OrderYear INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        st.Name AS TerritoryName,
        SUM(sod.LineTotal) AS TotalSales
    FROM Sales.SalesOrderHeader soh
    INNER JOIN Sales.SalesOrderDetail sod 
        ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Sales.SalesTerritory st 
        ON soh.TerritoryID = st.TerritoryID
    WHERE YEAR(soh.OrderDate) = @OrderYear
    GROUP BY st.Name
    ORDER BY TotalSales DESC;
END;
GO
EXEC proc_TerritorySalesByYear @OrderYear = 2013;
GO


---2----
IF OBJECT_ID('proc_SalesByTerritory', 'P') IS NOT NULL
    DROP PROCEDURE proc_SalesByTerritory;
GO

CREATE PROCEDURE proc_SalesByTerritory
    @TerritoryName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        YEAR(soh.OrderDate) AS OrderYear,
        SUM(sod.LineTotal) AS TotalSales
    FROM Sales.SalesOrderHeader soh
    INNER JOIN Sales.SalesOrderDetail sod 
        ON soh.SalesOrderID = sod.SalesOrderID
    INNER JOIN Sales.SalesTerritory st 
        ON soh.TerritoryID = st.TerritoryID
    WHERE st.Name = @TerritoryName
    GROUP BY YEAR(soh.OrderDate)
    ORDER BY OrderYear;
END;
GO


EXEC proc_SalesByTerritory @TerritoryName = 'Northwest';
GO

---3-----

IF OBJECT_ID('proc_TerritoryTop5Sales_ByProduct', 'P') IS NOT NULL
    DROP PROCEDURE proc_TerritoryTop5Sales_ByProduct;
GO

CREATE PROCEDURE proc_TerritoryTop5Sales_ByProduct
    @TerritoryName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH TerritorySales AS (
        SELECT 
            YEAR(soh.OrderDate) AS OrderYear,
            p.Name AS ProductName,
            SUM(sod.LineTotal) AS TotalSales
        FROM Sales.SalesOrderHeader soh
        INNER JOIN Sales.SalesOrderDetail sod 
            ON soh.SalesOrderID = sod.SalesOrderID
        INNER JOIN Production.Product p 
            ON sod.ProductID = p.ProductID
        INNER JOIN Sales.SalesTerritory st 
            ON soh.TerritoryID = st.TerritoryID
        WHERE st.Name = @TerritoryName
        GROUP BY YEAR(soh.OrderDate), p.Name
    )
    SELECT OrderYear, ProductName, TotalSales
    FROM (
        SELECT 
            OrderYear,
            ProductName,
            TotalSales,
            ROW_NUMBER() OVER (PARTITION BY OrderYear ORDER BY TotalSales DESC) AS RankByYear
        FROM TerritorySales
    ) ranked
    WHERE RankByYear <= 5
    ORDER BY OrderYear, TotalSales DESC;
END;
GO




IF OBJECT_ID('dbo.emp', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.emp (
        empID INT PRIMARY KEY,
        empName VARCHAR(50),
        MgrID INT NULL
    );

    INSERT INTO dbo.emp (empID, empName, MgrID) VALUES
    (1, 'Alice', NULL),
    (2, 'Bob', 1),
    (3, 'Carol', 1),
    (4, 'Dave', 2),
    (5, 'Eve', 2),
    (10, 'ManagerA', NULL),
    (11, 'ManagerB', NULL);
END;
GO



----4----
IF OBJECT_ID('sp_GetManagerID', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetManagerID;
GO

CREATE PROCEDURE sp_GetManagerID
    @empID INT,
    @mgrID INT OUTPUT
AS
BEGIN
    SELECT @mgrID = MgrID
    FROM dbo.emp
    WHERE empID = @empID;
END;
GO


DECLARE @empID INT = 5;
DECLARE @mgrID INT;
DECLARE @manager_name VARCHAR(50);

EXEC sp_GetManagerID @empID = @empID, @mgrID = @mgrID OUTPUT;

SELECT @manager_name = empName
FROM dbo.emp
WHERE empID = @mgrID;

PRINT 'Manager Name: ' + ISNULL(@manager_name, 'No Manager Found');
GO



USE AdventureWorks2019;  -- Change to your installed version
GO
