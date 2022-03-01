#!/bin/bash

# make diff image for all input images between SANS submission 
# and attempted SANS recreation

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

for sub in `cat ${scriptdir}/newsubs.txt`; do
	for task in doors socialdoors; do
		for type in act ppi_seed-VS_r26; do
			for cope in 3 4; do
				fslmaths ${maindir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-${type}_run-1_sm-6.feat/thresh_zstat${cope}.nii.gz -sub ${maindir}/derivatives/_fsl-archive2/sub-${sub}/L1_task-${task}_model-1_type-${type}_run-1_sm-6.feat/thresh_zstat${cope}.nii.gz sub-${sub}_task-${task}_type-${type}_cope${cope}_diffimage.nii.gz
			done
		done
	done
done

