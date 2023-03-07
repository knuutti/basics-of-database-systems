-- SQL script for initializing the database

CREATE TABLE Player (
	playerID INTEGER NOT NULL PRIMARY KEY,
	playerName VARCHAR(50)
);

CREATE TABLE Game (
	gameID INTEGER NOT NULL PRIMARY KEY,
	gameName VARCHAR(50)
);

CREATE TABLE Category (
	categoryID INTEGER NOT NULL PRIMARY KEY,
	categoryName VARCHAR(50),
	FK_gameID INTEGER NOT NULL,
	FOREIGN KEY (FK_gameID) REFERENCES Game (gameID) ON DELETE CASCADE
);

CREATE TABLE Moderator (
	role CHAR(20),
	FK_gameID INTEGER NOT NULL,
	FK_playerID INTEGER NOT NULL,
	FOREIGN KEY (FK_gameID) REFERENCES Game (gameID) ON DELETE CASCADE,
	FOREIGN KEY (FK_playerID) REFERENCES Player (playerID) ON DELETE CASCADE
);

CREATE TABLE Run (
	runID INTEGER NOT NULL PRIMARY KEY,
	runTime REAL NOT NULL,
	runDate CHAR(20),
	runNotes VARCHAR(500),
	FK_categoryID INTEGER NOT NULL,
	FK_playerID INTEGER NOT NULL,
	FOREIGN KEY (FK_categoryID) REFERENCES Category (categoryID) ON DELETE CASCADE,
	FOREIGN KEY (FK_playerID) REFERENCES Player (playerID) ON DELETE CASCADE
);

CREATE TABLE Comment (
	commentID INTEGER NOT NULL PRIMARY KEY,
	content VARCHAR(500),
	FK_runID INTEGER NOT NULL,
	FK_playerID INTEGER NOT NULL,
	FK_commentID INTEGER,
	FOREIGN KEY (FK_runID) REFERENCES Run (runID) ON DELETE CASCADE,
	FOREIGN KEY (FK_playerID) REFERENCES Player (playerID) ON DELETE CASCADE,
	FOREIGN KEY (FK_commentID) REFERENCES Comment (commentID) ON DELETE CASCADE
);

CREATE TABLE Perform (
	FK_runID INTEGER NOT NULL,
	FK_playerID INTEGER NOT NULL,
	FOREIGN KEY (FK_runID) REFERENCES Run (runID) ON DELETE CASCADE,
	FOREIGN KEY (FK_playerID) REFERENCES Player (playerID) ON DELETE CASCADE
);