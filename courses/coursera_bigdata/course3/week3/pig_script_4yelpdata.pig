-- *******   PIG LATIN SCRIPT for Yelp Assignmet ******************

-- 0. get function defined for CSV loader

register /usr/lib/pig/piggybank.jar;
register /home/cloudera/Downloads/incubator-datafu/datafu-pig/build/libs/datafu-pig-incubating-1.3.0-SNAPSHOT.jar;
define CSVLoader org.apache.pig.piggybank.storage.CSVLoader();

-- 1 load data

Y = LOAD '/usr/lib/hue/apps/search/examples/collections/solr_configs_yelp_demo/index_data.csv'
    USING CSVLoader() 
    AS (
           business_id:chararray,
           cool,
           date,
           funny,
           id,
           stars:int,
           text:chararray,
           type,useful:int,
           user_id,
           name,
           full_address,
           latitude,
           longitude,
           neighborhoods,
           open,
           review_count,
           state
       );

Y_good = FILTER Y BY (useful is not null and stars is not null);

--2 Find max useful
Y_all = GROUP Y_good ALL;
Umax  = FOREACH Y_all GENERATE MAX(Y_good.useful);
DUMP Umax

-- this shows max useful rating of 28! ...

-- 3 Now limit useful field to be <=5 and then get wtd average

Y_rate  = FOREACH Y_good GENERATE business_id,stars,(useful>5 ? 5:useful) as useful_clipped;
Y_rate2 = FOREACH Y_rate GENERATE $0..,(double) stars*(useful_clipped/5) as wtd_stars;

-- 4 Rank businesses

Y_g = GROUP Y_rate2 BY business_id;
Y_m = FOREACH Y_g
      GENERATE group as business_idgroup,COUNT(Y_rate2.stars) as num_ratings ,
          AVG(Y_rate2.stars) as avg_stars,
          AVG(Y_rate2.useful_clipped) as avg_useful,
          AVG(Y_rate2.wtd_stars) as avg_wtdstars;
         
Y_rnk = RANK Y_m BY avg_wtdstars;

-- Question #1

Y_rnk = RANK Y_m BY avg_wtdstars DESC;
DUMP Y_rnk;

-- Question #2

Y_m2 = filter Y_m by (num_ratings > 1);
Y_g2 = group Y_m2 all;
Y_a2 = foreach Y_g2 generate AVG(Y_m2.avg_wtdstars) as avg_avg_wtdstars;
DUMP Y_a2;

-- Question #3

Y_j  = JOIN Y_rate by business_id, Y_m2  by business_idgroup;
Y_jg = group Y_j all;
Y_a  = foreach Y_jg generate AVG(Y_j.avg_wtdstars) as avg_avg_wtdstars;
dump Y_a;

-- Question #4
-- Under what condition would you prefer to report the average of the average, or the average of all wtd_stars grouped together?

-- If you know that the businesses are similar, with similar customers and in similar neighborhoods, then grouping them all together will give you a better estimate of the overall average.

-- If you know that businesses are not the same, perhaps because of different demographics of their location or customers, then you should not group it all together and take averages of averages.

-- The other possibility is to report both, and depending on your context, you might need to report number of ratings as well, because that could be skewing a grouped average.


-- Question #5

Ygf     = FOREACH Y_g GENERATE COUNT(Y_rate2.stars) as num_rated, Y_rate2.wtd_stars as wtd_stars2use;
Ygf_gt1 = FILTER Ygf BY num_rated>1;
Y_next  = FOREACH Ygf_gt1 GENERATE FLATTEN(wtd_stars2use) AS flat_wtd_stars2use;
Yg2     = GROUP Y_next ALL;
A2      = FOREACH Yg2 GENERATE AVG(Y_next.flat_wtd_stars2use);
dump A2;



