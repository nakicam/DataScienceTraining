-- drop existing

drop table b_obs;
drop table b;
drop table a;
drop sequence b_seq;
drop sequence a_seq;

-- deploy

@abc.ddl

-- load data

-- query test
