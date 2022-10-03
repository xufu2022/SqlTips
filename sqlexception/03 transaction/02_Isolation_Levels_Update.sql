-- Run this script to follow along with the demo.
-- UPDATE Script
USE [WiredBrainCoffee];
GO

-- Let's check which isolation level we are using.
DBCC USEROPTIONS;
GO


SELECT	s.[session_id] AS [SPID]
		,s.[nt_user_name] AS [User]
		,CASE s.[transaction_isolation_level] 
		WHEN 0 THEN 'Unspecified'
		WHEN 1 THEN 'Read Uncomitted'
		WHEN 2 THEN 'Read Comitted'
		WHEN 3 THEN 'Repeatable'
		WHEN 4 THEN 'Serializable'
		WHEN 5 THEN 'Snapshot'
                  END as [Isolation Level]
FROM [sys].[dm_exec_sessions] [s]
WHERE [s].[session_id] = @@SPID;
GO


-- Let's perform some updates on our SalesPerson table.
BEGIN TRANSACTION;

	UPDATE [Sales].[SalesPerson] SET [Email] = NULL;

ROLLBACK TRANSACTION;
GO


-- Let's make sure we have no open transactions.
DBCC OPENTRAN;
GO

-- Now let's try and update one row.
BEGIN TRANSACTION;

	UPDATE [Sales].[SalesPerson] SET [Email] = NULL WHERE [Id] = 1;

ROLLBACK TRANSACTION;
GO