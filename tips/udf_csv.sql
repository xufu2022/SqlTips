
ALTER   FUNCTION [dbo].[udfFileRecordData] (
	@dataValue nvarchar(max)
)
RETURNS  TABLE 
AS
return
 select [AssetComponentId],[PropertyCode],[Address],[PropertyType]
 ,[ComponentGroup],[ComponentName],[InstallDate],[ExpectedLifeInYears],[ReplacementYear]
FROM (
select case 
		when ColumnID = 0 then 'AssetComponentId'
        when ColumnID = 1 then 'PropertyCode'
        when ColumnID = 2 then 'Address'
        when ColumnID = 3 then 'PropertyType'
        when ColumnID = 4 then 'ComponentGroup'
        when ColumnID = 5 then 'ComponentName'   
        when ColumnID = 6 then 'InstallDate'
        when ColumnID = 7 then 'ExpectedLifeInYears'
        when ColumnID = 8 then 'ReplacementYear' 		
		else null end as 
 ColumnRow , [value] from 
 ( SELECT CONVERT(int, [key]) as ColumnID,[value]
FROM OPENJSON(CONCAT('["', REPLACE(@dataValue, ',', '","'), '"]'))) a)
 as SOURCETABLE
  PIVOT
 (
 MAX([value])
 FOR ColumnRow IN ([AssetComponentId],[PropertyCode],[Address],[PropertyType]
 ,[ComponentGroup],[ComponentName],[InstallDate],[ExpectedLifeInYears],[ReplacementYear]
 )
 )
 AS  PivotTable 
