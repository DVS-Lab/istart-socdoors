#!/usr/bin/env bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

for sub in `cat ${maindir}/code/newsubs-SANS.txt`; do	
	# ROI name and other path information
	for ROI in VS_r26; do
		for TASK in doors socialdoors; do		
			MASK=${maindir}/masks/seed-${ROI}.nii.gz
			fslmeants -i /data/projects/istart-data/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz -m ${MASK} -o sub-${sub}_task-${TASK}_run-1_${ROI}.txt
			mv sub-${sub}_task-${TASK}_run-1_${ROI}.txt ${maindir}/derivatives/fsl/sub-${sub}/
		done
	done
done