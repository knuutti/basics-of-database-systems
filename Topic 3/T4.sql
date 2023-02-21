-- Finding the new matchid and the rankids for the lowest and highest ranked players
INSERT INTO Matches VALUES (1+(SELECT matchid FROM Matches ORDER BY Matches.matchid DESC LIMIT 1),
(SELECT playerid FROM Player LEFT JOIN Ranking ON Player.playerid = Ranking.FK_playerid ORDER BY Ranking.rank ASC LIMIT 1), 
(SELECT playerid FROM Player LEFT JOIN Ranking ON Player.playerid = Ranking.FK_playerid ORDER BY Ranking.rank DESC LIMIT 1), 
'0-0', 'unplayed', 0);