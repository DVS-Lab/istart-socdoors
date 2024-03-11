#!/usr/bin/env bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"
outputdir=${maindir}/derivatives/imaging_plots

# base paths
for TASK in doors socialdoors; do
	for TYPE in act ppi_seed-VS_thr5; do
		for COPEINFO in "1 win" "2 loss" "4 win-loss"; do
			set -- $COPEINFO
			COPENUM=$1
			COPENAME=$2
			
			DATA=`ls -1 ${maindir}/derivatives/fsl/L3_model-1_task-${TASK}_n46_flame1+2/L3_task-${TASK}_type-${TYPE}_cnum-${COPENUM}_cname-${COPENAME}_flame1+2.gfeat/cope1.feat/filtered_func_data.nii.gz`
			
			echo "Extracting ${TASK} ${TYPE} cope ${COPENUM}"
			fslmeants -i $DATA -o ${outputdir}/L3_task-${TASK}_type-${TYPE}_cnum-${COPENUM}_cname-${COPENAME}_VS_flame1+2_3mar24.txt -m ${maindir}/masks/seed-VS_thr5.nii.gz
		done
	done
done
