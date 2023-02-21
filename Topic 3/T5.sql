-- Using MAX() for defining a new playerid
INSERT INTO Player VALUES ((SELECT MAX(playerid) FROM Player)+1, 'Emil', 'Ruusuvuori', 'FIN', '02/04/1999');
INSERT INTO Ranking VALUES ((SELECT MAX(playerid) FROM Player), 0, (SELECT MAX(playerid) FROM Player), 
'W: 0 - L: 0', (SELECT MAX(playerid) FROM Player));