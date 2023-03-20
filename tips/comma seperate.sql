SELECT 
	GETDATE() AS [CreatedOn]
	, au.[Id] AS [CreatedById] 
	, a.[PersonId] AS [PersonId]
	, a.[Details] + ' for property ' + a.[ProprtyCode] + ' planned works starts on ' + a.[StartDate] + ' to ' + a.[EndDate] + ' by ' + a.[Contractor] + ' - ' + a.[ContractorContactNumber] AS [Details]  
	, GETDATE() AS [EventDate]
	, (SELECT [Id] FROM [CRM].[dbo].[FlagTypes] WHERE [Name] = 'Planned Works') AS [FlagTypeId]
	, (SELECT [Id] FROM [CRM].[dbo].[FlagGroups] WHERE [Name] = 'Information') AS [FlagGroupId]
	, 0 AS [IsDeleted]
	, a.[Id] AS [SystemRefId]
	, au.[Id] AS [ModifiedById]
	, GETDATE() AS [ModifiedOn]
FROM 
	ActiveIdentity..AspNetUsers  au
INNER JOIN(
SELECT DISTINCT
    [OriginalValues].[Id],
	createdby
    --, [UploadedFileId]
    , [pt].[PersonId]
    , S.a.value('(/H/r)[1]', 'VARCHAR(MAX)') AS [ProprtyCode]
    , S.a.value('(/H/r)[2]', 'VARCHAR(MAX)')  AS [Details]
    , S.a.value('(/H/r)[3]', 'VARCHAR(MAX)') AS [StartDate]
    , S.a.value('(/H/r)[4]', 'VARCHAR(MAX)') AS [EndDate]
    , S.a.value('(/H/r)[5]', 'VARCHAR(MAX)') AS [Contractor]
    , S.a.value('(/H/r)[6]', 'VARCHAR(MAX)') AS [ContractorContactNumber] 
FROM
    (
    SELECT 
        [Id]
        , createdby
        --[UploadedFileId],
        , CAST (N'<H><r>' + REPLACE(CurrentDataValues, ',', '</r><r>')  + '</r></H>' AS XML) AS [vals] 
    FROM 
        [RMS].[dbo].[UploadedFileRecords]) OriginalValues 
        CROSS APPLY OriginalValues.[vals].nodes('/H/r') S(a),
        [CRM].[dbo].[Properties] [prop]
        INNER JOIN [CRM].[dbo].[Tenancies] [t] ON [prop].[Id] = [t].[PropertyId]
        INNER JOIN [CRM].[dbo].[PersonTenancies] [pt] ON [t].[Id] = [pt].[TenancyId] 
    WHERE 
        [prop].[PropertyCode] IN (CAST(S.a.value('(/H/r)[1]', 'VARCHAR(MAX)') as nvarchar)) AND [pt].[PersonEndDate] IS NULL AND [pt].[IsMainTenant] = 1) a
	ON au.[Email] = a.[CreatedBy]
WHERE 
	[a].[Id] NOT IN (SELECT [SystemRefId] FROM [CRM].[dbo].[PersonFlags] WHERE [SystemRefId] IS NOT NULL)
	

DECLARE @inputString NVARCHAR(MAX) = '21720,   850101003,   3 Alcester Garth,    FLAT,      Rooms,   Bathroom,          01/03/2014  ,30s';
DECLARE @delimiter CHAR(1) = ',';
DECLARE @count INT = LEN(@inputString) - LEN(REPLACE(@inputString, @delimiter, '')) + 1;

WITH Numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
  FROM Numbers
  WHERE n < @count
),
Substrings AS (
  SELECT
    n,
    SUBSTRING(@delimiter + @inputString + @delimiter,
      CHARINDEX(@delimiter, @delimiter + @inputString, CHARINDEX(@delimiter, @delimiter + @inputString, 1) * n - (n - 1) * 2) + 1,
      CHARINDEX(@delimiter, @delimiter + @inputString, CHARINDEX(@delimiter, @delimiter + @inputString, 1) * n - (n - 1) * 2 + 1) - CHARINDEX(@delimiter, @delimiter + @inputString, CHARINDEX(@delimiter, @delimiter + @inputString, 1) * n - (n - 1) * 2) - 1
    ) AS Substring
  FROM Numbers
)
SELECT
  LTRIM(RTRIM(MAX(CASE WHEN n = 1 THEN Substring END))) AS Column1,
  LTRIM(RTRIM(MAX(CASE WHEN n = 2 THEN Substring END))) AS Column2,
  LTRIM(RTRIM(MAX(CASE WHEN n = 3 THEN Substring END))) AS Column3,
  LTRIM(RTRIM(MAX(CASE WHEN n = 4 THEN Substring END))) AS Column4,
  LTRIM(RTRIM(MAX(CASE WHEN n = 5 THEN Substring END))) AS Column5,
  LTRIM(RTRIM(MAX(CASE WHEN n = 6 THEN Substring END))) AS Column6,
  LTRIM(RTRIM(MAX(CASE WHEN n = 7 THEN Substring END))) AS Column7,
  LTRIM(RTRIM(MAX(CASE WHEN n = 8 THEN Substring END))) AS Column8
