-- Generated by Oracle SQL Developer Data Modeler 4.1.0.866
--   at:        2015-06-17 11:23:27 PDT
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g




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
    value BLOB ) NOT FINAL ;
  /

CREATE TABLE players
  (
    id     NUMBER (7) NOT NULL ,
    name   VARCHAR2 (10) ,
    starts NUMBER ,
    goals  NUMBER ,
    image1 ArrayInfo ,
    image2 ArrayInfo ,
    image3 ArrayInfo ,
    teams_id NUMBER (7) NOT NULL
  ) ;
ALTER TABLE players ADD CONSTRAINT players_PK PRIMARY KEY ( id ) ;
ALTER TABLE players ADD CONSTRAINT players__UN UNIQUE ( name ) ;

CREATE TABLE teams
  (
    id    NUMBER (7) NOT NULL ,
    name  VARCHAR2 (10) NOT NULL ,
    wins  NUMBER ,
    loses NUMBER ,
    pic1 ArrayInfo
  ) ;
ALTER TABLE teams ADD CONSTRAINT teams_PK PRIMARY KEY ( id ) ;
ALTER TABLE teams ADD CONSTRAINT teams__UN UNIQUE ( name ) ;

ALTER TABLE players ADD CONSTRAINT players_teams_FK FOREIGN KEY ( teams_id ) REFERENCES teams ( id ) ;

CREATE OR REPLACE VIEW v_players ( player_id, player_name, player_starts, player_goals, player_teams_id, player_image1_avg, player_image1_std, player_image1_ndim, player_image1_dim1, player_image1_dim2, player_image1_dim3, player_image1_dim4, player_image1_dtype, player_image2_avg, player_image2_std, player_image2_ndim, player_image2_dim1, player_image2_dim2, player_image2_dim3, player_image2_dim4, player_image2_dtype, player_image3_avg, player_image3_std, player_image3_ndim, player_image3_dim1, player_image3_dim2, player_image3_dim3, player_image3_dim4, player_image3_dtype ) AS
SELECT player.id AS player_id,
  player.name player_name,
  player.starts player_starts,
  player.goals player_goals,
  player.teams_id player_teams_id,
  player.image1.avg player_image1_avg,
  player.image1.std player_image1_std,
  player.image1.ndim player_image1_ndim,
  player.image1.dim1 player_image1_dim1,
  player.image1.dim2 player_image1_dim2,
  player.image1.dim3 player_image1_dim3,
  player.image1.dim4 player_image1_dim4,
  player.image1.dtype player_image1_dtype,
  player.image2.avg player_image2_avg,
  player.image2.std player_image2_std,
  player.image2.ndim player_image2_ndim,
  player.image2.dim1 player_image2_dim1,
  player.image2.dim2 player_image2_dim2,
  player.image2.dim3 player_image2_dim3,
  player.image2.dim4 player_image2_dim4,
  player.image2.dtype player_image2_dtype,
  player.image3.avg player_image3_avg,
  player.image3.std player_image3_std,
  player.image3.ndim player_image3_ndim,
  player.image3.dim1 player_image3_dim1,
  player.image3.dim2 player_image3_dim2,
  player.image3.dim3 player_image3_dim3,
  player.image3.dim4 player_image3_dim4,
  player.image3.dtype player_image3_dtype
FROM players player ;





CREATE OR REPLACE VIEW v_teams  AS
SELECT team.id    AS team_id,
  team.name       AS team_name,
  team.wins       AS team_wins,
  team.loses      AS team_loses,
  team.pic1.avg   AS team_pic1_avg,
  team.pic1.std   AS team_pic1_std,
  team.pic1.ndim  AS team_pic1_ndim,
  team.pic1.dim1  AS team_pic1_dim1,
  team.pic1.dim2  AS team_pic1_dim2,
  team.pic1.dim3  AS team_pic1_dim3,
  team.pic1.dim4  AS team_pic1_dim4,
  team.pic1.dtype AS team_pic1_dtype
FROM teams team ;





CREATE SEQUENCE players_id_SEQ START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER players_id_TRG BEFORE
  INSERT ON players FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := players_id_SEQ.NEXTVAL;
END;
/

CREATE SEQUENCE teams_id_SEQ START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER teams_id_TRG BEFORE
  INSERT ON teams FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := teams_id_SEQ.NEXTVAL;
END;
/


-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             2
-- CREATE INDEX                             0
-- ALTER TABLE                              5
-- CREATE VIEW                              2
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   1
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          2
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
