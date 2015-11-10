#!/usr/bin/env python
import sys

prev_word            = 'X;aldjksfal;jdkfpoquier'
months               = ['Jan','Feb','Mar','Apr','Jun','Jul','Aug','Sep','Nov','Dec']
dates_to_output      = []
day_counts_to_output = []
line_count           = 0

for line in sys.stdin:
    line                = line.strip()
    curr_word, value_in = line.split('\t')
    line_count          = line_count+1

    if curr_word != prev_word:

        if line_count>1:
            for i in range(len(dates_to_output)):
                 print('{0} {1} {2} {3}'.format(dates_to_output[i], prev_word, day_counts_to_output[i], curr_word_total_count))

        # reset globals
        dates_to_output      = []
        day_counts_to_output = []
        prev_word            = curr_word

    if value_in[0:3] in months: 
        day, count = value_in.split()
        dates_to_output.append(day)
        day_counts_to_output.append(count)
    else:
        curr_word_total_count = value_in

for i in range(len(dates_to_output)):
    print('{0} {1} {2} {3}'.format(dates_to_output[i], prev_word, day_counts_to_output[i], curr_word_total_count))


