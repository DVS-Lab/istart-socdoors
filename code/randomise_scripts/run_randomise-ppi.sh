#!/bin/bash

MAINDIR=/data/projects/start-socdoors

for COV in alcohol tobacco marijuana; do
for COPEINFO in "3 dec" "4 win-loss"; do
for PPI in NAcc-act_n46 vmpfc; do
	set -- $COPEINFO
	CNUM=$1
	CNAME=$2
	
	NCORES=20
	SCRIPTNAME=${MAINDIR}/derivatives/fsl/L3_model-1_task-socialdoors_n100_flame1+2/randomise-ppi.sh
	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
		sleep 1s
	done
	
	bash $SCRIPTNAME $PPI $COV $CNUM $CNAME &
	

done
done
done