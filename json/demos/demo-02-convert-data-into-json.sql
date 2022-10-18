/* demo-02-convert-data-into-json */

SELECT 
	Comments.Text AS [Comment.Content],
	Users.DisplayName AS [Comment.Author.Name],
	Users.LastAccessDate AS [Comment.Author.LastAccess],
	JSON_VALUE(Post_json, '$.Post.Title') AS [Comment.Post]
FROM Comments
	JOIN Users ON Users.Id = Comments.UserId
	JOIN Posts ON JSON_VALUE(Post_json, '$.Post.Id') = Comments.PostId
WHERE Comments.Score > 15 AND JSON_VALUE(Post_json, '$.Post.Title') IS NOT NULL 
FOR JSON PATH, ROOT ('Comments')
