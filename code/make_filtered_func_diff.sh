#!/bin/bash

# This script will perform Level 3 stats across social 
# and nonsocial conditions in the ISTART Social Doors task
# for models containing covariates

MAINDIR=/data/projects/istart-socdoors/derivatives/fsl

robust="no"

for modelnum in 2 3; do
	for type in "act" "nppi-dmn" "ppi_seed-VS_thr5"; do

	#mkdir ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n92_flame1+2_randomise/L3_model-${modelnum}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_flame1+2_randomise
	
	#if [${robust} == "no"]; then
	#fslmaths ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n46_flame1+2/L3_task-socialdoors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/filtered_func_data.nii.gz	-sub ${MAINDIR}/L3_model-${modelnum}_task-doors_n46_flame1+2/L3_task-doors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/filtered_func_data.nii.gz type-${type}_model-${modelnum}_randomise_filteredfunc_diff;
	#mv type-${type}_model-${modelnum}_randomise_filteredfunc_diff.nii.gz ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n92_flame1+2_randomise/L3_model-${modelnum}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise;
	
	#elif [${robust} == "yes"]; then	
	fslmaths ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n46_flame1+2/L3_task-socialdoors_type-${type}_cnum-4_cname-win-loss_flame1+2_robust.gfeat/cope1.feat/filtered_func_data.nii.gz	-sub ${MAINDIR}/L3_model-${modelnum}_task-doors_n46_flame1+2/L3_task-doors_type-${type}_cnum-4_cname-win-loss_flame1+2_robust.gfeat/cope1.feat/filtered_func_data.nii.gz type-${type}_model-${modelnum}_randomise_filteredfunc_diff
	mv type-${type}_model-${modelnum}_randomise_filteredfunc_diff.nii.gz ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n92_flame1+2_randomise/L3_model-${modelnum}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise_robust
	
	#fi

	done
done