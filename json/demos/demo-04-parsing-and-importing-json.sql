/* demo-04-parsing-and-importing-json */

DECLARE @JSONFILE VARCHAR (MAX);

SELECT @JSONFILE = BulkColumn 
FROM OPENROWSET (BULK 'Y:\files\top-posts.json', SINGLE_CLOB) as j;

Print @JSONFILE;

If (ISJSON(@JSONFILE)=1) Print 'Valid JSON';