--
-- This SQL script implements sample queries on the Monopoly database.
--
-- @author kvlinden
-- @version Summer, 2015
--

-- Get the number of Game records.
SELECT *
  FROM Game
  ;

-- Get the player records.
SELECT * 
  FROM Player
  ;

-- Get all the users with Calvin email addresses.
SELECT *
  FROM Player
 WHERE email LIKE '%calvin%'
 ;

-- Get the highest score ever recorded.
SELECT score FROM PlayerGame ORDER BY score DESC LIMIT 1;

-- Get the cross-product of all the tables.
SELECT * FROM Player, PlayerGame, Game;


-- Get all the Players and their scores
SELECT Player.name, playergame.playerid, playergame.score
FROM Player
JOIN playergame ON Player.id = playergame.playerid
JOIN Game ON playergame.gameid = Game.id
 ORDER BY playergame.score DESC;