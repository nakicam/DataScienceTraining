#!/bin/bash

cmd="g++ soci_test.cpp -o soci_test \
 -I/usr/local/Cellar/soci/3.2.2/include \
 -I/usr/local/Cellar/soci/3.2.2/include/soci \
 -I$ORACLE_HOME/sdk/include \
 -L/usr/local/Cellar/soci/3.2.2/lib \
 -L$ORACLE_HOME/lib \
 -lsoci_core \
 -lsoci_oracle"

echo $cmd
eval $cmd
