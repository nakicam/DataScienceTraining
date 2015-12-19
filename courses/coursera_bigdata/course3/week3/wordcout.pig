-- ************* THE CODE STARTS HERE: ************************

wordfile = LOAD '/user/cloudera/pigin/testfile*' USING PigStorage('\n') as (linesin:chararray);

wordfile_flat = FOREACH wordfile GENERATE FLATTEN(TOKENIZE(linesin)) as wordin;

wordfile_grpd = GROUP wordfile_flat by wordin;

word_counts = FOREACH wordfile_grpd GENERATE group, COUNT(wordfile_flat.wordin);



--If you are running pig -x mapreduce don't forget to

--use hdfs commands to rm the file and rmdir for the output



STORE word_counts into '/user/cloudera/pigoutnew/word_counts_pig';



-- And dont forget to copy from hdfs into your local unix filesystem, (but your paths may differ!)

--hdfs dfs -copyToLocal /user/cloudera/pigoutnew/word_counts_pig /home/cloudera/word_counts_pig

