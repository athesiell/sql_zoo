/* 
game
id	mdate	stadium	team1	team2
1001	8 June 2012	National Stadium, Warsaw	POL	GRE
1002	8 June 2012	Stadion Miejski (Wroclaw)	RUS	CZE
1003	12 June 2012	Stadion Miejski (Wroclaw)	GRE	CZE
1004	12 June 2012	National Stadium, Warsaw	POL	RUS
...

goal
matchid	teamid	player	gtime
1001	POL	Robert Lewandowski	17
1001	GRE	Dimitris Salpingidis	51
1002	RUS	Alan Dzagoev	15
1002	RUS	Roman Pavlyuchenko	82
...

eteam
id	teamname	coach
POL	Poland	Franciszek Smuda
RUS	Russia	Dick Advocaat
CZE	Czech Republic	Michal Bilek
GRE	Greece	Fernando Santos
...
*/

-- 1. Modify it to show the matchid and player name for all goals scored by Germany. 

SELECT matchid, player 
  FROM goal
 WHERE teamid = 'GER';

-- 2. Show id, stadium, team1, team2 for just game 1012

SELECT id, stadium, team1, team2 
  FROM game
 WHERE game.id = 1012;

-- 3. Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT player, teamid, stadium, mdate 
  FROM game
        JOIN goal
        ON game.id = goal.matchid
 WHERE teamid = 'GER';

-- 4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

SELECT team1, team2, player 
  FROM game
        JOIN goal
        ON game.id = goal.matchid
 WHERE player LIKE 'Mario%';

-- 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime 
  FROM goal
        JOIN eteam 
        ON teamid = id;

-- 6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

SELECT mdate, teamname 
  FROM game
        JOIN eteam 
        ON game.team1 = eteam.id
 WHERE coach = 'Fernando Santos';

-- 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT player 
  FROM goal
        JOIN game 
        ON goal.matchid = game.id
 WHERE stadium = 'National Stadium, Warsaw';

-- 8. Show the name of all players who scored a goal against Germany.

SELECT DISTINCT player 
  FROM goal
        JOIN game 
        ON goal.matchid = game.id
 WHERE teamid != 'GER' AND (team1 = 'GER' OR team2 = 'GER');

-- 9. Show teamname and the total number of goals scored.

SELECT teamname, COUNT(teamid) 
  FROM eteam
        JOIN goal
        ON eteam.id = goal.teamid
 GROUP BY teamname;

-- 10. Show the stadium and the number of goals scored in each stadium.

SELECT stadium, COUNT(teamid) 
  FROM game
        JOIN goal
        ON game.id = goal.matchid
 GROUP BY stadium;

-- 11. For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT matchid, mdate, COUNT(teamid) 
  FROM game
        JOIN goal 
        ON game.id = goal.matchid 
 WHERE (team1 = 'POL' OR team2 = 'POL')
 GROUP BY matchid;

-- 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT matchid, mdate, COUNT(teamid) 
  FROM game
        JOIN goal 
        ON game.id = goal.matchid
 WHERE teamid = 'GER'
 GROUP BY matchid;

/* 13. List every match with the goals scored by each team as shown.
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
...
*/ 

SELECT game.mdate, game.team1,
 SUM(CASE WHEN goal.teamid = game.team1 THEN 1 ELSE 0 END) AS score1,
 game.team2,
 SUM(CASE WHEN goal.teamid = game.team2 THEN 1 ELSE 0 END) AS score 2
  FROM game
        LEFT JOIN goal 
        ON game.id = goal.matchid
 GROUP BY game.id, game.mdate, game.team1, game.team2
 ORDER BY mdate, matchid, team1, team2;