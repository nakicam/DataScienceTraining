-- drop existing

drop table players;
drop table teams;
drop table array_data;
drop sequence players_id_seq;
drop sequence teams_id_seq;
drop sequence array_data_id_seq;

-- deploy

@abc.ddl

-- load data

-- query test
