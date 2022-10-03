-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO



-- Let's check how many rows are in the salesperson table.
SELECT COUNT(1) AS [EmployeeCount]
FROM [Sales].[SalesPerson];
GO



-- Let's add a check constraint on the salesperson start date.
ALTER TABLE [Sales].[SalesPerson] WITH CHECK
ADD CONSTRAINT [CK_SalesPerson_StartDate] CHECK ([StartDate] <= DATEADD(MONTH,3,GETDATE()));
GO



-- This is not a clear error message.
BEGIN TRY

    BEGIN TRANSACTION;

    INSERT INTO Sales.SalesPerson
    (
        [EmployeeNumber],
        [FirstName],
        [LastName],
        [SalaryHr],
        [LevelId],
        [Email],
		[IsActive],
        [StartDate]
    )
    VALUES
    ('0003002', 'Amber', 'Green', 750, 1, 'Amber.Green@WiredBrainCoffee', 1, '1/1/2030');

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
GO



-- This message will make more sense to the end user.
BEGIN TRY

    DECLARE @CurrentDate DATE = DATEADD(MONTH,3,GETDATE());

    BEGIN TRANSACTION;

    INSERT INTO Sales.SalesPerson
    (
        [EmployeeNumber],
        [FirstName],
        [LastName],
        [SalaryHr],
        [LevelId],
        [Email],
		[IsActive],
        [StartDate]
    )
    VALUES
    ('0003002', 'Amber', 'Green', 750, 1, 'Amber.Green@WiredBrainCoffee', 1, '1/1/2030');

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    -- Can't we just use the error number?
    IF (
           ERROR_MESSAGE() = 'The INSERT statement conflicted with the CHECK constraint "CK_SalesPerson_StartDate". The conflict occurred in database "WiredBrainCoffee", table "Sales.SalesPerson", column ''StartDate''.'
           AND @@TRANCOUNT > 0
       )
    BEGIN
        DECLARE @Message NVARCHAR(500);
        SET @Message = CONCAT('Please enter a start date before ', @CurrentDate);

        ROLLBACK TRANSACTION;

        THROW 65000, @Message, 1;
    END;

    IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
GO


-- Using XACT_ABORT to perform the rollback.
BEGIN TRY

    SET XACT_ABORT ON;

    DECLARE @CurrentDate DATE = DATEADD(MONTH,3,GETDATE());

    BEGIN TRANSACTION;

    INSERT INTO Sales.SalesPerson
    (
        [EmployeeNumber],
        [FirstName],
        [LastName],
        [SalaryHr],
        [LevelId],
        [Email],
		[IsActive],
        [StartDate]
    )
    VALUES
    ('0003002', 'Amber', 'Green', 750, 1, 'Amber.Green@WiredBrainCoffee', 1, '1/1/2030');

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF (
           ERROR_MESSAGE() = 'The INSERT statement conflicted with the CHECK constraint "CK_SalesPerson_StartDate". The conflict occurred in database "WiredBrainCoffee", table "Sales.SalesPerson", column ''StartDate''.'
           AND @@TRANCOUNT > 0
       )
    BEGIN
        DECLARE @Message NVARCHAR(500);
        SET @Message = CONCAT('Please enter a start date before ', @CurrentDate);

        THROW 65000, @Message, 1;
    END;

    IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
GO