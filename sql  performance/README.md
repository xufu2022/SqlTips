# SqlTips

DBCC FREEPROCCACHE -- Do not run in production!
GO 

DBCC SHOW_STATISTICS

 SET STATISTICS TIME On;
 SET STATISTICS IO On

 EXEC [QuickCheckOnCache] '%VARCHAR (15)%';
 CREATE PROCEDURE [dbo].[QuickCheckOnCache]
(
    @StringToFind   NVARCHAR (4000)
)
AS
SET NOCOUNT ON;

SELECT [st].[text]
	, [qs].[execution_count]
	, [qs].*
	, [p].* 
FROM [sys].[dm_exec_query_stats] AS [qs] 
	CROSS APPLY [sys].[dm_exec_sql_text] 
		([qs].[sql_handle]) AS [st]
	CROSS APPLY [sys].[dm_exec_query_plan] 
		([qs].[plan_handle]) AS [p]
WHERE [st].[text] LIKE @StringToFind
ORDER BY 1, [qs].[execution_count] DESC;
GO