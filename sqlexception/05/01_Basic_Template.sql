-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO



-- Here we are adding a new column.
ALTER TABLE [Sales].[SalesPerson] ADD [LastSalesDate] DATE NULL;
GO




-- We don't have any error handling in this stored procedure.
CREATE OR ALTER PROCEDURE [Sales].[Insert_SalesOrder]
    @SalesPerson INT,
    @SalesAmount DECIMAL(36, 2),
    @SalesDate DATE,
    @SalesTerritory INT,
	@SalesOrderStatus INT,
    @OrderDescription NVARCHAR(MAX)
AS
BEGIN

    SET NOCOUNT ON;

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

    UPDATE [Sales].[SalesPerson]
    SET [LastSalesDate] = GETDATE()
    WHERE [Id] = @SalesPerson;

END;
GO




-- This statement will fail.
EXECUTE [Sales].[Insert_SalesOrder] @SalesPerson = 1,
                                    @SalesAmount = 7500,
                                    @SalesDate = '8/21/2022',
                                    @SalesTerritory = 88,
                                    @SalesOrderStatus = 1,
									@OrderDescription = 'First sale of the month. Ship ASAP!';
GO




-- Did the lastsalesdate get updated?
SELECT [LastSalesDate]
FROM [Sales].[SalesPerson]
WHERE [Id] = 1;
GO




-- Let's clean up.
UPDATE [Sales].[SalesPerson]
SET [LastSalesDate] = NULL
WHERE [Id] = 1;
GO




-- Below is a basic template with error handling.
CREATE OR ALTER PROCEDURE [Sales].[Insert_SalesOrder]
    @SalesPerson INT,
    @SalesAmount DECIMAL(36, 2),
    @SalesDate DATE,
    @SalesTerritory INT,
	@SalesOrderStatus INT,
    @OrderDescription NVARCHAR(MAX)
AS
BEGIN

    BEGIN TRY

        SET NOCOUNT ON;

        SET XACT_ABORT ON;

        BEGIN TRANSACTION;

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

        UPDATE [Sales].[SalesPerson]
        SET [LastSalesDate] = GETDATE()
        WHERE [Id] = @SalesPerson;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF (@@TRANCOUNT > 0)
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END;
GO




-- This will fail again.
EXECUTE [Sales].[Insert_SalesOrder] @SalesPerson = 1,
                                    @SalesAmount = 7500,
                                    @SalesDate = '8/21/2022',
                                    @SalesTerritory = 88,
                                    @SalesOrderStatus = 1,
									@OrderDescription = 'First sale of the month. Ship ASAP!';
GO




-- The lastsalesdate should be null.
SELECT [LastSalesDate]
FROM [Sales].[SalesPerson]
WHERE [Id] = 1;
GO