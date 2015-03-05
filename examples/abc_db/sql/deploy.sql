-- drop existing

drop table players;
drop table teams;
drop sequence players_id_seq;
drop sequence teams_id_seq;

-- deploy

@abc.ddl

-- load data

-- query test
