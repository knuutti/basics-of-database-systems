#
#   BUILDING THE SQLCOMMANDS.SQL FILE
#

from urllib.request import urlopen
import json

# Defining which games we want to include in the database
# speedrun.com uses 8-characters long ID values for each game
games = ["nd2egvd0", "4d79zg17", "9d3rkgdl", "o1y9526q", "m1mxemj6"]

# CREATE TABLE COMMANDS

sql_file_name = "sqlcommands.sql"
sql_file = open(sql_file_name,'w',encoding="utf-8")

initialize = open("initialize.sql", "r")
r = initialize.read()
for row in r:
    sql_file.write(row)
initialize.close()


# PLATFORM
platform_query = "\n\nINSERT INTO Platform VALUES"
url = "https://www.speedrun.com/api/v1/platforms?max=200"
response = urlopen(url)
data_json = json.loads(response.read())
platforms_json = data_json.get("data")
platforms = []
for p_json in platforms_json:
    platform_id = p_json.get("id")
    platform_name = p_json.get("name")
    platforms.append(f"(\"{platform_id}\",\"{platform_name}\")")

# SQL query for Platform
platform_query = "\n\nINSERT INTO Platform VALUES"
for value in platforms:
    platform_query += "\n\t" + value + ","
platform_query = platform_query[:-1]
platform_query += ";\n"
sql_file.write(platform_query)
platform_query = ""


game_values = []
game_platforms = []
for game in games:
    url = "https://www.speedrun.com/api/v1/games/" + game
    response = urlopen(url)
    data_json = json.loads(response.read())
    game_name = data_json.get("data").get("names").get("international")
    game_platforms_json = data_json.get("data").get("platforms")
    s = ""
    for game_platform in game_platforms_json:
        game_platforms.append(f"(\"{game_platform}\",\"{game}\")")
    game_plats = s[:-1]
    game_values.append(f"(\"{game}\",\"{game_name}\")")

# SQL query for GAME
game_query = "\n\nINSERT INTO Game VALUES"
for value in game_values:
    game_query += "\n\t" + value + ","
game_query = game_query[:-1]
game_query += ";\n"
sql_file.write(game_query)
game_query = ""

# SQL query for ISPLATFORMOF
game_platform_query = "\n\nINSERT INTO IsPlatformOf VALUES"
for value in game_platforms:
    game_platform_query += "\n\t" + value + ","
game_platform_query = game_platform_query[:-1]
game_platform_query += ";\n"
sql_file.write(game_platform_query)
game_platform_query = ""



perform = []
category_values = []
player_dictionary = {}
run_values = []
for game in games:
    url = "https://www.speedrun.com/api/v1/games/" + game + "/categories"
    response = urlopen(url)
    data_json = json.loads(response.read())
    for category in data_json.get("data"):
        if category.get("type") != "per-level":
            category_id = category.get("id")
            category_name = category.get("name")
            category_values.append(f"(\"{category_id}\",\"{category_name}\",\"{game}\")")

            # Reading all the runs of a category
            run_url = "https://www.speedrun.com/api/v1/leaderboards/" + game + "/category/" + category_id + "?embed=players"
            run_response = urlopen(run_url)
            run_json = json.loads(run_response.read())
            runs = run_json.get("data").get("runs")
            players = run_json.get("data").get("players").get("data")
            for i,r in enumerate(runs):
                run = r.get("run")
                run_id = run.get("id")

                run_date = run.get("date")
                if not run_date:
                    run_date = "null"
                else:
                    run_date = "\"" + run_date + "\""

                player = players[i]
                if player.get("rel") == "guest":
                    continue
                player_id = player.get("id")
                perform.append(f"(\"{run_id}\",\"{player_id}\")")
                player_name = player.get("names").get("international")
                player_dictionary[player_id] = player_name

                run_time = run.get("times").get("primary_t")
                run_values.append(f"(\"{run_id}\",{run_time},{run_date},\"{category_id}\",\"{player_id}\")")


# SQL query for categories
category_query = "\nINSERT INTO Category VALUES"
for value in category_values:
    category_query += "\n\t" + value + ","
category_query = category_query[:-1]
category_query += ";\n"
sql_file.write(category_query)
category_query = ""



# MODERATORS

moderator_values = []
for game in games:
    url = "https://www.speedrun.com/api/v1/games/" + game
    response = urlopen(url)
    data_json = json.loads(response.read())
    moderators = data_json.get("data").get("moderators")
    for moderator in moderators:
        moderator_role = moderators[moderator]
        moderator_values.append(f"(\"{moderator_role}\",\"{game}\",\"{moderator}\")")




# PLAYERS
player_values = []
for player in player_dictionary:
    player_values.append(f"(\"{player}\",\"{player_dictionary[player]}\")")

# SQL query
player_query = "\nINSERT INTO Player VALUES"
for value in player_values:
    player_query += "\n\t" + value + ","
player_query = player_query[:-1]
player_query += ";\n"
sql_file.write(player_query)
player_query = ""

# SQL query for runs
run_query = "\nINSERT INTO Run VALUES"
for value in run_values:
    run_query += "\n\t" + value + ","
run_query = run_query[:-1]
run_query += ";\n"
sql_file.write(run_query)
run_query = ""


## PERFORM
perform_query = "\nINSERT INTO Perform VALUES"
for value in perform:
    perform_query += "\n\t" + value + ","
perform_query = perform_query[:-1]
perform_query += ";\n"
sql_file.write(perform_query)
perform_query = ""

# SQL query for moderators
moderator_query = "\nINSERT INTO Moderator VALUES"
for value in moderator_values:
    moderator_query += "\n\t" + value + ","
moderator_query = moderator_query[:-1]
moderator_query += ";\n"
sql_file.write(moderator_query)
moderator_query = ""

sql_file.close()
