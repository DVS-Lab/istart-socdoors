#!/bin/bash
#
# This script finds the min & max values for all randomise output for comparisons between social & doors for ISTART 2022
# Jimmy Wyngaarden, May 2022

for model in 2 3 4 5; do
	for type in "act" "nppi-dmn" "ppi_seed-VS_thr5"; do
		for file in /data/projects/istart-socdoors/derivatives/fsl/L3_model-${model}_task-socialdoors_n92_flame1+2_randomise/L3_model-${model}_task-socialdoors_type-${type}_cnum-4_cname-win-loss_randomise/*.nii.gz; do
			echo $file
			fslstats $file -R
		done
	done
done
