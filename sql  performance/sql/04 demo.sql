USE [master];
GO

RESTORE DATABASE [EmployeeCaseStudy]
FROM DISK = N'C:\dev\09\projects\SqlTips\data\EmployeeCaseStudySampleDB2012.bak'
WITH MOVE N'EmployeeCaseStudyData' 
		TO N'C:\dev\09\projects\SqlTips\data\EmployeeCaseStudyData.mdf',  
	 MOVE N'EmployeeCaseStudyLog' 
		TO N'C:\dev\09\projects\SqlTips\data\EmployeeCaseStudyLog.ldf',
	 STATS = 10, REPLACE;
GO

Select @@version

ALTER DATABASE [EmployeeCaseStudy]
		SET COMPATIBILITY_LEVEL = 150; -- SQL Server 2014
GO

use [EmployeeCaseStudy]

GO

SELECT [t].* 
FROM [sys].[tables] AS [t];
GO

-- Review table definition and indexes
EXEC [sp_help] '[dbo].[Employee]';

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

-- NOTE: IOs alone are not the ONLY way to understand
-- what's going on. We'll add graphical showplan as well.
-- Use Query, Include Actual Execution Plan


-- Think like an index in the back of a book... you
-- reference one thing (the index key) but then have
-- to go to the data to get more information.

-- The table (i.e. the "book") is structured by the 
-- clustering key of EmployeeID 

-- The reference (i.e. the index in the back of the book)
-- is SSN (the nonclustered index)

SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[SSN] = '749-21-9445';
GO

SELECT [EmployeeID]
FROM [dbo].[Employee] AS [e]
WHERE [e].[SSN] = '749-21-9445';
GO

SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[EmployeeID] = 12345;
GO

-------------------------------------------------------------------------------
-- Employee Table as a Heap
-------------------------------------------------------------------------------

-- Review table definition and indexes
EXEC [sp_help] [EmployeeHeap];
GO

-- With a HEAP the "book" is unstructured 
-- But, there are still secondary reference columns such
-- as EmployeeID and SSN (the nonclustered indexes)

-- Bookmark lookup from a nonclustered to a heap
SELECT [e].* 
FROM [dbo].[EmployeeHeap] AS [e]
WHERE [e].[EmployeeID] = 12345;
GO

-- Bookmark lookup from a nonclustered to a heap
SELECT [e].* 
FROM [dbo].[EmployeeHeap] AS [e]
WHERE [e].[SSN] = '749-21-9445';
GO

-- -------------------------------------------------------------------------------
-- Bookmark lookups allow you to find data based
-- on secondary index keys
-- (we'll talk a lot more about this)
-------------------------------------------------------------------------------