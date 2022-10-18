/* demo-01-creating-temporal-tables */

CREATE TABLE PostsTemporal (
	Id INT NOT NULL PRIMARY KEY CLUSTERED,
	CreationDate DATETIME NOT NULL DEFAULT GETDATE(),
	Score INT NOT NULL DEFAULT 0,
	ViewCount INT,
	Body VARCHAR(MAX) NOT NULL,
	OwnerUserId INT,
	LastActivityDate DATETIME NOT NULL DEFAULT GETDATE(),
	Title VARCHAR(500),
	Tags VARCHAR(255),
	AnswerCount INT,
	CommentCount INT,
	FavoriteCount INT,
	SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL, 
	SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime)
)
WITH    
   (   
      SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.PostsHistory)   
   )
;