-- Generated by Oracle SQL Developer Data Modeler 4.1.0.866
--   at:        2015-02-22 11:35:58 PST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g




CREATE TABLE a
  ( id NUMBER (7) NOT NULL , name VARCHAR2 (10) NOT NULL
  ) ;
ALTER TABLE a ADD CONSTRAINT a_PK PRIMARY KEY ( id ) ;
ALTER TABLE a ADD CONSTRAINT a__UN UNIQUE ( name ) ;

CREATE TABLE b
  (
    id   NUMBER (7) NOT NULL ,
    name VARCHAR2 (10) ,
    image BLOB ,
    a_id NUMBER (7) NOT NULL
  ) ;
ALTER TABLE b ADD CONSTRAINT b_PK PRIMARY KEY ( id ) ;
ALTER TABLE b ADD CONSTRAINT b__UN UNIQUE ( name , a_id ) ;

CREATE TABLE b_obs
  (
    i     INTEGER ,
    j     INTEGER ,
    image INTEGER ,
    b_id  NUMBER (7) NOT NULL
  ) ;
ALTER TABLE b_obs ADD CONSTRAINT b_obs_PK PRIMARY KEY ( b_id ) ;
ALTER TABLE b_obs ADD CONSTRAINT b_obs__UN UNIQUE ( i , j , b_id ) ;

ALTER TABLE b ADD CONSTRAINT b_a_FK FOREIGN KEY ( a_id ) REFERENCES a ( id ) ;

ALTER TABLE b_obs ADD CONSTRAINT b_obs_b_FK FOREIGN KEY ( b_id ) REFERENCES b ( id ) ;

CREATE SEQUENCE a_seq START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER a_seq BEFORE
  INSERT ON a FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := a_seq.NEXTVAL;
END;
/

CREATE SEQUENCE b_seq START WITH 1 NOCACHE ORDER ;
CREATE OR REPLACE TRIGGER b_trg BEFORE
  INSERT ON b FOR EACH ROW WHEN (NEW.id IS NULL) BEGIN :NEW.id := b_seq.NEXTVAL;
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