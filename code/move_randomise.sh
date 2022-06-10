#!/bin/bash

# This script will perform Level 3 stats across social 
# and nonsocial conditions in the ISTART Social Doors task
# for models containing covariates

MAINDIR=/data/projects/istart-socdoors/derivatives/fsl


for modelnum in 2 3; do
	for type in "act" "ppi_seed-VS_thr5" "nppi-dmn"; do

		#cp run_randomise.sh ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n92_flame1+2_randomise/L3_model-${modelnum}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise
		#cd ${MAINDIR}/L3_model-${modelnum}_task-socialdoors_n92_flame1+2_randomise/L3_model-${modelnum}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise
		nohup bash run_randomise.sh > randomise_output.out	
	
	done
done