/** Name: Esther Koffi
Lab2
SECTION 106
9/20/2024 
**/
---
--1
drop table if exists Menu
create table Menu 
 ( ItemID int identity(1000,1) primary key,
 ItemName Varchar(50) null, ItemType Varchar(50) null,
 CostToMake money null, Price money null, WeeklySales int null,
 MonthlySales int null, YearlySales int null)
 
 ----b. ItemType does not allow nulls
 Alter table Menu 
 alter column ItemType Varchar(50) not null;

 ---c. CostToMake should always be greater than 0
 ALter table Menu
 add constraint ct_CostToMake 
 check(CostToMake >0)

 ---2. Run the following script to populate the table

 INSERT INTO dbo.Menu

SELECT 'Big Mac','Hamburger',1.25,3.24,1015,5000,15853

union

SELECT 'Quarter Pounder / Cheese','Hamburger',1.15,3.24,1000,4589,16095

union

SELECT 'Half Pounder / Cheese','Hamburger',1.35,3.50,500,3500,12589

union

SELECT 'Whopper','Hamburger',1.55,3.99,989,4253,13000

union

SELECT 'Kobe Cheeseburger','Hamburger',2.25,5.25,350,1500,5000

union

SELECT 'Grilled Stuffed Burrito','Burrito',.75,5.00,2000,7528,17896

union

SELECT 'Bean Burrito','Burrito',.50,1.00,1750,7000,18853

union

SELECT '7 layer Burrito','Burrito',.78,2.50,350,1000,2563

union

SELECT 'Dorrito Burrito','Burrito',.85,1.50,600,2052,9857

union

SELECT 'Turkey and Cheese Sub','Sub Sandwich',1.75,5.50,1115,7878,16853

union

SELECT 'Philly Cheese Steak Sub','Sub Sandwich',2.50,6.00,726,2785,8000

union

SELECT 'Tuna Sub','Sub Sandwich',1.25,4.50,825,3214,13523
union

SELECT 'Meatball Sub','Sub Sandwich',1.95,6.50,987,4023,15287

union

SELECT 'Italian Sub','Sub Sandwich',2.25,7.00,625,1253,11111

union

SELECT '3 Cheese Sub','Sub Sandwich',.25,6.00,815,3000,1185





---3. Retrieve all Burritos and sort by Price
SELECT ItemType, Price
FROM Menu
where ItemType = 'Burrito'
Order by Price;

--4. Retrieve all items that Cost more than $1.00 to make and sort by WeeklySales
SELECT ItemName, CostToMake, WeeklySales 
FROM Menu
Where CostToMake >1
Order by WeeklySales

--5. What’s the sum of total profit by ItemType
select ItemType, SUM(PRICE-CostToMake) as Total_Profit
FROM Menu
GROUP BY ItemType
Order by ItemType

---  6. Retrieve Total Weekly Sales by ItemType of only items with more than 3000 weekly Sales. Sort by Total Weekly Sales descending.
select ItemType, SUM (WeeklySales ) AS Total_Weekly_Sales
From Menu
GROUP BY ItemType
Having SUM (WeeklySales )>3000
ORDER BY Total_Weekly_Sales DESC;



---7. Find out the profit made Weekly, Monthly and Yearly on Big Mac’s

SELECT 
ItemName, 
(Price -CostToMake)* WeeklySales AS Profit_made_weekly,
(Price -CostToMake)* MonthlySales AS Profit_made_Monthly,
(Price -CostToMake)* YearlySales AS Profit_made_Yearly
FROM Menu
where ItemName LIKE '%Big%MAC%'


--8. Retrieve the ItemType has more than $20,000 in Monthly Sales
Select Itemtype, SUM(MonthlySales) AS MS
FROM Menu
GROUP BY ItemType
HAVING SUM(MonthlySales)> 20000;

---9. Retrieve the ItemType that had the best Profit from MonthlySales--
Select top 1 Itemtype, SUM ((PRICE-COSTTOMAKE)* MonthlySales )
AS TOTAL_MONTTHLY_SALES
FROM Menu
Group by ItemType
ORDER BY TOTAL_MONTTHLY_SALES
