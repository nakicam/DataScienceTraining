
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "ABC"."TEAMS_VIEW" ("TEAM_ID", "TEAM_NAME", "TEAM_WINS", "TEAM_LOSES", "TEAM_PIC1_ID", "TEAM_PIC1_STD", "TEAM_PIC1_AVG") AS 
  select
    t.id    as team_id
  , t.name  as team_name
  , t.wins  as team_wins
  , t.loses as team_loses
  , d1.id   as team_pic1_id
  , d1.std  as team_pic1_std
  , d1.avg  as team_pic1_avg
from teams t
  inner join array_data d1 on (t.pic1_id=d1.id);


