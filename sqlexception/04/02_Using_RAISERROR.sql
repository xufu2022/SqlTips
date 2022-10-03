-- Run this script to follow along with the demo.


-- Let's start a new error log.
-- Please do not run this in production.
EXECUTE sp_cycle_errorlog;  
GO  





-- Trying to improve the spelling will not work.
RAISEERROR('There is something wrong here',16,1);
GO





-- Raise a message without the Id.
RAISERROR('The row count does not match',16,1);
GO





-- Raise where the message Id does not exist.
RAISERROR(65000,16,1);
GO





-- Raise a message with a low severity level.
RAISERROR('This is a lower severity message',1,1);
GO





-- SQL will log this message into the error log.
RAISERROR('This is a custom logged message',16,1) WITH LOG;
GO





-- Here you are using a variable as the message text.
DECLARE @MessageText nvarchar(500);
SET @MessageText = 'This is a custom error message';

RAISERROR(@MessageText,16,1);
GO





-- Another way to check the error and log it.
DECLARE @ErrorNumber int;
SELECT 1/0;

SET @ErrorNumber = @@ERROR;

IF (@ErrorNumber = 8134)
	BEGIN
		RAISERROR('Please stop dividing by zero',0,1) WITH LOG;
	END
GO





-- The statement will show the message right away.
RAISERROR('I cannot wait 10 seconds',16,1) WITH NOWAIT;
WAITFOR DELAY '00:00:10';
GO





EXEC sp_addmessage @msgnum=50010,@severity=16,
	@msgtext='Row count from the %s table does not match',
	@replace = 'replace';  
GO





-- Let's raise a message without the Id.
DECLARE @TableName nvarchar(100) = 'SalesOrder';
RAISERROR(50010,16,1,@TableName);
GO





--  If the severity is over 19, SQL will terminate the connection.
RAISERROR('This is a fatal message',20,1) WITH LOG;
GO