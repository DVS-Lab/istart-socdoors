#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# the "type" variable below is setting a path inside the main script
for type in act ppi_seed-NAcc; do # act nppi-ecn nppi-dmn
	for sub in 1001 1002 1003 1004 1006 1007 1009 1010 1011 1012 1013 1015 1016 1019 1021 1240 1242 1243 1244 1245 1247 1248 1249 1251 1253 1286 1300; do

		# Manages the number of jobs and cores
  	SCRIPTNAME=${maindir}/code/L2stats.sh
  	NCORES=10
  	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
    		sleep 1s
  	done
  	bash $SCRIPTNAME $sub $type &
  	sleep 1s

	done
done
