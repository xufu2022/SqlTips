-- Run this script to follow along with the demo.


-- Let's start a new error log.
-- Please don't run this in production.
EXECUTE sp_cycle_errorlog;  
GO  





-- Which line number do you get back?
SELECT	'First Script'
		,1/0;
GO





-- You can check the error number.
SELECT @@ERROR;
GO





-- Let's use a variable to hold the error number.
DECLARE @ErrorId int; 
SELECT 1/0;

SET @ErrorId = @@ERROR;

SELECT @ErrorId;
GO





-- Let's check out the message.
SELECT [message_id]
	   ,[language_id]
	   ,[severity]
	   ,[is_event_logged]
	   ,[text]	
FROM [sys].[messages] 
WHERE [message_id] = 8134
GO





-- These messages are logged by SQL Server.
SELECT [message_id]
	   ,[language_id]
	   ,[severity]
	   ,[is_event_logged]
	   ,[text]	
FROM [sys].[messages] 
WHERE [is_event_logged] = 1
GO





-- Add your own error messages.
EXECUTE sp_addmessage @msgnum=50010,@severity=16,
	@msgtext='Row count does not match';  
GO





-- Let's see if our message exists.
SELECT [message_id]
	   ,[language_id]
	   ,[severity]
	   ,[is_event_logged]
	   ,[text]	
FROM [sys].[messages] 
WHERE [message_id] = 50010
GO




-- If we want to change the error to be logged.
EXECUTE sp_altermessage @message_id = 50010, @parameter = 'WITH_LOG',
@parameter_value = 'TRUE';
GO





-- Let's drop the message.
-- You might also want to pass in the language.
EXECUTE sp_dropmessage @msgnum = 50010;  
GO