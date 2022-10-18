/* demo-07-filtering-data-using-contains-and-exist */

SELECT
	Id,
	Post_xml.value('(//Posts/@Title)[1]', 'nvarchar(255)') AS [Post Title],
	Post_xml.value('(//Posts/@Tags)[1]', 'nvarchar(100)') AS [Post Tags],
	Post_xml.query('//Comment') AS [All Comments]

FROM [tsql-xml-json].[dbo].[Posts]	

WHERE 
	Post_xml.exist('//Comment') = 1 AND
	Post_xml.exist('(//Posts[contains(@Tags,"machine-learning")])[1]') = 1 
	