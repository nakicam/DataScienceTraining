#!/bin/bash

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-streaming.jar \
 -input /user/cloudera/input                              \
 -output /user/cloudera/output_join2                      \
 -mapper $PWD/join2_mapper.py                             \
 -reducer $PWD/join2_reducer.py
