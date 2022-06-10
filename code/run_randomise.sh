#!/bin/bash

# This script will perform Level 3 stats across social 
# and nonsocial conditions in the ISTART Social Doors task
# for models containing covariates

MAINDIR=/data/projects/istart-socdoors/derivatives/fsl


for modelnum in 1 2; do
	for type in "act" "ppi_seed-VS_thr5" "nppi-dmn"; do

	randomise -i type-${type}_model-${modelnum}_randomise_filteredfunc_diff.nii.gz -o ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n92_flame1+2_randomise/L3_model-${modelnum}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/ -d ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n46_flame1+2/L3_task-socialdoors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/design.mat -t ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n46_flame1+2/L3_task-socialdoors_type-${type}_cnum-4_cname-win-loss_flame1+2.gfeat/cope1.feat/design.con -x -c 3.1 -T

	done
done