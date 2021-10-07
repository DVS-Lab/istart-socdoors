#!/bin/bash

for sub in 1255 1276 1282 1286 1294; do

	script=code/fmriprep.sh
	NCORES=8
	while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		sleep 1s
	done
	bash $script $sub &
	sleep 5s
done
