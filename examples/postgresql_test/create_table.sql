
drop table weather;

CREATE TABLE weather (
    city     varchar(80),
--     temp_lo  int,           -- low temperature
--     temp_hi  int,           -- high temperature
--     prcp     real,          -- precipitation
    test     integer[3]
--     date     date
);

-- INSERT INTO weather (city, temp_lo, temp_hi, prcp, test, date) VALUES ('San Francisco', 43, 57, 0.0, '{{1,2,3},{4,5,6},{7,8,9}}', '1994-11-29');
-- INSERT INTO weather (city, temp_lo, temp_hi, prcp, test, date) VALUES ('San Diego'    , 63, 77, 0.0, '{{1,2,3},{4,5,6},{7,8,9}}', '1997-12-31');

INSERT INTO weather (city, test) VALUES ('San Francisco', '{{1,2,3},{3,4,5},{7,8,9}}');
INSERT INTO weather (city, test) VALUES ('San Diego'    , '{{1,2,3},{3,4,5}}');

select * from weather;
