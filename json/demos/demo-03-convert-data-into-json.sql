/* demo-03-convert-data-into-json */

SELECT 
	Users.DisplayName,
	Users.Reputation,
	JSON_VALUE(Post_json, '$.Post.Title') AS PostTitle
FROM Users
	JOIN Posts ON Users.Id = JSON_VALUE(Post_json, '$.Post.OwnerUserId')
WHERE Users.Reputation > 8000 AND JSON_VALUE(Post_json, '$.Post.Title') IS NOT NULL 
FOR JSON AUTO
