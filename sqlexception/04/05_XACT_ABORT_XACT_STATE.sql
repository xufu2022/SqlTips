-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO



-- Let's remove these rows if they exist.
DELETE FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- Let's check and see how many rows we have.
SELECT COUNT(1) [SalesPerson Count]
FROM [Sales].[SalesPerson];
GO



-- Using XACT_ABORT ON without an explicit transaction.
-- Are any of the rows inserted?
SET XACT_ABORT ON;
	
	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004000','Ella','Fant',300,2,'Ella.Fant@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004001','Dan','Sing',300,99,'Dan.Sing@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004002','Bill','Board',300,2,'Bill.Board@WiredBrainCoffee.com',1,'9/5/2022');

GO




-- Which rows were inserted?
SELECT * 
FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- Let's remove so we can try again.
DELETE FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- Let's use XACT_ABORT ON with an explicit transaction.
-- Will SQL insert any rows?
SET XACT_ABORT ON;

BEGIN TRANSACTION;
	
	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004000','Ella','Fant',300,2,'Ella.Fant@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004001','Dan','Sing',300,99,'Dan.Sing@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004002','Bill','Board',300,5,'Bill.Board@WiredBrainCoffee.com',1,'9/5/2022');

COMMIT TRANSACTION;
GO




-- Did any row get inserted?
SELECT * 
FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- Do we need to clean up?
DELETE FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO



-- Using XACT_ABORT & XACT_STATE together.
SET XACT_ABORT OFF;

BEGIN TRY

BEGIN TRANSACTION;
	
	SELECT XACT_STATE(); -- Should be 1

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004000','Ella','Fant',300,2,'Ella.Fant@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004001','Dan','Sing',300,99,'Dan.Sing@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004002','Bill','Board',300,5,'Bill.Board@WiredBrainCoffee.com',1,'9/5/2022');

COMMIT TRANSACTION;

END TRY

BEGIN CATCH

	SELECT XACT_STATE();

	IF (XACT_STATE() = -1)
		BEGIN
			PRINT 'Things are not looking good';
			ROLLBACK TRANSACTION;
		END

	IF (XACT_STATE() = 1)
		BEGIN
			PRINT 'At least something works';
			COMMIT TRANSACTION;
		END

END CATCH
GO




-- Did either row get inserted?
SELECT * 
FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- Let's clean up.
DELETE FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO




-- Using XACT_ABORT & XACT_STATE together.
SET XACT_ABORT ON;

BEGIN TRY

BEGIN TRANSACTION;
	
	SELECT XACT_STATE(); -- Should be 1

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004000','Ella','Fant',300,2,'Ella.Fant@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004001','Dan','Sing',300,99,'Dan.Sing@WiredBrainCoffee.com',1,'9/5/2022');

	INSERT INTO [Sales].[SalesPerson] ([EmployeeNumber],[FirstName],[LastName],[SalaryHr],[LevelId],[Email],[IsActive],[StartDate])
		VALUES	('0004002','Bill','Board',300,5,'Bill.Board@WiredBrainCoffee.com',1,'9/5/2022');

COMMIT TRANSACTION;

END TRY

BEGIN CATCH
	
	SELECT XACT_STATE();
	
	IF (XACT_STATE() = -1)
		BEGIN
			PRINT 'Things are not looking good';
			ROLLBACK TRANSACTION;
		END

	IF (XACT_STATE() = 1)
		BEGIN
			PRINT 'At least something works';
			COMMIT TRANSACTION;
		END

END CATCH
GO




-- Did either row get inserted?
SELECT * 
FROM [Sales].[SalesPerson] WHERE [EmployeeNumber] IN ('0004000','0004001','0004002');
GO