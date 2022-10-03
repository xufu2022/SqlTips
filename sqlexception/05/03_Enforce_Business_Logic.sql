-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO


-- Let's check and see how many sales orders we have.
SELECT COUNT(1) AS [SalesOrderCount]
FROM [Sales].[SalesOrder];
GO



-- We don't want sales orders added with inactive salespeople.
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

    THROW;

END CATCH;
GO



SELECT TOP (1) [Id] FROM [Sales].[SalesPerson]
WHERE IsActive = 0
ORDER BY Id ASC;
GO


-- We are using an inactive salesperson here.
EXECUTE [Sales].[Insert_SalesOrder] @SalesPerson = 1901, -- Use an inactive salesperson
                                    @SalesAmount = 7500,
                                    @SalesDate = '9/1/2022',
                                    @SalesTerritory = 2,
									@SalesOrderStatus = 1,
                                    @OrderDescription = 'An older sales order with an inactive salesperson';
GO



-- Did that sales order get added?
SELECT COUNT(1) AS [SalesOrderCount]
FROM [Sales].[SalesOrder];
GO