FROM Substrings
OPTION (MAXRECURSION 0);
In this example, the Numbers common table expression (CTE) generates a sequence of integers from 1 to the number of substrings. The Substrings CTE uses the SUBSTRING function along with the CHARINDEX function to extract the individual substrings between the delimiters. Finally, the main SELECT statement trims the extracted substrings and assigns them to the corresponding columns.






DECLARE @inputString NVARCHAR(MAX) = '21720,   850101003,   3 Alcester Garth,    FLAT,      Rooms,   Bathroom,          01/03/2014  ,30s';

WITH SplitData AS (
  SELECT
    value,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RowNumber
  FROM STRING_SPLIT(@inputString, ',')
),
ProcessedData AS (
  SELECT
    LTRIM(RTRIM(value)) AS ProcessedValue,
    RowNumber
  FROM SplitData
)
SELECT
  MAX(CASE WHEN RowNumber = 1 THEN ProcessedValue END) AS Column1,
  MAX(CASE WHEN RowNumber = 2 THEN ProcessedValue END) AS Column2,
  MAX(CASE WHEN RowNumber = 3 THEN ProcessedValue END) AS Column3,
  MAX(CASE WHEN RowNumber = 4 THEN ProcessedValue END) AS Column4,
  MAX(CASE WHEN RowNumber = 5 THEN ProcessedValue END) AS Column5,
  MAX(CASE WHEN RowNumber = 6 THEN ProcessedValue END) AS Column6,
  MAX(CASE WHEN RowNumber = 7 THEN ProcessedValue END) AS Column7,
  MAX(CASE WHEN RowNumber = 8 THEN ProcessedValue END) AS Column8
FROM ProcessedData;
These queries will split the input string by commas, remove extra spaces, and display the result as Column1, Column2, Column3, Column4, Column5, Column6, Column7, and Column8.




fu xu
can i use substring in tsql?
Yes, you can use the SUBSTRING function in T-SQL (Transact-SQL), which is the dialect of SQL used by Microsoft SQL Server. The SUBSTRING function allows you to extract a portion of a string by specifying the start position and the length of the substring.

Here's an example of how to use the SUBSTRING function in T-SQL to process the input string:

sql
Copy code
DECLARE @inputString NVARCHAR(MAX) = '21720,   850101003,   3 Alcester Garth,    FLAT,      Rooms,   Bathroom,          01/03/2014  ,30s';
DECLARE @delimiter CHAR(1) = ',';
DECLARE @count INT = LEN(@inputString) - LEN(REPLACE(@inputString, @delimiter, '')) + 1;

WITH Numbers AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1
  FROM Numbers
  WHERE n < @count
),
Substrings AS (
  SELECT
    n,
    SUBSTRING(@delimiter + @inputString + @delimiter,
      CHARINDEX(@delimiter, @delimiter + @inputString, CHARINDEX(@delimiter, @delimiter + @inputString, 1) * n - (n - 1) * 2) + 1,
      CHARINDEX(@delimiter, @delimiter + @inputString, CHARINDEX(@delimiter, @delimiter + @inputString, 1) * n - (n - 1) * 2 + 1) - CHARINDEX(@delimiter, @delimiter + @inputString, CHARINDEX(@delimiter, @delimiter + @inputString, 1) * n - (n - 1) * 2) - 1
    ) AS Substring
  FROM Numbers
)
SELECT
  LTRIM(RTRIM(MAX(CASE WHEN n = 1 THEN Substring END))) AS Column1,
  LTRIM(RTRIM(MAX(CASE WHEN n = 2 THEN Substring END))) AS Column2,
  LTRIM(RTRIM(MAX(CASE WHEN n = 3 THEN Substring END))) AS Column3,
  LTRIM(RTRIM(MAX(CASE WHEN n = 4 THEN Substring END))) AS Column4,
  LTRIM(RTRIM(MAX(CASE WHEN n = 5 THEN Substring END))) AS Column5,
  LTRIM(RTRIM(MAX(CASE WHEN n = 6 THEN Substring END))) AS Column6,
  LTRIM(RTRIM(MAX(CASE WHEN n = 7 THEN Substring END))) AS Column7,
  LTRIM(RTRIM(MAX(CASE WHEN n = 8 THEN Substring END))) AS Column8
FROM Substrings
OPTION (MAXRECURSION 0);
In this example, the Numbers common table expression (CTE) generates a sequence of integers from 1 to the number of substrings. The Substrings CTE uses the SUBSTRING function along with the CHARINDEX function to extract the individual substrings between the delimiters. Finally, the main SELECT statement trims the extracted substrings and assigns them to the corresponding columns.






