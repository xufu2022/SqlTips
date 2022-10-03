-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO


-- Let's check our current transaction count.
SELECT @@TRANCOUNT;
GO

-- We currently have 6 rows.
SELECT COUNT(1) AS [SalesPerson Count] 
FROM [Sales].[SalesPersonLevel];
GO


-- Let's see how @@TRANCOUNT works.
BEGIN TRANSACTION;

	UPDATE [Sales].[SalesOrder] SET [OrderDescription] = NULL
	WHERE Id < 101;

ROLLBACK TRANSACTION;
GO



-- Now let's try and nest a transaction.
BEGIN TRANSACTION Level_1;

	INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
		VALUES	('Vice President');

BEGIN TRANSACTION Level_2;

	INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
		VALUES ('CIO');

BEGIN TRANSACTION Level_3;

	INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
		VALUES ('Intern');

GO



-- Let's check our current transaction count.
SELECT @@TRANCOUNT;
GO



-- Will this command work?
ROLLBACK TRANSACTION Level_3;
GO



-- I only want to commit up to level 3.
COMMIT TRANSACTION Level_2;
GO



-- Do we have the intern?
SELECT * 
FROM [Sales].[SalesPersonLevel];
GO



-- A rollback must be applied to the outermost transaction.
ROLLBACK TRANSACTION Level_1;
GO


-- Paul Randal talks about the myth of nested transactions.
-- https://www.sqlskills.com/blogs/paul/a-sql-server-dba-myth-a-day-2630-nested-transactions-are-real/