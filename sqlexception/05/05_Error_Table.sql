-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO



-- Drop if the error log table already exists.
DROP TABLE IF EXISTS [dbo].[ErrorLog];
GO



-- This will create your error log table.
CREATE TABLE [dbo].[ErrorLog]
(
    [Id] INT IDENTITY(1, 1) NOT NULL,
    [MessageId] INT NOT NULL,
    [MessageText] NVARCHAR(2047) NULL,
    [SeverityLevel] INT NOT NULL,
    [State] INT NOT NULL,
    [LineNumber] INT NOT NULL,
    [ProcedureName] NVARCHAR(2500) NULL,
    [CreateDate] DATETIME NOT NULL
        DEFAULT GETDATE(),
    CONSTRAINT [PK_ErrorLog_Id]
        PRIMARY KEY CLUSTERED ([Id])
);
GO



-- Let's log a message to the error log table.
BEGIN TRY

    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    INSERT INTO [Sales].[SalesPerson]
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
    ('0005000', 'Paige', 'Turner', 300, 99, 'Paige.Turner@WiredBrainCoffee.com', 1, '9/5/2022');

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;

    INSERT INTO [dbo].[ErrorLog]
    (
        [MessageId],
        [MessageText],
        [SeverityLevel],
        [State],
        [LineNumber],
        [ProcedureName]
    )
    VALUES
    (ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(), ERROR_PROCEDURE());

    THROW;

END CATCH;
GO



-- Let's check the error log table.
SELECT *
FROM [dbo].[ErrorLog];
GO



-- Let's create a procedure to log the error message.
CREATE OR ALTER PROCEDURE [dbo].[Log_Error_Message]
AS
BEGIN TRY

    SET NOCOUNT ON;

    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    INSERT INTO [dbo].[ErrorLog]
    (
        [MessageId],
        [MessageText],
        [SeverityLevel],
        [State],
        [LineNumber],
        [ProcedureName]
    )
    VALUES
    (ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_LINE(), ERROR_PROCEDURE());

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;

    THROW;

END CATCH;
GO



-- Here we are using the error log procedure.
BEGIN TRY

    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    INSERT INTO [Sales].[SalesPerson]
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
    ('0005000', 'Paige', 'Turner', 300, 99, 'Paige.Turner@WiredBrainCoffee.com', 1, '9/5/2022');

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;

    EXECUTE [dbo].[Log_Error_Message];

    THROW;

END CATCH;
GO



-- Let's check the error log table again.
SELECT *
FROM [dbo].[ErrorLog];
GO



CREATE OR ALTER PROCEDURE [Sales].[Insert_SalesOrder]
    @SalesPerson INT,
    @SalesAmount DECIMAL(36, 2),
    @SalesDate DATE,
    @SalesTerritory INT,
    @SalesOrderStatus INT,
    @OrderDescription NVARCHAR(MAX)
AS
BEGIN TRY

    SET NOCOUNT ON;

    SET XACT_ABORT ON;

    BEGIN TRANSACTION;

    IF EXISTS
    (
        SELECT 1
        FROM [Sales].[SalesPerson]
        WHERE [IsActive] = 0
              AND [Id] = @SalesPerson
    )
    BEGIN
        ; THROW 65001, 'Please select an active salesperson.', 1;
    END;
    ELSE
        INSERT INTO [Sales].[SalesOrder]
        (
            [SalesPerson],
            [SalesAmount],
            [SalesDate],
            [SalesTerritory],
            [SalesOrderStatus],
            [OrderDescription]
        )
        VALUES
        (@SalesPerson, @SalesAmount, @SalesDate, @SalesTerritory, @SalesOrderStatus, @OrderDescription);

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH

    IF (@@TRANCOUNT > 0)
        ROLLBACK TRANSACTION;

    EXECUTE [dbo].[Log_Error_Message];

    THROW;

END CATCH;
GO


-- Let's find an inactive salesperson.
SELECT TOP (1)
       *
FROM Sales.SalesPerson
WHERE IsActive = 0;
GO


-- We are using an inactive sales person here.
EXECUTE [Sales].[Insert_SalesOrder] @SalesPerson = xxxx, -- Input an inactive salesperson
                                    @SalesAmount = 7500,
                                    @SalesDate = '6/1/2019',
                                    @SalesTerritory = 2,
                                    @SalesOrderStatus = 1,
                                    @OrderDescription = 'An older order';
GO



-- Let's check the error log table one last time.
SELECT *
FROM [dbo].[ErrorLog];
GO