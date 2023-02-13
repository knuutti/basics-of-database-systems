-- Got idea from Joona Lappalainen to use WHERE for getting the highest ranked players
SELECT * FROM Player
INNER JOIN Ranking ON Player.playerid = Ranking.FK_playerid
WHERE Ranking.rank < 11
ORDER BY playerid ASC;