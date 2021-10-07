#!/bin/bash

#for sub in 1001 1002 1003 1004 1006 1007 1009 1010 1011 1012 1013 1015 1016 1019 1021 1240 1242 1243 1244 1245 1247 1248 1249 1251 1253 1286 1300; do

for sub in 1255 1276 1282 1286 1294 1301 1999 2048 3101 3122 3125 3140; do

	script=code/prepdata.sh
	NCORES=12
	while [ $(ps -ef | grep -v grep | grep $script | wc -l) -ge $NCORES ]; do
		sleep 1s
	done
	bash $script $sub &
	sleep 5s

done
