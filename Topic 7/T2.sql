SELECT 
	(SELECT (first_name||' '||last_name) FROM Player WHERE Player.playerid = FK_playerOne) AS "Player one",
	(SELECT (first_name||' '||last_name) FROM Player WHERE Player.playerid = FK_playerTwo) AS "Player two",
	matchdate,
	(SELECT (first_name||' '||last_name) FROM Player WHERE Player.playerid = winnerID) AS "Winner"
FROM (SELECT
	matchid
FROM Matches
INNER JOIN (
	SELECT * FROM
	(SELECT
		playerid as playerid1,
		CASE
		WHEN (Player.playerid == Matches.FK_playerTwo) THEN Matches.FK_playerOne
		ELSE Matches.FK_playerTwo
		END "playerid2"
	FROM Player
	INNER JOIN Matches ON Player.playerid = Matches.FK_playerOne OR Player.playerid = Matches.FK_playerTwo
	group by matchid)
	group by playerid1, playerid2
	having count(*) > 1) A
ON (A.playerid1 = Matches.FK_playerOne AND A.playerid2 = Matches.FK_playerTwo) OR (A.playerid1 = Matches.FK_playerTwo AND A.playerid2 = Matches.FK_playerOne)) t
INNER JOIN Matches AS m ON m.matchid = t.matchid
ORDER BY Winner