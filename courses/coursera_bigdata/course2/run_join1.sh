#!/bin/bash

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
 -input /user/cloudera/input                              \
 -output /user/cloudera/output_join                       \
 -mapper $PWD/join1_mapper.py                             \
 -reducer $PWD/join1_reducer.py
