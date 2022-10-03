-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO





-- The following stored procedure is used for setting an employee to inactive.
CREATE OR ALTER PROCEDURE [Sales].[Update_SalesPerson_Inactive] @EmployeeNumber NVARCHAR(10)
AS
BEGIN

    BEGIN TRY

        SET NOCOUNT ON;

        SET XACT_ABORT ON;

        DECLARE @RowCount INT;

        BEGIN TRANSACTION;

        UPDATE [Sales].[SalesPerson]
        SET [IsActive] = 0
        WHERE [EmployeeNumber] = @EmployeeNumber;

        SET @RowCount = @@ROWCOUNT;

        IF (@RowCount > 1)
        BEGIN
            ; THROW 65002, 'There are multiple employees with this number.', 1;
        END;

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH

        IF (@@TRANCOUNT > 0)
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END;
GO



UPDATE [Sales].[SalesPerson]
SET EmployeeNumber = '0001'
WHERE Id IN ( 1, 2 );
GO



-- Let's try setting a salesperson to inactive.
EXECUTE [Sales].[Update_SalesPerson_Inactive] @EmployeeNumber = '0001';
GO