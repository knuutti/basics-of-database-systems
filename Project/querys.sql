-- View 1
-- This view prints all the runs of a spesific category (Any%, Sly 3) forming a proper leaderboard
CREATE VIEW "LeaderboardView" AS
SELECT
	playerName AS "Player",
	runTime AS "Time"
FROM (SELECT playerName,runTime,categoryName,FK_gameID FROM (SELECT * FROM Player
INNER JOIN Run ON playerID = Run.FK_playerID) A
INNER JOIN Category ON A.FK_categoryID = Category.categoryID) B
INNER JOIN Game ON B.FK_gameID = Game.gameID WHERE gameName = "Sly 3: Honor Among Thieves" AND categoryName = "Any%"
ORDER BY runTime ASC;

-- View 2
-- This view prints all the moderators of a spesific game (Slyfecta) and their roles
CREATE VIEW "ModeratorView" AS
SELECT
	playerName AS "Moderator",
	role AS "Role"
FROM (SELECT * FROM Moderator INNER JOIN Player ON Moderator.FK_playerID = Player.playerID) A
INNER JOIN Game ON A.FK_gameID = Game.gameID WHERE Game.gameName = "Slyfecta"
ORDER BY Role DESC;

-- View 3
-- This view prints all the categories in the database ordering them by the number of runs
CREATE VIEW "CategoryView" AS
SELECT 
	gameName AS "Game",
	categoryName AS "Category",
	COUNT(runID) AS "Runs"
FROM (SELECT * FROM Run
INNER JOIN Category ON Category.categoryID = Run.FK_categoryID) A
INNER JOIN Game ON Game.gameID = A.FK_gameID
GROUP BY categoryID
ORDER BY "Runs" DESC;

-- View 4
-- This view prints all the players who have done a run for a spesific game (Sly 2)
CREATE VIEW "PlayerView" AS
SELECT
	playerName AS "Player"
FROM (SELECT 
	*
FROM (SELECT * FROM Run 
INNER JOIN Category ON Category.categoryID = Run.FK_categoryID) A
INNER JOIN Game ON Game.gameID = A.FK_gameID WHERE Game.gameName = "Sly 2: Band of Thieves"
GROUP BY FK_playerID) B
INNER JOIN Player ON Player.playerID = B.FK_playerID;

-- View 5
-- This view prints all the games with all of their platforms in one column
CREATE VIEW "PlatformView" AS
SELECT
	gameName AS "Game",
	GROUP_CONCAT(platformName) AS "Platforms"
FROM (SELECT * FROM Game
INNER JOIN IsPlatformOf ON IsPlatformOf.FK_gameID = Game.gameID) A
INNER JOIN Platform ON A.FK_platformID = Platform.platformID
GROUP BY gameID;