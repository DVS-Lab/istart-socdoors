#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
nruns=2
task=sharedreward # edit if necessary

for ppi in 0 NAcc; do # putting 0 first will indicate "activation"
	for sub in 1001 1002 1003 1004 1006 1007 1009 1010 1011 1012 1013 1015 1016 1019 1021 1240 1242 1243 1244 1245 1247 1248 1249 1251 1253 1286 1300; do
	  for run in `seq $nruns`; do

			# some exceptions, hopefully temporary
			if [ $sub -eq 1240 ] || [ $sub -eq 1245 ] || [ $sub -eq 1247 ] || [ $sub -eq 1248 ] || [ $sub -eq 1003 ]; then # bad data
				echo "skipping both runs for sub-${sub} for task-${task}"
				continue
			fi
			if [ $sub -eq 1002 ] && [ $run -eq 2 ]; then # bad data
				echo "skipping run-2 for sub-${sub} for task-${task}"
				continue
			fi

	  	# Manages the number of jobs and cores
	  	SCRIPTNAME=${basedir}/code/L1stats.sh
	  	NCORES=15
	  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
	    		sleep 5s
	  	done
	  	bash $SCRIPTNAME $sub $run $ppi &
	  	sleep 1s
	  done
	done
done
