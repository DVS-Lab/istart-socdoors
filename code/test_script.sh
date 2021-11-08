#!/usr/bin/env bash

# This script will perform Level 1 statistics in FSL.
# Rather than having multiple scripts, we are merging three analyses
# into this one script:
#		1) activation
#		2) seed-based ppi
#		3) network-based ppi
# Note that activation analysis must be performed first.
# Seed-based PPI and Network PPI should follow activation analyses.

# ensure paths are correct irrespective from where user runs the script
scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
maindir="$(dirname "$scriptdir")"

# study-specific inputs
TASK=doors
sm=6
sub=$1
run=$2
ppi=$3 # 0 for activation, otherwise seed region or network


# set inputs and general outputs (should not need to chage across studies in Smith Lab)
MAINOUTPUT=${maindir}/derivatives/fsl/sub-${sub}
mkdir -p $MAINOUTPUT
DATA=${maindir}/derivatives/fmriprep/sub-${sub}/func/sub-${sub}_task-${TASK}_run-${run}_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz
NVOLUMES=`fslnvols $DATA`
CONFOUNDEVS=${maindir}/derivatives/fsl/confounds/sub-${sub}/sub-${sub}_task-${TASK}_run-${run}_desc-fslConfounds.tsv
if [ ! -e $CONFOUNDEVS ]; then
	echo "missing confounds: $CONFOUNDEVS " >> ${maindir}/re-runL1.log
	exit # exiting to ensure nothing gets run without confounds
fi
EVDIR=${maindir}/derivatives/fsl/EVfiles/sub-${sub}/${TASK}/run-0${run} #change to maindir TO FIX: no zero pad

OUTPUT=${MAINOUTPUT}/L1_task-${TASK}_model-0_type-nppi-${ppi}_run-${run}_sm-${sm}

x=1
if [x=1]; then
	echo "MAINDIR: $maindir"
	echo "MAINOUTPUT: $MAINOUTPUT"
	echo "DATA: $DATA"
	echo "CONFOUNDEVS: $CONFOUNDEVS"
	echo "EVDIR: $EVDIR"
	echo "OUTPUT: $OUTPUT"
	exit
fi

