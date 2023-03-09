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
        print("1: Print leaderboards for Sly 3 Any%")
        print("2: Print moderators for Sly 3")
        print("3: Print all the categories")
        print("4: Print all players who have done Sly 2 run")
        print("5: Print all the games and their platforms")
        print("0: Quit")
        userInput = input("What do you want to do? ")
        print()
        if userInput == "1":
            cur.execute("SELECT * FROM LeaderboardView;")
            printTable()
        elif userInput == "2":
            cur.execute("SELECT * FROM ModeratorView;")
            printTable()
        elif userInput == "3":
            cur.execute("SELECT * FROM CategoryView;")
            printTable()
        elif userInput == "4":
            cur.execute("SELECT * FROM PlayerView;")
            printTable()
        elif userInput == "5":
            cur.execute("SELECT * FROM PlatformView;")
            printTable()
        elif userInput == "0":
            print("Ending software...")
            break
        else:
            print("Invalid input")
    db.close()        
    return

def printTable():
    results = cur.fetchall()
    for r in results:
        print(r)

main()