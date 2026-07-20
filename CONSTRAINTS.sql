/** Esther Koffi
Section 105
09/19/2025 **/

-- Create primary keys on all tables
CREATE Table Customer( CustID int Primary Key,
Custname Varchar(50) null, HireDate datetime null);

Create Table SalesReps ( RepID int primary key , Repname 
Varchar(50) null, Hiredate datetime null);

Create Table Sales(SalesID int primary key, CustId int null,
RepId int null, SalesDate datetime null, UnitCount int null,
VerificationCode Varchar(50) null);

---All 3 tables should have IDENTITY columns as the PRIMARY KEY’s. 
--They must start at 100 and increment by 2.
DROP table if exists sales;
Create Table Sales(SalesID int identity (100,2) primary key,
CustId int null,RepId int null, SalesDate datetime null,
UnitCount int null,VerificationCode Varchar(50) null);

DROP table if exists salesReps
Create Table SalesReps ( RepID int identity( 100,2) primary key,
Repname Varchar(50) null, Hiredate datetime null);

Drop table if exists Customer
Create Table Customer ( CustID int identity(100,2) primary key,
Custname Varchar(50) null, HireDate datetime null);

----Unique key on dbo.sales.Verification
Alter table Sales add constraint UQ_SAles_Verification 
Unique (VerificationCode);

---ADD foreign key to sales tables
Alter table Sales add constraint Fq_customer_salesreps 
Foreign key(CustId) references Customer (CustId);

ALTER table Sales add constraint Fq_sales_saleresps
foreign key( RepId) references Salesreps(RepId);

---No nulls will be allowed in the following tables.columns
---a. dbo.Sales.SalesDate
Alter table Sales 
alter column SalesDate datetime not null;
---b. dbo.Sales.VerificationCo
ALTER TABLE Sales
Drop Constraint UQ_SAles_Verification ;

ALter table Sales
Alter column VerificationCode  varchar(50) not null;

Alter table Sales add constraint UQ_SAles_Verification 
Unique (VerificationCode);

---The following tables.columns will default to GetDate() if no Date is given.
alter table Sales
add constraint df_sales_salesdate default Getdate() for salesdate;

---Dbo.Customer.EntryDate
alter table customer
add constraint df_customer_EntryDate default Getdate() for Hiredate;
---b. Dbo.SalesRep.HireDate
alter table SalesReps
add   constraint df_SalesReps_Hiredate default Getdate() for Hiredate;

---7. dbo.Sales.UnitCount should not allow NULLS or Zero’s
alter table Sales
alter column Unitcount int not null;

alter table Sales
add constraint ch_unitcount_posititif check (Unitcount>0);

---8. Run the following script to ensure the Constraints have been added correctly
EXEC sp_help Sales

INSERT INTO dbo.Customer (CustName)

SELECT 'Ali' UNION

SELECT 'Anand' UNION

SELECT 'Alex' UNION

SELECT 'Jack' UNION

SELECT 'Nina' UNION

SELECT 'Joel' UNION

SELECT 'Keon' UNION

SELECT 'James' UNION

SELECT 'Mike' UNION

SELECT 'Sai' UNION

SELECT 'Terry'


INSERT INTO dbo.SalesReps (RepName)

SELECT 'Joseph' UNION

SELECT 'Jermaine' UNION

SELECT 'Marshall' UNION

SELECT 'Marvin' UNION

SELECT 'Mitchell' UNION

SELECT 'Johnson' UNION

SELECT 'Robert' UNION

SELECT 'Rachel' UNION

SELECT 'Rene' UNION

SELECT 'Brandy'UNION

SELECT 'Dirk'


INSERT INTO dbo.Sales (CustID, RepID,UnitCount,VerificationCode)

SELECT 100,120,1,'Ver01' UNION

SELECT 102,118,2,'Ver02' UNION

SELECT 104,116,3,'Ver03' UNION

SELECT 106,114,4,'Ver04' UNION

SELECT 108,112,5,'Ver05' UNION

SELECT 110,110,1,'Ver06' UNION

SELECT 112,108,2,'Ver07' UNION

SELECT 114,106,3,'Ver08' UNION

SELECT 116,104,4,'Ver09' UNION

SELECT 118,102,5,'Ver10' UNION

SELECT 120,100,6,'Ver11'

