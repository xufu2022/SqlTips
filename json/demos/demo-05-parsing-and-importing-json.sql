/* demo-05-parsing-and-importing-json */

DECLARE @JSONFILE VARCHAR (MAX);

SET @JSONFILE = N'[
   {
      "Id":6107,
      "Score":176,
      "ViewCount":155988,
      "Title":"What are deconvolutional layers?",
      "OwnerUserId":8820
   },
   {
      "Id":155,
      "Score":164,
      "ViewCount":25822,
      "Title":"Publicly Available Datasets",
      "OwnerUserId":227
   }
]'; 

SELECT * FROM OPENJSON (@JSONFILE) WITH (
	Id INT, 
	Score INT, 
	ViewCount INT,
	Title VARCHAR(255),
	OwnerUserId INT
) AS TopPosts