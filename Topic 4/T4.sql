CREATE VIEW Comments_of_comments AS
SELECT Username as User, Content as Comment, FK_CommentID as "Commented on" FROM 
(SELECT * FROM (SELECT * FROM Comments WHERE FK_CommentID IS NOT NULL) t
INNER JOIN User ON t.UserID = User.UserID) ORDER BY Username;
