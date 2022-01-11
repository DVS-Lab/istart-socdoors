#!/bin/bash

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# compile cope and zstat images for doors and social to one directory
for sub in `cat ${scriptdir}/newsubs.txt`; do
	for task in doors socialdoors; do
		for img in cope zstat; do
			for n in 1 2 3 4; do
				cp ${maindir}/derivatives/fsl/sub-${sub}/L1_task-${task}_model-1_type-act_run-1_sm-6.feat/stats/${img}${n}.nii.gz ${maindir}/derivatives/fsl/for_Camille/sub-${sub}_task-${task}_${img}${n}.nii.gz
			done
		done
	done
done  