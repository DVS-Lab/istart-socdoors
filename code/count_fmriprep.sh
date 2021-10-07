#!/usr/bin/env bash

# This script will count up your fmriprep output for this collection of tasks.
# Check the numbers to make sure everything matches your expectations.
# Are you missing data? Do you have unexpected output, like a run-3?

# usage: bash count_fmriprep.sh


for task in mid sharedreward ugdg socialdoors doors; do
	for run in 1 2 3 4; do # note: run-3 shouldn't exist, but I saw it for an mid run and now we check exhaustively
		count=`ls -1 /data/projects/istart-data/derivatives/fmriprep/sub-*/func/sub-*_task-${task}_run-${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz 2>/dev/null | wc -l` || count=0
		if [ $count -gt 0 ]; then
			echo "task-${task}_run-${run}: ${count}"
		fi
	done
done
