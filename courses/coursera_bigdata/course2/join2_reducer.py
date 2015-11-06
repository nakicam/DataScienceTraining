#!/usr/bin/env python

import sys
import re

current_key = None
total    = 0
abc_list = []

# -----------------------------------
# Loop thru file
#  --------------------------------
for line in sys.stdin:
    line = line.strip()

    key, value = line.split("\t", 1)

    # test weather the value is a channel
    if len(value)==3 and re.search('[a-zA-Z]', value):
        if value=='ABC':
            abc_list.append(key)
        continue
    else:
        value = int(value)
 
    if current_key == key:
        total += value
    else:
        if current_key and current_key in abc_list:
            print( "{0} {1}".format(current_key, total))
        total    = value
        current_key = key

if current_key == key and current_key in abc_list:
    print(abc_list)
    print( "{0} {1}".format(current_key, total)) 
