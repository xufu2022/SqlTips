-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO



-- Let's see how many rows are in the salesperson table.
SELECT COUNT(1) AS [Salesperson Count]
FROM [Sales].[SalesPerson];
GO


-- Autocommit is the default mode of SQL Server.
INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
	VALUES	('0003001','Susan','Jobes',300,2,'Susan.Jobes@WiredBrainCoffee.com',1,'9/5/2022');

INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
	VALUES	('0003002','Harry','Martin',300,2,'Harry.Martin@WiredBrainCoffee.com',1,'9/5/2022');

INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
	VALUES	('0003003','Karen','Wright',300,5,'Karen.Wright@WiredBrainCoffee.com',1,'9/5/2022');
GO





-- Will any values be inserted?
INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
	VALUES	('0003001','Susan','Jobes',300,2,'Susan.Jobes@WiredBrainCoffee.com',1,'9/5/2022'),
			('0003002','Harry','Martin',300,2,'Harry.Martin@WiredBrainCoffee.com',1,'9/5/2022'),
			('0003003','Karen','Wright',300,5,'Karen.Wright@WiredBrainCoffee.com',1,'9/5/2022');
GO



-- Our original count was 3000; what is it now?
SELECT COUNT(1) AS [Salesperson Count]
FROM [Sales].[SalesPerson];
GO



-- Below you turn on Implicit transactions.
SET IMPLICIT_TRANSACTIONS ON;

	INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
		VALUES	('Director');

	INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
		VALUES	('Senior Director');
GO


-- Let's look at two methods for checking open transactions.
-- Method 1
DBCC OPENTRAN;
GO

-- Method 2
SELECT	s.[session_id]
		,s.[open_transaction_count]
FROM [sys].[dm_exec_sessions] s
ORDER BY [last_request_start_time] DESC;
GO

-- Session option 2 indicates implicit transactions.
-- https://docs.microsoft.com/en-us/previous-versions/sql/sql-server-2005/ms176031(v=sql.90)
SELECT @@OPTIONS & 2;
GO


ROLLBACK TRANSACTION;
GO

SET IMPLICIT_TRANSACTIONS OFF;
GO



-- My preferred method is using explicit transactions.
BEGIN TRANSACTION;

	INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
		VALUES	('Director');

	INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
		VALUES	('Senior Director');

COMMIT TRANSACTION;
GO


-- Can you roll back DDL statements?
BEGIN TRANSACTION;

	ALTER TABLE [Sales].[SalesPersonLevel] ADD [isActive] bit NOT NULL DEFAULT 1;

	TRUNCATE TABLE [Sales].[SalesOrder];

ROLLBACK TRANSACTION;
GO


-- Let's check our tables to see what's going on.
SELECT * 
FROM [Sales].[SalesPersonLevel];
GO

SELECT COUNT(1) AS [SalesOrder Count]
FROM [Sales].[SalesOrder];
GO