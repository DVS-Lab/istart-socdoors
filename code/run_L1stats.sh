#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
nruns=1

for ppi in 0; do # putting 0 first will indicate "activation"
	for sub in `cat ${basedir}/code/newsubs.txt`; do
	  for run in `seq $nruns`; do

	  	# Manages the number of jobs and cores
	  	SCRIPTNAME=${basedir}/code/L1stats.sh
	  	NCORES=15
	  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    		sleep 5s
	  	done
	  	#bash $SCRIPTNAME $sub $run $ppi &
		bash /data/projects/istart-socdoors/code/L1stats.sh $sub $run $ppi &	  	
	  	sleep 1s
	  done
	done
done
