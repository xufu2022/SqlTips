-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO



-- Let's use Savepoints in SQL Server.
BEGIN TRANSACTION;

	SAVE TRANSACTION Level_1;

		INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
			VALUES	('Vice President');

	SAVE TRANSACTION Level_2;

		INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
			VALUES ('CIO');

	SAVE TRANSACTION Level_3;

		INSERT INTO [Sales].[SalesPersonLevel] ([LevelName])
			VALUES ('Intern');

	SAVE TRANSACTION Level_4;
GO


-- Let's check our transaction count.
SELECT @@TRANCOUNT;
GO


-- Now we can remove the intern.
ROLLBACK TRANSACTION Level_3;
GO




-- What do our level names look like?
SELECT * 
FROM [Sales].[SalesPersonLevel];
GO




-- Let's only commit up to Savepoint 3.
COMMIT TRANSACTION Level_3;
GO


-- Let's check the transaction count again.
SELECT @@TRANCOUNT;
GO



-- What do our level names look like?
SELECT * 
FROM [Sales].[SalesPersonLevel];
GO




-- I recommend this Microsoft article on Savepoints.
-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/save-transaction-transact-sql?view=sql-server-2017