-- Run this script to follow along with the demo.
-- READ Script
USE [WiredBrainCoffee];
GO



-- Can we perform a select?
SELECT TOP 10 * 
FROM [Sales].[SalesPerson];
GO


-- How about on the record we are updating?
SELECT *
FROM [Sales].[SalesPerson] WHERE [Id] = 1;
GO



-- What about a different row?
SELECT *
FROM [Sales].[SalesPerson] WHERE [Id] = 2;
GO



-- Here we are using NOLOCK.
SELECT *
FROM [Sales].[SalesPerson] WITH (NOLOCK) WHERE Id = 1;
GO


-- Let's change the isolation level to read uncommitted.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT *
FROM [Sales].[SalesPerson] WHERE Id = 1;
GO


-- Don't forget to set this back!
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO