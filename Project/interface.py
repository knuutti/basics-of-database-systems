import sqlite3
db = sqlite3.connect('speedrun.db')
cur = db.cursor()
def initializeDB():
    try:

        # Initialize database
        f = open("sqlcommands.sql", "r")
        commandstring = ""
        for line in f.readlines():
            commandstring+=line
        cur.executescript(commandstring)
        f.close()

        f = open("querys.sql", "r")
        commandstring = ""
        for line in f.readlines():
            commandstring+=line
        cur.executescript(commandstring)
        f.close()

    except sqlite3.OperationalError:
        print("Database exists, skip initialization")
    except:
        print("No SQL file to be used for initialization") 


def main():
    initializeDB()
    userInput = -1
    while(True):
        print("\nMenu options:")
        print("1: Print leaderboards")
        print("2: Print moderators")
        print("3: Print all the categories")
        print("4: Print all players for a game")
        print("5: Print all the games and their platforms")
        print("0: Quit")
        userInput = input("What do you want to do? ")
        print()
        if userInput == "1":
            printLeaderboard()
        elif userInput == "2":
            printModerators()
        elif userInput == "3":
            printCategories()
        elif userInput == "4":
            printPlayers()
        elif userInput == "5":
            printPlatforms()
        elif userInput == "0":
            print("Ending software...")
            break
        else:
            print("Invalid input")
    db.close()        
    return

def printTable():
    results = cur.fetchall()
    s = "| "
    for r in results:
        for node in r:
            s = s + str(node) + " | "
        s = s[:-2]
        s += "\n| "
    s= s[:-2]
    print(s)

def printCategories():
    try:
        print("Choose the game:")
        cur.execute("SELECT gameName FROM Game;")
        printTable()
        game = input("Your choise: ")
        script = f"""SELECT 
            categoryName AS "Category",
            COUNT(runID) AS "Runs"
        FROM (SELECT * FROM Run
        INNER JOIN Category ON Category.categoryID = Run.FK_categoryID) A
        INNER JOIN Game ON Game.gameID = A.FK_gameID WHERE Game.gameName = \"{game}\"
        GROUP BY categoryID
        ORDER BY "Runs" DESC;"""

        cur.execute(script)
        print(f"\n All categories and the number of runners for {game}\n-------------------------")
        printTable()
    except Exception:
        print("Something went wrong. Make sure to use the exact names for games.")

def printPlayers():
    try:
        print("Choose the game:")
        cur.execute("SELECT gameName FROM Game;")
        printTable()
        game = input("Your choise: ")

        script = f"""SELECT
            playerName AS "Player"
        FROM (SELECT 
            *
        FROM (SELECT * FROM(SELECT * FROM Run 
        INNER JOIN Category ON Category.categoryID = Run.FK_categoryID) A
        INNER JOIN Game ON Game.gameID = A.FK_gameID WHERE Game.gameName = \"{game}\") B
        INNER JOIN Perform ON B.runID = Perform.FK_runID) C
        INNER JOIN Player ON Player.playerID = C.FK_playerID
        GROUP BY "Player";"""

        cur.execute(script)
        print(f"\n All runners for {game}\n-------------------------")
        printTable()

    except Exception:
        print("Something went wrong. Make sure to use the exact names for games.")

def printModerators():
    try:
        print("Choose the game:")
        cur.execute("SELECT gameName FROM Game;")
        printTable()
        game = input("Your choise: ")
        script = f"""SELECT
            playerName AS "Moderator",
            role AS "Role"
        FROM (SELECT * FROM Moderator INNER JOIN Player ON Moderator.FK_playerID = Player.playerID) A
        INNER JOIN Game ON A.FK_gameID = Game.gameID WHERE Game.gameName = \"{game}\"
        ORDER BY Role DESC;"""

        cur.execute(script)
        print(f"\n All moderators for {game}\n-------------------------")
        printTable()

    except Exception:
        print("Something went wrong. Make sure to use the exact names for games.")

def printPlatforms():
    script = """SELECT
        gameName AS "Game",
        GROUP_CONCAT(platformName) AS "Platforms"
    FROM (SELECT * FROM Game
    INNER JOIN IsPlatformOf ON IsPlatformOf.FK_gameID = Game.gameID) A
    INNER JOIN Platform ON A.FK_platformID = Platform.platformID
    GROUP BY gameID;"""
    cur.execute(script)
    print("\n All games and platforms\n-------------------------")
    printTable()

def printLeaderboard():
    try:
        print("Choose the game:")
        cur.execute("SELECT gameName FROM Game;")
        printTable()
        game = input("Your choise: ")

        print("\nChoose category:")
        category_query = f"""
        SELECT categoryName FROM Category 
        INNER JOIN Game ON Category.FK_gameID = Game.gameID WHERE Game.gameName = \"{game}\""""
        cur.execute(category_query)
        printTable()
        category = input("Your choise: ")
        offset = int(input("\nHow many runs you want to see: "))

        script = f"""SELECT
            playerName AS "Player",
            runTime AS "Time"
        FROM (SELECT playerName,runTime,categoryName,FK_gameID FROM (SELECT * FROM (SELECT * FROM Player
        INNER JOIN Perform ON playerID = Perform.FK_playerID) A
        INNER JOIN Run ON Run.runID = A.FK_runID) B
        INNER JOIN Category ON B.FK_categoryID = Category.categoryID) C
        INNER JOIN Game ON C.FK_gameID = Game.gameID WHERE gameName = \"{game}\" AND categoryName = \"{category}\"
        ORDER BY runTime ASC
        LIMIT {offset};"""

        cur.execute(script)
        print(f"\nLeaderboard for {game} - {category}\n-------------------------")
        printTable()
    except Exception:
        print("Something went wrong. Make sure to use the exact names for game/category and use integer values for limit.")

main()