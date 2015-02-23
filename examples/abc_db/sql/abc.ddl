-- Generated by Oracle SQL Developer Data Modeler 4.1.0.866
--   at:        2015-02-22 20:32:15 PST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g




CREATE TABLE player_images
  (
    i          INTEGER ,
    j          INTEGER ,
    k          INTEGER ,
    image      INTEGER ,
    players_id NUMBER (7) NOT NULL
  ) ;
ALTER TABLE player_images ADD CONSTRAINT player_images_PK PRIMARY KEY ( players_id ) ;
ALTER TABLE player_images ADD CONSTRAINT player_images__UN UNIQUE ( i , j , k , players_id ) ;

CREATE TABLE players
  (
    id   NUMBER (7) NOT NULL ,
    name VARCHAR2 (10) ,
    image BLOB ,
    teams_id NUMBER (7) NOT NULL
  ) ;
ALTER TABLE players ADD CONSTRAINT players_PK PRIMARY KEY ( id ) ;
ALTER TABLE players ADD CONSTRAINT players__UN UNIQUE ( name , teams_id ) ;

CREATE TABLE teams
  ( id NUMBER (7) NOT NULL , name VARCHAR2 (10) NOT NULL
  ) ;
ALTER TABLE teams ADD CONSTRAINT teams_PK PRIMARY KEY ( id ) ;
ALTER TABLE teams ADD CONSTRAINT teams__UN UNIQUE ( name ) ;

ALTER TABLE player_images ADD CONSTRAINT player_images_players_FK FOREIGN KEY ( players_id ) REFERENCES players ( id ) ;

ALTER TABLE players ADD CONSTRAINT players_teams_FK FOREIGN KEY ( teams_id ) REFERENCES teams ( id ) ;

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
-- CREATE TABLE                             3
-- CREATE INDEX                             0
-- ALTER TABLE                              8
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           2
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
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
