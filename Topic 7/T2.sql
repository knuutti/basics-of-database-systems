SELECT 
	-- Final select
	(SELECT (first_name||' '||last_name) FROM Player WHERE Player.playerid = FK_playerOne) AS "Player one",
	(SELECT (first_name||' '||last_name) FROM Player WHERE Player.playerid = FK_playerTwo) AS "Player two",
	matchdate AS "Matchdate",
	(SELECT (first_name||' '||last_name) FROM Player WHERE Player.playerid = winnerID) AS "Winner"
FROM 
	(SELECT
		matchid
	FROM Matches
	INNER JOIN (
		SELECT * FROM
			-- Selecting all matches in a way that the player with lower playerID is always the left side 
			(SELECT
				playerid as playerid1,
				CASE
				WHEN (Player.playerid == Matches.FK_playerTwo) THEN Matches.FK_playerOne
				ELSE Matches.FK_playerTwo
				END "playerid2"
			FROM Player
			INNER JOIN Matches ON Player.playerid = Matches.FK_playerOne OR Player.playerid = Matches.FK_playerTwo
			GROUP BY matchid)
		-- Grouping the rows where the player pairs are the same
		GROUP BY playerid1, playerid2
		-- Removing the pairs who only play once against each other
		HAVING COUNT(*) > 1) A
	ON (A.playerid1 = Matches.FK_playerOne AND A.playerid2 = Matches.FK_playerTwo) OR (A.playerid1 = Matches.FK_playerTwo AND A.playerid2 = Matches.FK_playerOne)) t
INNER JOIN Matches AS m ON m.matchid = t.matchid
ORDER BY Winner