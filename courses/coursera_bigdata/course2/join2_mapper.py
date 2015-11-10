#!/usr/bin/env python   

import sys


for line in sys.stdin:  
    line       = line.strip()
    key, value = line.split(',')
    
    print('{0}\t{1}'.format(key, value))
