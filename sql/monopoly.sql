-- This SQL script builds a monopoly database, deleting any pre-existing version.
--
-- @author kvlinden
-- Editor: Ivan Widjanarko
-- @version Summer, 2015
--

-- Drop previous versions of the tables if they exist, in reverse order of foreign keys.
DROP TABLE IF EXISTS PlayerProperty;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS PlayerGame;
DROP TABLE IF EXISTS Game;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Board;

-- Create the schema.
CREATE TABLE Game (
    ID integer PRIMARY KEY,         
    time timestamp                  
);

CREATE TABLE Player (
    ID integer PRIMARY KEY,          
    emailAddress varchar(50) NOT NULL, 
    name varchar(50)                 
);

CREATE TABLE PlayerGame (
    gameID integer REFERENCES Game(ID),   
    playerID integer REFERENCES Player(ID), 
    score integer                          
);

CREATE TABLE Property (
    ID integer PRIMARY KEY,             
    name varchar(50) NOT NULL,           
    value integer NOT NULL,              
    ownerID integer REFERENCES Player(ID)  
);

CREATE TABLE Board (
    ID integer PRIMARY KEY,             
    name varchar(50) NOT NULL            
);

CREATE TABLE PlayerProperty (
    playerID integer REFERENCES Player(ID), 
    propertyID integer REFERENCES Property(ID), 
    PRIMARY KEY (playerID, propertyID)   
);

-- Allow users to select data from the tables.
GRANT SELECT ON Game TO PUBLIC;
GRANT SELECT ON Player TO PUBLIC;
GRANT SELECT ON PlayerGame TO PUBLIC;
GRANT SELECT ON Property TO PUBLIC;
GRANT SELECT ON Board TO PUBLIC;
GRANT SELECT ON PlayerProperty TO PUBLIC;

-- Added sample records for Game.
INSERT INTO Game VALUES (1, '2006-06-27 08:00:00');  -- Game ID 1 on this date
INSERT INTO Game VALUES (2, '2006-06-28 13:20:00');  -- Game ID 2 on this date
INSERT INTO Game VALUES (3, '2006-06-29 18:41:00');  -- Game ID 3 on this date
INSERT INTO Game VALUES (4, '2006-06-30 20:38:00');  -- Game ID 4 on this date
INSERT INTO Game VALUES (5, '2024-10-31 21:20:02');  -- Game ID 5 on this date

-- Add sample records for Player.
INSERT INTO Player VALUES (1, 'me@calvin.edu', 'Me');  -- Player 1
INSERT INTO Player VALUES (2, 'king@gmail.edu', 'The King');  -- Player 2
INSERT INTO Player VALUES (3, 'dog@gmail.edu', 'Dogbreath');  -- Player 3
INSERT INTO Player VALUES (4, 'iw3@gmail.edu', 'Ivan Widjanarko');  -- Player 4
INSERT INTO Player VALUES (5, 'null@calvin.edu', NULL);  -- Player 5


-- Add sample records for PlayerGame.
INSERT INTO PlayerGame VALUES (1, 1, 0.00);  -- Player 1 in Game 1 with score 0
INSERT INTO PlayerGame VALUES (2, 1, 1500.00);  -- Player 1 in Game 2 with score 1500
INSERT INTO PlayerGame VALUES (3, 1, 2350.00);  -- Player 1 in Game 3 with score 2350
INSERT INTO PlayerGame VALUES (1, 2, 1000.00);  -- Player 2 in Game 1 with score 1000
INSERT INTO PlayerGame VALUES (2, 2, 0.00);  -- Player 2 in Game 2 with score 0
INSERT INTO PlayerGame VALUES (3, 2, 500.00);  -- Player 2 in Game 3 with score 500
INSERT INTO PlayerGame VALUES (2, 3, 300.00);  -- Player 3 in Game 2 with score 300
INSERT INTO PlayerGame VALUES (3, 3, 5500.00);  -- Player 3 in Game 3 with score 5500
INSERT INTO PlayerGame VALUES (4, 4, 3000.00);  -- Player 4 in Game 4 with score 3000


-- Add sample records for Property.
INSERT INTO Property VALUES (1, 'Park Place', 350, NULL);  -- Property ID 1, value 350
INSERT INTO Property VALUES (2, 'Boardwalk', 400, NULL);  -- Property ID 2, value 400
INSERT INTO Property VALUES (3, 'Marvin Gardens', 200, NULL);  -- Property ID 3, value 200
INSERT INTO Property VALUES (4, 'Ventnor Avenue', 300, NULL);  -- Property ID 4, value 300

-- Add sample records for Board.
INSERT INTO Board VALUES (1, 'Classic Monopoly Board');  -- Board ID 1

-- Add sample records for PlayerProperty.
INSERT INTO PlayerProperty VALUES (1, 1);  -- Player 1 owns Park Place
INSERT INTO PlayerProperty VALUES (2, 2);  -- Player 2 owns Boardwalk
INSERT INTO PlayerProperty VALUES (1, 3);  -- Player 1 owns Marvin Gardens
INSERT INTO PlayerProperty VALUES (3, 4);  -- Player 3 owns Ventnor Avenue


-- Exercise 8.1

-- 1. Retrieve a list of all the games, ordered by date with the most recent game coming first.
-- SELECT * FROM game ORDER BY game.time DESC;

-- 2. Retrieve all the games that occurred in the past week.
-- SELECT * FROM game WHERE game.time >= CURRENT_DATE - INTERVAL '7 days';

-- 3. Retrieve a list of players who have (non-NULL) names.
-- SELECT * FROM player WHERE player.name IS NOT NULL

-- 4. Retrieve a list of IDs for players who have some game score larger than 2000.
-- SELECT playerid FROM playergame WHERE playergame.score > 2000;

-- 5. Retrieve a list of players who have GMail accounts.
-- SELECT * FROM player WHERE player.emailaddress LIKE '%@gmail.edu%';


-- Exercise 8.2

-- 1. Retrieve all “The King”’s game scores in decreasing order.
-- SELECT playergame.score FROM player, playergame WHERE player.id = playergame.playerid AND player.name LIKE '%The King%' ORDER BY playergame.score DESC;

-- 2. Retrieve the name of the winner of the game played on 2006-06-28 13:20:00.
--  SELECT player.name FROM game, playergame, player WHERE playergame.gameid = game.id AND playergame.playerid = player.id AND game.time = '2006-06-28 13:20:00' ORDER BY playergame.score LIMIT 1;

-- 3. So what does that P1.ID < P2.ID clause do in the last example query (i.e., the from SQL Examples)?
--SELECT P1.name
--FROM Player AS P1, Player AS P2
--WHERE P1.name = P2.name
  --AND P1.ID < P2.ID;

-- the clause P1.ID < P2.ID is used to find and eliminate duplicate pairs by only selecting one instance of each unique name combination where a player name appears more than once in the Player table. 

-- 4. The query that joined the Player table to itself seems rather contrived. Can you think of a realistic situation in which you’d want to join a table to itself?
-- SELECT P1.name FROM Player AS P1 LEFT JOIN Player AS P2 ON P1.name = P2.name AND P1.ID < P2.ID WHERE P2.ID IS NOT NULL;

-- This query efficiently identifies players who share the same name in the Player table 
-- using a self-join, ensuring that only unique pairs are considered by the condition P1.ID < P2.ID. 
-- The LEFT JOIN method maintains data integrity by allowing all entries in P1 to be considered, 
-- but ultimately filters the results to return only those names with duplicates. 
-- This approach avoids redundancy while accurately reflecting the relationships within the dataset.






