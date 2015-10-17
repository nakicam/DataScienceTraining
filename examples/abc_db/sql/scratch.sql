CREATE OR REPLACE TYPE ArrayInfo
AS
  OBJECT
  (
    AVG   NUMBER ,
    std   NUMBER ,
    ndim  NUMBER ,
    dim1  NUMBER ,
    dim2  NUMBER ,
    dim3  NUMBER ,
    dim4  NUMBER ,
    dtype VARCHAR2 (20) ,
    value LOB ) NOT FINAL ;
  /
show errors;

SELECT * FROM ALL_TABLES
where table_name = 'PLAYERS';

select 
    column_name
  , data_type
  , data_precision
  , data_scale
from
  user_tab_columns
where
  table_name = 'PLAYERS'
;

select *
from
  user_tab_columns
where
  table_name = 'PLAYERS'
;

select distinct teams.id
from teams
  inner join players on (teams.id = players.teams_id)
  where players.goals > 2
;

select
    t.name
  , t.wins
  , t.loses
  , t.pic1.ndim
  , t.pic1.dim1
  , t.pic1.dtype
  , t.pic1.value 
from teams t
where t.id in (
  select distinct teams.id
  from teams
    inner join players on (teams.id = players.teams_id)
  where players.goals > 2
)
;

