CREATE INDEX PlayerIndex ON Player(playerid);
CREATE INDEX RankingIndex ON Ranking(FK_playerid);
CREATE INDEX PlayerOneIndex ON Matches(FK_playerOne);
CREATE INDEX PlayerTwoIndex ON Matches(FK_playerTwo);
CREATE INDEX WinnerIndex ON Matches(winnerID);

SELECT * FROM Player 
	INNER JOIN Ranking ON Player.playerid = Ranking.FK_playerid
	WHERE (SELECT COUNT (*) FROM Matches 
		WHERE (Player.playerid = Matches.FK_playerOne OR Player.playerid = Matches.FK_playerTwo) )/2 = 
		(SELECT COUNT (*) FROM Matches WHERE (Player.playerid = Matches.winnerID));
		