-- SQLite
CREATE TRIGGER hashtag_not_allowed
AFTER INSERT ON Hashtag
BEGIN  
   SELECT RAISE(ABORT, 'Mayonnaise detected!');
END