-- Run this script to follow along with the demo
USE [WiredBrainCoffee];
GO


-- Let's check and see how many rows we have.
SELECT COUNT(1) [SalesPerson Count]
FROM [Sales].[SalesPerson];
GO




-- This insert should succeed.
-- We should not enter the CATCH.
BEGIN TRY 
	
	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004000','Ella','Fant',300,2,'Ella.Fant@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004001','Dan','Sing',300,2,'Dan.Sing@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004002','Bill','Board',300,2,'Bill.Board@WiredBrainCoffee.com',1,'9/5/2022');

END TRY

BEGIN CATCH

	PRINT 'Does this execute?';

END CATCH
GO




-- Let's remove so we can try again.
DELETE FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- The second insert will not work.
-- Will the third row be inserted?
BEGIN TRY 
		
	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004000','Ella','Fant',300,2,'Ella.Fant@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004001','Dan','Sing',300,99,'Dan.Sing@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004002','Bill','Board',300,2,'Bill.Board@WiredBrainCoffee.com',1,'9/5/2022');

END TRY

BEGIN CATCH

	PRINT 'Start Catch';

END CATCH
GO




-- Did either row get inserted?
SELECT * 
FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO



-- Let's remove so we can try again.
DELETE FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- The second insert will not work because of the level.
-- Is this the error we want to see?
BEGIN TRY 

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004000','Ella','Fant',300,2,'Ella.Fant@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004001','Dan','Sing',300,99,'Dan.Sing@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004002','Bill','Board',300,5,'Bill.Board@WiredBrainCoffee.com',1,'9/5/2022');

END TRY

BEGIN CATCH

	RAISERROR('Something went really wrong',16,1);

END CATCH
GO



-- Let's clean up
DELETE FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- This is more like it!
BEGIN TRY 

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004000','Ella','Fant',300,2,'Ella.Fant@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004001','Dan','Sing',300,99,'Dan.Sing@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004002','Bill','Board',300,5,'Bill.Board@WiredBrainCoffee.com',1,'9/5/2022');

END TRY

BEGIN CATCH

	DECLARE @ErrorMessage nvarchar(250);
	DECLARE @ErrorSeverity int;
	DECLARE @ErrorState int;
	DECLARE @ErrorLine int;
	
	SELECT	@ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE()
			,@ErrorLine = ERROR_LINE();

	RAISERROR(@ErrorMessage,@ErrorSeverity,@ErrorState,@ErrorLine);

END CATCH
GO