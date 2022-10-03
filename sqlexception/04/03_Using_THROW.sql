-- Run this script to follow along with the demo.

-- This will not work outside of a TRY...CATCH block.
THROW;
GO






-- Notice we don't specify the severity.
THROW 50010,'This is a great message',1;
GO




-- The syntax for using THROW is simple.
-- Notice what line number SQL returns.
BEGIN TRY
	
	SELECT 1/0;

END TRY

BEGIN CATCH

	THROW;
	PRINT 'Does this print?';

END CATCH
GO




-- Let's use a variable as the message text and number.
DECLARE @MessageText nvarchar(500);
DECLARE @ErrorNumber int;
SET @MessageText = 'This is a custom error message';
SET @ErrorNumber = 65000;

THROW @ErrorNumber,@MessageText,1;
GO