/* demo-06-working-with-xpath-query-syntax */


SELECT TOP (10)
	
	Id,
	Post_xml.value('(//Posts/@Title)[1]', 'nvarchar(255)') AS [Post Title],
	Post_xml.value('(//Author/@DisplayName)[1]', 'nvarchar(100)') AS [Author],
	Post_xml.value('(//Author/@Reputation)[1]', 'int') AS [Author Reputation],
	Post_xml.query('//Comment[@Score > 2]') AS [Relevant Comments]
FROM [tsql-xml-json].[dbo].[Posts]	

WHERE 
	Post_xml.value('(//Posts/@Title)[1]', 'nvarchar(255)') IS NOT NULL

ORDER BY Post_xml.value('(//Posts/@Score)[1]', 'int') DESC
	