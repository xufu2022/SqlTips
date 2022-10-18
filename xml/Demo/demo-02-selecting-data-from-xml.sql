/* demo-02-selecting-data-from-xml */

SELECT 
	Post_xml.value('(/root/Posts/@Id)[1]', 'int') AS [Post Id],
	Post_xml.value('(/root/Posts/@Title)[1]', 'varchar(500)') AS [Post Title],
	Post_xml.value('(/root/Posts/@CreationDate)[1]', 'datetime') AS [Post Creation],
	Post_xml.query('(/root/Posts/Comments)') AS [Post Author]
FROM Posts
WHERE
	Post_xml.value('(/root/Posts/@Score)[1]', 'int') > 100 AND
	Post_xml.value('(/root/Posts/@Title)[1]', 'varchar(500)') IS NOT NULL; 
