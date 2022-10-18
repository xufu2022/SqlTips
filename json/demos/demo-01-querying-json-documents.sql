/* demo-01-querying-json-documents */

SELECT 
	JSON_VALUE(Post_json, '$.Post.Id') AS jsonId,
	JSON_VALUE(Post_json, '$.Post.Title') AS jsonTitle,
	JSON_QUERY(Post_json, '$.Post.Author') AS jsonAuthor,
	JSON_VALUE(Post_json, '$.Post.Comments[0].Comment.Text') AS jsonSecondComment
FROM Posts
WHERE
	JSON_VALUE(Post_json, '$.Post.Title') = 'Python vs R for machine learning';