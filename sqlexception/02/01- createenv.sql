-- Run this script to follow along with the demo.
USE [master];
GO

-- Checking to see if our database exists and if it does drop it.
IF DATABASEPROPERTYEX ('WiredBrainCoffee','Version') IS NOT NULL
BEGIN
	ALTER DATABASE [WiredBrainCoffee] SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE;
	DROP DATABASE [WiredBrainCoffee];
END
GO

-- Make sure you have at least 1GB to follow along.
CREATE DATABASE [WiredBrainCoffee]
 ON PRIMARY 
( NAME = N'WiredBrainCoffee', FILENAME = N'C:\Pluralsight\SQLFiles\WiredBrainCoffee.mdf' ,SIZE = 100000KB , FILEGROWTH = 100000KB)
 LOG ON 
( NAME = N'WiredBrainCoffee_log', FILENAME = N'C:\Pluralsight\SQLFiles\WiredBrainCoffee_log.ldf',SIZE = 100000KB , FILEGROWTH = 100000KB)
GO


ALTER DATABASE [WiredBrainCoffee] SET RECOVERY SIMPLE;
GO

USE [WiredBrainCoffee];
GO

CREATE SCHEMA [Sales];
GO

CREATE SCHEMA [Bank];
GO

CREATE SCHEMA [Admin];
GO

-- Script inspired by Cathrine Wilhelmsen. Please check out her blog https://www.cathrinewilhelmsen.net/.
CREATE TABLE [Admin].[Numbers] (
	[Number] bigint NOT NULL,
	CONSTRAINT PK_Numbers PRIMARY KEY CLUSTERED ([Number]) WITH FILLFACTOR = 100);
GO

