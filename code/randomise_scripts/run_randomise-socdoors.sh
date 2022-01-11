#!/bin/bash

# This script is a wrapper for the randomise_socdoors.sh script that runs
# level 3 stats across conditions in the ISTART Social Doors task. 

MAINDIR=/data/projects/istart-socdoors

N=50
N2=100
for TYPE in act; do 									# options: act ppi
for COV in tobacco alcohol marijuana; do		# name of 
for COPEINFO in "3 dec" "4 win-loss"; do
#for in NAcc vmpfc; do

	set -- $COPEINFO
	CNUM=$1
	CNAME=$2
	
	# Set paths for input variables in randomise_socdoors.sh script	
	SOCIALIMAGE=${MAINDIR}/derivatives/fsl/L3_model-1_task-socialdoors_n${N}_flame1+2/L3_task-socialdoors_type-${TYPE}_run-1_cnum-${CNUM}_cname-${CNAME}_onegroup_cov-${COV}.gfeat/cope1.feat/filtered_func_data.nii.gz	
	NONSOCIALIMAGE=${MAINDIR}/derivatives/fsl/L3_model-1_task-doors_n${N}_flame1+2/L3_task-doors_type-${TYPE}_run-1_cnum-${CNUM}_cname-${CNAME}_onegroup_cov-${COV}.gfeat/cope1.feat/filtered_func_data.nii.gz
	MATFILE=${MAINDIR}/derivatives/fsl/L3_model-1_task-socialdoors_n${N}_flame1+2/L3_task-socialdoors_type-${TYPE}_run-1_cnum-${CNUM}_cname-${CNAME}_onegroup_cov-${COV}.gfeat/cope1.feat/design.mat
	CONFILE=${MAINDIR}/derivatives/fsl/L3_model-1_task-socialdoors_n${N}_flame1+2/L3_task-socialdoors_type-${TYPE}_run-1_cnum-${CNUM}_cname-${CNAME}_onegroup_cov-${COV}.gfeat/cope1.feat/design.con	
	
	NCORES=20
	SCRIPTNAME=${MAINDIR}/code/randomise_scripts/randomise_socdoors.sh
	while [ $(ps -ef | grep -v grep | grep $SCRIPTNAME | wc -l) -ge $NCORES ]; do
		sleep 1s
	done
	
	bash $SCRIPTNAME $SOCIALIMAGE $NONSOCIALIMAGE $MATFILE $CONFILE $CNUM $CNAME $N $N2 $TYPE $COV &
	
#done
done
done
done