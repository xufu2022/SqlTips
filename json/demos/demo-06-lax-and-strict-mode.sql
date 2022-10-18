/* demo-06-lax-and-strict-mode */

SELECT TOP (10)
	JSON_VALUE(Post_json, '$.Post.Id'),
	JSON_VALUE(Post_json, '$.Post.Title'),
	JSON_VALUE(Post_json, 'strict$.Post.Badges')

FROM Posts
WHERE
	JSON_VALUE(Post_json, '$.Post.Title') LIKE '%python%';


SELECT TOP (10)
	JSON_VALUE(Post_json, 'strict$.Post.Id'),
	JSON_VALUE(Post_json, '$.Post.Title'),
	JSON_VALUE(Post_json, 'lax$.Post.Comments')

FROM Posts
WHERE
	JSON_VALUE(Post_json, '$.Post.Title') LIKE '%python%';