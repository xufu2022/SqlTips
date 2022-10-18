/* demo-02-modifying-data-in-temporal-tables */

INSERT PostsTemporal
	(Id, CreationDate,Score,ViewCount,Body,OwnerUserId,LastActivityDate,
	Title,Tags,AnswerCount,CommentCount,FavoriteCount)

SELECT 
	Id,
	JSON_VALUE(Post_json, '$.Post.CreationDate') AS CreationDate,
	JSON_VALUE(Post_json, '$.Post.Score') AS Score,
	JSON_VALUE(Post_json, '$.Post.ViewCount') AS ViewCount,
	JSON_VALUE(Post_json, '$.Post.Body') AS Body,
	JSON_VALUE(Post_json, '$.Post.OwnerUserId') AS OwnerUserId,
	JSON_VALUE(Post_json, '$.Post.LastActivityDate') AS LastActivityDate,
	JSON_VALUE(Post_json, '$.Post.Title') AS Title,
	JSON_VALUE(Post_json, '$.Post.Tags') AS Tags,
	JSON_VALUE(Post_json, '$.Post.AnswerCount') AS AnswerCount,
	JSON_VALUE(Post_json, '$.Post.CommentCount') AS CommentCount,
	JSON_VALUE(Post_json, '$.Post.FavoriteCount') AS FavoriteCount
FROM Posts
WHERE 
	JSON_VALUE(Post_json, '$.Post.Tags') LIKE '%python%' AND 
	JSON_VALUE(Post_json, '$.Post.Score') > 20 AND
	JSON_VALUE(Post_json, '$.Post.Body') IS NOT NULL;

SELECT * FROM PostsTemporal;
SELECT * FROM PostsHistory;


UPDATE PostsTemporal 
	SET Title = 'Estimating users age based on Facebook sites they like'
	WHERE Id = 116;

UPDATE PostsTemporal 
	SET Title = 'Which cost function is the best option for neural networks'
	WHERE Id = 9850;


SELECT * FROM PostsTemporal;
SELECT * FROM PostsHistory;


UPDATE PostsTemporal
	SET Score += 50
	WHERE Tags LIKE '%neural-network%' OR Tags LIKE '%deep-learning%';


SELECT * FROM PostsTemporal;
SELECT * FROM PostsHistory;


DELETE PostsTemporal 
	WHERE Score < 50;


SELECT * FROM PostsTemporal;
SELECT * FROM PostsHistory;