-- Run this script to follow along with the demo.
USE [WiredBrainCoffee];
GO






-- Here we are using CAST. Do you think it will work?
SELECT CAST('31 Dec 12' AS date) AS 'First Date'
	   ,CAST('Dec 12 1776 12:38AM' AS date) AS 'Second Date'
	   ,CAST('Dec 12 1400 12:38AM' AS datetime) AS 'Third Date'
	   ,CAST('Number 3' AS int) AS 'Number 3';
GO





-- Here we are using TRY_CAST. Do you think it will work?
SELECT TRY_CAST('30 Dec 06' AS date) AS 'First Date'
	   ,TRY_CAST('Dec 12 1776 12:38AM' AS datetime) AS 'Second Date'
	   ,TRY_CAST('Dec 12 1400 12:38AM' AS datetime) AS 'Third Date'
	   ,TRY_CAST('Number 3' AS int) AS 'Number 3';
GO





-- Here we are using CONVERT. Do you think it will work?
SELECT CONVERT(date,'30 Dec 06',101) AS 'Date'
	   ,CONVERT(int, '00002A') AS 'Number';
GO





-- Here we are using TRY_CONVERT. What do you think the results will be?
SELECT TRY_CONVERT(date,'30 Dec 06',101) AS 'Date'
	   ,TRY_CONVERT(int, '00002A') AS 'Number';
GO





-- This statement will return an exception.
SELECT TRY_CONVERT(xml,123);
GO





-- Using CASE statement to handle the NULL.
SELECT CASE WHEN TRY_CONVERT(int, '00002B') IS NULL 
	THEN 99
	END AS Id;
GO