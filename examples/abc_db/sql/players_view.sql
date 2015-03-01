
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ABC"."PLAYERS_VIEW" ("PLAYER_ID", "PLAYER_NAME", "PLAYER_GOALS", "PLAYER_STARTS", "PLAYER_IMAGE1_ID", "PLAYER_IMAGE1_STD", "PLAYER_IMAGE1_AVG", "PLAYER_IMAGE2_ID", "PLAYER_IMAGE2_STD", "PLAYER_IMAGE2_AVG", "PLAYER_IMAGE3_ID", "PLAYER_IMAGE3_STD", "PLAYER_IMAGE3_AVG", "TEAM_ID") AS 
  select
	  p.id     as player_id
  , p.name   as player_name
  , p.goals  as player_goals
  , p.starts as player_starts
  , d1.id    as player_image1_id
  , d1.std   as player_image1_std
  , d1.avg   as player_image1_avg
  , d2.id    as player_image2_id
  , d2.std   as player_image2_std
  , d2.avg   as player_image2_avg
  , d3.id    as player_image3_id
  , d3.std   as player_image3_std
  , d3.avg   as player_image3_avg
  , p.teams_id as team_id
from players p
  inner join array_data d1 on (p.image1_id=d1.id)
  inner join array_data d2 on (p.image2_id=d2.id)
  inner join array_data d3 on (p.image3_id=d3.id);
  

