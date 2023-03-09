-- View 1
CREATE VIEW "LeaderboardView" AS
SELECT
	playerName AS "Player",
	runTime AS "Time"
FROM (SELECT playerName,runTime,categoryName,FK_gameID FROM (SELECT * FROM (SELECT * FROM Player
INNER JOIN Perform ON playerID = Perform.FK_playerID) A
INNER JOIN Run ON Run.runID = A.FK_runID) B
INNER JOIN Category ON B.FK_categoryID = Category.categoryID) C
INNER JOIN Game ON C.FK_gameID = Game.gameID WHERE gameName = "Ratchet & Clank: Up Your Arsenal" AND categoryName = "NG+ No QE"
ORDER BY runTime ASC
LIMIT 10;

-- View 2
CREATE VIEW "ModeratorView" AS
SELECT
	playerName AS "Moderator",
	role AS "Role"
FROM (SELECT * FROM Moderator INNER JOIN Player ON Moderator.FK_playerID = Player.playerID) A
INNER JOIN Game ON A.FK_gameID = Game.gameID WHERE Game.gameName = "Ratchet & Clank"
ORDER BY Role DESC;

-- View 3
CREATE VIEW "CategoryView" AS
SELECT 
	categoryName AS "Category",
	COUNT(runID) AS "Runs"
FROM (SELECT * FROM Run
INNER JOIN Category ON Category.categoryID = Run.FK_categoryID) A
INNER JOIN Game ON Game.gameID = A.FK_gameID WHERE Game.gameName = "Sly 3: Honor Among Thieves"
GROUP BY categoryID
ORDER BY "Runs" DESC;

-- View 4
CREATE VIEW "PlayerView" AS
SELECT
	playerName AS "Player"
FROM (SELECT 
	*
FROM (SELECT * FROM(SELECT * FROM Run 
INNER JOIN Category ON Category.categoryID = Run.FK_categoryID) A
INNER JOIN Game ON Game.gameID = A.FK_gameID WHERE Game.gameName = "Sly 2: Band of Thieves") B
INNER JOIN Perform ON B.runID = Perform.FK_runID) C
INNER JOIN Player ON Player.playerID = C.FK_playerID
GROUP BY "Player";

-- View 5
CREATE VIEW "PlatformView" AS
SELECT
	gameName AS "Game",
	GROUP_CONCAT(platformName) AS "Platforms"
FROM (SELECT * FROM Game
INNER JOIN IsPlatformOf ON IsPlatformOf.FK_gameID = Game.gameID) A
INNER JOIN Platform ON A.FK_platformID = Platform.platformID
GROUP BY gameID;