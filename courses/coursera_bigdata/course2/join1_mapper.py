#!/usr/bin/env python   

import sys


for line in sys.stdin:  
    line     = line.strip()
    lhs, rhs = line.split(',')
    
    # hard code it for this example 
    if ' ' in lhs: 
        date, key = lhs.split(' ')
        value     = date + ' ' + rhs
    else:
        key   = lhs
        value = rhs


    print('{0}\t{1}'.format(key, value))
