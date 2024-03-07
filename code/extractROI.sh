#!/usr/bin/env bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

for sub in `cat ${maindir}/code/newsubs.txt`; do	
	# ROI name and other path information
	for ROI in VS_thr5; do
		for TASK in doors socialdoors; do		
			#MASK=${maindir}/masks/${ROI}.nii.gz
			MASK=${maindir}/masks/seed-${ROI}.nii.gz
			fslmeants -i /ZPOOL/data/projects/istart-socdoors/derivatives/fsl/sub-${sub}/L1_task-${TASK}_model-1_type-act_run-1_sm-6.feat/stats/zstat4.nii.gz -m ${MASK} -o sub-${sub}_task-${TASK}_run-1_${ROI}_zstat4.txt
			mv sub-${sub}_task-${TASK}_run-1_${ROI}.txt ${maindir}/derivatives/zstats/
		done
	done
done
