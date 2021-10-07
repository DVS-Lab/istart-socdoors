#!/usr/bin/env python3
# =============================================================================
# Created By  : David Smith
# Created Date: Mon Sep 6 2021
# =============================================================================
'''
This code shifts the dates in the acq_time column of the *scans.tsv files. It takes
a sub-{sub}_scans.tsv as its input and shifts the dates.

usage:
python3 shiftdates.py /data/projects/istart-data/bids/sub-1004/sub-1004_scans.tsv

notes and disclaimers:
1) needs trailing slash on input path
2) supressing a performancewarning right now, so code could definitely be improved
3) this will overwrite the existing file
'''

# =============================================================================
# Imports
# =============================================================================
import sys
import datetime, dateutil
import pandas as pd


# =============================================================================
# To do's and things to improve
# This is intended to supress the following warning that i was getting:
# /fakepath/datetimelike.py:1187: PerformanceWarning: Adding/subtracting object-dtype array to DatetimeArray not vectorized
import warnings
warnings.simplefilter(action='ignore', category=pd.errors.PerformanceWarning)
# =============================================================================


# full path to input file. this is the input to the script
scan = sys.argv[1]
months = 100*12 # how many months are we removing? 100*12 would be 100 years...

# print out progress and load in tsv file
print('scrubbing ' + scan)
df = pd.read_csv(scan, sep = '\t')

# convert string to datetime format, shift date, and convert back to string format
df['acq_time'] = pd.to_datetime(df['acq_time'],infer_datetime_format=True)
df['acq_time'] = df['acq_time'] - pd.DateOffset(months=months)
df['acq_time'] = df['acq_time'].dt.strftime('%Y-%m-%dT%H:%M:%S.%f')

# edit operator column so that it doesn't output as empty
df['operator'] = 'tubric'

# save revised dataframe. overwrites existing!
df.to_csv(scan, sep = '\t', index = False)
