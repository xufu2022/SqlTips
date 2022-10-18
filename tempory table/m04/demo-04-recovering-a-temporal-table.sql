/* demo-04-recovering-a-temporal-table */


DELETE PostsTemporal
	WHERE Tags LIKE '%scikit-learn%'


SELECT * FROM PostsTemporal
	WHERE Tags LIKE '%scikit-learn%'


INSERT INTO PostsTemporal 
	(Id,CreationDate,Score,ViewCount,Body,OwnerUserId,LastActivityDate,Title
	,Tags,AnswerCount,CommentCount,FavoriteCount)
	
	SELECT 
	Id,CreationDate,Score,ViewCount,Body,OwnerUserId,LastActivityDate,Title
	,Tags,AnswerCount,CommentCount,FavoriteCount
	FROM PostsTemporal FOR SYSTEM_TIME AS OF '2019-08-05 15:00:00.0'
	WHERE Tags LIKE '%scikit-learn%'


SELECT * FROM PostsTemporal
	WHERE Tags LIKE '%scikit-learn%'

