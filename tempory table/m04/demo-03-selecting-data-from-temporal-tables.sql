/* demo-03-selecting-data-from-temporal-tables */

SELECT * FROM PostsTemporal  
FOR SYSTEM_TIME AS OF '2019-08-03 17:22:23.2292675' 
WHERE Id=9850


SELECT * FROM PostsTemporal
FOR SYSTEM_TIME BETWEEN '2019-08-03 17:00:00.0000000' AND '2019-08-03 18:00:00.0000000';


SELECT * FROM PostsTemporal
FOR SYSTEM_TIME ALL
WHERE Id = 9850
ORDER BY Id, SysEndTime 