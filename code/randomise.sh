#!/bin/bash

# This script will perform Level 3 stats across social 
# and nonsocial conditions in the ISTART Social Doors task
# for models containing covariates

# Ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

switch="new"
task="social+doors"

if [ ${task} == "social+doors" ]; then
	for modelnum in 2 3 4 5; do
		for type in "act" "nppi-dmn" "ppi_seed-VS_thr5"; do
			random=$(randomise -i ${maindir}/derivatives/fsl/L3_model-${modelnum}_task-${task}_n46_flame1+2_randomise/L3_model-${modelnum}_task-${task}_type-${type}_cnum-4_cname-win-loss_randomise/type-${type}_model-${modelnum}_randomise_filteredfunc_diff.nii.gz -o ${maindir}/derivatives/fsl/L3_model-${modelnum}_task-${task}_n46_flame1+2_randomise/L3_model-${modelnum}_task-${task}_type-${type}_cnum-4_cname-win-loss_randomise/ -d ${maindir}/derivatives/fsl/L3_model-${modelnum}_task-${task}_n46_flame1+2/L3_task-${task}_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/design.mat -t ${maindir}/derivatives/fsl/L3_model-${modelnum}_task-${task}_n46_flame1+2/L3_task-${task}_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/design.con -x -c 3.1 -T)
			nohup $random > ${maindir}/derivatives/fsl/L3_model-${modelnum}_task-${task}_n46_flame1+2_randomise/L3_model-${modelnum}_task-${task}_type-${type}_cnum-4_cname-win-loss_randomise/randomise.out &
		done
	done
fi 

if [ ${switch} == "old" ]; then
	for modelnum in 1 2; do
		for type in "act" "ppi_seed-VS_thr5" "nppi-dmn"; do
			randomise -i type-${type}_model-${modelnum}_randomise_filteredfunc_diff.nii.gz -o ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n92_flame1+2_randomise/L3_model-${modelnum}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/ -d ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n46_flame1+2/L3_task-socialdoors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/design.mat -t ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n46_flame1+2/L3_task-socialdoors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/design.con -x -c 3.1 -T
		done
	done
fi