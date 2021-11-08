#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basedir="$(dirname "$scriptdir")"
nruns=1

for ppi in 0; do # putting 0 first will indicate "activation"
	for sub in 1001 1002 1003 1004 1006 1007 1009 1010 1011 1012 1013 1015 1016 1019 1021 1240 1242 1243 1244 1245 1247 1248 1249 1251 1253 1255 1276 1282 1286 1294 1300 1301 \
	1302 3101 3116 3122 3140 3143 3152 3164 3166 3167 3170 3173 3175 3176 3189 3190; do
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
