/** Name: Esther Koffi
Lab 104
9/16/2025 
**/



/**1) CREATE TABLE**/
CREATE TABLE BBalls_Stats
(  PlayerID        INT             NULL
  ,PlayerName      VARCHAR(50)     NULL
  ,PLayerNum       INT             NULL
  ,PlayerPosition  VARCHAR(50)     NULL
  ,Assist          INT             NULL
  ,Rebounds        INT             NULL
  ,GamesPlayed     INT             NULL
  ,Points          INT             NULL
  ,PlayersCoach    VARCHAR(50)     NULL );

  INSERT INTO BBALLS_STATS(PLAYERID, PLAYERNAME,PLAYERNUM,PLAYERPOSITION,ASSIST,REBOUNDS,GAMESPLAYED,POINTS,PLAYERSCOACH)
select 1,'ali',20,'guard',125,80,10,60,'thompson' union
select 2,'james',22,'forward',65,100,10,65,'garret' union
SELECT 3,'ralph',24, 'center',30 ,120,9,70,'samson' union
   SELECT 4,'terry',30,'guard',145,90,9,75,'garret' union
   SELECT 5,'dirk',32,'forward',70,110,10,80,'thompson'union
   SELECT 6,'alex',34,'center',35 ,130,10,90,'garret' union
   SELECT 7,'nina',40,'guard',155 ,100,9,100 ,' samson'union
   SELECT 8,'krystal',42,'forward',75,100,9,95,'thompson' union
   SELECT 9,'bud',44, 'center',40,125,10,90,'thompson' union
   SELECT 10,'tiger',50, 'guard',160,90,10,85,'samson' union
   SELECT 11,'troy',52, 'forward',80,125,10,80,'samson' union
   SELECT 12,'anand',54, 'center',50,145,10,110,'samson' union
   SELECT 13,'kishan',60, 'guard',120,150,9,115,'samson' union
   SELECT 14,'spock',62, 'forward',85,105,8,120,'thompson' union
SELECT 15,'cory',64, 'center',55,175,10,135,'samson'


/**3.	 Questions**/

/**a.	Find the Number of Players at each Position**/
SELECT PlayerPosition, Count (*)PLAYERNUM 
from BBalls_Stats
GROUP BY PlayerPosition
ORDER BY PlayerPosition

/**b.	Find the Number of Players assigned to each Coach**/
SELECT PlayersCoach, COUNT (*) PLAYERNUM
FROM BBalls_Stats
GROUP BY PlayersCoach
ORDER BY PlayersCoach

/**c.	Find the Most POINTS scored per game by Position**/
SELECT PlayerPosition, MAX( Points) AS MOSTP
FROM BBalls_Stats
GROUP BY PlayerPosition
ORDER BY PlayerPosition


/**d.	Find the Number of Rebounds per game by Coach**/
SELECT PlayersCoach, COUNT(*)REBOUNDS 
from BBalls_Stats
GROUP BY PlayersCoach
ORDER BY PlayersCoach	
/**e.	Find the Average number of Assist by Coach**/
SELECT PlayersCoach, AVG(ASSIST) AS ASSISTAV
from BBalls_Stats
GROUP BY PlayersCoach
ORDER BY PlayersCoach	
/**f.	Find the Average number of Assist per game by Position **/
SELECT PlayerPosition, AVG(ASSIST) AS ASSISTAV
FROM BBalls_Stats
GROUP BY PlayerPosition
ORDER BY PlayerPosition
/**g.	Find the Total number of Points by each Player Position.**/
SELECT PlayerPosition, SUM (POINTS) AS TOTALNUMBER
FROM BBalls_Stats
GROUP BY PlayerPosition
ORDER BY PlayerPosition