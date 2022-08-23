#!/bin/bash

# This script will perform Level 3 stats across social 
# and nonsocial conditions in the ISTART Social Doors task
# for models containing covariates

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"

# Manages the number of jobs and cores
SCRIPTNAME=${basedir}/code/randomise.sh
NCORES=10
while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	sleep 5s
done

bash $SCRIPTNAME &
sleep 1s