WITH
	L0   AS(SELECT 1 AS c UNION ALL SELECT 1),
	L1   AS(SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
	L2   AS(SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
	L3   AS(SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
	L4   AS(SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
	L5   AS(SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
	Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L5)
INSERT INTO [Admin].[Numbers] ([Number])
SELECT TOP (1000000) n FROM Nums ORDER BY n;
GO

CREATE TABLE [Sales].[SalesPersonLevel] (
	[Id] int identity(1,1) NOT NULL,
	[LevelName] nvarchar(500) NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL,
	CONSTRAINT [PK_SalesPersonLevel_Id] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
	VALUES	('Manager'),
			('Senior Staff'),
			('Staff'),
			('Associate');
GO

CREATE TABLE [Sales].[SalesPerson] (
	[Id] int identity(1,1) NOT NULL,
	[EmployeeNumber] nvarchar(10) NOT NULL,
	[FirstName] nvarchar(500) NOT NULL,
	[LastName] nvarchar(500) NOT NULL,
	[SalaryHr] decimal(32,2) NULL,
	[LevelId] int NOT NULL,
	[Email] nvarchar(500) NULL,
	[IsActive] bit NOT NULL,
	[StartDate] date NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL,
	CONSTRAINT [PK_SalesPerson_Id] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_SalesPersonLevel_Id] FOREIGN KEY ([LevelId]) REFERENCES [Sales].[SalesPersonLevel] ([Id]));
GO

WITH FirstName AS (
	SELECT 'Tom'	AS FirstName UNION ALL
	SELECT 'Sally'	AS FirstName UNION ALL
	SELECT 'Bill'	AS FirstName UNION ALL
	SELECT 'Ted'	AS FirstName UNION ALL
	SELECT 'Lisa'	AS FirstName UNION ALL
	SELECT 'Kerrie' AS FirstName UNION ALL
	SELECT 'Arun'	AS FirstName UNION ALL
	SELECT 'Wanda'	AS FirstName UNION ALL
	SELECT 'Tammy'	AS FirstName UNION ALL
	SELECT 'Dione'	AS FirstName
), LastName AS (
	SELECT 'Jones'	AS LastName UNION ALL
	SELECT 'Smith'	AS LastName UNION ALL
	SELECT 'Knocks' AS LastName UNION ALL
	SELECT 'James'	AS LastName UNION ALL
	SELECT 'Friend'	AS LastName UNION ALL
	SELECT 'Seker'	AS LastName UNION ALL
	SELECT 'Lincoln' AS LastName UNION ALL
	SELECT 'Morgan'	AS LastName UNION ALL
	SELECT 'Jones'	AS LastName UNION ALL
	SELECT 'Kumar'	AS LastName 
	)
INSERT INTO [Sales].[SalesPerson]
		([EmployeeNumber],
		[FirstName],
		[LastName],
		[SalaryHr],
		[LevelId],
		[Email],
		[IsActive],
		[StartDate]) 
	SELECT	CONCAT('000',ROW_NUMBER() OVER(ORDER BY (SELECT NULL))) AS 'EmployeeNumber',
			[FirstName] AS 'FirstName',
			[LastName] AS 'LastName',
			ABS(CHECKSUM(NEWID()) % 100) + 50 AS 'SalaryHr',
			ABS(CHECKSUM(NEWID()) % 4) + 1 AS 'LevelId',
			CONCAT([FirstName],'.',[LastName],n.number,'@WiredBrainCoffee.com') AS 'Email',
			CASE	WHEN n.[Number] % 20 = 0 THEN 0
					ELSE 1 END AS 'IsActive',
			DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2016', '05/01/2022')),'01/01/2016') AS 'StartDate'
	FROM FirstName
	CROSS JOIN LastName
	CROSS JOIN [Admin].[Numbers] n
	WHERE [n].[Number] <= 30;
GO

CREATE TABLE [Sales].[SalesTerritoryStatus] (
	[Id] int identity(1,1) NOT NULL,
	[StatusName] nvarchar(500) NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL,
	CONSTRAINT [PK_SalesTerritoryStatus_Id] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Sales].[SalesTerritoryStatus] ([StatusName])
	VALUES	('Active'),
			('Closing'),
			('In Review');
GO

CREATE TABLE [Sales].[SalesTerritory] (
	[Id] int identity(1,1) NOT NULL,
	[TerritoryName] nvarchar(500) NOT NULL,
	[Group] nvarchar(500) NULL,
	[StatusId] int NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL,
	CONSTRAINT [PK_SalesTerritory_Id] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_Status_Id] FOREIGN KEY ([StatusId]) REFERENCES [Sales].[SalesTerritoryStatus] ([Id]));
GO

INSERT INTO [Sales].[SalesTerritory] ([TerritoryName],[Group],[StatusId]) 
	VALUES	('Northwest','North America',1),
			('Northeast','North America',1),
			('Southwest','North America',1),
			('Southeast','North America',1),
			('Canada','North America',3),
			('France','Europe',1),
			('Germany','Europe',2),
			('Australia','Pacific',2),
			('United Kingdom','Europe',3),
			('Spain','Europe',1);
GO

CREATE TABLE [Sales].[SalesOrderStatus] (
	[Id] int identity(1,1) NOT NULL,
	[StatusName] nvarchar(500) NOT NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL,
	CONSTRAINT [PK_SalesOrderStatus_Id] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Sales].[SalesOrderStatus] ([StatusName])
	VALUES	('Complete'),
			('In Progress'),
			('Returned');
GO

CREATE TABLE [Sales].[SalesOrder] (
	[Id] int identity(1,1) NOT NULL,
	[SalesPerson] int NOT NULL,
	[SalesAmount] decimal(36,2) NOT NULL,
	[SalesDate] date NOT NULL,
	[SalesTerritory] int NOT NULL,
	[SalesOrderStatus] int NOT NULL,
	[OrderDescription] nvarchar(MAX) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL,
	CONSTRAINT [PK_SalesOrder_Id] PRIMARY KEY CLUSTERED ([Id]),
	CONSTRAINT [FK_SalesPerson_Id] FOREIGN KEY ([SalesPerson]) REFERENCES [Sales].[SalesPerson] ([Id]),
	CONSTRAINT [FK_SalesTerritory_Id] FOREIGN KEY ([SalesTerritory]) REFERENCES [Sales].[SalesTerritory] ([Id]),
	CONSTRAINT [FK_SalesOrderStatus_Id] FOREIGN KEY ([SalesOrderStatus]) REFERENCES [Sales].[SalesOrderStatus] ([Id]));
GO

DECLARE @Count int = 0;
WHILE (@Count < 1000000)
BEGIN
INSERT INTO [Sales].[SalesOrder]
		([SalesPerson],
		[SalesAmount],
		[SalesDate],
		[SalesTerritory],
		[SalesOrderStatus],
		[OrderDescription]) 
	SELECT	ABS(CHECKSUM(NEWID()) % 3000) + 1 AS 'SalesPerson',
			ABS(CHECKSUM(NEWID()) % 50) + 10 AS 'SalesAmount',
			DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, '01/01/2016', '04/30/2022')),'01/01/2016') AS 'SalesDate',
			ABS(CHECKSUM(NEWID()) % 10) + 1 AS 'SalesTerritory',
			CASE	WHEN @Count % 300000 = 0 THEN 3
					ELSE ABS(CHECKSUM(NEWID()) % 2) + 1 END AS 'SalesOrderStatus',
			'I love selling coffee' AS 'SalesDescription'
	FROM [Admin].[Numbers] AS nt WHERE [nt].[Number] <= 10000
	SET @Count = @Count + @@ROWCOUNT;
END
GO


-- The following statements will create our banking information.
CREATE TABLE [Bank].[Savings] (
	[Id] int identity(1,1) NOT NULL,
	[TransactionNotes] nvarchar(50) NOT NULL,
	[Amount] decimal(36,2) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_Savings] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Bank].[Savings] ([TransactionNotes], [Amount])
	VALUES ('Just Started', 5000.00),
		   ('Mowing Lawns', 500.00),
		   ('Short this month', -1400.00);
GO

CREATE TABLE [Bank].[Checking] (
	[Id] int identity(1,1) NOT NULL,
	[TransactionNotes] nvarchar(50) NOT NULL,
	[Amount] decimal(36,2) NULL,
	[CreateDate] datetime NOT NULL DEFAULT GETDATE(),
	[ModifyDate] datetime NULL
	CONSTRAINT [PK_Checking] PRIMARY KEY CLUSTERED ([Id]));
GO

INSERT INTO [Bank].[Checking] ([TransactionNotes], [Amount])
	VALUES ('Rent', -1200.00),
		   ('Paycheck', 2000.00),
		   ('Car Payment', -450.00);
GO