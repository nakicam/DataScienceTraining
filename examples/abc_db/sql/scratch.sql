select t.* from teams_view t where t.team_id=1;

create or replace view player_view 

as
  select p.name as p_name
        , p.goals as p_goals
        , d1.id   as p_i1_id
        , d1.ndim as p_i1_std
        , d2.id   as p_i2_id
        , d2.ndim as p_i2_std
    from players p
      inner join array_data d1 on (p.image1_id=d1.id)
      inner join array_data d2 on (p.image2_id=d2.id)
  ;

select * from player_view;

select
    t.id    as id
  , t.name  as name
  , t.wins  as wins
  , t.loses as loses
  , d1.std  as team_i1_std
  , d2.id   as p_i2_id
  , d2.ndim as p_i2_std
from players p
  inner join array_data d1 on (p.image1_id=d1.id)
  inner join array_data d2 on (p.image2_id=d2.id)
;

select teams_view.*, players_view.* 
from teams inner join players_views on teams_views.team_id=players_view.team_id
;

select team_id 
from teams_view natural join players_view
where team_wins > 0 and player_goals > 9
;

select p.id
from players p inner join teams t on p.teams_id=t.id
where t.id=1
;

select
      d.ndim 
    , d.dim1 
    , d.dim2 
    , d.dim3 
    , d.dim4 
    , d.dtype
    , d.value
from array_data d where d.id=1
;