# Extracts IQMs from MRIQC, identifies outlier subjects, and creates covariates
# Note: this is specific to SRNDNA
#
# usage example:
# python code/SRNDNA_OutlierID.py --mriqcDir="derivatives/mriqc"
#
# originally written by Jeff Dennison (Spring 2020)

import numpy as np
import json
import pandas as pd
import os
import itertools
import argparse
from scipy.stats import zscore


# set up paths relative to code directory
codedir = dirname(os.path.realpath(sys.argv[0]))
basedir = dirname(codedir)
mriqc_path = os.path.join(basedir,'derivatives','mriqc')
path_derivative = os.path.join(basedir,'derivatives')
bids_dir = os.path.join(basedir,'bids')


# collect subjects

all_subs=[s for s in os.listdir(bids_dir) if s.startswith('sub')]

#make list of json files
j_files=[]
for root, dirs, files in os.walk(mriqc_path):
    for f in files:
        if f.endswith('bold.json'):
            j_files.append(os.path.join(root, f))

# jimmy to add known exclusions here
custom_exclude=['sub-111','sub-118','sub-129','sub-135','sub-138','sub-149']

keys=['tsnr','fd_mean'] # the IQM's we might care about
sr=['Sub','task','run']

# Open an empty array and fill it. Do this it is a good idea
row=[]
import re # re will let us parse text in a nice way
for i in range(len(j_files)):
    sub=re.search('/mriqc/(.*)/func', j_files[i]).group(1) # this will parse the text for a string that looks like sub-###
    task=re.search('task-(.*)_run',j_files[i]).group(1)
    run=re.search('_run-(.*)_bold.json', j_files[i]).group(1) # this is parsed just as # so we have to put in the run text ourselves if we want later
    with open(j_files[i]) as f: #we load the j_son file and extract the dictionary ingo
        data = json.load(f)
    now=[sub,task,run]+[data[x]for x in keys] #the currently created row in the loop
    row.append(now) #through that row on the end

df_full=pd.DataFrame(row,columns=sr+keys) # imaybe later try to do multi-indexing later with sub and run as the index?


for task in df_full.task.unique():
    print(task)
    df=df_full[df_full['task']==task]
    mriqc_subs = np.setdiff1d(all_subs,df.Sub.unique())
    # yields the elements in `list_2` that are NOT in `list_1`
    print("%s are missing MRIQC OUTPUT"%(mriqc_subs))
    Q1=df[keys].quantile(0.25)
    Q3=df[keys].quantile(0.75)
    #find the interquartile range
    IQR = Q3 - Q1
    #defining fences as 1.5*IQR further than the 1st and 3rd quartile from the mean
    lower=Q1 - 1.5 * IQR
    upper=Q3 + 1.5 * IQR
    upper.tsnr=upper.tsnr*100 # so we don't exclude runs with "too good" signal-noise ratio

    print("These are the upper and lower bounds for our metrics")
    print(lower.to_frame(name='lower').join(upper.to_frame(name='upper')))

    outList=(df[keys]<upper)&(df[keys]>lower)#Here we make comparisons
    df['outlier_run_Custom1']=~outList.all(axis='columns')

    print('These are the identities outlier Runs')
    print(df[df['outlier_run_Custom1']==True])
    df.to_csv('../derivatives/Task-%s_Level-Run_Outlier-info_mriqc-0.16.1.tsv'%(task),sep='\t',index=False)

    GS=df[df['outlier_run_Custom1']==False]
    GS=list(GS.Sub.value_counts().reset_index(name="count").query("count > 0")['index']) # how many good runs?
    BS=df[~df.Sub.isin(GS)]['Sub']

    df_cov=df[df.Sub.isin(GS)]
    df_cov=df_cov[df_cov['outlier_run_Custom1']==False]
    df_cov=df_cov.groupby(by='Sub').mean().reset_index().rename(columns={'index':'Sub'})
    df_cov=df_cov[['Sub']+keys]
    df_cov[['tsnr','fd_mean']]=df_cov[['tsnr','fd_mean']].apply(zscore)
    df_cov.to_csv('../derivatives/Task-%s_Level-Group_Covariates_mriqc-0.16.1.tsv'%(task),sep='\t',index=False)

    df_out=df[df.Sub.isin(BS)]
    df_out=df_out.Sub.value_counts().reset_index().rename(columns={'index':'Sub_num'})
    df_out=df_out.sort_values(by='Sub_num')
    df_out.to_csv('../derivatives/Task-%s_CustomSubOutlier_mriqc-0.16.1.tsv'%(task),sep='\t',index=False)
    print("df_out")
