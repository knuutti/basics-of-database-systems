-- At this point I should probably start commenting the code...
CREATE VIEW Tweets_and_tags AS
SELECT 
	Username as User,
	Content as Tweet,
	Hashtag
FROM 
(SELECT 
	UserID AS FK_UserID,
	Content,
	GROUP_CONCAT(Hashtag_Content, '') AS Hashtag
FROM 
	(SELECT
		TweetID as FK_TweetID,
		Content as Hashtag_Content
	FROM
		HashtagsInContent
	INNER JOIN
		Hashtag
	WHERE
		HashtagsInContent.HashtagID = Hashtag.HashtagID
	)
INNER JOIN
	Tweet
WHERE
	Tweet.TweetID = FK_TweetID
GROUP BY TweetID)
INNER JOIN
	User
WHERE
	User.UserID = FK_UserID
ORDER BY
    User


