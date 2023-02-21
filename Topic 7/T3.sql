SELECT
	(SELECT (first_name||' '||last_name) FROM Player WHERE Player.playerid = winnerID) AS "Winner name",
	(SELECT rank FROM Ranking WHERE Ranking.FK_playerid = winnerID) AS "Winner rank",
	(SELECT (first_name||' '||last_name) FROM Player WHERE Player.playerid = loserID) AS "Loser name",
	(SELECT rank FROM Ranking WHERE Ranking.FK_playerid = loserID) AS "Loser rank",
	matchdate AS "Matchdate"
FROM
	(SELECT 
		playerid AS "loserID", rankingid 
	FROM
		Player
	INNER JOIN Ranking ON Player.playerid = Ranking.FK_playerid WHERE rank < 6)
INNER JOIN Matches ON (FK_playerOne = loserID OR FK_playerTwo = loserID) AND winnerID <> loserID
ORDER BY "Winner rank"